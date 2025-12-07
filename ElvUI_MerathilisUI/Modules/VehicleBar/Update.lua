local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")
local WS = W:GetModule("Skins")
local LAB = LibStub("LibActionButton-1.0-ElvUI")

local format = string.format
local ipairs, pairs = ipairs, pairs
local strsplit = strsplit
local Round = Round

local GetOverrideBarIndex = GetOverrideBarIndex
local GetVehicleBarIndex = GetVehicleBarIndex

local GetGlidingInfo = C_PlayerInfo.GetGlidingInfo

function module:UpdateKeybinds()
	for i, button in ipairs(self.bar.buttons) do
		-- Keybinds handling
		local buttonIndex = (i == 8) and 12 or i
		local actionButton = _G["ActionButton" .. buttonIndex]
		if actionButton then
			local keybind = GetBindingKey("ACTIONBUTTON" .. buttonIndex)
			if keybind and self.db.showKeybinds then
				button.HotKey:SetTextColor(1, 1, 1)
				button.HotKey:SetText(self:FormatKeybind(keybind))
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
	local point, anchor, attachTo, x, y =
		strsplit(",", F.Position(strsplit(",", self.db.position or "BOTTOM,ElvUIParent,BOTTOM,0,160")))
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
			WS:CreateShadow(button)
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
	end

	self:UpdateKeybinds()
end
