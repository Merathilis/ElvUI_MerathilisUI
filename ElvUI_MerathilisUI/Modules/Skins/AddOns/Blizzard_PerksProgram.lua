local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_PerksProgram()
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
		module:CreateShadow(products.PerksProgramFilter)
	end

	local footer = frame.FooterFrame
	if footer then
		for _, button in pairs({
			footer.TogglePlayerPreview,
			footer.ToggleMountSpecial,
		}) do
			module:CreateShadow(button)
			if button.MERshadow then
				button.MERshadow:SetAllPoints()
			end

			F.SetFontOutline(button.Text)
		end

		module:CreateBackdropShadow(footer.RotateButtonContainer.RotateLeftButton)
		module:CreateBackdropShadow(footer.RotateButtonContainer.RotateRightButton)

		module:CreateBackdropShadow(footer.LeaveButton)
		module:CreateBackdropShadow(footer.PurchaseButton)
		module:CreateBackdropShadow(footer.RefundButton)
	end
end

module:AddCallbackForAddon("Blizzard_PerksProgram")
