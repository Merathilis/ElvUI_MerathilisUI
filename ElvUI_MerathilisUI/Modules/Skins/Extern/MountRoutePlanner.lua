local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G

local TEX_PREFIX = "Interface\\AddOns\\MountRoutePlanner\\Assets\\"

local function trySkin(func)
	return function(button)
		if button.__MER then
			return
		end

		if func(button) ~= false then
			button.__MER = true
		end
	end
end
local function reskinTextButton(button)
	if not button.Text then
		return false
	end

	S:HandleButton(button)

	if MER.ChineseLocale then
		button:SetWidth(80)
	end
end

local function reskinIconButton(button, icon, size)
	button:StripTextures()
	button.Icon = button:CreateTexture(nil, "ARTWORK")
	button.Icon:SetTexture(icon)
	button.Icon:Size(size, size)
	button.Icon:Point("CENTER")

	button:HookScript("OnEnter", function(self)
		self.Icon:SetVertexColor(E.media.rgbvaluecolor.r, E.media.rgbvaluecolor.g, E.media.rgbvaluecolor.b)
	end)
	button:HookScript("OnLeave", function(self)
		self.Icon:SetVertexColor(1, 1, 1)
	end)
end

local function closeButton(button)
	if not module:IsTexturePathEqual(button:GetNormalTexture(), TEX_PREFIX .. "Frame_Close.tga") then
		return false
	end

	S:HandleCloseButton(button)
end

local function settingButton(button)
	if not module:IsTexturePathEqual(button:GetNormalTexture(), TEX_PREFIX .. "Frame_Settings.tga") then
		return false
	end

	reskinIconButton(button, I.Media.Buttons.Setting, 14)
end

local function resetButton(button)
	if not module:IsTexturePathEqual(button:GetNormalTexture(), TEX_PREFIX .. "Frame_Reset.tga") then
		return false
	end

	reskinIconButton(button, I.Media.Buttons.Start, 18)
end

local function discordButton(button)
	if not module:IsTexturePathEqual(button:GetNormalTexture(), TEX_PREFIX .. "Frame_Discord.tga") then
		return false
	end

	reskinIconButton(button, I.Media.Buttons.Discord, 15)
end

local function mountButton(button)
	local width, height = button:GetSize()
	if not width or not height or abs(width - 32) > 0.01 or abs(height - 32) > 0.01 then
		return false
	end

	button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	button:GetHighlightTexture():SetTexCoord(unpack(E.TexCoords))
	button:CreateBackdrop()
end

local function actionButton(button)
	local width, height = button:GetSize()
	if not width or not height or abs(width - 40) > 0.01 or abs(height - 40) > 0.01 then
		return false
	end

	button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	button:GetHighlightTexture():SetTexCoord(unpack(E.TexCoords))
	button:SetTemplate()
end

function module:MountRoutePlanner()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.mrp then
		return
	end

	local frame = _G.MRPFrame
	if not frame then
		return
	end

	frame:SetTemplate("Transparent")
	self:CreateShadow(frame)

	frame.progressBar:SetTexture(E.media.normTex)
	frame.progressBar:SetVertexColor(MER.Utilities.Color.RGBFromTemplate("success"))
	frame.progressBarBG:Kill()
	frame.progressBar:CreateBackdrop()
	frame.progressBar.backdrop:SetAllPoints(frame.progressBarBG)

	for _, region in pairs({ frame:GetRegions() }) do
		if region.GetObjectType and region:GetObjectType() == "FontString" then
			F.SetFontOutline(region)
		end
	end

	for _, child in pairs({ frame:GetChildren() }) do
		local objectType = child.GetObjectType and child:GetObjectType()
		if objectType == "Button" then
			trySkin(discordButton)(child)
			trySkin(resetButton)(child)
			trySkin(settingButton)(child)
			trySkin(closeButton)(child)
			trySkin(reskinTextButton)(child)
			trySkin(actionButton)(child)
		elseif objectType == "CheckButton" then
			S:HandleCheckBox(child)
			child:Size(24, 24)
		end
	end

	local waitForUpdate = false

	hooksecurefunc(frame.stepText, "SetText", function()
		if frame.rewardIcons then
			for _, button in pairs(frame.rewardIcons) do
				trySkin(mountButton)(button)
			end
		end
	end)
end

module:AddCallbackForAddon("MountRoutePlanner")
