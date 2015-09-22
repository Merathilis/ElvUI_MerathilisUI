local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local MER = E:GetModule('MerathilisUI');

-- Hides the GarrisonAlertFrame when in combat (credits Sniffles)
local combat = CreateFrame("Frame")
combat:RegisterEvent("PLAYER_REGEN_DISABLED")
combat:RegisterEvent("PLAYER_REGEN_ENABLED")
combat:SetScript("OnEvent", function(self, event, ...)
	if E.db.Merathilis.HideAlertFrame then
		if event == "PLAYER_REGEN_DISABLED" then
			AlertFrame:UnregisterEvent("GARRISON_MISSION_FINISHED")
		else
			AlertFrame:RegisterEvent("GARRISON_MISSION_FINISHED")
		end
	end
end)
