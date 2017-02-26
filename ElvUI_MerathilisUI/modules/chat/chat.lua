local E, L, V, P, G = unpack(ElvUI);
local MERC = E:NewModule('muiChat')
local CH = E:GetModule('Chat')

-- Cache global variables
-- Lua functions
local _G = _G
local gsub = string.gsub
-- WoW API / Variable
local GetRealmName = GetRealmName
local IsResting = IsResting
local UnitIsInMyGuild = UnitIsInMyGuild
local UnitName = UnitName
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
-- Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: 

-- Main filters
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function() return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function() return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function() return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", function() return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function() return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_SAY", function() if IsResting() then return true end end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", function() if IsResting() then return true end end)

_G["DRUNK_MESSAGE_ITEM_OTHER1"] = ""
_G["DRUNK_MESSAGE_ITEM_OTHER2"] = ""
_G["DRUNK_MESSAGE_ITEM_OTHER3"] = ""
_G["DRUNK_MESSAGE_ITEM_OTHER4"] = ""
_G["DRUNK_MESSAGE_ITEM_SELF1"] = ""
_G["DRUNK_MESSAGE_ITEM_SELF2"] = ""
_G["DRUNK_MESSAGE_ITEM_SELF3"] = ""
_G["DRUNK_MESSAGE_ITEM_SELF4"] = ""
_G["DRUNK_MESSAGE_OTHER1"] = ""
_G["DRUNK_MESSAGE_OTHER2"] = ""
_G["DRUNK_MESSAGE_OTHER3"] = ""
_G["DRUNK_MESSAGE_OTHER4"] = ""
_G["DRUNK_MESSAGE_SELF1"] = ""
_G["DRUNK_MESSAGE_SELF2"] = ""
_G["DRUNK_MESSAGE_SELF3"] = ""
_G["DRUNK_MESSAGE_SELF4"] = ""
_G["DUEL_WINNER_KNOCKOUT"] = ""
_G["DUEL_WINNER_RETREAT"] = ""
_G["ERR_CHAT_THROTTLED"] = ""
_G["ERR_LEARN_ABILITY_S"] = ""
_G["ERR_LEARN_PASSIVE_S"] = ""
_G["ERR_LEARN_SPELL_S"] = ""
_G["ERR_PET_LEARN_ABILITY_S"] = ""
_G["ERR_PET_LEARN_SPELL_S"] = ""
_G["ERR_PET_SPELL_UNLEARNED_S"] = ""
_G["ERR_SPELL_UNLEARNED_S"] = ""
_G["ERR_FRIEND_ONLINE_SS"] = "|Hplayer:%s|h[%s]|h "..L["has come |cff298F00online|r."]
_G["ERR_FRIEND_OFFLINE_S"] = "[%s] "..L["has gone |cffff0000offline|r."]

-- Repeat filter
local lastMessage
local function RepeatMessageFilter(self, event, text, sender)
	if sender == E.myname or UnitIsInMyGuild(sender) then return end

	if not self.repeatMessages or self.repeatCount > 100 then
		self.repeatCount = 0
		self.repeatMessages = {}
	end

	lastMessage = self.repeatMessages[sender]

	if lastMessage == text then
		return true
	end

	self.repeatMessages[sender] = text
	self.repeatCount = self.repeatCount + 1
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", RepeatMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", RepeatMessageFilter)

function MERC:RemoveCurrentRealmName(msg, author, ...)
	local realmName = gsub(GetRealmName(), " ", "")

	if msg and msg:find("-" .. realmName) then
		return false, gsub(msg, "%-"..realmName, ""), author, ...
	end
end

function MERC:LoadChat()
	if E.private.chat.enable ~= true then return; end

	-- Remove the Realm Name from system messages
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", MERC.RemoveCurrentRealmName)
end
hooksecurefunc(CH, "Initialize", MERC.LoadChat)

E:RegisterModule(MERC:GetName())
