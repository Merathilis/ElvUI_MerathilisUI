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
	bar:SetFrameLevel(frame.Castbar.Holder:GetFrameLevel()+1)

	MER:CreateStatusBar(bar, true, .8, .8, .8)
	bar:Hide()

	bar.Text = bar:CreateFontString(nil, "OVERLAY")
	bar.Text:FontTemplate()
	bar.Text:SetText("")
	bar.Text:SetPoint("CENTER", bar, "CENTER", 0, 2)

	frame.GCD = bar
	frame.Text = bar.Text
end
