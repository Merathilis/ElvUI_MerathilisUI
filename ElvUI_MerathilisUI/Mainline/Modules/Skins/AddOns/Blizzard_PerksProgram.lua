local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("perks", "perksProgram") then
		return
	end

	local frame = _G.PerksProgramFrame
	local products = frame.ProductsFrame

	if products then
		module:CreateShadow(products.PerksProgramFilter.FilterDropDownButton)
		products.PerksProgramCurrencyFrame.Icon:CreateBackdrop()
		module:CreateBackdropShadow(products.PerksProgramCurrencyFrame.Icon)

		module:CreateShadow(products.ProductsScrollBoxContainer)
		module:CreateShadow(products.PerksProgramProductDetailsContainerFrame)
	end

	local footer = frame.FooterFrame
	if footer then
		module:CreateShadow(footer.TogglePlayerPreview)
		footer.TogglePlayerPreview.MERshadow:SetAllPoints()

		module:CreateBackdropShadow(footer.RotateButtonContainer.RotateLeftButton)
		module:CreateBackdropShadow(footer.RotateButtonContainer.RotateRightButton)

		module:CreateBackdropShadow(footer.LeaveButton)
		module:CreateBackdropShadow(footer.PurchaseButton)
		module:CreateBackdropShadow(footer.RefundButton)
	end
end

S:AddCallbackForAddon("Blizzard_PerksProgram", LoadSkin)
