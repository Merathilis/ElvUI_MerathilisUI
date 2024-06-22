local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")

function module:CreateVigorBar()
	local vigorBar = CreateFrame("Frame", "CustomVigorBar", E.UIParent)
	local width = self.bar:GetWidth()
	vigorBar:SetSize(width - self.spacing, self.vigorHeight)
	vigorBar:SetPoint("BOTTOM", self.bar, "TOP", 0, self.spacing * 3)

	vigorBar.speedText = vigorBar:CreateFontString(nil, "OVERLAY")
	vigorBar.speedText:FontTemplate(nil, 20)
	vigorBar.speedText:SetPoint("BOTTOM", vigorBar, "TOP", 0, 0)
	vigorBar.speedText:SetText("0%")

	vigorBar.speedText:SetParent(vigorBar)

	vigorBar:Hide()

	vigorBar:SetScript("OnUpdate", function()
		self:UpdateSpeedText()
	end)

	vigorBar.segments = {}
	self.vigorBar = vigorBar

	self:UpdateVigorSegments()
end
