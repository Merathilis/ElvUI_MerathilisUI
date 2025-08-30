local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G
local pairs = pairs

function module:WorldQuestTab()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.wowLua then
		return
	end

	self:DisableAddOnSkins("WowLua", true)

	local frame = _G.WowLuaFrame
	if not frame then
		return
	end

	S:HandlePortraitFrame(frame)
	S:HandleCloseButton(_G.WowLuaButton_Close)
	_G.WowLuaFrameTitle:Point("TOP", 15, -5)
	_G.WowLuaButton_Close:Point("TOPRIGHT", -5, -5)
	module:CreateShadow(frame)

	_G.WowLuaFrameResizeBar:StripTextures()
	S:HandleScrollBar(_G.WowLuaFrameEditScrollFrameScrollBar)

	_G.WowLuaFrameLineNumScrollFrame:DisableDrawLayer("ARTWORK")
	_G.WowLuaFrameLineNumScrollFrame:CreateBackdrop("Transparent")
	_G.WowLuaFrameLineNumScrollFrame.backdrop:Point("TOPLEFT", -1, 3)
	_G.WowLuaFrameLineNumScrollFrame.backdrop:Point("BOTTOMRIGHT", -2, -2)

	_G.WowLuaFrameEditFocusGrabber:CreateBackdrop("Transparent")
	_G.WowLuaFrameEditFocusGrabber.backdrop:Point("BOTTOMRIGHT", 6, -6)

	_G.WowLuaFrameOutput:CreateBackdrop("Transparent")
	_G.WowLuaFrameOutput.backdrop:Point("TOPLEFT", -2, 1)
	_G.WowLuaFrameOutput.backdrop:Point("BOTTOMRIGHT", -20, -2)

	_G.WowLuaFrameCommand:DisableDrawLayer("BACKGROUND")
	_G.WowLuaButton_New:Point("LEFT", -30, 5)

	local buttons = {
		_G.WowLuaButton_New,
		_G.WowLuaButton_Open,
		_G.WowLuaButton_Save,
		_G.WowLuaButton_Undo,
		_G.WowLuaButton_Redo,
		_G.WowLuaButton_Delete,
		_G.WowLuaButton_Lock,
		_G.WowLuaButton_Unlock,
		_G.WowLuaButton_Config,
		_G.WowLuaButton_Previous,
		_G.WowLuaButton_Next,
		_G.WowLuaButton_Run,
	}

	for _, object in pairs(buttons) do
		object:CreateBackdrop()
		S:HandleIcon(object:GetNormalTexture())
		if object:GetDisabledTexture() then
			S:HandleIcon(object:GetDisabledTexture())
		end
		object:StyleButton()
		object:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
	end
end

module:AddCallbackForAddon("WorldQuestTab")
