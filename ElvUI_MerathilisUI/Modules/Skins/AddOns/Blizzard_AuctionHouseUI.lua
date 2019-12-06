local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.auctionhouse ~= true or E.private.muiSkins.blizzard.auctionhouse ~= true then return end

	local Frame = _G.AuctionHouseFrame
	Frame:Styling()

	local ItemBuyFrame = Frame.ItemBuyFrame
	MERS:CreateGradient(ItemBuyFrame.ItemDisplay.backdrop)
	MERS:CreateGradient(ItemBuyFrame.ItemList.backdrop)

	local CommoditiesBuyFrame = Frame.CommoditiesBuyFrame
	MERS:CreateGradient(CommoditiesBuyFrame.BuyDisplay.ItemDisplay.backdrop)
	MERS:CreateGradient(CommoditiesBuyFrame.ItemList.backdrop)

	local ItemSellFrame = Frame.ItemSellFrame
	MERS:CreateGradient(ItemSellFrame.ItemDisplay.backdrop)
	MERS:CreateGradient(Frame.ItemSellList.ScrollFrame.backdrop)

	local AuctionsFrame = _G.AuctionHouseFrameAuctionsFrame
	MERS:CreateGradient(AuctionsFrame.ItemDisplay.backdrop)
	MERS:CreateGradient(AuctionsFrame.ItemList.ScrollFrame.backdrop)
	MERS:CreateGradient(AuctionsFrame.CommoditiesList.ScrollFrame.backdrop)
end

S:AddCallbackForAddon("Blizzard_AuctionHouseUI", "mUIAuctionhouse", LoadSkin)
