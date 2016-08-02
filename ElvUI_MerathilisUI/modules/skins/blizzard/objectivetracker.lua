local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local LSM = LibStub('LibSharedMedia-3.0');
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
local _G = _G
local select, pairs, unpack = select, pairs, unpack
-- WoW API / Variables
local GetScreenWidth = GetScreenWidth
local IsAddOnLoaded = IsAddOnLoaded
local C_Scenario = C_Scenario
local BONUS_OBJECTIVE_TRACKER_MODULE = _G["BONUS_OBJECTIVE_TRACKER_MODULE"]
local LevelUpDisplayScenarioFrame = _G["LevelUpDisplayScenarioFrame"]
local ObjectiveTrackerFrame = _G["ObjectiveTrackerFrame"]
local ObjectiveTrackerBlocksFrame = _G["ObjectiveTrackerBlocksFrame"]
local ObjectiveTrackerBonusBannerFrame = _G["ObjectiveTrackerBonusBannerFrame"]
local GetNumQuestWatches = GetNumQuestWatches
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetQuestLogTitle = GetQuestLogTitle
local GetQuestWatchInfo = GetQuestWatchInfo

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, QUEST_TRACKER_MODULE, OBJECTIVE_TRACKER_COLOR, ACHIEVEMENT_TRACKER_MODULE

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local dummy = function() return end

-- Level Text for QuestTracker
hooksecurefunc(QUEST_TRACKER_MODULE, "Update", function(self)
	for i = 1, GetNumQuestWatches() do
		local questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i)
		if not questID then
			break
		end
		local block = QUEST_TRACKER_MODULE:GetBlock(questID)
		local oldBlock = QUEST_TRACKER_MODULE:GetExistingBlock(questID)
		if oldBlock then
			local newTitle = "[" .. select(2, GetQuestLogTitle(questLogIndex)) .. "] " .. title
			QUEST_TRACKER_MODULE:SetStringText(oldBlock.HeaderText, newTitle, nil, OBJECTIVE_TRACKER_COLOR["Header"])
		end
		local heightcheck = block.HeaderText:GetNumLines()
		if heightcheck == 2 then
			local height = block:GetHeight()
			block:SetHeight(height + 16)
		end
	end
end)

-- Level Color for QuestTracker
hooksecurefunc(QUEST_TRACKER_MODULE, "Update", function()
	for i = 1, GetNumQuestWatches() do
		local questID, _, questIndex = GetQuestWatchInfo(i)
		if not questID then
			break
		end
		local _, level = GetQuestLogTitle(questIndex)
		local col = GetQuestDifficultyColor(level)
		local block = QUEST_TRACKER_MODULE:GetExistingBlock(questID)
		if block then
			block.HeaderText:SetTextColor(col.r, col.g, col.b)
			block.HeaderText.col = col
		end
	end
end)

hooksecurefunc("ObjectiveTrackerBlockHeader_OnLeave", function(self)
	local block = self:GetParent()
	if block.HeaderText.col then
		block.HeaderText:SetTextColor(block.HeaderText.col.r, block.HeaderText.col.g, block.HeaderText.col.b)
	end
end)

hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddObjective", function(self, block)
	if block.module == ACHIEVEMENT_TRACKER_MODULE then
		block.HeaderText:SetTextColor(0.75, 0.61, 0)
		block.HeaderText.col = nil
	end
end)

-- Skin bonus objective progress bar
hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(self, block, line)
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar
	local icon = bar.Icon
	local flare = progressBar.FullBarFlare1

	if not progressBar.styled then
		local label = bar.Label

		bar.BarFrame:Hide()
		bar.BarFrame2:Hide()
		bar.BarFrame3:Hide()
		bar.BarGlow:Kill()
		bar.IconBG:Kill()
		bar:SetSize(225, 18)
		bar:SetStatusBarTexture(LSM:Fetch('statusbar', 'MerathilisFlat'))
		bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
		bar:SetBackdropColor(0, 0, 0, 0)

		flare:Hide()

		label:ClearAllPoints()
		label:SetPoint("CENTER", bar, "CENTER", 0, 0)
		label:FontTemplate(LSM:Fetch('font', 'Merathilis Expressway', 16))

		icon:SetPoint("RIGHT", 24, 0)
		icon:SetSize(20, 20)

		local border = CreateFrame("Frame", "$parentBorder", bar)
		border:SetAllPoints(icon)
		border:SetTemplate("Transparent")
		border:SetBackdropColor(0, 0, 0, 0)
		bar.newIconBg = border

		bar.AnimIn.Play = dummy
		BonusObjectiveTrackerProgressBar_PlayFlareAnim = dummy
		progressBar.styled = true
	end

	bar.newIconBg:SetShown(icon:IsShown())
end)

-- Set tooltip depending on position
local function IsFramePositionedLeft(frame)
	local x = frame:GetCenter()
	local screenWidth = GetScreenWidth()
	local screenHeight = GetScreenHeight()
	local positionedLeft = false

	if x and x < (screenWidth / 2) then
		positionedLeft = true
	end

	return positionedLeft
end

hooksecurefunc("BonusObjectiveTracker_ShowRewardsTooltip", function(block)
	if IsFramePositionedLeft(ObjectiveTrackerFrame) then
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("TOPLEFT", block, "TOPRIGHT", 0, 0)
	end
end)

local function ObjectiveTrackerReskin()
	if IsAddOnLoaded("Blizzard_ObjectiveTracker") then
		if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectivetracker ~= true then return end

		for _, headerName in pairs({"QuestHeader", "AchievementHeader", "ScenarioHeader"}) do
			ObjectiveTrackerFrame.BlocksFrame[headerName].Background:Hide()
		end

		-- Quest
		ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 12, 'OUTLINE')
		ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)

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
