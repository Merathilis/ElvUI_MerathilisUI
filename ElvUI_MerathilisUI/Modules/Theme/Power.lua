local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Theme") ---@class Theme

local ALTERNATE_POWER_INDEX = _G.Enum.PowerType.Alternate or 10
local select = select
local UnitPowerType = UnitPowerType

function module:GetPowerColor(frame, unit)
	if frame.displayType == ALTERNATE_POWER_INDEX then
		return "powerColorMap", "ALT_POWER"
	end
	return "powerColorMap", select(2, UnitPowerType(unit))
end

function module:PostUpdatePowerColor(frame, unit, color, altR, altG, altB)
	if not self.isEnabled or not self.db or not self.db.enable then
		return
	end
	if not unit then
		return
	end

	-- oUF sends (unit, color, altR, altG, altB); color is nil on alternative powers
	local eR, eG, eB = altR, altG, altB
	if color then
		eR, eG, eB = color, nil, nil
	end

	-- Power values are secret in Midnight, use fixed percentage
	local valueChanged = frame.currentPercent == nil
	if valueChanged then
		frame.currentPercent = 1
	end

	self:SetGradientColors(frame, valueChanged, eR, eG, eB, false, function()
		return module:GetPowerColor(frame, unit)
	end)
end
