local MER, E, L, V, P, G = unpack(select(2, ...))
local MERC = E:NewModule("muiChat")
local CH = E:GetModule("Chat")
MERC.modName = L["Chat"]

-- Cache global variables
-- Lua functions
local _G = _G
local gsub = string.gsub
-- WoW API / Variable
local GetRealmName = GetRealmName

local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

_G["ERR_FRIEND_ONLINE_SS"] = "|Hplayer:%s|h[%s]|h "..L["has come |cff298F00online|r."]
_G["ERR_FRIEND_OFFLINE_S"] = "[%s] "..L["has gone |cffff0000offline|r."]

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

	if not chat.styled then
		E:GetModule("muiSkins"):CreateStripes(_G["LeftChatPanel"])
		if _G["LeftChatPanel"].stripes then
			_G["LeftChatPanel"].stripes:SetInside(_G["LeftChatPanel"])
		end

		E:GetModule("muiSkins"):CreateStripes(_G["RightChatPanel"])
		if _G["RightChatPanel"].stripes then
			_G["RightChatPanel"].stripes:SetInside(_G["RightChatPanel"])
		end
		chat.styled = true
	end
end
hooksecurefunc(CH, "Initialize", MERC.LoadChat)

local function InitializeCallback()
	MERC:LoadChat()
end

E:RegisterModule(MERC:GetName(), InitializeCallback)
