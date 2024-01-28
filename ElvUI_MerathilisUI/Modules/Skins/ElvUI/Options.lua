local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local unpack = unpack

local InCombatLockdown = InCombatLockdown

local function StyleElvUIConfig()
	if InCombatLockdown() or not E.private.skins.ace3Enable then return end

	local frame = E:Config_GetWindow()
	-- Shadow & Styling handled via Ace3 Skin

	if frame and not frame.__MERSkin then
		if frame.leftHolder then
			frame.leftHolder.slider:SetThumbTexture(E.media.normTex)
			frame.leftHolder.slider.thumb:SetVertexColor(unpack(E.media.rgbvaluecolor))
			frame.leftHolder.slider.thumb:SetAlpha(1)
		end

		frame.__MERSkin = true
	end
end

local function StyleElvUIInstall()
	if InCombatLockdown() then return end

	local frame = _G.ElvUIInstallFrame
	if frame then
		module:CreateShadow(frame)
	end
end

local function StyleSeparatorLine(self, frame, lastButton)
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

local function ElvUI_SkinMoverPopup()
	if not _G.ElvUIMoverPopupWindow then
		return
	end

	module:CreateShadow(_G.ElvUIMoverPopupWindow)
	module:CreateShadow(_G.ElvUIMoverPopupWindow.header)
end

local function Skin_ElvUI_Options()
	if not E.private.mui.skins.enable then
		return
	end

	module:SecureHook(E, "ToggleOptions", StyleElvUIConfig)

	if _G.ElvUIInstallFrame then
		module:CreateShadow(_G.ElvUIInstallFrame)
	else
		module:SecureHook(E, "Install", StyleElvUIInstall)
	end

	module:SecureHook(E, "Config_CreateSeparatorLine", StyleSeparatorLine)

	module:SecureHook(E, "ToggleMoveMode", ElvUI_SkinMoverPopup)
end

S:AddCallback("ElvUI_Options", Skin_ElvUI_Options)
