local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("misc", "misc") or not E.private.skins.blizzard.genericTrait then
		return
	end

	local GenericTraitFrame = _G.GenericTraitFrame
	GenericTraitFrame:StripTextures()
	GenericTraitFrame:Styling()
	module:CreateShadow(GenericTraitFrame)
end

S:AddCallbackForAddon("Blizzard_GenericTraitUI", LoadSkin)
