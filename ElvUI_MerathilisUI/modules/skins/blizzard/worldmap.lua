local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local unpack = unpack

local function styleWorldmap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true or E.private.muiSkins.blizzard.worldmap ~= true then return end

	MERS:CreateGradient(WorldMapFrame)
	if not WorldMapFrame.stripes then
		MERS:CreateStripes(WorldMapFrame)
	end

	local frame = CreateFrame("Frame", nil, QuestMapFrame)
	QuestMapFrame.QuestCountFrame = frame

	frame:RegisterEvent("QUEST_LOG_UPDATE")
	frame:Size(240, 20)
	frame:Point("TOP", 0, 30)
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
end

S:AddCallback("mUISkinWorldMap", styleWorldmap)