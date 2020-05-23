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

	local atlasColors = {
		["UI-Frame-Bar-Fill-Blue"] = {.2, .6, 1},
		["UI-Frame-Bar-Fill-Red"] = {.9, .2, .2},
		["UI-Frame-Bar-Fill-Yellow"] = {1, .6, 0},
		["objectivewidget-bar-fill-left"] = {.2, .6, 1},
		["objectivewidget-bar-fill-right"] = {.9, .2, .2}
	}

	local function updateBarTexture(self, atlas)
		if atlasColors[atlas] then
			self:SetStatusBarTexture(E.media.normTex)
			self:SetStatusBarColor(unpack(atlasColors[atlas]))
		end
	end

	local doubleBarType = _G.Enum.UIWidgetVisualizationType.DoubleStatusBar
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("UPDATE_ALL_UI_WIDGETS")
	frame:SetScript("OnEvent", function()
		for _, widgetFrame in pairs(_G.UIWidgetTopCenterContainerFrame.widgetFrames) do
			if widgetFrame.widgetType == doubleBarType then
				for _, bar in pairs({widgetFrame.LeftBar, widgetFrame.RightBar}) do
					if not bar.styled then
						bar.BG:SetAlpha(0)
						bar.BorderLeft:SetAlpha(0)
						bar.BorderRight:SetAlpha(0)
						bar.BorderCenter:SetAlpha(0)
						bar.Spark:SetAlpha(0)
						bar.SparkGlow:SetAlpha(0)
						bar.BorderGlow:SetAlpha(0)
						MERS:CreateBD(bar)
						hooksecurefunc(bar, "SetStatusBarAtlas", updateBarTexture)

						bar.styled = true
					end
				end
			end
		end
	end)

	hooksecurefunc(_G.UIWidgetTemplateCaptureBarMixin, "Setup", function(widgetInfo)
		widgetInfo.LeftLine:SetAlpha(0)
		widgetInfo.RightLine:SetAlpha(0)
		widgetInfo.BarBackground:SetAlpha(0)
		widgetInfo.Glow1:SetAlpha(0)
		widgetInfo.Glow2:SetAlpha(0)
		widgetInfo.Glow3:SetAlpha(0)

		widgetInfo.LeftBar:SetTexture(E.media.normTex)
		widgetInfo.NeutralBar:SetTexture(E.media.normTex)
		widgetInfo.RightBar:SetTexture(E.media.normTex)

		widgetInfo.LeftBar:SetVertexColor(.2, .6, 1)
		widgetInfo.NeutralBar:SetVertexColor(.8, .8, .8)
		widgetInfo.RightBar:SetVertexColor(.9, .2, .2)

		if not widgetInfo.bg then
			widgetInfo.bg = MERS:CreateBD(widgetInfo)
			widgetInfo.bg:Point("TOPLEFT", widgetInfo.LeftBar, -2, 2)
			widgetInfo.bg:Point("BOTTOMRIGHT", widgetInfo.RightBar, 2, -2)
		end
	end)

	hooksecurefunc(_G.UIWidgetTemplateStatusBarMixin, "Setup", function(widgetInfo)
		local bar = widgetInfo.Bar
		local atlas = bar:GetStatusBarAtlas()
		updateBarTexture(bar, atlas)

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
