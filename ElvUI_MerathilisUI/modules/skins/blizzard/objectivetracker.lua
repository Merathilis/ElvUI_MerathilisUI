local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local LSM = LibStub('LibSharedMedia-3.0');
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetScreenHeight = GetScreenHeight
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
-- GLOBALS: BonusObjectiveTrackerProgressBar_PlayFlareAnim, GameTooltip, ScenarioStageBlock
-- GLOBALS: ScenarioProvingGroundsBlock, ScenarioProvingGroundsBlockAnim,  DEFAULT_OBJECTIVE_TRACKER_MODULE
-- GLOBALS: SCENARIO_TRACKER_MODULE, ScenarioTrackerProgressBar_PlayFlareAnim, SCENARIO_CONTENT_TRACKER_MODULE

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local dummy = function() return end

local otf = ObjectiveTrackerFrame
local height = 450 -- overall height
local width = 188 -- overall width

local function ObjectiveTrackerReskin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectivetracker ~= true then return end

	if not ObjectiveTrackerFrame then
		UIParentLoadAddOn'Blizzard_ObjectiveTracker'
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

	local QuestOnEnter = function()
		for i = 1, GetNumQuestWatches() do
			local id = GetQuestWatchInfo(i)
			if not id then break end
			local block = QUEST_TRACKER_MODULE:GetBlock(id)
			Dash()
		end
	end

	-- Hooks
	for i = 1, #otf.MODULES do
		local module = otf.MODULES[i]
		hooksecurefunc(module, "AddObjective", AddObjective)
		hooksecurefunc(module, "AddProgressBar", AddProgressBar)
		hooksecurefunc(module, 'AddTimerBar', AddTimerBar)
	end

	hooksecurefunc(QUEST_TRACKER_MODULE, 'Update', Dash)
	hooksecurefunc(QUEST_TRACKER_MODULE, 'OnBlockHeaderLeave', QuestOnEnter)
end
hooksecurefunc(S, "Initialize", ObjectiveTrackerReskin)
