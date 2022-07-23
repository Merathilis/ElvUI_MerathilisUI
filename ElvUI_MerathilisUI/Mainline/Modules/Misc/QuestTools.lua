local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Misc')
local LCG = E.Libs.CustomGlow

local pairs, strfind = pairs, strfind
local UnitGUID, GetItemCount = UnitGUID, GetItemCount
local GetActionInfo, GetSpellInfo, GetOverrideBarSkin = GetActionInfo, GetSpellInfo, GetOverrideBarSkin
local C_QuestLog_GetLogIndexForQuestID = C_QuestLog.GetLogIndexForQuestID
local C_GossipInfo_SelectOption, C_GossipInfo_GetNumOptions = C_GossipInfo.SelectOption, C_GossipInfo.GetNumOptions

local watchQuests = {
	-- check npc
	[60739] = true, -- https://www.wowhead.com/quest=60739/tough-crowd
	[62453] = true, -- https://www.wowhead.com/quest=62453/into-the-unknown
	-- glow
	[59585] = true, -- https://www.wowhead.com/quest=59585/well-make-an-aspirant-out-of-you
	[64271] = true, -- https://www.wowhead.com/quest=64271/a-more-civilized-way
}

local activeQuests = {}

local questNPCs = {
	[170080] = true, -- Boggart
	[174498] = true, -- Shimmersod
}

function module:QuestTool_Init()
	for questID, value in pairs(watchQuests) do
		if C_QuestLog_GetLogIndexForQuestID(questID) then
			activeQuests[questID] = value
		end
	end
end

function module:QuestTool_Accept(questID)
	if watchQuests[questID] then
		activeQuests[questID] = watchQuests[questID]
	end
end

function module:QuestTool_Remove(questID)
	if watchQuests[questID] then
		activeQuests[questID] = nil
	end
end

local function isActionMatch(msg, text)
	return text and strfind(msg, text)
end

function module:QuestTool_SetGlow(msg)
	if GetOverrideBarSkin() and (activeQuests[59585] or activeQuests[64271]) then
		for i = 1, 3 do
			local button = _G["ActionButton"..i]
			local _, spellID = GetActionInfo(button.action)
			local name = spellID and GetSpellInfo(spellID)
			if isActionMatch(msg, name) then
				LCG.ShowOverlayGlow(button)
			else
				LCG.HideOverlayGlow(button)
			end
		end
		module.isGlowing = true
	else
		module:QuestTool_ClearGlow()
	end
end

function module:QuestTool_ClearGlow()
	if module.isGlowing then
		module.isGlowing = nil
		for i = 1, 3 do
			LCG.HideOverlayGlow(_G["ActionButton"..i])
		end
	end
end

function module:QuestTool_SetQuestUnit()
	if not activeQuests[60739] and not activeQuests[62453] then return end

	local guid = UnitGUID("mouseover")
	local npcID = guid and F.GetNPCID(guid)
	if questNPCs[npcID] then
		self:AddLine(L["NPCisTrue"])
	end
end

function module:QuestTools()
	local db = E.db.mui.misc.quest
	if not db.questTool then
		return
	end

	local handler = CreateFrame("Frame", nil, E.UIParent)
	module.QuestHandler = handler

	local text = F.CreateText(handler, "OVERLAY", 20)
	text:ClearAllPoints()
	text:SetPoint("TOP", E.UIParent, 0, -200)
	text:SetWidth(800)
	text:SetWordWrap(true)
	text:Hide()
	module.QuestTip = text

	-- Check existing quests
	module:QuestTool_Init()
	MER:RegisterEvent("QUEST_ACCEPTED", module.QuestTool_Accept)
	MER:RegisterEvent("QUEST_REMOVED", module.QuestTool_Remove)

	-- Override button quests
	MER:RegisterEvent("CHAT_MSG_MONSTER_SAY", module.QuestTool_SetGlow)
	MER:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN", module.QuestTool_ClearGlow)

	-- Check npc in quests
	_G.GameTooltip:HookScript("OnTooltipSetUnit", module.QuestTool_SetQuestUnit)

	-- Auto gossip
	local firstStep
	MER:RegisterEvent("GOSSIP_SHOW", function()
		local guid = UnitGUID("npc")
		local npcID = guid and F.GetNPCID(guid)
		if npcID == 174498 then
			C_GossipInfo_SelectOption(3)
		elseif npcID == 174371 then
			if GetItemCount(183961) == 0 then return end
			if C_GossipInfo_GetNumOptions() ~= 5 then return end
			if firstStep then
				C_GossipInfo_SelectOption(5)
			else
				C_GossipInfo_SelectOption(2)
				firstStep = true
			end
		end
	end)
end


module:AddCallback("QuestTools")
