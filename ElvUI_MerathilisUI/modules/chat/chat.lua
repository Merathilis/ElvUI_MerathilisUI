local MER, E, L, V, P, G = unpack(select(2, ...))
local MERC = E:NewModule("muiChat", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local CH = E:GetModule("Chat")
MERC.modName = L["Chat"]

-- Cache global variables
-- Lua functions
local _G = _G
local find, gsub = string.find, string.gsub
-- WoW API / Variable
local GetRealmName = GetRealmName

-- GLOBALS:

local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

function MERC:RemoveCurrentRealmName(msg, author, ...)
	local realmName = gsub(GetRealmName(), " ", "")

	if msg and msg:find("-" .. realmName) then
		return false, gsub(msg, "%-"..realmName, ""), author, ...
	end
end

function MERC:Initialize()
	if E.private.chat.enable ~= true then return; end

	_G["ERR_FRIEND_ONLINE_SS"] = "|Hplayer:%s|h[%s]|h "..L["has come |cff298F00online|r."]
	_G["ERR_FRIEND_OFFLINE_S"] = "[%s] "..L["has gone |cffff0000offline|r."]
	_G["GUILD_MOTD_TEMPLATE"] = "|cff00c0faGMOTD|r: %s"

	-- Style the chat
	_G["LeftChatPanel"].backdrop:Styling()
	_G["RightChatPanel"].backdrop:Styling()

	-- Remove the Realm Name from system messages
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", MERC.RemoveCurrentRealmName)

	self:EasyChannel()
end

local function InitializeCallback()
	MERC:Initialize()
end

E:RegisterModule(MERC:GetName(), InitializeCallback)