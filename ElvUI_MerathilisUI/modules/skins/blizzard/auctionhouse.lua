local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local select, pairs = select, pairs
-- WoW API
local CreateFrame = CreateFrame
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc

local function styleAuctionhouse()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.auctionhouse ~= true or E.private.muiSkins.blizzard.auctionhouse ~= true then return end

	_G["AuctionFrame"]:Styling(true, true)

	if _G["AuctionFrameBrowse"] then
		_G["AuctionFrameBrowse"].bg1:Hide()
		_G["AuctionFrameBrowse"].bg2:Hide()
	end

	if _G["AuctionFrameBid"] then
		_G["AuctionFrameBid"].bg:Hide()
	end

	if _G["AuctionFrameAuctions"] then
		_G["AuctionFrameAuctions"].bg1:Hide()
		_G["AuctionFrameAuctions"].bg2:Hide()
	end

	local ABBD = CreateFrame("Frame", nil, _G["AuctionProgressBar"])
	ABBD:Point("TOPLEFT", -1, 1)
	ABBD:Point("BOTTOMRIGHT", 1, -1)
	ABBD:SetFrameLevel(_G["AuctionProgressBar"]:GetFrameLevel()-1)
	MERS:CreateBD(ABBD, .25)

	select(14, _G["AuctionProgressFrameCancelButton"]:GetRegions()):SetPoint("CENTER", 0, 2)

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

	_G["BrowseCloseButton"]:ClearAllPoints()
	_G["BrowseCloseButton"]:SetPoint("BOTTOMRIGHT", _G["AuctionFrameBrowse"], "BOTTOMRIGHT", 66, 13)
	_G["BrowseBuyoutButton"]:ClearAllPoints()
	_G["BrowseBuyoutButton"]:Point("RIGHT", _G["BrowseCloseButton"], "LEFT", -1, 0)
	_G["BrowseBidButton"]:ClearAllPoints()
	_G["BrowseBidButton"]:Point("RIGHT", _G["BrowseBuyoutButton"], "LEFT", -1, 0)
	_G["BidBuyoutButton"]:ClearAllPoints()
	_G["BidBuyoutButton"]:Point("RIGHT", _G["BidCloseButton"], "LEFT", -1, 0)
	_G["BidBidButton"]:ClearAllPoints()
	_G["BidBidButton"]:Point("RIGHT", _G["BidBuyoutButton"], "LEFT", -1, 0)
	_G["AuctionsCancelAuctionButton"]:ClearAllPoints()
	_G["AuctionsCancelAuctionButton"]:Point("RIGHT", _G["AuctionsCloseButton"], "LEFT", -1, 0)
	_G["BrowsePrevPageButton"]:ClearAllPoints()
	_G["BrowsePrevPageButton"]:Point("TOPLEFT", _G["BrowseSearchButton"], "BOTTOMLEFT", 0, -5)
	_G["BrowseNextPageButton"]:ClearAllPoints()
	_G["BrowseNextPageButton"]:Point("TOPRIGHT", _G["BrowseResetButton"], "BOTTOMRIGHT", 0, -5)

	-- Blizz needs to be more consistent
	_G["BrowseBidPriceSilver"]:Point("LEFT", _G["BrowseBidPriceGold"], "RIGHT", 1, 0)
	_G["BrowseBidPriceCopper"]:Point("LEFT", _G["BrowseBidPriceSilver"], "RIGHT", 1, 0)
	_G["BidBidPriceSilver"]:Point("LEFT", _G["BidBidPriceGold"], "RIGHT", 1, 0)
	_G["BidBidPriceCopper"]:Point("LEFT", _G["BidBidPriceSilver"], "RIGHT", 1, 0)
	_G["StartPriceSilver"]:Point("LEFT", _G["StartPriceGold"], "RIGHT", 1, 0)
	_G["StartPriceCopper"]:Point("LEFT", _G["StartPriceSilver"], "RIGHT", 1, 0)
	_G["BuyoutPriceSilver"]:Point("LEFT", _G["BuyoutPriceGold"], "RIGHT", 1, 0)
	_G["BuyoutPriceCopper"]:Point("LEFT", _G["BuyoutPriceSilver"], "RIGHT", 1, 0)

	local auctionhandler = CreateFrame("Frame")
	auctionhandler:RegisterEvent("NEW_AUCTION_UPDATE")
	auctionhandler:SetScript("OnEvent", function()
		local _, _, _, _, _, _, _, _, _, _, _, _, _, AuctionsItemButtonIconTexture = _G["AuctionsItemButton"]:GetRegions() -- blizzard, please name your textures
		if AuctionsItemButtonIconTexture then
			AuctionsItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
			AuctionsItemButtonIconTexture:Point("TOPLEFT", 1, -1)
			AuctionsItemButtonIconTexture:Point("BOTTOMRIGHT", -1, 1)
		end
	end)
end

S:AddCallbackForAddon("Blizzard_AuctionUI", "mUIAuctionhouse", styleAuctionhouse)