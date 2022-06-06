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

S:AddCallbackForAddon("Blizzard_AuctionHouseUI", LoadSkin)
