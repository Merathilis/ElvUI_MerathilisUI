local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")
local CM = MER:GetModule("MER_ColorModifiers")
local WS = W:GetModule("Skins")
local LAB = LibStub("LibActionButton-1.0-ElvUI")

local format = string.format
local ipairs, pairs = ipairs, pairs
local strsplit = strsplit
local Round = Round

local C_ActionBar_GetOverrideBarIndex = C_ActionBar.GetOverrideBarIndex
local C_ActionBar_GetVehicleBarIndex = C_ActionBar.GetVehicleBarIndex
local C_PlayerInfo_GetGlidingInfo = C_PlayerInfo.GetGlidingInfo
local GetUnitSpeed = GetUnitSpeed

function module:UpdateVigorSegments()
	local chargeInfo = self:GetSpellChargeInfo()

	if not chargeInfo then
		self:UpdateRechargeTicker(false)
		return
	end

	local currentCharges = chargeInfo.currentCharges
	local maxCharges = chargeInfo.maxCharges

	-- Calculate fractional charge progress
	local fractionalCharge = 0
	if currentCharges < maxCharges and chargeInfo.cooldownStartTime and chargeInfo.cooldownDuration then
		local elapsed = GetTime() - chargeInfo.cooldownStartTime
		fractionalCharge = elapsed / chargeInfo.cooldownDuration
	end

	local grayColor = 0.5 -- Gray color for recharging segments

	for i, segment in ipairs(self.vigorBar.segments) do
		if i <= currentCharges then
			-- Full charge - use gradient colors
			segment:SetValue(1)
			if segment.leftColor and segment.rightColor then
				segment:GetStatusBarTexture():SetGradient("HORIZONTAL", segment.leftColor, segment.rightColor)
			else
				segment:SetStatusBarColor(segment.classColor.r, segment.classColor.g, segment.classColor.b)
			end
			segment:Show()
		elseif i == currentCharges + 1 and fractionalCharge > 0 then
			-- Recharging - use gray color
			segment:SetValue(fractionalCharge)
			segment:SetStatusBarColor(grayColor, grayColor, grayColor)
			segment:Show()
		else
			-- Empty - hide
			segment:SetValue(0)
			segment:Show()
		end
	end

	self:UpdateRechargeTicker(currentCharges < maxCharges)
end

function module:UpdateSpeedText()
	if not self.vigorBar or not self:IsVigorAvailable() then
		return
	end

	local isGliding, _, forwardSpeed = C_PlayerInfo_GetGlidingInfo()
	local base = isGliding and forwardSpeed or GetUnitSpeed("player")

	if not E:NotSecretValue(base) then
		self.vigorBar.speedText:SetText(F.String.Muted("N/A"))
		return
	end

	local movespeed = Round(base / BASE_MOVEMENT_SPEED * 100)

	self.vigorBar.speedText:SetText(self:ColorSpeedText(format("%d%%", movespeed)))
end

function module:UpdateVigorBar()
	-- Update vigor bar size before creating segments
	local height = self.vdb.height or 10
	local width = self.bar:GetWidth() - self.spacing
	self.vigorBar:SetSize(width, height)

	-- Update speed text font and position
	self.vigorBar.speedText:SetFont(
		F.GetFontPath(self.vdb.speedTextFont),
		F.FontSizeScaled(self.vdb.speedTextFontSize),
		"OUTLINE"
	)
	self.vigorBar.speedText:ClearAllPoints()
	self.vigorBar.speedText:SetPoint("BOTTOM", self.vigorBar, "TOP", 0, self.vdb.speedTextOffsetY)

	-- Show or hide speed text
	if self.vdb.showSpeedText then
		self.vigorBar.speedText:Show()
	else
		self.vigorBar.speedText:Hide()
	end

	-- Rebuild the segments with the current size, colors and textures
	self:CreateVigorSegments()

	-- Update segment display, a restart while visible also picks up a changed speed text setting
	if self.vigorBar:IsVisible() then
		self:StartVigorUpdates()
	else
		self:UpdateVigorSegments()
	end
end

function module:UpdateButtonLock()
	if not self.bar or not self.bar.buttons then
		return
	end
	for _, button in ipairs(self.bar.buttons) do
		button:SetAttribute("buttonlock", self.ab.db.lockActionBars or nil)
	end
end

function module:UpdateKeybinds()
	for i, button in ipairs(self.bar.buttons) do
		-- Keybinds handling
		local buttonIndex = (i == 8) and 12 or i
		local actionButton = _G["ActionButton" .. buttonIndex]
		if actionButton then
			local keybind = GetBindingKey("ACTIONBUTTON" .. buttonIndex)
			if keybind and self.db.showKeybinds then
				button.HotKey:SetTextColor(1, 1, 1)
				button.HotKey:SetText(CM:FormatKeybind(keybind))
				button.HotKey:Width(button:GetWidth())
				button.HotKey:Show()
			else
				button.HotKey:Hide()
			end
		end

		-- Macro Text handling
		if button.Name then
			if self.db.showMacro then
				button.Name:Show()
			else
				button.Name:Hide()
			end
		end
	end
end

function module:UpdateBar()
	-- Vars
	local size = self.db.buttonWidth or 48

	local init = self.bar == nil
	local bar = self.bar or CreateFrame("Frame", "MER_VehicleBar", E.UIParent, "SecureHandlerStateTemplate")
	-- Default position
	if init then
		local point, anchor, attachTo, x, y = strsplit(",", F.Position(strsplit(",", self.db.position)))
		bar:SetPoint(point, anchor, attachTo, x, y)
	end

	self.bar = bar
	self.bar.id = 1

	-- Page Handling
	-- Runs in the restricted environment: it has GetVehicleBarIndex/GetOverrideBarIndex,
	-- not this file's locals
	bar:SetAttribute(
		"_onstate-page",
		[[
		newstate = ((HasTempShapeshiftActionBar() and self:GetAttribute("hasTempBar")) and GetTempShapeshiftBarIndex())
		or (UnitHasVehicleUI("player") and GetVehicleBarIndex())
		or (HasOverrideActionBar() and GetOverrideBarIndex())
		or newstate

		if not newstate then
			return
		end

		if newstate ~= 0 then
			self:SetAttribute("state", newstate)
			control:ChildUpdate("state", newstate)
		else
			local newCondition = self:GetAttribute("newCondition")
			if newCondition then
				newstate = SecureCmdOptionParse(newCondition)
				self:SetAttribute("state", newstate)
				control:ChildUpdate("state", newstate)
			end
		end
	]]
	)

	if not bar.buttons then
		bar.buttons = {}

		for i = 1, 8 do
			local buttonIndex = (i == 8) and 12 or i

			local button = LAB:CreateButton(buttonIndex, "MER_VehicleBarButton" .. buttonIndex, bar, nil)
			button:SetState(0, "action", buttonIndex)

			for k = 1, 18 do
				button:SetState(k, "action", (k - 1) * 12 + buttonIndex)
			end
			if buttonIndex == 12 then
				button:SetState(12, "custom", self.ab.customExitButton)
			end

			self.ab:StyleButton(button, nil, nil)
			button:SetTemplate("Transparent")
			button:SetCheckedTexture("")
			WS:CreateShadow(button)
			button.MasqueSkinned = true

			-- Always show grid for empty buttons
			button.config.showGrid = true

			button.Count:ClearAllPoints()
			button.Count:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", self.spacing, self.spacing)

			bar.buttons[i] = button
		end
	end

	-- Calculate Bar Width/Height
	local width = (size * 8) + (self.spacing * (8 - 1)) + 4
	bar:SetWidth(width)
	bar:SetHeight((size / 3 * 2))

	-- Update button position and size
	for i, button in ipairs(bar.buttons) do
		button:SetSize(size, size / 3 * 2)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint("BOTTOMLEFT", self.spacing, self.spacing)
		else
			button:SetPoint("LEFT", bar.buttons[i - 1], "RIGHT", self.spacing, 0)
		end
	end

	-- Update Paging
	local vehicleBarIndex = C_ActionBar_GetVehicleBarIndex()
	local pageState = format(
		"[overridebar] %d; [vehicleui] %d; [possessbar] %d; [shapeshift] 13; %s",
		C_ActionBar_GetOverrideBarIndex(),
		vehicleBarIndex,
		vehicleBarIndex,
		"[bonusbar:5] 11;"
	)
	local pageAttribute = self.ab:GetPage("bar1", 1, pageState)
	RegisterStateDriver(bar, "page", pageAttribute)
	self.bar:SetAttribute("page", pageAttribute)

	-- ElvUI Bar config
	self.ab:UpdateButtonConfig("bar1", "ACTIONBUTTON")
	self.ab:PositionAndSizeBar("bar1")
	self.ab:PositionAndSizeBar("bar2")
	self.ab:PositionAndSizeBar("bar3")

	bar:Hide()

	-- Disable() removes every hook (UnhookAll), so they are set again on each enable. Without
	-- OnShow the vigor bar, the animations and the keybinds never came back.
	if not self:IsHooked(bar, "OnShow") then
		self:SecureHookScript(bar, "OnShow", "OnShowEvent")
	end
	if not self:IsHooked(bar, "OnHide") then
		self:SecureHookScript(bar, "OnHide", "OnHideEvent")
	end

	if init then
		-- Create Mover
		E:CreateMover(
			bar,
			"MER_VehicleBar",
			MER.Title .. " Vehicle Bar",
			nil,
			nil,
			nil,
			"ALL,ACTIONBARS,MERATHILISUI",
			nil,
			"mui,modules,vehicleBar"
		)

		-- Force update
		for _, button in pairs(bar.buttons) do
			button:UpdateAction()
		end
	end

	-- Also when the vigor bar was turned off on login and is turned on later
	if not self.vigorBar and self.vdb.enable then
		self:CreateVigorBar()
	elseif self.vigorBar and self.vdb.enable then
		-- Update vigor bar if it exists (for settings changes)
		self:UpdateVigorBar()
		-- Show vigor bar if the vehicle bar is currently shown and we're skyriding
		if self.bar:IsShown() and self:IsVigorAvailable() then
			self.vigorBar:Show()
		end
	end

	self:UpdateKeybinds()
	self:UpdateButtonLock()
end
