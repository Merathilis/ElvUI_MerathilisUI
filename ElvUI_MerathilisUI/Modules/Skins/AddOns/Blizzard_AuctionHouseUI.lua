local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_AuctionHouseUI()
	if not module:CheckDB("auctionhouse", "auctionhouse") then
		return
	end

	local Frame = _G.AuctionHouseFrame
	module:CreateShadow(Frame)
	module:CreateShadow(Frame.WoWTokenResults.GameTimeTutorial)

	local ItemBuyFrame = Frame.ItemBuyFrame
	module:CreateGradient(ItemBuyFrame.ItemDisplay)
	module:CreateGradient(ItemBuyFrame.ItemList)

	local CommoditiesBuyFrame = Frame.CommoditiesBuyFrame
	module:CreateGradient(CommoditiesBuyFrame.BuyDisplay.ItemDisplay)
	module:CreateGradient(CommoditiesBuyFrame.ItemList)

	local ItemSellFrame = Frame.ItemSellFrame
	module:CreateGradient(ItemSellFrame.ItemDisplay)
	module:CreateGradient(Frame.ItemSellList.ScrollBox)

	local AuctionsFrame = _G.AuctionHouseFrameAuctionsFrame
	module:CreateGradient(AuctionsFrame.ItemDisplay)
	module:CreateGradient(AuctionsFrame.ItemList.ScrollBox)
	module:CreateGradient(AuctionsFrame.CommoditiesList.ScrollBox)

	local tabs = { _G.AuctionHouseFrameBuyTab, _G.AuctionHouseFrameSellTab, _G.AuctionHouseFrameAuctionsTab }
	for _, tab in pairs(tabs) do
		if tab then
			module:ReskinTab(tab)
			module:CreateBackdropShadow(tab)
		end
	end
end

module:AddCallbackForAddon("Blizzard_AuctionHouseUI")
