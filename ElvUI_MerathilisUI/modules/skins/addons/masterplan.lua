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

-- Hook to AddOnSkins Credit Darth Predator
if not IsAddOnLoaded("AddOnSkins") then return; end
local AS = unpack(AddOnSkins);
local MPskin = AS.MasterPlan
function AS:MasterPlan(event, addon)
	MPskin(self, event, addon)
	if addon == 'MasterPlan' or IsAddOnLoaded('MasterPlan') then
		_G["MPCompleteAllText"]:SetFont(E['media'].muiRoboto, 12, 'OUTLINE')
		_G["MPPokeTentativePartiesText"]:SetFont(E['media'].muiRoboto, 12, 'OUTLINE')
		_G["MPPokeTentativeParties"]:SetWidth(235)

		for i = 1, 4 do
			_G["GarrisonMissionFrameTab"..i.."Text"]:SetFont(E['media'].muiRoboto, 12, 'OUTLINE')
		end
		
		for i = 1, 3 do
			_G["GarrisonShipyardFrameTab"..i.."Text"]:SetFont(E['media'].muiRoboto, 12, 'OUTLINE')
		end

		for i = 1, 4 do
			_G["GarrisonLandingPageTab"..i.."Text"]:SetFont(E['media'].muiRoboto, 12, 'OUTLINE')
		end

		_G["MPCompleteAll"]:SetTemplate("Transparent")
		_G["MPPokeTentativeParties"]:SetTemplate("Transparent")
	end
end
AS:RegisterSkin('MasterPlan', AS.MasterPlan, "ADDON_LOADED")
