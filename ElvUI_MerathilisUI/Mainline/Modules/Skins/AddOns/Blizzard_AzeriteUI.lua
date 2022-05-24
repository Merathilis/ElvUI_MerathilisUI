local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.azerite ~= true or E.private.mui.skins.blizzard.azerite ~= true then return end

	local AzeriteEmpoweredItemUI = _G.AzeriteEmpoweredItemUI
	AzeriteEmpoweredItemUI:Styling()
	MER:CreateBackdropShadow(AzeriteEmpoweredItemUI)
end

S:AddCallbackForAddon("Blizzard_AzeriteUI", "mUIAzerite", LoadSkin)
