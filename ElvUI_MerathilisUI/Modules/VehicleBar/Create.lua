local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")
local S = MER:GetModule("MER_Skins")

local tinsert = table.insert

function module:CreateVigorBar()
	local vigorBar = CreateFrame("Frame", "CustomVigorBar", UIParent)
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

	self.vigorBar = vigorBar
	self.vigorBar.segments = {}

	self:CreateVigorSegments()
	if not F.Table.IsEmpty(self.vigorBar.segments) then
		self:UpdateVigorSegments()
	end
end

function module:CreateVigorSegments()
	local widgetInfo = self:GetWidgetInfo()
	if not widgetInfo then
		return
	end

	local maxVigor = widgetInfo.numTotalFrames or 6

	local segmentWidth = (self.vigorBar:GetWidth() / maxVigor) - (self.spacing * 2)

	local classColor = E:ClassColor(E.myclass, true)
	local r, g, b = classColor.r, classColor.g, classColor.b
	local _, class = UnitClass("player")

	for i = 1, maxVigor do
		local segment = CreateFrame("StatusBar", nil, self.vigorBar)
		segment:SetSize(segmentWidth, self.vigorHeight)

		segment:SetStatusBarTexture(E.media.normTex)
		segment:GetStatusBarTexture():SetHorizTile(false)

		if E.db.mui.gradient.enable then
			segment:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors(class))
		else
			segment:SetStatusBarColor(r, g, b)
		end

		local bg = segment:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints()
		bg:SetColorTexture(0, 0, 0, 0.5)

		local border = CreateFrame("Frame", nil, segment, "BackdropTemplate")
		border:SetPoint("TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetBackdrop({
			edgeFile = E.media.blankTex,
			edgeSize = E.twoPixelsPlease and 2 or 1,
		})
		border:SetBackdropBorderColor(0, 0, 0)

		if i == 1 then
			segment:SetPoint("LEFT", self.vigorBar, "LEFT", self.spacing, 0)
		else
			segment:SetPoint("LEFT", self.vigorBar.segments[i - 1], "RIGHT", self.spacing * 2, 0)
		end

		segment:SetMinMaxValues(0, 1)
		S:CreateShadow(segment)

		tinsert(self.vigorBar.segments, segment)
	end
end
