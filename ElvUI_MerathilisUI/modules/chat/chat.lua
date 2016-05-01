local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI')
local MERC = E:NewModule('muiChat', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local CH = E:GetModule('Chat')

-- Cache global variables
-- Lua functions
local _G = _G
local gsub, split, strlen = string.gsub, string.split, string.len
-- WoW API / Variables
local GetRealmName = GetRealmName
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

local specialChatIcons
local lfgChannels = {
	"PARTY_LEADER",
	"PARTY",
	"RAID",
	"RAID_LEADER",
	"INSTANCE_CHAT",
	"INSTANCE_CHAT_LEADER",
	"RAID_WARNING",
}
MERC.lfgRolesTable = {}
MERC.PlayerRealm = gsub(E.myrealm,'[%s%-]','')

function MERC:RemoveCurrentRealmName(self, msg, author, ...)
	local realmName = gsub(GetRealmName(), " ", "")
	
	if msg and msg:find("-" .. realmName) then
		return false, gsub(msg, "%-"..realmName, ""), author, ...
	end
end

function MERC:GetChatIcon(sender)
	if not specialChatIcons then 
		MER:GetRegion()
		specialChatIcons = MER.SpecialChatIcons[MER.region]
	end
	local senderName, senderRealm
	if sender then
		senderName, senderRealm = split('-', sender)
	else
		senderName = E.myname
	end
	senderRealm = senderRealm or MERC.PlayerRealm
	senderRealm = gsub(senderRealm, ' ', '')

	if specialChatIcons[senderRealm] and specialChatIcons[senderRealm][senderName] then
		return specialChatIcons[senderRealm][senderName]
	end
end

function CH:GetPluginReplacementIcon(arg2, arg6, type)
	local icon = ""
	if arg6 and (strlen(arg6) > 0) then
		if ( arg6 == "GM" ) then
			--If it was a whisper, dispatch it to the GMChat addon.
			if ( type == "WHISPER" ) then
				return;
			end
			--Add Blizzard Icon, this was sent by a GM
			icon = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
		elseif ( arg6 == "DEV" ) then
			--Add Blizzard Icon, this was sent by a Dev
			icon = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
		elseif ( arg6 == "DND" or arg6 == "AFK") then
			icon = MERC:GetChatIcon(arg2).._G["CHAT_FLAG_"..arg6]
		else
			icon = _G["CHAT_FLAG_"..arg6];
		end
	else
		icon = MERC:GetChatIcon(arg2)
		if(MERC.lfgRolesTable[arg2] and MER:SimpleTable(lfgChannels, type)) then
			icon = MERC.lfgRolesTable[arg2]..icon
		end
	end
	if icon == "" then icon = nil end
	return icon, true
end

_G.ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h "..L["has come |cff298F00online|r."]
_G.ERR_FRIEND_OFFLINE_S = "[%s] "..L["has gone |cffff0000offline|r."]

function MERC:LoadChat()
	if E.private.chat.enable ~= true then return; end
	
	-- Remove the Realm Name from system messages
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", MERC.RemoveCurrentRealmName)
end
hooksecurefunc(CH, "Initialize", MERC.LoadChat)

E:RegisterModule(MERC:GetName())
