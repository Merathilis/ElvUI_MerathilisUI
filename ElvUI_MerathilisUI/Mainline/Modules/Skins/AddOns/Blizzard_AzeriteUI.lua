local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_AzeriteUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.azerite ~= true or E.private.mui.skins.blizzard.azerite ~= true then return end

	local AzeriteEmpoweredItemUI = _G.AzeriteEmpoweredItemUI
	AzeriteEmpoweredItemUI:Styling()
	MER:CreateBackdropShadow(AzeriteEmpoweredItemUI)
end

module:AddCallbackForAddon("Blizzard_AzeriteUI")
