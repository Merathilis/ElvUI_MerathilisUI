local MER, E, L, V, P, G = unpack(select(2, ...))
local MERC = MER:GetModule("muiChat")

--Cache global variables
--Lua Variables
local _G = _G
local select, tonumber = select, tonumber
local gsub, find, match = gsub, string.find, string.match
--WoW API / Variables
local CreateFrame = CreateFrame
local GetItemInfo = GetItemInfo
local GetAchievementInfo = GetAchievementInfo
local GetSpellInfo = GetSpellInfo
local GetCursorPosition = GetCursorPosition
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local strsplit = strsplit
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: SetItemRef

local tooltip = CreateFrame("GameTooltip", "ChatLinkLevelTooltip", E.UIParent, "GameTooltipTemplate")
local ItemLevelPattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")
local ARMOR = ARMOR or "Armor"
local WEAPON = WEAPON or "Weapon"
local RELICSLOT = RELICSLOT or "Relic"

local function GetItemLevelAndTexture(ItemLink)
	local _, _, _, _, _, class, subclass, _, equipSlot, texture = GetItemInfo(ItemLink)
	if (not texture) then return end
	local text, level, slotText
	tooltip:SetOwner(E.UIParent, "ANCHOR_NONE")
	tooltip:ClearLines()
	tooltip:SetHyperlink(ItemLink)
	for i = 2, 4 do
		text = _G[tooltip:GetName().."TextLeft"..i]:GetText() or ""
		level = match(text, ItemLevelPattern)
		if (level) then break end
	end
	if (equipSlot and find(equipSlot, "INVTYPE_")) then
		slotText = _G[equipSlot]
	elseif (class == ARMOR) then
		slotText = class
	elseif (subclass and find(subclass, RELICSLOT)) then
		slotText = RELICSLOT
	end
	return level, texture, slotText
end

local function SetChatLinkLevel(Hyperlink)
	local link = match(Hyperlink, "|H(.-)|h")
	local level, _, slotText = GetItemLevelAndTexture(link)
	if (level and slotText) then
		Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h("..slotText..")["..level..":%1]|h")
	elseif (level) then
		Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h["..level..":%1]|h")
	end
	return Hyperlink
end

local function filter(self, event, msg, ...)
	msg = msg:gsub("(|Hitem:%d+:.-|h.-|h)", SetChatLinkLevel)
	return false, msg, ...
end

function MERC:ItemLevelLink()
	if E.db.mui.chat.iLevelLink ~= true then return end

	local _SetItemRef = SetItemRef
	SetItemRef = function(link, text, button, chatFrame)
		if (link:sub(1,12) == "ChatLinkIcon") then
			return
		end
		_SetItemRef(link, text, button, chatFrame)
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", filter)
end