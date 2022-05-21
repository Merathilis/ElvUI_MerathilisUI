local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Notification')
local MERS = MER:GetModule('MER_Skins')
local CH = E:GetModule('Chat')
local S = E:GetModule('Skins')

-- Credits RealUI
local _G = _G
local select, unpack, type, pairs, ipairs, tostring, next = select, unpack, type, pairs, ipairs, tostring, next
local table = table
local tinsert, tremove = table.insert, table.remove
local floor = math.floor
local format, find, sub = string.format, string.find, string.sub

local CreateFrame = CreateFrame
local UnitIsAFK = UnitIsAFK
local HasNewMail = HasNewMail
local GetFactionInfoByID = GetFactionInfoByID
local GetQuestLogCompletionText = GetQuestLogCompletionText
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemDurability = GetInventoryItemDurability
local GetTime = GetTime
local C_Texture_GetAtlasInfo = C_Texture.GetAtlasInfo
local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
local C_Calendar_GetNumGuildEvents = C_Calendar and C_Calendar.GetNumGuildEvents
local C_Calendar_GetGuildEventInfo = C_Calendar and C_Calendar.GetGuildEventInfo
local C_Calendar_GetNumDayEvents = C_Calendar and C_Calendar.GetNumDayEvents
local C_Calendar_GetDayEvent = C_Calendar and C_Calendar.GetDayEvent
local C_Calendar_GetNumPendingInvites = C_Calendar and C_Calendar.GetNumPendingInvites
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_Scenario_GetInfo = C_Scenario and C_Scenario.GetInfo
local C_VignetteInfo_GetVignetteInfo = C_VignetteInfo and C_VignetteInfo.GetVignetteInfo
local C_QuestLog_GetLogIndexForQuestID =C_QuestLog.GetLogIndexForQuestID
local C_LFGList_GetAvailableRoles = C_LFGList.GetAvailableRoles
local InCombatLockdown = InCombatLockdown
local LoadAddOn = LoadAddOn
local PlaySoundFile = PlaySoundFile
local PlaySound = PlaySound
local C_Timer = C_Timer
local CreateAnimationGroup = CreateAnimationGroup
local SlashCmdList = SlashCmdList
local ShowUIPanel = ShowUIPanel
local IsInGroup, IsInRaid, IsPartyLFG = IsInGroup, IsInRaid, IsPartyLFG
local MAIL_LABEL = MAIL_LABEL
local HAVE_MAIL = HAVE_MAIL
local UNKNOWN = UNKNOWN
local LFG_LIST_AND_MORE = LFG_LIST_AND_MORE
local SocialQueueUtil_GetQueueName = SocialQueueUtil_GetQueueName
local SocialQueueUtil_GetRelationshipInfo = SocialQueueUtil_GetRelationshipInfo
local C_SocialQueue_GetGroupMembers = C_SocialQueue and C_SocialQueue.GetGroupMembers
local C_SocialQueue_GetGroupQueues = C_SocialQueue and C_SocialQueue.GetGroupQueues
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetActivityInfo = C_LFGList.GetActivityInfoTable
local TANK, HEALER, DAMAGER = TANK, HEALER, DAMAGER

local bannerWidth = 255
local bannerHeight = 68
local max_active_toasts = 3
local fadeout_delay = 5
local toasts = {}
local activeToasts = {}
local queuedToasts = {}
local anchorFrame

local SOCIAL_QUEUE_QUEUED_FOR = _G.SOCIAL_QUEUE_QUEUED_FOR:gsub(':%s?$','') --some language have `:` on end

local VignetteExclusionMapIDs = {
	[579] = true, -- Lunarfall: Alliance garrison
	[585] = true, -- Frostwall: Horde garrison
	[646] = true, -- Scenario: The Broken Shore
}

local VignetteBlackListIDs = {
	[4024] = true, -- Soul Cage (The Maw and Torghast)
	[4578] = true, -- Gateway to Hero's Rest (Bastion)
	[4583] = true, -- Gateway to Hero's Rest (Bastion)
	[4553] = true, -- Recoverable Corpse (The Maw)
	[4581] = true, -- Grappling Growth (Maldraxxus)
	[4582] = true, -- Ripe Purian (Bastion)
	[4602] = true, -- Aimless Soul (The Maw)
	[4617] = true, -- Imprisoned Soul (The Maw)
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
	local db = E.db.mui.notification

	toast = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	toast:SetFrameStrata("HIGH")
	toast:SetSize(bannerWidth, bannerHeight)
	toast:SetPoint("TOP", E.UIParent, "TOP")
	toast:Hide()
	MERS:CreateBD(toast, .45)
	toast:Styling()
	MER:CreateBackdropShadow(toast, true)
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

	local title = F.CreateText(toast, "OVERLAY")
	title:SetShadowOffset(1, -1)
	title:SetPoint("TOPLEFT", sep, "TOPRIGHT", 3, 3)
	title:SetPoint("TOP", toast, "TOP", 0, 0)
	title:SetJustifyH("LEFT")
	title:SetNonSpaceWrap(true)
	F.SetFontDB(title, db.titleFont)
	toast.title = title

	local text = F.CreateText(toast, "OVERLAY")
	text:SetShadowOffset(1, -1)
	text:SetPoint("BOTTOMLEFT", sep, "BOTTOMRIGHT", 3, 20)
	text:SetPoint("RIGHT", toast, -9, 0)
	text:SetJustifyH("LEFT")
	text:SetWidth(toast:GetRight() - sep:GetLeft() - 5)
	F.SetFontDB(text, db.textFont)
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
	module:DisplayToast(MER:cOption("MerathilisUI:", 'gradient'), L["This is an example of a notification."], testCallback, b == "true" and "INTERFACE\\ICONS\\SPELL_FROST_ARCTICWINDS" or nil, .08, .92, .08, .92)
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
				PlaySoundFile([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Sounds\mail.mp3]])
			end
		end
	end
end

local showRepair = true
local Slots = {
	[1] = {1, _G.INVTYPE_HEAD, 1000},
	[2] = {3, _G.INVTYPE_SHOULDER, 1000},
	[3] = {5, _G.INVTYPE_ROBE, 1000},
	[4] = {6, _G.INVTYPE_WAIST, 1000},
	[5] = {9, _G.INVTYPE_WRIST, 1000},
	[6] = {10, _G.INVTYPE_HAND, 1000},
	[7] = {7, _G.INVTYPE_LEGS, 1000},
	[8] = {8, _G.INVTYPE_FEET, 1000},
	[9] = {16, _G.INVTYPE_WEAPONMAINHAND, 1000},
	[10] = {17, _G.INVTYPE_WEAPONOFFHAND, 1000},
	[11] = {18, _G.INVTYPE_RANGED, 1000}
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
		self:DisplayToast(_G.MINIMAP_TRACKING_REPAIR, format(L["%s slot needs to repair, current durability is %d."], Slots[1][2], value))
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
	if not E.Retail then return end
	if not _G.CalendarFrame then LoadAddOn("Blizzard_Calendar") end
	ShowUIPanel(_G.CalendarFrame)
end

local function alertEvents()
	if module.db.enable ~= true or module.db.invites ~= true then return end
	if _G.CalendarFrame and _G.CalendarFrame:IsShown() then return end
	local num = C_Calendar_GetNumPendingInvites()
	if num ~= numInvites then
		if num > 0 then
			module:DisplayToast(_G.CALENDAR, L["You have %s pending calendar |4invite:invites;."]:format(num), toggleCalendar)
		end
		numInvites = num
	end
end

local function alertGuildEvents()
	if module.db.enable ~= true or module.db.guildEvents ~= true then return end
	if _G.CalendarFrame and _G.CalendarFrame:IsShown() then return end
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
	if not E.Retail then return end

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
	if inGroup or inRaid or inPartyLFG then return end

	if onMinimap then
		local vignetteInfo = C_VignetteInfo_GetVignetteInfo(vignetteGUID)
		if not vignetteInfo then return end
		--MER:Print("Vignette-ID:"..vignetteInfo.vignetteID, "Vignette-Name:"..vignetteInfo.name)
		if VignetteBlackListIDs[vignetteInfo.vignetteID] then return end

		if vignetteInfo and vignetteGUID ~= self.lastMinimapRare.id then
			vignetteInfo.name = format("|cff00c0fa%s|r", vignetteInfo.name:utf8sub(1, 28))
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

-- Credits: Paragon Reputation
local PARAGON_QUEST_ID = { --[questID] = {factionID}
	--Legion
	[48976] = {2170}, -- Argussian Reach
	[46777] = {2045}, -- Armies of Legionfall
	[48977] = {2165}, -- Army of the Light
	[46745] = {1900}, -- Court of Farondis
	[46747] = {1883}, -- Dreamweavers
	[46743] = {1828}, -- Highmountain Tribes
	[46748] = {1859}, -- The Nightfallen
	[46749] = {1894}, -- The Wardens
	[46746] = {1948}, -- Valarjar

	--Battle for Azeroth
	--Neutral
	[54453] = {2164}, --Champions of Azeroth
	[58096] = {2415}, --Rajani
	[55348] = {2391}, --Rustbolt Resistance
	[54451] = {2163}, --Tortollan Seekers
	[58097] = {2417}, --Uldum Accord

	--Horde
	[54460] = {2156}, --Talanji's Expedition
	[54455] = {2157}, --The Honorbound
	[53982] = {2373}, --The Unshackled
	[54461] = {2158}, --Voldunai
	[54462] = {2103}, --Zandalari Empire

	--Alliance
	[54456] = {2161}, --Order of Embers
	[54458] = {2160}, --Proudmoore Admiralty
	[54457] = {2162}, --Storm's Wake
	[54454] = {2159}, --The 7th Legion
	[55976] = {2400}, --Waveblade Ankoan

	--Shadowlands
	[61100] = {2413}, --Court of Harvesters
	[61097] = {2407}, --The Ascended
	[61095] = {2410}, --The Undying Army
	[61098] = {2465}, --The Wild Hunt
	[64012] = {2470}, --The Death Advance
	[64266] = {2472}, --The Archivist's Codex
	[64267] = {2432}, --Ve'nari
	[64867] = {2478}, --The Enlightened
}

function module:QUEST_ACCEPTED(_, questID)
	if module.db.paragon and PARAGON_QUEST_ID[questID] then
		local name = format("|cff00c0fa%s|r", GetFactionInfoByID(PARAGON_QUEST_ID[questID][1])) or UNKNOWN
		local text = GetQuestLogCompletionText(C_QuestLog_GetLogIndexForQuestID(questID))
		PlaySound(618, "Master") -- QUEST ADDED
		self:DisplayToast(name, text, nil, "Interface\\Icons\\Achievement_Quests_Completed_08", .08, .92, .08, .92)
	end
end

function module:SocialQueueEvent(_, guid, numAddedItems)
	if not module.db.quickJoin or InCombatLockdown() then return end
	if numAddedItems == 0 or not guid then return end

	local players = C_SocialQueue_GetGroupMembers(guid)
	if not players then return end

	local firstMember, numMembers, extraCount, coloredName = players[1], #players, ''
	local playerName, nameColor = SocialQueueUtil_GetRelationshipInfo(firstMember.guid, nil, firstMember.clubId)
	if numMembers > 1 then
		extraCount = format(' +%s', numMembers - 1)
	end
	if playerName and playerName ~= '' then
		coloredName = format('%s%s|r%s', nameColor, playerName, extraCount)
	else
		coloredName = format('{%s%s}', UNKNOWN, extraCount)
	end

	local queues = C_SocialQueue_GetGroupQueues(guid)
	local firstQueue = queues and queues[1]
	local isLFGList = firstQueue and firstQueue.queueData and firstQueue.queueData.queueType == 'lfglist'

	if isLFGList and firstQueue and firstQueue.eligible then
		local activityID, name, leaderName, fullName, isLeader

		if firstQueue.queueData.lfgListID then
			local searchResultInfo = C_LFGList_GetSearchResultInfo(firstQueue.queueData.lfgListID)
			if searchResultInfo then
				activityID, name, leaderName = searchResultInfo.activityID, searchResultInfo.name, searchResultInfo.leaderName
				isLeader = CH:SocialQueueIsLeader(playerName, leaderName)
			end
		end

		if activityID or firstQueue.queueData.activityID then
			fullName = C_LFGList_GetActivityInfoTable(activityID or firstQueue.queueData.activityID)
		end

		if name then
			if not E.db.chat.socialQueueMessages then
				self:DisplayToast(coloredName, format('%s: [%s] |cff00CCFF%s|r', (isLeader and L["is looking for members"]) or L["joined a group"], fullName or UNKNOWN, name), _G.ToggleQuickJoinPanel, "Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend", .08, .92, .08, .92)
			end
		else
			if not E.db.chat.socialQueueMessages then
				self:DisplayToast(coloredName, format('%s: |cff00CCFF%s|r', (isLeader and L["is looking for members"]) or L["joined a group"], fullName or UNKNOWN), _G.ToggleQuickJoinPanel, "Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend", .08, .92, .08, .92)
			end
		end
	elseif firstQueue then
		local output, outputCount, queueCount, queueName = '', '', 0
		for _, queue in pairs(queues) do
			if type(queue) == "table" and queue.eligible then
				queueName = (queue.queueData and SocialQueueUtil_GetQueueName(queue.queueData)) or ""
				if queueName ~= "" then
					if output == "" then
						output = queueName:gsub("\n.+","") -- grab only the first queue name
						queueCount = queueCount + select(2, queueName:gsub("\n","")) -- collect additional on single queue
					else
						queueCount = queueCount + 1 + select(2, queueName:gsub("\n","")) -- collect additional on additional queues
					end
				end
			end
		end

		if output ~= "" then
			if queueCount > 0 then outputCount = format(LFG_LIST_AND_MORE, queueCount) end
			if not E.db.chat.socialQueueMessages then
				self:DisplayToast(coloredName, format('%s: |cff00CCFF%s|r %s', SOCIAL_QUEUE_QUEUED_FOR, output, outputCount), _G.ToggleQuickJoinPanel, "Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend", .08, .92, .08, .92)
			end
		end
	end
end

local LFG_Timer = 0
function module:LFG_UPDATE_RANDOM_INFO()
	if not module.db.callToArms then return end

	local _, forTank, forHealer, forDamage = GetLFGRoleShortageRewards(2087, _G.LFG_ROLE_SHORTAGE_RARE) -- 2087 Random Shadowlands Heroic
	local IsTank, IsHealer, IsDamage = C_LFGList_GetAvailableRoles()

	local ingroup, tank, healer, damager, result

	tank = IsTank and forTank and "|cff00B2EE"..TANK.."|r" or ""
	healer = IsHealer and forHealer and "|cff00EE00"..HEALER.."|r" or ""
	damager = IsDamage and forDamage and "|cffd62c35"..DAMAGER.."|r" or ""

	if IsInGroup(_G.LE_PARTY_CATEGORY) or IsInGroup(_G.LE_PARTY_CATEGORY_INSTANCE) then
		ingroup = true
	end

	if ((IsTank and forTank) or (IsHealer and forHealer) or (IsDamage and forDamage)) and not ingroup then
		if GetTime() - LFG_Timer > 20 then
			self:DisplayToast(format(_G.LFG_CALL_TO_ARMS, tank.." "..healer.." "..damager), nil, nil, "Interface\\Icons\\Ability_DualWield", .08, .92, .08, .92)
			LFG_Timer = GetTime()
		end
	end
end

function module:Initialize()
	module.db = E.db.mui.notification
	if not module.db.enable then return end

	anchorFrame = CreateFrame("Frame", nil, E.UIParent)
	anchorFrame:SetSize(bannerWidth, 50)
	anchorFrame:SetPoint("TOP", 0, -80)
	E:CreateMover(anchorFrame, "MER_NotificationMover", L["Notification Mover"], nil, nil, nil, "ALL,SOLO,MERATHILISUI", nil, 'mui,modules,Notification')

	self:RegisterEvent("UPDATE_PENDING_MAIL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	if E.Retail then
		self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
		self:RegisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")
		self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
		self:RegisterEvent("SOCIAL_QUEUE_UPDATE", 'SocialQueueEvent')
		self:RegisterEvent("LFG_UPDATE_RANDOM_INFO")
	end
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	self:RegisterEvent("QUEST_ACCEPTED")

	self.lastMinimapRare = {time = 0, id = nil}
end

MER:RegisterModule(module:GetName())
