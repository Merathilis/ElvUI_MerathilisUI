local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")
local LSM = E.Libs.LSM

local tinsert = table.insert

local C_Timer_NewTicker = C_Timer.NewTicker

-- Everything below only runs while the vigor bar is visible (skyriding with the vehicle bar up)
function module:StartVigorUpdates()
	local vigorBar = self.vigorBar
	self:StopVigorUpdates()

	vigorBar:RegisterEvent("SPELL_UPDATE_CHARGES")

	-- Speed has no event, it is polled at its own update rate
	if self.vdb.showSpeedText then
		vigorBar.speedTextTicker = C_Timer_NewTicker(self.vdb.speedTextUpdateRate, function()
			self:UpdateSpeedText()
		end)
		self:UpdateSpeedText()
	end

	self:UpdateVigorSegments()
end

function module:StopVigorUpdates()
	local vigorBar = self.vigorBar
	if not vigorBar then
		return
	end

	vigorBar:UnregisterAllEvents()
	if vigorBar.vigorTicker then
		vigorBar.vigorTicker:Cancel()
		vigorBar.vigorTicker = nil
	end
	if vigorBar.speedTextTicker then
		vigorBar.speedTextTicker:Cancel()
		vigorBar.speedTextTicker = nil
	end
end

-- The recharge fill has no event either, so it only ticks while a charge refills
-- (0.05s = 20fps, visually indistinguishable from per-frame)
function module:UpdateRechargeTicker(recharging)
	local vigorBar = self.vigorBar
	if recharging and vigorBar:IsVisible() then
		if not vigorBar.vigorTicker then
			vigorBar.vigorTicker = C_Timer_NewTicker(0.05, function()
				self:UpdateVigorSegments()
			end)
		end
	elseif vigorBar.vigorTicker then
		vigorBar.vigorTicker:Cancel()
		vigorBar.vigorTicker = nil
	end
end

function module:CreateVigorBar()
	local vigorBar = CreateFrame("Frame", "MER_VigorBar", UIParent)
	local width = self.bar:GetWidth()
	local height = self.vdb.height or 10
	vigorBar:SetSize(width - self.spacing, height)
	vigorBar:SetPoint("BOTTOM", self.bar, "TOP", 0, self.spacing * 3)

	-- Create a separate frame for speed text with higher frame level
	local speedTextFrame = CreateFrame("Frame", "MER_VigorBar_SpeedTextFrame", vigorBar)
	speedTextFrame:SetAllPoints(vigorBar)
	speedTextFrame:SetFrameLevel(vigorBar:GetFrameLevel() + 10)

	-- Create speed text on the higher-level frame
	vigorBar.speedText = speedTextFrame:CreateFontString(nil, "OVERLAY")
	vigorBar.speedText:SetFont(
		F.GetFontPath(self.vdb.speedTextFont),
		F.FontSizeScaled(self.vdb.speedTextFontSize),
		"OUTLINE"
	)
	vigorBar.speedText:SetPoint("BOTTOM", vigorBar, "TOP", 0, self.vdb.speedTextOffsetY)
	vigorBar.speedText:SetText("0%")

	if self.vdb.showSpeedText then
		vigorBar.speedText:Show()
	else
		vigorBar.speedText:Hide()
	end

	self.vigorBar = vigorBar
	self.vigorBar.segments = {}

	vigorBar:Hide()

	-- Events and tickers only live while the bar is visible
	vigorBar:SetScript("OnShow", function()
		self:StartVigorUpdates()
	end)
	vigorBar:SetScript("OnHide", function()
		self:StopVigorUpdates()
	end)
	vigorBar:SetScript("OnEvent", function()
		-- Only update segment values, don't recreate
		self:UpdateVigorSegments()
	end)

	self:CreateVigorSegments()
	if not F.Table.IsEmpty(self.vigorBar.segments) then
		self:UpdateVigorSegments()
	end
end

function module:CreateVigorSegments()
	local segments = {}
	local chargeInfo = self:GetSpellChargeInfo()
	if not chargeInfo then
		return
	end

	local maxCharges = chargeInfo.maxCharges
	local height = self.vdb.height or 10

	local segmentWidth = (self.vigorBar:GetWidth() / maxCharges) - (self.spacing * 2)

	local classColor = E:ClassColor(E.myclass, true)
	local r, g, b = classColor.r, classColor.g, classColor.b

	local leftColor, rightColor

	-- Check if custom colors are enabled
	if self.vdb.useCustomColor then
		local customLeft = self.vdb.customColorLeft
		local customRight = self.vdb.customColorRight
		leftColor = CreateColor(customLeft.r, customLeft.g, customLeft.b, 1)
		rightColor = CreateColor(customRight.r, customRight.g, customRight.b, 1)
	elseif E.db.mui.themes.gradientMode.enable then
		local colorMap = E.db.mui.themes.gradientMode.classColorMap

		local left = colorMap[1][E.myclass]
		local right = colorMap[2][E.myclass]

		if left.r and right.r then
			leftColor = CreateColor(left.r, left.g, left.b, 1)
			rightColor = CreateColor(right.r, right.g, right.b, 1)
		end
	end

	local darkTexture = LSM:Fetch("statusbar", self.vdb.darkTexture)
	-- local normalTexture = LSM:Fetch("statusbar", self.vdb.normalTexture)

	-- Frames can't be freed, so every segment is built once and reused
	local pool = self.vigorBar.segmentPool or {}
	self.vigorBar.segmentPool = pool

	for i = 1, maxCharges do
		local segment = pool[i]
		if not segment then
			segment = CreateFrame("StatusBar", "MER_VigorBar_Segment" .. i, self.vigorBar)

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

			pool[i] = segment
		end

		segment:SetSize(segmentWidth, height)
		segment:SetStatusBarTexture(darkTexture)
		segment:GetStatusBarTexture():SetHorizTile(false)

		-- Store colors for later use
		segment.classColor = { r = r, g = g, b = b }
		segment.leftColor = leftColor
		segment.rightColor = rightColor

		-- Set initial color (will be updated in UpdateVigorSegments)
		if leftColor and rightColor then
			segment:GetStatusBarTexture():SetGradient("HORIZONTAL", leftColor, rightColor)
		else
			segment:SetStatusBarColor(r, g, b)
		end

		segment:ClearAllPoints()
		if i == 1 then
			segment:SetPoint("LEFT", self.vigorBar, "LEFT", self.spacing, 0)
		else
			segment:SetPoint("LEFT", segments[i - 1], "RIGHT", self.spacing * 2, 0)
		end

		segment:SetMinMaxValues(0, 1)
		segment:Show()

		tinsert(segments, segment)
	end

	for i = maxCharges + 1, #pool do
		pool[i]:Hide()
	end

	self.vigorBar.segments = segments
end
