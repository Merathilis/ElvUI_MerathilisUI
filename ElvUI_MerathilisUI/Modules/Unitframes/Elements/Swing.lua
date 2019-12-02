local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")

--Cache global variables
--Lua functions
--WoW API / Variables
local CreateFrame = CreateFrame
-- GLOBALS:

function module:Construct_Swing(frame)
	local width = E.db.unitframe.units.player.castbar.width - 2
	local Mcolor = E.db.mui.unitframes.swing.mcolor
	local Tcolor = E.db.mui.unitframes.swing.tcolor
	local Ocolor = E.db.mui.unitframes.swing.ocolor
	local Mr, Mg, Mb = Mcolor.r, Mcolor.g, Mcolor.b or {.8, .8, .8}
	local Tr, Tg, Tb = Tcolor.r, Tcolor.g, Tcolor.b or {.8, .8, .8}
	local Or, Og, Ob = Ocolor.r, Ocolor.g, Ocolor.b or {.8, .8, .8}

	local bar = CreateFrame("StatusBar", frame:GetName().."_Swing", frame)
	bar:SetSize(width, 3)
	bar:SetPoint("TOP", frame.Castbar.Holder, "BOTTOM", 0, 1)
	bar:SetFrameLevel(frame.Castbar.Holder:GetFrameLevel()+1)
	bar:CreateBackdrop("Transparent")
	bar.backdrop:Styling()

	local main = CreateFrame("StatusBar", nil, bar)
	main:SetAllPoints(bar)
	main:SetStatusBarTexture(E.media.normTex)
	main:SetStatusBarColor(Mr, Mg, Mb)

	main.BG = main:CreateTexture(nil, "BORDER")
	main.BG:SetAllPoints(main)

	main.Spark = main:CreateTexture(nil, "OVERLAY")
	main.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	main.Spark:SetBlendMode("ADD")
	main.Spark:SetAlpha(.8)
	main.Spark:SetPoint("TOPLEFT", main:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
	main.Spark:SetPoint("BOTTOMRIGHT", main:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)

	local two = CreateFrame("StatusBar", nil, bar)
	two:SetAllPoints(bar)
	two:SetStatusBarTexture(E.media.normTex)
	two:SetStatusBarColor(Tr, Tg, Tb)

	two.BG = two:CreateTexture(nil, "BORDER")
	two.BG:SetAllPoints(two)

	two.Spark = two:CreateTexture(nil, "OVERLAY")
	two.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	two.Spark:SetBlendMode("ADD")
	two.Spark:SetAlpha(.8)
	two.Spark:SetPoint("TOPLEFT", two:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
	two.Spark:SetPoint("BOTTOMRIGHT", two:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)

	local off = CreateFrame("StatusBar", nil, bar)
	off:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, -3)
	off:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, -6)
	off:SetStatusBarTexture(E.media.normTex)
	off:SetStatusBarColor(Or, Og, Ob)

	off.BG = off:CreateTexture(nil, "BORDER")
	off.BG:SetAllPoints(off)

	off.Spark = off:CreateTexture(nil, "OVERLAY")
	off.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	off.Spark:SetBlendMode("ADD")
	off.Spark:SetAlpha(.8)
	off.Spark:SetPoint("TOPLEFT", off:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
	off.Spark:SetPoint("BOTTOMRIGHT", off:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)

	bar.Text = bar:CreateFontString(nil, "OVERLAY")
	bar.Text:FontTemplate()
	bar.Text:SetPoint("CENTER", 0, 0)

	bar.TextMH = bar:CreateFontString(nil, "OVERLAY")
	bar.TextMH:FontTemplate()
	bar.TextMH:SetPoint("CENTER", 0, 0)

	bar.TextOH = bar:CreateFontString(nil, "OVERLAY")
	bar.TextOH:FontTemplate()
	bar.TextOH:SetPoint("CENTER", off, "CENTER", 1, -3)

	bar:Hide()

	frame.Swing = bar
	frame.Swing.Mainhand = main
	frame.Swing.Twohand = two
	frame.Swing.Offhand = off
	frame.Swing.hideOoc = true
end
