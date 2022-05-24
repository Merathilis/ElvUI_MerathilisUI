local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.auctionhouse ~= true or E.private.mui.skins.blizzard.auctionhouse ~= true then return end

	local AuctionFrame = _G.AuctionFrame
	AuctionFrame.backdrop:Styling()
	MER:CreateBackdropShadow(AuctionFrame)
end

S:AddCallbackForAddon("Blizzard_AuctionUI", "mUIAuctionhouse", LoadSkin)
