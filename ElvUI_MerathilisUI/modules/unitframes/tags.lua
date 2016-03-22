local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')
local ElvUF = ElvUI.oUF

-- Cache global variables
-- WoW API / Variables
local UnitIsDead, UnitIsGhost, UnitIsConnected = UnitIsDead, UnitIsGhost, UnitIsConnected
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local DEAD = DEAD

ElvUF.Tags.Events['health:percent_short'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods['health:percent_short'] = function(unit)
	local status = UnitIsDead(unit) and DEAD or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

	if (status) then
		return status
	else
		return MER:GetFormattedText('PERCENT_SHORT', UnitHealth(unit), UnitHealthMax(unit))
	end
end
