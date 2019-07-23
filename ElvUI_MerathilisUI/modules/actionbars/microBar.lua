local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("MicroBar", "AceTimer-3.0", "AceEvent-3.0")
local MERS = MER:GetModule("muiSkins")

--Cache global variables
--Lua functions
local _G = _G
local ipairs, pairs, select, tonumber, unpack = ipairs, pairs, select, tonumber, unpack
local floor = math.floor
local format = string.format
local strfind = strfind

--WoW API / Variables
local CreateFrame = CreateFrame
local GetCVar = GetCVar
local date = date
local BNGetNumFriends = BNGetNumFriends
local GetCurrentRegion = GetCurrentRegion
local GetGameTime = GetGameTime
local GetGuildRosterInfo = GetGuildRosterInfo
local GetNumGuildMembers = GetNumGuildMembers
local GetCVarBool = GetCVarBool
local GetCurrencyInfo = GetCurrencyInfo
local GetQuestObjectiveInfo = GetQuestObjectiveInfo
local InCombatLockdown = InCombatLockdown
local IsInGuild = IsInGuild
local IsQuestFlaggedCompleted = IsQuestFlaggedCompleted
local LoadAddOn = LoadAddOn
local PlaySound = PlaySound
local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local C_FriendList_GetNumFriends = C_FriendList.GetNumFriends
local C_GarrisonIsPlayerInGarrison = C_Garrison.IsPlayerInGarrison
local C_AreaPoiInfo_GetAreaPOISecondsLeft = C_AreaPoiInfo.GetAreaPOISecondsLeft
local C_Map_GetMapInfo = C_Map.GetMapInfo
local C_Calendar_GetDate = C_Calendar.GetDate
local C_Calendar_SetAbsMonth = C_Calendar.SetAbsMonth
local C_Calendar_OpenCalendar = C_Calendar.OpenCalendar
local C_Calendar_GetNumDayEvents = C_Calendar.GetNumDayEvents
local C_Calendar_GetDayEvent = C_Calendar.GetDayEvent
local C_Calendar_GetNumPendingInvites = C_Calendar.GetNumPendingInvites
local C_IslandsQueue_GetIslandsWeeklyQuestID = C_IslandsQueue.GetIslandsWeeklyQuestID
local TIMEMANAGER_TICKER_24HOUR = TIMEMANAGER_TICKER_24HOUR
local TIMEMANAGER_TICKER_12HOUR = TIMEMANAGER_TICKER_12HOUR
local GetNumSavedInstances = GetNumSavedInstances
local GetSavedInstanceInfo = GetSavedInstanceInfo
local GetNumSavedWorldBosses = GetNumSavedWorldBosses
local GetSavedWorldBossInfo = GetSavedWorldBossInfo
local RequestRaidInfo = RequestRaidInfo
local SecondsToTime = SecondsToTime
local GameTooltip = GameTooltip
local UnitLevel = UnitLevel
local InCombatLockdown = InCombatLockdown

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local microBar
local r, g, b
local mod = mod

local DELAY = 5
local elapsed = DELAY - 5

local function updateTimerFormat(color, hour, minute)
	if GetCVarBool("timeMgrUseMilitaryTime") then
		return format(color .. TIMEMANAGER_TICKER_24HOUR, hour, minute)
	else
		local timerUnit = MER.InfoColor .. (hour < 12 and "AM" or "PM")
		if hour > 12 then
			hour = hour - 12
		end
		return format(color .. TIMEMANAGER_TICKER_12HOUR .. timerUnit, hour, minute)
	end
end

function module.OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed
	if self.timer > 1 then
		local color = C_Calendar_GetNumPendingInvites() > 0 and "|cffFF0000" or ""

		local hour, minute
		if GetCVarBool("timeMgrUseLocalTime") then
			hour, minute = tonumber(date("%H")), tonumber(date("%M"))
		else
			hour, minute = GetGameTime()
		end
		self.text:SetText(updateTimerFormat(color, hour, minute))

		self.timer = 0
	end
end

-- Data
local bonus = {
	52834,
	52838, -- Gold
	52835,
	52839, -- Honor
	52837,
	52840 -- Resources
}
local bonusName = GetCurrencyInfo(1580)

local isTimeWalker, walkerTexture
local function checkTimeWalker(event)
	local date = C_Calendar_GetDate()
	C_Calendar_SetAbsMonth(date.month, date.year)
	C_Calendar_OpenCalendar()

	local today = date.monthDay
	local numEvents = C_Calendar_GetNumDayEvents(0, today)
	if numEvents <= 0 then
		return
	end

	for i = 1, numEvents do
		local info = C_Calendar_GetDayEvent(0, today, i)
		if info and strfind(info.title, PLAYER_DIFFICULTY_TIMEWALKER) and info.sequenceType ~= "END" then
			isTimeWalker = true
			walkerTexture = info.iconTexture
			break
		end
	end
	module:UnregisterEvent(event, checkTimeWalker)
end
module:RegisterEvent("PLAYER_ENTERING_WORLD", checkTimeWalker)

local function checkTexture(texture)
	if not walkerTexture then
		return
	end
	if walkerTexture == texture or walkerTexture == texture - 1 then
		return true
	end
end

local questlist = {
	{name = L["Blingtron"], id = 34774},
	{name = L["Mean One"], id = 6983},
	{name = L["Timewarped"], id = 40168, texture = 1129674}, -- TBC
	{name = L["Timewarped"], id = 40173, texture = 1129686}, -- WotLK
	{name = L["Timewarped"], id = 40786, texture = 1304688}, -- Cata
	{name = L["Timewarped"], id = 45799, texture = 1530590} -- MoP
}

-- Invasion Code --
local region = GetCVar("portal")
if not region or #region ~= 2 then
	local regionID = GetCurrentRegion()
	region = regionID and ({"US", "KR", "EU", "TW", "CN"})[regionID]
end

-- Check Invasion Status
local invIndex = {
	[1] = {
		title = L["Faction Assault"],
		duration = 68400,
		maps = {862, 863, 864, 896, 942, 895},
		timeTable = {4, 1, 6, 2, 5, 3},
		baseTime = {
			US = 1548032400, -- 01/20/2019 17:00 UTC-8
			EU = 1548000000, -- 01/20/2019 16:00 UTC+0
			CN = 1546743600 -- 01/06/2019 11:00 UTC+8
		}
	}
}

local mapAreaPoiIDs = {
	[630] = 5175,
	[641] = 5210,
	[650] = 5177,
	[634] = 5178,
	[862] = 5973,
	[863] = 5969,
	[864] = 5970,
	[896] = 5964,
	[942] = 5966,
	[895] = 5896
}

local function GetInvasionTimeInfo(mapID)
	local areaPoiID = mapAreaPoiIDs[mapID]
	local seconds = C_AreaPoiInfo_GetAreaPOISecondsLeft(areaPoiID)
	local mapInfo = C_Map_GetMapInfo(mapID)
	return seconds, mapInfo.name
end

local function CheckInvasion(index)
	for _, mapID in pairs(invIndex[index].maps) do
		local timeLeft, name = GetInvasionTimeInfo(mapID)
		if timeLeft and timeLeft > 0 then
			return timeLeft, name
		end
	end
end

local function GetNextTime(baseTime, index)
	local inv = invIndex[index]
	local currentTime = time()
	local baseTime = inv.baseTime[region]
	local duration = invIndex[index].duration
	local elapsed = mod(currentTime - baseTime, duration)
	return duration - elapsed + currentTime
end

local function GetNextLocation(nextTime, index)
	local inv = invIndex[index]
	local count = #inv.timeTable
	local baseTime = inv.baseTime[region]
	local elapsed = nextTime - baseTime
	local round = mod(floor(elapsed / inv.duration) + 1, count)

	if round == 0 then
		round = count
	end

	return C_Map_GetMapInfo(inv.maps[inv.timeTable[round]]).name
end

local title
local function addTitle(text)
	if not title then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(text .. ":", 1, .8, .1)
		title = true
	end
end

function module.OnEnter(self)
	if E.db.mui.microBar.tooltip ~= true then
		return
	end
	RequestRaidInfo()

	if not GameTooltip:IsForbidden() then
		GameTooltip:Hide() -- WHY??? BECAUSE FUCK GAMETOOLTIP, THATS WHY!!
	end

	if InCombatLockdown() then
		return
	end

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("BOTTOM", timeButton, "TOP")
	GameTooltip:ClearLines()

	local today = C_Calendar_GetDate()
	local w, m, d, y = today.weekday, today.month, today.monthDay, today.year
	GameTooltip:AddLine(
		format(FULLDATE, CALENDAR_WEEKDAY_NAMES[w], CALENDAR_FULLDATE_MONTH_NAMES[m], d, y),
		unpack(E.media.rgbvaluecolor)
	)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(L["Local Time"], GameTime_GetLocalTime(true), 1, .8, .1, 1, 1, 1)
	GameTooltip:AddDoubleLine(L["Realm Time"], GameTime_GetGameTime(true), 1, .8, .1, 1, 1, 1)

	-- World bosses
	title = false
	for i = 1, GetNumSavedWorldBosses() do
		local name, id, reset = GetSavedWorldBossInfo(i)
		if not (id == 11 or id == 12 or id == 13) then
			addTitle(RAID_INFO_WORLD_BOSS)
			GameTooltip:AddDoubleLine(name, SecondsToTime(reset, true, nil, 3), 1, 1, 1, 1, 1, 1)
		end
	end

	-- Mythic Dungeons
	title = false
	for i = 1, GetNumSavedInstances() do
		local name, _, reset, diff, locked, extended = GetSavedInstanceInfo(i)
		if diff == 23 and (locked or extended) then
			addTitle(L["Mythic Dungeon"])
			if extended then
				r, g, b = .3, 1, .3
			else
				r, g, b = 1, 1, 1
			end
			GameTooltip:AddDoubleLine(name, SecondsToTime(reset, true, nil, 3), 1, 1, 1, r, g, b)
		end
	end

	-- Raids
	title = false
	for i = 1, GetNumSavedInstances() do
		local name, _, reset, _, locked, extended, _, isRaid, _, diffName = GetSavedInstanceInfo(i)
		if isRaid and (locked or extended) then
			addTitle(RAID_INFORMATION)
			if extended then
				r, g, b = .3, 1, .3
			else
				r, g, b = 1, 1, 1
			end
			GameTooltip:AddDoubleLine(name .. " - " .. diffName, SecondsToTime(reset, true, nil, 3), 1, 1, 1, r, g, b)
		end
	end

	-- Quests
	title = false
	local count, maxCoins = 0, 2
	for _, id in pairs(bonus) do
		if IsQuestFlaggedCompleted(id) then
			count = count + 1
		end
	end
	if count > 0 then
		addTitle(QUESTS_LABEL)
		if count == maxCoins then
			r, g, b = 1, 0, 0
		else
			r, g, b = 0, 1, 0
		end
		GameTooltip:AddDoubleLine(bonusName, count .. "/" .. maxCoins, 1, 1, 1, r, g, b)
	end

	local iwqID = C_IslandsQueue_GetIslandsWeeklyQuestID()
	if iwqID and UnitLevel("player") == 120 then
		addTitle(QUESTS_LABEL)
		if IsQuestFlaggedCompleted(iwqID) then
			GameTooltip:AddDoubleLine(ISLANDS_HEADER, QUEST_COMPLETE, 1, 1, 1, 1, 0, 0)
		else
			local cur, max = select(4, GetQuestObjectiveInfo(iwqID, 1, false))
			local stautsText = cur .. "/" .. max
			if not cur or not max then
				stautsText = LFG_LIST_LOADING
			end
			GameTooltip:AddDoubleLine(ISLANDS_HEADER, stautsText, 1, 1, 1, 0, 1, 0)
		end
	end

	for _, v in pairs(questlist) do
		if v.name and IsQuestFlaggedCompleted(v.id) then
			if v.name == L["Timewarped"] and isTimeWalker and checkTexture(v.texture) or v.name ~= L["Timewarped"] then
				addTitle(QUESTS_LABEL)
				GameTooltip:AddDoubleLine(v.name, QUEST_COMPLETE, 1, 1, 1, 1, 0, 0)
			end
		end
	end

	-- Invasions
	for index, value in ipairs(invIndex) do
		title = false
		addTitle(value.title)
		if value.baseTime[region] and value.baseTime[region] ~= "" then
			local timeLeft, zoneName = CheckInvasion(index)
			local nextTime = GetNextTime(value.baseTime, index)
			if timeLeft then
				timeLeft = timeLeft / 60
				if timeLeft < 60 then
					r, g, b = 1, 0, 0
				else
					r, g, b = 0, 1, 0
				end
				GameTooltip:AddDoubleLine(
					L["Current Invasion: "] .. zoneName,
					format("%.2d:%.2d", timeLeft / 60, timeLeft % 60),
					1,
					1,
					1,
					r,
					g,
					b
				)
			end
			GameTooltip:AddDoubleLine(
				L["Next Invasion: "] .. GetNextLocation(nextTime, index),
				date("%d/%m %H:%M", nextTime),
				1,
				1,
				1,
				1,
				1,
				1
			)
		else
			GameTooltip:AddDoubleLine(L["Missing invasion info on your realm."])
		end
	end
	GameTooltip:Show()
end

local function OnHover(button)
	local buttonHighlight = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\highlight2"

	if button.tex then
		button.tex:SetVertexColor(unpack(E["media"].rgbvaluecolor))

		button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
		button.highlight:SetPoint("TOPLEFT", button.tex, "TOPLEFT", -4, 1)
		button.highlight:SetPoint("BOTTOMRIGHT", button.tex, "BOTTOMRIGHT", 4, -1)
		button.highlight:SetVertexColor(unpack(E["media"].rgbvaluecolor))
		button.highlight:SetTexture(buttonHighlight)
		button.highlight:SetBlendMode("ADD")
	end
end

local function OnLeave(button)
	if button.tex then
		button.tex:SetVertexColor(.6, .6, .6)
		button.highlight:Hide()
	end
	GameTooltip:Hide()
end

function module:OnClick(btn)
	if InCombatLockdown() then
		return
	end
	if btn == "LeftButton" then
		if (not CalendarFrame) then
			LoadAddOn("Blizzard_Calendar")
		end
		Calendar_Toggle()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end
end

function module:CreateMicroBar()
	microBar = CreateFrame("Frame", MER.Title .. "MicroBar", E.UIParent)
	microBar:SetFrameStrata("MEDIUM")
	microBar:EnableMouse(true)
	microBar:SetSize(400, 26)
	microBar:SetScale(module.db.scale or 1)
	microBar:Point("TOP", E.UIParent, "TOP", 0, -19)
	microBar:SetTemplate("Transparent")
	microBar:Styling()
	E.FrameLocks[microBar] = true

	local IconPath = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\icons\\"

	--Character
	local charButton = CreateFrame("Button", nil, microBar)
	charButton:SetPoint("LEFT", microBar, 2, 0)
	charButton:SetSize(32, 32)
	charButton:SetFrameLevel(6)

	charButton.tex = charButton:CreateTexture(nil, "OVERLAY")
	charButton.tex:SetPoint("BOTTOMLEFT")
	charButton.tex:SetPoint("BOTTOMRIGHT")
	charButton.tex:SetSize(32, 32)
	charButton.tex:SetTexture(IconPath .. "Character")
	charButton.tex:SetVertexColor(.6, .6, .6)
	charButton.tex:SetBlendMode("ADD")

	charButton.text = MER:CreateText(charButton, "HIGHLIGHT", 11)
	if module.db.text.position == "BOTTOM" then
		charButton.text:SetPoint("BOTTOM", charButton, 2, -15)
	else
		charButton.text:SetPoint("TOP", charButton, 2, 15)
	end
	charButton.text:SetText(CHARACTER_BUTTON)
	charButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	charButton:SetScript(
		"OnEnter",
		function(self)
			OnHover(self)
		end
	)
	charButton:SetScript(
		"OnLeave",
		function(self)
			OnLeave(self)
		end
	)
	charButton:SetScript(
		"OnClick",
		function(self)
			if InCombatLockdown() then
				return
			end
			_G["ToggleCharacter"]("PaperDollFrame")
		end
	)

	--Friends
	local friendsButton = CreateFrame("Button", nil, microBar)
	friendsButton:SetPoint("LEFT", charButton, "RIGHT", 2, 0)
	friendsButton:SetSize(32, 32)
	friendsButton:SetFrameLevel(6)

	friendsButton.tex = friendsButton:CreateTexture(nil, "OVERLAY")
	friendsButton.tex:SetPoint("BOTTOMLEFT")
	friendsButton.tex:SetPoint("BOTTOMRIGHT")
	friendsButton.tex:SetSize(32, 32)
	friendsButton.tex:SetTexture(IconPath .. "Friends")
	friendsButton.tex:SetVertexColor(.6, .6, .6)
	friendsButton.tex:SetBlendMode("ADD")

	friendsButton.text = MER:CreateText(friendsButton, "HIGHLIGHT", 11)
	if module.db.text.position == "BOTTOM" then
		friendsButton.text:SetPoint("BOTTOM", friendsButton, 2, -15)
	else
		friendsButton.text:SetPoint("TOP", friendsButton, 2, 15)
	end
	friendsButton.text:SetText(SOCIAL_BUTTON)
	friendsButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	local function UpdateFriends()
		module.db = E.db.mui.microBar
		local friendsOnline = C_FriendList_GetNumFriends()
		local bnTotal, bnOnline = BNGetNumFriends()
		local totalOnline = friendsOnline + bnOnline

		if module.db.text.friends then
			if (bnOnline > 0) or (friendsOnline > 0) then
				if bnOnline > 0 then
					friendsButton.online:SetText(totalOnline)
				else
					friendsButton.online:SetText("0")
				end
			end
		end
	end

	friendsButton.online = friendsButton:CreateFontString(nil, "OVERLAY")
	friendsButton.online:FontTemplate(nil, 10, "OUTLINE")
	friendsButton.online:SetPoint("BOTTOMRIGHT", friendsButton, 0, 5)
	friendsButton.online:SetText("")
	friendsButton.online:SetTextColor(unpack(E["media"].rgbvaluecolor))

	friendsButton:SetScript(
		"OnEnter",
		function(self)
			OnHover(self)
		end
	)
	friendsButton:SetScript(
		"OnLeave",
		function(self)
			OnLeave(self)
		end
	)
	friendsButton:SetScript(
		"OnClick",
		function(self)
			if InCombatLockdown() then
				return
			end
			_G["ToggleFriendsFrame"]()
		end
	)
	friendsButton:SetScript(
		"OnUpdate",
		function(self, elapse)
			elapsed = elapsed + elapse

			if elapsed >= DELAY then
				elapsed = 0
				UpdateFriends()
			end
		end
	)

	--Guild
	local guildButton = CreateFrame("Button", nil, microBar)
	guildButton:SetPoint("LEFT", friendsButton, "RIGHT", 2, 0)
	guildButton:SetSize(32, 32)
	guildButton:SetFrameLevel(6)

	guildButton.tex = guildButton:CreateTexture(nil, "OVERLAY")
	guildButton.tex:SetPoint("BOTTOMLEFT")
	guildButton.tex:SetPoint("BOTTOMRIGHT")
	guildButton.tex:SetSize(32, 32)
	guildButton.tex:SetTexture(IconPath .. "Guild")
	guildButton.tex:SetVertexColor(.6, .6, .6)
	guildButton.tex:SetBlendMode("ADD")

	guildButton.text = MER:CreateText(guildButton, "HIGHLIGHT", 11)
	if module.db.text.position == "BOTTOM" then
		guildButton.text:SetPoint("BOTTOM", guildButton, 2, -15)
	else
		guildButton.text:SetPoint("TOP", guildButton, 2, 15)
	end
	guildButton.text:SetText(GUILD)
	guildButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	local function UpdateGuild()
		module.db = E.db.mui.microBar
		if IsInGuild() then
			local guildTotal, online = GetNumGuildMembers()
			for i = 1, guildTotal do
				local _, _, _, _, _, _, _, _, connected, _, _, _, _, isMobile = GetGuildRosterInfo(i)
				if isMobile then
					online = online + 1
				end
			end

			if module.db.text.guild then
				if online > 0 then
					guildButton.online:SetText(online)
				else
					guildButton.online:SetText("0")
				end
			end
		end
	end

	guildButton.online = guildButton:CreateFontString(nil, "OVERLAY")
	guildButton.online:FontTemplate(nil, 10, "OUTLINE")
	guildButton.online:SetPoint("BOTTOMRIGHT", guildButton, 0, 5)
	guildButton.online:SetText("")
	guildButton.online:SetTextColor(unpack(E["media"].rgbvaluecolor))

	guildButton:SetScript(
		"OnEnter",
		function(self)
			OnHover(self)
		end
	)
	guildButton:SetScript(
		"OnLeave",
		function(self)
			OnLeave(self)
		end
	)
	guildButton:SetScript(
		"OnClick",
		function(self)
			if InCombatLockdown() then
				return
			end
			_G["ToggleGuildFrame"]()
		end
	)
	guildButton:SetScript(
		"OnUpdate",
		function(self, elapse)
			elapsed = elapsed + elapse

			if elapsed >= DELAY then
				elapsed = 0
				UpdateGuild()
			end
		end
	)

	--Achievements
	local achieveButton = CreateFrame("Button", nil, microBar)
	achieveButton:SetPoint("LEFT", guildButton, "RIGHT", 2, 0)
	achieveButton:SetSize(32, 32)
	achieveButton:SetFrameLevel(6)

	achieveButton.tex = achieveButton:CreateTexture(nil, "OVERLAY")
	achieveButton.tex:SetPoint("BOTTOMLEFT")
	achieveButton.tex:SetPoint("BOTTOMRIGHT")
	achieveButton.tex:SetSize(32, 32)
	achieveButton.tex:SetTexture(IconPath .. "Achievement")
	achieveButton.tex:SetVertexColor(.6, .6, .6)
	achieveButton.tex:SetBlendMode("ADD")

	achieveButton.text = MER:CreateText(achieveButton, "HIGHLIGHT", 11)
	if module.db.text.position == "BOTTOM" then
		achieveButton.text:SetPoint("BOTTOM", achieveButton, 2, -15)
	else
		achieveButton.text:SetPoint("TOP", achieveButton, 2, 15)
	end
	achieveButton.text:SetText(ACHIEVEMENT_BUTTON)
	achieveButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	achieveButton:SetScript(
		"OnEnter",
		function(self)
			OnHover(self)
		end
	)
	achieveButton:SetScript(
		"OnLeave",
		function(self)
			OnLeave(self)
		end
	)
	achieveButton:SetScript(
		"OnClick",
		function(self)
			if InCombatLockdown() then
				return
			end
			_G["ToggleAchievementFrame"]()
		end
	)

	--EncounterJournal
	local encounterButton = CreateFrame("Button", nil, microBar)
	encounterButton:SetPoint("LEFT", achieveButton, "RIGHT", 2, 0)
	encounterButton:SetSize(32, 32)
	encounterButton:SetFrameLevel(6)

	encounterButton.tex = encounterButton:CreateTexture(nil, "OVERLAY")
	encounterButton.tex:SetPoint("BOTTOMLEFT")
	encounterButton.tex:SetPoint("BOTTOMRIGHT")
	encounterButton.tex:SetSize(32, 32)
	encounterButton.tex:SetTexture(IconPath .. "EJ")
	encounterButton.tex:SetVertexColor(.6, .6, .6)
	encounterButton.tex:SetBlendMode("ADD")

	encounterButton.text = MER:CreateText(encounterButton, "HIGHLIGHT", 11)
	if module.db.text.position == "BOTTOM" then
		encounterButton.text:SetPoint("BOTTOM", encounterButton, 2, -15)
	else
		encounterButton.text:SetPoint("TOP", encounterButton, 2, 15)
	end
	encounterButton.text:SetText(ENCOUNTER_JOURNAL)
	encounterButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	encounterButton:SetScript(
		"OnEnter",
		function(self)
			OnHover(self)
		end
	)
	encounterButton:SetScript(
		"OnLeave",
		function(self)
			OnLeave(self)
		end
	)
	encounterButton:SetScript(
		"OnClick",
		function(self)
			if InCombatLockdown() then
				return
			end
			_G["ToggleEncounterJournal"]()
		end
	)

	-- Time
	local timeButton = CreateFrame("Button", nil, microBar)
	timeButton:SetPoint("LEFT", encounterButton, "RIGHT", 18, 0)
	timeButton:SetSize(32, 32)
	timeButton:SetFrameLevel(6)

	timeButton.text = MER:CreateText(timeButton, "OVERLAY", 16)
	timeButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))
	timeButton.text:SetPoint("CENTER", 0, 0)

	timeButton.tex = timeButton:CreateTexture(nil, "OVERLAY") --dummy texture
	timeButton.tex:SetPoint("BOTTOMLEFT")
	timeButton.tex:SetPoint("BOTTOMRIGHT")
	timeButton.tex:SetSize(32, 32)
	timeButton.tex:SetBlendMode("ADD")

	local timer = timeButton:CreateAnimationGroup()

	local timerAnim = timer:CreateAnimation()
	timerAnim:SetDuration(1)

	timer:SetScript(
		"OnFinished",
		function(self, requested)
			local euTime = date("%H|cFF00c0fa:|r%M")
			local ukTime = date("%I|cFF00c0fa:|r%M")

			if E.db.datatexts.time24 == true then
				timeButton.text:SetText(euTime)
			else
				timeButton.text:SetText(ukTime)
			end
			self:Play()
		end
	)
	timer:Play()

	timeButton:SetScript(
		"OnEnter",
		function(self)
			OnHover(self)
			module.OnEnter(self)
		end
	)
	timeButton:SetScript(
		"OnLeave",
		function(self)
			OnLeave(self)
		end
	)
	timeButton:SetScript("OnMouseUp", module.OnClick)

	--Pet/Mounts
	local petButton = CreateFrame("Button", nil, microBar)
	petButton:SetPoint("LEFT", timeButton, "RIGHT", 12, 0)
	petButton:SetSize(32, 32)
	petButton:SetFrameLevel(6)

	petButton.tex = petButton:CreateTexture(nil, "OVERLAY")
	petButton.tex:SetPoint("BOTTOMLEFT")
	petButton.tex:SetPoint("BOTTOMRIGHT")
	petButton.tex:SetSize(32, 32)
	petButton.tex:SetTexture(IconPath .. "Pet")
	petButton.tex:SetVertexColor(.6, .6, .6)
	petButton.tex:SetBlendMode("ADD")

	petButton.text = MER:CreateText(petButton, "HIGHLIGHT", 11)
	if module.db.text.position == "BOTTOM" then
		petButton.text:SetPoint("BOTTOM", petButton, 2, -15)
	else
		petButton.text:SetPoint("TOP", petButton, 2, 15)
	end
	petButton.text:SetText(MOUNTS_AND_PETS)
	petButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	petButton:SetScript(
		"OnEnter",
		function(self)
			OnHover(self)
		end
	)
	petButton:SetScript(
		"OnLeave",
		function(self)
			OnLeave(self)
		end
	)
	petButton:SetScript(
		"OnClick",
		function(self)
			if InCombatLockdown() then
				return
			end
			_G["ToggleCollectionsJournal"](1)
		end
	)

	--LFR
	local lfrButton = CreateFrame("Button", nil, microBar)
	lfrButton:SetPoint("LEFT", petButton, "RIGHT", 2, 0)
	lfrButton:SetSize(32, 32)
	lfrButton:SetFrameLevel(6)

	lfrButton.tex = lfrButton:CreateTexture(nil, "OVERLAY")
	lfrButton.tex:SetPoint("BOTTOMLEFT")
	lfrButton.tex:SetPoint("BOTTOMRIGHT")
	lfrButton.tex:SetSize(32, 32)
	lfrButton.tex:SetTexture(IconPath .. "LFR")
	lfrButton.tex:SetVertexColor(.6, .6, .6)
	lfrButton.tex:SetBlendMode("ADD")

	lfrButton.text = MER:CreateText(lfrButton, "HIGHLIGHT", 11)
	if module.db.text.position == "BOTTOM" then
		lfrButton.text:SetPoint("BOTTOM", lfrButton, 2, -15)
	else
		lfrButton.text:SetPoint("TOP", lfrButton, 2, 15)
	end
	lfrButton.text:SetText(LFG_TITLE)
	lfrButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	lfrButton:SetScript(
		"OnEnter",
		function(self)
			OnHover(self)
		end
	)
	lfrButton:SetScript(
		"OnLeave",
		function(self)
			OnLeave(self)
		end
	)
	lfrButton:SetScript(
		"OnClick",
		function(self)
			if InCombatLockdown() then
				return
			end
			_G["PVEFrame_ToggleFrame"]()
		end
	)

	--Spellbook
	local spellBookButton = CreateFrame("Button", nil, microBar)
	spellBookButton:SetPoint("LEFT", lfrButton, "RIGHT", 2, 0)
	spellBookButton:SetSize(32, 32)
	spellBookButton:SetFrameLevel(6)

	spellBookButton.tex = spellBookButton:CreateTexture(nil, "OVERLAY")
	spellBookButton.tex:SetPoint("BOTTOMLEFT")
	spellBookButton.tex:SetPoint("BOTTOMRIGHT")
	spellBookButton.tex:SetSize(32, 32)
	spellBookButton.tex:SetTexture(IconPath .. "Spellbook")
	spellBookButton.tex:SetVertexColor(.6, .6, .6)
	spellBookButton.tex:SetBlendMode("ADD")

	spellBookButton.text = MER:CreateText(spellBookButton, "HIGHLIGHT", 11)
	if module.db.text.position == "BOTTOM" then
		spellBookButton.text:SetPoint("BOTTOM", spellBookButton, 2, -15)
	else
		spellBookButton.text:SetPoint("TOP", spellBookButton, 2, 15)
	end
	spellBookButton.text:SetText(SPELLBOOK_ABILITIES_BUTTON)
	spellBookButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	spellBookButton:SetScript(
		"OnEnter",
		function(self)
			OnHover(self)
		end
	)
	spellBookButton:SetScript(
		"OnLeave",
		function(self)
			OnLeave(self)
		end
	)
	spellBookButton:SetScript(
		"OnClick",
		function(self)
			if InCombatLockdown() then
				return
			end
			_G["ToggleSpellBook"](BOOKTYPE_SPELL)
		end
	)

	--Specc Button
	local speccButton = CreateFrame("Button", nil, microBar)
	speccButton:SetPoint("LEFT", spellBookButton, "RIGHT", 2, 0)
	speccButton:SetSize(32, 32)
	speccButton:SetFrameLevel(6)

	speccButton.tex = speccButton:CreateTexture(nil, "OVERLAY")
	speccButton.tex:SetPoint("BOTTOMLEFT")
	speccButton.tex:SetPoint("BOTTOMRIGHT")
	speccButton.tex:SetSize(32, 32)
	speccButton.tex:SetTexture(IconPath .. "Specc")
	speccButton.tex:SetVertexColor(.6, .6, .6)
	speccButton.tex:SetBlendMode("ADD")

	speccButton.text = MER:CreateText(speccButton, "HIGHLIGHT", 11)
	if module.db.text.position == "BOTTOM" then
		speccButton.text:SetPoint("BOTTOM", speccButton, 2, -15)
	else
		speccButton.text:SetPoint("TOP", speccButton, 2, 15)
	end
	speccButton.text:SetText(TALENTS_BUTTON)
	speccButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	speccButton:SetScript(
		"OnEnter",
		function(self)
			OnHover(self)
		end
	)
	speccButton:SetScript(
		"OnLeave",
		function(self)
			OnLeave(self)
		end
	)
	speccButton:SetScript(
		"OnClick",
		function(self)
			if InCombatLockdown() then
				return
			end
			_G["ToggleTalentFrame"]()
		end
	)

	--Shop
	local shopButton = CreateFrame("Button", nil, microBar)
	shopButton:SetPoint("LEFT", speccButton, "RIGHT", 2, 0)
	shopButton:SetSize(32, 32)
	shopButton:SetFrameLevel(6)

	shopButton.tex = shopButton:CreateTexture(nil, "OVERLAY")
	shopButton.tex:SetPoint("BOTTOMLEFT")
	shopButton.tex:SetPoint("BOTTOMRIGHT")
	shopButton.tex:SetSize(32, 32)
	shopButton.tex:SetTexture(IconPath .. "Store")
	shopButton.tex:SetVertexColor(.6, .6, .6)
	shopButton.tex:SetBlendMode("ADD")

	shopButton.text = MER:CreateText(shopButton, "HIGHLIGHT", 11)
	if module.db.text.position == "BOTTOM" then
		shopButton.text:SetPoint("BOTTOM", shopButton, 2, -15)
	else
		shopButton.text:SetPoint("TOP", shopButton, 2, 15)
	end
	shopButton.text:SetText(BLIZZARD_STORE)
	shopButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))

	shopButton:SetScript(
		"OnEnter",
		function(self)
			OnHover(self)
		end
	)
	shopButton:SetScript(
		"OnLeave",
		function(self)
			OnLeave(self)
		end
	)
	shopButton:SetScript(
		"OnClick",
		function(self)
			if InCombatLockdown() then
				return
			end
			StoreMicroButton:Click()
		end
	)

	E:CreateMover(
		microBar,
		"MER_MicroBarMover",
		L["MicroBarMover"],
		nil,
		nil,
		nil,
		"ALL,ACTIONBARS,MERATHILISUI",
		nil,
		"mui,modules,actionbars"
	)
end

function module:Toggle()
	if module.db.enable then
		microBar:Show()
		E:EnableMover(microBar.mover:GetName())
	else
		microBar:Hide()
		E:DisableMover(microBar.mover:GetName())
	end
	module:UNIT_AURA(nil, "player")
end

function module:PLAYER_REGEN_DISABLED()
	if module.db.hideInCombat == true then
		microBar:SetAlpha(0)
	end
end

function module:PLAYER_REGEN_ENABLED()
	if module.db.enable then
		microBar:SetAlpha(1)
	end
end

function module:UNIT_AURA(_, unit)
	if unit ~= "player" then
		return
	end
	if module.db.enable and module.db.hideInOrderHall then
		local inOrderHall = C_GarrisonIsPlayerInGarrison(LE_GARRISON_TYPE_7_0)
		if inOrderHall then
			microBar:SetAlpha(0)
		else
			microBar:SetAlpha(1)
		end
	end
end

function module:Initialize()
	local db = E.db.mui.microBar
	MER:RegisterDB(self, "microBar")

	if db.enable ~= true then
		return
	end

	self:CreateMicroBar()
	self:Toggle()

	function module:ForUpdateAll()
		module.db = E.db.mui.microBar

		self:Toggle()
	end

	self:ForUpdateAll()

	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("UNIT_AURA")
end

MER:RegisterModule(module:GetName())
