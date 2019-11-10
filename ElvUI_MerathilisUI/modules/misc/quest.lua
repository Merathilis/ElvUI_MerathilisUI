local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, tonumber, select = pairs, tonumber, select
local format, find, gsub = string.format, string.find, string.gsub
local floor, mod = math.floor, mod
-- WoW API / Variables
local C_TaskQuest_GetQuestInfoByQuestID = C_TaskQuest.GetQuestInfoByQuestID
local GetItemInfo = GetItemInfo
local GetQuestLink = GetQuestLink
local GetQuestItemLink = GetQuestItemLink
local GetQuestLogTitle = GetQuestLogTitle
local GetQuestTagInfo = GetQuestTagInfo
local GetNumQuestChoices = GetNumQuestChoices
local GetNumQuestLogEntries = GetNumQuestLogEntries
local IsPartyLFG = IsPartyLFG
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local PlaySound = PlaySound
local QuestUtils_IsQuestWorldQuest = QuestUtils_IsQuestWorldQuest
local SendChatMessage = SendChatMessage
-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: QuestInfo_GetRewardButton, QuestInfoItemHighlight

local dbg = 0;
local completedQuest, initComplete = {}

-- [[ AUTO SELECT REWARD]]

local function SelectQuestReward(index)
	local rewardsFrame = _G["QuestInfoFrame"].rewardsFrame

	local btn = QuestInfo_GetRewardButton(rewardsFrame, index)
	if (btn.type == "choice") then
		QuestInfoItemHighlight:ClearAllPoints()
		QuestInfoItemHighlight:SetOutside(btn.Icon)

		if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true then
			QuestInfoItemHighlight:SetPoint("TOPLEFT", btn, "TOPLEFT", -8, 7)
		else
			btn.Name:SetTextColor(1, 1, 0)
		end
		QuestInfoItemHighlight:Show()

		-- set choice
		_G["QuestInfoFrame"].itemChoice = btn:GetID()
	end
end

function MI:QUEST_COMPLETE()
	-- default first button when no item has a sell value.
	local choice, price = 1, 0
	local num = GetNumQuestChoices()

	if num <= 0 then
		return -- no choices, quick exit
	end

	for index = 1, num do
		local link = GetQuestItemLink("choice", index)
		if (link) then
			local vsp = select(11, GetItemInfo(link))
			if vsp and vsp > price then
				price = vsp
				choice = index
			end
		end
	end
	SelectQuestReward(choice)
end

-- [[ QUEST NOTIFIER]]

local function acceptText(link, daily)
	if daily then
		return format("%s [%s]%s", L["Accept Quest"], DAILY, link)
	else
		return format("%s %s", L["Accept Quest"], link)
	end
end

local function completeText(link)
	PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_3, "Master")
	return format("%s %s", link, QUEST_COMPLETE)
end

local function sendQuestMsg(msg)
	if IsPartyLFG() then
		SendChatMessage(msg, "INSTANCE_CHAT")
	elseif IsInRaid() then
		SendChatMessage(msg, "RAID")
	elseif IsInGroup() and not IsInRaid() then
		SendChatMessage(msg, "PARTY")
	end
end

-- Baaaad Tooltip scanning :|
local function getPattern(pattern)
	pattern = gsub(pattern, "%(", "%%%1")
	pattern = gsub(pattern, "%)", "%%%1")
	pattern = gsub(pattern, "%%%d?$?.", "(.+)")

	return format("^%s$", pattern)
end

local questMatches = {
	["Found"] = getPattern(ERR_QUEST_ADD_FOUND_SII),
	["Item"] = getPattern(ERR_QUEST_ADD_ITEM_SII),
	["Kill"] = getPattern(ERR_QUEST_ADD_KILL_SII),
	["PKill"] = getPattern(ERR_QUEST_ADD_PLAYER_KILL_SII),
	["ObjectiveComplete"] = getPattern(ERR_QUEST_OBJECTIVE_COMPLETE_S),
	["QuestComplete"] = getPattern(ERR_QUEST_COMPLETE_S),
	["QuestFailed"] = getPattern(ERR_QUEST_FAILED_S),
}

local function FindQuestProgress(_, _, msg)
	for _, pattern in pairs(questMatches) do
		if msg:match(pattern) then
			local _, _, _, cur, max = find(msg, "(.*)[:：]%s*([-%d]+)%s*/%s*([-%d]+)%s*$")
			cur, max = tonumber(cur), tonumber(max)
			if cur and max and max >= 10 then
				if mod(cur, floor(max/5)) == 0 then
					sendQuestMsg(msg)
				end
			else
				sendQuestMsg(msg)
			end
			break
		end
	end
end

local function FindQuestAccept(_, questLogIndex, questID)
	local title, _, _, _, _, _, frequency = GetQuestLogTitle(questLogIndex)
	local link = GetQuestLink(questID)
	if title then
		local tagID, _, worldQuestType = GetQuestTagInfo(questID)
		if tagID == 109 or worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION then return end
		sendQuestMsg(acceptText(link, frequency == LE_QUEST_FREQUENCY_DAILY))
	end
end

local function FindQuestComplete()
	for i = 1, GetNumQuestLogEntries() do
		local title, _, _, _, _, isComplete, _, questID = GetQuestLogTitle(i)
		local link = GetQuestLink(questID)
		local worldQuest = select(3, GetQuestTagInfo(questID))
		if title and isComplete and not completedQuest[questID] and not worldQuest then
			if initComplete then
				sendQuestMsg(completeText(link))
			end
			completedQuest[questID] = true
		end
	end
end

local function FindWorldQuestComplete(_, questID)
	if QuestUtils_IsQuestWorldQuest(questID) then
		local title = C_TaskQuest_GetQuestInfoByQuestID(questID)
		local link = GetQuestLink(questID)
		if title and not completedQuest[questID] then
			sendQuestMsg(completeText(link))
			completedQuest[questID] = true
		end
	end
end

function MI:LoadQuest()
	if E.db.mui.misc.quest ~= true then return end

	FindQuestComplete()
	initComplete = true

	self:RegisterEvent("QUEST_ACCEPTED", FindQuestAccept)
	self:RegisterEvent("QUEST_LOG_UPDATE", FindQuestComplete)
	self:RegisterEvent("QUEST_TURNED_IN", FindWorldQuestComplete)
	self:RegisterEvent("UI_INFO_MESSAGE", FindQuestProgress)

	self:RegisterEvent("QUEST_COMPLETE")
end
