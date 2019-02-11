local MER, E, L, V, P, G = unpack(select(2, ...))
local MERTT = MER:NewModule("mUITooltip", "AceTimer-3.0", "AceHook-3.0", "AceEvent-3.0")
local TT = E:GetModule("Tooltip")
MERTT.modName = L["mUI Tooltip"]

--Cache global variables
--Lua functions
local pairs, select = pairs, select
local format = string.format
local tsort, twipe = table.sort, table.wipe
--WoW API / Variables
local GetGuildInfo = GetGuildInfo
local GetMouseFocus = GetMouseFocus
local IsControlKeyDown = IsControlKeyDown
local IsAltKeyDown = IsAltKeyDown
local IsForbidden = IsForbidden
local IsShiftKeyDown = IsShiftKeyDown
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName
local UnitPVPName = UnitPVPName
local UnitLevel = UnitLevel
local UnitRealmRelationship = UnitRealmRelationship
local FOREIGN_SERVER_LABEL = FOREIGN_SERVER_LABEL
local LE_REALM_RELATION_COALESCED = LE_REALM_RELATION_COALESCED
local LE_REALM_RELATION_VIRTUAL = LE_REALM_RELATION_VIRTUAL
local INTERACTIVE_SERVER_LABEL = INTERACTIVE_SERVER_LABEL
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local hooksecurefunc = hooksecurefunc
local UIParent = UIParent
local C_LFGList_GetActivityInfo = C_LFGList.GetActivityInfo
local C_LFGList_GetSearchResultMemberCounts = C_LFGList.GetSearchResultMemberCounts
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local LFGListUtil_GetQuestDescription = LFGListUtil_GetQuestDescription
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo
local C_LFGList_GetSearchResultEncounterInfo = C_LFGList.GetSearchResultEncounterInfo
local LFGListSearchEntryUtil_GetFriendList = LFGListSearchEntryUtil_GetFriendList

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: CUSTOM_CLASS_COLORS, UIParent, GameTooltipTextLeft1

local AFK_LABEL = " |cffFFFFFF<|r|cffFF0000"..L["AFK"].."|r|cffFFFFFF>|r"
local DND_LABEL = " |cffFFFFFF<|r|cffFFFF00"..L["DND"].."|r|cffFFFFFF>|r"

function MERTT:GameTooltip_OnTooltipSetUnit(tt)
	if tt:IsForbidden() then return end
	local unit = select(2, tt:GetUnit())
	if((tt:GetOwner() ~= UIParent) and (self.db.visibility and self.db.visibility.unitFrames ~= 'NONE')) then
		local modifier = self.db.visibility.unitFrames

		if(modifier == 'ALL' or not ((modifier == 'SHIFT' and IsShiftKeyDown()) or (modifier == 'CTRL' and IsControlKeyDown()) or (modifier == 'ALT' and IsAltKeyDown()))) then
			tt:Hide()
			return
		end
	end

	if(not unit) then
		local GMF = GetMouseFocus()
		if(GMF and GMF.GetAttribute and GMF:GetAttribute("unit")) then
			unit = GMF:GetAttribute("unit")
		end
		if(not unit or not UnitExists(unit)) then
			return
		end
	end

	self:RemoveTrashLines(tt) --keep an eye on this may be buggy
	local level = UnitLevel(unit)
	local isShiftKeyDown = IsShiftKeyDown()

	local color
	if(UnitIsPlayer(unit)) then
		local localeClass, class = UnitClass(unit)
		local name, realm = UnitName(unit)
		local guildName, guildRankName, _, guildRealm = GetGuildInfo(unit)
		local pvpName = UnitPVPName(unit)
		local relationship = UnitRealmRelationship(unit);
		if not localeClass or not class then return; end
		color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

		if(self.db.playerTitles and pvpName) then
			name = pvpName
		end

		if(realm and realm ~= "") then
			if(isShiftKeyDown) or self.db.alwaysShowRealm then
				name = name..format("|cff00c0fa%s|r", " - "..realm)
			elseif(relationship == LE_REALM_RELATION_COALESCED) then
				name = name..format("|cff00c0fa%s|r", FOREIGN_SERVER_LABEL)
			elseif(relationship == LE_REALM_RELATION_VIRTUAL) then
				name = name..format("|cff00c0fa%s|r", INTERACTIVE_SERVER_LABEL)
			end
		end

		if(UnitIsAFK(unit)) then
			name = name..AFK_LABEL
		elseif(UnitIsDND(unit)) then
			name = name..DND_LABEL
		end

		GameTooltipTextLeft1:SetFormattedText("|c%s%s|r", color.colorStr, name)

		local lineOffset = 2
		if(guildName) then
			if(guildRealm and isShiftKeyDown) then
				guildName = guildName.."-"..guildRealm
			end

			if(self.db.guildRanks) then
				GameTooltipTextLeft2:SetText(("|cff00c0fa[|r|cff00ff10%s|r|cff00c0fa]|r <|cff00ff10%s|r>"):format(guildName, guildRankName))
			else
				GameTooltipTextLeft2:SetText(("[|cff00ff10%s|r]"):format(guildName))
			end
			lineOffset = 3
		end
	end
end

function MERTT_SetSearchEntryTooltip(tooltip, resultID, autoAcceptOption)
	local searchResultInfo = C_LFGList_GetSearchResultInfo(resultID)
	local activityName, shortName, categoryID, groupID, minItemLevel, filters, minLevel, maxPlayers, displayType, orderIndex, useHonorLevel = C_LFGList_GetActivityInfo(searchResultInfo.activityID)
	local memberCounts = C_LFGList_GetSearchResultMemberCounts(resultID)
	tooltip:SetText(searchResultInfo.name, 1, 1, 1, true)
	tooltip:AddLine(activityName)
	if ( searchResultInfo.comment and searchResultInfo.comment == "" and searchResultInfo.questID ) then
		searchResultInfo.comment = LFGListUtil_GetQuestDescription(searchResultInfo.questID)
	end
	if ( searchResultInfo.comment ~= "" ) then
		tooltip:AddLine(format(LFG_LIST_COMMENT_FORMAT, searchResultInfo.comment), LFG_LIST_COMMENT_FONT_COLOR.r, LFG_LIST_COMMENT_FONT_COLOR.g, LFG_LIST_COMMENT_FONT_COLOR.b, true)
	end
	tooltip:AddLine(" ")
	if ( searchResultInfo.requiredItemLevel > 0 ) then
		tooltip:AddLine(format(LFG_LIST_TOOLTIP_ILVL, searchResultInfo.requiredItemLevel))
	end
	if ( useHonorLevel and searchResultInfo.requiredHonorLevel > 0 ) then
		tooltip:AddLine(format(LFG_LIST_TOOLTIP_HONOR_LEVEL, searchResultInfo.requiredHonorLevel))
	end
	if ( searchResultInfo.voiceChat ~= "" ) then
		tooltip:AddLine(format(LFG_LIST_TOOLTIP_VOICE_CHAT, searchResultInfo.voiceChat), nil, nil, nil, true)
	end
	if ( searchResultInfo.requiredItemLevel > 0 or (useHonorLevel and searchResultInfo.requiredHonorLevel > 0) or searchResultInfo.voiceChat ~= "" ) then
		tooltip:AddLine(" ")
	end

	if ( searchResultInfo.leaderName ) then
		tooltip:AddLine(format(LFG_LIST_TOOLTIP_LEADER, searchResultInfo.leaderName))
	end
	if ( searchResultInfo.age > 0 ) then
		tooltip:AddLine(format(LFG_LIST_TOOLTIP_AGE, SecondsToTime(searchResultInfo.age, false, false, 1, false)))
	end

	if ( searchResultInfo.leaderName or searchResultInfo.age > 0 ) then
		tooltip:AddLine(" ")
	end

	tooltip:AddLine(format(LFG_LIST_TOOLTIP_MEMBERS, searchResultInfo.numMembers, memberCounts.TANK, memberCounts.HEALER, memberCounts.DAMAGER))
	local roleClasses = {}
	for i = 1, searchResultInfo.numMembers do
		local role, class, classLocalized = C_LFGList_GetSearchResultMemberInfo(resultID, i)
		local classcounts = roleClasses[role] or {}
		roleClasses[role] = classcounts
		if not classcounts[class] then
			classcounts[class] = 1
		else
			classcounts[class] = classcounts[class] + 1
		end
	end
	tsort(roleClasses, function(a, b) return a > b end)
	for role, classcnts in pairs(roleClasses) do
		--tooltip:AddLine(_G[role]..":")
		for class, cnt in pairs(classcnts) do
			local classColor = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
			tooltip:AddLine(format(LFG_LIST_TOOLTIP_CLASS_ROLE.." - %d", LOCALIZED_CLASS_NAMES_MALE[class], _G[role], cnt), classColor.r, classColor.g, classColor.b)
		end
		twipe(classcnts)
	end
	twipe(roleClasses)

	if ( searchResultInfo.numBNetFriends + searchResultInfo.numCharFriends + searchResultInfo.numGuildMates > 0 ) then
		tooltip:AddLine(" ")
		tooltip:AddLine(LFG_LIST_TOOLTIP_FRIENDS_IN_GROUP);
		tooltip:AddLine(LFGListSearchEntryUtil_GetFriendList(resultID), 1, 1, 1, true)
	end

	local completedEncounters = C_LFGList_GetSearchResultEncounterInfo(resultID);
	if ( completedEncounters and #completedEncounters > 0 ) then
		tooltip:AddLine(" ")
		tooltip:AddLine(LFG_LIST_BOSSES_DEFEATED)
		for i=1, #completedEncounters do
			tooltip:AddLine(completedEncounters[i], RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		end
	end

	autoAcceptOption = autoAcceptOption or LFG_LIST_UTIL_ALLOW_AUTO_ACCEPT_LINE

	if autoAcceptOption == LFG_LIST_UTIL_ALLOW_AUTO_ACCEPT_LINE and searchResultInfo.autoAccept then
		tooltip:AddLine(" ");
		tooltip:AddLine(LFG_LIST_TOOLTIP_AUTO_ACCEPT, LIGHTBLUE_FONT_COLOR:GetRGB())
	end

	if ( searchResultInfo.isDelisted ) then
		tooltip:AddLine(" ")
		tooltip:AddLine(LFG_LIST_ENTRY_DELISTED, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true)
	end

	tooltip:Show()
end
hooksecurefunc("LFGListUtil_SetSearchEntryTooltip", MERTT_SetSearchEntryTooltip)

function MERTT:Initialize()
	if E.private.tooltip.enable ~= true or E.db.mui.tooltip.tooltip ~= true then return end
	self.db = E.db.tooltip

	hooksecurefunc(TT, "GameTooltip_OnTooltipSetUnit", MERTT.GameTooltip_OnTooltipSetUnit)
end

local function InitializeCallback()
	MERTT:Initialize()
end

MER:RegisterModule(MERTT:GetName(), InitializeCallback)
