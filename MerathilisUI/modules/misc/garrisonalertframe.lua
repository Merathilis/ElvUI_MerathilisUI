local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

-- Hides the GarrisonAlertFrame when in combat (credits Sniffles)
if IsAddOnLoaded("HideGarrisonAlertFrame") then return end

local combat = CreateFrame("Frame")
combat:RegisterEvent("PLAYER_REGEN_DISABLED")
combat:RegisterEvent("PLAYER_REGEN_ENABLED")
combat:SetScript("OnEvent", function(self, event, ...)
	if E.db.muiMisc.HideAlertFrame then
		if event == "PLAYER_REGEN_DISABLED" then
			AlertFrame:UnregisterEvent("GARRISON_MISSION_FINISHED")
		else
			AlertFrame:RegisterEvent("GARRISON_MISSION_FINISHED")
		end
	end
end)
