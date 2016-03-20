local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local LSM = LibStub('LibSharedMedia-3.0');
local S = E:GetModule('Skins');

-- Cache global variables
-- GLOBALS: C_Scenario, BonusObjectiveTrackerProgressBar_PlayFlareAnim, hooksecurefunc, CreateFrame, IsAddOnLoaded, TRIVIAL_QUEST_DISPLAY, NORMAL_QUEST_DISPLAY, QUEST_TRACKER_MODULE
-- GLOBALS: OBJECTIVE_TRACKER_COLOR, QuestLogQuests_GetTitleButton, DEFAULT_OBJECTIVE_TRACKER_MODULE, SCENARIO_CONTENT_TRACKER_MODULE
local _G = _G
local select, table, unpack = select, table, unpack

local GetGossipActiveQuests = GetGossipActiveQuests
local GetGossipAvailableQuests = GetGossipAvailableQuests
local GetNumQuestLogEntries = GetNumQuestLogEntries
local GetNumQuestWatches = GetNumQuestWatches
local GetQuestLogTitle = GetQuestLogTitle
local GetQuestWatchInfo = GetQuestWatchInfo
local GossipResize = GossipResize
local ObjectiveTrackerBlocksFrame = ObjectiveTrackerBlocksFrame
local ScenarioStageBlock = ScenarioStageBlock
local ScenarioProvingGroundsBlock = ScenarioProvingGroundsBlock
local ScenarioProvingGroundsBlockAnim = ScenarioProvingGroundsBlockAnim

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local width = 190
local dummy = function() return end
local flat = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Flat]]

-- Objective Tracker Bar
local function skinObjectiveBar(self, block, line)
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar
	local icon = bar.Icon
	local flare = progressBar.FullBarFlare1

	if not progressBar.styled then
		local label = bar.Label

		bar.BarBG:Hide()
		bar.BarFrame:Hide()
		bar.BarFrame2:Hide()
		bar.BarFrame3:Hide()
		bar.BarGlow:Kill()
		bar:SetSize(225, 18)

		bar:SetStatusBarTexture(flat)
		bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
		bar:CreateBackdrop('Transparent')
		bar:SetFrameStrata('HIGH')

		flare:Hide()

		label:ClearAllPoints()
		label:SetPoint('CENTER', bar, -1, 0)
		label:FontTemplate()

		BonusObjectiveTrackerProgressBar_PlayFlareAnim = dummy
		progressBar.styled = true
	end

	if icon then icon:Hide() end
	bar.IconBG:Hide()
end

-- Timer bars
local function SkinTimerBar(self, block, line, duration, startTime)
	local tb = self.usedTimerBars[block] and self.usedTimerBars[block][line]

	if tb and tb:IsShown() and not tb.skinned then
		tb.Bar.BorderMid:Hide()
		tb.Bar:StripTextures()
		tb.Bar:CreateBackdrop('Transparent')
		tb.Bar:SetStatusBarTexture(flat)
		tb.Bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
		tb.skinned = true
	end
end

-- Scenario buttons
local function SkinScenarioButtons()
	local block = ScenarioStageBlock
	local _, currentStage, numStages, flags = C_Scenario.GetInfo()
	local inChallengeMode = C_Scenario.IsChallengeMode()

	-- pop-up artwork
	block.NormalBG:Hide()
	block.NormalBG:SetSize(width + 21, 75)

	-- pop-up final artwork
	block.FinalBG:ClearAllPoints()
	block.FinalBG:SetPoint("TOPLEFT", block.NormalBG, 6, -6)
	block.FinalBG:SetPoint("BOTTOMRIGHT", block.NormalBG, -6, 6)

	-- pop-up glow
	block.GlowTexture.AlphaAnim.Play = dummy
	block.GlowTexture:SetSize(width+20, 75)
end

-- Proving grounds
local function SkinProvingGroundButtons()
	local block = ScenarioProvingGroundsBlock
	local sb = block.StatusBar
	local anim = ScenarioProvingGroundsBlockAnim

	block.MedalIcon:SetSize(42, 42)
	block.MedalIcon:ClearAllPoints()
	block.MedalIcon:SetPoint("TOPLEFT", block, 20, -10)

	block.WaveLabel:ClearAllPoints()
	block.WaveLabel:SetPoint("LEFT", block.MedalIcon, "RIGHT", 3, 0)

	block.BG:Hide()
	block.BG:SetSize(width + 21, 75)

	block.GoldCurlies:Hide()
	block.GoldCurlies:ClearAllPoints()
	block.GoldCurlies:SetPoint("TOPLEFT", block.BG, 6, -6)
	block.GoldCurlies:SetPoint("BOTTOMRIGHT", block.BG, -6, 6)

	anim.BGAnim:Hide()
	anim.BGAnim:SetSize(width + 45, 85)
	anim.BorderAnim:SetSize(width + 21, 75)
	anim.BorderAnim:Hide()
	anim.BorderAnim:ClearAllPoints()
	anim.BorderAnim:SetPoint("TOPLEFT", block.BG, 8, -8)
	anim.BorderAnim:SetPoint("BOTTOMRIGHT", block.BG, -8, 8)

	-- Timer
	sb:StripTextures()
	sb:CreateBackdrop('Transparent')
	sb:SetStatusBarTexture(flat)
	sb:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
	sb:ClearAllPoints()
	sb:SetPoint('TOPLEFT', block.MedalIcon, 'BOTTOMLEFT', -4, -5)
	sb:SetSize(200, 15)

	-- Create a little border around the Bar.
	local sb2 = sb:GetParent():CreateTexture(nil, 'BACKGROUND')
	sb2:SetPoint('TOPLEFT', sb, -1, 1)
	sb2:SetPoint('BOTTOMRIGHT', sb, 1, -1)
	sb2:SetTexture(flat)
	sb2:SetAlpha(0.5)
	sb2:SetVertexColor(unpack(E.media.backdropcolor))
end

-- Initialize
local function ObjectiveTrackerReskin()
	if IsAddOnLoaded("Blizzard_ObjectiveTracker") then
		if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectivetracker ~= true then return end
		
		-- Quest
		ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetFont(LSM:Fetch('font', 'Merathilis Prototype'), 12, 'OUTLINE')
		ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
		
		-- Achievements
		ObjectiveTrackerBlocksFrame.AchievementHeader.Text:SetFont(LSM:Fetch('font', 'Merathilis Prototype'), 12, 'OUTLINE')
		ObjectiveTrackerBlocksFrame.AchievementHeader.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
		
		-- Bonus Objectives
		_G['BONUS_OBJECTIVE_TRACKER_MODULE'].Header.Text:SetFont(LSM:Fetch('font', 'Merathilis Prototype'), 12, 'OUTLINE')
		_G['BONUS_OBJECTIVE_TRACKER_MODULE'].Header.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
		_G['BONUS_OBJECTIVE_TRACKER_MODULE'].Header.Background:Hide()
		
		-- Scenario
		hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddTimerBar", SkinTimerBar)
		hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "Update", SkinScenarioButtons)
		hooksecurefunc("ScenarioBlocksFrame_OnLoad", SkinScenarioButtons)
		ObjectiveTrackerBlocksFrame.ScenarioHeader.Text:SetFont(LSM:Fetch('font', 'Merathilis Prototype'), 12, 'OUTLINE')
		ObjectiveTrackerBlocksFrame.ScenarioHeader.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
		
		-- Proving grounds
		hooksecurefunc("Scenario_ProvingGrounds_ShowBlock", SkinProvingGroundButtons)
		
		-- Timer Bar
		hooksecurefunc(_G['BONUS_OBJECTIVE_TRACKER_MODULE'], "AddProgressBar", skinObjectiveBar)
		
		-- Menu Title
		_G['ObjectiveTrackerFrame'].HeaderMenu.Title:SetFont(LSM:Fetch('font', 'Merathilis Prototype'), 12, 'OUTLINE')
		_G['ObjectiveTrackerFrame'].HeaderMenu.Title:SetVertexColor(classColor.r, classColor.g, classColor.b)
		_G['ObjectiveTrackerFrame'].HeaderMenu.Title:SetAlpha(0)
		
		-- Underlines
		_G["ObjectiveTrackerBlocksFrame"].QuestHeader.Underline = MER:Underline(_G["ObjectiveTrackerBlocksFrame"].QuestHeader, true, 1)
		_G["ObjectiveTrackerBlocksFrame"].AchievementHeader.Underline = MER:Underline(_G["ObjectiveTrackerBlocksFrame"].AchievementHeader, true, 1)
		_G['BONUS_OBJECTIVE_TRACKER_MODULE'].Header.Underline = MER:Underline(_G['BONUS_OBJECTIVE_TRACKER_MODULE'].Header, true, 1)
		_G["ObjectiveTrackerBlocksFrame"].ScenarioHeader.Underline = MER:Underline(_G["ObjectiveTrackerBlocksFrame"].ScenarioHeader, true, 1)
	end
end
hooksecurefunc(S, "Initialize", ObjectiveTrackerReskin)