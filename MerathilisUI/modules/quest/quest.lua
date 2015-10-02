local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

if IsAddOnLoaded("ObjectiveTrackerForModernists") then return end
if E.db.muiSkins == nil then E.db.muiSkins = {} end -- prevent a nil error
if E.db.muiSkins.Quest == false then return end

-- Taken from Objectiv Tracker by ObbleYeah

-- Config:
-- set height of the objective tracker frame.
local otfheight = 450

-- set width of the objective tracker frame.

local otfwidth = 188

-- set font size of objective titles
local titlesize = 13

--Colors:
local _, class = UnitClass("player")
local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
local otf = ObjectiveTrackerFrame

-- Make the tracker moveable
otf:SetClampedToScreen(true)
otf:ClearAllPoints()
otf.ClearAllPoints = function() end
otf:SetPoint("TOPRIGHT", E.UIParent, "TOPRIGHT", -122, -292) 
otf.SetPoint = function() end
otf:SetMovable(true)
otf:SetUserPlaced(true)
otf:SetHeight(otfheight)
otf:SetWidth(otfwidth)

local otfmove = CreateFrame("FRAME", nil, otf)  
otfmove:SetHeight(16)
otfmove:SetPoint("TOPLEFT", otf, 110, 0)
otfmove:SetPoint("TOPRIGHT", otf)
otfmove:EnableMouse(true)
otfmove:RegisterForDrag("LeftButton")
otfmove:SetHitRectInsets(-5, -5, -5, -5)

local function OTFM_Tooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOP")
	GameTooltip:AddLine("Shift + drag to move", color.r, color.g, color.b)
	GameTooltip:Show()
end

otfmove:SetScript("OnDragStart", function(self, button)
	if IsModifiedClick() and button=="LeftButton" then
		local f = self:GetParent()
		f:StartMoving()
	end
end)

otfmove:SetScript("OnDragStop", function(self, button)
	local f = self:GetParent()
	f:StopMovingOrSizing()
end)

otfmove:SetScript("OnEnter", function(s)
	OTFM_Tooltip(s)
end)

otfmove:SetScript("OnLeave", function(s)
	GameTooltip:Hide()
end)

-- collapse the watchframe if in a bossfight
-- or arena 
-- or if the world state capture bar is showing.
-- written with oWatchFrameToggler by haste as a base
-- https://github.com/haste/oWatchFrameToggler/blob/master/auto.lua

local otfboss = CreateFrame("Frame", nil)
otfboss:RegisterEvent("PLAYER_ENTERING_WORLD")
otfboss:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
otfboss:RegisterEvent("UNIT_TARGETABLE_CHANGED")
otfboss:RegisterEvent("PLAYER_REGEN_ENABLED")
otfboss:RegisterEvent("UPDATE_WORLD_STATES")

local function bossexists()
	for i = 1, MAX_BOSS_FRAMES do
		if UnitExists("boss"..i) then
			return true
		end
	end
end

otfboss:SetScript("OnEvent", function(self, event)
local _, instanceType = IsInInstance()
local bar = _G["WorldStateCaptureBar1"]
local mapcheck = GetMapInfo(mapFileName)

-- collapse if there's a boss
	if bossexists() then
		if not otf.collapsed then
			ObjectiveTracker_Collapse()
		end
-- or we're pvping
	elseif instanceType=="arena" or instanceType=="pvp" then
		if not otf.collapsed then
			ObjectiveTracker_Collapse()
		end
-- or if we get a tracker bar appear.
	elseif bar and bar:IsVisible() then
		if not otf.collapsed then
			ObjectiveTracker_Collapse()
		end
-- open back up afterward if we're in a raid 
	elseif otf.collapsed and instanceType=="raid" and not InCombatLockdown() then
		ObjectiveTracker_Expand()
-- or in Ashran.
-- add other maps here at some point? Wintergrasp etc. might be needed
	elseif otf.collapsed and mapcheck=="Ashran" and not InCombatLockdown() then
		ObjectiveTracker_Expand()
	end
end)

-- Color block headers by class

-- style
-- quests
hooksecurefunc(QUEST_TRACKER_MODULE, "Update", function(self)
	for i = 1, GetNumQuestWatches() do
		local questID = GetQuestWatchInfo(i)
		if not questID then
			break
		end
		local block = QUEST_TRACKER_MODULE:GetBlock(questID)

		block.HeaderText:SetFont(STANDARD_TEXT_FONT, 12)
		block.HeaderText:SetShadowOffset(.7, -.7)
		block.HeaderText:SetShadowColor(0, 0, 0, 1)
		block.HeaderText:SetTextColor(color.r, color.g, color.b)
		block.HeaderText:SetJustifyH("LEFT")
		block.HeaderText:SetWidth(otfwidth)
		block.HeaderText:SetWordWrap(true)

-- fix overlap from double-lined headers
		local heightcheck = block.HeaderText:GetNumLines()

		if heightcheck==2 then
			local height = block:GetHeight()

			block:SetHeight(height + 16)
		end
	end
end)

-- keep quest style consistant on enter/leave  
local function hoverquest()
for i = 1, GetNumQuestWatches() do
	local id = GetQuestWatchInfo(i)
	if not id then
		break
	end
	local block = QUEST_TRACKER_MODULE:GetBlock(id)

	block.HeaderText:SetTextColor(color.r, color.g, color.b)
	end
end

hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderEnter", hoverquest)  
hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderLeave", hoverquest)

-- achievements
-- incomplete, hovering breaks recoloring
hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "Update", function(self)
	local trackedAchievements = {GetTrackedAchievements()}

	for i = 1, #trackedAchievements do
		local achieveID = trackedAchievements[i]
		local _, achievementName, _, completed, _, _, _, description, _, icon, _, _, wasEarnedByMe = GetAchievementInfo(achieveID)
		local showAchievement = true

		if wasEarnedByMe then
			showAchievement = false
		elseif displayOnlyArena then
			if GetAchievementCategory(achieveID)~=ARENA_CATEGORY then
				showAchievement = false
			end
		end

		if showAchievement then
			local block = ACHIEVEMENT_TRACKER_MODULE:GetBlock(achieveID)

			block.HeaderText:SetFont(STANDARD_TEXT_FONT, 12)
			block.HeaderText:SetShadowOffset(.7, -.7)
			block.HeaderText:SetShadowColor(0, 0, 0, 1)
			block.HeaderText:SetTextColor(color.r, color.g, color.b)
			block.HeaderText:SetJustifyH("LEFT")
			block.HeaderText:SetWidth(otfwidth)
		end
	end
end)

local function hoverachieve()
	local trackedachievements = {GetTrackedAchievements()}

	for i = 1, #trackedachievements do
		local id = trackedachievements[i]
		if not id then
			break
		end
		local block = ACHIEVEMENT_TRACKER_MODULE:GetBlock(id)

		block.HeaderText:SetTextColor(color.r, color.g, color.b)
	end
end

hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderEnter", hoverachieve)
hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderLeave", hoverachieve)

-- Hide header art & restyle text
if IsAddOnLoaded("Blizzard_ObjectiveTracker") then
	hooksecurefunc("ObjectiveTracker_Update", function(reason, id)
		if otf.MODULES then  
			for i = 1, #otf.MODULES do                               
				otf.MODULES[i].Header.Background:SetAtlas(nil)
				otf.MODULES[i].Header.Text:SetFont(STANDARD_TEXT_FONT, 12)
				otf.MODULES[i].Header.Text:ClearAllPoints()
				otf.MODULES[i].Header.Text:SetPoint("RIGHT", otf.MODULES[i].Header, -62, 0)
				otf.MODULES[i].Header.Text:SetJustifyH("RIGHT")
			end
		end
	end)
end

-- Timer bars
hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddTimerBar", function(self, block, line, duration, startTime)
	local tb = self.usedTimerBars[block] and self.usedTimerBars[block][line]

	if tb and tb:IsShown() and not tb.skinned then
		tb.Bar:SetStatusBarTexture("Interface\\AddOns\\MerathilisUI\\media\\textures\\Flat.tga")
		tb.Bar:SetStatusBarColor(color.r, color.g, color.b)
		tb.skinned = true
	end
end)

-- Scenario buttons

local function SkinScenarioButtons()
	local block = ScenarioStageBlock
	local _, currentStage, numStages, flags = C_Scenario.GetInfo()
	local inChallengeMode = C_Scenario.IsChallengeMode()

	-- we have to independently resize the artwork
	-- because we're messing with the tracker width >_>
	-- pop-up artwork
	block.NormalBG:SetSize(otfwidth + 21, 75)

	-- pop-up final artwork
	block.FinalBG:ClearAllPoints()
	block.FinalBG:SetPoint("TOPLEFT", block.NormalBG, 6, -6)
	block.FinalBG:SetPoint("BOTTOMRIGHT", block.NormalBG, -6, 6)

	-- pop-up glow
	block.GlowTexture:SetSize(otfwidth+20, 75)
end

-- Proving grounds

local function SkinProvingGroundButtons()
	local block = ScenarioProvingGroundsBlock
	local sb = block.StatusBar
	local anim = ScenarioProvingGroundsBlockAnim

	block.MedalIcon:SetSize(32, 32)
	block.MedalIcon:ClearAllPoints()
	block.MedalIcon:SetPoint("TOPLEFT", block, 20, -10)

	block.WaveLabel:ClearAllPoints()
	block.WaveLabel:SetPoint("LEFT", block.MedalIcon, "RIGHT", 3, 0)

	block.BG:SetSize(otfwidth + 21, 75)

	block.GoldCurlies:ClearAllPoints()
	block.GoldCurlies:SetPoint("TOPLEFT", block.BG, 6, -6)
	block.GoldCurlies:SetPoint("BOTTOMRIGHT", block.BG, -6, 6)

	anim.BGAnim:SetSize(otfwidth + 21, 75)
	anim.BorderAnim:SetSize(otfwidth + 21, 75)
	anim.BorderAnim:ClearAllPoints()
	anim.BorderAnim:SetPoint("TOPLEFT", block.BG, 8, -8)
	anim.BorderAnim:SetPoint("BOTTOMRIGHT", block.BG, -8, 8)

	sb:SetStatusBarTexture("Interface\\AddOns\\MerathilisUI\\media\\textures\\Flat.tga")
	sb:SetStatusBarColor(color.r, color.g, color.b)
	sb:ClearAllPoints()
	sb:SetPoint("TOPLEFT", block.MedalIcon, "BOTTOMLEFT", -4, -5)
end

-- auto-quest pop ups
-- 6.0 ready!

local function alterAQButton()
	local pop = GetNumAutoQuestPopUps()
	for i = 1, pop do
		local questID, popUpType = GetAutoQuestPopUp(i)
		local questTitle = GetQuestLogTitle(GetQuestLogIndexByID(questID))

		if questTitle and questTitle~="" then
			local block = AUTO_QUEST_POPUP_TRACKER_MODULE:GetBlock(questID)
			if block then
				local blockframe = block.ScrollChild

				local aqf = CreateFrame("Frame", nil, blockframe)
				aqf:SetPoint("TOPLEFT", blockframe, -1, 1)
				aqf:SetPoint("BOTTOMRIGHT", blockframe, -1, 1)
				aqf:SetFrameStrata("DIALOG")
				blockframe.aqf = aqf
				if popUpType=="COMPLETE" then
					blockframe.QuestIconBg:ClearAllPoints()
					blockframe.QuestIconBg:SetPoint("CENTER", blockframe.aqf, "LEFT", 35, -2)
					blockframe.QuestIconBg:SetParent(blockframe.aqf)
					blockframe.QuestIconBg:SetDrawLayer("OVERLAY", 4)
					blockframe.QuestionMark:ClearAllPoints()
					blockframe.QuestionMark:SetPoint("CENTER", blockframe.aqf, "LEFT", 35, -2)
					blockframe.QuestionMark:SetParent(blockframe.aqf)
					blockframe.QuestionMark:SetDrawLayer("OVERLAY", 7)
				elseif popUpType=="OFFER" then
					blockframe.QuestIconBg:ClearAllPoints()
					blockframe.QuestIconBg:SetPoint("CENTER", blockframe.aqf, "LEFT", 35, -2)
					blockframe.QuestIconBg:SetParent(blockframe.aqf)
					blockframe.QuestIconBg:SetDrawLayer("OVERLAY", 4)
					blockframe.Exclamation:ClearAllPoints()
					blockframe.Exclamation:SetPoint("CENTER", blockframe.aqf, "LEFT", 35, -2)
					blockframe.Exclamation:SetParent(blockframe.aqf)
					blockframe.Exclamation:SetDrawLayer("OVERLAY", 7)
				end
			end
		end
	end
end

-- Implement
local ObjFhandler = CreateFrame("Frame")
ObjFhandler:RegisterEvent("ADDON_LOADED")
ObjFhandler:RegisterEvent("PLAYER_ENTERING_WORLD")
ObjFhandler:RegisterEvent("QUEST_AUTOCOMPLETE")
ObjFhandler:RegisterEvent("QUEST_LOG_UPDATE")

ObjFhandler:SetScript("OnEvent", function(self, event, AddOn)
	if AddOn=="Blizzard_ObjectiveTracker" then
		alterAQButton()
	end
end)

if IsAddOnLoaded("Blizzard_ObjectiveTracker") then
-- scenario
	hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "Update", SkinScenarioButtons)
	hooksecurefunc("ScenarioBlocksFrame_OnLoad", SkinScenarioButtons)
-- proving grounds
	hooksecurefunc("Scenario_ProvingGrounds_ShowBlock", SkinProvingGroundButtons)
-- auto-quest pop ups
	hooksecurefunc("AutoQuestPopupTracker_AddPopUp", function(questID, popUpType)
		if AddAutoQuestPopUp(questID, popUpType) then
			alterAQButton()
		end
	end)
	hooksecurefunc(AUTO_QUEST_POPUP_TRACKER_MODULE, "Update", alterAQButton)
end

