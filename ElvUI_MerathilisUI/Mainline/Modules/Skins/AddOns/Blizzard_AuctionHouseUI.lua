local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("auctionhouse", "auctionhouse") then
		return
	end

	local Frame = _G.AuctionHouseFrame
	Frame:Styling()
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

	local tabs = {_G.AuctionHouseFrameBuyTab, _G.AuctionHouseFrameSellTab, _G.AuctionHouseFrameAuctionsTab}
	for _, tab in pairs(tabs) do
		if tab then
			module:CreateBackdropShadow(tab)
		end
	end
end

S:AddCallbackForAddon("Blizzard_AuctionHouseUI", LoadSkin)
