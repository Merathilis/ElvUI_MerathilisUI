local MER, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')
local module = MER:NewModule("mUILFGInfo", "AceHook-3.0")
module.modName = L["LFG Member Info"]

--Cache global variables
--Lua functions
local _G = _G
local pairs = pairs
local format = string.format
--WoW API / Variables
local C_LFGList_GetActivityInfo = C_LFGList.GetActivityInfo
local C_LFGList_GetSearchResultEncounterInfo = C_LFGList.GetSearchResultEncounterInfo
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultMemberCounts = C_LFGList.GetSearchResultMemberCounts
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo
local LFGListUtil_GetQuestDescription = LFGListUtil_GetQuestDescription
local LFGListSearchEntryUtil_GetFriendList = LFGListSearchEntryUtil_GetFriendList
local LFG_LIST_COMMENT_FONT_COLOR = LFG_LIST_COMMENT_FONT_COLOR
local LIGHTBLUE_FONT_COLOR = LIGHTBLUE_FONT_COLOR
local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local RED_FONT_COLOR = RED_FONT_COLOR
local SecondsToTime = SecondsToTime
local IsAddOnLoaded = IsAddOnLoaded
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function MER_LFGListUtil_SetSearchEntryTooltip(tooltip, resultID, autoAcceptOption)
	local searchResultInfo = C_LFGList_GetSearchResultInfo(resultID)
	local activityName, shortName, categoryID, groupID, minItemLevel, filters, minLevel, maxPlayers, displayType, orderIndex, useHonorLevel = C_LFGList_GetActivityInfo(searchResultInfo.activityID)
	local memberCounts = C_LFGList_GetSearchResultMemberCounts(resultID)

	tooltip:SetText(searchResultInfo.name, 1, 1, 1, true)
	tooltip:AddLine(activityName)

	if (searchResultInfo.comment and searchResultInfo.comment == "" and searchResultInfo.questID) then
		searchResultInfo.comment = LFGListUtil_GetQuestDescription(searchResultInfo.questID)
	end

	if (searchResultInfo.comment ~= "") then
		tooltip:AddLine(format(_G.LFG_LIST_COMMENT_FORMAT, searchResultInfo.comment), LFG_LIST_COMMENT_FONT_COLOR.r, LFG_LIST_COMMENT_FONT_COLOR.g, LFG_LIST_COMMENT_FONT_COLOR.b, true)
	end

	tooltip:AddLine(" ")
	if (searchResultInfo.requiredItemLevel > 0) then
		tooltip:AddLine(format(_G.LFG_LIST_TOOLTIP_ILVL, searchResultInfo.requiredItemLevel))
	end

	if (useHonorLevel and searchResultInfo.requiredHonorLevel > 0) then
		tooltip:AddLine(format(_G.LFG_LIST_TOOLTIP_HONOR_LEVEL, searchResultInfo.requiredHonorLevel))
	end

	if (searchResultInfo.voiceChat ~= "") then
		tooltip:AddLine(format(_G.LFG_LIST_TOOLTIP_VOICE_CHAT, searchResultInfo.voiceChat), nil, nil, nil, true)
	end

	if (searchResultInfo.requiredItemLevel > 0 or (useHonorLevel and searchResultInfo.requiredHonorLevel > 0) or searchResultInfo.voiceChat ~= "") then
		tooltip:AddLine(" ")
	end

	if (searchResultInfo.leaderName) then
		tooltip:AddLine(format(_G.LFG_LIST_TOOLTIP_LEADER, searchResultInfo.leaderName))
	end

	if (searchResultInfo.age > 0) then
		tooltip:AddLine(format(_G.LFG_LIST_TOOLTIP_AGE, SecondsToTime(searchResultInfo.age, false, false, 1, false)))
	end

	if (searchResultInfo.leaderName or searchResultInfo.age > 0) then
		tooltip:AddLine(" ")
	end

	tooltip:AddLine(format(_G.LFG_LIST_TOOLTIP_MEMBERS, searchResultInfo.numMembers, memberCounts.TANK, memberCounts.HEALER, memberCounts.DAMAGER))

	if displayType ~= _G.LE_LFG_LIST_DISPLAY_TYPE_CLASS_ENUMERATE and not searchResultInfo.isDelisted and tooltip:IsShown() then
		local roles = {}
		local classInfo = {}
		for i = 1, searchResultInfo.numMembers do
			local role, class, classLocalized = C_LFGList_GetSearchResultMemberInfo(resultID, i)
			classInfo[class] = {
				name = classLocalized,
				color = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
			}
			if not roles[role] then roles[role] = {} end
			if not roles[role][class] then roles[role][class] = 0 end
			roles[role][class] = roles[role][class] + 1
		end
		for role, classes in pairs(roles) do
			tooltip:AddLine(_G[role] .. ": ")
			for class, count in pairs(classes) do
				local text = "   "
				if count > 1 then text = text .. count .. " " else text = text .. "   " end
				text = text .. "|c" .. classInfo[class].color.colorStr .. classInfo[class].name .. "|r "
				tooltip:AddLine(text)
			end
		end
		tooltip:Show()
	end

	if (searchResultInfo.numBNetFriends + searchResultInfo.numCharFriends + searchResultInfo.numGuildMates > 0) then
		tooltip:AddLine(" ")
		tooltip:AddLine(_G.LFG_LIST_TOOLTIP_FRIENDS_IN_GROUP)
		tooltip:AddLine(LFGListSearchEntryUtil_GetFriendList(resultID), 1, 1, 1, true)
	end

	local completedEncounters = C_LFGList_GetSearchResultEncounterInfo(resultID)
	if (completedEncounters and #completedEncounters > 0) then
		tooltip:AddLine(" ")
		tooltip:AddLine(_G.LFG_LIST_BOSSES_DEFEATED)
		for i = 1, #completedEncounters do
			tooltip:AddLine(completedEncounters[i], RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		end
	end

	autoAcceptOption = autoAcceptOption or _G.LFG_LIST_UTIL_ALLOW_AUTO_ACCEPT_LINE

	if autoAcceptOption == _G.LFG_LIST_UTIL_ALLOW_AUTO_ACCEPT_LINE and searchResultInfo.autoAccept then
		tooltip:AddLine(" ")
		tooltip:AddLine(_G.LFG_LIST_TOOLTIP_AUTO_ACCEPT, LIGHTBLUE_FONT_COLOR:GetRGB())
	end

	if (searchResultInfo.isDelisted) then
		tooltip:AddLine(" ")
		tooltip:AddLine(_G.LFG_LIST_ENTRY_DELISTED, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true)
	end

	tooltip:Show()
end

function module:Initialize()
	if E.db.mui.misc.lfgInfo ~= true or IsAddOnLoaded("PremadeGroupsFilter") then return; end

	hooksecurefunc("LFGListUtil_SetSearchEntryTooltip", MER_LFGListUtil_SetSearchEntryTooltip)
end

MER:RegisterModule(module:GetName())
