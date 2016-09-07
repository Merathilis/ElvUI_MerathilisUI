local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local LSM = LibStub('LibSharedMedia-3.0');
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
local _G = _G
local pairs = pairs
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local ObjectiveTrackerFrame = _G["ObjectiveTrackerFrame"]
local ScenarioStageBlock = _G["ScenarioStageBlock"]
local GetNumQuestWatches = GetNumQuestWatches
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetQuestLogTitle = GetQuestLogTitle
local GetQuestIndexForWatch = GetQuestIndexForWatch
local GetQuestWatchInfo = GetQuestWatchInfo
local GetScreenHeight = GetScreenHeight
local GetScreenWidth = GetScreenWidth
local LE_QUEST_FREQUENCY_DAILY = LE_QUEST_FREQUENCY_DAILY
local LE_QUEST_FREQUENCY_WEEKLY = LE_QUEST_FREQUENCY_WEEKLY
local UIParentLoadAddOn = UIParentLoadAddOn

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, QUEST_TRACKER_MODULE, ScenarioTrackerProgressBar_PlayFlareAnim, C_Scenario, Bar
-- GLOBALS: BonusObjectiveTrackerProgressBar_PlayFlareAnim, ObjectiveTracker_Initialize, ScenarioProvingGroundsBlock
-- GLOBALS: ScenarioProvingGroundsBlockAnim, GameTooltip, UIParent

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local otf = _G["ObjectiveTrackerFrame"]
local height = 450 -- overall height
local width = 188 -- overall width

local function ObjectiveTrackerReskin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectivetracker ~= true then return end

	if not otf then
		UIParentLoadAddOn('Blizzard_ObjectiveTracker')
	end

	if not otf.initialized then
		ObjectiveTracker_Initialize(ObjectiveTrackerFrame)
	end

	-- Underlines and header text
	if otf and otf:IsShown() then
		if otf.MODULES then
			for i = 1, #otf.MODULES do
				local module = otf.MODULES[i]
				module.Header.Underline = MER:Underline(otf.MODULES[i].Header, true, 1)
				module.Header.Text:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 12, "OUTLINE")
				module.Header.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
			end
		end
	end

	-- Scenario LevelUp Display
	_G["LevelUpDisplayScenarioFrame"].level:SetVertexColor(classColor.r, classColor.g, classColor.b)

	-- Bonus Objectives Banner Frame
	_G["ObjectiveTrackerBonusBannerFrame"].Title:SetVertexColor(classColor.r, classColor.g, classColor.b)
	_G["ObjectiveTrackerBonusBannerFrame"].BonusLabel:SetVertexColor(1, 1, 1)

	local AddObjective = function(self, block, key)
		local header = block.HeaderText
		local line = block.lines[key]

		if header then
			local wrap = header:GetNumLines()
			header:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 11, nil)
			header:SetShadowOffset(.7, -.7)
			header:SetShadowColor(0, 0, 0, 1)
			header:SetWidth(width)
			header:SetWordWrap(true)
			if wrap > 1 then
				local height = block:GetHeight()
				block:SetHeight(height*2)
			end
		end

		line.Text:SetWidth(width)

		if line.Dash and line.Dash:IsShown() then
			line.Dash:SetText('• ')
		end
	end

	-- General ProgressBars
	local AddProgressBar = function(self, block, line)
		local progressBar = line.ProgressBar
		local bar = progressBar.Bar
		local flare = progressBar.FullBarFlare1

		if not progressBar.styled then
			bar:StripTextures()
			bar:SetStatusBarTexture(E["media"].MuiFlat)
			bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
			bar:CreateBackdrop("Transparent")
			bar.backdrop:Point("TOPLEFT", Bar, -1, 1)
			bar.backdrop:Point("BOTTOMRIGHT", Bar, 1, -1)
			progressBar.styled = true

			flare:Hide()
		end
	end

	-- Scenario ProgressBars
	local AddProgressBar1 = function(self, block, line, criteriaIndex)
		local progressBar = self.usedProgressBars[block] and self.usedProgressBars[block][line];

		progressBar.Bar:StripTextures()
		progressBar.Bar:SetStatusBarTexture(E["media"].MuiFlat)
		progressBar.Bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
		progressBar.Bar:CreateBackdrop("Transparent")
		progressBar.Bar.backdrop:Point("TOPLEFT", Bar, -1, 1)
		progressBar.Bar.backdrop:Point("BOTTOMRIGHT", Bar, 1, -1)
		progressBar.Bar.skinned = true

		progressBar.Bar.Icon:Kill()
		progressBar.Bar.IconBG:Kill()
		progressBar.Bar.BarGlow:Kill()

	end

	local AddTimerBar = function(self, block, line, duration, startTime)
		local bar = self.usedTimerBars[block] and self.usedTimerBars[block][line]

		bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)

		if not bar.styled then
			local bg = CreateFrame('Frame', nil, bar)
			bg:SetPoint('TOPLEFT', bar)
			bg:SetPoint('BOTTOMRIGHT', bar)
			bg:SetFrameLevel(0)
			-- bar.styled = true
		end

		bar.Label:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 11, 'THINOUTLINE')
		bar.Label:SetShadowOffset(0, -0)
		bar.Label:ClearAllPoints()
		bar.Label:SetPoint('CENTER', bar, 'BOTTOM', 1, -2)
		bar.Label:SetDrawLayer('OVERLAY', 7)
	end

	--Set tooltip depending on position
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

	-- Scenario buttons
	local function SkinScenarioButtons()
		local block = ScenarioStageBlock
		local _, currentStage, numStages, flags = C_Scenario.GetInfo()

		-- pop-up artwork
		block.NormalBG:Hide()

		-- pop-up final artwork
		block.FinalBG:Hide()

		-- pop-up glow
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
		sb.backdrop:Point('TOPLEFT', sb, -1, 1)
		sb.backdrop:Point('BOTTOMRIGHT', sb, 1, -1)
		sb:SetStatusBarTexture(E["media"].MuiFlat)
		sb:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
		sb:ClearAllPoints()
		sb:SetPoint('TOPLEFT', block.MedalIcon, 'BOTTOMLEFT', -4, -5)
		sb:SetSize(200, 15)
	end

	local minimize = otf.HeaderMenu.MinimizeButton
	minimize:SetSize(15, 15)
	minimize:SetNormalTexture('')
	minimize:SetPushedTexture('')

	minimize.minus = minimize:CreateFontString(nil, 'OVERLAY')
	minimize.minus:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 14, nil)
	minimize.minus:SetText('>')
	minimize.minus:SetPoint('CENTER')
	minimize.minus:SetTextColor(1, 1, 1)
	minimize.minus:SetShadowOffset(1, -1)
	minimize.minus:SetShadowColor(0, 0, 0)

	minimize.plus = minimize:CreateFontString(nil, 'OVERLAY')
	minimize.plus:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 14, 'THINOUTLINE')
	minimize.plus:SetText('<')
	minimize.plus:SetPoint('CENTER')
	minimize.plus:SetTextColor(1, 1, 1)
	minimize.plus:SetShadowOffset(1, -1)
	minimize.plus:SetShadowColor(0, 0, 0)
	minimize.plus:Hide()

	local title = otf.HeaderMenu.Title
	title:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 13, nil)
	title:ClearAllPoints()
	title:SetPoint('RIGHT', minimize, 'LEFT', -8, 0)

	minimize:HookScript('OnEnter', function() minimize.minus:SetTextColor(classColor.r, classColor.g, classColor.b) minimize.plus:SetTextColor(classColor.r, classColor.g, classColor.b) end)
	minimize:HookScript('OnLeave', function() minimize.minus:SetTextColor(1, 1, 1) minimize.plus:SetTextColor(1, 1, 1) end)

	hooksecurefunc('ObjectiveTracker_Collapse', function() minimize.plus:Show() minimize.minus:Hide() end)
	hooksecurefunc('ObjectiveTracker_Expand', function() minimize.plus:Hide() minimize.minus:Show() end)

	-- Hooks
	for i = 1, #otf.MODULES do
		local module = otf.MODULES[i]
		-- hooksecurefunc(module, "AddObjective", AddObjective)
		hooksecurefunc(module, "AddProgressBar", AddProgressBar)
		-- hooksecurefunc(module, "AddTimerBar", AddTimerBar)
		-- hooksecurefunc(_G["SCENARIO_TRACKER_MODULE"], "AddProgressBar", AddProgressBar1)
	end

	if IsAddOnLoaded('Blizzard_ObjectiveTracker') then
		-- hooksecurefunc(_G["SCENARIO_CONTENT_TRACKER_MODULE"], "Update", SkinScenarioButtons)
		-- hooksecurefunc("ScenarioBlocksFrame_OnLoad", SkinScenarioButtons)
		-- hooksecurefunc("Scenario_ProvingGrounds_ShowBlock", SkinProvingGroundButtons)
	end
end
S:RegisterSkin('ElvUI', ObjectiveTrackerReskin)
