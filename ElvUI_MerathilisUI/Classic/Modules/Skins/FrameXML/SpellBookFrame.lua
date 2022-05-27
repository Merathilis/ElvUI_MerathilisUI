local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.spellbook) or not E.private.mui.skins.blizzard.spellbook then return end

	local SpellBookFrame = _G.SpellBookFrame
	if SpellBookFrame.backdrop then
		SpellBookFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(SpellBookFrame)

	for i = 1, SPELLS_PER_PAGE do
		local button = _G["SpellButton"..i]

		if button.bg then
			module:CreateGradient(button.bg)
		end
	end
end

module:AddCallback("SpellBookFrame")
