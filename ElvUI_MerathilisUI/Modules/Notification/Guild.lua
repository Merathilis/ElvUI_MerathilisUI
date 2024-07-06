local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Notification

local _G = _G

local GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
local GetNumGuildEvents = C_Calendar.GetNumGuildEvents
local GetGuildEventInfo = C_Calendar.GetGuildEventInfo
local GetNumDayEvents = C_Calendar.GetNumDayEvents
local GetDayEvent = C_Calendar.GetDayEvent
local GetNumPendingInvites = C_Calendar and C_Calendar.GetNumPendingInvites
local LoadAddOn = C_AddOns.LoadAddOn
local After = C_Timer.After
local ShowUIPanel = ShowUIPanel

local numInvites = 0
local function GetGuildInvites()
	local numGuildInvites = 0
	local date = GetCurrentCalendarTime()
	for index = 1, GetNumGuildEvents() do
		local info = GetGuildEventInfo(index)
		local monthOffset = info.month - date.month
		local numDayEvents = GetNumDayEvents(monthOffset, info.monthDay)

		for i = 1, numDayEvents do
			local event = GetDayEvent(monthOffset, info.monthDay, i)
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

	local num = GetNumPendingInvites()
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
	After(7, LoginCheck)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end
