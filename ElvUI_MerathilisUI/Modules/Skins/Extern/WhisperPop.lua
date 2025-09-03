local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack

local hooksecurefunc = hooksecurefunc

local function notifyButton(button)
	button:CreateBackdrop()
	module:CreateBackdropShadow(button)
	button:SetScript("OnMouseDown", nil)
	button:SetScript("OnMouseUp", nil)

	button:GetHighlightTexture():SetTexture(E.Media.Textures.White8x8)
	button:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.3)

	button:GetPushedTexture():SetTexture(E.Media.Textures.White8x8)
	button:GetPushedTexture():SetVertexColor(1, 1, 0, 0.3)

	button:GetCheckedTexture():SetTexture(E.Media.Textures.White8x8)
	button:GetCheckedTexture():SetVertexColor(1, 0.875, 0.125, 0.3)

	button.icon:SetTexCoord(unpack(E.TexCoords))
end

local function mainView(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	S:HandleCloseButton(_G.WhisperPopFrameTopCloseButton)
	S:HandleCloseButton(_G.WhisperPopFrameListDelete)
	S:HandleScrollBar(_G.WhisperPopFrameListScrollBar)
	module:ReskinIconButton(_G.WhisperPopFrameConfig, I.Media.Buttons.Setting, 14)
end

local function messageView(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	S:HandleCloseButton(_G.WhisperPopMessageFrameTopCloseButton)
	S:HandleCheckBox(_G.WhisperPopMessageFrameProtectCheck)

	S:HandleNextPrevButton(_G.WhisperPopScrollingMessageFrameButtonUp, "up", nil, true)
	S:HandleNextPrevButton(_G.WhisperPopScrollingMessageFrameButtonDown, "down", nil, true)
	module:ReskinIconButton(_G.WhisperPopScrollingMessageFrameButtonEnd, I.Media.Buttons.End, 22, -1.571)

	F.InternalizeMethod(frame, "SetPoint")
	hooksecurefunc(frame, "SetPoint", function(self, ...)
		F.Move(self, -6, 0)
	end)
end

local function optionFrame(frame)
	for _, child in pairs({ frame:GetChildren() }) do
		if child:IsObjectType("CheckButton") then
			S:HandleCheckBox(child)
			child:Size(24)
			F.Move(child, 0, -3)
		elseif child:IsObjectType("Button") then
			if child.dropdown then
				child.Button = child.toggleButton
				S:HandleDropDownBox(child, child:GetWidth())
			else
				S:HandleButton(child)
			end
		elseif child:IsObjectType("EditBox") then
			S:HandleEditBox(child)
		elseif child:IsObjectType("Slider") then
			S:HandleSliderFrame(child)
		end
	end
end

function module:WhisperPop()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.whisperPop then
		return
	end

	self:DisableAddOnSkins("WhisperPop")

	if _G.WhisperPop then
		mainView(_G.WhisperPop.frame)
		messageView(_G.WhisperPop.messageFrame)
		notifyButton(_G.WhisperPop.notifyButton)
		optionFrame(_G.WhisperPop.optionFrame)
	end
end

module:AddCallbackForAddon("WhisperPop")
