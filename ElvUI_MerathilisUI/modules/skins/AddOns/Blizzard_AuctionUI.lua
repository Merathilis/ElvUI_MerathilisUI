local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local select, unpack = select, unpack
-- WoW API
local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleAuctionhouse()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.auctionhouse ~= true or E.private.muiSkins.blizzard.auctionhouse ~= true then return end

	local AuctionFrame = _G.AuctionFrame
	AuctionFrame.backdrop:Styling()

	--Change ElvUI's backdrop to be Transparent
	if _G.AuctionFrameBrowse.bg1 then _G.AuctionFrameBrowse.bg1:SetTemplate("Transparent") end
	if _G.AuctionFrameBrowse.bg2 then _G.AuctionFrameBrowse.bg2:SetTemplate("Transparent") end
	if _G.AuctionFrameBid.bg then _G.AuctionFrameBid.bg:SetTemplate("Transparent") end
	if _G.AuctionFrameAuctions.bg1 then _G.AuctionFrameAuctions.bg1:SetTemplate("Transparent") end
	if _G.AuctionFrameAuctions.bg2 then _G.AuctionFrameAuctions.bg2:SetTemplate("Transparent") end

	_G.AuctionProgressBar.Text:ClearAllPoints()
	_G.AuctionProgressBar.Text:SetPoint("CENTER", 0, 1)

	select(14, _G.AuctionProgressFrameCancelButton:GetRegions()):SetPoint("CENTER", 0, 2)

	_G.BrowseQualitySort:DisableDrawLayer("BACKGROUND")
	_G.BrowseLevelSort:DisableDrawLayer("BACKGROUND")
	_G.BrowseDurationSort:DisableDrawLayer("BACKGROUND")
	_G.BrowseHighBidderSort:DisableDrawLayer("BACKGROUND")
	_G.BrowseCurrentBidSort:DisableDrawLayer("BACKGROUND")
	_G.BidQualitySort:DisableDrawLayer("BACKGROUND")
	_G.BidLevelSort:DisableDrawLayer("BACKGROUND")
	_G.BidDurationSort:DisableDrawLayer("BACKGROUND")
	_G.BidBuyoutSort:DisableDrawLayer("BACKGROUND")
	_G.BidStatusSort:DisableDrawLayer("BACKGROUND")
	_G.BidBidSort:DisableDrawLayer("BACKGROUND")
	_G.AuctionsQualitySort:DisableDrawLayer("BACKGROUND")
	_G.AuctionsDurationSort:DisableDrawLayer("BACKGROUND")
	_G.AuctionsHighBidderSort:DisableDrawLayer("BACKGROUND")
	_G.AuctionsBidSort:DisableDrawLayer("BACKGROUND")
	select(6, _G.BrowseCloseButton:GetRegions()):Hide()
	select(6, _G.BrowseBuyoutButton:GetRegions()):Hide()
	select(6, _G.BrowseBidButton:GetRegions()):Hide()
	select(6, _G.BidCloseButton:GetRegions()):Hide()
	select(6, _G.BidBuyoutButton:GetRegions()):Hide()
	select(6, _G.BidBidButton:GetRegions()):Hide()

	hooksecurefunc("FilterButton_SetUp", function(button)
		button:SetNormalTexture("")
	end)

	local lastSkinnedTab = 1
	AuctionFrame:HookScript("OnShow", function()
		local tab = _G["AuctionFrameTab"..lastSkinnedTab]

		while tab do
			MERS:ReskinTab(tab)
			lastSkinnedTab = lastSkinnedTab + 1
			tab = _G["AuctionFrameTab"..lastSkinnedTab]
		end
	end)

	local abuttons = {"BrowseBidButton", "BrowseBuyoutButton", "BrowseCloseButton", "BrowseSearchButton", "BrowseResetButton", "BidBidButton", "BidBuyoutButton", "BidCloseButton", "AuctionsCloseButton", "AuctionsCancelAuctionButton", "AuctionsCreateAuctionButton", "AuctionsNumStacksMaxButton", "AuctionsStackSizeMaxButton"}
	for i = 1, #abuttons do
		MERS:Reskin(_G[abuttons[i]])
	end

	_G.BrowseCloseButton:ClearAllPoints()
	_G.BrowseCloseButton:SetPoint("BOTTOMRIGHT", _G.AuctionFrameBrowse, "BOTTOMRIGHT", 66, 13)
	_G.BrowseBuyoutButton:ClearAllPoints()
	_G.BrowseBuyoutButton:SetPoint("RIGHT", _G.BrowseCloseButton, "LEFT", -1, 0)
	_G.BrowseBidButton:ClearAllPoints()
	_G.BrowseBidButton:SetPoint("RIGHT", _G.BrowseBuyoutButton, "LEFT", -1, 0)
	_G.BidBuyoutButton:ClearAllPoints()
	_G.BidBuyoutButton:SetPoint("RIGHT", _G.BidCloseButton, "LEFT", -1, 0)
	_G.BidBidButton:ClearAllPoints()
	_G.BidBidButton:SetPoint("RIGHT", _G.BidBuyoutButton, "LEFT", -1, 0)
	_G.AuctionsCancelAuctionButton:ClearAllPoints()
	_G.AuctionsCancelAuctionButton:SetPoint("RIGHT", _G.AuctionsCloseButton, "LEFT", -1, 0)

	-- Blizz needs to be more consistent
	_G.BrowseBidPriceSilver:SetPoint("LEFT", _G.BrowseBidPriceGold, "RIGHT", 1, 0)
	_G.BrowseBidPriceCopper:SetPoint("LEFT", _G.BrowseBidPriceSilver, "RIGHT", 1, 0)
	_G.BidBidPriceSilver:SetPoint("LEFT", _G.BidBidPriceGold, "RIGHT", 1, 0)
	_G.BidBidPriceCopper:SetPoint("LEFT", _G.BidBidPriceSilver, "RIGHT", 1, 0)
	_G.StartPriceSilver:SetPoint("LEFT", _G.StartPriceGold, "RIGHT", 1, 0)
	_G.StartPriceCopper:SetPoint("LEFT", _G.StartPriceSilver, "RIGHT", 1, 0)
	_G.BuyoutPriceSilver:SetPoint("LEFT", _G.BuyoutPriceGold, "RIGHT", 1, 0)
	_G.BuyoutPriceCopper:SetPoint("LEFT", _G.BuyoutPriceSilver, "RIGHT", 1, 0)

	local function reskinAuctionButtons(button, i)
		local bu = _G[button..i]
		local it = _G[button..i.."Item"]
		local ic = _G[button..i.."ItemIconTexture"]

		if bu and it then
			it:SetNormalTexture("")
			it:SetPushedTexture("")
			it:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			MERS:ReskinIcon(ic)
			it.IconBorder:SetAlpha(0)
			bu:StripTextures()

			local bg = MERS:CreateBDFrame(bu, .25)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, 5)
			MERS:CreateGradient(bg)

			bu:SetHighlightTexture(E["media"].normTex)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .2)
			hl:ClearAllPoints()
			hl:SetPoint("TOPLEFT", 0, -1)
			hl:SetPoint("BOTTOMRIGHT", -1, 6)
		end
	end

	for i = 1, _G.NUM_BROWSE_TO_DISPLAY do
		reskinAuctionButtons("BrowseButton", i)
	end

	for i = 1, _G.NUM_BIDS_TO_DISPLAY do
		reskinAuctionButtons("BidButton", i)
	end

	for i = 1, _G.NUM_AUCTIONS_TO_DISPLAY do
		reskinAuctionButtons("AuctionsButton", i)
	end

	local auctionhandler = CreateFrame("Frame")
	auctionhandler:RegisterEvent("NEW_AUCTION_UPDATE")
	auctionhandler:SetScript("OnEvent", function()
		local AuctionsItemButtonIconTexture = _G.AuctionsItemButton:GetNormalTexture()
		if AuctionsItemButtonIconTexture then
			AuctionsItemButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
			AuctionsItemButtonIconTexture:SetPoint("TOPLEFT", 1, -1)
			AuctionsItemButtonIconTexture:SetPoint("BOTTOMRIGHT", -1, 1)
		end
		_G.AuctionsItemButton.IconBorder:SetTexture("")
	end)

	local _, AuctionsItemButtonNameFrame = _G.AuctionsItemButton:GetRegions()
	AuctionsItemButtonNameFrame:Hide()

	_G.BrowsePrevPageButton:SetPoint("TOPLEFT", 660, -60)
	_G.BrowseNextPageButton:SetPoint("TOPRIGHT", 67, -60)
	_G.BrowsePrevPageButton:GetRegions():SetPoint("LEFT", BrowsePrevPageButton, "RIGHT", 2, 0)

	_G.BrowseDropDownLeft:SetAlpha(0)
	_G.BrowseDropDownMiddle:SetAlpha(0)
	_G.BrowseDropDownRight:SetAlpha(0)

	local a1, p, a2, x, y = _G.BrowseDropDownButton:GetPoint()
	_G.BrowseDropDownButton:SetPoint(a1, p, a2, x, y-4)
	_G.BrowseDropDownButton:SetSize(16, 16)

	-- [[ WoW token ]]
	local BrowseWowTokenResults = _G.BrowseWowTokenResults

	MERS:Reskin(BrowseWowTokenResults.Buyout)

	-- Tutorial
	local WowTokenGameTimeTutorial = _G.WowTokenGameTimeTutorial
	WowTokenGameTimeTutorial:Styling()

	MERS:Reskin(_G.StoreButton)
	WowTokenGameTimeTutorial.LeftDisplay.Tutorial1:SetTextColor(1, .8, 0)
	WowTokenGameTimeTutorial.RightDisplay.Tutorial1:SetTextColor(1, .8, 0)

	-- Token
	do
		local Token = BrowseWowTokenResults.Token
		local icon = Token.Icon
		local iconBorder = Token.IconBorder

		Token.ItemBorder:Hide()
		iconBorder:SetTexture(E["media"].normTex)
		iconBorder:SetDrawLayer("BACKGROUND")
		iconBorder:SetPoint("TOPLEFT", icon, -1, 1)
		iconBorder:SetPoint("BOTTOMRIGHT", icon, 1, -1)
		icon:SetTexCoord(unpack(E.TexCoords))
	end
end

S:AddCallbackForAddon("Blizzard_AuctionUI", "mUIAuctionhouse", styleAuctionhouse)
