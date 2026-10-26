local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Chat")

local _G = _G
local gmatch, gsub, ipairs, strfind, strlower, strmatch, strsub, wipe =
	gmatch, gsub, ipairs, strfind, strlower, strmatch, strsub, wipe
local tconcat = table.concat

local Ambiguate = Ambiguate
local EventRegistry = EventRegistry
local hooksecurefunc = hooksecurefunc
local InviteUnit = C_PartyInfo and C_PartyInfo.InviteUnit
local IsAltKeyDown = IsAltKeyDown
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid

-- Blizzard's "addon" link type, a click on it fires the SetItemRef event
local LINK_PREFIX = "addon:MerathilisUI:invite:"

-- Where people ask for an invite. Party, raid and instance chat are left out,
-- whoever writes there is in the group already.
local CHAT_EVENTS = {
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_SAY",
	"CHAT_MSG_YELL",
	"CHAT_MSG_CHANNEL",
}

local keywords = {}
local filtersAdded = false

local function GetDB()
	return module.chatDB and module.chatDB.invite
end

local function AddFilter(event, filter)
	local util = _G.ChatFrameUtil
	local add = util and util.AddMessageEventFilter or _G.ChatFrame_AddMessageEventFilter
	add(event, filter)
end

local function RemoveFilter(event, filter)
	local util = _G.ChatFrameUtil
	local remove = util and util.RemoveMessageEventFilter or _G.ChatFrame_RemoveMessageEventFilter
	remove(event, filter)
end

local function IsInGroupWith(name)
	return UnitInParty(name) or UnitInRaid(name)
end

-------------------------------------------------------------------------------
-- Keywords as invite links
-------------------------------------------------------------------------------
local linkAuthor
local function LinkKeyword(word)
	if keywords[strlower(word)] then
		return E.media.hexvaluecolor .. "|H" .. LINK_PREFIX .. linkAuthor .. "|h[" .. word .. "]|h|r"
	end
end

-- Only the text between links is touched, item names and the like stay as they are
local parts = {}
local function LinkKeywords(message, author)
	wipe(parts)
	linkAuthor = author

	local found, pos = 0, 1
	while true do
		local first, last = strfind(message, "|H.-|h.-|h", pos)
		local text, count = gsub(strsub(message, pos, first and first - 1 or nil), "%w+", LinkKeyword)
		parts[#parts + 1] = text
		found = found + count
		if not first then
			break
		end
		parts[#parts + 1] = strsub(message, first, last)
		pos = last + 1
	end

	return found > 0 and tconcat(parts) or nil
end

local function InviteFilter(_, _, message, author, ...)
	-- Chat in instances can come in as secret values, those stay untouched
	if E:IsSecretValue(message) or E:IsSecretValue(author) or not message or not author or author == "" then
		return false
	end

	local name = Ambiguate(author, "none")
	if name == E.myname or IsInGroupWith(name) then
		return false
	end

	local linked = LinkKeywords(message, author)
	if linked then
		return false, linked, author, ...
	end

	return false
end

local function OnSetItemRef(_, link)
	if E:IsSecretValue(link) or strsub(link, 1, #LINK_PREFIX) ~= LINK_PREFIX then
		return
	end

	local name = strsub(link, #LINK_PREFIX + 1)
	if name ~= "" then
		InviteUnit(name)
	end
end

-------------------------------------------------------------------------------
-- Alt-click on a name
-------------------------------------------------------------------------------
-- A plain click on a name opens a whisper. The invite goes out before that,
-- the whisper Blizzard opens right after it is closed again.
local closeWhisper = false

local function OnHyperlinkClick(_, _, link, _, button)
	local db = GetDB()
	if not (db and db.enable and db.altClick) or button ~= "LeftButton" or not IsAltKeyDown() then
		return
	end

	if E:IsSecretValue(link) then
		return
	end

	local name = strmatch(link, "^player:([^:]+)")
	if name and name ~= "" and Ambiguate(name, "none") ~= E.myname then
		InviteUnit(name)
		closeWhisper = true
	end
end

local function PostSetItemRef()
	if not closeWhisper then
		return
	end
	closeWhisper = false

	local util = _G.ChatFrameUtil
	local editBox = util and util.GetActiveWindow and util.GetActiveWindow()
	if editBox and editBox.ClearChat and editBox:GetChatType() == "WHISPER" then
		editBox:ClearChat()
	end
end

-------------------------------------------------------------------------------
-- API
-------------------------------------------------------------------------------
function module:UpdateInvite()
	local db = GetDB()
	local enabled = db and db.enable and self.inviteReady

	wipe(keywords)
	if enabled then
		for keyword in gmatch(gsub(db.keywords or "", ",%s+", ","), "[^,]+") do
			keyword = strlower(strmatch(keyword, "^%s*(.-)%s*$"))
			if keyword ~= "" then
				keywords[keyword] = true
			end
		end
	end

	local wanted = enabled and next(keywords) ~= nil
	if wanted ~= filtersAdded then
		for _, event in ipairs(CHAT_EVENTS) do
			if wanted then
				AddFilter(event, InviteFilter)
			else
				RemoveFilter(event, InviteFilter)
			end
		end
		filtersAdded = wanted
	end
end

function module:InitializeInvite()
	-- The link and click events exist on Retail only
	if not (InviteUnit and EventRegistry and _G.LinkTypes and _G.LinkTypes.AddOn) then
		return
	end

	EventRegistry:RegisterCallback("SetItemRef", OnSetItemRef, self)
	EventRegistry:RegisterCallback("ChatFrame.OnHyperlinkClick", OnHyperlinkClick, self)
	hooksecurefunc("SetItemRef", PostSetItemRef)
	self.inviteReady = true
end
