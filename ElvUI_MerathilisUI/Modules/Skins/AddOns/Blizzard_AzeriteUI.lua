local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_AzeriteUI()
	if not module:CheckDB("azerite", "azerite") then
		return
	end

	local AzeriteEmpoweredItemUI = _G.AzeriteEmpoweredItemUI
	module:CreateBackdropShadow(AzeriteEmpoweredItemUI)
end

module:AddCallbackForAddon("Blizzard_AzeriteUI")
