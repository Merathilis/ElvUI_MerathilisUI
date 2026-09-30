local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")

-- The settings are read on every configure, the plates that exist just need a refresh
function module:ProfileUpdate()
	module:UpdateFactionIndicators()
	module:UpdateTargetArrows()
	module:UpdateHighlights()
	module:UpdateInterruptReady()
	module:UpdateCastTargets()
	module:UpdateExecuteLines()
end

function module:Initialize()
	if not E.private.nameplates.enable then
		return
	end

	module:FactionIndicator()
	module:TargetArrows()
	module:Highlight()
	module:InterruptReady()
	module:CastTarget()
	module:ExecuteLine()
end

MER:RegisterModule(module:GetName())
