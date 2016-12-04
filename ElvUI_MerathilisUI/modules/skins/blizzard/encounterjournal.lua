local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERS = E:GetModule('MuiSkins');

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: styleEncounterJournal

function styleEncounterJournal()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.encounterjournal ~= true or E.private.muiSkins.blizzard.encounterjournal ~= true then return end

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
		Tab:GetNormalTexture():SetTexture(nil)
		Tab:GetPushedTexture():SetTexture(nil)
		Tab:GetDisabledTexture():SetTexture(nil)
		Tab:GetHighlightTexture():SetTexture(nil)
		MERS:SkinBackdropFrame(Tab, nil, true)
		Tab.Backdrop:SetPoint('TOPLEFT', 11, -8)
		Tab.Backdrop:SetPoint('BOTTOMRIGHT', -6, 8)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, _, addon)
	if addon == "Blizzard_EncounterJournal" then
		styleEncounterJournal()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
