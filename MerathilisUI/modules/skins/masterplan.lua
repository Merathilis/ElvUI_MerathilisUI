local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

local function skinMasterPlan()
	S:HandleTab(GarrisonMissionFrameTab3)
	S:HandleTab(GarrisonMissionFrameTab4)
	local MissionPage = GarrisonMissionFrame.MissionTab.MissionPage
	S:HandleCloseButton(MissionPage.MinimizeButton, nil, "-")
	MissionPage.MinimizeButton:SetFrameLevel(MissionPage:GetFrameLevel() + 2)
end

if IsAddOnLoaded("MasterPlan") then
	skinMasterPlan()
else
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(self, event, addon)
		if addon == "MasterPlan" then
			skinMasterPlan()
			self:UnregisterEvent("ADDON_LOADED")
		end
	end)
end
