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

	local tabs = { _G.AuctionHouseFrameBuyTab, _G.AuctionHouseFrameSellTab, _G.AuctionHouseFrameAuctionsTab }
	for _, tab in pairs(tabs) do
		if tab then
			module:ReskinTab(tab)
			module:CreateBackdropShadow(tab)
		end
	end
end

module:AddCallbackForAddon("Blizzard_AuctionHouseUI")
