local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function module:Update_TargetFrame(frame)
	local db = E.db.mui.unitframes

	-- Only looks good on Transparent
	if db.style and E.db.unitframe.colors.transparentHealth then
		if frame then frame:Styling() end
	end
end

function module:InitTarget()
	if not E.db.unitframe.units.target.enable then return end

	hooksecurefunc(UF, "Update_TargetFrame", module.Update_TargetFrame)
end
