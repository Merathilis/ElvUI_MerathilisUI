local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

-- Cache global variables
-- GLOBALS: styleEncounterJournal
local _G = _G
local pairs, unpack = pairs, unpack

function styleEncounterJournal()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.encounterjournal ~= true or E.private.muiSkins.blizzard.encounterjournal == false then return end
	
	local EJ = _G["EncounterJournal"]
	local EncounterInfo = EJ.encounter.info
	EncounterInfo.instanceTitle:SetTextColor(unpack(E.media.rgbvaluecolor))
	EncounterInfo.encounterTitle:SetTextColor(unpack(E.media.rgbvaluecolor))
	
	local Tabs = {
		_G["EncounterJournalEncounterFrameInfoBossTab"],
		_G["EncounterJournalEncounterFrameInfoLootTab"],
		_G["EncounterJournalEncounterFrameInfoModelTab"],
		_G["EncounterJournalEncounterFrameInfoOverviewTab"]
	}
	
	for _, Tab in pairs(Tabs) do
		Tab.backdrop:StripTextures(true)
		Tab.backdrop:CreateBackdrop('Transparent')
		MER:StyleOutside(Tab.backdrop)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_EncounterJournal" then
		styleEncounterJournal()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
