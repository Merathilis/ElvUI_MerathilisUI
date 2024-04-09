local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G

function module:Pawn()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.pawn then
		return
	end

	module:DisableAddOnSkins("Pawn", false)

	local Texture = "Interface\\AddOns\\Pawn\\Textures\\PawnLogo"

	S:HandleFrame(_G.PawnUIFrame, true)
	module:CreateBackdropShadow(_G.PawnUIFrame)

	S:HandleCloseButton(_G.PawnUIFrame_TinyCloseButton)
	S:HandleScrollBar(_G.PawnUIScaleSelectorScrollFrameScrollBar)

	S:HandleFrame(_G.PawnUIStringDialogSingleLine)
	S:HandleEditBox(_G.PawnUIStringDialogSingleLine.TextBox)
	S:HandleFrame(_G.PawnUIStringDialogMultiLine)
	S:HandleEditBox(_G.PawnUIStringDialogMultiLine_TextBox)

	for i = 1, _G.PawnUIFrame.numTabs do
		S:HandleTab(_G["PawnUIFrameTab" .. i])
		module:ReskinTab(_G["PawnUIFrameTab" .. i])
	end

	local buttons = {
		_G.PawnUIFrame_RenameScaleButton,
		_G.PawnUIFrame_DeleteScaleButton,
		_G.PawnUIFrame_ShowScaleCheck,
		_G.PawnUIFrame_ImportScaleButton,
		_G.PawnUIFrame_ExportScaleButton,
		_G.PawnUIFrame_CopyScaleButton,
		_G.PawnUIFrame_NewScaleFromDefaultsButton,
		_G.PawnUIFrame_NewScaleButton,
		_G.PawnUIFrame_AutoSelectScalesOnButton,
		_G.PawnUIFrame_AutoSelectScalesOffButton,
		_G.PawnUIFrame_ClearValueButton,
		_G.PawnUIFrame_CompareSwapButton,
		_G.PawnUIFrame_ResetUpgradesButton,
		_G.PawnUI_InventoryPawnButton,
		_G.PawnUIStringDialogSingleLine.OKButton,
		_G.PawnUIStringDialogSingleLine.CancelButton,
		_G.PawnUIStringDialogMultiLine.OKButton,
		_G.PawnUIStringDialogMultiLine.CancelButton,
	}

	for _, button in pairs(buttons) do
		if button then
			S:HandleButton(button)
		end
	end

	_G.PawnUI_InventoryPawnButton:SetNormalTexture(Texture)
	_G.PawnUI_InventoryPawnButton:SetSize(40, 20)
	_G.PawnUI_InventoryPawnButton:GetNormalTexture():SetTexCoord(0, 1, 0, 1)

	local checkBoxes = {
		_G.PawnUIFrame_EnchantedValuesCheck,
		_G.PawnUIFrame_ShowIconsCheck,
		_G.PawnUIFrame_ShowSpecIconsCheck,
		_G.PawnUIFrame_AlignRightCheck,
		_G.PawnUIFrame_ColorTooltipBorderCheck,
		_G.PawnUIFrame_ShowBagUpgradeAdvisorCheck,
		_G.PawnUIFrame_ShowLootUpgradeAdvisorCheck,
		_G.PawnUIFrame_ShowQuestUpgradeAdvisorCheck,
		_G.PawnUIFrame_ShowSocketingAdvisorCheck,
		_G.PawnUIFrame_IgnoreGemsWhileLevelingCheck,
		_G.PawnUIFrame_DebugCheck,
		_G.PawnUIFrame_ShowItemIDsCheck,
		_G.PawnUIFrame_ShowItemLevelUpgradesCheck,
		_G.PawnUIFrame_NormalizeValuesCheck,
	}

	for _, checkbox in pairs(checkBoxes) do
		if checkbox then
			S:HandleCheckBox(checkbox)
		end
	end

	S:HandleScrollBar(_G.PawnUIFrame_StatsListScrollBar)
	S:HandleEditBox(_G.PawnUIFrame_StatValueBox)

	S:HandleFrame(_G.PawnUICompareItemIcon1, true)
	S:HandleFrame(_G.PawnUICompareItemIcon2, true)
	S:HandleFrame(_G.PawnUIFrame_ClearItemsButton, true)
	S:HandleScrollBar(_G.PawnUICompareScrollFrameScrollBar)

	S:HandleEditBox(_G.PawnUIFrame_GemQualityLevelBox, 40, 20)
	S:HandleScrollBar(_G.PawnUIGemScrollFrameScrollBar)

	-- Tooltips
	_G.PawnCommon.ColorTooltipBorder = false
	hooksecurefunc("PawnUI_OnSocketUpdate", function()
		if _G.PawnSocketingTooltip then
			_G.PawnSocketingTooltip:StripTextures()
			_G.PawnSocketingTooltip:CreateBackdrop("Transparent")
			module:CreateBackdropShadow(_G.PawnSocketingTooltip)
		end
	end)
end

module:AddCallbackForAddon("Pawn")
