local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

function module:Blizzard_CatalogShop()
	if not module:CheckDB("catalogShop", "catalogShop") then
		return
	end

	if E.private.skins.blizzard.tooltip and _G.CatalogShopTooltip then
		self:ReskinTooltip(_G.CatalogShopTooltip)
	end

	local CatalogShopFrame = _G.CatalogShopFrame
	if not CatalogShopFrame then
		return
	end

	self:CreateShadow(CatalogShopFrame)

	local CatalogShopDetailsFrame = CatalogShopFrame.CatalogShopDetailsFrame
	if CatalogShopDetailsFrame then
		self:CreateShadow(CatalogShopDetailsFrame)
	end

	local ProductDetailsContainerFrame = CatalogShopFrame.ProductDetailsContainerFrame
	if ProductDetailsContainerFrame then
		local BackButton = ProductDetailsContainerFrame.BackButton
		if BackButton then
			self:CreateBackdropShadow(BackButton, true)
		end
	end
end

module:AddCallback("Blizzard_CatalogShop")
