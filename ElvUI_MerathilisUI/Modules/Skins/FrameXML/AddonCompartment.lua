local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')

local _G = _G

function module:AddonCompartment()
	if not E.private.mui.skins.blizzard.addonCompartment then
		return
	end

	local AddonCompartmentFrame = _G.AddonCompartmentFrame
	AddonCompartmentFrame:Styling()
	module:CreateShadow(AddonCompartmentFrame)
end

module:AddCallback("AddonCompartment")
