local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')
local AB = E:GetModule('ActionBars')

function module:SkinZoneAbilities(button)
	if not E.Retail then return end

	for spellButton in button.SpellButtonContainer:EnumerateActive() do
		if spellButton and spellButton.IsSkinned then
			module:CreateShadow(spellButton)
		end
	end
end

function module:Skin_ElvUI_ActionBars()
	if not E.private.actionbar.enable then
		return
	end

	-- Zone Button
	module:SecureHook(_G.ZoneAbilityFrame, "UpdateDisplayedZoneAbilities", "SkinZoneAbilities")

	for i = 1, _G.ExtraActionBarFrame:GetNumChildren() do
		local button = _G["ExtraActionButton" .. i]
		if button and button.backdrop then
			module:CreateBackdropShadow(button.backdrop, true)
		end
	end
end

module:AddCallback("Skin_ElvUI_ActionBars")