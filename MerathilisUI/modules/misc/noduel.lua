local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
local format = string.format
local CreateFrame = CreateFrame

-- Auto decline duel
local frame = CreateFrame("Frame")
frame:RegisterEvent("DUEL_REQUESTED")
frame:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED")
frame:SetScript("OnEvent", function(self, event, name)
	if not E.db.muiMisc.noDuel then return end
	if event == "DUEL_REQUESTED" then
		CancelDuel()
		print(format("|cffffff00"..L['INFO_DUEL']..name.."."))
		StaticPopup_Hide("DUEL_REQUESTED")
	elseif event == "PET_BATTLE_PVP_DUEL_REQUESTED" then
		C_PetBattles.CancelPVPDuel()
		print(format("|cffffff00"..L['INFO_PET_DUEL']..name.."."))
		StaticPopup_Hide("PET_BATTLE_PVP_DUEL_REQUESTED")
	end
end)
