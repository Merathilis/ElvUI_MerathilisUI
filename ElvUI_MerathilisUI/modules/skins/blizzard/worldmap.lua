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

	MERS:CreateGradient(_G["WorldMapFrame"])
	MERS:CreateStripes(_G["WorldMapFrame"])

	local frame = CreateFrame("Frame", nil, _G["QuestMapFrame"])
	_G["QuestMapFrame"].QuestCountFrame = frame

	frame:RegisterEvent("QUEST_LOG_UPDATE")
	frame:Size(240, 20)
	frame:Point("TOP", -12, 30)
	MERS:CreateBD(frame, .25)

	local text = frame:CreateFontString(nil, "OVERLAY")
	text:FontTemplate(nil, 12, "OUTLINE")
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
		return;
	end
end

S:AddCallback("mUISkinWorldMap", styleWorldmap)