local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")

local hooksecurefunc = hooksecurefunc

local function HideTag(nameplate, text)
	if text then
		nameplate:Untag(text)
		text:Hide()
	end
end

-- ElvUI disables widgets-only plates (delve companions, objects with a widget bar)
-- without touching the tag texts. Those sit on the nameplate itself, not on the
-- RaisedElement, so they stay visible with the layout of the plate's previous unit.
-- The next regular unit gets a full update (previousType is reset), which tags them again.
local function HideWidgetsOnlyTags(_, nameplate)
	if not nameplate.widgetsOnly then
		return
	end

	HideTag(nameplate, nameplate.Name)
	HideTag(nameplate, nameplate.Title)
	HideTag(nameplate, nameplate.Level)
	HideTag(nameplate, nameplate.Health and nameplate.Health.Text)
	HideTag(nameplate, nameplate.Power and nameplate.Power.Text)
end

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

	hooksecurefunc(NP, "DisablePlate", HideWidgetsOnlyTags)

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
