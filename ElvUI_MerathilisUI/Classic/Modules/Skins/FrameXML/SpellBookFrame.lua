local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("spellbook", "spellbook") then
		return
	end

	local SpellBookFrame = _G.SpellBookFrame
	if SpellBookFrame.backdrop then
		SpellBookFrame.backdrop:Styling()
	end
	module:CreateBackdropShadow(SpellBookFrame)

	for i = 1, SPELLS_PER_PAGE do
		local button = _G["SpellButton"..i]

		if button.bg then
			module:CreateGradient(button.bg)
		end
	end
end

S:AddCallback("SpellBookFrame", LoadSkin)
