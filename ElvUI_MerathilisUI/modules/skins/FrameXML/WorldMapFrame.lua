local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
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

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleWorldmap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true or E.private.muiSkins.blizzard.worldmap ~= true then return end

	_G["WorldMapFrame"]:Styling()

	local frame = CreateFrame("Frame", nil, _G["QuestScrollFrame"])
	_G["QuestScrollFrame"].QuestCountFrame = frame

	frame:RegisterEvent("QUEST_LOG_UPDATE")
	frame:Size(240, 20)
	frame:Point("TOP", -1, 22)
	MERS:CreateBD(frame, .25)

	local text = MER:CreateText(frame, "OVERLAY", 12, "OUTLINE")
	text:SetTextColor(r, g, b)
	text:SetAllPoints()

	frame.text = text
	local str = "%d / 25 Quests"
	frame.text:SetFormattedText(str, select(2, GetNumQuestLogEntries()))

	frame:SetScript("OnEvent", function(self, event)
		local _, quests = GetNumQuestLogEntries()
		frame.text:SetFormattedText(str, quests)
	end)

	if _G["QuestScrollFrame"].DetailFrame.backdrop then
		_G["QuestScrollFrame"].DetailFrame.backdrop:Hide()
	end
end

S:AddCallback("mUISkinWorldMap", styleWorldmap)