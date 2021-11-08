local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.spellbook) or E.private.muiSkins.blizzard.spellbook ~= true then return end

	local SpellBookFrame = _G.SpellBookFrame

	SpellBookFrame.backdrop:Styling()
	MER:CreateBackdropShadow(SpellBookFrame)

	for i = 1, SPELLS_PER_PAGE do
		local button = _G["SpellButton"..i]
		local icon = _G["SpellButton"..i.."IconTexture"]

		if button.bg then
			MERS:CreateGradient(button.bg)
		end
	end
end

S:AddCallback("mUISpellBook", LoadSkin)
