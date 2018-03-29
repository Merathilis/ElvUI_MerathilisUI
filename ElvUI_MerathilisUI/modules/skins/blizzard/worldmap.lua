local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local select = select
--WoW API / Variables
local CreateFrame = CreateFrame
local GetNumQuestLogEntries = GetNumQuestLogEntries
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleWorldmap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true or E.private.muiSkins.blizzard.worldmap ~= true then return end

	_G["WorldMapFrame"]:Styling()

	local frame = CreateFrame("Frame", nil, _G["QuestMapFrame"])
	_G["QuestMapFrame"].QuestCountFrame = frame

	frame:RegisterEvent("QUEST_LOG_UPDATE")
	frame:Size(240, 20)
	frame:Point("TOP", -12, 30)
	MERS:CreateBD(frame, .25)

	local text = MER:CreateText(frame, "OVERLAY", 12, "OUTLINE")
	text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	text:SetAllPoints()

	frame.text = text
	local str = "%d / 25 Quests"
	frame.text:SetFormattedText(str, select(2, GetNumQuestLogEntries()))

	frame:SetScript("OnEvent", function(self, event)
		local _, quests = GetNumQuestLogEntries()
		frame.text:SetFormattedText(str, quests)
	end)

	if frame then
		_G["QuestMapFrame"].DetailsFrame.BackButton:ClearAllPoints()
		_G["QuestMapFrame"].DetailsFrame.BackButton:Point("LEFT", 10, 275)
	else
		return
	end

	WorldMapFrame.UIElementsFrame.BountyBoard.BountyName:FontTemplate(nil, 14, "OUTLINE")
	WorldMapFrame.UIElementsFrame.OpenQuestPanelButton:Size(22 ,22)
	WorldMapFrame.UIElementsFrame.CloseQuestPanelButton:Size(22, 22)

	WorldMapFrameAreaLabel:FontTemplate(nil, 30, "OUTLINE")
	WorldMapFrameAreaLabel:SetShadowOffset(1, -1)
	WorldMapFrameAreaLabel:SetTextColor(0.9, 0.8, 0.6)
	WorldMapFrameAreaDescription:FontTemplate(nil, 20, "OUTLINE")
	WorldMapFrameAreaDescription:SetShadowOffset(1, -1)
	WorldMapFrameAreaPetLevels:FontTemplate(nil, 20, "OUTLINE")
	WorldMapFrameAreaPetLevels:SetShadowOffset(1, -1)
	WorldMapZoneInfo:FontTemplate(nil, 25, "OUTLINE")
	WorldMapZoneInfo:SetShadowOffset(1, -1)
end

S:AddCallback("mUISkinWorldMap", styleWorldmap)