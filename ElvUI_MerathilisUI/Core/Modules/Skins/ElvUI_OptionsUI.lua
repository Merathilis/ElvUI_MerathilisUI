local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G
local unpack = unpack

local InCombatLockdown = InCombatLockdown

function module:StyleElvUIConfig()
	if InCombatLockdown() or not E.private.skins.ace3Enable then return end

	local frame = E:Config_GetWindow()

	if frame and not frame.IsStyled then
		frame:Styling()
		MER:CreateShadow(frame)

		if frame.leftHolder then
			frame.leftHolder.slider:SetThumbTexture(E.media.normTex)
			frame.leftHolder.slider.thumb:SetVertexColor(unpack(E.media.rgbvaluecolor))
			frame.leftHolder.slider.thumb:SetAlpha(1)
		end

		frame.IsStyled = true
	end
end

function module:StyleElvUIInstall()
	if InCombatLockdown() then return end

	local frame = _G.ElvUIInstallFrame
	if frame then
		frame:Styling()
		MER:CreateShadow(frame)
	end
end

function module:StyleSeparatorLine(self, frame, lastButton)
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

function module:ElvUI_OptionsUI()
	if not E.private.mui.skins.enable then
		return
	end

	self:SecureHook(E, "ToggleOptionsUI", "StyleElvUIConfig")

	if _G.PluginInstallFrame then
		_G.PluginInstallFrame:Styling()
		_G.PluginInstallTitleFrame:Styling()
	end

	if _G.ElvUIInstallFrame then
		_G.ElvUIInstallFrame:Styling()
		MER:CreateShadow(_G.ElvUIInstallFrame)
	else
		self:SecureHook(E, "Install", "StyleElvUIInstall")
	end

	self:SecureHook(E, "Config_CreateSeparatorLine", "StyleSeparatorLine")
end

module:AddCallback("ElvUI_OptionsUI")