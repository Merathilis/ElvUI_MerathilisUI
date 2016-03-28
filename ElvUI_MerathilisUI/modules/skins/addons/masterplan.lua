local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

-- MasterPlan
local function skinMasterPlan()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.garrison ~= true or E.private.muiSkins.addonSkins.mp ~= true then return; end

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
	_G["GarrisonMissionFrameFollowers"].SearchBox:SetPoint("TOPLEFT", 20, 25)
	_G["GarrisonMissionFrameFollowers"].SearchBox:SetSize(252, 20)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "MasterPlan" or IsAddOnLoaded('MasterPlan') then
		skinMasterPlan()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
