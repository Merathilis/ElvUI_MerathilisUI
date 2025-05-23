local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")
local CH = E:GetModule("Chat")

local _G = _G
local pairs, select, type = pairs, select, type
local format = string.format

local SocialQueueUtil_GetQueueName = SocialQueueUtil_GetQueueName
local SocialQueueUtil_GetRelationshipInfo = SocialQueueUtil_GetRelationshipInfo
local GetGroupMembers = C_SocialQueue.GetGroupMembers
local GetGroupQueues = C_SocialQueue.GetGroupQueues
local GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local GetActivityInfoTable = C_LFGList.GetActivityInfoTable
local InCombatLockdown = InCombatLockdown
local UNKNOWN = UNKNOWN
local LFG_LIST_AND_MORE = LFG_LIST_AND_MORE

local SOCIAL_QUEUE_QUEUED_FOR = _G.SOCIAL_QUEUE_QUEUED_FOR:gsub(":%s?$", "") --some language have `:` on end

function module:SocialQueueEvent(_, guid, numAddedItems)
	module.db = E.db.mui.notification
	if not module.db.enable or not module.db.quickJoin or InCombatLockdown() then
		return
	end
	if numAddedItems == 0 or not guid then
		return
	end

	local players = GetGroupMembers(guid)
	if not players then
		return
	end

	local firstMember, numMembers, extraCount, coloredName = players[1], #players, ""
	local playerName, nameColor = SocialQueueUtil_GetRelationshipInfo(firstMember.guid, nil, firstMember.clubId)
	if numMembers > 1 then
		extraCount = format(" +%s", numMembers - 1)
	end
	if playerName and playerName ~= "" then
		coloredName = format("%s%s|r%s", nameColor, playerName, extraCount)
	else
		coloredName = format("{%s%s}", UNKNOWN, extraCount)
	end

	local queues = GetGroupQueues(guid)
	local firstQueue = queues and queues[1]
	local isLFGList = firstQueue and firstQueue.queueData and firstQueue.queueData.queueType == "lfglist"

	if isLFGList and firstQueue and firstQueue.eligible then
		local activityID, activityInfo, name, leaderName, isLeader

		if firstQueue.queueData.lfgListID then
			local searchResultInfo = GetSearchResultInfo(firstQueue.queueData.lfgListID)
			if searchResultInfo then
				activityID, name, leaderName =
					searchResultInfo.activityID, searchResultInfo.name, searchResultInfo.leaderName
				isLeader = CH:SocialQueueIsLeader(playerName, leaderName)
			end
		end

		if activityID or firstQueue.queueData.activityID then
			activityInfo = GetActivityInfoTable(activityID or firstQueue.queueData.activityID)
		end

		if name then
			if not E.db.chat.socialQueueMessages then
				self:DisplayToast(
					coloredName,
					format(
						"%s: [%s] |cff00CCFF%s|r",
						(isLeader and L["is looking for members"]) or L["joined a group"],
						activityInfo and activityInfo.fullName or UNKNOWN,
						name
					),
					_G.ToggleQuickJoinPanel,
					"Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend",
					0.08,
					0.92,
					0.08,
					0.92
				)
			end
		else
			if not E.db.chat.socialQueueMessages then
				self:DisplayToast(
					coloredName,
					format(
						"%s: |cff00CCFF%s|r",
						(isLeader and L["is looking for members"]) or L["joined a group"],
						activityInfo and activityInfo.fullName or UNKNOWN
					),
					_G.ToggleQuickJoinPanel,
					"Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend",
					0.08,
					0.92,
					0.08,
					0.92
				)
			end
		end
	elseif firstQueue then
		local output, outputCount, queueCount, queueName = "", "", 0
		for _, queue in pairs(queues) do
			if type(queue) == "table" and queue.eligible then
				queueName = (queue.queueData and SocialQueueUtil_GetQueueName(queue.queueData)) or ""
				if queueName ~= "" then
					if output == "" then
						output = queueName:gsub("\n.+", "") -- grab only the first queue name
						queueCount = queueCount + select(2, queueName:gsub("\n", "")) -- collect additional on single queue
					else
						queueCount = queueCount + 1 + select(2, queueName:gsub("\n", "")) -- collect additional on additional queues
					end
				end
			end
		end

		if output ~= "" then
			if queueCount > 0 then
				outputCount = format(LFG_LIST_AND_MORE, queueCount)
			end
			if not E.db.chat.socialQueueMessages then
				self:DisplayToast(
					coloredName,
					format("%s: |cff00CCFF%s|r %s", SOCIAL_QUEUE_QUEUED_FOR, output, outputCount),
					_G.ToggleQuickJoinPanel,
					"Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend",
					0.08,
					0.92,
					0.08,
					0.92
				)
			end
		end
	end
end
