local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')
local ElvUF = ElvUI.oUF

-- Cache global variables
-- WoW API / Variables
local DEAD = DEAD
local GetNumGroupMembers = GetNumGroupMembers
local IsInGroup, IsInRaid = IsInGroup, IsInRaid
local UnitIsDead, UnitIsGhost, UnitIsConnected, UnitIsUnit = UnitIsDead, UnitIsGhost, UnitIsConnected, UnitIsUnit
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax

ElvUF.Tags.Events['health:percent_short'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods['health:percent_short'] = function(unit)
	local status = UnitIsDead(unit) and DEAD or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

	if (status) then
		return status
	else
		return MER:GetFormattedText('PERCENT_SHORT', UnitHealth(unit), UnitHealthMax(unit))
	end
end

ElvUF.Tags.Events['num:targeting'] = "UNIT_TARGET PLAYER_TARGET_CHANGED GROUP_ROSTER_UPDATE"
ElvUF.Tags.Methods['num:targeting'] = function(unit)
	if not IsInGroup() then return "" end

	local targetedByNum = 0
	for i = 1, GetNumGroupMembers() do
		local groupUnit = (IsInRaid() and "raid"..i or "party"..i);
		if (UnitIsUnit(groupUnit.."target", unit) and not UnitIsUnit(groupUnit, "player")) or UnitIsUnit("playertarget", unit) then
			targetedByNum = targetedByNum + 1
		end
	end

	return (targetedByNum > 0 and targetedByNum or "")
end
