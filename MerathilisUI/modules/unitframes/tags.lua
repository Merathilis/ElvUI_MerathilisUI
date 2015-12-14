local E, L, V, P, G = unpack(ElvUI)
local ElvUF = ElvUI.oUF

ElvUF.Tags.Events['health:percent_short'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods['health:percent_short'] = function(unit)
	local status = UnitIsDead(unit) and DEAD or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

	if (status) then
		return status
	else
		return E:GetFormattedText('PERCENT_SHORT', UnitHealth(unit), UnitHealthMax(unit))
	end
end
