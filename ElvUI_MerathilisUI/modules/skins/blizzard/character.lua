local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: styleEncounterJournal

function styleCharacter()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.muiSkins.blizzard.character ~= true then return end

	CharacterStatsPane.ItemLevelCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
	CharacterStatsPane.AttributesCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
	CharacterStatsPane.EnhancementsCategory.Title:SetTextColor(unpack(E.media.rgbvaluecolor))
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "ElvUI_MerathilisUI" then
		E:Delay(1, styleCharacter)
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
