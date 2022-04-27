local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_VehicleBar')
local AB = E:GetModule('ActionBars')
local LAB = LibStub('LibActionButton-1.0-ElvUI')
local Masque = LibStub('Masque', true)
local MasqueGroup = Masque and Masque:Group('ElvUI', 'ActionBars')

local _G = _G
local format, split = string.format, string.split
local ipairs, pairs = ipairs, pairs

local CreateFrame = CreateFrame
local GetOverrideBarIndex = GetOverrideBarIndex
local GetVehicleBarIndex = GetVehicleBarIndex
local InCombatLockdown = InCombatLockdown
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

function module:StopAllAnimations()
	if (self.bar.SlideIn) and (self.bar.SlideIn.SlideIn:IsPlaying()) then self.bar.SlideIn.SlideIn:Finish() end

	for _, button in ipairs(self.bar.buttons) do
		if (button.FadeIn) and (button.FadeIn:IsPlaying()) then
			button.FadeIn:Stop()
			button:SetAlpha(1)
		end
	end
end

function module:SetupButtonAnim(button, index)
	local iconFade = (1 * self.db.animationsMult)
	local iconHold = (index * 0.10) * self.db.animationsMult

	button.FadeIn = button.FadeIn or MER:CreateAnimationGroup(button)

	button.FadeIn.ResetFade = button.FadeIn.ResetFade or button.FadeIn:CreateAnimation("Fade")
	button.FadeIn.ResetFade:SetDuration(0)
	button.FadeIn.ResetFade:SetChange(0)
	button.FadeIn.ResetFade:SetOrder(1)

	button.FadeIn.Hold = button.FadeIn.Hold or button.FadeIn:CreateAnimation("Sleep")
	button.FadeIn.Hold:SetDuration(iconHold)
	button.FadeIn.Hold:SetOrder(2)

	button.FadeIn.Fade = button.FadeIn.Fade or button.FadeIn:CreateAnimation("Fade")
	button.FadeIn.Fade:SetEasing("out-quintic")
	button.FadeIn.Fade:SetChange(1)
	button.FadeIn.Fade:SetDuration(iconFade)
	button.FadeIn.Fade:SetOrder(3)
end

function module:SetupBarAnim()
	local iconFade = ((7 * 0.10) * self.db.animationsMult) + (1 * self.db.animationsMult)

	self.bar.SlideIn = self.bar.SlideIn or {}

	self.bar.SlideIn.ResetOffset = self.bar.SlideIn.ResetOffset or MER:CreateAnimationGroup(self.bar):CreateAnimation("Move")
	self.bar.SlideIn.ResetOffset:SetDuration(0)
	self.bar.SlideIn.ResetOffset:SetOffset(0, -60)
	self.bar.SlideIn.ResetOffset:SetScript("OnFinished", function(anim)
		anim:GetParent().SlideIn.SlideIn:SetOffset(0, 60)
		anim:GetParent().SlideIn.SlideIn:Play()
	end)

	self.bar.SlideIn.SlideIn = self.bar.SlideIn.SlideIn or MER:CreateAnimationGroup(self.bar):CreateAnimation("Move")
	self.bar.SlideIn.SlideIn:SetEasing("out-quintic")
	self.bar.SlideIn.SlideIn:SetDuration(iconFade)
end

function module:OnShowEvent()
	self:StopAllAnimations()

	local animationsAllowed = (self.db.animations) and (not InCombatLockdown()) and (not self.combatLock)

	if (animationsAllowed) then
		self:SetupBarAnim()
		self.bar.SlideIn.ResetOffset:Play()

		for i, button in ipairs(self.bar.buttons) do
			self:SetupButtonAnim(button, i)
		end
	end

	for _, button in ipairs(self.bar.buttons) do
		if (animationsAllowed) then
			button:SetAlpha(0)
			button.FadeIn:Play()
		else
			button:SetAlpha(1)
		end
	end
end

function module:UpdateBar()
	-- Vars
	local size = 40
	local spacing = 2

	-- Create or get bar
	local bar = self.bar or CreateFrame("Frame", "MER_VehicleBar", E.UIParent, "SecureHandlerStateTemplate, BackdropTemplate")

	-- Default position
	local point, anchor, attachTo, x, y = split(",", self.db.position)
	bar:Point(point, anchor, attachTo, x, y)

	-- Set bar vars
	self.bar = bar
	self.bar.id = 1

	-- Page Handling
	bar:SetAttribute("_onstate-page", [[
		if HasTempShapeshiftActionBar() and self:GetAttribute("hasTempBar") then
			newstate = GetTempShapeshiftBarIndex() or newstate
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
	]])

	bar:CreateBackdrop(AB.db.transparent and 'Transparent', nil, nil, nil, nil, nil, nil, nil, 0)
	if bar.backdrop then
		bar.backdrop:Styling()
	end

	-- Create Buttons
	if not bar.buttons then
		bar.buttons = {}

		for i = 1, 7 do
			local buttonIndex = i == 7 and 12 or i

			-- Create button
			local button = LAB:CreateButton(buttonIndex, "MER_VehicleBarButton" .. buttonIndex, bar, nil)

			-- Set state aka actions
			button:SetState(0, "action", buttonIndex)

			for k = 1, 14 do
				button:SetState(k, "action", (k - 1) * 12 + buttonIndex)
			end

			if (buttonIndex == 12) then
				button:SetState(12, "custom", AB.customExitButton)
			end

			-- Style
			AB:StyleButton(button, nil, MasqueGroup and E.private.actionbar.masque.actionbars)
			button:SetTemplate("Transparent")
			button:SetCheckedTexture("")

			-- Add to array
			bar.buttons[i] = button
		end
	end

	-- Calculate Bar Width/Height
	bar:Width((size * 7) + (spacing * (7 - 1)) + 4)
	bar:Height(size + 4)

	-- Update button position and size
	for i, button in ipairs(bar.buttons) do
		button:Size(size)
		button:ClearAllPoints()

		if (i == 1) then
			button:SetPoint("BOTTOMLEFT", 2, 2)
		else
			button:SetPoint("LEFT", bar.buttons[i - 1], "RIGHT", spacing, 0)
		end
	end

	--! Did not test the masque stuff tbh (Yolo)
	if MasqueGroup and E.private.actionbar.masque.actionbars then
		MasqueGroup:ReSkin()

		-- masque retrims them all so we have to too
		for btn in pairs(AB.handledbuttons) do
			AB:TrimIcon(btn, true)
		end
	end

	-- Update Paging
	local pageAttribute = AB:GetPage("bar1", 1, format("[overridebar] %d; [vehicleui] %d; [possessbar] %d; [shapeshift] 13;", GetOverrideBarIndex(), GetVehicleBarIndex(), GetVehicleBarIndex()))
	RegisterStateDriver(bar, "page", pageAttribute)
	self.bar:SetAttribute("page", pageAttribute)

	-- ElvUI Bar config
	AB:UpdateButtonConfig("bar1", "ACTIONBUTTON")
	AB:PositionAndSizeBar("bar1")

	-- Hook for animation
	self:SecureHookScript(bar, "OnShow", "OnShowEvent")

	-- Hide
	bar:Hide()
end

function module:PLAYER_ENTERING_WORLD()
	self:ScheduleTimer(function()
		if InCombatLockdown() then
			self.regenEnabledInit = true
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			self:ProfileUpdate()
		end
	end, 3)
end

function module:PLAYER_REGEN_DISABLED()
	self.combatLock = true
	self:StopAllAnimations()
end

function module:PLAYER_REGEN_ENABLED()
	self.combatLock = false

	if (self.regenEnabledInit) then
		self.regenEnabledInit = false
		self:ProfileUpdate()
	end
end

function module:Disable()
	self:CancelAllTimers()
	self:UnregisterAllEvents()
	self:UnhookAll()

	if (self.Initialized) then
		self:StopAllAnimations()
		UnregisterStateDriver(self.bar, "visibility")
		UnregisterStateDriver(AB["handledBars"]["bar1"], "visibility")
		RegisterStateDriver(AB["handledBars"]["bar1"], "visibility", E.db.actionbar["bar1"].visibility)
		self.bar:Hide()
	end
end

function module:Enable()
	self:UnregisterAllEvents()

	-- Update or create bar
	self:UpdateBar()

	-- Overwrite default bar visibility
	local visibility = "[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar] hide;"

	self:Hook(AB, "PositionAndSizeBar", function(_, barName)
		local bar = AB["handledBars"][barName]
		if (E.db.actionbar[barName].enabled) and (barName == "bar1") then
			UnregisterStateDriver(bar, "visibility")
			RegisterStateDriver(bar, "visibility", visibility .. E.db.actionbar[barName].visibility)
		end
	end)

	-- Unregister/Register State Driver
	UnregisterStateDriver(self.bar, "visibility")
	UnregisterStateDriver(AB["handledBars"]["bar1"], "visibility")

	RegisterStateDriver(self.bar, "visibility", "[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar] show; hide")
	RegisterStateDriver(AB["handledBars"]["bar1"], "visibility", visibility .. E.db.actionbar["bar1"].visibility)

	-- Register Events
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
end

function module:ProfileUpdate()
	self:Disable()

	self.db = E.db.mui.actionbars.vehicleBar
	if (self.db and self.db.enable) then
		if self.Initialized then
			self:Enable()
		else
			self:Initialize(true)
		end
	end
end

function module:Initialize(worldInit)
	-- Get db
	self.db = E.db.mui.actionbars.vehicleBar
	MER:RegisterDB(self.db, "vehicleBar")

	if self.Initialized then return end
	if (not self.db) or (not self.db.enable) then return end

	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	if InCombatLockdown() then
		self.regenEnabledInit = true
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	if (not worldInit) then return end

	self.combatLock = false
	self:Enable()

	E:CreateMover(self.bar, "MER_VehicleBar", L["Vehicle Bar"], nil, nil, nil, 'ALL,MERATHILISUI', nil, 'mui,modules,actionbars,vehicleBar')

	-- Force update
	for _, button in pairs(self.bar.buttons) do
		button:UpdateAction()
	end

	-- We are done, hooray!
	self.Initialized = true
end

MER:RegisterModule(module:GetName())
