local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G
local pairs = pairs

local C_AzeriteEssence_CanOpenUI = C_AzeriteEssence.CanOpenUI

function module:Blizzard_AzeriteEssenceUI()
	if not module:CheckDB("azeriteEssence", "AzeriteEssence") then
		return
	end

	if not C_AzeriteEssence_CanOpenUI() then return end

	local AzeriteEssenceUI = _G.AzeriteEssenceUI
	module:CreateBackdropShadow(AzeriteEssenceUI)

	for _, button in pairs(AzeriteEssenceUI.EssenceList.buttons) do
		if button.backdrop then
			button.backdrop:SetTemplate("Transparent")
			module:CreateGradient(button.backdrop)
		end
	end
end

module:AddCallbackForAddon("Blizzard_AzeriteEssenceUI")
