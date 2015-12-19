local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI')
local MERC = E:NewModule('muiChat')
local CH = E:GetModule('Chat')

-- Cache global variables
local GetRealmName = GetRealmName
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

function MERC:RemoveCurrentRealmName(self, msg, author, ...)
	local realmName = string.gsub(GetRealmName(), " ", "")
	
	if msg and msg:find("-" .. realmName) then
		return false, gsub(msg, "%-"..realmName, ""), author, ...
	end
end

function MERC:InitializeChat()
	-- Remove the Realm Name from system messages
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", MERC.RemoveCurrentRealmName)
end
hooksecurefunc(CH, "Initialize", MERC.InitializeChat)

E:RegisterModule(MERC:GetName())
