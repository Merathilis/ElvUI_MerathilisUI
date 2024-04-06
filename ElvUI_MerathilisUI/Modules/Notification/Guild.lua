local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Notification

local _G = _G

local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
local C_Calendar_GetNumGuildEvents = C_Calendar and C_Calendar.GetNumGuildEvents
local C_Calendar_GetGuildEventInfo = C_Calendar and C_Calendar.GetGuildEventInfo
local C_Calendar_GetNumDayEvents = C_Calendar and C_Calendar.GetNumDayEvents
local C_Calendar_GetDayEvent = C_Calendar and C_Calendar.GetDayEvent
local C_Calendar_GetNumPendingInvites = C_Calendar and C_Calendar.GetNumPendingInvites
local LoadAddOn = LoadAddOn
local ShowUIPanel = ShowUIPanel

local numInvites = 0
local function GetGuildInvites()
	local numGuildInvites = 0
	local date = C_DateAndTime_GetCurrentCalendarTime()
	for index = 1, C_Calendar_GetNumGuildEvents() do
		local info = C_Calendar_GetGuildEventInfo(index)
		local monthOffset = info.month - date.month
		local numDayEvents = C_Calendar_GetNumDayEvents(monthOffset, info.monthDay)

		for i = 1, numDayEvents do
			local event = C_Calendar_GetDayEvent(monthOffset, info.monthDay, i)
			if event.inviteStatus == _G.CALENDAR_INVITESTATUS_NOT_SIGNEDUP then
				numGuildInvites = numGuildInvites + 1
			end
		end
	end

	return numGuildInvites
end

local function toggleCalendar()
	if not _G.CalendarFrame then
		LoadAddOn("Blizzard_Calendar")
	end
	ShowUIPanel(_G.CalendarFrame)
end

local function alertEvents()
	module.db = E.db.mui.notification
	if not module.db.enable or not module.db.invites then
		return
	end
	if _G.CalendarFrame and _G.CalendarFrame:IsShown() then
		return
	end

	local num = C_Calendar_GetNumPendingInvites()
	if num ~= numInvites then
		if num > 0 then
			module:DisplayToast(
				_G.CALENDAR,
				L["You have %s pending calendar |4invite:invites;."]:format(num),
				toggleCalendar
			)
		end
		numInvites = num
	end
end

local function alertGuildEvents()
	module.db = E.db.mui.notification
	if not module.db.enable or not module.db.guildEvents then
		return
	end

	if _G.CalendarFrame and _G.CalendarFrame:IsShown() then
		return
	end

	local num = GetGuildInvites()
	if num > 0 then
		module:DisplayToast(_G.CALENDAR, L["You have %s pending guild |4event:events;."]:format(num), toggleCalendar)
	end
end

function module:CALENDAR_UPDATE_PENDING_INVITES()
	alertEvents()
	alertGuildEvents()
end

function module:CALENDAR_UPDATE_GUILD_EVENTS()
	alertGuildEvents()
end

local function LoginCheck()
	alertEvents()
	alertGuildEvents()
end

function module:PLAYER_ENTERING_WORLD()
	C_Timer.After(7, LoginCheck)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end
