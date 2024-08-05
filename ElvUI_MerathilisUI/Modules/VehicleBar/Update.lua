local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")
local S = MER:GetModule("MER_Skins")
local LAB = LibStub("LibActionButton-1.0-ElvUI")

local format = string.format
local ipairs, pairs = ipairs, pairs
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

	local widgetInfo = self:GetWidgetInfo()

	if not widgetInfo then
		return
	end

	local currentVigor = widgetInfo.numFullFrames
	local partialFill = widgetInfo.fillValue / widgetInfo.fillMax

	for i, segment in ipairs(self.vigorBar.segments) do
		if i <= currentVigor then
			segment:SetValue(1)
			segment:Show()
		elseif i == currentVigor + 1 then
			segment:SetValue(partialFill)
			segment:Show()
		else
			segment:SetValue(0)
			segment:Show()
		end
	end
end

function module:UpdateSpeedText()
	if self:IsVigorAvailable() and not self.vigorBar then
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
				button.HotKey:SetText(self:FormatKeybind(keybind))
				button.HotKey:Width(button:GetWidth())
				button.HotKey:Show()
			else
				button.HotKey:Hide()
			end
		end
	end
end

function module:UpdateVigorBar()
	if F.Table.IsEmpty(self.vigorBar.segments) then
		self:CreateVigorSegments()
	end

	local currentBarWidth = self.bar:GetWidth()
	if currentBarWidth ~= self.previousBarWidth then
		local widgetInfo = self:GetWidgetInfo()

		local width = currentBarWidth - self.spacing
		self.vigorBar:SetWidth(width)

		if not widgetInfo then
			return
		end
		local maxVigor = widgetInfo.numTotalFrames

		local segmentWidth = (self.vigorBar:GetWidth() / maxVigor) - (self.spacing * 2)

		for _, segment in ipairs(self.vigorBar.segments) do
			segment:SetWidth(segmentWidth)
		end

		self.previousBarWidth = currentBarWidth
	end

	self:UpdateVigorSegments()
end

function module:UpdateBar()
	-- Vars
	local size = self.db.buttonWidth or 48

	local init = self.bar == nil
	local bar = self.bar or CreateFrame("Frame", "MER_VehicleBar", E.UIParent, "SecureHandlerStateTemplate")

	-- Default position
	local point, anchor, attachTo, x, y =
		strsplit(",", F.Position(strsplit(",", self.db.position or "BOTTOM,ElvUIParent,BOTTOM,0,140")))
	bar:SetPoint(point, anchor, attachTo, x, y)

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
			S:CreateShadow(button)
			button.MasqueSkinned = true

			button.Count:ClearAllPoints()
			button.Count:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", self.spacing, self.spacing)

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

	-- Hook for animation
	self:SecureHookScript(bar, "OnShow", "OnShowEvent")
	self:SecureHookScript(bar, "OnHide", "OnHideEvent")

	bar:Hide()

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

		if not self.vigorBar and self.vdb.enable then
			self:CreateVigorBar()
		end
	end

	self:UpdateKeybinds()
end
