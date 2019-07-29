local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local module = MER:NewModule("Notification", "AceEvent-3.0")
local CH = E:GetModule("Chat")
local S = E:GetModule("Skins")
module.modName = L["Notification"]

-- Credits RealUI

--Cache global variables
--Lua functions
local _G = _G
local select, unpack, type, pairs, ipairs, tostring, next = select, unpack, type, pairs, ipairs, tostring, next
local table = table
local tinsert, tremove = table.insert, table.remove
local floor = math.floor
local format, find, sub = string.format, string.find, string.sub

--WoW API / Variables
local CreateFrame = CreateFrame
local UnitIsAFK = UnitIsAFK
local HasNewMail = HasNewMail
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemDurability = GetInventoryItemDurability
local GetTime = GetTime
local C_Texture_GetAtlasInfo = C_Texture.GetAtlasInfo
local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
local C_Calendar_GetNumGuildEvents = C_Calendar.GetNumGuildEvents
local C_Calendar_GetGuildEventInfo = C_Calendar.GetGuildEventInfo
local C_Calendar_GetNumDayEvents = C_Calendar.GetNumDayEvents
local C_Calendar_GetDayEvent = C_Calendar.GetDayEvent
local C_Calendar_GetNumPendingInvites = C_Calendar.GetNumPendingInvites
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_Scenario_GetInfo = C_Scenario.GetInfo
local C_VignetteInfo_GetVignetteInfo = C_VignetteInfo.GetVignetteInfo
local InCombatLockdown = InCombatLockdown
local LoadAddOn = LoadAddOn
local PlaySoundFile = PlaySoundFile
local PlaySound = PlaySound
local C_Timer = C_Timer
local CreateAnimationGroup = CreateAnimationGroup
local SlashCmdList = SlashCmdList
local Calendar_Toggle = Calendar_Toggle
local IsInGroup, IsInRaid, IsPartyLFG = IsInGroup, IsInRaid, IsPartyLFG
local MAIL_LABEL = MAIL_LABEL
local HAVE_MAIL = HAVE_MAIL

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local bannerWidth = 255
local bannerHeight = 68
local max_active_toasts = 3
local fadeout_delay = 5
local toasts = {}
local activeToasts = {}
local queuedToasts = {}
local anchorFrame

local VignetteExclusionMapIDs = {
	[579] = true, -- Lunarfall: Alliance garrison
	[585] = true, -- Frostwall: Horde garrison
	[646] = true, -- Scenario: The Broken Shore
}

function module:SpawnToast(toast)
	if not toast then return end

	if #activeToasts >= max_active_toasts then
		tinsert(queuedToasts, toast)

		return false
	end

	if UnitIsAFK("player") then
		tinsert(queuedToasts, toast)
		self:RegisterEvent("PLAYER_FLAGS_CHANGED")

		return false
	end

	local YOffset = 0
	if E:GetScreenQuadrant(anchorFrame):find("TOP") then
		YOffset = -54
	else
		YOffset = 54
	end

	toast:ClearAllPoints()
	if #activeToasts > 0 then
		if E:GetScreenQuadrant(anchorFrame):find("TOP") then
			toast:SetPoint("TOP", activeToasts[#activeToasts], "BOTTOM", 0, -4 - YOffset)
		else
			toast:SetPoint("BOTTOM", activeToasts[#activeToasts], "TOP", 0, 4 - YOffset)
		end
	else
		toast:SetPoint("TOP", anchorFrame, "TOP", 0, 1 - YOffset)
	end

	tinsert(activeToasts, toast)

	toast:Show()
	toast.AnimIn.AnimMove:SetOffset(0, YOffset)
	toast.AnimOut.AnimMove:SetOffset(0, -YOffset)
	toast.AnimIn:Play()
	toast.AnimOut:Play()

	if module.db.noSound ~= true then
		PlaySound(18019, "Master")
	end
end

function module:RefreshToasts()
	for i = 1, #activeToasts do
		local activeToast = activeToasts[i]
		local YOffset, _ = 0
		if activeToast.AnimIn.AnimMove:IsPlaying() then
			_, YOffset = activeToast.AnimIn.AnimMove:GetOffset()
		end
		if activeToast.AnimOut.AnimMove:IsPlaying() then
			_, YOffset = activeToast.AnimOut.AnimMove:GetOffset()
		end

		activeToast:ClearAllPoints()

		if i == 1 then
			activeToast:SetPoint("TOP", anchorFrame, "TOP", 0, 1 - YOffset)
		else
			if E:GetScreenQuadrant(anchorFrame):find("TOP") then
				activeToast:SetPoint("TOP", activeToasts[i - 1], "BOTTOM", 0, -4 - YOffset)
			else
				activeToast:SetPoint("BOTTOM", activeToasts[i - 1], "TOP", 0, 4 - YOffset)
			end
		end
	end

	local queuedToast = tremove(queuedToasts, 1)

	if queuedToast then
		self:SpawnToast(queuedToast)
	end
end

function module:HideToast(toast)
	for i, activeToast in pairs(activeToasts) do
		if toast == activeToast then
			tremove(activeToasts, i)
		end
	end
	tinsert(toasts, toast)
	toast:Hide()
	C_Timer.After(0.1, function() self:RefreshToasts() end)
end

local function ToastButtonAnimOut_OnFinished(self)
	module:HideToast(self:GetParent())
end

function module:CreateToast()
	local toast = tremove(toasts, 1)

	toast = CreateFrame("Frame", nil, E.UIParent)
	toast:SetFrameStrata("HIGH")
	toast:SetSize(bannerWidth, bannerHeight)
	toast:SetPoint("TOP", E.UIParent, "TOP")
	toast:Hide()
	MERS:CreateBD(toast, .45)
	toast:Styling()
	toast:CreateCloseButton(10)

	local icon = toast:CreateTexture(nil, "OVERLAY")
	icon:SetSize(32, 32)
	icon:SetPoint("LEFT", toast, "LEFT", 9, 0)
	MERS:CreateBG(icon)
	toast.icon = icon

	local sep = toast:CreateTexture(nil, "BACKGROUND")
	sep:SetSize(2, bannerHeight)
	sep:SetPoint("LEFT", icon, "RIGHT", 9, 0)
	sep:SetColorTexture(unpack(E["media"].rgbvaluecolor))

	local title = MER:CreateText(toast, "OVERLAY", 11, "OUTLINE")
	title:SetShadowOffset(1, -1)
	title:SetPoint("TOPLEFT", sep, "TOPRIGHT", 3, -6)
	title:SetPoint("TOP", toast, "TOP", 0, 0)
	title:SetJustifyH("LEFT")
	title:SetNonSpaceWrap(true)
	toast.title = title

	local text = MER:CreateText(toast, "OVERLAY", 10, nil)
	text:SetShadowOffset(1, -1)
	text:SetPoint("BOTTOMLEFT", sep, "BOTTOMRIGHT", 3, 9)
	text:SetPoint("RIGHT", toast, -9, 0)
	text:SetJustifyH("LEFT")
	text:SetWidth(toast:GetRight() - sep:GetLeft() - 5)
	toast.text = text

	toast.AnimIn = CreateAnimationGroup(toast)

	local animInAlpha = toast.AnimIn:CreateAnimation("Fade")
	animInAlpha:SetOrder(1)
	animInAlpha:SetChange(1)
	animInAlpha:SetDuration(0.5)
	toast.AnimIn.AnimAlpha = animInAlpha

	local animInMove = toast.AnimIn:CreateAnimation("Move")
	animInMove:SetOrder(1)
	animInMove:SetDuration(0.5)
	animInMove:SetEasing("Out")
	animInMove:SetOffset(-bannerWidth, 0)
	toast.AnimIn.AnimMove = animInMove

	toast.AnimOut = CreateAnimationGroup(toast)

	local animOutSleep = toast.AnimOut:CreateAnimation("Sleep")
	animOutSleep:SetOrder(1)
	animOutSleep:SetDuration(fadeout_delay)
	toast.AnimOut.AnimSleep = animOutSleep

	local animOutAlpha = toast.AnimOut:CreateAnimation("Fade")
	animOutAlpha:SetOrder(2)
	animOutAlpha:SetChange(0)
	animOutAlpha:SetDuration(0.5)
	toast.AnimOut.AnimAlpha = animOutAlpha

	local animOutMove = toast.AnimOut:CreateAnimation("Move")
	animOutMove:SetOrder(2)
	animOutMove:SetDuration(0.5)
	animOutMove:SetEasing("In")
	animOutMove:SetOffset(bannerWidth, 0)
	toast.AnimOut.AnimMove = animOutMove

	toast.AnimOut.AnimAlpha:SetScript("OnFinished", ToastButtonAnimOut_OnFinished)

	toast:SetScript("OnEnter", function(self)
		self.AnimOut:Stop()
	end)

	toast:SetScript("OnLeave", function(self)
		self.AnimOut:Play()
	end)

	toast:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and self.clickFunc then
			self.clickFunc()
		end
	end)

	return toast
end

function module:DisplayToast(name, message, clickFunc, texture, ...)
	local toast = self:CreateToast()

	if type(clickFunc) == "function" then
		toast.clickFunc = clickFunc
	else
		toast.clickFunc = nil
	end

	if texture then
		if C_Texture_GetAtlasInfo(texture) then
			toast.icon:SetAtlas(texture)
		else
			toast.icon:SetTexture(texture)

			if ... then
				toast.icon:SetTexCoord(...)
			else
				toast.icon:SetTexCoord(unpack(E.TexCoords))
			end
		end
	else
		toast.icon:SetTexture("Interface\\Icons\\achievement_general")
		toast.icon:SetTexCoord(unpack(E.TexCoords))
	end

	toast.title:SetText(name)
	toast.text:SetText(message)

	self:SpawnToast(toast)
end

function module:PLAYER_FLAGS_CHANGED(event)
	self:UnregisterEvent(event)
	for i = 1, max_active_toasts - #activeToasts do
		self:RefreshToasts()
	end
end

function module:PLAYER_REGEN_ENABLED()
	for i = 1, max_active_toasts - #activeToasts do
		self:RefreshToasts()
	end
end

-- Test function
local function testCallback()
	MER:Print("Banner clicked!")
end

SlashCmdList.TESTNOTIFICATION = function(b)
	module:DisplayToast(MER:cOption("MerathilisUI:"), L["This is an example of a notification."], testCallback, b == "true" and "INTERFACE\\ICONS\\SPELL_FROST_ARCTICWINDS" or nil, .08, .92, .08, .92)
end
SLASH_TESTNOTIFICATION1 = "/testnotification"

local hasMail = false
function module:UPDATE_PENDING_MAIL()
	if module.db.enable ~= true or module.db.mail ~= true then return end
	if InCombatLockdown() then return end

	local newMail = HasNewMail()
	if hasMail ~= newMail then
		hasMail = newMail
		if hasMail then
			self:DisplayToast(format("|cfff9ba22%s|r", MAIL_LABEL), HAVE_MAIL, nil, "Interface\\Icons\\inv_letter_15", .08, .92, .08, .92)
			if module.db.noSound ~= true then
				PlaySoundFile([[Interface\AddOns\ElvUI_MerathilisUI\media\sounds\mail.mp3]])
			end
		end
	end
end

local showRepair = true

local Slots = {
	[1] = {1, INVTYPE_HEAD, 1000},
	[2] = {3, INVTYPE_SHOULDER, 1000},
	[3] = {5, INVTYPE_ROBE, 1000},
	[4] = {6, INVTYPE_WAIST, 1000},
	[5] = {9, INVTYPE_WRIST, 1000},
	[6] = {10, INVTYPE_HAND, 1000},
	[7] = {7, INVTYPE_LEGS, 1000},
	[8] = {8, INVTYPE_FEET, 1000},
	[9] = {16, INVTYPE_WEAPONMAINHAND, 1000},
	[10] = {17, INVTYPE_WEAPONOFFHAND, 1000},
	[11] = {18, INVTYPE_RANGED, 1000}
}

local function ResetRepairNotification()
	showRepair = true
end

function module:UPDATE_INVENTORY_DURABILITY()
	local current, max

	for i = 1, 11 do
		if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
			current, max = GetInventoryItemDurability(Slots[i][1])
			if current then
				Slots[i][3] = current/max
			end
		end
	end
	table.sort(Slots, function(a, b) return a[3] < b[3] end)
	local value = floor(Slots[1][3]*100)

	if showRepair and value < 20 then
		showRepair = false
		E:Delay(30, ResetRepairNotification)
		self:DisplayToast(MINIMAP_TRACKING_REPAIR, format(L["%s slot needs to repair, current durability is %d."],Slots[1][2],value))
	end
end


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
	if not _G.CalendarFrame then LoadAddOn("Blizzard_Calendar") end
	Calendar_Toggle()
end

local function alertEvents()
	if module.db.enable ~= true or module.db.invites ~= true then return end
	if _G.CalendarFrame and _G.CalendarFrame:IsShown() then return end
	local num = C_Calendar_GetNumPendingInvites()
	if num ~= numInvites then
		if num > 0 then
			module:DisplayToast(CALENDAR, L["You have %s pending calendar |4invite:invites;."]:format(num), toggleCalendar)
		end
		numInvites = num
	end
end

local function alertGuildEvents()
	if module.db.enable ~= true or module.db.guildEvents ~= true then return end
	if _G.CalendarFrame and _G.CalendarFrame:IsShown() then return end
	local num = GetGuildInvites()
	if num > 0 then
		module:DisplayToast(CALENDAR, L["You have %s pending guild |4event:events;."]:format(num), toggleCalendar)
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


local SOUND_TIMEOUT = 20
function module:VIGNETTE_MINIMAP_UPDATED(event, vignetteGUID, onMinimap)
	if not module.db.vignette or InCombatLockdown() or VignetteExclusionMapIDs[C_Map_GetBestMapForUnit("player")] then return end

	local inGroup, inRaid, inPartyLFG = IsInGroup(), IsInRaid(), IsPartyLFG()
	if inGroup or inRaid or inPartyLFG then
		return;
	end

	if onMinimap then
		local vignetteInfo = C_VignetteInfo_GetVignetteInfo(vignetteGUID)
		if vignetteInfo and vignetteGUID ~= self.lastMinimapRare.id then
			vignetteInfo.name = format("|cff00c0fa%s|r", vignetteInfo.name:sub(1, 28))
			self:DisplayToast(vignetteInfo.name, L["has appeared on the MiniMap!"], nil, vignetteInfo.atlasName)
			self.lastMinimapRare.id = vignetteGUID

			local time = GetTime()
			if time > (self.lastMinimapRare.time + SOUND_TIMEOUT) then
				if module.db.noSound ~= true then
					PlaySound(_G.SOUNDKIT.RAID_WARNING)
					self.lastMinimapRare.time = time
				end
			end
		end
	end
end

function module:RESURRECT_REQUEST(name)
	if module.db.noSound ~= true then
		PlaySound(46893, "Master")
	end
end

function module:Initialize()
	module.db = E.db.mui.notification
	MER:RegisterDB(self, "notification")
	if module.db.enable ~= true then return end

	anchorFrame = CreateFrame("Frame", nil, E.UIParent)
	anchorFrame:SetSize(bannerWidth, 50)
	anchorFrame:SetPoint("TOP", 0, -80)
	E:CreateMover(anchorFrame, "Notification Mover", L["Notification Mover"], nil, nil, nil, "ALL,SOLO,MERATHILISUI", nil, 'mui,modules,Notification')

	self:RegisterEvent("UPDATE_PENDING_MAIL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	self:RegisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	self:RegisterEvent("RESURRECT_REQUEST")
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")

	self.lastMinimapRare = {time = 0, id = nil}
end

MER:RegisterModule(module:GetName())
