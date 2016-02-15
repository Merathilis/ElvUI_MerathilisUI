local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

-- Cache global variables
local _G = _G
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

if E.private.muiSkins == nil then E.private.muiSkins = {} end -- Prevent a nil Error.
if E.private.muiSkins.addons == nil then E.private.muiSkins.addons = {} end -- Also a nil Error.
if not IsAddOnLoaded("MasterPlan") and E.private.muiSkins.addons.MasterPlan == false then return; end

-- MasterPlan
local function skinMasterPlan()
	-- Garrison
	S:HandleTab(_G["GarrisonMissionFrameTab3"])
	S:HandleTab(_G["GarrisonMissionFrameTab4"])
	-- Landing Page
	S:HandleTab(_G["GarrisonLandingPageTab4"])
	-- Shipyard
	S:HandleTab(_G["GarrisonShipyardFrameTab3"])
	S:HandleButton(_G["MPCompleteAll"], true)
	S:HandleButton(_G["MPPokeTentativeParties"], true)
	S:HandleButton(_G["MPLootSummaryDone"], true)
	-- Follower SearchBox
	GarrisonMissionFrameFollowers.SearchBox:SetPoint("TOPLEFT", 20, 25)
	GarrisonMissionFrameFollowers.SearchBox:SetSize(252, 20)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "MasterPlan" then
		skinMasterPlan()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
