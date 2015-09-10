local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERS = E:NewModule('MerathilisUISkins');
local S = E:GetModule('Skins');

if not IsAddOnLoaded("MasterPlan") then return end

function MERS:skinMasterPlan()
	S:HandleTab(GarrisonMissionFrameTab3)
	S:HandleTab(GarrisonMissionFrameTab4)
	local MissionPage = GarrisonMissionFrame.MissionTab.MissionPage
	S:HandleCloseButton(MissionPage.MinimizeButton, nil, "-")
	MissionPage.MinimizeButton:SetFrameLevel(MissionPage:GetFrameLevel() + 2)
end

function MERS:Initialize()
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'skinMasterPlan')
end
E:RegisterModule(MERS:GetName())