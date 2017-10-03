local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local NF = E:NewModule("Notification", "AceEvent-3.0", "AceHook-3.0")
local S = E:GetModule("Skins")
NF.modName = L["Notification"]

--Cache global variables
--Lua functions
local select, unpack, type, pairs, ipairs, tostring = select, unpack, type, pairs, ipairs, tostring
local table = table
local tinsert = table.insert
local floor = math.floor
local format, find = string.format, string.find

--WoW API / Variables
local CreateFrame = CreateFrame
local UnitIsAFK = UnitIsAFK
local GetScreenWidth = GetScreenWidth
local IsShiftKeyDown = IsShiftKeyDown
local HasNewMail = HasNewMail
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local GetObjectIconTextureCoords = GetObjectIconTextureCoords
local GetInstanceInfo = GetInstanceInfo
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemDurability = GetInventoryItemDurability
local GetLFGDungeonInfo = GetLFGDungeonInfo
local GetRealmName = GetRealmName
local CalendarGetDate = CalendarGetDate
local CalendarGetNumGuildEvents = CalendarGetNumGuildEvents
local CalendarGetGuildEventInfo = CalendarGetGuildEventInfo
local CalendarGetNumDayEvents = CalendarGetNumDayEvents
local CalendarGetDayEvent = C_Calendar.GetDayEvent
local InCombatLockdown = InCombatLockdown
local LoadAddOn = LoadAddOn
local CalendarGetNumPendingInvites = CalendarGetNumPendingInvites
local C_Vignettes = C_Vignettes
local PlaySoundFile = PlaySoundFile
local PlaySound = PlaySound
local C_Timer = C_Timer
local C_LFGListGetActivityInfo = C_LFGList.GetActivityInfo
local C_LFGListGetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_SocialQueueGetGroupMembers = C_SocialQueue.GetGroupMembers
local C_SocialQueueGetGroupQueues = C_SocialQueue.GetGroupQueues
local C_PvPGetBrawlInfo = C_PvP.GetBrawlInfo
local GetGameTime = GetGameTime
local CreateAnimationGroup = CreateAnimationGroup
local CalendarGetAbsMonth = CalendarGetAbsMonth
local BNGetNumFriends = BNGetNumFriends
local BNGetFriendInfo = BNGetFriendInfo
local BNGetGameAccountInfo = BNGetGameAccountInfo

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: SLASH_TESTNOTIFICATION1, MAIL_LABEL, HAVE_MAIL, MINIMAP_TRACKING_REPAIR, CalendarFrame
-- GLOBALS: CALENDAR, Calendar_Toggle, BAG_UPDATE, BACKPACK_CONTAINER, NUM_BAG_SLOTS, ToggleBackpack

local bannerWidth = 250
local max_active_toasts = 3
local fadeout_delay = 5
local toasts = {}
local activeToasts = {}
local queuedToasts = {}
local anchorFrame
local alertBagsFull
local shouldAlertBags = false

function NF:SpawnToast(toast)
	if not toast then return end

	if #activeToasts >= max_active_toasts then
		table.insert(queuedToasts, toast)

		return false
	end

	if UnitIsAFK("player") then
		table.insert(queuedToasts, toast)
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

	table.insert(activeToasts, toast)

	toast:Show()
	toast.AnimIn.AnimMove:SetOffset(0, YOffset)
	toast.AnimOut.AnimMove:SetOffset(0, -YOffset)
	toast.AnimIn:Play()
	toast.AnimOut:Play()
	PlaySound(18019, "Master")
end

function NF:RefreshToasts()
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

	local queuedToast = table.remove(queuedToasts, 1)

	if queuedToast then
		self:SpawnToast(queuedToast)
	end
end

function NF:HideToast(toast)
	for i, activeToast in pairs(activeToasts) do
		if toast == activeToast then
			table.remove(activeToasts, i)
		end
	end
	table.insert(toasts, toast)
	toast:Hide()
	C_Timer.After(0.1, function() self:RefreshToasts() end)
end

local function ToastButtonAnimOut_OnFinished(self)
	NF:HideToast(self:GetParent())
end

function NF:GetToast()
	local toast = table.remove(toasts, 1)
	if not toast then
		toast = CreateFrame("Frame", nil, E.UIParent)
		toast:SetFrameStrata("FULLSCREEN_DIALOG")
		toast:SetSize(bannerWidth, 60)
		toast:SetPoint("TOP", E.UIParent, "TOP")
		toast:Hide()
		MERS:CreateBD(toast, .45)
		MERS:StyleOutside(toast)
		MERS:CreateStripes(toast)

		local icon = toast:CreateTexture(nil, "OVERLAY")
		icon:SetSize(32, 32)
		icon:SetPoint("LEFT", toast, "LEFT", 9, 0)
		MERS:CreateBG(icon)
		MERS:StyleOutside(toast)
		toast.icon = icon

		local sep = toast:CreateTexture(nil, "BACKGROUND")
		sep:SetSize(1, 60)
		sep:SetPoint("LEFT", icon, "RIGHT", 9, 0)
		sep:SetColorTexture(0, 0, 0)

		local title = toast:CreateFontString(nil, "OVERLAY")
		title:SetFont(E["media"].normFont, 12, "OUTLINE")
		title:SetShadowOffset(1, -1)
		title:SetPoint("TOPLEFT", sep, "TOPRIGHT", 9, -5)
		title:SetPoint("TOP", toast, "TOP", 0, 0)
		title:SetJustifyH("LEFT")
		toast.title = title

		local text = toast:CreateFontString(nil, "OVERLAY")
		text:SetFont(E["media"].normFont, 10)
		text:SetShadowOffset(1, -1)
		text:SetPoint("BOTTOMLEFT", sep, "BOTTOMRIGHT", 9, 9)
		text:SetPoint("RIGHT", toast, -9, 0)
		text:SetJustifyH("LEFT")
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
		animInMove:SetSmoothing("Out")
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
		animOutMove:SetSmoothing("In")
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
	end
	return toast
end

function NF:DisplayToast(name, message, clickFunc, texture, ...)
	local toast = self:GetToast()

	if type(clickFunc) == "function" then
		toast.clickFunc = clickFunc
	else
		toast.clickFunc = nil
	end

	if type(texture) == "string" then
		toast.icon:SetTexture(texture)

		if ... then
			toast.icon:SetTexCoord(...)
		else
			toast.icon:SetTexCoord(.08, .92, .08, .92)
		end
	else
		toast.icon:SetTexture("Interface\\Icons\\achievement_general")
		toast.icon:SetTexCoord(.08, .92, .08, .92)
	end

	toast.title:SetText(name)
	toast.text:SetText(message)

	self:SpawnToast(toast)
end

function NF:PLAYER_FLAGS_CHANGED(event)
	self:UnregisterEvent(event)
	for i = 1, max_active_toasts - #activeToasts do
		self:RefreshToasts()
	end
end

function NF:PLAYER_REGEN_ENABLED()
	for i = 1, max_active_toasts - #activeToasts do
		self:RefreshToasts()
	end
end

-- Test function

local function testCallback()
	MER:Print("Banner clicked!")
end

SlashCmdList.TESTNOTIFICATION = function(b)
	NF:DisplayToast(MER:cOption("MerathilisUI:"), L["This is an example of a notification."], testCallback, b == "true" and "INTERFACE\\ICONS\\SPELL_FROST_ARCTICWINDS" or nil, .08, .92, .08, .92)
end
SLASH_TESTNOTIFICATION1 = "/testnotification"

local hasMail = false
function NF:UPDATE_PENDING_MAIL()
	if E.db.mui.general.Notification.enable ~= true or E.db.mui.general.Notification.mail ~= true then return end
	local newMail = HasNewMail()
	if hasMail ~= newMail then
		hasMail = newMail
		if hasMail then
			PlaySoundFile([[Interface\AddOns\ElvUI_MerathilisUI\media\sounds\mail.mp3]])
			self:DisplayToast(MAIL_LABEL, HAVE_MAIL, nil, "Interface\\Icons\\inv_letter_15", .08, .92, .08, .92)
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

function NF:UPDATE_INVENTORY_DURABILITY()
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
	local _, currentMonth = CalendarGetDate()

	for i = 1, CalendarGetNumGuildEvents() do
		local month, day = CalendarGetGuildEventInfo(i)
		local monthOffset = month - currentMonth
		local numDayEvents = CalendarGetNumDayEvents(monthOffset, day)

		for i = 1, numDayEvents do
			local _, _, _, _, _, _, _, _, inviteStatus = CalendarGetDayEvent(monthOffset, day, i)
			if inviteStatus == 8 then
				numGuildInvites = numGuildInvites + 1
			end
		end
	end

	return numGuildInvites
end

local function toggleCalendar()
	if not CalendarFrame then LoadAddOn("Blizzard_Calendar") end
	Calendar_Toggle()
end

local function alertEvents()
	if E.db.mui.general.Notification.enable ~= true or E.db.mui.general.Notification.invites ~= true then return end
	if CalendarFrame and CalendarFrame:IsShown() then return end
	local num = CalendarGetNumPendingInvites()
	if num ~= numInvites then
		if num > 1 then
			NF:DisplayToast(CALENDAR, format(L["You have %s pending calendar invite(s)."], num), toggleCalendar)
		elseif num > 0 then
			NF:DisplayToast(CALENDAR, format(L["You have %s pending calendar invite(s)."], 1), toggleCalendar)
		end
		numInvites = num
	end
end

local function alertGuildEvents()
	if E.db.mui.general.Notification.enable ~= true or E.db.mui.general.Notification.guildEvents ~= true then return end
	if CalendarFrame and CalendarFrame:IsShown() then return end
	local num = GetGuildInvites()
	if num > 1 then
		NF:DisplayToast(CALENDAR, format(L["You have %s pending guild event(s)."], num), toggleCalendar)
	elseif num > 0 then
		NF:DisplayToast(CALENDAR, format(L["You have %s pending guild event(s)."], 1), toggleCalendar)
	end
end

function NF:CALENDAR_UPDATE_PENDING_INVITES()
	alertEvents()
	alertGuildEvents()
end

function NF:CALENDAR_UPDATE_GUILD_EVENTS()
	alertGuildEvents()
end

local function LoginCheck()
	alertEvents()
	alertGuildEvents()
	local month, day, year = select(2, CalendarGetDate())
	local numDayEvents = CalendarGetNumDayEvents(0, day)
	local numDays = select(3, CalendarGetAbsMonth(month, year))
	local hournow, minutenow = GetGameTime()

	-- Today
	for i = 1, numDayEvents do
		local title, hour, minute, calendarType, sequenceType, eventType, texture, modStatus, inviteStatus, invitedBy, difficulty, inviteType = CalendarGetDayEvent(0, day, i)
		if calendarType == "HOLIDAY" and ( sequenceType == "END" or sequenceType == "" ) and hournow < hour then
			NF:DisplayToast(CALENDAR, format(L["Event \"%s\" will end today."], title), toggleCalendar)
		end
		if calendarType == "HOLIDAY" and sequenceType == "START" and hournow > hour then
			NF:DisplayToast(CALENDAR, format(L["Event \"%s\" started today."], title), toggleCalendar)
		end
		if calendarType == "HOLIDAY" and sequenceType == "ONGOING" then
			NF:DisplayToast(CALENDAR, format(L["Event \"%s\" is ongoing."], title), toggleCalendar)
		end
	end

	--Tomorrow
	local offset = 0
	if numDays == day then
		offset = 1
		day = 1
	else
		day = day + 1
	end
	numDayEvents = CalendarGetNumDayEvents(offset, day)
	for i = 1, numDayEvents do
		local title, hour, minute, calendarType, sequenceType, eventType, texture, modStatus, inviteStatus, invitedBy, difficulty, inviteType = CalendarGetDayEvent(offset, day, i)
		if calendarType == "HOLIDAY" and ( sequenceType == "END" or sequenceType == "" ) then
			NF:DisplayToast(CALENDAR, format(L["Event \"%s\" will end tomorrow."], title), toggleCalendar)
		end
	end
end

function NF:PLAYER_ENTERING_WORLD()
	C_Timer.After(7, LoginCheck)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function NF:VIGNETTE_ADDED(event, id)
	if not E.db.mui.general.Notification.vignette or InCombatLockdown() then return end
	if not id then return end

	local _, _, name, icon = C_Vignettes.GetVignetteInfoFromInstanceID(id)
	local left, right, top, bottom = GetObjectIconTextureCoords(icon)
	PlaySoundFile("Sound\\Interface\\RaidWarning.ogg")
	local str = "|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:"..(left*256)..":"..(right*256)..":"..(top*256)..":"..(bottom*256).."|t"
	self:DisplayToast(str..name, L[" spotted!"])
end

local last = 0
local function delayBagCheck(self, elapsed)
	last = last + elapsed
	if last > 1 then
		self:SetScript("OnUpdate", nil)
		last = 0
		shouldAlertBags = true
		BAG_UPDATE(self)
	end
end

function NF:BAG_UPDATE(self)
	local totalFree, freeSlots, bagFamily = 0
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		freeSlots, bagFamily = GetContainerNumFreeSlots(i)
		if bagFamily == 0 then
			totalFree = totalFree + freeSlots
		end
	end

	if totalFree == 0 then
		if shouldAlertBags then
			NF:DisplayToast("Bags", "Your bags are full.", ToggleBackpack, "Interface\\Icons\\inv_misc_bag_08")
			shouldAlertBags = false
		else
			self:SetScript("OnUpdate", delayBagCheck)
		end
	else
		shouldAlertBags = false
	end
end

function NF:RESURRECT_REQUEST(name)
	PlaySound(46893, "Master")
end

-- Taken from Quick Join Notification
local function checkIfLeader(leaderName, friendName)
	if leaderName == friendName then
		return true
	end

	local bnetFriendName = ""
	for i = 1, BNGetNumFriends() do
		local bnetIDAccount, accountName, battleTag, isBattleTag, characterName, bnetIDGameAccount, client, isOnline, lastOnline, isBnetAFK, isBnetDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(i)
		if isOnline then
			local hasFocus, characterName, client, realmName, realmID, faction, race, class, _, zoneName, level, gameText = BNGetGameAccountInfo(bnetIDGameAccount)
			local playerRealmName = GetRealmName()
			if accountName == friendName then
				bnetFriendName = characterName
				if realmName ~= playerRealmName then
					bnetFriendName = bnetFriendName.."-"..realmName
				end
			end
		end
	end
	return leaderName == bnetFriendName
end

local function AppendQueueName(textTable, name, nameFormatter)
	if ( name ) then
		if ( nameFormatter ) then
			name = nameFormatter:format(name)
		end
		table.insert(textTable, name)
	end
end

local function GetQueueName(queue, nameFormatter)
	local nameText = {}

	if ( queue.queueType == "lfg" ) then
		for i, lfgID in ipairs(queue.lfgIDs) do
			local name, typeID, subtypeID, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel, expansionLevel, groupID, textureFilename, difficulty, maxPlayers, description, isHoliday, _, _, isTimeWalker = GetLFGDungeonInfo(lfgID)
			if ( typeID == TYPEID_RANDOM_DUNGEON or isTimeWalker or isHoliday ) then
				-- Name remains unchanged
			elseif ( subtypeID == LFG_SUBTYPEID_DUNGEON ) then
				name = SOCIAL_QUEUE_FORMAT_DUNGEON:format(name)
			elseif ( subtypeID == LFG_SUBTYPEID_HEROIC ) then
				name = SOCIAL_QUEUE_FORMAT_HEROIC_DUNGEON:format(name)
			elseif ( subtypeID == LFG_SUBTYPEID_RAID ) then
				name = SOCIAL_QUEUE_FORMAT_RAID:format(name)
			elseif ( subtypeID == LFG_SUBTYPEID_FLEXRAID ) then
				name = SOCIAL_QUEUE_FORMAT_RAID:format(name)
			elseif ( subtypeID == LFG_SUBTYPEID_WORLDPVP ) then
				name = SOCIAL_QUEUE_FORMAT_WORLDPVP:format(name)
			else
				-- Name remains unchanged
			end

			AppendQueueName(nameText, name, nameFormatter)
		end
	elseif ( queue.queueType == "pvp" ) then
		local battlefieldType = queue.battlefieldType
		local isBrawl = queue.isBrawl
		local name = queue.mapName
		if (isBrawl) then
			local brawlInfo = C_PvPGetBrawlInfo()
			if (brawlInfo and brawlInfo.active) then
				name = brawlInfo.name
			end
		elseif ( battlefieldType == "BATTLEGROUND" ) then
			name = SOCIAL_QUEUE_FORMAT_BATTLEGROUND:format(name)
		elseif ( battlefieldType == "ARENA" ) then
			name = SOCIAL_QUEUE_FORMAT_ARENA:format(queue.teamSize)
		elseif ( battlefieldType == "ARENASKIRMISH" ) then
			name = SOCIAL_QUEUE_FORMAT_ARENA_SKIRMISH
		end

		AppendQueueName(nameText, name, nameFormatter)
	elseif ( queue.queueType == "lfglist" ) then
		local name
		if ( queue.lfgListID ) then
			name = select(3, C_LFGListGetSearchResultInfo(queue.lfgListID))
		else
			if ( queue.activityID ) then
				name = C_LFGListGetActivityInfo(queue.activityID)
			end
		end

		AppendQueueName(nameText, name, nameFormatter)
	end

	return nameText
end

local function colorName(name)
	local color = "|cff00c0fa%s |r"
	return (color):format(name)
end

local IGNORE_EVENTS_TIME = 10 --seconds
local timeOfEvent
function NF:SOCIAL_QUEUE_UPDATE(event, guid, numAddedItems)
	if not E.db.mui.general.Notification.quickJoin or InCombatLockdown() then return end
	if ( event == "SOCIAL_QUEUE_UPDATE" ) then
		if ( time() - timeOfEvent <= IGNORE_EVENTS_TIME ) then
			return
		end

		if ( numAddedItems == 0 or C_SocialQueueGetGroupMembers(guid) == nil) then
			return
		end

		local members, playerName, color = nil, '', ''
		if C_SocialQueueGetGroupMembers(guid) ~= nil then
			members = SocialQueueUtil_SortGroupMembers(C_SocialQueueGetGroupMembers(guid))
			playerName, color = SocialQueueUtil_GetNameAndColor(members[1])
		end
		local coloredPlayerName = color..playerName.."|r"

		local queues = C_SocialQueueGetGroupQueues(guid)
		if queues ~= nil then
			if ( queues[1].queueData.queueType == "lfglist" ) then
				if ( queues[1].eligible ) then
					--lfglist groups can't queue in the regular LFG tool, so we only need to check this queue
					local queue = queues[1]

					local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers = C_LFGListGetSearchResultInfo(queue.queueData.lfgListID)
					local activityName, shortName, categoryID, groupID, minItemLevel, filters, minLevel, maxPlayers, displayType, _, useHonorLevel = C_LFGListGetActivityInfo(activityID)

					--ignore groups created by the addon World Quest Group Finder
					if ( find(comment, "World Quest Group Finder") ) then
						return
					end

					--create flavor text
					local friendIsLeader = checkIfLeader(leaderName, playerName)
					local flavorText = ""
					if friendIsLeader then
						flavorText = L["is looking for members: "]
					else
						flavorText = L["joined a group: "]
					end

					NF:DisplayToast(coloredPlayerName, flavorText.. activityName ..": ".. colorName(name), ToggleQuickJoinPanel, "Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend")
				end
			else
				--maybe several queues, concat all of them for displaying
				local queueSummaryName = ""
				local anyEligibleQueue = false
				for id, queue in pairs(queues) do
					if ( queue.eligible ) then
						anyEligibleQueue = true
						local queueNameTable = GetQueueName(queue.queueData)
						local queueName = ""
						for queueId, name in pairs(queueNameTable) do
							if queueName == "" then
								queueName = name
							else
								queueName = queueName..", "..name
							end
						end
						if ( queueSummaryName == "" ) then
							queueSummaryName = queueName
						else
							queueSummaryName = queueSummaryName..", "..queueName
						end
					end
				end
				if ( anyEligibleQueue ) then
					NF:DisplayToast(coloredPlayerName, L["is queued for: "].. colorName(queueSummaryName), ToggleQuickJoinPanel, "Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend")
				end
			end
		end
	end
end

function NF:Initialize()
	if E.db.mui.general.Notification.enable ~= true or InCombatLockdown() then return end

	anchorFrame = CreateFrame("Frame", nil, E.UIParent)
	anchorFrame:SetSize(bannerWidth, 50)
	anchorFrame:SetPoint("TOP", 0, -80)
	E:CreateMover(anchorFrame, "Notification Mover", L["Notification Mover"], true, nil, "ALL,GENERAL,SOLO")

	timeOfEvent = time()

	self:RegisterEvent("UPDATE_PENDING_MAIL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	self:RegisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("VIGNETTE_ADDED")
	self:RegisterEvent("RESURRECT_REQUEST")
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("SOCIAL_QUEUE_UPDATE")
end

local function InitializeCallback()
	NF:Initialize()
end

E:RegisterModule(NF:GetName(), InitializeCallback)