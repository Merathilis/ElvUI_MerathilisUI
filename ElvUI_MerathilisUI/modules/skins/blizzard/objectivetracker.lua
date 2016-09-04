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
local ObjectiveTrackerFrame = _G["ObjectiveTrackerFrame"]
local ScenarioStageBlock = _G["ScenarioStageBlock"]
local GetNumQuestWatches = GetNumQuestWatches
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetQuestLogTitle = GetQuestLogTitle
local GetQuestIndexForWatch = GetQuestIndexForWatch
local GetQuestWatchInfo = GetQuestWatchInfo
local LE_QUEST_FREQUENCY_DAILY = LE_QUEST_FREQUENCY_DAILY
local LE_QUEST_FREQUENCY_WEEKLY = LE_QUEST_FREQUENCY_WEEKLY
local UIParentLoadAddOn = UIParentLoadAddOn

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, QUEST_TRACKER_MODULE, ScenarioTrackerProgressBar_PlayFlareAnim, C_Scenario, Bar
-- GLOBALS: BonusObjectiveTrackerProgressBar_PlayFlareAnim, ObjectiveTracker_Initialize, ScenarioProvingGroundsBlock
-- GLOBALS: ScenarioProvingGroundsBlockAnim

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local dummy = function() return end

local otf = ObjectiveTrackerFrame
local height = 450 -- overall height
local width = 188 -- overall width

local function ObjectiveTrackerReskin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectivetracker ~= true then return end

	if not ObjectiveTrackerFrame then
		UIParentLoadAddOn('Blizzard_ObjectiveTracker')
	end

	if not ObjectiveTrackerFrame.initialized then
		ObjectiveTracker_Initialize(ObjectiveTrackerFrame)
	end

	-- Underlines and header text
	hooksecurefunc("ObjectiveTracker_Update", function(reason, id)
		if otf.MODULES then
			for i = 1, #otf.MODULES do
				local module = otf.MODULES[i]
				module.Header.Underline = MER:Underline(otf.MODULES[i].Header, true, 1)
				module.Header.Text:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 12, "OUTLINE")
				module.Header.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
			end
		end
	end)

	-- Quest Header Font
	local AddObjective = function(self, block, objectiveKey)
		local header = block.HeaderText
		local line = self:GetLine(block, objectiveKey)

		if header then
			local wrap = header:GetNumLines()
			header:SetFont(LSM:Fetch('font', 'Merathilis Roboto-Black'), 11, 'THINOUTLINE')
			header:SetShadowOffset(1, -1)
			header:SetShadowColor(0, 0, 0)
			header:SetWidth(width)
			header:SetWordWrap(true)
			if wrap > 1 then
				local height = block:GetHeight()
				block:SetHeight(height*2)
			end
			header.styled = true
		end

		line.Text:SetWidth(width)

		if line.Dash and line.Dash:IsShown() then
			line.Dash:SetText'• '
		end
	end

	-- ProgressBars
	local AddProgressBar = function(self, block, line)
		local frame = line.ProgressBar
		local bar = frame.Bar

		bar:StripTextures()
		bar:SetStatusBarTexture(E["media"].MuiFlat)
		bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
		bar:CreateBackdrop("Transparent")
		bar.backdrop:Point("TOPLEFT", Bar, -1, 1)
		bar.backdrop:Point("BOTTOMRIGHT", Bar, 1, -1)
		bar.skinned = true

		ScenarioTrackerProgressBar_PlayFlareAnim = dummy
		BonusObjectiveTrackerProgressBar_PlayFlareAnim = dummy

		if self == QUEST_TRACKER_MODULE then
			local x = {frame:GetPoint()}
			frame:ClearAllPoints()
			frame:SetPoint(x[1], x[2], x[3], x[4] - 30, x[5])
		end

		if not bar.styled then
			local bg = CreateFrame("Frame", nil, bar)
			bg:SetPoint("TOPLEFT", bar)
			bg:SetPoint("BOTTOMRIGHT", bar)
			bg:SetFrameLevel(0)
			bar.styled = true
		end

		for _, v in pairs({bar.BarFrame, bar.Icon, bar.IconBG, bar.BorderLeft, bar.BorderRight, bar.BorderMid}) do
			if v then v:Hide() end -- causes a taint
		end
	end

	local AddTimerBar = function(self, block, line, duration, startTime)
		local bar = self.usedTimerBars[block] and self.usedTimerBars[block][line]

		bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)

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

	-- Acts as quest difficulty/daily indicator
	local Dash = function(block)
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
							line.dash:SetVertexColor(red, green, blue)
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
		block.GlowTexture.AlphaAnim.Play = dummy
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

	local function MinOnClick(self)
		local textObject = self.text
		textObject:SetText("")
	end
	_G["ObjectiveTrackerFrame"].HeaderMenu.MinimizeButton:SetSize(14,14)
	_G["ObjectiveTrackerFrame"].HeaderMenu.MinimizeButton:SetNormalTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\NewQuestMinimize]])
	_G["ObjectiveTrackerFrame"].HeaderMenu.MinimizeButton:SetPushedTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\NewQuestMinimize]])
	_G["ObjectiveTrackerFrame"].HeaderMenu.MinimizeButton:HookScript('OnClick', MinOnClick)

	-- Hooks
	for i = 1, #otf.MODULES do
		local module = otf.MODULES[i]
		hooksecurefunc(module, "AddObjective", AddObjective)
		hooksecurefunc(module, "AddProgressBar", AddProgressBar)
		hooksecurefunc(module, 'AddTimerBar', AddTimerBar)
	end

	hooksecurefunc(QUEST_TRACKER_MODULE, 'Update', Dash)
	hooksecurefunc(_G["SCENARIO_CONTENT_TRACKER_MODULE"], "Update", SkinScenarioButtons)
	hooksecurefunc("ScenarioBlocksFrame_OnLoad", SkinScenarioButtons)
	hooksecurefunc("Scenario_ProvingGrounds_ShowBlock", SkinProvingGroundButtons)
end
hooksecurefunc(S, "Initialize", ObjectiveTrackerReskin)
