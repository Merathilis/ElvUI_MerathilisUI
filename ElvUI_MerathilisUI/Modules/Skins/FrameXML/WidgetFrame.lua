local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
local pairs, unpack = pairs, unpack
--WoW API / Variables
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true then return end

	local AtlasColors = {
		["UI-Frame-Bar-Fill-Blue"] = {.2, .6, 1},
		["UI-Frame-Bar-Fill-Red"] = {.9, .2, .2},
		["UI-Frame-Bar-Fill-Yellow"] = {1, .6, 0},
		["objectivewidget-bar-fill-left"] = {.2, .6, 1},
		["objectivewidget-bar-fill-right"] = {.9, .2, .2}
	}

	local function UpdateBarTexture(self, atlas)
		if AtlasColors[atlas] then
			self:SetStatusBarTexture(E.media.normTex)
			self:SetStatusBarColor(unpack(AtlasColors[atlas]))
		end
	end

	local Type_DoubleStatusBar = _G.Enum.UIWidgetVisualizationType.DoubleStatusBar
	local Type_SpellDisplay = _G.Enum.UIWidgetVisualizationType.SpellDisplay

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("UPDATE_ALL_UI_WIDGETS")
	frame:SetScript("OnEvent", function()
		for _, widgetFrame in pairs(_G.UIWidgetTopCenterContainerFrame.widgetFrames) do
			if widgetFrame.widgetType == Type_DoubleStatusBar then
				if not widgetFrame.styled then
					for _, bar in pairs({widgetFrame.LeftBar, widgetFrame.RightBar}) do
						bar.BG:SetAlpha(0)
						bar.BorderLeft:SetAlpha(0)
						bar.BorderRight:SetAlpha(0)
						bar.BorderCenter:SetAlpha(0)
						bar.Spark:SetAlpha(0)
						bar.SparkGlow:SetAlpha(0)
						bar.BorderGlow:SetAlpha(0)
						MERS:CreateBD(bar)
						hooksecurefunc(bar, "SetStatusBarAtlas", UpdateBarTexture)
					end

					widgetFrame.styled = true
				end
			elseif widgetFrame.widgetType == Type_SpellDisplay then
				if not widgetFrame.styled then
					local widgetSpell = widgetFrame.Spell
					widgetSpell.IconMask:Hide()
					widgetSpell.Border:SetTexture(nil)
					widgetSpell.DebuffBorder:SetTexture(nil)
					S:HandleIcon(widgetSpell.Icon)

					widgetFrame.styled = true
				end
			end
		end
	end)

	hooksecurefunc(_G.UIWidgetTemplateCaptureBarMixin, "Setup", function(self)
		self.LeftLine:SetAlpha(0)
		self.RightLine:SetAlpha(0)
		self.BarBackground:SetAlpha(0)
		self.Glow1:SetAlpha(0)
		self.Glow2:SetAlpha(0)
		self.Glow3:SetAlpha(0)

		self.LeftBar:SetTexture(E.media.normTex)
		self.NeutralBar:SetTexture(E.media.normTex)
		self.RightBar:SetTexture(E.media.normTex)

		self.LeftBar:SetVertexColor(.2, .6, 1)
		self.NeutralBar:SetVertexColor(.8, .8, .8)
		self.RightBar:SetVertexColor(.9, .2, .2)
	end)

	hooksecurefunc(_G.UIWidgetTemplateStatusBarMixin, "Setup", function(self)
		local bar = self.Bar
		local atlas = bar:GetStatusBarAtlas()
		UpdateBarTexture(bar, atlas)

		if not bar.styled then
			bar.BGLeft:SetAlpha(0)
			bar.BGRight:SetAlpha(0)
			bar.BGCenter:SetAlpha(0)
			bar.BorderLeft:SetAlpha(0)
			bar.BorderRight:SetAlpha(0)
			bar.BorderCenter:SetAlpha(0)
			bar.Spark:SetAlpha(0)
			MERS:CreateBD(bar)

			bar.styled = true
		end
	end)

	hooksecurefunc(_G.UIWidgetTemplateScenarioHeaderCurrenciesAndBackgroundMixin, "Setup", function(widgetInfo)
		widgetInfo.Frame:SetAlpha(0)
	end)
end

S:AddCallback("MER_WidgetFrame", LoadSkin)
