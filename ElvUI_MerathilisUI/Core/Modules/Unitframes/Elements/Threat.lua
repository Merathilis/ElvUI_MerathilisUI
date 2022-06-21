local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local S = MER:GetModule('MER_Skins')
local UF = E:GetModule('UnitFrames')

function module:UnitFrames_Configure_Threat(_, f)
	if f.shadow then return end

	local threat = f.ThreatIndicator
	if not threat then return end

	threat.PostUpdate = function(self, unit, status, r, g, b)
		UF.UpdateThreat(self, unit, status, r, g, b)
		local parent = self:GetParent()
		if not unit or parent.unit ~= unit then
			return
		end
		if parent.db and parent.db.threatStyle == "GLOW" then
			if parent.Health and parent.Health.backdrop and parent.Health.backdrop.shadow then
				parent.Health.backdrop.shadow:SetShown(not threat.MainGlow:IsShown())
			end
			if parent.Power and parent.Power.backdrop and parent.Power.backdrop.shadow and parent.USE_POWERBAR_OFFSET then
				parent.Power.backdrop.shadow:SetShown(not threat.MainGlow:IsShown())
			end
		end
	end
end