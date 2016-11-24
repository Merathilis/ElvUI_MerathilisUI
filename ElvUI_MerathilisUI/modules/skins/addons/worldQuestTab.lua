local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables

-- GLOBALS: styleWQTab, 

function styleWQTab()

	-- WorldQuestTab
	S:HandleScrollBar(_G["BWQ_QuestScrollFrameScrollBar"])
	S:HandleButton(_G["BWQ_TabNormal"])
	S:HandleButton(_G["BWQ_TabWorld"])
	S:HandleButton(_G["BWQ_WorldQuestFrameFilterButton"])
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "WorldQuestTab" then
			styleWQTab()
			self:UnregisterEvent("ADDON_LOADED")
		end
	end
end)