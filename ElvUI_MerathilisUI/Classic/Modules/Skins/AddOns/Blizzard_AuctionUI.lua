local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_AuctionUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.auctionhouse ~= true or not E.private.mui.skins.blizzard.auctionhouse then return end

	local AuctionFrame = _G.AuctionFrame
	if AuctionFrame.backdrop then
		AuctionFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(AuctionFrame)
end

module:AddCallbackForAddon("Blizzard_AuctionUI")
