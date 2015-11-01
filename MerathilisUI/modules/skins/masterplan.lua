local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

if E.db.muiSkins == nil then E.db.muiSkins = {} end -- Prevent a nil Error.
if not IsAddOnLoaded("MasterPlan") and E.db.muiSkins.MasterPlan == false then return; end

-- Garrison Tab
local function skinMasterPlanGarrison()
	S:HandleTab(GarrisonMissionFrameTab3)
	S:HandleTab(GarrisonMissionFrameTab4)
end

-- ShipYard Tab
local function skinMasterPlanShipyard()
	S:HandleTab(GarrisonShipyardFrameTab3)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "MasterPlan" then
		skinMasterPlanGarrison()
		skinMasterPlanShipyard()
		f:UnregisterEvent("ADDON_LOADED")
	end
end)
