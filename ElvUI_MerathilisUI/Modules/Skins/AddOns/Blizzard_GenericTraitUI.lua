local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_GenericTraitUI()
	if not module:CheckDB("misc", "misc") or not E.private.skins.blizzard.genericTrait then
		return
	end

	local GenericTraitFrame = _G.GenericTraitFrame
	module:CreateShadow(GenericTraitFrame)
end

module:AddCallbackForAddon("Blizzard_GenericTraitUI")
