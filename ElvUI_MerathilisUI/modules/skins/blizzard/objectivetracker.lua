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
-- GLOBALS: OBJECTIVE_TRACKER_COLOR, OBJECTIVE_TRACKER_COLOR, OBJECTIVE_TRACKER_HEADER_HEIGHT
-- GLOBALS: BonusObjectiveTrackerProgressBar_PlayFlareAnim, AUTO_QUEST_POPUP_TRACKER_MODULE, ScenarioProvingGroundsBlock
-- GLOBALS: ScenarioProvingGroundsBlockAnim, OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT, OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT
-- GLOBALS: QUEST_TRACKER_MODULE, ObjectiveTracker_Initialize, ObjectiveTracker_Initialize, QuestSuperTracking_ChooseClosestQuest
-- GLOBALS: ObjectiveTracker_Update, SCENARIO_CONTENT_TRACKER_MODULE, ObjectiveTrackerBonusRewardsFrame
-- GLOBALS: ObjectiveTrackerScenarioRewardsFrame, SkinObjectiveItem, _, bossexists, DEFAULT_OBJECTIVE_TRACKER_MODULE
-- GLOBALS: STANDARD_TEXT_FONT, LevelUpDisplayScenarioFrame, ObjectiveTrackerBonusBannerFrame

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local height = 500 -- overall height
local width = 180 -- overall width

-- Blizzard Frames
local otf = _G["ObjectiveTrackerFrame"]
local ScenarioStageBlock = _G["ScenarioStageBlock"]

DEFAULT_OBJECTIVE_TRACKER_MODULE['blockOffsetY'] = -4

local dungeons  = {
	L['Assault on Violet Hold'],
	L['Black Rook Hold'],
	L['Court of Stars'],
	L['Darkheart Thicket'],
	L['Eye of Azshara'],
	L['Halls of Valor'],
	L['Maw of Souls'],
	L['Neltharion\'s Lair'],
	L['The Arcway'], 
	L['Vault of the Wardens'],
}

-- Minimize button
local function AddMinimizeButton()
	local min = otf.HeaderMenu.MinimizeButton
	min:SetSize(15, 15)
	min:ClearAllPoints()
	min:SetPoint('TOPRIGHT', otf, 25, -4)
	min:SetNormalTexture('')
	min:SetPushedTexture('')

	min.minus = min:CreateFontString(nil, 'OVERLAY')
	min.minus:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 14, nil)
	min.minus:SetText('>')
	min.minus:SetPoint('CENTER')
	min.minus:SetTextColor(1, 1, 1)
	min.minus:SetShadowOffset(1, -1)
	min.minus:SetShadowColor(0, 0, 0, 1)

	min.plus = min:CreateFontString(nil, 'OVERLAY')
	min.plus:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 14, nil)
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

local function AddTitleSubs(line)
	local t = line.Text:GetText()
	t = gsub(t, L['WANTED:'], L['|cffff0000W:|r'])
	t = gsub(t, L['DANGER:'], L['|cffff0000D:|r'])
	t = gsub(t, L['Warden Tower Assault:'], L['|cffff0000PvP:|r'])
	t = gsub(t, L['Black Rook Rumble'], L['|cffff0000PvP:|r Black Rook Rumble']) 

	for _, v in pairs(dungeons) do 
		t = gsub(t, v..':', '|cff9063ed'..v..':|r')
	end

	line.Text:SetText(t)
end

local function AddHeaderTitle()
	local title = otf.HeaderMenu.Title
	title:FontTemplate()
	title:SetVertexColor(classColor.r, classColor.g, classColor.b)
	title:ClearAllPoints()
	title:SetPoint('RIGHT', otf.HeaderMenu.MinimizeButton, 'LEFT', -8, 0)
end

-- Overhall Header
local function AddHeader()
	for i = 1, #otf.MODULES do
		local module = otf.MODULES[i]

		-- Header font
		module.Header.Text:FontTemplate()
		module.Header.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
		module.Header.Text:ClearAllPoints()
		module.Header.Text:SetPoint('RIGHT', otf.MODULES[i].Header, -10, -2)
		module.Header.Text:SetJustifyH('RIGHT')

		if E.private.muiSkins.blizzard.objectivetracker.backdrop then
			-- Backdrop
			module.Header:CreateBackdrop("Transparent")
			module.Header.backdrop:Point("TOPLEFT", -3, 0)
			MER:StyleInside(module.Header.backdrop)

			-- Texture
			module.Header.Icon = module.Header.backdrop:CreateTexture(nil, 'ARTWORK')
			module.Header.Icon:SetPoint('LEFT', module.Header, 'LEFT', 0, -2)
			module.Header.Icon:SetSize(16, 16)
			module.Header.Icon:SetTexture("Interface\\GossipFrame\\AvailableLegendaryQuestIcon")
		end
	end
end

-- World Quest Tracker
local function AddLines(line, key)
	local r, g, b = line.Text:GetTextColor()
	AddTitleSubs(line)

	line.Text:FontTemplate()
	line.Text:SetWidth(key == 0 and width + 21 or width)

	line:SetHeight(line.Text:GetNumLines()*11)
	line:SetWidth(width + 21)
	line.width = width

	if line.Dash and line.Dash:IsShown() then
		line.Text:SetJustifyH('LEFT')
		line.Dash:SetText('• ')
	end
end

local function AddBlock(line, key, block)
	if key == 0 or key == 1 then block.x = 0 end
	local height = line.Text:GetNumLines()*13
	if block.x then
		block.x = block.x + height
		block.height = block.x + height
	end
end

local function AddObjective(self, block, key)
	local header = block.HeaderText
	local line = block.lines[key]

	AddLines(line, key)
	AddBlock(line, key, block)

	if header then
		local r, g, b = header:GetTextColor()
		header:FontTemplate()
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

	OBJECTIVE_TRACKER_COLOR['Header'] = {r = classColor.r, g = classColor.g, b = classColor.b}
	OBJECTIVE_TRACKER_COLOR['HeaderHighlight'] = {r = classColor.r*1.2, g = classColor.g*1.2, b = classColor.b*1.2}
end

local function AddProgressBar(self, block, line)
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar

	bar:StripTextures()
	bar:SetHeight(9)

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

	bar.Label:FontTemplate()
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

	bar.Label:FontTemplate()
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

	ScenarioStageBlock.Stage:FontTemplate()
	ObjectiveTrackerBonusBannerFrame.Title:SetVertexColor(classColor.r, classColor.g, classColor.b)
end

local function AddScenarioBar()
	local bar = ScenarioObjectiveBlock.currentLine.Bar

	bar:StripTextures()
	bar:SetHeight(9)

	bar:SetStatusBarTexture(E["media"].MuiFlat)
	bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
	bar:CreateBackdrop("Transparent")
	bar.backdrop:Point("TOPLEFT", bar, -1, 1)
	bar.backdrop:Point("BOTTOMRIGHT", bar, 1, -1)

	bar.Label:FontTemplate()
	bar.Label:SetShadowOffset(0, -0)
	bar.Label:SetJustifyH('CENTER')
	bar.Label:ClearAllPoints()
	bar.Label:SetPoint('CENTER', bar, 'BOTTOM', 0, -1)
	bar.Label:SetDrawLayer('OVERLAY', 7)
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
		block:SetWidth(width + 50)
		if line then
			line.Text:SetWordWrap(true)
			line.Text:FontTemplate()
			line.Text:SetWidth(width+50)
			line.Text:SetJustifyH('RIGHT')

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

		LevelUpDisplayScenarioFrame:StripTextures()
		LevelUpDisplayScenarioFrame.level:SetVertexColor(classColor.r, classColor.g, classColor.b)

		ScenarioStageBlock.Stage:SetVertexColor(classColor.r, classColor.g, classColor.b)
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

local function InitializeObjectiveTracker(self, event, addon)
	if addon == 'Blizzard_ObjectiveTracker' then
		hooksecurefunc('ScenarioBlocksFrame_OnLoad', AddScenarioButton)
		hooksecurefunc(SCENARIO_TRACKER_MODULE, 'AddProgressBar', AddScenarioBar)
		hooksecurefunc('Scenario_ProvingGrounds_ShowBlock', AddProvingGroundButton)
		hooksecurefunc(QUEST_TRACKER_MODULE, 'Update', AddDash)
		hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, 'UpdateCriteria', AddCriteria)

		hooksecurefunc('BonusObjectiveTracker_AnimateReward', function()
			AnimateReward(ObjectiveTrackerBonusRewardsFrame)
		end)

		hooksecurefunc('ScenarioObjectiveTracker_AnimateReward', function()
			AnimateReward(ObjectiveTrackerScenarioRewardsFrame)
		end)

		AddDefaults()
		AddModules()
		AddHeaderTitle()
		AddHeader()
		AddScenarioButton()
		AddMinimizeButton()
	end
end

function MER:LoadObjectiveTracker()
	if E.private.muiSkins.blizzard.objectivetracker.enable == true then
		if IsAddOnLoaded('Blizzard_ObjectiveTracker') then
			InitializeObjectiveTracker(_, _, 'Blizzard_ObjectiveTracker')
		end
	end
end
