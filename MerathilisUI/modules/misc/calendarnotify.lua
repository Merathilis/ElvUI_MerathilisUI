local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins')

local classColor = RAID_CLASS_COLORS[E.myclass]

-- Credits to Shackleford (CalendarNotify)
if IsAddOnLoaded("CalendarNotify") then return end

--inviteStatus 

--CALENDAR_INVITESTATUS_INVITED      = 1
--CALENDAR_INVITESTATUS_ACCEPTED     = 2
--CALENDAR_INVITESTATUS_DECLINED     = 3
--CALENDAR_INVITESTATUS_CONFIRMED    = 4
--CALENDAR_INVITESTATUS_OUT          = 5
--CALENDAR_INVITESTATUS_STANDBY      = 6
--CALENDAR_INVITESTATUS_SIGNEDUP     = 7
--CALENDAR_INVITESTATUS_NOT_SIGNEDUP = 8
--CALENDAR_INVITESTATUS_TENTATIVE    = 9


local frame = CreateFrame("Frame")
frame:Hide();
frame:SetHeight(90)
frame:SetWidth(300)
frame:SetPoint("CENTER", E.UIParent, "CENTER", 0, 50)
frame:EnableMouse(true)
frame:SetTemplate("Transparent")
frame:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
frame:RegisterEvent("CALENDAR_EVENT_ALARM")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST")
frame:RegisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")

local font = frame:CreateFontString(nil, "OVERLAY")
font:SetPoint("TOP", frame, "TOP", 0, -20)
font:FontTemplate(nil, 10)
font:SetTextColor(classColor.r, classColor.g, classColor.b)
local font2 = frame:CreateFontString(nil, "OVERLAY")
font2:SetPoint("TOP", frame, "TOP", 0, -30)
font2:FontTemplate(nil, 10)
font2:SetTextColor(classColor.r, classColor.g, classColor.b)
local font3 = frame:CreateFontString(nil, "OVERLAY")
font3:SetPoint("TOP", frame, "TOP", 0, -40)
font3:FontTemplate(nil, 10)
font3:SetTextColor(classColor.r, classColor.g, classColor.b)

function button_OnClick()
	GameTimeFrame_OnClick(GameTimeFrame)
	frame:Hide()
end

local button = CreateFrame("Button", "CalendarButton", frame, "UIPanelButtonTemplate")
button:SetHeight(25)
button:SetWidth(50)
button:SetPoint("BOTTOM", frame, "BOTTOM", 0, 5)
button:SetText(L["View"])
button:RegisterForClicks("AnyUp")
button:SetScript("OnClick", button_OnClick)
S:HandleButton(button)

local closebutton = CreateFrame("Button", "CloseButton", frame, "UIPanelCloseButton")
closebutton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -8)
closebutton:SetHeight(10)
closebutton:SetWidth(10)
S:HandleCloseButton(closebutton)

local function CheckToday()
local curweekday, curmonth, curday, curyear = CalendarGetDate()
local numtodaysEvents = CalendarGetNumDayEvents(0, curday)	
local todaysevents = 0
local numtentative = 0	
	font3:SetText("")	
	if numtodaysEvents ~= 0 then
		for i = 1, numtodaysEvents do
		local title3, hour3, minute3, calendarType3, _, _, _, _, inviteStatus3, invitedBy3 = CalendarGetDayEvent(0, curday, i)
		if calendarType3 == "PLAYER" or calendarType3 == "GUILD_EVENT" then
			if inviteStatus3 == 8 or inviteStatus3 == 3 or inviteStatus3 == 5 then
				if CalendarFrame and CalendarFrame:IsVisible() then
					frame:Hide()
				end
				return
			else
				if inviteStatus3 == 9 then
					numtentative = numtentative + 1
				end
				--DEFAULT_CHAT_FRAME:AddMessage(string.format("|cffffff00CalendarNotify:|r %s is scheduled for today at %02d:%02d.", title3, hour3, minute3 ),0.0, 1.0, 0.0, nil, true)			
				todaysevents = todaysevents + 1
				font3:SetText(string.format(L["You have %s events scheduled for today. %s Tentative."], todaysevents, numtentative ))
				if not frame:IsShown() then
					frame:Show()
				end
			end
		end
		end
	end
	if CalendarFrame and CalendarFrame:IsVisible() then
		frame:Hide()
	end
end

local function GetInvites()
	font:SetText("")
	if CalendarGetNumPendingInvites() ~= 0 then	
		font:SetText(string.format(L["You have %s pending event invite(s)!"], CalendarGetNumPendingInvites()))
		if not frame:IsShown() then
			frame:Show()
		end
	end
	if CalendarFrame and CalendarFrame:IsVisible() then
		frame:Hide()
	end	
end

local function GetGuildEvents()
local pendinginvites = 0
local numguildEvents = CalendarGetNumGuildEvents()
local currentweekday, currentmonth, currentday, currentyear = CalendarGetDate()
	font2:SetText("")
	for eventIndex = 1, numguildEvents do
		
		local month, day, weekday, hour, minute, eventType, title, calendarType, textureName = CalendarGetGuildEventInfo(eventIndex)
		local monthOffset = month - currentmonth
		local numEvents = CalendarGetNumDayEvents(monthOffset, day)
		
		if numEvents ~= 0 then
			for i = 1, numEvents do
			local title2, hour2, minute2, calendarType2, _, _, _, _, inviteStatus, invitedBy = CalendarGetDayEvent(monthOffset, day, i)
				if inviteStatus == 8 then
					pendinginvites = pendinginvites + 1
					font2:SetText(string.format(L["You have %s pending guild event(s)!"], pendinginvites))
					if not frame:IsShown() then
						frame:Show()
					end
				end
			end
		end
	end
	if CalendarFrame and CalendarFrame:IsVisible() then
		frame:Hide()
	end
end 
 
local function eventHandler(self, event, ...)
	if E.db.Merathilis.CalendarNotify then
		if event == "CALENDAR_EVENT_ALARM" then
		local title, hour, minute = ...;
			font:SetText(string.format(L["%s begins in 15 minutes"], title)) --("Your event is scheduled to begin in 15 minutes")
			font2:SetText("")
			font3:SetText("")
			frame:Show()
			PlaySound("AlarmClockwarning3")
			if CalendarFrame and CalendarFrame:IsVisible() then
				frame:Hide()
			end
		elseif event == "PLAYER_ENTERING_WORLD" then
			local _, todaysmonth, _, todaysyear = CalendarGetDate()
			CalendarSetAbsMonth(todaysmonth, todaysyear)
			OpenCalendar()
			GetInvites() 
			GetGuildEvents()
			CheckToday()
			frame:UnregisterEvent("PLAYER_ENTERING_WORLD")
		elseif event == "CALENDAR_UPDATE_PENDING_INVITES" or event == "CALENDAR_UPDATE_GUILD_EVENTS" or event == "CALENDAR_UPDATE_EVENT_LIST" then
			GetInvites()
			GetGuildEvents()
			CheckToday()
		end
	end
end
frame:SetScript("OnEvent", eventHandler)
