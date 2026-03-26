local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Theme") ---@class Theme

local ALTERNATE_POWER_INDEX = _G.Enum.PowerType.Alternate or 10
local select = select
local UnitPowerType = UnitPowerType

function module:GetPowerColor(frame, unit)
	if frame.displayType == ALTERNATE_POWER_INDEX then
		return "powerColorMap", "ALT_POWER"
	end
	local powerKey = select(2, UnitPowerType(unit))
	return "powerColorMap", powerKey
end

function module:PostUpdatePowerColor(frame, unit, eR, eG, eB)
	if not self.isEnabled or not self.db or not self.db.enable then
		return
	end
	if not unit then
		return
	end

	-- Power values are secret in Midnight, use fixed percentage
	local valueChanged = frame.currentPercent == nil
	if valueChanged then
		frame.currentPercent = 1
	end

	if not frame._gradColorFunc then
		frame._gradColorFunc = F.Event.GenerateClosure(self.GetPowerColor, self, frame, unit)
	end
	self:SetGradientColors(frame, valueChanged, eR, eG, eB, false, frame._gradColorFunc)
end
