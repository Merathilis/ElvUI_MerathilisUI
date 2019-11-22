local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function module:Update_TargetTargetFrame(frame)
	local db = E.db.unitframe

	-- Only looks good on Transparent
	if db.colors.transparentHealth then
		if frame and not frame.isStyled then
			frame:Styling()
			frame.isStyled = true
		end
	end
end

function module:InitTargetTarget()
	if not E.db.unitframe.units.targettarget.enable then return end

	hooksecurefunc(UF, "Update_TargetTargetFrame", module.Update_TargetTargetFrame)
end
