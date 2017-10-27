local MER, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

--Cache global variables
local _G = _G
local type = type
local format = string.format
local join = string.join
local floor = math.floor
local twipe = table.wipe
local date = date
--WoW API / Variables
local CalendarGetDate = CalendarGetDate
local GetGameTime = GetGameTime
local GetDifficultyInfo = GetDifficultyInfo
local GetQuestsCompleted = GetQuestsCompleted
local GetNumSavedInstances = GetNumSavedInstances
local GetNumWorldPVPAreas = GetNumWorldPVPAreas
local GetNumSavedWorldBosses = GetNumSavedWorldBosses
local GetSavedInstanceInfo = GetSavedInstanceInfo
local GetSavedWorldBossInfo = GetSavedWorldBossInfo
local GetWorldPVPAreaInfo = GetWorldPVPAreaInfo
local RequestRaidInfo = RequestRaidInfo
local SecondsToTime = SecondsToTime
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: VOICE_CHAT_BATTLEGROUND, WINTERGRASP_IN_PROGRESS, QUEUE_TIME_UNAVAILABLE, difficultyId, instanceID
-- GLOBALS: ChatFrame_TimeBreakDown, RAID_INFO_WORLD_BOSS, TIMEMANAGER_TOOLTIP_REALMTIME, TIMEMANAGER_TOOLTIP_LOCALTIME

local _
local APM = { TIMEMANAGER_PM, TIMEMANAGER_AM }
local europeDisplayFormat = '';
local ukDisplayFormat = '';
local europeDisplayFormat_nocolor = join("", "%02d", ":|r%02d")
local ukDisplayFormat_nocolor = join("", "", "%d", ":|r%02d", " %s|r")
local timerLongFormat = "%d:%02d:%02d"
local timerShortFormat = "%d:%02d"
local lockoutInfoFormat = "%s%s |cffaaaaaa(%s, %s/%s)"
local lockoutInfoFormatNoEnc = "%s%s |cffaaaaaa(%s)"
local formatBattleGroundInfo = "%s: "
local lockoutColorExtended, lockoutColorNormal = { r = 0.3, g = 1, b = 0.3 }, { r = .8, g = .8, b = .8 }
local lockoutFormatString = { "%dd %02dh %02dm", "%dd %dh %02dm", "%02dh %02dm", "%dh %02dm", "%dh %02dm", "%dm" }
local curHr, curMin, curAmPm
local enteredFrame = false;

local Update, lastPanel; -- UpValue
local localizedName, isActive, canQueue, startTime, canEnter
local name, reset, locked, extended, isRaid, maxPlayers, difficulty, numEncounters, encounterProgress
local quests = {}
local updateQuestTable = false

local function ValueColorUpdate(hex)
	europeDisplayFormat = join("", "%02d", hex, ":|r%02d")
	ukDisplayFormat = join("", "", "%d", hex, ":|r%02d", hex, " %s|r")

	if lastPanel ~= nil then
		Update(lastPanel, 20000)
	end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

local function ConvertTime(h, m)
	local AmPm
	if E.db.datatexts.time24 == true then
		return h, m, -1
	else
		if h >= 12 then
			if h > 12 then h = h - 12 end
			AmPm = 1
		else
			if h == 0 then h = 12 end
			AmPm = 2
		end
	end
	return h, m, AmPm
end

local function CalculateTimeValues(tooltip)
	if (tooltip and E.db.datatexts.localtime) or (not tooltip and not E.db.datatexts.localtime) then
		return ConvertTime(GetGameTime())
	else
		local dateTable = date("*t")
		return ConvertTime(dateTable["hour"], dateTable["min"])
	end
end

local function CalculateTimeLeft(time)
	local hour = floor(time / 3600)
	local min = floor(time / 60 - (hour*60))
	local sec = time - (hour * 3600) - (min * 60)

	return hour, min, sec
end

local function formatResetTime(sec)
	local d, h, m, s = ChatFrame_TimeBreakDown(floor(sec))
	if not type(d) == "number" or not type(h)== "number" or not type(m) == "number" or not type(s) == "number" then
		return "N/A"
	end

	if d > 0 and lockoutFormatString[h>10 and 1 or 2] then 
		return format(lockoutFormatString[h>10 and 1 or 2], d, h, m)
	end
	if h > 0 and lockoutFormatString[h>10 and 3 or 4] then
		return format(lockoutFormatString[h>10 and 3 or 4], h, m)
	end
	if m > 0 and lockoutFormatString[m>10 and 5 or 6] then 
		return format(lockoutFormatString[m>10 and 5 or 6], m) 
	end
end

local function OnEvent(self, event)
	if event == "QUEST_COMPLETE" then
		updateQuestTable = true
	elseif (event == "QUEST_LOG_UPDATE" and updateQuestTable) or event == "ELVUI_FORCE_RUN" then
		twipe(quests)
		quests = GetQuestsCompleted()
		updateQuestTable = false
	end
end

local function Click()
	_G["GameTimeFrame"]:Click();
end

local function OnLeave(self)
	DT.tooltip:Hide();
	enteredFrame = false;
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	if(not enteredFrame) then
		enteredFrame = true;
		RequestRaidInfo()
	end

	DT.tooltip:AddLine(VOICE_CHAT_BATTLEGROUND);
	for i = 1, GetNumWorldPVPAreas() do
		_, localizedName, isActive, canQueue, startTime, canEnter = GetWorldPVPAreaInfo(i)
		if canEnter then
			if isActive then
				startTime = WINTERGRASP_IN_PROGRESS
			elseif startTime == nil then
				startTime = QUEUE_TIME_UNAVAILABLE
			else
				startTime = SecondsToTime(startTime, false, nil, 3)
			end
			DT.tooltip:AddDoubleLine(format(formatBattleGroundInfo, localizedName), startTime, 1, 1, 1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b)
		end
	end

	local oneraid, lockoutColor
	for i = 1, GetNumSavedInstances() do
		name, _, reset, difficultyId, locked, extended, _, isRaid, maxPlayers, difficulty, numEncounters, encounterProgress  = GetSavedInstanceInfo(i)
		if isRaid and (locked or extended) and name then
			if not oneraid then
				DT.tooltip:AddLine(" ")
				DT.tooltip:AddLine(L["Saved Raid(s)"])
				oneraid = true
			end
			if extended then 
				lockoutColor = lockoutColorExtended 
			else
				lockoutColor = lockoutColorNormal 
			end

			local _, _, isHeroic, _, displayHeroic, displayMythic = GetDifficultyInfo(difficultyId)
			if (numEncounters and numEncounters > 0) and (encounterProgress and encounterProgress > 0) then
				DT.tooltip:AddDoubleLine(format(lockoutInfoFormat, maxPlayers, (displayMythic and "M" or (isHeroic or displayHeroic) and "H" or "N"), name, encounterProgress, numEncounters), SecondsToTime(reset, false, nil, 3), 1, 1, 1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
			else
				DT.tooltip:AddDoubleLine(format(lockoutInfoFormatNoEnc, maxPlayers, (displayMythic and "M" or (isHeroic or displayHeroic) and "H" or "N"), name), SecondsToTime(reset, false, nil, 3), 1, 1, 1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
			end
		end
	end

	local addedLine = false
	for i = 1, GetNumSavedWorldBosses() do
		name, instanceID, reset = GetSavedWorldBossInfo(i)
		if(reset) then
			if(not addedLine) then
				DT.tooltip:AddLine(' ')
				DT.tooltip:AddLine(RAID_INFO_WORLD_BOSS.."(s)")
				addedLine = true
			end
			DT.tooltip:AddDoubleLine(name, SecondsToTime(reset, true, nil, 3), 1, 1, 1, 0.8, 0.8, 0.8)
		end
	end

	local timeText
	local Hr, Min, AmPm = CalculateTimeValues(true)

	DT.tooltip:AddLine(" ")
	if AmPm == -1 then
		DT.tooltip:AddDoubleLine(E.db.datatexts.localtime and TIMEMANAGER_TOOLTIP_REALMTIME or TIMEMANAGER_TOOLTIP_LOCALTIME, 
			format(europeDisplayFormat_nocolor, Hr, Min), 1, 1, 1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b)
	else
		DT.tooltip:AddDoubleLine(E.db.datatexts.localtime and TIMEMANAGER_TOOLTIP_REALMTIME or TIMEMANAGER_TOOLTIP_LOCALTIME,
			format(ukDisplayFormat_nocolor, Hr, Min, APM[AmPm]), 1, 1, 1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b)
	end

	local monthAbr = {
		[1] = L["Jan"],
		[2] = L["Feb"],
		[3] = L["Mar"],
		[4] = L["Apr"],
		[5] = L["May"],
		[6] = L["Jun"],
		[7] = L["Jul"],
		[8] = L["Aug"],
		[9] = L["Sep"],
		[10] = L["Oct"],
		[11] = L["Nov"],
		[12] = L["Dec"],
	}

	local daysAbr = {
		[1] = L["Sun"],
		[2] = L["Mon"],
		[3] = L["Tue"],
		[4] = L["Wed"],
		[5] = L["Thu"],
		[6] = L["Fri"],
		[7] = L["Sat"],
	}

	DT.tooltip:AddLine(" ")
	local curDayName, curMonth, curDay, curYear = CalendarGetDate()
	DT.tooltip:AddLine(format("%s, %s %d, %d", daysAbr[curDayName], monthAbr[curMonth], curDay, curYear))

	DT.tooltip:Show()
end

local int = 3
function Update(self, t)
	self.db = E.db.datatexts
	int = int - t

	if enteredFrame then
		OnEnter(self)
	end

	if _G["GameTimeFrame"].flashInvite then
		E:Flash(self, 0.53)
	else
		E:StopFlash(self)
	end

	if int > 0 then return end

	local Hr, Min, AmPm = CalculateTimeValues(false)

	-- no update quick exit
	if (Hr == curHr and Min == curMin and AmPm == curAmPm) and not (int < -15000) then
		int = 5
		return
	end

	curHr = Hr
	curMin = Min
	curAmPm = AmPm

	if AmPm == -1 then
		self.text:FontTemplate(nil, self.db.fontSize*1.6, self.db.fontOutline)
		self.text:SetFormattedText(europeDisplayFormat, Hr, Min)
	else
		self.text:FontTemplate(nil, self.db.fontSize*1.6, self.db.fontOutline)
		self.text:SetFormattedText(ukDisplayFormat, Hr, Min, APM[AmPm])
	end
	lastPanel = self
	int = 5
end

DT:RegisterDatatext("MUI Time", { "QUEST_COMPLETE", "QUEST_LOG_UPDATE" }, OnEvent, Update, Click, OnEnter, OnLeave)