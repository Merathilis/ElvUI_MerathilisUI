local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")
local MERS = MER:GetModule("muiSkins")

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
local InCombatLockdown = InCombatLockdown
-- GLOBALS:

local function StyleElvUIConfig()
	if InCombatLockdown() or not E.private.skins.ace3.enable then return end

	local frame = E:Config_GetWindow()

	if frame and not frame.IsStyled then
		frame:Styling()

		if frame.leftHolder then
			frame.leftHolder.slider:SetThumbTexture(E.media.normTex)
			frame.leftHolder.slider.thumb:SetVertexColor(unpack(E.media.rgbvaluecolor))
			frame.leftHolder.slider.thumb:SetAlpha(1)
		end

		frame.IsStyled = true
	end
end

local function StyleElvUIInstall()
	if InCombatLockdown() then return end

	local frame = _G.ElvUIInstallFrame
	if frame and not frame.IsStyled then
		frame:Styling()
		frame.IsStyled = true
	end
end

local function pluginInstaller()
	if _G.PluginInstallFrame then
		_G.PluginInstallFrame:Styling()
		_G.PluginInstallTitleFrame:Styling()
	end
end

local function StyleAce3Tooltip(self)
	if not self or self:IsForbidden() then return end
	if not self.styling then
		self:Styling()
	end
end

local function Style_CreateSeparatorLine(self, frame, lastButton)
	if frame.leftHolder then
		local line = frame.leftHolder.buttons:CreateTexture()
		line:SetTexture(E.Media.Textures.White8x8)
		line:SetVertexColor(unpack(E.media.rgbvaluecolor))
		line:Size(179, 2)
		line:Point("TOP", lastButton, "BOTTOM", 0, -6)
		line.separator = true
		return line
	end
end

local function Style_SetButtonColor(self, btn, disabled)
	if disabled then
		btn:Disable()
		btn:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
		btn:SetBackdropColor(unpack(E.media.rgbvaluecolor))
		btn.Text:SetTextColor(1, 1, 1)
		E:Config_SetButtonText(btn, true)
	else
		btn:Enable()
		btn:SetBackdropColor(unpack(E.media.backdropcolor))
		local r, g, b = unpack(E.media.bordercolor)
		btn:SetBackdropBorderColor(r, g, b, 1)
		btn.Text:SetTextColor(.9, .8, 0)
		E:Config_SetButtonText(btn)
	end
end

local function Style_Ace3TabSelected(self, selected)
	local bd = self.backdrop
	if not bd then return end

	if selected then
		bd:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
		bd:SetBackdropColor(unpack(E.media.rgbvaluecolor))
	else
		local r, g, b = unpack(E.media.bordercolor)
		bd:SetBackdropBorderColor(r, g, b, 1)
		r, g, b = unpack(E.media.backdropcolor)
		bd:SetBackdropColor(r, g, b, 1)
	end
end

function MERS:StyleElvUIConfig()
	pluginInstaller()

	hooksecurefunc(E, 'ToggleOptionsUI', StyleElvUIConfig)
	hooksecurefunc(E, 'Config_CreateSeparatorLine', Style_CreateSeparatorLine)
	hooksecurefunc(E, 'Config_SetButtonColor', Style_SetButtonColor)
	hooksecurefunc(E, 'Install', StyleElvUIInstall)
	hooksecurefunc(S, 'Ace3_StyleTooltip', StyleAce3Tooltip)
	hooksecurefunc(S, 'Ace3_TabSetSelected', Style_Ace3TabSelected)
end
