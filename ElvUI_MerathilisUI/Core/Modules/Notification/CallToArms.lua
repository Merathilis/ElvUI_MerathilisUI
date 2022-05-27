local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Notification

local _G = _G
local GetTime = GetTime

local C_LFGList_GetAvailableRoles = C_LFGList.GetAvailableRoles
local IsInGroup = IsInGroup
local TANK, HEALER, DAMAGER = TANK, HEALER, DAMAGER

local LFG_Timer = 0
function module:LFG_UPDATE_RANDOM_INFO()
	if not module.db.enable or not module.db.callToArms then return end

	local _, forTank, forHealer, forDamage = GetLFGRoleShortageRewards(2087, _G.LFG_ROLE_SHORTAGE_RARE) -- 2087 Random Shadowlands Heroic
	local IsTank, IsHealer, IsDamage = C_LFGList_GetAvailableRoles()

	local ingroup, tank, healer, damager, result

	tank = IsTank and forTank and "|cff00B2EE"..TANK.."|r" or ""
	healer = IsHealer and forHealer and "|cff00EE00"..HEALER.."|r" or ""
	damager = IsDamage and forDamage and "|cffd62c35"..DAMAGER.."|r" or ""

	if IsInGroup(_G.LE_PARTY_CATEGORY) or IsInGroup(_G.LE_PARTY_CATEGORY_INSTANCE) then
		ingroup = true
	end

	if ((IsTank and forTank) or (IsHealer and forHealer) or (IsDamage and forDamage)) and not ingroup then
		if GetTime() - LFG_Timer > 50 then
			self:DisplayToast(format(_G.LFG_CALL_TO_ARMS, tank.." "..healer.." "..damager), nil, nil, "Interface\\Icons\\Ability_DualWield", .08, .92, .08, .92)
			LFG_Timer = GetTime()
		end
	end
end