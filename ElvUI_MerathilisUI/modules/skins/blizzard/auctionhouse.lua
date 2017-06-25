local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
-- WoW API

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleAuctionhouse()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.auctionhouse ~= true or E.private.muiSkins.blizzard.auctionhouse ~= true then return end

	MERS:CreateGradient(AuctionFrame)
	MERS:CreateStripes(AuctionFrame)

	if AuctionFrameBrowse then
		AuctionFrameBrowse.bg1:Hide()
		AuctionFrameBrowse.bg2:Hide()
	end

	if AuctionFrameBid then
		AuctionFrameBid.bg:Hide()
	end

	if AuctionFrameAuctions then
		AuctionFrameAuctions.bg1:Hide()
		AuctionFrameAuctions.bg2:Hide()
	end

	local ABBD = CreateFrame("Frame", nil, AuctionProgressBar)
	ABBD:Point("TOPLEFT", -1, 1)
	ABBD:Point("BOTTOMRIGHT", 1, -1)
	ABBD:SetFrameLevel(AuctionProgressBar:GetFrameLevel()-1)
	MERS:CreateBD(ABBD, .25)

	select(14, AuctionProgressFrameCancelButton:GetRegions()):SetPoint("CENTER", 0, 2)

	local sorttabs = {
		"BrowseQualitySort",
		"BrowseLevelSort",
		"BrowseDurationSort",
		"BrowseHighBidderSort",
		"BrowseCurrentBidSort",
		"BidQualitySort",
		"BidLevelSort",
		"BidDurationSort",
		"BidBuyoutSort",
		"BidStatusSort",
		"BidBidSort",
		"AuctionsQualitySort",
		"AuctionsDurationSort",
		"AuctionsHighBidderSort",
		"AuctionsBidSort",
	}
	for _, sorttab in pairs(sorttabs) do
		_G[sorttab.."Left"]:Kill()
		_G[sorttab.."Middle"]:Kill()
		_G[sorttab.."Right"]:Kill()
	end

	hooksecurefunc("FilterButton_SetUp", function(button)
		button:SetNormalTexture("")
	end)

	BrowseCloseButton:ClearAllPoints()
	BrowseCloseButton:SetPoint("BOTTOMRIGHT", AuctionFrameBrowse, "BOTTOMRIGHT", 66, 13)
	BrowseBuyoutButton:ClearAllPoints()
	BrowseBuyoutButton:Point("RIGHT", BrowseCloseButton, "LEFT", -1, 0)
	BrowseBidButton:ClearAllPoints()
	BrowseBidButton:Point("RIGHT", BrowseBuyoutButton, "LEFT", -1, 0)
	BidBuyoutButton:ClearAllPoints()
	BidBuyoutButton:Point("RIGHT", BidCloseButton, "LEFT", -1, 0)
	BidBidButton:ClearAllPoints()
	BidBidButton:Point("RIGHT", BidBuyoutButton, "LEFT", -1, 0)
	AuctionsCancelAuctionButton:ClearAllPoints()
	AuctionsCancelAuctionButton:Point("RIGHT", AuctionsCloseButton, "LEFT", -1, 0)
	BrowsePrevPageButton:ClearAllPoints()
	BrowsePrevPageButton:Point("TOPLEFT", BrowseSearchButton, "BOTTOMLEFT", 0, -5)
	BrowseNextPageButton:ClearAllPoints()
	BrowseNextPageButton:Point("TOPRIGHT", BrowseResetButton, "BOTTOMRIGHT", 0, -5)

	-- Blizz needs to be more consistent
	BrowseBidPriceSilver:Point("LEFT", BrowseBidPriceGold, "RIGHT", 1, 0)
	BrowseBidPriceCopper:Point("LEFT", BrowseBidPriceSilver, "RIGHT", 1, 0)
	BidBidPriceSilver:Point("LEFT", BidBidPriceGold, "RIGHT", 1, 0)
	BidBidPriceCopper:Point("LEFT", BidBidPriceSilver, "RIGHT", 1, 0)
	StartPriceSilver:Point("LEFT", StartPriceGold, "RIGHT", 1, 0)
	StartPriceCopper:Point("LEFT", StartPriceSilver, "RIGHT", 1, 0)
	BuyoutPriceSilver:Point("LEFT", BuyoutPriceGold, "RIGHT", 1, 0)
	BuyoutPriceCopper:Point("LEFT", BuyoutPriceSilver, "RIGHT", 1, 0)

	local auctionhandler = CreateFrame("Frame")
	auctionhandler:RegisterEvent("NEW_AUCTION_UPDATE")
	auctionhandler:SetScript("OnEvent", function()
		local _, _, _, _, _, _, _, _, _, _, _, _, _, AuctionsItemButtonIconTexture = AuctionsItemButton:GetRegions() -- blizzard, please name your textures
		if AuctionsItemButtonIconTexture then
			AuctionsItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
			AuctionsItemButtonIconTexture:Point("TOPLEFT", 1, -1)
			AuctionsItemButtonIconTexture:Point("BOTTOMRIGHT", -1, 1)
		end
	end)
end

S:AddCallbackForAddon("Blizzard_AuctionUI", "mUIAuctionhouse", styleAuctionhouse)