local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_UnitFrames')

local CreateFrame = CreateFrame

function module:Construct_GCD(frame)
	local width = E.db.unitframe.units.player.castbar.width - 2
	local color = E.db.mui.unitframes.gcd.color
	local r, g, b = color.r, color.g, color.b or { .8, .8, .8 }

	local bar = CreateFrame("StatusBar", frame:GetName() .. "_GCD", frame)
	bar:Size(width, 3)
	bar:ClearAllPoints()
	bar:Point("BOTTOM", frame.Castbar.Holder, "TOP", 0, -1)
	bar:SetFrameLevel(frame.Castbar.Holder:GetFrameLevel() + 1)
	bar:SetStatusBarTexture(E.media.normTex)
	bar:SetStatusBarColor(r, g, b)
	MER:SmoothBar(bar)

	bar.BG = bar:CreateTexture(nil, "BORDER")
	bar.BG:SetAllPoints(bar)
	bar.BG:CreateBackdrop("Transparent")

	bar.Spark = bar:CreateTexture(nil, "OVERLAY")
	bar.Spark:SetTexture(E.media.blankTex)
	bar.Spark:SetVertexColor(1, 1, 1, 0.4)
	bar.Spark:SetPoint("RIGHT", bar:GetStatusBarTexture())
	bar.Spark:SetBlendMode("ADD")
	bar.Spark:Size(2)

	bar.Text = bar:CreateFontString(nil, "OVERLAY")
	bar.Text:FontTemplate()
	bar.Text:SetPoint("CENTER", 0, 0)

	bar:Hide()

	frame.GCD = bar
	frame.Text = bar.Text
end
