local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Announcement')

local _G = _G
local format = format
local pairs = pairs
local strfind = strfind

local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestLink = GetQuestLink
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard

local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo

local lastList

local ignoreTagIDs = {
	[128] = true,
	[265] = true
}

local function GetQuests()
	local quests = {}

	for questIndex = 1, C_QuestLog_GetNumQuestLogEntries() do
		local questInfo = C_QuestLog_GetInfo(questIndex)
		if questInfo then
			local skip = questInfo.isHeader or questInfo.isBounty or questInfo.isHidden

			if tagInfo and ignoreTagIDs[tagInfo.tagID] then
				skip = true
			end

			if questInfo.isOnMap and tagInfo and tagInfo.worldQuestType then
				skip = false
			end

			if questInfo.isOnMap and tagInfo and tagInfo.tagID == 128 then
				skip = false
			end

			if not skip then
				quests[questInfo.questID] = {
					title = questInfo.title,
					questID = questInfo.questID,
					level = questInfo.level,
					suggestedGroup = questInfo.suggestedGroup,
					isComplete = questInfo.isComplete,
					frequency = questInfo.frequency,
					tag = tagInfo and tagInfo.tagName,
					worldQuestType = tagInfo and tagInfo.worldQuestType,
					link = GetQuestLink(questInfo.questID)
				}

				for queryIndex = 1, GetNumQuestLeaderBoards(questIndex) do
					local queryText = GetQuestLogLeaderBoard(queryIndex, questIndex)
					local _, _, numItems, numNeeded, itemName = strfind(queryText, "(%d+)/(%d+) ?(.*)")
					quests[questInfo.questID][queryIndex] = {
						item = itemName,
						numItems = numItems,
						numNeeded = numNeeded
					}
				end
			end
		end
	end

	return quests
end

do
	local ERR_QUEST_ADD_ITEM_SII = ERR_QUEST_ADD_ITEM_SII
	local ERR_QUEST_ADD_FOUND_SII = ERR_QUEST_ADD_FOUND_SII
	local ERR_QUEST_ADD_KILL_SII = ERR_QUEST_ADD_KILL_SII
	local ERR_QUEST_UNKNOWN_COMPLETE = ERR_QUEST_UNKNOWN_COMPLETE
	local ERR_QUEST_OBJECTIVE_COMPLETE_S = ERR_QUEST_OBJECTIVE_COMPLETE_S

	function module:UpdateBlizzardQuestAnnouncement()
		local enable = false

		if not (self.db.enable and self.db.quest and self.db.quest.enable and self.db.quest.disableBlizzard) then
			enable = true
		end

		_G.ERR_QUEST_ADD_ITEM_SII = enable and ERR_QUEST_ADD_ITEM_SII or "    "
		_G.ERR_QUEST_ADD_FOUND_SII = enable and ERR_QUEST_ADD_FOUND_SII or "    "
		_G.ERR_QUEST_ADD_KILL_SII = enable and ERR_QUEST_ADD_KILL_SII or "    "
		_G.ERR_QUEST_UNKNOWN_COMPLETE = enable and ERR_QUEST_UNKNOWN_COMPLETE or "    "
		_G.ERR_QUEST_OBJECTIVE_COMPLETE_S = enable and ERR_QUEST_OBJECTIVE_COMPLETE_S or "    "

		hooksecurefunc(_G.UIErrorsFrame, "AddMessage", function(frame, text)
			if text == "   " then
				frame:Clear()
			end
		end)
	end
end

function module:Quest()
	local config = self.db.quest
	if not config or not config.enable then
		return
	end

	local currentList = GetQuests()
	if not lastList then
		lastList = currentList
		return
	end

	for questID, questCache in pairs(currentList) do
		local mainInfo = ""
		local extraInfo = ""
		local mainInfoColored = ""
		local extraInfoColored = ""
		local needAnnounce = false
		local isDetailInfo = false

		if questCache.frequency == 1 and config.daily.enable then
			extraInfo = extraInfo .. "[" .. _G.DAILY .. "]"
			extraInfoColored = extraInfoColored .. F.CreateColorString("[" .. _G.DAILY .. "]", config.daily.color)
		elseif questCache.frequency == 2 and config.weekly.enable then
			extraInfo = extraInfo .. "[" .. _G.WEEKLY .. "]"
			extraInfoColored = extraInfoColored .. F.CreateColorString("[" .. _G.WEEKLY .. "]", config.weekly.color)
		end

		if questCache.suggestedGroup > 1 and config.suggestedGroup.enable then
			extraInfo = extraInfo .. "[" .. questCache.suggestedGroup .. "]"
			extraInfoColored =
			extraInfoColored .. F.CreateColorString("[" .. questCache.suggestedGroup .. "]", config.suggestedGroup.color)
		end

		if questCache.level and config.level.enable then
			if not config.level.hideOnMax or questCache.level ~= GetMaxLevelForPlayerExpansion() then
				extraInfo = extraInfo .. "[" .. questCache.level .. "]"
				extraInfoColored = extraInfoColored .. F.CreateColorString("[" .. questCache.level .. "]", config.level.color)
			end
		end

		if questCache.tag and config.tag then
			extraInfo = extraInfo .. "[" .. questCache.tag .. "]"
			extraInfoColored = extraInfoColored .. F.CreateColorString("[" .. questCache.tag .. "]", config.tag.color)
		end

		local questCacheOld = lastList[questID]

		if questCacheOld then
			if not questCacheOld.isComplete then
				if questCache.isComplete then
					mainInfo = questCache.title .. " " .. F.CreateColorString(L["Completed"], { r = 0.5, g = 1, b = 0.5 })
					mainInfoColored = questCache.link .. " " .. F.CreateColorString(L["Completed"], { r = 0.5, g = 1, b = 0.5 })
					needAnnounce = true
				elseif #questCacheOld > 0 and #questCache > 0 then
					for queryIndex = 1, #questCache do
						if questCache[queryIndex] and questCacheOld[queryIndex] and questCache[queryIndex].numItems and
							questCacheOld[queryIndex].numItems and
							questCache[queryIndex].numItems > questCacheOld[queryIndex].numItems
						then
							local progressColor = F.GetProgressColor(questCache[queryIndex].numItems / questCache[queryIndex].numNeeded)

							local subGoalIsCompleted = questCache[queryIndex].numItems == questCache[queryIndex].numNeeded

							if config.includeDetails or subGoalIsCompleted then
								local progressInfo = questCache[queryIndex].numItems .. "/" .. questCache[queryIndex].numNeeded
								local progressInfoColored = progressInfo
								if subGoalIsCompleted then
									progressInfoColored = progressInfoColored .. format(" |T%s:0|t", MER.Media.Icons.complete)
								else
									isDetailInfo = true
								end

								mainInfo = questCache.link .. " " .. questCache[queryIndex].item .. " "
								mainInfoColored = questCache.link .. " " .. questCache[queryIndex].item .. " "

								mainInfo = mainInfo .. progressInfo
								mainInfoColored = mainInfoColored .. F.CreateColorString(progressInfoColored, progressColor)
								needAnnounce = true
							end
						end
					end
				end
			end
		else
			if not questCache.worldQuestType then
				mainInfo = questCache.link .. " " .. L["Accepted"]
				mainInfoColored =
				questCache.link ..
					" " .. F.CreateColorString(L["Accepted"], { r = 1, g = 1, b = 1 }) .. format(" |T%s:0|t", MER.Media.Icons.accept)
				needAnnounce = true
			end
		end

		if needAnnounce then
			local message = extraInfo .. mainInfo
			if not config.paused then
				self:SendMessage(message, self:GetChannel(config.channel))
			end

			if not isDetailInfo or self.db.quest.disableBlizzard then -- only show details if system do not show that
				local messageColored = extraInfoColored .. mainInfoColored
				_G.UIErrorsFrame:AddMessage(messageColored)
			end
		end
	end

	lastList = currentList
end
