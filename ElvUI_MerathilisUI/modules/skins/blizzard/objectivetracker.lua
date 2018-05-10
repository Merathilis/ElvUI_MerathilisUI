local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")
local LSM = LibStub("LibSharedMedia-3.0")

--Cache global variables
--Lua functions
local _G = _G
local pairs, select, tostring = pairs, select, tostring
local tinsert, tgetn = table.insert, table.getn

--WoW API / Variables
local GetGossipActiveQuests = GetGossipActiveQuests
local GetGossipAvailableQuests = GetGossipAvailableQuests
local GetNumQuestLogEntries = GetNumQuestLogEntries
local GetNumQuestWatches = GetNumQuestWatches
local GetQuestLogTitle = GetQuestLogTitle
local GetQuestLink = GetQuestLink
local GetQuestLogSelection = GetQuestLogSelection
local GetQuestWatchInfo = GetQuestWatchInfo
local InCombatLockdown = InCombatLockdown

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, MAX_QUESTS, TRIVIAL_QUEST_DISPLAY, NORMAL_QUEST_DISPLAY, GossipResize
-- GLOBALS: TRACKER_HEADER_QUESTS, OBJECTIVES_TRACKER_LABEL, QUEST_TRACKER_MODULE
-- GLOBALS: OBJECTIVE_TRACKER_COLOR, ENABLE_COLORBLIND_MODE, QuestLogQuests_GetTitleButton

-- Show Quest Count on the ObjectiveTrackerFrame
local InCombat , a, f, _, id, cns, ncns, l, n, q, o, w = false, ...
local nQ = CreateFrame("Frame", a)
function f.PLAYER_LOGIN()
	_G["WorldMapTitleButton"]:HookScript('OnClick', function(_, b, d)
		if b == "LeftButton" and not d then
			local mainlist, tasks, other = {}, {}, {}
			for i = 1, 1000 do
				_, _, _, _, _, _, _, id, _, _, _, _, _, cns, _, ncns = GetQuestLogTitle(i)
				l = GetQuestLink(id)
				if l then
					if ncns then
						tinsert(other,l)
					elseif cns then
						tinsert(tasks,l)
					else
						tinsert(mainlist,l)
					end
				end
			end
		end
	end)
end

function f.PLAYER_REGEN_DISABLED()
	InCombat = true
end
function f.PLAYER_REGEN_ENABLED()
	InCombat = false
end
function f.QUEST_LOG_UPDATE()
	if not InCombat and not InCombatLockdown() then
		n = tostring(select(2, GetNumQuestLogEntries()))
		q = n.."/"..MAX_QUESTS.." "..TRACKER_HEADER_QUESTS
		o = n.."/"..MAX_QUESTS.." "..OBJECTIVES_TRACKER_LABEL
		-- w = MAP_AND_QUEST_LOG.." ("..n.."/"..MAX_QUESTS..")"
		_G["ObjectiveTrackerBlocksFrame"].QuestHeader.Text:SetText(q)
		_G["ObjectiveTrackerFrame"].HeaderMenu.Title:SetText(o)
		_G["WorldMapFrame"].BorderFrame.TitleText:SetText(w)
	end
end

local function styleObjectiveTracker()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectiveTracker ~= true then return end

	local function fixBlockHeight(block)
		if block.shouldFix then
			local height = block:GetHeight()

			if block.lines then
				for _, line in pairs(block.lines) do
					if line:IsShown() then
						height = height + 4
					end
				end
			end

			block.shouldFix = false
			block:SetHeight(height + 5)
			block.shouldFix = true
		end
	end

	hooksecurefunc("ObjectiveTracker_AddBlock", function(block)
		if block.lines then
			for _, line in pairs(block.lines) do
				if not line.styled then
					line:SetHeight(line.Text:GetHeight())
					line.Text:SetSpacing(2)
					line.styled = true
				end
			end
		end

		if not block.styled then
			block.shouldFix = true
			hooksecurefunc(block, "SetHeight", fixBlockHeight)
			block.styled = true
		end
	end)

	-- Quest Level ObjectiveTrackerFrame
	local function ShowObjectiveTrackerLevel()
		if ENABLE_COLORBLIND_MODE == "1" then return end
		for i = 1, GetNumQuestWatches() do
			local questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i)
			if ( not questID ) then
				break
			end
			local block = _G["QUEST_TRACKER_MODULE"]:GetExistingBlock(questID)
			if block then
				local title, level, _, isHeader, _, isComplete, frequency, questID = GetQuestLogTitle(questLogIndex)
				local text = "["..level.."] "..title
				if isComplete then
					text = "|cff22ff00"..text
				elseif frequency == LE_QUEST_FREQUENCY_DAILY then
					text = "|cff3399ff"..text
				end
				block.HeaderText:SetText(text)
			end
		end
	end
	hooksecurefunc(QUEST_TRACKER_MODULE, "Update", ShowObjectiveTrackerLevel)

	-- Quest Level QuestLog
	local function ShowQuestLogLevel()
		if ENABLE_COLORBLIND_MODE == "1" then return end
		local numEntries, numQuests = GetNumQuestLogEntries()
		local titleIndex = 1

		for i = 1, numEntries do
			local title, level, _, isHeader, _, isComplete, frequency, questID = GetQuestLogTitle(i)
			local titleButton = QuestLogQuests_GetTitleButton(titleIndex)
			if title and (not isHeader) and titleButton.questID == questID then
				local height = titleButton.Text:GetHeight()
				local text = "["..level.."] "..title
				if isComplete then
					text = "|cff22ff00"..text
				elseif frequency == LE_QUEST_FREQUENCY_DAILY then
					text = "|cff3399ff"..text
				end
				titleButton.Text:SetText(text)
				titleButton.Text:SetPoint("TOPLEFT", 24, -5)
				titleButton:SetHeight(titleButton:GetHeight() - height + titleButton.Text:GetHeight())
				titleButton.Check:SetPoint("LEFT", titleButton.Text, titleButton.Text:GetWrappedWidth() + 2, 0)

				titleIndex = titleIndex + 1
			end
		end
	end
	--hooksecurefunc("QuestLogQuests_Update", ShowQuestLogLevel)

	local function SetAchievementColor(block)
		if block.module == ACHIEVEMENT_TRACKER_MODULE then
			block.HeaderText:SetTextColor(0.75, 0.61, 0)
			block.HeaderText.col = nil
		end
	end
	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddObjective", SetAchievementColor)

	--Panels
	hooksecurefunc("ObjectiveTracker_Update", function(self)
		local frame = ObjectiveTrackerFrame.MODULES
		if (frame) then
			for i = 1, #frame do
				local Modules = frame[i]
				if (Modules) then
					local Header = Modules.Header
					Header:SetFrameStrata("MEDIUM")
					Header:SetFrameLevel(1)

					if not (Modules.IsSkinned) then
						local HeaderPanel = CreateFrame("Frame", nil, Modules.Header)
						HeaderPanel:SetFrameLevel(Modules.Header:GetFrameLevel() - 1)
						HeaderPanel:SetFrameStrata("HIGH")
						HeaderPanel:SetPoint("BOTTOMLEFT", 0, 3)
						HeaderPanel:SetSize(210, 2)
						MERS:SkinPanel(HeaderPanel)

						Modules.IsSkinned = true
					end
				end
			end
		end
	end)

	local function AutoQuestPopUpBlockTemplate(scrollframe)
		scrollframe:SetSize(232, 68)

		local ScrollChild = scrollframe.ScrollChild
		ScrollChild:SetSize(227, 68)
		ScrollChild.Bg:SetPoint("TOPLEFT", 36, -4)
		ScrollChild.Bg:SetPoint("BOTTOMRIGHT", 0, 4)

		ScrollChild.BorderTopLeft:SetSize(16, 16)
		ScrollChild.BorderTopLeft:SetPoint("TOPLEFT", 32, 0)
		ScrollChild.BorderTopRight:SetSize(16, 16)
		ScrollChild.BorderTopRight:SetPoint("TOPRIGHT", 4, 0)
		ScrollChild.BorderBotLeft:SetSize(16, 16)
		ScrollChild.BorderBotLeft:SetPoint("BOTTOMLEFT", 32, 0)
		ScrollChild.BorderBotRight:SetSize(16, 16)
		ScrollChild.BorderBotRight:SetPoint("BOTTOMRIGHT", 4, 0)

		ScrollChild.BorderLeft:SetWidth(8)
		ScrollChild.BorderRight:SetWidth(8)
		ScrollChild.BorderTop:SetHeight(8)
		ScrollChild.BorderBottom:SetHeight(8)

		ScrollChild.QuestIconBg:SetSize(60, 60)
		ScrollChild.QuestIconBg:SetPoint("CENTER", ScrollChild, "LEFT", 36, 0)
		ScrollChild.QuestIconBadgeBorder:SetSize(44, 45)
		ScrollChild.QuestIconBadgeBorder:SetPoint("TOPLEFT", ScrollChild.QuestIconBg, 8, -8)

		ScrollChild.QuestName:SetPoint("LEFT", ScrollChild.QuestIconBg, "RIGHT", -6, 0)
		ScrollChild.QuestName:SetPoint("RIGHT", -8, 0)
		ScrollChild.TopText:SetPoint("LEFT", ScrollChild.QuestIconBg, "RIGHT", -6, 0)
		ScrollChild.TopText:SetPoint("RIGHT", -8, 0)
		ScrollChild.BottomText:SetPoint("BOTTOM", 0, 8)
		ScrollChild.BottomText:SetPoint("LEFT", ScrollChild.QuestIconBg, "RIGHT", -6, 0)
		ScrollChild.BottomText:SetPoint("RIGHT", -8, 0)

		ScrollChild.Shine:SetPoint("TOPLEFT", 35, -3)
		ScrollChild.Shine:SetPoint("BOTTOMRIGHT", 1, 3)
		ScrollChild.IconShine:SetSize(42, 42)
	end

	S:HandleButton(_G["ObjectiveTrackerFrame"].HeaderMenu.MinimizeButton)

	-- AutoQuestPopUpTracker
	local function AUTO_QUEST_POPUP_TRACKER_MODULE_Update(self)
		for _, block in next, self.usedBlocks do
			if not block.IsSkinned then
				AutoQuestPopUpBlockTemplate(block)
				block.IsSkinned = true
			end
		end
	end
	hooksecurefunc(AUTO_QUEST_POPUP_TRACKER_MODULE, "Update", AUTO_QUEST_POPUP_TRACKER_MODULE_Update)

	nQ:RegisterEvent("PLAYER_LOGIN")
	nQ:RegisterEvent("PLAYER_REGEN_DISABLED")
	nQ:RegisterEvent("PLAYER_REGEN_ENABLED")
	nQ:RegisterEvent("QUEST_LOG_UPDATE")
	nQ:SetScript("OnEvent", function(_,event,...)
		f[event](...)
	end)
end

S:AddCallback("mUIObjectiveTracker", styleObjectiveTracker)