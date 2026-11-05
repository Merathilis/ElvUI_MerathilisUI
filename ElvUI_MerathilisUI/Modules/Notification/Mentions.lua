local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")

local _G = _G
local format, gsub, gmatch, strfind, strlower, strsub = format, gsub, gmatch, strfind, strlower, strsub
local pairs, wipe = pairs, wipe

local Ambiguate = Ambiguate
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown

-- Chat events per channel setting, every one of them needs the setting turned on
local EVENT_SETTINGS = {
	CHAT_MSG_GUILD = "guild",
	CHAT_MSG_OFFICER = "officer",
	CHAT_MSG_PARTY = "party",
	CHAT_MSG_PARTY_LEADER = "party",
	CHAT_MSG_RAID = "raid",
	CHAT_MSG_RAID_LEADER = "raid",
	CHAT_MSG_RAID_WARNING = "raid",
	CHAT_MSG_INSTANCE_CHAT = "instance",
	CHAT_MSG_INSTANCE_CHAT_LEADER = "instance",
	CHAT_MSG_SAY = "say",
	CHAT_MSG_YELL = "say",
	CHAT_MSG_CHANNEL = "channel",
	CHAT_MSG_WHISPER = "whisper",
}

-- Shown next to the sender and used as slash prefix to answer on a click
local EVENT_CHANNELS = {
	CHAT_MSG_GUILD = { _G.CHAT_MSG_GUILD, "/g " },
	CHAT_MSG_OFFICER = { _G.CHAT_MSG_OFFICER, "/o " },
	CHAT_MSG_PARTY = { _G.CHAT_MSG_PARTY, "/p " },
	CHAT_MSG_PARTY_LEADER = { _G.CHAT_MSG_PARTY, "/p " },
	CHAT_MSG_RAID = { _G.CHAT_MSG_RAID, "/ra " },
	CHAT_MSG_RAID_LEADER = { _G.CHAT_MSG_RAID, "/ra " },
	CHAT_MSG_RAID_WARNING = { _G.CHAT_MSG_RAID_WARNING, "/ra " },
	CHAT_MSG_INSTANCE_CHAT = { _G.INSTANCE_CHAT, "/i " },
	CHAT_MSG_INSTANCE_CHAT_LEADER = { _G.INSTANCE_CHAT, "/i " },
	CHAT_MSG_SAY = { _G.CHAT_MSG_SAY, "/s " },
	CHAT_MSG_YELL = { _G.CHAT_MSG_YELL, "/y " },
	CHAT_MSG_WHISPER = { _G.WHISPER },
}

-- One toast per sender in this window, a chatty group would fill the queue otherwise
local SENDER_THROTTLE = 10

local keywords = {}
local lastToastBySender = {}

local function OpenChat(text)
	local util = _G.ChatFrameUtil
	local open = util and util.OpenChat or _G.ChatFrame_OpenChat
	if open then
		open(text)
	end
end

local function SendTell(name)
	local util = _G.ChatFrameUtil
	local send = util and util.SendTell or _G.ChatFrame_SendTell
	if send then
		send(name)
	end
end

-- Same syntax as ElvUI's keyword list: comma separated, %MYNAME% is the character name
function module:UpdateMentionKeywords()
	wipe(keywords)

	local list = gsub(E.db.mui.notification.mentions.keywords or "", ",%s+", ",")
	for keyword in gmatch(list, "[^,]+") do
		keyword = gsub(keyword, "^%s+", "")
		keyword = gsub(keyword, "%s+$", "")
		if keyword ~= "" then
			keywords[#keywords + 1] = strlower(keyword == "%MYNAME%" and E.myname or keyword)
		end
	end
end

local function IsWordChar(char)
	return char ~= "" and strfind(char, "[%w_]") ~= nil
end

-- Whole words only, so "mera" does not fire on "camera"
local function ContainsKeyword(text)
	for i = 1, #keywords do
		local keyword = keywords[i]
		local init = 1
		while true do
			local first, last = strfind(text, keyword, init, true)
			if not first then
				break
			end

			if
				not IsWordChar(strsub(text, first - 1, first - 1)) and not IsWordChar(strsub(text, last + 1, last + 1))
			then
				return true
			end

			init = last + 1
		end
	end

	return false
end

local function GetSenderIcon(guid)
	if not guid or E:IsSecretValue(guid) then
		return
	end

	local _, class = GetPlayerInfoByGUID(guid)
	if class and not E:IsSecretValue(class) then
		return "classicon-" .. strlower(class), class
	end
end

function module:OnMentionEvent(event, message, author, _, _, _, _, _, channelIndex, channelBaseName, _, _, guid)
	-- Chat in instances can come in as secret values, those cannot be read
	if E:IsSecretValue(message) or E:IsSecretValue(author) or not message or not author then
		return
	end

	local db = E.db.mui.notification
	local mentions = db.mentions
	if not db.enable or not mentions.enable or not mentions[EVENT_SETTINGS[event]] then
		return
	end

	if mentions.hideInCombat and InCombatLockdown() then
		return
	end

	if guid and E:NotSecretValue(guid) and guid == E.myguid then
		return
	end

	-- Every whisper counts, everything else only with a keyword outside of links
	if event ~= "CHAT_MSG_WHISPER" then
		local plain = gsub(message, "|H.-|h.-|h", "")
		plain = strlower(E:StripString(plain))
		if not ContainsKeyword(plain) then
			return
		end
	end

	local now = GetTime()
	if lastToastBySender[author] and now - lastToastBySender[author] < SENDER_THROTTLE then
		return
	end
	lastToastBySender[author] = now

	local channelName, slash
	local channel = EVENT_CHANNELS[event]
	if channel then
		channelName, slash = channel[1], channel[2]
	elseif E:NotSecretValue(channelIndex) and channelIndex and channelIndex > 0 then
		channelName = E:NotSecretValue(channelBaseName) and channelBaseName ~= "" and channelBaseName or nil
		slash = format("/%d ", channelIndex)
	end

	local shortName = Ambiguate(author, "short")
	local icon, class = GetSenderIcon(guid)
	local classColor = class and E:ClassColor(class)
	local coloredName = classColor and classColor:WrapTextInColorCode(shortName) or shortName

	local title = coloredName
	if channelName then
		title = format("%s |cff9e9e9e- %s|r", coloredName, channelName)
	end

	local onClick
	if event == "CHAT_MSG_WHISPER" then
		onClick = function()
			SendTell(author)
		end
	elseif slash then
		onClick = function()
			OpenChat(slash)
		end
	end

	self:DisplayToast(title, message, onClick, icon or "Interface\\Icons\\INV_Misc_Note_01")
end

-- Called from UpdateEvents, each chat event only while its channel is turned on
function module:UpdateMentions()
	local db = E.db.mui.notification
	local mentions = db.mentions
	local active = db.enable and mentions.enable

	if active then
		self:UpdateMentionKeywords()
	end

	for event, setting in pairs(EVENT_SETTINGS) do
		if active and mentions[setting] then
			self:RegisterEvent(event, "OnMentionEvent")
		else
			self:UnregisterEvent(event)
		end
	end
end
