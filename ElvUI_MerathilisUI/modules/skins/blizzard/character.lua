local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule("Skins")
local MERS = E:GetModule("muiSkins")

-- Cache global variables
-- Lua functions
local unpack = unpack
-- WoW API

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: styleCharacter, CharacterStatsPane

function styleCharacter()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.muiSkins.blizzard.character ~= true then return end

	CharacterStatsPane.ItemLevelCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
	CharacterStatsPane.AttributesCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
	CharacterStatsPane.EnhancementsCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))

	-- Handle Tabs at bottom of character frame
	for i = 1, 4 do
		MERS:HandleTab(_G["CharacterFrameTab"..i])
	end
end

S:AddCallback("mUICharacter", styleCharacter)