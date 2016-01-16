local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

function styleEncounterJournal()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.encounterjournal ~= true or E.db.muiSkins.EJTitle == false then return end
	
	local classColor = RAID_CLASS_COLORS[E.myclass]
	local EJ = EncounterJournal
	local EncounterInfo = EJ.encounter.info
	EncounterInfo.instanceTitle:SetTextColor(classColor.r, classColor.g, classColor.b)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_EncounterJournal" then
		styleEncounterJournal()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
