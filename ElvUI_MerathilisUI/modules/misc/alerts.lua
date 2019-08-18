local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("mUIMisc")

--Cache global variables
--Lua functions
local _G = _G
local print, tonumber = print, tonumber
local twipe = table.wipe
local format = string.format
local gsub = gsub
local strsplit = strsplit
local Ambiguate = Ambiguate
--WoW API / Variables
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage
local C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix
local C_LFGList_GetAvailableRoles = C_LFGList.GetAvailableRoles
local ChatTypeInfo = ChatTypeInfo
local CreateFrame = CreateFrame
local GetTime = GetTime
local IsInGuild = IsInGuild
local IsInGroup = IsInGroup
local IsPartyLFG = IsPartyLFG
local IsInRaid = IsInRaid
local GetLFGRoleShortageRewards = GetLFGRoleShortageRewards
local PlaySound = PlaySound
local RaidNotice_AddMessage = RaidNotice_AddMessage
-- GLOBALS:

local eventframe = CreateFrame('Frame')
eventframe:SetScript('OnEvent', function(self, event, ...)
	eventframe[event](self, ...)
end)

--[[-----------------------------------------------------------------------------
LFG Call to Arms rewards
-------------------------------------------------------------------------------]]
local LFG_Timer = 0
function eventframe:LFG_UPDATE_RANDOM_INFO()
	local eligible, forTank, forHealer, forDamage = GetLFGRoleShortageRewards(1671, _G.LFG_ROLE_SHORTAGE_RARE) -- 1671 Random Battle For Azeroth Heroic
	local IsTank, IsHealer, IsDamage = C_LFGList_GetAvailableRoles()

	local ingroup, tank, healer, damager, result

	tank = IsTank and forTank and "|cff00B2EE"..TANK.."|r" or ""
	healer = IsHealer and forHealer and "|cff00EE00"..HEALER.."|r" or ""
	damager = IsDamage and forDamage and "|cffd62c35"..DAMAGER.."|r" or ""

	if IsInGroup(_G.LE_PARTY_CATEGORY) or IsInGroup(_G.LE_PARTY_CATEGORY_INSTANCE) then
		ingroup = true
	end

	if ((IsTank and forTank) or (IsHealer and forHealer) or (IsDamage and forDamage)) and not ingroup then
		if GetTime() - LFG_Timer > 20 then
			PlaySound(8959) --Sound\\Interface\\RaidWarning.ogg
			RaidNotice_AddMessage(_G.RaidWarningFrame, format(_G.LFG_CALL_TO_ARMS, tank.." "..healer.." "..damager), ChatTypeInfo["RAID_WARNING"])
			MER:Print(format(_G.LFG_CALL_TO_ARMS, tank.." "..healer.." "..damager))
			LFG_Timer = GetTime()
		end
	end
end

function module:AddAlerts()
	if E.db.mui.misc.alerts.lfg then
		eventframe:RegisterEvent('LFG_UPDATE_RANDOM_INFO')
	end
end
