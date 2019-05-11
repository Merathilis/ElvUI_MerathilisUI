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
local PlaySoundFile = PlaySoundFile
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
	local eligible, forTank, forHealer, forDamage = GetLFGRoleShortageRewards(1671, _G.LFG_ROLE_SHORTAGE_RARE) -- 1671	Random Battle For Azeroth Heroic
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
			PlaySoundFile("Sound\\Interface\\RaidWarning.ogg")
			RaidNotice_AddMessage(_G.RaidWarningFrame, format(_G.LFG_CALL_TO_ARMS, tank.." "..healer.." "..damager), ChatTypeInfo["RAID_WARNING"])
			MER:Print(format(_G.LFG_CALL_TO_ARMS, tank.." "..healer.." "..damager))
			LFG_Timer = GetTime()
		end
	end
end

--[[-----------------------------------------------------------------------------
Versions Check
-------------------------------------------------------------------------------]]
local function msgChannel()
	return IsPartyLFG() and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY"
end

function module:VersionCheck()
	if not E.db.mui.misc.alerts.versionCheck then return end

	local f = CreateFrame("Frame", nil, nil, "MicroButtonAlertTemplate")
	f:SetPoint("BOTTOMLEFT", _G.ChatFrame1, "TOPLEFT", 20, 70)
	f.Text:SetText("")
	f:Hide()

	local DetectVersion = E.db.mui.misc.alerts.detectVersion

	local function CompareVersion(new, old)
		local new1, new2 = strsplit(".", new)
		new1, new2 = tonumber(new1), tonumber(new2)
		local old1, old2 = strsplit(".", old)
		old1, old2 = tonumber(old1), tonumber(old2)
		if new1 > old1 or new2 > old2 then
			return "IsNew"
		elseif new1 < old1 or new2 < old2 then
			return "IsOld"
		end
	end

	local checked
	local function UpdateVersionCheck(_, ...)
		local prefix, msg, distType, author = ...
		if prefix ~= "MERVersionCheck" then return end
		if Ambiguate(author, "none") == E.myname then return end

		local status = CompareVersion(msg, DetectVersion)
		if status == "IsNew" then
			E.db.mui.general.detectVersion = msg
		elseif status == "IsOld" then
			C_ChatInfo_SendAddonMessage("MERVersionCheck", DetectVersion, distType)
		end

		if not checked then
			if CompareVersion(DetectVersion, MER.Version) == "IsNew" then
				local release = gsub(DetectVersion, "(%d)$", "0")
				f.Text:SetText(format(L["Outdated MER"], release))
				f:Show()
			end
			checked = true
		end
	end

	MER:RegisterEvent("CHAT_MSG_ADDON", UpdateVersionCheck)
	C_ChatInfo_RegisterAddonMessagePrefix("MERVersionCheck")

	if IsInGuild() then
		C_ChatInfo_SendAddonMessage("MERVersionCheck", MER.Version, "GUILD")
	end

	local prevTime = 0
	local function SendGroupCheck()
		if not IsInGroup() or (GetTime()-prevTime < 30) then return end
		prevTime = GetTime()
		C_ChatInfo_SendAddonMessage("MERVersionCheck", MER.Version, msgChannel())
	end
	SendGroupCheck()
	MER:RegisterEvent("GROUP_ROSTER_UPDATE", SendGroupCheck)
end

function module:AddAlerts()
	if E.db.mui.misc.alerts.lfg then
		eventframe:RegisterEvent('LFG_UPDATE_RANDOM_INFO')
	end

	self:VersionCheck()
end
