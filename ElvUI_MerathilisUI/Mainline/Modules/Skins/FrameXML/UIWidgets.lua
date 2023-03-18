local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local pairs, unpack = pairs, unpack

local hooksecurefunc = hooksecurefunc

local Type_StatusBar = _G.Enum.UIWidgetVisualizationType.StatusBar
local Type_CaptureBar = _G.Enum.UIWidgetVisualizationType.CaptureBar
local Type_SpellDisplay = _G.Enum.UIWidgetVisualizationType.SpellDisplay
local Type_DoubleStatusBar = _G.Enum.UIWidgetVisualizationType.DoubleStatusBar

local atlasColors = {
	["UI-Frame-Bar-Fill-Blue"] = {.2, .6, 1},
	["UI-Frame-Bar-Fill-Red"] = {.9, .2, .2},
	["UI-Frame-Bar-Fill-Yellow"] = {1, .6, 0},
	["objectivewidget-bar-fill-left"] = {.2, .6, 1},
	["objectivewidget-bar-fill-right"] = {.9, .2, .2},
	["EmberCourtScenario-Tracker-barfill"] = {.9, .2, .2},
}

local function ReplaceWidgetBarTexture(self, atlas)
	if self:IsForbidden() then return end

	if atlasColors[atlas] then
		self:SetStatusBarTexture(E.media.normTex)
		self:SetStatusBarColor(unpack(atlasColors[atlas]))
	end
end

local function ReskinWidgetStatusBar(bar)
	if not bar or bar:IsForbidden() then return end

	if bar and not bar.styled then
		if bar.BG then bar.BG:SetAlpha(0) end
		if bar.BGLeft then bar.BGLeft:SetAlpha(0) end
		if bar.BGRight then bar.BGRight:SetAlpha(0) end
		if bar.BGCenter then bar.BGCenter:SetAlpha(0) end
		if bar.BorderLeft then bar.BorderLeft:SetAlpha(0) end
		if bar.BorderRight then bar.BorderRight:SetAlpha(0) end
		if bar.BorderCenter then bar.BorderCenter:SetAlpha(0) end
		if bar.Spark then bar.Spark:SetAlpha(0) end
		if bar.SparkGlow then bar.SparkGlow:SetAlpha(0) end
		if bar.BorderGlow then bar.BorderGlow:SetAlpha(0) end

		bar:CreateBackdrop('Transparent')
		if bar.GetStatusBarTexture then
			ReplaceWidgetBarTexture(bar, bar:GetStatusBarTexture())
			hooksecurefunc(bar, "SetStatusBarTexture", ReplaceWidgetBarTexture)
		end

		bar.styled = true
	end
end

local function ReskinDoubleStatusBarWidget(self)
	if self:IsForbidden() then return end

	if not self.styled then
		ReskinWidgetStatusBar(self.LeftBar)
		ReskinWidgetStatusBar(self.RightBar)

		self.styled = true
	end
end

local function ReskinPVPCaptureBar(self)
	if self:IsForbidden() then return end

	self.LeftBar:SetTexture(E.media.normTex)
	self.NeutralBar:SetTexture(E.media.normTex)
	self.RightBar:SetTexture(E.media.normTex)

	self.LeftBar:SetVertexColor(.2, .6, 1, 1)
	self.NeutralBar:SetVertexColor(.8, .8, .8, 1)
	self.RightBar:SetVertexColor(.9, .2, .2, 1)

	self.LeftLine:SetAlpha(0)
	self.RightLine:SetAlpha(0)
	self.BarBackground:SetAlpha(0)
	self.Glow1:SetAlpha(0)
	self.Glow2:SetAlpha(0)
	self.Glow3:SetAlpha(0)

	if not self.backdrop then
		self:CreateBackdrop('Transparent')
		self.backdrop:SetPoint("TOPLEFT", self.LeftBar, -2, 2)
		self.backdrop:SetPoint("BOTTOMRIGHT", self.RightBar, 2, -2)
	end
end

local function ReskinSpellDisplayWidget(spell)
	if not spell or spell:IsForbidden() then return end

	if not spell.backdrop then
		spell.Border:SetAlpha(0)
		spell.DebuffBorder:SetAlpha(0)
		spell.backdrop = S:HandleIcon(spell.Icon)
	end
	spell.IconMask:Hide()
end

local function LoadSkin()
	if not module:CheckDB("misc", "misc") then
		return
	end

	hooksecurefunc(_G.UIWidgetTopCenterContainerFrame, "UpdateWidgetLayout", function(self)
		for _, widgetFrame in pairs(self.widgetFrames) do
			local widgetType = widgetFrame.widgetType
			if widgetType == Type_DoubleStatusBar then
				ReskinDoubleStatusBarWidget(widgetFrame)
			elseif widgetType == Type_SpellDisplay then
				ReskinSpellDisplayWidget(widgetFrame.Spell)
			elseif widgetType == Type_StatusBar then
				ReskinWidgetStatusBar(widgetFrame.Bar)
			end
		end
	end)

	hooksecurefunc(_G.UIWidgetBelowMinimapContainerFrame, "UpdateWidgetLayout", function(self)
		for _, widgetFrame in pairs(self.widgetFrames) do
			if widgetFrame.widgetType == Type_CaptureBar then
				ReskinPVPCaptureBar(widgetFrame)
			end
		end
	end)

	hooksecurefunc(_G.UIWidgetPowerBarContainerFrame, "UpdateWidgetLayout", function(self)
		for _, widgetFrame in pairs(self.widgetFrames) do
			if widgetFrame.widgetType == Type_StatusBar then
				ReskinWidgetStatusBar(widgetFrame.Bar)
			end
		end
	end)

	for _, widgetFrame in pairs(_G.UIWidgetPowerBarContainerFrame.widgetFrames) do
		if not widgetFrame:IsForbidden() then
			ReskinWidgetStatusBar(widgetFrame.Bar)
		end
	end

	hooksecurefunc(_G.TopScenarioWidgetContainerBlock.WidgetContainer, "UpdateWidgetLayout", function(self)
		for _, widgetFrame in pairs(self.widgetFrames) do
			if widgetFrame.widgetType == Type_StatusBar then
				ReskinWidgetStatusBar(widgetFrame.Bar)
			end
		end
	end)

	hooksecurefunc(_G.BottomScenarioWidgetContainerBlock.WidgetContainer, "UpdateWidgetLayout", function(self)
		for _, widgetFrame in pairs(self.widgetFrames) do
			if widgetFrame.widgetType == Type_SpellDisplay then
				ReskinSpellDisplayWidget(widgetFrame.Spell)
			end
		end
	end)

	hooksecurefunc(_G.UIWidgetTemplateStatusBarMixin, "Setup", function(self)
		ReskinWidgetStatusBar(self.Bar)
	end)

	module:SecureHook(S, "SkinStatusBarWidget", function(_, widgetFrame)
		if widgetFrame.Label then
			F.SetFontOutline(widgetFrame.Label)
		end
		if widgetFrame.Bar then
			module:CreateBackdropShadow(widgetFrame.Bar)
			if widgetFrame.Bar.Label then
				F.SetFontOutline(widgetFrame.Bar.Label)
			end
		end
	end)

	module:SecureHook(_G.UIWidgetTemplateStatusBarMixin, "Setup", function(widget)
		local forbidden = widget:IsForbidden()
		local bar = widget.Bar
		local id = widget.widgetSetID

		if forbidden or id == 283 or not bar or not bar.backdrop then
			return
		end

		module:CreateBackdropShadow(bar)

		if widget.isJailersTowerBar and module:CheckDB(nil, "scenario") then
			bar:SetWidth(234)
		end
	end)

	module:SecureHook(_G.UIWidgetTemplateCaptureBarMixin, "Setup", function(widget)
		local bar = widget.Bar
		if bar then
			module:CreateBackdropShadow(bar)
		end
	end)

	module:RawHook(S, "SkinTextWithStateWidget", function(_, widgetFrame)
		local text = widgetFrame.Text
		if not text then
			return
		end
		F.SetFontOutline(text)
		text:SetTextColor(1, 1, 1)
	end, true)
end

S:AddCallback("UIWidgets", LoadSkin)
