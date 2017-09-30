local MER, E, L, V, P, G = unpack(select(2, ...))
local MERC = E:NewModule("muiChat")
local CH = E:GetModule("Chat")
MERC.modName = L["Chat"]

-- Cache global variables
-- Lua functions
local _G = _G
local format, gsub = string.format, string.gsub
-- WoW API / Variable
local ChatTypeInfo = ChatTypeInfo
local GetRealmName = GetRealmName
local strsplit = strsplit

-- GLOBALS: ChatFrame_DisplayGMOTD, ChatFrame_DisplayGMOTD, GUILD_MOTD_TEMPLATE

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

	-- Adjust the Guild Message of the Day
	local a, b = strsplit(":", GUILD_MOTD_TEMPLATE)
	if a and b then
			GUILD_MOTD_TEMPLATE = "|cff00c0fa" .. "GMOTD" .. "|r:" .. b
	end

	-- Remove the Realm Name from system messages
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", MERC.RemoveCurrentRealmName)

	E:GetModule("muiSkins"):CreateGradient(_G["LeftChatPanel"].backdrop)
	if not (_G["LeftChatPanel"]).backdrop.stripes then
		E:GetModule("muiSkins"):CreateStripes(_G["LeftChatPanel"].backdrop)
	end

	E:GetModule("muiSkins"):CreateGradient(_G["RightChatPanel"].backdrop)
	if not (_G["RightChatPanel"]).backdrop.stripes then
		E:GetModule("muiSkins"):CreateStripes(_G["RightChatPanel"].backdrop)
	end
end
hooksecurefunc(CH, "Initialize", MERC.Initialize)

local function InitializeCallback()
	MERC:Initialize()
end

E:RegisterModule(MERC:GetName(), InitializeCallback)