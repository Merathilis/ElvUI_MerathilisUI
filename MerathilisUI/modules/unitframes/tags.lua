local E, L, V, P, G = unpack(ElvUI)
local ElvUF = ElvUI.oUF

ElvUF.Tags.Events['health:test'] = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_HEALTH_FREQUENT UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods['health:test'] = function(unit)
	local status = UnitIsDead(unit) and L["DEAD"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
	local name = UnitName(unit)
	if (status) then
		return status
	elseif UnitHealth(unit) == UnitHealthMax(unit) then
		return name ~= nil and E:ShortenString(name, 5) or ''
	else
		return E:GetFormattedText('DEFICIT', UnitHealth(unit), UnitHealthMax(unit))
	end
end
