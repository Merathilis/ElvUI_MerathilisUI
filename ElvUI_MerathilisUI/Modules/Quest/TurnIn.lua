local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_TurnIn")

local _G = _G
local format = format
local ipairs, select, tonumber = ipairs, select, tonumber
local strfind, strlen, strmatch, strupper = strfind, strlen, strmatch, strupper
local tinsert = tinsert

local AcceptQuest = AcceptQuest
local AcknowledgeAutoAcceptQuest = AcknowledgeAutoAcceptQuest
local CloseQuest = CloseQuest
local CompleteQuest = CompleteQuest
local GetActiveQuestID = GetActiveQuestID
local GetActiveTitle = GetActiveTitle
local GetAutoQuestPopUp = GetAutoQuestPopUp
local GetAvailableQuestInfo = GetAvailableQuestInfo
local GetInstanceInfo = GetInstanceInfo
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local GetNumActiveQuests = GetNumActiveQuests
local GetNumAutoQuestPopUps = GetNumAutoQuestPopUps
local GetNumAvailableQuests = GetNumAvailableQuests
local GetNumQuestChoices = GetNumQuestChoices
local GetNumQuestItems = GetNumQuestItems
local GetQuestID = GetQuestID
local GetQuestItemInfo = GetQuestItemInfo
local GetQuestItemLink = GetQuestItemLink
local GetQuestReward = GetQuestReward
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsModifierKeyDown = IsModifierKeyDown
local IsQuestCompletable = IsQuestCompletable
local IsShiftKeyDown = IsShiftKeyDown
local QuestGetAutoAccept = QuestGetAutoAccept
local QuestInfoItem_OnClick = QuestInfoItem_OnClick
local QuestIsFromAreaTrigger = QuestIsFromAreaTrigger
local SelectActiveQuest = SelectActiveQuest
local SelectAvailableQuest = SelectAvailableQuest
local ShowQuestComplete = ShowQuestComplete
local ShowQuestOffer = ShowQuestOffer
local StaticPopup_Hide = StaticPopup_Hide
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitName = UnitName
local UnitPlayerControlled = UnitPlayerControlled

local C_GossipInfo_GetActiveDelveGossip = C_GossipInfo.GetActiveDelveGossip
local C_GossipInfo_GetActiveQuests = C_GossipInfo.GetActiveQuests
local C_GossipInfo_GetAvailableQuests = C_GossipInfo.GetAvailableQuests
local C_GossipInfo_GetNumActiveQuests = C_GossipInfo.GetNumActiveQuests
local C_GossipInfo_GetNumAvailableQuests = C_GossipInfo.GetNumAvailableQuests
local C_GossipInfo_GetOptions = C_GossipInfo.GetOptions
local C_GossipInfo_SelectActiveQuest = C_GossipInfo.SelectActiveQuest
local C_GossipInfo_SelectAvailableQuest = C_GossipInfo.SelectAvailableQuest
local C_GossipInfo_SelectOption = C_GossipInfo.SelectOption
local C_Item_GetItemInfo = C_Item.GetItemInfo
local C_Minimap_IsFilteredOut = C_Minimap.IsFilteredOut
local C_Minimap_IsTrackingHiddenQuests = C_Minimap.IsTrackingHiddenQuests
local C_QuestInfoSystem_GetQuestClassification = C_QuestInfoSystem.GetQuestClassification
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo
local C_QuestLog_IsQuestFlaggedCompletedOnAccount = C_QuestLog.IsQuestFlaggedCompletedOnAccount
local C_QuestLog_IsQuestTrivial = C_QuestLog.IsQuestTrivial
local C_QuestLog_IsRepeatableQuest = C_QuestLog.IsRepeatableQuest
local C_QuestLog_IsWorldQuest = C_QuestLog.IsWorldQuest

local Enum_GossipOptionRecFlags_QuestLabelPrepend = Enum.GossipOptionRecFlags.QuestLabelPrepend
local Enum_MinimapTrackingFilter_AccountCompletedQuests = Enum.MinimapTrackingFilter.AccountCompletedQuests
local Enum_QuestClassification_Calling = Enum.QuestClassification.Calling
local Enum_QuestClassification_Recurring = Enum.QuestClassification.Recurring

local QUEST_STRING = "cFF0000FF.-" .. TRANSMOG_SOURCE_2
local SKIP_STRING = "^.+|cFFFF0000<.+>|r"
local DELVE_STRING = "%(Delve%)"

local choiceQueue = nil

local ignoreQuestNPC = {
	[4311] = true,
	[14847] = true,
	[43929] = true,
	[45400] = true,
	[77789] = true,
	[87391] = true,
	[88570] = true,
	[93538] = true,
	[98489] = true,
	[101462] = true,
	[101880] = true,
	[103792] = true,
	[105387] = true,
	[107934] = true,
	[108868] = true,
	[111243] = true,
	[114719] = true,
	[119388] = true,
	[121263] = true,
	[124312] = true,
	[126954] = true,
	[127037] = true,
	[135690] = true,
	[141584] = true,
	[142063] = true,
	[143388] = true,
	[143555] = true,
	[150563] = true,
	[150987] = true,
	[154534] = true,
	[160248] = true,
	[162804] = true,
	[168430] = true,
	[223875] = true,
}

local ignoreGossipNPC = {
	[45400] = true,
	-- Bodyguards
	[86682] = true,
	[86927] = true,
	[86933] = true,
	[86934] = true,
	[86945] = true,
	[86946] = true,
	[86964] = true,
	-- Sassy Imps
	[95139] = true,
	[95141] = true,
	[95142] = true,
	[95143] = true,
	[95144] = true,
	[95145] = true,
	[95146] = true,
	[95200] = true,
	[95201] = true,
	-- Misc NPCs
	[79740] = true,
	[79953] = true,
	[84268] = true,
	[84511] = true,
	[84684] = true,
	[117871] = true,
	[150122] = true,
	[150131] = true,
	[155101] = true,
	[155261] = true,
	[165196] = true,
	[171589] = true,
	[171787] = true,
	[171795] = true,
	[171821] = true,
	[172558] = true,
	[172572] = true,
	[173021] = true,
	[175513] = true,
	[180458] = true,
	[182681] = true,
	[183262] = true,
	[184587] = true,
}

local smartChatNPCs = {
	[93188] = true,
	[96782] = true,
	[97004] = true,
	[107486] = true,
	[167839] = true,
}

local followerAssignees = {
	[135614] = true,
	[138708] = true,
}

local darkmoonNPC = {
	[54334] = true,
	[55382] = true,
	[57850] = true,
}

local itemBlacklist = {
	-- Inscription weapons
	[79340] = true,
	[79341] = true,
	[79343] = true,
	-- Darkmoon Faire artifacts
	[71635] = true,
	[71636] = true,
	[71637] = true,
	[71638] = true,
	[71715] = true,
	[71716] = true,
	[71951] = true,
	[71952] = true,
	[71953] = true,
	-- Tiller Gifts
	[79264] = true,
	[79265] = true,
	[79266] = true,
	[79267] = true,
	[79268] = true,
	-- Garrison scouting missives
	[122399] = true,
	[122400] = true,
	[122401] = true,
	[122402] = true,
	[122403] = true,
	[122404] = true,
	[122405] = true,
	[122406] = true,
	[122407] = true,
	[122408] = true,
	[122409] = true,
	[122410] = true,
	[122411] = true,
	[122412] = true,
	[122413] = true,
	[122414] = true,
	[122415] = true,
	[122416] = true,
	[122417] = true,
	[122418] = true,
	[122419] = true,
	[122420] = true,
	[122421] = true,
	[122422] = true,
	[122423] = true,
	[122424] = true,
	-- Misc
	[88604] = true,
}

local ignoreInstances = {
	[1571] = true,
	[1626] = true,
}

local cashRewards = {
	[45724] = 1e5,
	[64491] = 2e6,
	[138123] = 15,
	[138125] = 16,
	[138127] = 15,
	[138129] = 11,
	[138131] = 24,
	[138133] = 27,
}

local function IsAccountCompleted(questID)
	return C_Minimap_IsFilteredOut(Enum_MinimapTrackingFilter_AccountCompletedQuests)
		and C_QuestLog_IsQuestFlaggedCompletedOnAccount(questID)
end

function IsQuestRepeatable(questID)
	if C_QuestLog_IsWorldQuest(questID) then
		return true
	end

	if C_QuestLog_IsRepeatableQuest(questID) then
		return true
	end

	local classification = C_QuestInfoSystem_GetQuestClassification(questID)
	return classification == Enum_QuestClassification_Recurring or classification == Enum_QuestClassification_Calling
end

function module:GetNPCID(unit)
	return tonumber(strmatch(UnitGUID(unit or "npc") or "", "Creature%-.-%-.-%-.-%-.-%-(.-)%-"))
end

do
	local modiferFunctionTable = {
		["SHIFT"] = IsShiftKeyDown,
		["CTRL"] = IsControlKeyDown,
		["ALT"] = IsAltKeyDown,
		["Any"] = IsModifierKeyDown,
		["NONE"] = function()
			return false
		end,
	}

	function module:IsPaused(moduleEvent)
		if not self.db or moduleEvent and self.db.mode ~= "ALL" and moduleEvent ~= self.db.mode then
			return true
		end

		local func = modiferFunctionTable[self.db.pauseModifier]
		if func and func() then
			return true
		end

		return false
	end
end

function module:IsIgnoredNPC(npcID)
	npcID = npcID or self:GetNPCID()

	if npcID and ignoreQuestNPC[npcID] then
		return true
	end

	return npcID and self.db and self.db.customIgnoreNPCs and self.db.customIgnoreNPCs[npcID]
end

function module:QUEST_GREETING()
	if self:IsIgnoredNPC() then
		return
	end

	local active = GetNumActiveQuests()
	if active > 0 then
		for index = 1, active do
			local _, isComplete = GetActiveTitle(index)
			local questID = GetActiveQuestID(index)
			local isWorldQuest = C_QuestLog_IsWorldQuest(questID)
			local skipRepeatable = self.db.onlyRepeatable and not IsQuestRepeatable(questID)
			if isComplete and not isWorldQuest and not skipRepeatable then
				if not self:IsPaused("COMPLETE") then
					SelectActiveQuest(index)
				end
			end
		end
	end

	local available = GetNumAvailableQuests()
	if available > 0 then
		for index = 1, available do
			local isTrivial, _, _, _, questID = GetAvailableQuestInfo(index)
			local skipRepeatable = self.db.onlyRepeatable and not IsQuestRepeatable(questID)
			if
				not IsAccountCompleted(questID)
				and (not isTrivial or C_Minimap_IsTrackingHiddenQuests())
				and not skipRepeatable
				and not self:IsPaused("ACCEPT")
			then
				SelectAvailableQuest(index)
			end
		end
	end
end

function module:GOSSIP_SHOW()
	local npcID = self:GetNPCID()
	if self:IsPaused() or self:IsIgnoredNPC(npcID) then
		return
	end

	local numActiveQuests = C_GossipInfo_GetNumActiveQuests()
	if numActiveQuests > 0 then
		for _, gossipQuestUIInfo in ipairs(C_GossipInfo_GetActiveQuests()) do
			local questID = gossipQuestUIInfo.questID
			local isWorldQuest = C_QuestLog_IsWorldQuest(questID)
			local skipRepeatable = self.db.onlyRepeatable and not IsQuestRepeatable(questID)
			if gossipQuestUIInfo.isComplete and not isWorldQuest and not skipRepeatable then
				if not self:IsPaused("COMPLETE") then
					C_GossipInfo_SelectActiveQuest(questID)
				end
			end
		end
	end

	local gossipOptions = C_GossipInfo_GetOptions() or C_GossipInfo_GetActiveDelveGossip()
	local numGossipOptions = gossipOptions and #gossipOptions
	for index, gossipOption in ipairs(gossipOptions) do
		if strfind(gossipOption.name, SKIP_STRING) then
			return
		end
	end

	local numAvailableQuests = C_GossipInfo_GetNumAvailableQuests()
	if numAvailableQuests > 0 then
		for _, gossipQuestUIInfo in ipairs(C_GossipInfo_GetAvailableQuests()) do
			local isTrivial = gossipQuestUIInfo.isTrivial
			local questID = gossipQuestUIInfo.questID
			local skipRepeatable = self.db.onlyRepeatable and not IsQuestRepeatable(questID)

			if
				not IsAccountCompleted(questID)
				and (not isTrivial or C_Minimap_IsTrackingHiddenQuests() or (isTrivial and npcID == 64337))
				and not skipRepeatable
				and not self:IsPaused("ACCEPT")
			then
				C_GossipInfo_SelectAvailableQuest(questID)
			end
		end
	end

	if not numGossipOptions or numGossipOptions <= 0 then
		return
	end

	local firstGossipOptionID = gossipOptions[1].gossipOptionID

	if not (self.db and self.db.smartChat) then
		return
	end

	if smartChatNPCs[npcID] then
		return C_GossipInfo_SelectOption(firstGossipOptionID)
	end

	if numActiveQuests == 0 and numAvailableQuests == 0 then
		if numGossipOptions == 1 then
			if npcID == 57850 then
				return C_GossipInfo_SelectOption(firstGossipOptionID)
			end

			local _, instance, _, _, _, _, _, mapID = GetInstanceInfo()
			if instance ~= "raid" and not ignoreGossipNPC[npcID] and not ignoreInstances[mapID] then
				local name, status = gossipOptions[1].name, gossipOptions[1].status
				if name and status and status == 0 then
					local questNameFound = strfind(name, "cFF0000FF") and strfind(name, QUEST_STRING)
					local delveNameFound = strfind(name, DELVE_STRING)
					if questNameFound or delveNameFound then
						return C_GossipInfo_SelectOption(firstGossipOptionID)
					end
				end
			end
		elseif self.db and self.db.followerAssignees and followerAssignees[npcID] and numGossipOptions > 1 then
			return C_GossipInfo_SelectOption(firstGossipOptionID)
		end
	end

	if numGossipOptions > 0 then
		local maybeQuestIndexes = {}
		for index, gossipOption in ipairs(gossipOptions) do
			if
				gossipOption.name
				and (
					gossipOption.flags == Enum_GossipOptionRecFlags_QuestLabelPrepend
					or strfind(gossipOption.name, QUEST_STRING)
				)
			then
				tinsert(maybeQuestIndexes, index)
			end
		end

		if #maybeQuestIndexes == 1 then
			local index = maybeQuestIndexes[1]
			local status = gossipOptions[index] and gossipOptions[index].status
			if status and status == 0 then
				return C_GossipInfo_SelectOption(gossipOptions[index].gossipOptionID)
			end
		end
	end
end

function module:GOSSIP_CONFIRM(_, index)
	local npcID = self:GetNPCID()
	if self:IsPaused() or self:IsIgnoredNPC(npcID) then
		return
	end

	if not (self.db and self.db.smartChat) then
		return
	end

	if self.db and self.db.darkmoon and npcID and darkmoonNPC[npcID] then
		C_GossipInfo_SelectOption(index, "", true)
		StaticPopup_Hide("GOSSIP_CONFIRM")
	end
end

function module:QUEST_DETAIL()
	if self:IsPaused("ACCEPT") then
		return
	end

	local questID = GetQuestID()
	if
		QuestIsFromAreaTrigger()
		or QuestGetAutoAccept()
		or C_Minimap_IsTrackingHiddenQuests()
		or not C_QuestLog_IsQuestTrivial(questID)
	then
		if self:IsIgnoredNPC() then
			return
		end

		if questID and self.db.onlyRepeatable and not IsQuestRepeatable(questID) then
			return
		end

		AcceptQuest()
	end
end

function module:QUEST_ACCEPT_CONFIRM()
	if self:IsPaused("ACCEPT") then
		return
	end

	if self.db.onlyRepeatable then
		local questID = GetQuestID()
		if questID and not IsQuestRepeatable(questID) then
			return
		end
	end

	AcceptQuest()
end

function module:QUEST_ACCEPTED()
	if _G.QuestFrame:IsShown() and QuestGetAutoAccept() then
		CloseQuest()
	end
end

function module:QUEST_ITEM_UPDATE()
	if choiceQueue and self[choiceQueue] then
		self[choiceQueue](self)
	end
end

function module:QUEST_PROGRESS()
	if self:IsPaused("COMPLETE") then
		return
	end

	if not IsQuestCompletable() then
		return
	end

	local questID = GetQuestID()
	if self.db.onlyRepeatable and questID and not IsQuestRepeatable(questID) then
		return
	end

	local tagInfo = C_QuestLog_GetQuestTagInfo(questID)
	if tagInfo and (tagInfo.tagID == 153 or tagInfo.worldQuestType) or self:IsIgnoredNPC() then
		return
	end

	local requiredItems = GetNumQuestItems()
	if requiredItems > 0 then
		for index = 1, requiredItems do
			local link = GetQuestItemLink("required", index)
			if link then
				local id = GetItemInfoFromHyperlink(link)
				if id and itemBlacklist[id] then
					return CloseQuest()
				end
			else
				choiceQueue = "QUEST_PROGRESS"
				return GetQuestItemInfo("required", index)
			end
		end
	end

	CompleteQuest()
end

function module:QUEST_COMPLETE()
	if self:IsPaused("COMPLETE") then
		return
	end

	if self:IsIgnoredNPC() then
		return
	end

	if self.db.onlyRepeatable then
		local questID = GetQuestID()
		if questID and not IsQuestRepeatable(questID) then
			return
		end
	end

	local choices = GetNumQuestChoices()
	if choices <= 1 then
		GetQuestReward(1)
	elseif choices > 1 and self.db and self.db.selectReward then
		local bestSellPrice, bestIndex = 0

		for index = 1, choices do
			local link = GetQuestItemLink("choice", index)
			if link then
				local itemSellPrice = select(11, C_Item_GetItemInfo(link))
				itemSellPrice = cashRewards[GetItemInfoFromHyperlink(link)] or itemSellPrice

				if itemSellPrice > bestSellPrice then
					bestSellPrice, bestIndex = itemSellPrice, index
				end
			else
				choiceQueue = "QUEST_COMPLETE"
				return GetQuestItemInfo("choice", index)
			end
		end

		local button = bestIndex and _G.QuestInfoRewardsFrame.RewardButtons[bestIndex]
		if button then
			QuestInfoItem_OnClick(button)
		end
	end
end

function module:AttemptAutoComplete(event)
	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end

	if self:IsPaused("COMPLETE") then
		return
	end

	if GetNumAutoQuestPopUps() > 0 then
		if UnitIsDeadOrGhost("player") then
			self:RegisterEvent("PLAYER_REGEN_ENABLED", "AttemptAutoComplete")
			return
		end

		local questID, popUpType = GetAutoQuestPopUp(1)

		if self.db.onlyRepeatable then
			if questID and not IsQuestRepeatable(questID) then
				return
			end
		end

		if not C_QuestLog_IsWorldQuest(questID) then
			if popUpType == "OFFER" then
				ShowQuestOffer(questID)
			elseif popUpType == "COMPLETE" then
				ShowQuestComplete(questID)
			end
		end

		if _G.QuestObjectiveTracker then
			_G.QuestObjectiveTracker:RemoveAutoQuestPopUp(questID)
		end
	end
end

function module:AddTargetToBlacklist()
	if not UnitExists("target") then
		F.Print(L["Target does not exist."])
		return
	end
	if UnitPlayerControlled("target") then
		F.Print(L["Target is not an NPC."])
		return
	end
	local npcID = self:GetNPCID("target")
	if npcID then
		local list = E.db.mui.quest.turnIn.customIgnoreNPCs
		list[npcID] = UnitName("target")
		F.Print(format(L["%s has been added to the ignore list."], list[npcID]))
	end
end

_G.SLASH_MER_TURN_IN1 = "/muiti"
_G.SLASH_MER_TURN_IN2 = "/merti"
_G.SLASH_MER_TURN_IN3 = "/merturnin"

_G.SlashCmdList["MER_TURN_IN"] = function(msg)
	if msg and strlen(msg) > 0 then
		msg = strupper(msg)
		if msg == "ON" or msg == "1" or msg == "TRUE" or msg == "ENABLE" then
			module.db.enable = true
		elseif msg == "OFF" or msg == "0" or msg == "FALSE" or msg == "DISABLE" then
			module.db.enable = false
		elseif msg == "ADDTARGET" or msg == "ADD" or msg == "IGNORE" or msg == "ADD TARGET" then
			module:AddTargetToBlacklist()
			return
		end
	else
		module.db.enable = not module.db.enable
	end
	module:ProfileUpdate()

	F.Print(format("%s %s", L["Turn In"], module.db.enable and L["Enabled"] or L["Disabled"]))
end

function module:Initialize()
	self.db = E.db.mui.quest.turnIn
	if not self.db.enable or self.initialized then
		return
	end

	self:RegisterEvent("GOSSIP_CONFIRM")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("PLAYER_LOGIN", "AttemptAutoComplete")
	self:RegisterEvent("QUEST_ACCEPTED")
	self:RegisterEvent("QUEST_ACCEPT_CONFIRM")
	self:RegisterEvent("QUEST_COMPLETE")
	self:RegisterEvent("QUEST_DETAIL")
	self:RegisterEvent("QUEST_GREETING")
	self:RegisterEvent("QUEST_ITEM_UPDATE")
	self:RegisterEvent("QUEST_LOG_UPDATE", "AttemptAutoComplete")
	self:RegisterEvent("QUEST_PROGRESS")

	self.initialized = true
end

function module:ProfileUpdate()
	self:Initialize()

	if self.initialized and not self.db.enable then
		self:UnregisterEvent("GOSSIP_CONFIRM")
		self:UnregisterEvent("GOSSIP_SHOW")
		self:UnregisterEvent("PLAYER_LOGIN")
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UnregisterEvent("QUEST_ACCEPTED")
		self:UnregisterEvent("QUEST_ACCEPT_CONFIRM")
		self:UnregisterEvent("QUEST_COMPLETE")
		self:UnregisterEvent("QUEST_DETAIL")
		self:UnregisterEvent("QUEST_GREETING")
		self:UnregisterEvent("QUEST_ITEM_UPDATE")
		self:UnregisterEvent("QUEST_LOG_UPDATE")
		self:UnregisterEvent("QUEST_PROGRESS")
		self.initialized = false
	end
end

MER:RegisterModule(module:GetName())
