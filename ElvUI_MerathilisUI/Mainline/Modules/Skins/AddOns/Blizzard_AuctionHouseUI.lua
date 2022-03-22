local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.auctionhouse ~= true or E.private.muiSkins.blizzard.auctionhouse ~= true then return end

	local Frame = _G.AuctionHouseFrame
	Frame:Styling()
	MER:CreateShadow(Frame)

	local ItemBuyFrame = Frame.ItemBuyFrame
	MERS:CreateGradient(ItemBuyFrame.ItemDisplay)
	MERS:CreateGradient(ItemBuyFrame.ItemList)

	local CommoditiesBuyFrame = Frame.CommoditiesBuyFrame
	MERS:CreateGradient(CommoditiesBuyFrame.BuyDisplay.ItemDisplay)
	MERS:CreateGradient(CommoditiesBuyFrame.ItemList)

	local ItemSellFrame = Frame.ItemSellFrame
	MERS:CreateGradient(ItemSellFrame.ItemDisplay)
	MERS:CreateGradient(Frame.ItemSellList.ScrollFrame)

	local AuctionsFrame = _G.AuctionHouseFrameAuctionsFrame
	MERS:CreateGradient(AuctionsFrame.ItemDisplay)
	MERS:CreateGradient(AuctionsFrame.ItemList.ScrollFrame)
	MERS:CreateGradient(AuctionsFrame.CommoditiesList.ScrollFrame)
end

S:AddCallbackForAddon("Blizzard_AuctionHouseUI", "mUIAuctionhouse", LoadSkin)
