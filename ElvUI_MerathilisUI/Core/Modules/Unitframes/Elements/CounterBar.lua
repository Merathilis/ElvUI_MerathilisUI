local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_UnitFrames')

local floor = math.floor

local CreateFrame = CreateFrame

function module:Construct_CounterBar(frame)
	if not E.Retail then return end

	local CounterBar = CreateFrame("StatusBar", frame:GetName().."_CounterBar", frame)
	CounterBar:CreateBackdrop()
	CounterBar:SetWidth(217)
	CounterBar:SetHeight(20)
	CounterBar:SetStatusBarTexture(E.media.normTex)
	CounterBar:SetPoint("TOP", E.UIParent, "TOP", 0, -102)
	MER:SmoothBar(CounterBar)

	CounterBar.bg = CounterBar:CreateTexture(nil, "BORDER")
	CounterBar.bg:SetAllPoints()
	CounterBar.bg:SetTexture(E.media.normTex)

	CounterBar.Text = CounterBar:CreateFontString(nil, "OVERLAY")
	CounterBar.Text:FontTemplate()
	CounterBar.Text:SetPoint("CENTER")

	local r, g, b
	local max

	CounterBar:SetScript("OnValueChanged", function(_, value)
		_, max = CounterBar:GetMinMaxValues()
		r, g, b = E:ColorGradient(value, max, 0.8, 0, 0, 0.8, 0.8, 0, 0, 0.8, 0)
		CounterBar:SetStatusBarColor(r, g, b)
		CounterBar.bg:SetVertexColor(r, g, b, 0.2)
		CounterBar.Text:SetText(floor(value))
	end)

	frame.CounterBar = CounterBar
end
