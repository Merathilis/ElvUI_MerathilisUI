local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")

local _G = _G
local format = format
local GetTime = GetTime

local GetAvailableRoles = C_LFGList.GetAvailableRoles
local GetLFGRoleShortageRewards = GetLFGRoleShortageRewards
local IsInGroup = IsInGroup
local TANK, HEALER, DAMAGER = TANK, HEALER, DAMAGER

-- Random Heroic dungeon ID (update when Blizzard rotates seasons)
local RANDOM_HEROIC_ID = 2087

local LFG_Timer = 0

function module:LFG_UPDATE_RANDOM_INFO()
	local db = E.db.mui.notification
	if not db or not db.enable or not db.callToArms then
		return
	end

	if IsInGroup(_G.LE_PARTY_CATEGORY) or IsInGroup(_G.LE_PARTY_CATEGORY_INSTANCE) then
		return
	end

	if GetTime() - LFG_Timer <= 50 then
		return
	end

	local _, forTank, forHealer, forDamage = GetLFGRoleShortageRewards(RANDOM_HEROIC_ID, _G.LFG_ROLE_SHORTAGE_RARE)
	local IsTank, IsHealer, IsDamage = GetAvailableRoles()

	if not ((IsTank and forTank) or (IsHealer and forHealer) or (IsDamage and forDamage)) then
		return
	end

	local tank = (IsTank and forTank) and ("|cff00B2EE" .. TANK .. "|r") or ""
	local healer = (IsHealer and forHealer) and ("|cff00EE00" .. HEALER .. "|r") or ""
	local damager = (IsDamage and forDamage) and ("|cffd62c35" .. DAMAGER .. "|r") or ""

	self:DisplayToast(
		format(_G.LFG_CALL_TO_ARMS, tank .. " " .. healer .. " " .. damager),
		nil,
		nil,
		"Interface\\Icons\\Ability_DualWield",
		0.08,
		0.92,
		0.08,
		0.92
	)
	LFG_Timer = GetTime()
end
