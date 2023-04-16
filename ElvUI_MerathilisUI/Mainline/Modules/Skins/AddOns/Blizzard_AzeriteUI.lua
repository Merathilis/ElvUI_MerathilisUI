local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("azerite", "azerite") then
		return
	end

	local AzeriteEmpoweredItemUI = _G.AzeriteEmpoweredItemUI
	AzeriteEmpoweredItemUI:Styling()
	module:CreateBackdropShadow(AzeriteEmpoweredItemUI)
end

S:AddCallbackForAddon("Blizzard_AzeriteUI", LoadSkin)
