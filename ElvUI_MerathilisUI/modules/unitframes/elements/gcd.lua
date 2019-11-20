local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")

--Cache global variables
--Lua functions
--WoW API / Variables
local CreateFrame = CreateFrame
-- GLOBALS:

function module:Construct_GCD(frame)
	local bar = CreateFrame("StatusBar", nil, frame)
	local width = E.db.unitframe.units.player.castbar.width - 2

	bar:SetSize(width, 3)
	bar:SetPoint("BOTTOM", frame.Castbar.Holder, "TOP", 0, -1)
	MER:CreateStatusBar(bar, true, .8, .8, .8)
	bar:Hide()

	frame.GCD = bar
end
