local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local LRI = LibStub:GetLibrary("LibRealmInfo");

-- Cache global variables
-- GLOBALS: realm, DEFAULT_CHAT_FRAME, AddIgnore, C_LFGList, LFGListUtil_GetSearchEntryMenu, LFGListUtil_GetApplicantMemberMenu, UIDROPDOWNMENU_INIT_MENU, UIDROPDOWNMENU_MENU_LEVEL
local _G = _G
local tinsert = table.insert
local gsub, byte, format, lower, upper = string.gsub, string.byte, string.format, string.lower, string.upper

local GetRealmName = GetRealmName

-- Credits: Driizt, Phanx

local supportedRegion = {
	["us"] = true,
	["eu"] = true,
	["tw"] = true,
	["cn"] = true,
	["kr"] = true,
}

UnitPopupButtons["AQL"] = {text = L['ARMORYQUICKLINK'], dist = 0};
tinsert(UnitPopupMenus["PARTY"], #(UnitPopupMenus["PARTY"])-1, "AQL");
tinsert(UnitPopupMenus["PLAYER"], #(UnitPopupMenus["PLAYER"])-1, "AQL");
tinsert(UnitPopupMenus["RAID_PLAYER"], #(UnitPopupMenus["RAID_PLAYER"])-1, "AQL");
tinsert(UnitPopupMenus["GUILD"], #(UnitPopupMenus["GUILD"])-1, "AQL");
tinsert(UnitPopupMenus["GUILD_OFFLINE"], #(UnitPopupMenus["GUILD_OFFLINE"])-1, "AQL");
tinsert(UnitPopupMenus["FRIEND"], #(UnitPopupMenus["FRIEND"])-1, "AQL");
tinsert(UnitPopupMenus["FRIEND_OFFLINE"], #(UnitPopupMenus["FRIEND_OFFLINE"])-1, "AQL");
tinsert(UnitPopupMenus["CHAT_ROSTER"], #(UnitPopupMenus["CHAT_ROSTER"])-1, "AQL");

local function urlEscape(url)
	return gsub(url, "([^A-Za-z0-9_:/?&=.-])",
	function(ch)
		return format("%%%02x", byte(ch))
	end)
end

local function GetAQLRealm(pRealm)
	local _,realm,_,_,_,_,region = LRI:GetRealmInfo(pRealm)
	return realm, region
end

local function constructUrl(name,server)
	if not name or name == "" then return end
	if not server or server == "" then server = GetRealmName() end
	local region, url;
	
	realm, region = GetAQLRealm(server)
	
	if not realm and not region then
		if LRI:GetCurrentRegion() == "KR" then
			realm = server
			region = "kr"
		end
	end
	
	if region then
		region = lower(region)
		if not region or region == "" then
			DEFAULT_CHAT_FRAME:AddMessage(L['AQLCOLORLABEL']..L['REALMERROR']);
			return;
		end
	end
	
	if not realm or realm == "" then
		DEFAULT_CHAT_FRAME:AddMessage(L['AQLCOLORLABEL']..L['SERVERERROR']);
		return;
	end
	
	if not supportedRegion[region] then
		DEFAULT_CHAT_FRAME:AddMessage(L['AQLCOLORLABEL'].."["..upper(region).."]"..L['NOTSUPPORTEDLIST']);
		region = nil;
		return;
	end
	
	realm = realm:gsub("'","");
	realm = realm:gsub(" ","-");
	url = "http://"..region..".battle.net/wow/"..L['LANGUAGE'].."/character/"..realm.."/"..name.."/advanced";
	
	if url then
		url = urlEscape(url);
	end
	
	return url;
end

local function ShowUrl(name,server)
	if not name then return end
	local url = constructUrl(name,server);
	if url then
		local edit_box = _G["ChatEdit_ChooseBoxForSend"]()
		_G["ChatEdit_ActivateChat"](edit_box)
		if url then
			edit_box:Insert(url);
			edit_box:HighlightText();
		end
	end
end

local function LFGShowUrl(name)
	if not name then return end
	_G["pName"] = gsub(name, "%-[^|]+", "")
	_G["pServer"] = gsub(name, "[^|]+%-", "")
	if _G["pName"] == _G["pServer"] then 
		_G["pServer"] = GetRealmName() 
	end
	local url = constructUrl(_G["pName"], _G["pServer"]);
	if url then
		local edit_box = _G["ChatEdit_ChooseBoxForSend"]()
		_G["ChatEdit_ActivateChat"](edit_box)
		if url then
			edit_box:Insert(url);
			edit_box:HighlightText();
		end
	end
end

local CURRENT_NAME, CURRENT_SERVER

hooksecurefunc("UnitPopup_ShowMenu", function(self, which)
	if which == "FRIEND" and UIDROPDOWNMENU_MENU_LEVEL == 1 then
		CURRENT_NAME, CURRENT_SERVER = self.name, self.server
	end
end)

hooksecurefunc("UnitPopup_OnClick", function(self)
	local name, server = UIDROPDOWNMENU_INIT_MENU.name, UIDROPDOWNMENU_INIT_MENU.server
	if name == CURRENT_NAME and not server then server = CURRENT_SERVER end
	if self.value == "AQL" then
		ShowUrl(name, server);
	end
end)

------------------------------------------------------------------------
--- PremadeGroup Finder 6.0.0
------------------------------------------------------------------------

local LFG_LIST_SEARCH_ENTRY_MENU = {
	{
		text = nil, --Group name goes here
		isTitle = true,
		notCheckable = true,
	},
	{
		text = WHISPER_LEADER,
		func = function(_, name) _G["ChatFrame_SendTell"](name); end,
		notCheckable = true,
		arg1 = nil, --Leader name goes here
		disabled = nil, --Disabled if we don't have a leader name yet or you haven't applied
		tooltipWhileDisabled = 1,
		tooltipOnButton = 1,
		tooltipTitle = nil, --The title to display on mouseover
		tooltipText = nil, --The text to display on mouseover
	},
	{
		text = L['ARMORYQUICKLINK'],
		func = function(_, name) LFGShowUrl(name); end,
		notCheckable = true,
		arg1 = nil, --Player name goes here
		disabled = nil, --Disabled if we don't have a name yet
	},
	{
		text = LFG_LIST_REPORT_GROUP_FOR,
		hasArrow = true,
		notCheckable = true,
		menuList = {
			{
				text = LFG_LIST_BAD_NAME,
				func = function(_, id) C_LFGList.ReportSearchResult(id, "lfglistname"); end,
				arg1 = nil, --Search result ID goes here
				notCheckable = true,
			},
			{
				text = LFG_LIST_BAD_DESCRIPTION,
				func = function(_, id) C_LFGList.ReportSearchResult(id, "lfglistcomment"); end,
				arg1 = nil, --Search reuslt ID goes here
				notCheckable = true,
				disabled = nil, --Disabled if the description is just an empty string
			},
			{
				text = LFG_LIST_BAD_VOICE_CHAT_COMMENT,
				func = function(_, id) C_LFGList.ReportSearchResult(id, "lfglistvoicechat"); end,
				arg1 = nil, --Search reuslt ID goes here
				notCheckable = true,
				disabled = nil, --Disabled if the description is just an empty string
			},
			{
				text = LFG_LIST_BAD_LEADER_NAME,
				func = function(_, id) C_LFGList.ReportSearchResult(id, "badplayername"); end,
				arg1 = nil, --Search reuslt ID goes here
				notCheckable = true,
				disabled = nil, --Disabled if we don't have a name for the leader
			},
		},
	},
	{
		text = CANCEL,
		notCheckable = true,
	},
};

function LFGListUtil_GetSearchEntryMenu(resultID)
	local id, activityID, name, comment, voiceChat, iLvl, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName = C_LFGList.GetSearchResultInfo(resultID);
	local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(resultID);
	LFG_LIST_SEARCH_ENTRY_MENU[1].text = name;
	LFG_LIST_SEARCH_ENTRY_MENU[2].arg1 = leaderName;
	LFG_LIST_SEARCH_ENTRY_MENU[2].disabled = not leaderName;
	LFG_LIST_SEARCH_ENTRY_MENU[3].arg1 = leaderName;
	LFG_LIST_SEARCH_ENTRY_MENU[3].disabled = not leaderName;
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[1].arg1 = resultID;
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[2].arg1 = resultID;
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[2].disabled = (comment == "");
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[3].arg1 = resultID;
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[3].disabled = (voiceChat == "");
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[4].arg1 = resultID;
	LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[4].disabled = not leaderName;
	return LFG_LIST_SEARCH_ENTRY_MENU;
end

local LFG_LIST_APPLICANT_MEMBER_MENU = {
	{
		text = nil, --Player name goes here
		isTitle = true,
		notCheckable = true,
	},
	{
		text = WHISPER,
		func = function(_, name) _G["ChatFrame_SendTell"](name); end,
		notCheckable = true,
		arg1 = nil, --Player name goes here
		disabled = nil, --Disabled if we don't have a name yet
	},
	{
		text = L['ARMORYQUICKLINK'],
		func = function(_, name) LFGShowUrl(name); end,
		notCheckable = true,
		arg1 = nil, --Player name goes here
		disabled = nil, --Disabled if we don't have a name yet
	},
	{
		text = LFG_LIST_REPORT_FOR,
		hasArrow = true,
		notCheckable = true,
		menuList = {
			{
				text = LFG_LIST_BAD_PLAYER_NAME,
				notCheckable = true,
				func = function(_, id, memberIdx) C_LFGList.ReportApplicant(id, "badplayername", memberIdx); end,
				arg1 = nil, --Applicant ID goes here
				arg2 = nil, --Applicant Member index goes here
			},
			{
				text = LFG_LIST_BAD_DESCRIPTION,
				notCheckable = true,
				func = function(_, id) C_LFGList.ReportApplicant(id, "lfglistappcomment"); end,
				arg1 = nil, --Applicant ID goes here
			},
		},
	},
	{
		text = IGNORE_PLAYER,
		notCheckable = true,
		func = function(_, name, applicantID) AddIgnore(name); C_LFGList.DeclineApplicant(applicantID); end,
		arg1 = nil, --Player name goes here
		arg2 = nil, --Applicant ID goes here
		disabled = nil, --Disabled if we don't have a name yet
	},
	{
		text = CANCEL,
		notCheckable = true,
	},
};

function LFGListUtil_GetApplicantMemberMenu(applicantID, memberIdx)
	local name, class, localizedClass, level, itemLevel, tank, healer, damage, assignedRole = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx);
	local id, status, pendingStatus, numMembers, isNew, comment = C_LFGList.GetApplicantInfo(applicantID);
	LFG_LIST_APPLICANT_MEMBER_MENU[1].text = name or " ";
	LFG_LIST_APPLICANT_MEMBER_MENU[2].arg1 = name;
	LFG_LIST_APPLICANT_MEMBER_MENU[2].disabled = not name or (status ~= "applied" and status ~= "invited");
	LFG_LIST_APPLICANT_MEMBER_MENU[3].arg1 = name;
	LFG_LIST_APPLICANT_MEMBER_MENU[3].disabled = not name or (status ~= "applied" and status ~= "invited");
	LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[1].arg1 = applicantID;
	LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[1].arg2 = memberIdx;
	LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[2].arg1 = applicantID;
	LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[2].disabled = (comment == "");
	LFG_LIST_APPLICANT_MEMBER_MENU[5].arg1 = name;
	LFG_LIST_APPLICANT_MEMBER_MENU[5].arg2 = applicantID;
	LFG_LIST_APPLICANT_MEMBER_MENU[5].disabled = not name;
	return LFG_LIST_APPLICANT_MEMBER_MENU;
end
