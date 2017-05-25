local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule("Skins")
local MERS = E:GetModule("muiSkins")

-- Cache global variables
-- Lua functions
-- WoW API

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleAuctionhouse()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.auctionhouse ~= true or E.private.muiSkins.blizzard.auctionhouse ~= true then return end

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
end

S:AddCallbackForAddon("Blizzard_AuctionUI", "mUIAuctionhouse", styleAuctionhouse)