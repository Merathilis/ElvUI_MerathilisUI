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

	local function AutoQuestPopUpBlockTemplate()
		for i = 1, GetNumAutoQuestPopUps() do
			local ID, type = GetAutoQuestPopUp(i)
			local Title = GetQuestLogTitle(GetQuestLogIndexByID(ID))

			if Title and Title ~= "" then
				local Block = AUTO_QUEST_POPUP_TRACKER_MODULE:GetBlock(ID)

				if Block then
					local Frame = Block.ScrollChild

					if not Frame.Backdrop then
						Frame:CreateBackdrop("Transparent")

						Frame.backdrop:SetPoint("TOPLEFT", Frame, 40, -4)
						Frame.backdrop:SetPoint("BOTTOMRIGHT", Frame, 0, 4)
						Frame.backdrop:SetFrameLevel(0)
						Frame.backdrop:Styling()

						Frame.FlashFrame.IconFlash:Hide()
					end

					if type == "COMPLETE" then
						Frame.QuestIconBg:SetAlpha(0)
						Frame.QuestIconBadgeBorder:SetAlpha(0)
						Frame.QuestionMark:ClearAllPoints()
						Frame.QuestionMark:SetPoint("CENTER", Frame.backdrop, "LEFT", 10, 0)
						Frame.QuestionMark:SetParent(Frame.backdrop)
						Frame.QuestionMark:SetDrawLayer("OVERLAY", 7)
						Frame.IconShine:Hide()
					elseif type == "OFFER" then
						Frame.QuestIconBg:SetAlpha(0)
						Frame.QuestIconBadgeBorder:SetAlpha(0)
						Frame.Exclamation:ClearAllPoints()
						Frame.Exclamation:SetPoint("CENTER", Frame.backdrop, "LEFT", 10, 0)
						Frame.Exclamation:SetParent(Frame.backdrop)
						Frame.Exclamation:SetDrawLayer("OVERLAY", 7)
					end

					Frame.FlashFrame:Hide()
					Frame.Bg:Hide()

					for _, v in pairs({Frame.BorderTopLeft, Frame.BorderTopRight, Frame.BorderBotLeft, Frame.BorderBotRight, Frame.BorderLeft, Frame.BorderRight, Frame.BorderTop, Frame.BorderBottom}) do
						v:Hide()
					end
				end
			end
		end
	end

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


	S:HandleButton(_G["ObjectiveTrackerFrame"].HeaderMenu.MinimizeButton)

	nQ:RegisterEvent("PLAYER_LOGIN")
	nQ:RegisterEvent("PLAYER_REGEN_DISABLED")
	nQ:RegisterEvent("PLAYER_REGEN_ENABLED")
	nQ:RegisterEvent("QUEST_LOG_UPDATE")
	nQ:SetScript("OnEvent", function(_,event,...)
		f[event](...)
	end)
end

S:AddCallback("mUIObjectiveTracker", styleObjectiveTracker)