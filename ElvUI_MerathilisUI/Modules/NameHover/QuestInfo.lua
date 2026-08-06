local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NameHover")

local format, find, lower = string.format, string.find, string.lower
local tsort = table.sort

local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetQuestObjectives = C_QuestLog.GetQuestObjectives
local C_QuestLog_UnitIsRelatedToActiveQuest = C_QuestLog.UnitIsRelatedToActiveQuest
local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName

-- Cached quest list; invalidated on QUEST_LOG_UPDATE / PEW
local cachedQuests
local cacheDirty = true

local function InvalidateQuestCache()
	cacheDirty = true
	cachedQuests = nil
end

module.InvalidateQuestCache = InvalidateQuestCache

local function GetActiveQuests()
	if not cacheDirty and cachedQuests then
		return cachedQuests
	end

	local results = {}
	local num = C_QuestLog_GetNumQuestLogEntries()
	for i = 1, num do
		local info = C_QuestLog_GetInfo(i)
		if info and not info.isHeader then
			local objectives = {}
			local objs = C_QuestLog_GetQuestObjectives(info.questID) or {}
			for j = 1, #objs do
				local o = objs[j]
				objectives[j] = {
					text = o.text,
					type = o.type,
					finished = o.finished == true,
				}
			end
			results[#results + 1] = {
				questID = info.questID,
				isHeader = false,
				objectives = objectives,
			}
		end
	end

	cachedQuests = results
	cacheDirty = false
	return results
end

local function StripQuestCount(text)
	if not text then
		return ""
	end
	local s = lower(text)
	s = s:gsub("%s*:?%s*%d+/%d+", "")
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

function module:GetQuestText(unit, tooltipLines)
	if UnitIsPlayer(unit) or not C_QuestLog_UnitIsRelatedToActiveQuest(unit) then
		return nil
	end

	local unitName = UnitName(unit)
	if not (E:NotSecretValue(unitName) and unitName) then
		return nil
	end

	local questTexts = {}
	local targetName = lower(unitName)
	tooltipLines = tooltipLines or {}

	local weightsTable
	local npcID = module:GetNpcID(unit)
	if npcID and module.LOP and module.LOP.GetNPCWeightByCurrentQuests then
		weightsTable = module.LOP:GetNPCWeightByCurrentQuests(npcID)
	end

	local quests = GetActiveQuests()
	for i = 1, #quests do
		local info = quests[i]
		local objectives = info.objectives
		if objectives then
			for j = 1, #objectives do
				local obj = objectives[j]
				if obj.text then
					local matched = false

					if obj.type == "progressbar" and weightsTable then
						local npcWeight = weightsTable[info.questID]
						if npcWeight then
							questTexts[#questTexts + 1] = {
								text = obj.text .. format(" + %.1f%%", npcWeight),
								finished = obj.finished,
							}
							matched = true
						end
					elseif obj.type == "monster" and find(lower(obj.text), targetName, 1, true) then
						questTexts[#questTexts + 1] = { text = obj.text, finished = obj.finished }
						matched = true
					elseif
						module:IsInTooltip(tooltipLines, obj.text)
						or module:IsInTooltip(tooltipLines, StripQuestCount(obj.text))
					then
						questTexts[#questTexts + 1] = { text = obj.text, finished = obj.finished }
						matched = true
					end

					if matched then
						break
					end
				end
			end
		end
	end

	if #questTexts == 0 then
		return nil
	end

	tsort(questTexts, function(a, b)
		return not a.finished and b.finished
	end)

	local sortedQuestTexts = {}
	for i = 1, #questTexts do
		local entry = questTexts[i]
		local color = entry.finished and module.COLOR_COMPLETE or module.COLOR_DEFAULT
		local listIcon = entry.finished and module.ICON_CHECKMARK or module.ICON_LIST
		sortedQuestTexts[i] = module:GetTextWithColor(listIcon .. entry.text, color)
	end

	return sortedQuestTexts
end
