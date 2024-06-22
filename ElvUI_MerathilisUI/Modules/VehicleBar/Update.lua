local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")
local S = MER:GetModule("MER_Skins")
local LAB = LibStub("LibActionButton-1.0-ElvUI")

local format = string.format
local ipairs, pairs = ipairs, pairs
local tinsert = table.insert
local strsplit = strsplit
local Round = Round

local BASE_MOVEMENT_SPEED = BASE_MOVEMENT_SPEED
local GetOverrideBarIndex = GetOverrideBarIndex
local GetVehicleBarIndex = GetVehicleBarIndex

local GetGlidingInfo = C_PlayerInfo and C_PlayerInfo.GetGlidingInfo

function module:UpdateVigorSegments()
	local widgetInfo = module:GetWidgetInfo()

	if not widgetInfo then
		return
	end

	local maxVigor = widgetInfo.numTotalFrames or 6

	for _, segment in ipairs(self.vigorBar.segments) do
		segment:Hide()
	end

	self.vigorBar.segments = {}

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

		-- Border
		local border = CreateFrame("Frame", nil, segment, "BackdropTemplate")
		border:SetPoint("TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetBackdrop({
			edgeFile = E.media.blankTex,
			edgeSize = 1,
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

function module:UpdateSpeedText()
	if not self.vigorBar then
		return
	end

	local isGliding, _, forwardSpeed = GetGlidingInfo()
	local base = isGliding and forwardSpeed or GetUnitSpeed("player")
	local movespeed = Round(base / BASE_MOVEMENT_SPEED * 100)

	self.vigorBar.speedText:SetText(self:ColorSpeedText(format("%d%%", movespeed)))
end

function module:UpdateKeybinds()
	for i, button in ipairs(self.bar.buttons) do
		local buttonIndex = (i == 8) and 12 or i
		local actionButton = _G["ActionButton" .. buttonIndex]
		if actionButton then
			local keybind = GetBindingKey("ACTIONBUTTON" .. buttonIndex)
			if keybind then
				button.HotKey:SetTextColor(1, 1, 1)
				button.HotKey:SetText(self:FormatKeybind(GetBindingText(keybind, "KEY_", 1)))
				button.HotKey:Show()
			else
				button.HotKey:Hide()
			end
		end
	end
end

function module:UpdateVigorBar()
	local widgetInfo = module:GetWidgetInfo()

	if not widgetInfo then
		return
	end

	local currentVigor = widgetInfo.numFullFrames
	local partialFill = widgetInfo.fillValue / widgetInfo.fillMax
	local maxVigor = widgetInfo.numTotalFrames or 6

	-- Check if bar width has changed
	local currentBarWidth = self.bar:GetWidth()
	if currentBarWidth ~= self.previousBarWidth then
		-- Update the width of the vigorBar to match the width of self.bar
		local width = currentBarWidth - self.spacing
		self.vigorBar:SetWidth(width)

		-- Calculate the new segment width based on the updated vigorBar width
		local segmentWidth = (self.vigorBar:GetWidth() / maxVigor) - (self.spacing * 2)

		if #self.vigorBar.segments ~= maxVigor then
			self:UpdateVigorSegments()
		end

		for _, segment in ipairs(self.vigorBar.segments) do
			segment:SetWidth(segmentWidth) -- Update the width of each segment
		end

		-- Store the new width
		self.previousBarWidth = currentBarWidth
	end

	for i, segment in ipairs(self.vigorBar.segments) do
		if i <= currentVigor then
			segment:SetValue(1)
			segment:Show()
		elseif i == currentVigor + 1 then
			segment:SetValue(partialFill)
			segment:Show()
		elseif i <= maxVigor then
			segment:SetValue(0)
			segment:Show()
		else
			segment:Hide()
		end
	end

	-- Update the speed text
	self:UpdateSpeedText()
end

function module:UpdateBar()
	-- Vars
	local size = self.db.buttonWidth or 48

	-- Create or get bar
	local init = self.bar == nil
	local bar = self.bar or CreateFrame("Frame", "MER_VehicleBar", E.UIParent, "SecureHandlerStateTemplate")

	-- Default position
	local point, anchor, attachTo, x, y = strsplit(",", F.Position(strsplit(",", self.db.position)))
	bar:SetPoint(point, anchor, attachTo, x, y or "BOTTOM,ElvUIParent,BOTTOM,0,140")

	-- Set bar vars
	self.bar = bar
	self.bar.id = 1

	-- Page Handling
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

	-- Create Buttons
	if not bar.buttons then
		bar.buttons = {}

		for i = 1, 8 do
			local buttonIndex = (i == 8) and 12 or i

			-- Create button
			local button = LAB:CreateButton(buttonIndex, "MER_VehicleBarButton" .. buttonIndex, bar, nil)

			-- Set state aka actions
			button:SetState(0, "action", buttonIndex)
			for k = 1, 18 do
				button:SetState(k, "action", (k - 1) * 12 + buttonIndex)
			end
			if buttonIndex == 12 then
				button:SetState(12, "custom", self.ab.customExitButton)
			end

			-- Style
			self.ab:StyleButton(button, nil, nil)
			button:SetTemplate("Transparent")
			button:SetCheckedTexture("")
			button.MasqueSkinned = true -- Ugly fix for smaller cooldowns, not actually using Masque

			-- Adjust the count position
			button.Count:ClearAllPoints()
			button.Count:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", self.spacing, self.spacing)

			-- Add to array
			bar.buttons[i] = button
		end
	end

	-- Calculate Bar Width/Height
	local width = (size * 8) + (self.spacing * (8 - 1)) + 4
	bar:SetWidth(width)
	bar:SetHeight((size / 4 * 3))

	-- Update button position and size
	for i, button in ipairs(bar.buttons) do
		button:SetSize(size, size / 4 * 3)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint("BOTTOMLEFT", self.spacing, self.spacing)
		else
			button:SetPoint("LEFT", bar.buttons[i - 1], "RIGHT", self.spacing, 0)
		end
	end

	-- Update Paging
	local pageState = format(
		"[overridebar] %d; [vehicleui] %d; [possessbar] %d; [shapeshift] 13; %s",
		GetOverrideBarIndex(),
		GetVehicleBarIndex(),
		GetVehicleBarIndex(),
		(self.db.dragonRiding and "[bonusbar:5] 11;") or ""
	)
	local pageAttribute = self.ab:GetPage("bar1", 1, pageState)
	RegisterStateDriver(bar, "page", pageAttribute)
	self.bar:SetAttribute("page", pageAttribute)

	-- ElvUI Bar config
	self.ab:UpdateButtonConfig("bar1", "ACTIONBUTTON")
	self.ab:PositionAndSizeBar("bar1")
	self.ab:PositionAndSizeBar("bar2")
	self.ab:PositionAndSizeBar("bar3")

	-- Hook for animation
	self:SecureHookScript(bar, "OnShow", "OnShowEvent")
	self:SecureHookScript(bar, "OnHide", "OnHideEvent")

	-- Hide
	bar:Hide()

	-- Only run after first creation
	if init then
		-- Create Mover
		E:CreateMover(bar, "MER_VehicleBar", MER.Title .. " Vehicle Bar", nil, nil, nil, "ALL,ACTIONBARS,MERATHILISUI")

		-- Force update
		for _, button in pairs(bar.buttons) do
			button:UpdateAction()
		end

		if not self.vigorBar then
			self:CreateVigorBar()
		end

		-- Initial call to update keybinds
		self:UpdateKeybinds()
	end
end
