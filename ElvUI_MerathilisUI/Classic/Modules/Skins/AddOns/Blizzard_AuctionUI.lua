local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("auctionhouse", "auctionhouse") then
		return
	end

	local AuctionFrame = _G.AuctionFrame
	if AuctionFrame.backdrop then
		AuctionFrame.backdrop:Styling()
	end
	module:CreateBackdropShadow(AuctionFrame)
end

S:AddCallbackForAddon("Blizzard_AuctionUI", LoadSkin)
