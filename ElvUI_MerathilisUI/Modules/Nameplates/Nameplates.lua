local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")

-- The settings are read on every configure, the plates that exist just need a refresh
function module:ProfileUpdate()
	module:UpdateFactionIndicators()
	module:UpdateTargetArrows()
	module:UpdateTargetEmphasis()
	module:UpdateHighlights()
	module:UpdateFocusHighlights()
	module:UpdateMarkerColors()
	module:UpdateEnemyForces()
	module:UpdateInterruptReady()
	module:UpdateCastbarShield()
	module:UpdateCastTargets()
	module:UpdateExecuteLines()
	module:UpdateNeutralNameOnly()
end

function module:Initialize()
	if not E.private.nameplates.enable then
		return
	end

	module:FactionIndicator()
	module:TargetArrows()
	module:TargetEmphasis()
	module:Highlight()
	module:FocusHighlight()
	module:MarkerColor()
	module:EnemyForces()
	module:InterruptReady()
	module:CastbarShield()
	module:CastTarget()
	module:ExecuteLine()
	module:NeutralNameOnly()
end

MER:RegisterModule(module:GetName())
