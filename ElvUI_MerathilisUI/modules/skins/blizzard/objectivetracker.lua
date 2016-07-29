local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local LSM = LibStub('LibSharedMedia-3.0');
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
-- WoW API / Variables
local GetScreenWidth = GetScreenWidth
local IsAddOnLoaded = IsAddOnLoaded
local C_Scenario = C_Scenario
local BONUS_OBJECTIVE_TRACKER_MODULE = _G["BONUS_OBJECTIVE_TRACKER_MODULE"]
local LevelUpDisplayScenarioFrame = _G["LevelUpDisplayScenarioFrame"]
local ObjectiveTrackerFrame = _G["ObjectiveTrackerFrame"]
local ObjectiveTrackerBlocksFrame = _G["ObjectiveTrackerBlocksFrame"]
local ObjectiveTrackerBonusBannerFrame = _G["ObjectiveTrackerBonusBannerFrame"]

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local function ObjectiveTrackerReskin()
	if IsAddOnLoaded("Blizzard_ObjectiveTracker") then
		if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectivetracker ~= true then return end

		for _, headerName in pairs({"QuestHeader", "AchievementHeader", "ScenarioHeader"}) do
			ObjectiveTrackerFrame.BlocksFrame[headerName].Background:Hide()
		end

		-- Quest
		ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 12, 'OUTLINE')
		ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)

		hooksecurefunc(QUEST_TRACKER_MODULE, "Update", function(self)
			for i = 1, GetNumQuestWatches() do
				local questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i)
				if not questID then break end
				local oldBlock = QUEST_TRACKER_MODULE:GetExistingBlock(questID)
				if oldBlock then
					local newTitle = "[" .. select(2, GetQuestLogTitle(questLogIndex)) .. "] " .. title
					QUEST_TRACKER_MODULE:SetStringText(oldBlock.HeaderText, newTitle, nil, OBJECTIVE_TRACKER_COLOR["Header"])
				end
			end
		end)

		-- Achievements
		ObjectiveTrackerBlocksFrame.AchievementHeader.Text:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 12, 'OUTLINE')
		ObjectiveTrackerBlocksFrame.AchievementHeader.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
		
		-- Bonus Objectives
		BONUS_OBJECTIVE_TRACKER_MODULE.Header.Text:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 12, 'OUTLINE')
		BONUS_OBJECTIVE_TRACKER_MODULE.Header.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
		BONUS_OBJECTIVE_TRACKER_MODULE.Header.Background:Hide()

		-- Bonus Objectives Banner Frame
		ObjectiveTrackerBonusBannerFrame.Title:SetVertexColor(classColor.r, classColor.g, classColor.b)
		ObjectiveTrackerBonusBannerFrame.BonusLabel:SetVertexColor(1, 1, 1)

		-- Scenario/Instances
		ObjectiveTrackerBlocksFrame.ScenarioHeader.Text:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 12, 'OUTLINE')
		ObjectiveTrackerBlocksFrame.ScenarioHeader.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)

		LevelUpDisplayScenarioFrame.level:SetVertexColor(classColor.r, classColor.g, classColor.b)

		-- Menu Title
		ObjectiveTrackerFrame.HeaderMenu.Title:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 12, 'OUTLINE')
		ObjectiveTrackerFrame.HeaderMenu.Title:SetVertexColor(classColor.r, classColor.g, classColor.b)
		ObjectiveTrackerFrame.HeaderMenu.Title:SetAlpha(0)

		-- Underlines
		ObjectiveTrackerBlocksFrame.QuestHeader.Underline = MER:Underline(ObjectiveTrackerBlocksFrame.QuestHeader, true, 1)
		ObjectiveTrackerBlocksFrame.AchievementHeader.Underline = MER:Underline(ObjectiveTrackerBlocksFrame.AchievementHeader, true, 1)
		BONUS_OBJECTIVE_TRACKER_MODULE.Header.Underline = MER:Underline(BONUS_OBJECTIVE_TRACKER_MODULE.Header, true, 1)
		ObjectiveTrackerBlocksFrame.ScenarioHeader.Underline = MER:Underline(ObjectiveTrackerBlocksFrame.ScenarioHeader, true, 1)
	end
end
hooksecurefunc(S, "Initialize", ObjectiveTrackerReskin)
