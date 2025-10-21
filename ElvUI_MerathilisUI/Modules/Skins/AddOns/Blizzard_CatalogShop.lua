local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

function module:Blizzard_CatalogShop()
	if not module:CheckDB("catalogShop", "catalogShop") then
		return
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
end

module:AddCallback("Blizzard_CatalogShop")
