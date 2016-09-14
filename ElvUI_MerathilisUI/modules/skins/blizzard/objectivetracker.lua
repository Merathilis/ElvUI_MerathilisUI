local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERS = E:GetModule('MuiSkins')
local LSM = LibStub('LibSharedMedia-3.0');

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
local gsub = gsub
-- WoW API / Variables
local C_Scenario = C_Scenario
local CreateFrame = CreateFrame
local GetAutoQuestPopUp = GetAutoQuestPopUp
local GetNumQuestWatches = GetNumQuestWatches
local GetNumAutoQuestPopUps = GetNumAutoQuestPopUps
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetQuestIndexForWatch = GetQuestIndexForWatch
local GetQuestLogIndexByID = GetQuestLogIndexByID
local GetQuestLogTitle = GetQuestLogTitle
local GetQuestWatchInfo = GetQuestWatchInfo
local IsAddOnLoaded = IsAddOnLoaded
local IsInInstance = IsInInstance
local UnitExists = UnitExists
local LE_QUEST_FREQUENCY_DAILY = LE_QUEST_FREQUENCY_DAILY
local LE_QUEST_FREQUENCY_WEEKLY = LE_QUEST_FREQUENCY_WEEKLY

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, MAX_BOSS_FRAMES, ObjectiveTracker_Collapse, ObjectiveTracker_Expand, OBJECTIVE_TRACKER_COLOR
-- GLOBALS: OBJECTIVE_TRACKER_COLOR, OBJECTIVE_TRACKER_COLOR, OBJECTIVE_TRACKER_HEADER_HEIGHT, OBJECTIVE_TRACKER_HEADER_HEIGHT
-- GLOBALS: BonusObjectiveTrackerProgressBar_PlayFlareAnim, AUTO_QUEST_POPUP_TRACKER_MODULE, ScenarioProvingGroundsBlock
-- GLOBALS: ScenarioProvingGroundsBlockAnim, OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT, OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT
-- GLOBALS: QUEST_TRACKER_MODULE, ObjectiveTracker_Initialize, ObjectiveTracker_Initialize, QuestSuperTracking_ChooseClosestQuest
-- GLOBALS: ObjectiveTracker_Update, SCENARIO_CONTENT_TRACKER_MODULE, ObjectiveTrackerBonusRewardsFrame
-- GLOBALS: ObjectiveTrackerScenarioRewardsFrame, SkinObjectiveItem, _, bossexists

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local height = 500 -- overall height
local width = 160 -- overall width

-- Blizzard Frames
local otf = _G["ObjectiveTrackerFrame"]
local ScenarioStageBlock = _G["ScenarioStageBlock"]

-- Boss check
local function bossexist()
	for i = 1, MAX_BOSS_FRAMES do
		if UnitExists('boss'..i) then return true end
	end
end

-- Arena check
local function arenaexists()
	for i = 1, 5 do
		if UnitExists('arena'..i) then return true end
	end
end

local function CollapseExpandOTF(self, event)
	local _, instanceType = IsInInstance()
	local bar = _G['WorldStateCaptureBar1']
	if E.private.muiSkins.blizzard.objectivetracker.autoHide then
		-- collapse if there's a boss
		if bossexists() or arenaexists() then
			if not otf.boss then ObjectiveTracker_Collapse() otf.boss = true end
		-- or if we get a tracker bar appear.
		elseif event == 'UPDATE_WORLD_STATES' and bar and bar:IsVisible() then
			if not otf.boss then ObjectiveTracker_Collapse() otf.boss = true end
		else
			ObjectiveTracker_Expand()
			otf.boss = false
		end
	end
end

-- Minimize button
local function AddMinimizeButton()
	local min = otf.HeaderMenu.MinimizeButton
	min:SetSize(15, 15)
	min:ClearAllPoints()
	min:SetPoint('TOPRIGHT', otf, 25, -4)
	min:SetNormalTexture('')
	min:SetPushedTexture('')

	min.minus = min:CreateFontString(nil, 'OVERLAY')
	min.minus:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 15, nil)
	min.minus:SetText('>')
	min.minus:SetPoint('CENTER')
	min.minus:SetTextColor(1, 1, 1)
	min.minus:SetShadowOffset(1, -1)
	min.minus:SetShadowColor(0, 0, 0, 1)

	min.plus = min:CreateFontString(nil, 'OVERLAY')
	min.plus:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 15, nil)
	min.plus:SetText('<')
	min.plus:SetPoint('CENTER')
	min.plus:SetTextColor(1, 1, 1)
	min.plus:SetShadowOffset(1, -1)
	min.plus:SetShadowColor(0, 0, 0, 1)
	min.plus:Hide()

	min:HookScript('OnEnter', function() min.minus:SetTextColor(1, 1, 1) min.plus:SetTextColor(1, 1, 1) end)
	min:HookScript('OnLeave', function() min.minus:SetTextColor(1, 1, 1) min.plus:SetTextColor(1, 1, 1) end)

	hooksecurefunc('ObjectiveTracker_Collapse', function() min.plus:Show() min.minus:Hide() end)
	hooksecurefunc('ObjectiveTracker_Expand', function() min.plus:Hide() min.minus:Show() end)
end

-- Headermenu Title
local function AddHeaderTitle()
	local title = otf.HeaderMenu.Title
	title:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 13, "OUTLINE")
	title:SetVertexColor(classColor.r, classColor.g, classColor.b)
	title:ClearAllPoints()
	title:SetPoint('RIGHT', otf.HeaderMenu.MinimizeButton, 'LEFT', 0, 0)

	OBJECTIVE_TRACKER_COLOR['Header'] = {r = classColor.r, g = classColor.g, b = classColor.b}
	OBJECTIVE_TRACKER_COLOR['HeaderHighlight'] = {r = classColor.r*1.2, g = classColor.g*1.2, b = classColor.b*1.2}
	DEFAULT_OBJECTIVE_TRACKER_MODULE['blockOffsetY'] = -10
end

-- Skin Items
local function SkinObjectiveItems(self)
	if self and not self.skinned then
		MER:BU(self)
		self.skinned = true
	end
end

-- Move Items
local function MoveObjectiveItem(self)
	local _, parent = self:GetPoint()
	self:ClearAllPoints()
	self:SetPoint('TOPRIGHT', parent, 'TOPLEFT', -13, -7)
	self:SetFrameLevel(0)
end

local function AddTitleSubs(line)
	local t = line.Text:GetText()
	t = gsub(t, 'WANTED:', '|cffff0000W:|r')
	t = gsub(t, 'DANGER:', '|cffff0000D:|r')
	t = gsub(t, 'Warden Tower Assault:', '|cffff0000PvP:|r')
	line.Text:SetText(t)
end

local function AddLines(line, key)
	local r, g, b = line.Text:GetTextColor()
	AddTitleSubs(line)
	line:SetWidth(width)

	line.Text:SetFont(STANDARD_TEXT_FONT, key == 0 and 12 or 11)
	line.Text:SetWidth(width+55)

	if line.Dash and line.Dash:IsShown() then
		line.Dash:SetText'• '
	end
end

local function AddHeader()
	if otf.MODULES then
		for i = 1, #otf.MODULES do
			local module = otf.MODULES[i]
			module.Header.Background:SetAtlas(nil)
			-- Header font
			module.Header.Text:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 14, "OUTLINE")
			module.Header.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
			module.Header.Text:ClearAllPoints()
			module.Header.Text:SetPoint('RIGHT', otf.MODULES[i].Header, -62, 0)

			-- Underlines
			if E.private.muiSkins.blizzard.objectivetracker.underlines then
				module.Header.Underline = MER:Underline(otf.MODULES[i].Header, true, 1)
			end

			-- Backdrop
			if E.private.muiSkins.blizzard.objectivetracker.backdrop then
				module.Header:CreateBackdrop("Transparent")
				module.Header.backdrop:Point("TOPLEFT", -3, 0)
			end
		end
	end
end

local function AddObjective(self, block, key)
	local header = block.HeaderText
	local line = block.lines[key]

	if header then
		local r, g, b = header:GetTextColor()
		header:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 12, nil)
		header:SetShadowOffset(.7, -.7)
		header:SetShadowColor(0, 0, 0, 1)
		header:SetJustifyH('LEFT')
		header:SetWidth(width + 21)
		header:SetWordWrap(true)
		if header:GetNumLines() > 1 then
			OBJECTIVE_TRACKER_HEADER_HEIGHT = OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT
		else
			OBJECTIVE_TRACKER_HEADER_HEIGHT = 25
		end
	end

	block.lineWidth = width + 21

	AddLines(line, key)
end

local function AddProgressBar(self, block, line)
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar

	bar:StripTextures()
	bar:SetHeight(9)
	bar:SetStatusBarTexture(E["media"].MuiFlat)
	bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)

	bar:SetStatusBarTexture(E["media"].MuiFlat)
	bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
	bar:CreateBackdrop("Transparent")
	bar.backdrop:Point("TOPLEFT", bar, -1, 1)
	bar.backdrop:Point("BOTTOMRIGHT", bar, 1, -1)

	local _, parent = progressBar:GetPoint()
	progressBar:ClearAllPoints()
	progressBar:SetPoint('TOPLEFT', parent, 'TOPLEFT', 0, -10)
	progressBar:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 0, -20)

	bar:ClearAllPoints()
	bar:SetPoint('TOPLEFT', progressBar, 20, 0)
	bar:SetWidth(width + 21)

	for _, v in pairs({bar.BarFrame, bar.Icon, bar.IconBG, bar.BorderLeft, bar.BorderRight, bar.BorderMid}) do
		if v then v:Hide() end
	end

	bar.Label:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 15, "OUTLINE")
	bar.Label:SetShadowOffset(0, -0)
	bar.Label:SetJustifyH('CENTER')
	bar.Label:ClearAllPoints()
	bar.Label:SetPoint('CENTER', bar, 'BOTTOM', 0, -1)
	bar.Label:SetDrawLayer('OVERLAY', 7)

	if bar.AnimIn then
		bar.AnimIn.Play = function() end
	end

	if bar.BarGlow then
		bar.BarGlow:Kill()
	end

	BonusObjectiveTrackerProgressBar_PlayFlareAnim = function() end
end

local function AddTimerBar(self, block, line, duration, startTime)
	local bar = self.usedTimerBars[block] and self.usedTimerBars[block][line]

	bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
	bar:SetHeight(9)

	if not bar.styled then
		local bg = CreateFrame('Frame', nil, bar)
		bg:SetPoint('TOPLEFT', bar)
		bg:SetPoint('BOTTOMRIGHT', bar)
		bg:SetFrameLevel(0)
		bar.styled = true
	end

	bar.Label:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 11, 'THINOUTLINE')
	bar.Label:SetShadowOffset(0, -0)
	bar.Label:ClearAllPoints()
	bar.Label:SetPoint('CENTER', bar, 'BOTTOM', 1, -2)
	bar.Label:SetDrawLayer('OVERLAY', 7)
end

local function AddPopUp()
	for i = 1, GetNumAutoQuestPopUps() do
		local id, type = GetAutoQuestPopUp(i)
		local title = GetQuestLogTitle(GetQuestLogIndexByID(id))
		if title and title ~= '' then
			local block = AUTO_QUEST_POPUP_TRACKER_MODULE:GetBlock(id)
			if block then
				local f = block.ScrollChild
				if not f.bu then
					local bu = CreateFrame('Frame', nil, f)
					bu:SetPoint('TOPLEFT', f, 40, -4)
					bu:SetPoint('BOTTOMRIGHT', f, 0, 4)
					bu:SetFrameLevel(0)
					f.bu = bu

					f.FlashFrame.IconFlash:Hide()
				end

				if type == 'COMPLETE' then
					f.QuestIconBg:SetAlpha(0) f.QuestIconBadgeBorder:SetAlpha(0)
					f.QuestionMark:ClearAllPoints()
					f.QuestionMark:SetPoint('CENTER', f.bu, 'LEFT', 10, 0)
					f.QuestionMark:SetParent(f.bu)
					f.QuestionMark:SetDrawLayer('OVERLAY', 7)
					f.IconShine:Hide()
				elseif type == 'OFFER' then
					f.QuestIconBg:SetAlpha(0) f.QuestIconBadgeBorder:SetAlpha(0)
					f.Exclamation:ClearAllPoints()
					f.Exclamation:SetPoint('CENTER', f.bu, 'LEFT', 10, 0)
					f.Exclamation:SetParent(f.bu)
					f.Exclamation:SetDrawLayer('OVERLAY', 7)
				end

				f.FlashFrame:Hide()
				f.Bg:Hide()
				for _, v in pairs({f.BorderTopLeft, f.BorderTopRight, f.BorderBotLeft, f.BorderBotRight, f.BorderLeft, f.BorderRight, f.BorderTop, f.BorderBottom}) do
					v:Hide()
				end
			end
		end
	end
end

local function AddScenarioButton()
	local block = ScenarioStageBlock
	local _, current, num, flag = C_Scenario.GetInfo()

	block:SetSize(width + 21, ScenarioStageBlock.Name:GetNumLines() > 1 and 70 or 40)

	block.NormalBG:SetWidth(width + 21)
	block.NormalBG:SetTexture('')

	block.FinalBG:SetSize(width + 21, 50)
	block.FinalBG:SetTexture('')

	block.Stage:ClearAllPoints()
	block.Stage:SetPoint('LEFT', 17, 0)

	block.GlowTexture:SetWidth(width + 20)
	block.GlowTexture:SetTexture('')

	ScenarioStageBlock.Stage:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 14, nil)
end

local function AddProvingGroundButton()
	local block = ScenarioProvingGroundsBlock
	local anim = ScenarioProvingGroundsBlockAnim
	local sb = block.StatusBar

	block.MedalIcon:SetSize(32, 32)
	block.MedalIcon:ClearAllPoints()
	block.MedalIcon:SetPoint('TOPLEFT', block, -6, -2)

	block.WaveLabel:ClearAllPoints()
	block.WaveLabel:SetPoint('LEFT', block.MedalIcon, 'RIGHT', 14, 2)

	block.BG:SetSize(width + 21, 75)

	anim:SetWidth(width + 21)

	for _, v in pairs({block.BG, block.GoldCurlies, anim.BGAnim, anim.BorderAnim}) do
		v:Hide()
	end

	sb:StripTextures()
	sb:CreateBackdrop('Transparent')
	sb.backdrop:Point('TOPLEFT', sb, -1, 1)
	sb.backdrop:Point('BOTTOMRIGHT', sb, 1, -1)
	sb:SetStatusBarTexture(E["media"].MuiFlat)
	sb:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
	sb:ClearAllPoints()
	sb:SetPoint('TOP', block, 8, -33)
	sb:SetSize(200, 15)
	sb:SetHeight(9)
	sb:SetFrameLevel(0)

	local tex = {sb:GetRegions()}
	for _, v in pairs(tex) do
		if v:GetObjectType() ~= 'FontString' then
			v:Hide()
		else
			v:ClearAllPoints()
			v:SetPoint('CENTER', sb, 'BOTTOM')
		end
	end
end

local function AddDash(block)
	for i = 1, GetNumQuestWatches() do
		local questIndex = GetQuestIndexForWatch(i)
		if questIndex then
			local id = GetQuestWatchInfo(i)
			local block = QUEST_TRACKER_MODULE:GetBlock(id)
			local title, level, _, _, _, _, frequency = GetQuestLogTitle(questIndex)
			if block.lines then
				for key, line in pairs(block.lines) do
					if frequency == LE_QUEST_FREQUENCY_DAILY then
						local red, green, blue = 1/4, 6/9, 1
						line.Dash:SetVertexColor(red, green, blue)
					elseif frequency == LE_QUEST_FREQUENCY_WEEKLY then
						local red, green, blue = 0, 252/255, 177/255
						line.Dash:SetVertexColor(red, green, blue)
					else
						local col = GetQuestDifficultyColor(level)
						line.Dash:SetVertexColor(col.r, col.g, col.b)
					end
				end
			end
		end
	end
end

local function AddCriteria(self, num, block)
	for i = 1, num do
		local line = block.lines[i]
		block:SetWidth(width + 18)
		if line then
			line.Text:SetWordWrap(true)
			line.Text:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 11, nil)
			line.Text:SetWidth(width + 18)

			line.Icon:Hide()

			if not line.dash then
				line.dash = block:CreateFontString(nil, 'OVERLAY', 'ObjectiveFont')
				line.dash:SetTextColor(.8, .8, .8)
				line.dash:SetPoint('TOPLEFT', line, 20, 1)
				line.dash:SetText('•')
			end

			hooksecurefunc('ScenarioBlocksFrame_SlideOut', function()
				line.dash:Hide()
			end)
			hooksecurefunc('ScenarioBlocksFrame_SlideIn', function()
				line.dash:Show()
			end)

			if line.Text:GetNumLines() > 1 then
				line:SetHeight(14)
			else
				line:SetHeight(4)
			end
		end
	end
end

local function AnimateReward(reward)
	for i = 1, #reward do
		local bu = reward[i]
		MERS:BU(bu)
	end
end

local function AddDefaults()
	if not otf.initialized then ObjectiveTracker_Initialize(otf) end
	ObjectiveTracker_Update()
	QuestSuperTracking_ChooseClosestQuest()
end

local function AddModules()
	for i = 1, #otf.MODULES do
		local module = otf.MODULES[i]
		hooksecurefunc(module, 'OnBlockHeaderEnter', AddDash)
		hooksecurefunc(module, 'OnBlockHeaderLeave', AddDash)
		hooksecurefunc(module, 'AddObjective', AddObjective)
		hooksecurefunc(module, 'AddProgressBar', AddProgressBar)
		hooksecurefunc(module, 'AddTimerBar', AddTimerBar)
		if module == AUTO_QUEST_POPUP_TRACKER_MODULE then
			hooksecurefunc(module, 'Update', AddPopUp)
		end
		if module == SCENARIO_CONTENT_TRACKER_MODULE then
			hooksecurefunc(module, 'Update', AddScenarioButton)
		end
	end
end

local function AddHooks()
	hooksecurefunc('ObjectiveTracker_Update', AddHeader)
	hooksecurefunc('ScenarioBlocksFrame_OnLoad', AddScenarioButton)
	hooksecurefunc('Scenario_ProvingGrounds_ShowBlock', AddProvingGroundButton)
	hooksecurefunc(QUEST_TRACKER_MODULE, 'Update', AddDash)
	hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, 'UpdateCriteria', AddCriteria)

	hooksecurefunc('BonusObjectiveTracker_AnimateReward', function()
		AnimateReward(ObjectiveTrackerBonusRewardsFrame)
	end)

	hooksecurefunc('ScenarioObjectiveTracker_AnimateReward', function()
		AnimateReward(ObjectiveTrackerScenarioRewardsFrame)
	end)

	local qitime  = 0
	local throttle = 1
	hooksecurefunc('QuestObjectiveItem_OnUpdate', function(bu, elapsed)
		qitime = qitime + elapsed
		if qitime > throttle then
			SkinObjectiveItem(bu)
			MoveObjectiveItem(bu)
			qitime = 0
		end
	end)
end

local function InitializeObjectiveTracker(self, event, addon)
	if addon == 'Blizzard_ObjectiveTracker' then
		AddMinimizeButton()
		AddHeaderTitle()
		AddDefaults()
		AddModules()
		AddScenarioButton()
		AddHooks()
	end
end

function MER:LoadObjectiveTracker()
	if E.private.muiSkins.blizzard.objectivetracker.enable == true then
		-- Scenario LevelUp Display
		LevelUpDisplayScenarioFrame.level:SetVertexColor(classColor.r, classColor.g, classColor.b)
		ObjectiveTrackerBonusBannerFrame.Title:SetVertexColor(classColor.r, classColor.g, classColor.b)

		local f = CreateFrame("Frame")
		f:RegisterEvent('ADDON_LOADED', InitializeObjectiveTracker)
		f:RegisterEvent('PLAYER_ENTERING_WORLD', CollapseExpandOTF)
		f:RegisterEvent('INSTANCE_ENCOUNTER_ENGAGE_UNIT', CollapseExpandOTF)
		f:RegisterEvent('PLAYER_REGEN_ENABLED', CollapseExpandOTF)
		f:RegisterEvent('UPDATE_WORLD_STATES', CollapseExpandOTF)
		if IsAddOnLoaded('Blizzard_ObjectiveTracker') then
			InitializeObjectiveTracker(_, _, 'Blizzard_ObjectiveTracker')
		end
	end
end
