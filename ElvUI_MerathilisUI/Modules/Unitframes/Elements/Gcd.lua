local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")

--Cache global variables
--Lua functions
local unpack = unpack
--WoW API / Variables
local CreateFrame = CreateFrame
-- GLOBALS:

function module:Construct_GCD(frame)
	local width = E.db.unitframe.units.player.castbar.width - 2
	local color = E.db.mui.unitframes.gcd.color
	local r, g, b = color.r, color.g, color.b or {.8, .8, .8}

	local bar = CreateFrame("StatusBar", frame:GetName().."_GCD", frame)
	bar:SetSize(width, 3)
	bar:SetPoint("BOTTOM", frame.Castbar.Holder, "TOP", 0, -1)
	bar:SetFrameLevel(frame.Castbar.Holder:GetFrameLevel()+1)
	bar:SetStatusBarTexture(E.media.normTex)
	bar:SetStatusBarColor(r, g, b)

	bar.BG = bar:CreateTexture(nil, "BORDER")
	bar.BG:SetAllPoints(bar)
	bar.BG:CreateBackdrop("Transparent")
	bar.BG.backdrop:Styling()

	bar.Spark = bar:CreateTexture(nil, "OVERLAY")
	bar.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	bar.Spark:SetBlendMode("ADD")
	bar.Spark:SetAlpha(.8)
	bar.Spark:SetPoint("TOPLEFT", bar:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
	bar.Spark:SetPoint("BOTTOMRIGHT", bar:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)

	bar.Text = bar:CreateFontString(nil, "OVERLAY")
	bar.Text:FontTemplate()
	bar.Text:SetPoint("CENTER", 0, 0)

	bar:Hide()

	frame.GCD = bar
	frame.Text = bar.Text
end
