local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:AddonCompartment()
	if not E.private.mui.skins.blizzard.addonCompartment then
		return
	end

	local AddonCompartmentFrame = _G.AddonCompartmentFrame
	module:CreateShadow(AddonCompartmentFrame)
end

module:AddCallback("AddonCompartment")
