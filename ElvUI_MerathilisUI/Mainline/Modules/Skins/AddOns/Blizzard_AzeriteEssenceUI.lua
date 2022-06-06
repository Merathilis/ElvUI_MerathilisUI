local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local pairs = pairs

local C_AzeriteEssence_CanOpenUI = C_AzeriteEssence.CanOpenUI

local function LoadSkin()
	if not module:CheckDB("azeriteEssence", "AzeriteEssence") then
		return
	end

	if not C_AzeriteEssence_CanOpenUI() then return end

	local AzeriteEssenceUI = _G.AzeriteEssenceUI
	AzeriteEssenceUI:Styling()
	MER:CreateBackdropShadow(AzeriteEssenceUI)

	for _, button in pairs(AzeriteEssenceUI.EssenceList.buttons) do
		if button.backdrop then
			button.backdrop:SetTemplate("Transparent")
			module:CreateGradient(button.backdrop)
		end
	end
end

S:AddCallbackForAddon("Blizzard_AzeriteEssenceUI", LoadSkin)
