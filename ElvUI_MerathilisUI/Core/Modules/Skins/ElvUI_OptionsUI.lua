local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
local InCombatLockdown = InCombatLockdown
-- GLOBALS:

local function StyleElvUIConfig()
	if InCombatLockdown() or not E.private.skins.ace3Enable then return end

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
		local r, g, b = unpack(E.media.rgbvaluecolor)
		btn:SetBackdropBorderColor(r, g, b)
		btn:SetBackdropColor(r, g, b, 0.5)
		btn.Text:SetTextColor(1, 1, 1)
	else
		btn:SetBackdropColor(0.1, 0.1, 0.1, 0.5)
		local r, g, b = unpack(E.media.bordercolor)
		btn:SetBackdropBorderColor(r, g, b, 1)
		btn.Text:SetTextColor(.9, .8, 0)
	end
end

local function Style_Ace3TabSelected(self, selected)
	local bd = self.backdrop
	if not bd then return end

	if selected then
		local r, g, b = unpack(E.media.rgbvaluecolor)
		bd:SetBackdropBorderColor(r, g, b)
		bd:SetBackdropColor(r, g, b, 0.5)
	else
		local r, g, b = unpack(E.media.bordercolor)
		bd:SetBackdropBorderColor(r, g, b, 1)
		bd:SetBackdropColor(0.1, 0.1, 0.1, 0.5)
	end
end

function MERS:StyleElvUIConfig()
	pluginInstaller()

	hooksecurefunc(E, 'ToggleOptionsUI', StyleElvUIConfig)
	hooksecurefunc(E, 'Config_CreateSeparatorLine', Style_CreateSeparatorLine)
	hooksecurefunc(E, 'Config_SetButtonColor', Style_SetButtonColor)
	hooksecurefunc(E, 'Install', StyleElvUIInstall)
	hooksecurefunc(S, 'Ace3_TabSetSelected', Style_Ace3TabSelected)
end
