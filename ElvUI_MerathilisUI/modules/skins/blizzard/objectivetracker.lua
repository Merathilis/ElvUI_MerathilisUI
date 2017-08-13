local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

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
-- GLOBALS: TRACKER_HEADER_QUESTS, OBJECTIVES_TRACKER_LABEL

-- Show Quest Count on the ObjectiveTrackerFrame
local InCombat , a, f, _, id, cns, ncns, l, n, q, o, w = false, ...
local nQ = CreateFrame("Frame",a)
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

	local ot = _G["ObjectiveTrackerFrame"]
	local BlocksFrame = ot.BlocksFrame

	-- Fix height
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
		if not block.styled then
			block.shouldFix = true
			hooksecurefunc(block, "SetHeight", fixBlockHeight)
			block.styled = true
		end
	end)

	-- Quest Level GossipFrame
	local function GossipFrameUpdate_hook()
		local buttonIndex = 1
		-- name, level, isTrivial, isDaily, isRepeatable, isLegendary, isIgnored, ... = GetGossipAvailableQuests()
		local availableQuests = {GetGossipAvailableQuests()}
		local numAvailableQuests = tgetn(availableQuests)
		for i = 1, numAvailableQuests, 7 do
			local titleButton = _G["GossipTitleButton" .. buttonIndex]
			local title = "["..availableQuests[i+1].."] "..availableQuests[i]
			local isTrivial = availableQuests[i+2]
			if isTrivial then
				titleButton:SetFormattedText(TRIVIAL_QUEST_DISPLAY, title)
			else
				titleButton:SetFormattedText(NORMAL_QUEST_DISPLAY, title)
			end
			GossipResize(titleButton)
			buttonIndex = buttonIndex + 1
		end
		if numAvailableQuests > 1 then
			buttonIndex = buttonIndex + 1
		end

		-- name, level, isTrivial, isDaily, isLegendary, isIgnored, ... = GetGossipActiveQuests()
		local activeQuests = {GetGossipActiveQuests()}
		local numActiveQuests = tgetn(activeQuests)
		for i = 1, numActiveQuests, 6 do
			local titleButton = _G["GossipTitleButton" .. buttonIndex]
			local title = "["..activeQuests[i+1].."] "..activeQuests[i]
			local isTrivial = activeQuests[i+2]
			if isTrivial then
				titleButton:SetFormattedText(TRIVIAL_QUEST_DISPLAY, title)
			else
				titleButton:SetFormattedText(NORMAL_QUEST_DISPLAY, title)
			end
			GossipResize(titleButton)
			buttonIndex = buttonIndex + 1
		end
	end
	hooksecurefunc("GossipFrameUpdate", GossipFrameUpdate_hook)

	-- Quest Level QuestInfoFrame
	local function QuestInfo_hook(template, parentFrame, acceptButton, material, mapView)
		local elementsTable = template.elements
		for i = 1, #elementsTable, 3 do
			if elementsTable[i] == QuestInfo_ShowTitle then
				if _G["QuestInfoFrame"].questLog then
					local questLogIndex = GetQuestLogSelection()
					local level = select(2, GetQuestLogTitle(questLogIndex))
					local newTitle = "["..level.."] ".._G["QuestInfoTitleHeader"]:GetText()
					_G["QuestInfoTitleHeader"]:SetText(newTitle)
				end
			end
		end
	end
	hooksecurefunc("QuestInfo_Display", QuestInfo_hook)

	-- Quest Level ObjectiveTrackerFrame
	local function SetBlockHeader_hook()
		for i = 1, GetNumQuestWatches() do
			local questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i)
			if ( not questID ) then
				break
			end
			local oldBlock = _G["QUEST_TRACKER_MODULE"]:GetExistingBlock(questID)
			if oldBlock then
				local oldBlockHeight = oldBlock.height
				local oldHeight = _G["QUEST_TRACKER_MODULE"]:SetStringText(oldBlock.HeaderText, title, nil, OBJECTIVE_TRACKER_COLOR["Header"])
				local newTitle = "["..select(2, GetQuestLogTitle(questLogIndex)).."] "..title
				local newHeight = _G["QUEST_TRACKER_MODULE"]:SetStringText(oldBlock.HeaderText, newTitle, nil, OBJECTIVE_TRACKER_COLOR["Header"])
				oldBlock:SetHeight(oldBlockHeight + newHeight - oldHeight);
			end
		end
	end
	hooksecurefunc(QUEST_TRACKER_MODULE, "Update", SetBlockHeader_hook)

	-- Quest Level QuestLog
	local function QuestLogQuests_Update()
		if ENABLE_COLORBLIND_MODE == "1" then return end
		local numEntries, numQuests = GetNumQuestLogEntries()
		local titleIndex = 1

		for i = 1, numEntries do
			local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(i)
			local titleButton = QuestLogQuests_GetTitleButton(titleIndex)
			if title and (not isHeader) and titleButton.questID == questID then
				titleButton.Text:SetText("[" .. level .. "] " .. title)
				titleButton.Check:SetPoint("LEFT", titleButton.Text, titleButton.Text:GetWrappedWidth() + 2, 0);
				titleIndex = titleIndex + 1
			end
		end
	end
	hooksecurefunc(QUEST_TRACKER_MODULE, "Update", QuestLogQuests_Update)

	if MER:IsDeveloper() and MER:IsDeveloperRealm() then
		local bg = _G["ObjectiveTrackerBlocksFrame"].QuestHeader:CreateTexture(nil, "ARTWORK")
		bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
		bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
		bg:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		bg:SetPoint("BOTTOMLEFT", -30, -4)
		bg:SetSize(210, 30)

		local bg = _G["ObjectiveTrackerBlocksFrame"].AchievementHeader:CreateTexture(nil, "ARTWORK")
		bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
		bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
		bg:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		bg:SetPoint("BOTTOMLEFT", -30, -4)
		bg:SetSize(210, 30)

		local bg = _G["ObjectiveTrackerBlocksFrame"].ScenarioHeader:CreateTexture(nil, "ARTWORK")
		bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
		bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
		bg:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		bg:SetPoint("BOTTOMLEFT", -30, -4)
		bg:SetSize(210, 30)

		local bg = _G["BONUS_OBJECTIVE_TRACKER_MODULE"].Header:CreateTexture(nil, "ARTWORK")
		bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
		bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
		bg:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		bg:SetPoint("BOTTOMLEFT", -30, -4)
		bg:SetSize(210, 30)

		local bg = _G["WORLD_QUEST_TRACKER_MODULE"].Header:CreateTexture(nil, "ARTWORK")
		bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
		bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
		bg:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		bg:SetPoint("BOTTOMLEFT", -30, -4)
		bg:SetSize(210, 30)
	end

	nQ:RegisterEvent('PLAYER_LOGIN')
	nQ:RegisterEvent('PLAYER_REGEN_DISABLED')
	nQ:RegisterEvent('PLAYER_REGEN_ENABLED')
	nQ:RegisterEvent('QUEST_LOG_UPDATE')
	nQ:SetScript('OnEvent', function(_,event,...)
		f[event](...)
	end)
end

S:AddCallback("mUIObjectiveTracker", styleObjectiveTracker)