local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NameHover")

local ipairs = ipairs
local lower = string.lower
local tinsert, tsort = table.insert, table.sort

local C_QuestLog = C_QuestLog
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetQuestObjectives = C_QuestLog.GetQuestObjectives
local C_QuestLog_UnitIsRelatedToActiveQuest = C_QuestLog.UnitIsRelatedToActiveQuest

local function GetActiveQuests()
	local results = {}

	if C_QuestLog and C_QuestLog_GetNumQuestLogEntries then
		local num = C_QuestLog_GetNumQuestLogEntries()
		for i = 1, num do
			local info = C_QuestLog_GetInfo(i)
			if info and not info.isHeader then
				local objectives = {}
				local objs = C_QuestLog_GetQuestObjectives(info.questID) or {}
				for _, o in ipairs(objs) do
					tinsert(objectives, {
						text = o.text,
						type = o.type,
						finished = (o.finished == true),
					})
				end
				tinsert(results, { questID = info.questID, isHeader = false, objectives = objectives })
			end
		end
		return results
	end
end

local function UnitIsRelatedToActiveQuest(unit)
	if C_QuestLog and C_QuestLog_UnitIsRelatedToActiveQuest then
		return C_QuestLog_UnitIsRelatedToActiveQuest(unit)
	end
end

local function StripQuestCount(text)
	if not text then
		return ""
	end
	local s = lower(text)
	s = s:gsub("%s*:?%s*%d+/%d+", "") -- remove " : X/Y"
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

function module:GetQuestText(unit, tooltipLines)
	if UnitIsPlayer(unit) or not UnitIsRelatedToActiveQuest(unit) then
		return nil
	end

	local unitName = UnitName(unit)
	if not unitName or unitName == "" then
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

	for _, info in ipairs(GetActiveQuests()) do
		if info and not info.isHeader then
			local objectives = info.objectives
			if objectives then
				for _, obj in ipairs(objectives) do
					if obj.text then
						if obj.type == "progressbar" and weightsTable then
							local npcWeight = weightsTable[info.questID]
							if npcWeight then
								tinsert(questTexts, {
									text = obj.text .. string.format(" + %.1f%%", npcWeight),
									finished = obj.finished,
								})
								break
							end
						end

						if obj.type == "monster" and string.find(string.lower(obj.text), targetName, 1, true) then
							tinsert(questTexts, { text = obj.text, finished = obj.finished })
							break
						end

						if
							module:IsInTooltip(tooltipLines, obj.text)
							or module:IsInTooltip(tooltipLines, StripQuestCount(obj.text))
						then
							tinsert(questTexts, { text = obj.text, finished = obj.finished })
							break
						end
					end
				end
			end
		end
	end

	tsort(questTexts, function(a, b)
		return not a.finished and b.finished
	end)

	local sortedQuestTexts = {}
	for _, entry in ipairs(questTexts) do
		local color = entry.finished and module.COLOR_COMPLETE or module.COLOR_DEFAULT
		local listIcon = entry.finished and module.ICON_CHECKMARK or module.ICON_LIST
		tinsert(sortedQuestTexts, module:GetTextWithColor(listIcon .. entry.text, color))
	end

	return #sortedQuestTexts > 0 and sortedQuestTexts or nil
end
