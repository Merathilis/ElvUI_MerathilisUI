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
local DEFAULT_OBJECTIVE_TRACKER_MODULE = _G["DEFAULT_OBJECTIVE_TRACKER_MODULE"]
local BONUS_OBJECTIVE_TRACKER_MODULE = _G["BONUS_OBJECTIVE_TRACKER_MODULE"]
local LevelUpDisplayScenarioFrame = _G["LevelUpDisplayScenarioFrame"]
local ObjectiveTrackerFrame = _G["ObjectiveTrackerFrame"]
local ObjectiveTrackerBlocksFrame = _G["ObjectiveTrackerBlocksFrame"]
local ObjectiveTrackerBonusBannerFrame = _G["ObjectiveTrackerBonusBannerFrame"]
local ObjectiveTrackerBonusRewardsFrame = _G["ObjectiveTrackerBonusRewardsFrame"]
local SCENARIO_CONTENT_TRACKER_MODULE = _G["SCENARIO_CONTENT_TRACKER_MODULE"]
local ScenarioStageBlock = _G["ScenarioStageBlock"]
local ScenarioProvingGroundsBlock = _G["ScenarioProvingGroundsBlock"]
local ScenarioProvingGroundsBlockAnim = _G["ScenarioProvingGroundsBlockAnim"]
local ScenarioChallengeModeBlock = _G["ScenarioChallengeModeBlock"]

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: BonusObjectiveTrackerProgressBar_PlayFlareAnim, hooksecurefunc

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

-- Dynamic Tooltip position for the Bonus Reward Frame
local function IsFramePositionedLeft(frame)
	local x = frame:GetCenter()
	local screenWidth = GetScreenWidth()
	local positionedLeft = false

	if x and x < (screenWidth / 2) then
		positionedLeft = true
	end

	return positionedLeft
end

hooksecurefunc("BonusObjectiveTracker_ShowRewardsTooltip", function(block)
	if IsFramePositionedLeft(ObjectiveTrackerFrame) then
		_G["GameTooltip"]:ClearAllPoints()
		_G["GameTooltip"]:SetPoint("TOPLEFT", block, "TOPRIGHT", 0, 0)
	end
end)

-- Hide the reward Animation for Dungeon and BonusObjective
ObjectiveTrackerScenarioRewardsFrame.Show = dummy

hooksecurefunc("BonusObjectiveTracker_AnimateReward", function(block)
	ObjectiveTrackerBonusRewardsFrame:ClearAllPoints()
	ObjectiveTrackerBonusRewardsFrame:SetPoint("BOTTOM", E.UIParent, "TOP", 0, 90)
end)

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

-- Scenario/Instances
local function SkinScenario()
	local block = ScenarioStageBlock
	local _, currentStage, numStages, flags = C_Scenario.GetInfo()

	-- pop-up artwork
	block.NormalBG:Hide()

	-- pop-up final artwork
	block.FinalBG:Hide()

	-- pop-up glow
	block.GlowTexture.AlphaAnim.Play = dummy
	block.GlowTexture:SetSize(width+20, 75)

	-- font
	block.Stage:SetVertexColor(classColor.r, classColor.g, classColor.b)

	-- Bar
	if bar and bar:IsShown() then
		local bar = ScenarioObjectiveBlock.currentLine.Bar

		bar:StripTextures()
		bar:CreateBackdrop('Transparent')
		bar:SetStatusBarTexture(flat)
		bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
		bar:SetSize(200, 15)
		
		bar.Label:SetFont(LSM:Fetch('font', 'Merathilis Prototype'), 12, 'OUTLINE')
		bar.Label:SetPoint("CENTER", bar, "CENTER", 0, 1)
	end
end

-- Proving grounds
local function SkinProvingGround()
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

-- Challenge Mode
local function SkinChallengeMode()
	local block = ScenarioChallengeModeBlock
	local sb = block.StatusBar

	-- Timer
	sb:StripTextures()
	sb:CreateBackdrop('Transparent')
	sb:SetStatusBarTexture(flat)
	sb:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
	sb:ClearAllPoints()
	sb:SetPoint("LEFT", block.MedalIcon, "RIGHT", 3, 0)
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
		
		-- Timer Bar
		hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", skinObjectiveBar)
		
		-- Quest
		ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetFont(LSM:Fetch('font', 'Merathilis Prototype'), 12, 'OUTLINE')
		ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
		
		-- Achievements
		ObjectiveTrackerBlocksFrame.AchievementHeader.Text:SetFont(LSM:Fetch('font', 'Merathilis Prototype'), 12, 'OUTLINE')
		ObjectiveTrackerBlocksFrame.AchievementHeader.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
		
		-- Bonus Objectives
		BONUS_OBJECTIVE_TRACKER_MODULE.Header.Text:SetFont(LSM:Fetch('font', 'Merathilis Prototype'), 12, 'OUTLINE')
		BONUS_OBJECTIVE_TRACKER_MODULE.Header.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
		BONUS_OBJECTIVE_TRACKER_MODULE.Header.Background:Hide()
		
		-- Bonus Objectives Banner Frame
		ObjectiveTrackerBonusBannerFrame.Title:SetVertexColor(classColor.r, classColor.g, classColor.b)
		ObjectiveTrackerBonusBannerFrame.BonusLabel:SetVertexColor(1, 1, 1)
		
		-- Scenario
		hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddTimerBar", SkinTimerBar)
		hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "Update", SkinScenario)
		hooksecurefunc("ScenarioBlocksFrame_OnLoad", SkinScenario)
		ObjectiveTrackerBlocksFrame.ScenarioHeader.Text:SetFont(LSM:Fetch('font', 'Merathilis Prototype'), 12, 'OUTLINE')
		ObjectiveTrackerBlocksFrame.ScenarioHeader.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
		
		-- Proving grounds
		hooksecurefunc("Scenario_ProvingGrounds_ShowBlock", SkinProvingGround)
		
		-- Challenge Mode
		hooksecurefunc("Scenario_ChallengeMode_ShowBlock", SkinChallengeMode)
		
		-- Menu Title
		ObjectiveTrackerFrame.HeaderMenu.Title:SetFont(LSM:Fetch('font', 'Merathilis Prototype'), 12, 'OUTLINE')
		ObjectiveTrackerFrame.HeaderMenu.Title:SetVertexColor(classColor.r, classColor.g, classColor.b)
		ObjectiveTrackerFrame.HeaderMenu.Title:SetAlpha(0)
		
		-- Underlines
		ObjectiveTrackerBlocksFrame.QuestHeader.Underline = MER:Underline(ObjectiveTrackerBlocksFrame.QuestHeader, true, 1)
		ObjectiveTrackerBlocksFrame.AchievementHeader.Underline = MER:Underline(ObjectiveTrackerBlocksFrame.AchievementHeader, true, 1)
		BONUS_OBJECTIVE_TRACKER_MODULE.Header.Underline = MER:Underline(BONUS_OBJECTIVE_TRACKER_MODULE.Header, true, 1)
		ObjectiveTrackerBlocksFrame.ScenarioHeader.Underline = MER:Underline(ObjectiveTrackerBlocksFrame.ScenarioHeader, true, 1)
		
		-- Instances
		LevelUpDisplayScenarioFrame.level:SetVertexColor(classColor.r, classColor.g, classColor.b)
	end
end
hooksecurefunc(S, "Initialize", ObjectiveTrackerReskin)
