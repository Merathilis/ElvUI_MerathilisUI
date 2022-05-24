local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_AuctionHouseUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.auctionhouse ~= true or E.private.mui.skins.blizzard.auctionhouse ~= true then return end

	local Frame = _G.AuctionHouseFrame
	Frame:Styling()
	MER:CreateShadow(Frame)
	MER:CreateShadow(Frame.WoWTokenResults.GameTimeTutorial)

	local ItemBuyFrame = Frame.ItemBuyFrame
	module:CreateGradient(ItemBuyFrame.ItemDisplay)
	module:CreateGradient(ItemBuyFrame.ItemList)

	local CommoditiesBuyFrame = Frame.CommoditiesBuyFrame
	module:CreateGradient(CommoditiesBuyFrame.BuyDisplay.ItemDisplay)
	module:CreateGradient(CommoditiesBuyFrame.ItemList)

	local ItemSellFrame = Frame.ItemSellFrame
	module:CreateGradient(ItemSellFrame.ItemDisplay)
	module:CreateGradient(Frame.ItemSellList.ScrollFrame)

	local AuctionsFrame = _G.AuctionHouseFrameAuctionsFrame
	module:CreateGradient(AuctionsFrame.ItemDisplay)
	module:CreateGradient(AuctionsFrame.ItemList.ScrollFrame)
	module:CreateGradient(AuctionsFrame.CommoditiesList.ScrollFrame)
end

module:AddCallbackForAddon("Blizzard_AuctionHouseUI")
