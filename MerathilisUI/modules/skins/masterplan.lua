local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

-- Cache global variables
local _G = _G
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

if E.db.muiSkins == nil then E.db.muiSkins = {} end -- Prevent a nil Error.
if not IsAddOnLoaded("MasterPlan") and E.db.muiSkins.MasterPlan == false then return; end

-- Garrison Tabs
local function skinMasterPlanGarrison()
	S:HandleTab(_G["GarrisonMissionFrameTab3"])
	S:HandleTab(_G["GarrisonMissionFrameTab4"])
	S:HandleTab(_G["GarrisonLandingPageTab4"])
	S:HandleButton(MPCompleteAll, true)
	S:HandleButton(MPPokeTentativeParties, true)
	S:HandleButton(MPLootSummaryDone, true)
end

-- ShipYard Tabs
local function skinMasterPlanShipyard()
	S:HandleTab(_G["GarrisonShipyardFrameTab3"])
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "MasterPlan" then
		skinMasterPlanGarrison()
		skinMasterPlanShipyard()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
