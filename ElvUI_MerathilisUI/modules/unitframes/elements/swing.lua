local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")

--Cache global variables
--Lua functions
--WoW API / Variables
local CreateFrame = CreateFrame
-- GLOBALS:

function module:Construct_Swing(frame)
	local bar = CreateFrame("StatusBar", nil, frame)
	local width = E.db.unitframe.units.player.castbar.width - 2

	bar:SetSize(width, 3)
	bar:SetPoint("TOP", frame.Castbar.Holder, "BOTTOM", 0, 0)
	bar:SetFrameLevel(frame.Castbar.Holder:GetFrameLevel()+1)

	local two = CreateFrame("StatusBar", nil, bar)
	two:Hide()
	two:SetAllPoints()
	MER:CreateStatusBar(two, true, .8, .8, .8)

	local main = CreateFrame("StatusBar", nil, bar)
	main:Hide()
	main:SetAllPoints()
	MER:CreateStatusBar(main, true, .8, .8, .8)

	local off = CreateFrame("StatusBar", nil, bar)
	off:Hide()
	off:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, -3)
	off:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, -6)
	MER:CreateStatusBar(off, true, .8, .8, .8)

	bar.Text = bar:CreateFontString(nil, "OVERLAY")
	bar.Text:FontTemplate()
	bar.Text:SetText("")
	bar.Text:SetPoint("CENTER", bar, "CENTER")

	bar.TextMH = bar:CreateFontString(nil, "OVERLAY")
	bar.TextMH:FontTemplate()
	bar.TextMH:SetText("")
	bar.TextMH:SetPoint("CENTER", main, "CENTER")

	bar.TextOH = bar:CreateFontString(nil, "OVERLAY")
	bar.TextOH:FontTemplate()
	bar.TextOH:SetText("")
	bar.TextOH:SetPoint("CENTER", off, "CENTER", 1, -3)

	frame.Swing = bar
	frame.Swing.Twohand = two
	frame.Swing.Mainhand = main
	frame.Swing.Offhand = off
	frame.Swing.hideOoc = true
end
