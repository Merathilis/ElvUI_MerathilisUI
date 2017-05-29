local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local unpack = unpack
-- WoW API

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: styleCharacter, CharacterStatsPane

local function styleCharacter()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.muiSkins.blizzard.character ~= true then return end

	if not CharacterFrame.stripes then
		MERS:CreateStripes(CharacterFrame)
	end

	CharacterStatsPane.ItemLevelCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
	CharacterStatsPane.AttributesCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
	CharacterStatsPane.EnhancementsCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
end

S:AddCallback("mUICharacter", styleCharacter)