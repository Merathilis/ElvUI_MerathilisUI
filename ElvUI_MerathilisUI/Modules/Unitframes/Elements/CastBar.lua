local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")
local UF = E.UnitFrames

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
-- GLOBALS:

function module:Configure_Castbar(frame)
	if not frame.VARIABLES_SET then return end
	local castbar = frame.Castbar

	if castbar.backdrop and not castbar.isStyled then
		castbar.backdrop:Styling(false, false, true)
		castbar.isStyled = true
	end
end

function module:InitCastBar()
	hooksecurefunc(UF, "Configure_Castbar", module.Configure_Castbar)
end
