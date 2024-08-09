local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")

local format = string.format

local InCombatLockdown = InCombatLockdown
local ipairs = ipairs
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

function module:OnShowEvent()
	self:StopAllAnimations()

	if self:IsVigorAvailable() then
		-- Hide the Default Vigor Bar
		local defaultVigorBar = _G["UIWidgetPowerBarContainerFrame"]
		if defaultVigorBar then
			defaultVigorBar:Hide()
		end

		local widgetInfo = self:GetWidgetInfo()
		if self.vigorBar.segments and widgetInfo then
			-- Check if we have the correct amount of segments. If not, recreate the segments.
			if #self.vigorBar.segments < widgetInfo.numTotalFrames then
				F.Developer.LogDebug("Amount of segments is wrong ~ recreating segments.")
				F.Developer.LogDebug(
					"Segments: " .. #self.vigorBar.segments .. "; Total: " .. widgetInfo.numTotalFrames
				)

				-- Clear existing segments
				for _, segment in ipairs(self.vigorBar.segments) do
					segment:Kill()
				end
				self.vigorBar.segments = {} -- Clear the table

				-- Create new segments
				self:CreateVigorSegments()
			end
		end
	end

	local animationsAllowed = self.db.animations and (not InCombatLockdown()) and not self.combatLock

	if animationsAllowed then
		for i, button in ipairs(self.bar.buttons) do
			self:SetupButtonAnim(button, i)
		end

		if self:IsVigorAvailable() and self.vigorBar and self.vigorBar.segments and self.vigorBar.speedText then
			for i, segment in ipairs(self.vigorBar.segments) do
				self:SetupButtonAnim(segment, i)
			end

			self:SetupButtonAnim(self.vigorBar.speedText, 8)
		end
	end

	for _, button in ipairs(self.bar.buttons) do
		if animationsAllowed then
			button:SetAlpha(0)
			button.FadeIn:Play()
		else
			button:SetAlpha(1)
		end
	end

	if self:IsVigorAvailable() and self.vigorBar and self.vigorBar.segments and self.vigorBar.speedText then
		for _, segment in ipairs(self.vigorBar.segments) do
			if animationsAllowed then
				segment:SetAlpha(0)
				segment.FadeIn:Play()
			else
				segment:SetAlpha(1)
			end
		end

		if animationsAllowed then
			self.vigorBar.speedText:SetAlpha(0)
			self.vigorBar.speedText.FadeIn:Play()
		else
			self.vigorBar.speedText:SetAlpha(1)
		end
	end

	if self:IsVigorAvailable() and self.vigorBar and self.vigorBar.speedText then
		self.vigorBar:Show()
		self.vigorBar.speedText:Show()
	end

	self:UpdateKeybinds()
end
function module:OnHideEvent()
	if self.vigorBar then
		self.vigorBar:Hide()
		self.vigorBar.speedText:Hide()
	end
end
function module:OnCombatEvent(toggle)
	self.combatLock = toggle
	if self.combatLock then
		self:StopAllAnimations()
	end
end
function module:Enable()
	if not self.Initialized and E.private.actionbar.enable then
		return
	end

	self:UpdateBar()

	local visibility =
		format("[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar]%s hide;", "[bonusbar:5]")

	self:Hook(self.ab, "PositionAndSizeBar", function(_, barName)
		local bar = self.ab["handledBars"][barName]
		if E.db.mui.vehicleBar.hideElvUIBars and E.db.actionbar[barName].enable and (barName == "bar1") then
			UnregisterStateDriver(bar, "visibility")
			RegisterStateDriver(bar, "visibility", visibility .. E.db.actionbar[barName].visibility)
		end
		if E.db.mui.vehicleBar.hideElvUIBars and E.db.actionbar[barName].enable and (barName == "bar2") then
			UnregisterStateDriver(bar, "visibility")
			RegisterStateDriver(bar, "visibility", visibility .. E.db.actionbar[barName].visibility)
		end
		if E.db.mui.vehicleBar.hideElvUIBars and E.db.actionbar[barName].enable and (barName == "bar3") then
			UnregisterStateDriver(bar, "visibility")
			RegisterStateDriver(bar, "visibility", visibility .. E.db.actionbar[barName].visibility)
		end
	end)

	-- Unregister/Register State Driver
	UnregisterStateDriver(self.bar, "visibility")
	UnregisterStateDriver(self.ab["handledBars"]["bar1"], "visibility")
	UnregisterStateDriver(self.ab["handledBars"]["bar2"], "visibility")
	UnregisterStateDriver(self.ab["handledBars"]["bar3"], "visibility")

	RegisterStateDriver(
		self.bar,
		"visibility",
		format("[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar]%s show; hide", "[bonusbar:5]")
	)

	if E.db.mui.vehicleBar.hideElvUIBars then
		RegisterStateDriver(self.ab["handledBars"]["bar1"], "visibility", visibility .. E.db.actionbar["bar1"].visibility)
		RegisterStateDriver(self.ab["handledBars"]["bar2"], "visibility", visibility .. E.db.actionbar["bar2"].visibility)
		RegisterStateDriver(self.ab["handledBars"]["bar3"], "visibility", visibility .. E.db.actionbar["bar3"].visibility)
	 end

	-- Register Events
	F.Event.RegisterFrameEventAndCallback("PLAYER_REGEN_ENABLED", self.OnCombatEvent, self, false)
	F.Event.RegisterFrameEventAndCallback("PLAYER_REGEN_DISABLED", self.OnCombatEvent, self, true)
end

function module:Disable()
	if not self.Initialized then
		return
	end

	self:UnhookAll()

	if self.bar then
		self:StopAllAnimations()

		if E.db.mui.vehicleBar.hideElvUIBars then
			UnregisterStateDriver(self.bar, "visibility")
			UnregisterStateDriver(self.ab["handledBars"]["bar1"], "visibility")
			RegisterStateDriver(self.ab["handledBars"]["bar1"], "visibility", E.db.actionbar["bar1"].visibility)
			UnregisterStateDriver(self.ab["handledBars"]["bar2"], "visibility")
			RegisterStateDriver(self.ab["handledBars"]["bar2"], "visibility", E.db.actionbar["bar2"].visibility)
			UnregisterStateDriver(self.ab["handledBars"]["bar3"], "visibility")
			RegisterStateDriver(self.ab["handledBars"]["bar3"], "visibility", E.db.actionbar["bar3"].visibility)
		end

		self.bar:Hide()
	end

	if self.vigorBar then
		self.vigorBar:Hide()
		if self.vigorBar.speedText then
			self.vigorBar.speedText:Hide()
		end
	end

	F.Event.UnregisterFrameEventAndCallback("PLAYER_REGEN_ENABLED", self)
	F.Event.UnregisterFrameEventAndCallback("PLAYER_REGEN_DISABLED", self)
end

function module:DatabaseUpdate()
	-- Disable
	self:Disable()

	-- Set db
	self.db = E.db.mui.vehicleBar
	self.vdb = E.db.mui.vehicleBar.vigorBar

	-- Enable only out of combat
	F.Event.ContinueOutOfCombat(function()
		if self.db and self.db.enable and E.private.actionbar.enable then
			self:Enable()
		end
	end)
end

function module:Initialize()
	if self.Initialized then
		return
	end

	-- Vars
	self.combatLock = false
	self.ab = E:GetModule("ActionBars")
	self.vigorBar = nil
	self.previousBarWidth = nil
	self.vigorHeight = 10
	self.spacing = 2

	-- Register for updates
	F.Event.RegisterOnceCallback("MER.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
	F.Event.RegisterCallback("MER.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("VehicleBar.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("VehicleBar.SettingsUpdate", self.UpdateBar, self)

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
