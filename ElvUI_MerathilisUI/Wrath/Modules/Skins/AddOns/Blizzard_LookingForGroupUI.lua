local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("lfg", "lfg") then
		return
	end

	local LFGListingFrame = _G.LFGListingFrame
	LFGListingFrame.backdrop:Styling() -- must be on the backdrop >.<
	module:CreateBackdropShadow(LFGListingFrame)
end

S:AddCallbackForAddon("Blizzard_LookingForGroupUI", LoadSkin)
