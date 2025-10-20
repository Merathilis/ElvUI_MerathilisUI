local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

function module:Blizzard_CatalogShop()
	if not module:CheckDB("catalogShop", "catalogShop") then
		return
	end

	local ShopFrame = _G.CatalogShopFrame
	module:CreateShadow(ShopFrame)
end

module:AddCallback("Blizzard_CatalogShop")
