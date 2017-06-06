local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
-- WoW API / Variables
local SpellBookFrame = _G["SpellBookFrame"]
local SpellBookPageText = _G["SpellBookPageText"]
-- GLOBALS: hooksecurefunc

local function styleSpellBook()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true or E.private.muiSkins.blizzard.spellbook ~= true then return end

	MERS:CreateGradient(SpellBookFrame)
	if SpellBookFrame.pagebackdrop then
		SpellBookFrame.pagebackdrop:Hide()
	end

	if not SpellBookFrame.stripes then
		MERS:CreateStripes(SpellBookFrame)
	end

	SpellBookPageText:SetTextColor(unpack(E.media.rgbvaluecolor))

	local professionheaders = {
		"PrimaryProfession1",
		"PrimaryProfession2",
		"SecondaryProfession1",
		"SecondaryProfession2",
		"SecondaryProfession3",
		"SecondaryProfession4"
	}

	for _, header in pairs(professionheaders) do
		_G[header.."Missing"]:SetTextColor(1, 0.8, 0)
		_G[header.."Missing"]:SetShadowColor(0, 0, 0)
		_G[header.."Missing"]:SetShadowOffset(1, -1)
		_G[header].missingText:SetTextColor(0.6, 0.6, 0.6)
	end

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		if self.SpellSubName then
			self.SpellSubName:SetTextColor(unpack(E.media.rgbvaluecolor))
		end
	end)
end

S:AddCallback("mUISpellbook", styleSpellBook)