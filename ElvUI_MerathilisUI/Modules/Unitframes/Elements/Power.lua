local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function module:Configure_Power(frame)
	if not frame.VARIABLES_SET then return end
	local power = frame.Power

	if power and not power.isStyled then
		power:Styling(false, false, true)
		power.isStyled = true
	end
end

function module:InitPower()
	hooksecurefunc(UF, "Configure_Power", module.Configure_Power)
end
