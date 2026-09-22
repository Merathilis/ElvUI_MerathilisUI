local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_MinimapButtons")

local _G = _G
local ipairs, pairs, format = ipairs, pairs, string.format
local max, sort, strfind = math.max, table.sort, string.find

local CreateFrame = CreateFrame
local GetGameTime = GetGameTime
local HasNewMail = HasNewMail
local GetLatestThreeSenders = GetLatestThreeSenders
local GetNumSavedInstances = GetNumSavedInstances
local GetSavedInstanceInfo = GetSavedInstanceInfo
local GetDifficultyInfo = GetDifficultyInfo
local RequestRaidInfo = RequestRaidInfo
local SecondsToTime = SecondsToTime
local ToggleCalendar = ToggleCalendar
local issecretvalue = issecretvalue
local C_AddOns = C_AddOns
local C_WeeklyRewards = C_WeeklyRewards
local C_Timer = C_Timer
local C_Texture = C_Texture
local C_CVar = C_CVar
local C_DateAndTime = C_DateAndTime
local C_CraftingOrders = C_CraftingOrders
local Enum = Enum

local HAVE_MAIL = HAVE_MAIL
local HAVE_MAIL_FROM = HAVE_MAIL_FROM
local MAILFRAME_CRAFTING_ORDERS_TOOLTIP_TITLE = MAILFRAME_CRAFTING_ORDERS_TOOLTIP_TITLE
local PERSONAL_CRAFTING_ORDERS_AVAIL_FMT = PERSONAL_CRAFTING_ORDERS_AVAIL_FMT
local TIMEMANAGER_TOOLTIP_REALMTIME = TIMEMANAGER_TOOLTIP_REALMTIME
local TRACKING = TRACKING

local Minimap = _G.Minimap

-- first: where the leading button sits on the holder; point/rel/x/y: how each
-- following button hangs off its predecessor, scaled by the spacing setting.
local GROWTH = {
	DOWN = { first = "TOP", point = "TOP", rel = "BOTTOM", x = 0, y = -1 },
	UP = { first = "BOTTOM", point = "BOTTOM", rel = "TOP", x = 0, y = 1 },
	RIGHT = { first = "LEFT", point = "LEFT", rel = "RIGHT", x = 1, y = 0 },
	LEFT = { first = "RIGHT", point = "RIGHT", rel = "LEFT", x = -1, y = 0 },
}

-- Two independent bars, as in the original: the "main" bar carries the Great
-- Vault and the M+ portals, the "elements" bar the Blizzard indicators. The main
-- bar keeps its settings at the top level so existing profiles keep their layout.
local BAR_HOLDER = { main = "holder", elements = "elementHolder" }

local function BarDB(bar)
	local db = module.db
	if not db then
		return nil
	end

	return (bar == "elements" and db.elements) or db
end

-- Opens away from the minimap: a bar anchored on the right side grows its menus
-- and flyouts to the right, everything else to the left.
local function GrowsRight(bar)
	local cfg = BarDB(bar)
	return cfg and strfind(cfg.point, "RIGHT") ~= nil
end

-- The bar grows upwards, so menus and flyouts have to open upwards as well.
local function GrowsUp(bar)
	local cfg = BarDB(bar)
	return cfg and cfg.growth == "UP"
end

local GREAT_VAULT_ATLAS = "greatVault-whole-normal"
local PORTAL_ICON = [[Interface\Icons\Spell_Arcane_PortalDalaran]]

-------------------------------------------------------------------------------
-- Great Vault button
-------------------------------------------------------------------------------
local function GetVaultTokenColor(state)
	if state == "done" then
		return 0.176, 0.796, 0.349
	elseif state == "partial" then
		return 0.812, 0.592, 0.212
	end

	return 0.58, 0.58, 0.58
end

local function BuildVaultLine(activityType, isRaid)
	local activities = C_WeeklyRewards and C_WeeklyRewards.GetActivities and C_WeeklyRewards.GetActivities(activityType)
	local parts = {}

	for i = 1, 3 do
		local info = activities and activities[i]
		local text, state = "-", "empty"

		if info then
			local progress = (info.progress and info.progress > 0) and info.progress or 0
			local threshold = (info.threshold and info.threshold > 0) and info.threshold or 0
			local level = (info.level and info.level > 0) and info.level or 0

			if threshold > 0 then
				if progress >= threshold then
					state = "done"
					text = (not isRaid and level > 0) and ("+" .. level) or format("%d/%d", progress, threshold)
				else
					state = progress > 0 and "partial" or "empty"
					text = format("%d/%d", progress, threshold)
				end
			end
		end

		local r, g, b = GetVaultTokenColor(state)
		parts[i] = ("|cff%02x%02x%02x%s|r"):format(r * 255, g * 255, b * 255, text)
	end

	return table.concat(parts, "  ")
end

local function ShowVaultTooltip(self)
	local raidType = (Enum.WeeklyRewardChestThresholdType and Enum.WeeklyRewardChestThresholdType.Raid) or 3
	local dungeonType = (Enum.WeeklyRewardChestThresholdType and Enum.WeeklyRewardChestThresholdType.Activities) or 1
	local worldType = (Enum.WeeklyRewardChestThresholdType and Enum.WeeklyRewardChestThresholdType.World) or 6

	_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	_G.GameTooltip:AddLine(L["Great Vault"])
	_G.GameTooltip:AddDoubleLine(L["Raids"], BuildVaultLine(raidType, true), 0.8, 0.8, 0.8)
	_G.GameTooltip:AddDoubleLine(L["Mythic+"], BuildVaultLine(dungeonType, false), 0.8, 0.8, 0.8)
	_G.GameTooltip:AddDoubleLine(L["World"], BuildVaultLine(worldType, false), 0.8, 0.8, 0.8)
	_G.GameTooltip:Show()
end

local function ToggleGreatVault()
	local IsLoaded = C_AddOns and C_AddOns.IsAddOnLoaded
	local Load = C_AddOns and C_AddOns.LoadAddOn
	if Load and IsLoaded and not IsLoaded("Blizzard_WeeklyRewards") then
		Load("Blizzard_WeeklyRewards")
	end

	if _G.WeeklyRewardsFrame then
		_G.WeeklyRewardsFrame:SetShown(not _G.WeeklyRewardsFrame:IsShown())
	end
end

-- Pulses the icon's alpha and grows the whole button while at least one weekly reward is ready to claim.
local function UpdateGreatVaultPulse(btn)
	local hasRewards = btn.testPulse
		or (C_WeeklyRewards and C_WeeklyRewards.HasAvailableRewards and C_WeeklyRewards.HasAvailableRewards())

	if hasRewards then
		if not btn.PulseGroup:IsPlaying() then
			btn.PulseGroup:Play()
		end
		if not btn.ScaleGroup:IsPlaying() then
			btn.ScaleGroup:Play()
		end
	else
		if btn.PulseGroup:IsPlaying() then
			btn.PulseGroup:Stop()
			btn.Icon:SetAlpha(1)
		end
		if btn.ScaleGroup:IsPlaying() then
			btn.ScaleGroup:Stop()
			btn:SetScale(1)
		end
	end
end

local TEST_PULSE_DURATION = 5

-- Lets users preview the pulse animation from the options without waiting for an actual reward.
function module:TestGreatVaultPulse()
	local btn = self.greatVaultButton
	if not btn then
		return
	end

	if self.testPulseTimer then
		self.testPulseTimer:Cancel()
	end

	btn.testPulse = true
	UpdateGreatVaultPulse(btn)

	self.testPulseTimer = C_Timer.NewTimer(TEST_PULSE_DURATION, function()
		btn.testPulse = nil
		self.testPulseTimer = nil
		UpdateGreatVaultPulse(btn)
	end)
end

local PULSE_DURATION = 0.8
local PULSE_MAX_SCALE = 1.35

local function CreateGreatVaultButton(parent)
	local btn = CreateFrame("Button", "MER_MinimapGreatVaultButton", parent)
	btn:EnableMouse(true)
	btn:SetTemplate("Transparent")

	local icon = btn:CreateTexture(nil, "ARTWORK")
	icon:SetAtlas(GREAT_VAULT_ATLAS)
	icon:SetPoint("TOPLEFT", 2, -2)
	icon:SetPoint("BOTTOMRIGHT", -2, 2)
	btn.Icon = icon

	local pulse = icon:CreateAnimationGroup()
	pulse:SetLooping("BOUNCE")
	local pulseAlpha = pulse:CreateAnimation("Alpha")
	pulseAlpha:SetFromAlpha(1)
	pulseAlpha:SetToAlpha(0.35)
	pulseAlpha:SetDuration(PULSE_DURATION)
	pulseAlpha:SetSmoothing("IN_OUT")
	btn.PulseGroup = pulse

	-- Grows the whole button so the pulse reads at a glance.
	local scaleGroup = btn:CreateAnimationGroup()
	scaleGroup:SetLooping("BOUNCE")
	local scaleAnim = scaleGroup:CreateAnimation("Scale")
	scaleAnim:SetOrigin("CENTER", 0, 0)
	scaleAnim:SetScaleFrom(1, 1)
	scaleAnim:SetScaleTo(PULSE_MAX_SCALE, PULSE_MAX_SCALE)
	scaleAnim:SetDuration(PULSE_DURATION)
	scaleAnim:SetSmoothing("IN_OUT")
	btn.ScaleGroup = scaleGroup

	btn:SetScript("OnEnter", function(self)
		self.Icon:SetVertexColor(1, 1, 1)
		ShowVaultTooltip(self)
	end)
	btn:SetScript("OnLeave", function(self)
		self.Icon:SetVertexColor(0.85, 0.85, 0.85)
		_G.GameTooltip:Hide()
	end)
	btn:SetScript("OnClick", ToggleGreatVault)

	btn:RegisterEvent("WEEKLY_REWARDS_UPDATE")
	btn:RegisterEvent("PLAYER_ENTERING_WORLD")
	btn:SetScript("OnEvent", UpdateGreatVaultPulse)

	icon:SetVertexColor(0.85, 0.85, 0.85)
	UpdateGreatVaultPulse(btn)

	return btn
end

-------------------------------------------------------------------------------
-- Mythic+ Portals button (the flyout itself is shared, see F.PortalFlyout)
-------------------------------------------------------------------------------
local function TogglePortalFlyout(anchorBtn)
	local edge = GrowsRight(anchorBtn.bar) and "LEFT" or "RIGHT"
	local gap = F.Dpi(4)

	if GrowsUp(anchorBtn.bar) then
		F.PortalFlyout.Toggle(anchorBtn, "BOTTOM" .. edge, "TOP" .. edge, 0, gap)
	else
		F.PortalFlyout.Toggle(anchorBtn, "TOP" .. edge, "BOTTOM" .. edge, 0, -gap)
	end
end

local function CreatePortalButton(parent)
	local btn = CreateFrame("Button", "MER_MinimapPortalButton", parent)
	btn:EnableMouse(true)
	btn:SetTemplate("Transparent")

	local icon = btn:CreateTexture(nil, "ARTWORK")
	icon:SetTexture(PORTAL_ICON)
	icon:SetPoint("TOPLEFT", 2, -2)
	icon:SetPoint("BOTTOMRIGHT", -2, 2)
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	btn.Icon = icon

	btn:SetScript("OnEnter", function(self)
		self.Icon:SetVertexColor(1, 1, 1)
		if F.PortalFlyout.IsShown() then
			return
		end
		_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		_G.GameTooltip:AddLine(L["M+ Portals"])
		_G.GameTooltip:Show()
	end)
	btn:SetScript("OnLeave", function(self)
		self.Icon:SetVertexColor(0.85, 0.85, 0.85)
		_G.GameTooltip:Hide()
	end)
	btn:SetScript("OnClick", function(self)
		TogglePortalFlyout(self)
	end)

	icon:SetVertexColor(0.85, 0.85, 0.85)

	return btn
end

-------------------------------------------------------------------------------
-- Indicator buttons: tracking, calendar, mail and crafting orders.
-- These are our own buttons with our own handlers. The Blizzard frames are only
-- muted while a replacement is enabled -- never reparented -- so nothing fights
-- ElvUI's minimap layout and no protected frame is moved.
-------------------------------------------------------------------------------
local TRACKING_ATLAS = {
	"UI-HUD-Minimap-Tracking-Up",
	"UI-HUD-Minimap-Tracking-Mouseover",
	"UI-HUD-Minimap-Tracking-Down",
}
local MAIL_ATLAS = { "UI-HUD-Minimap-Mail-Up", "UI-HUD-Minimap-Mail-Mouseover" }
local CRAFTING_ATLAS = {
	"UI-HUD-Minimap-CraftingOrder-Up-2x",
	"UI-HUD-Minimap-CraftingOrder-Over-2x",
	"UI-HUD-Minimap-CraftingOrder-Down-2x",
}

-- Blizzard frames we mute, with their original alpha/mouse state so a disabled
-- MER button hands them back untouched.
local _mutedIndicators = {}

local function SetIndicatorMuted(frame, muted)
	if not frame then
		return
	end

	if muted then
		if not _mutedIndicators[frame] then
			_mutedIndicators[frame] = { alpha = frame:GetAlpha(), mouse = frame:IsMouseEnabled() }
		end
		frame:SetAlpha(0)
		frame:EnableMouse(false)
	else
		local saved = _mutedIndicators[frame]
		if saved then
			frame:SetAlpha(saved.alpha)
			frame:EnableMouse(saved.mouse)
			_mutedIndicators[frame] = nil
		end
	end
end

-- Sizes an atlas icon inside the button without distorting it: the native atlas
-- dimensions decide the aspect ratio, so Blizzard can reshape an atlas without
-- leaving a stretched icon behind.
local function SizeAtlasIcon(icon, atlas, btnSize, inset, scale)
	local avail = max(btnSize - inset * 2, 1)
	local info = atlas and C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(atlas)
	local ratio = (info and info.width and info.height and info.height > 0) and (info.width / info.height) or 1

	scale = scale or 1
	if ratio >= 1 then
		icon:SetSize(avail * scale, (avail / ratio) * scale)
	else
		icon:SetSize((avail * ratio) * scale, avail * scale)
	end
end

local function CreateIndicatorButton(parent, name, atlases, onClick)
	local btn = CreateFrame("Button", "MER_Minimap" .. name .. "Button", parent)
	btn:EnableMouse(true)
	btn:SetTemplate("Transparent")

	local icon = btn:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("CENTER")
	btn.Icon = icon

	btn.upAtlas, btn.overAtlas, btn.downAtlas = atlases[1], atlases[2], atlases[3]
	btn.iconScale = atlases.scale
	icon:SetAtlas(btn.upAtlas)

	-- Called from UpdateLayout so a size change re-fits the icon.
	btn.UpdateIcon = function(self, size)
		SizeAtlasIcon(self.Icon, self.upAtlas, size, F.Dpi(3), self.iconScale)
	end

	btn:SetScript("OnEnter", function(self)
		self.Icon:SetAtlas(self.overAtlas or self.upAtlas)
		if self.ShowTooltip then
			self:ShowTooltip()
		end
	end)
	btn:SetScript("OnLeave", function(self)
		self.Icon:SetAtlas(self.upAtlas)
		_G.GameTooltip:Hide()
	end)
	btn:SetScript("OnMouseDown", function(self)
		self.Icon:SetAtlas(self.downAtlas or self.overAtlas or self.upAtlas)
	end)
	btn:SetScript("OnMouseUp", function(self)
		self.Icon:SetAtlas(self:IsMouseOver() and (self.overAtlas or self.upAtlas) or self.upAtlas)
	end)

	-- Mail and crafting orders stay informational: hover art and tooltip only.
	if onClick then
		btn:SetScript("OnClick", onClick)
	end

	return btn
end

-------------------------------------------------------------------------------
-- Tracking
-------------------------------------------------------------------------------
local function GetBlizzardTrackingButton()
	local tracking = _G.MinimapCluster and _G.MinimapCluster.Tracking
	return tracking and tracking.Button
end

-- Drives Blizzard's own tracking dropdown and only re-anchors the finished menu
-- frame, so the whole filter list stays Blizzard's without us rebuilding it.
local function ToggleTrackingMenu(self)
	local blizBtn = GetBlizzardTrackingButton()
	if not blizBtn or not blizBtn.OpenMenu then
		return
	end

	if blizBtn.menu and blizBtn.menu:IsShown() then
		blizBtn:CloseMenu()
		return
	end

	blizBtn:OpenMenu()

	local menu = blizBtn.menu
	if menu then
		menu:ClearAllPoints()
		if GrowsRight(self.bar) then
			menu:SetPoint("TOPLEFT", self, "TOPRIGHT", F.Dpi(4), 0)
		else
			menu:SetPoint("TOPRIGHT", self, "TOPLEFT", -F.Dpi(4), 0)
		end
	end
end

local function CreateTrackingButton(parent)
	local btn = CreateIndicatorButton(parent, "Tracking", TRACKING_ATLAS, ToggleTrackingMenu)

	btn.ShowTooltip = function(self)
		_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		_G.GameTooltip:AddLine(TRACKING)
		_G.GameTooltip:Show()
	end

	return btn
end

-------------------------------------------------------------------------------
-- Calendar: day-of-month icon plus a raid lockout / reset tooltip
-------------------------------------------------------------------------------
local function GetCalendarDay()
	local now = C_DateAndTime and C_DateAndTime.GetCurrentCalendarTime and C_DateAndTime.GetCurrentCalendarTime()
	return (now and now.monthDay) or 1
end

local function CalendarAtlases(day)
	return {
		format("ui-hud-calendar-%d-up", day),
		format("ui-hud-calendar-%d-mouseover", day),
		format("ui-hud-calendar-%d-down", day),
		scale = 1.25,
	}
end

local LOCKOUT_TIER_ORDER = { lfr = 1, normal = 2, heroic = 3, mythic = 4 }
local LOCKOUT_TIER_COLOR = {
	lfr = { 0.6, 0.6, 0.6 },
	normal = { 0.4, 0.8, 0.4 },
	heroic = { 0.25, 0.6, 1 },
	mythic = { 0.64, 0.21, 0.93 },
}

-- Tier and display label for one saved instance. Everything comes from the
-- save's own live data, never from a hardcoded difficulty ID list, which rots
-- as Blizzard adds difficulties.
local function LockoutTierAndLabel(difficulty, fallbackLabel)
	local tier, label = "normal", fallbackLabel

	if GetDifficultyInfo and difficulty then
		local name, _, isHeroic, _, displayHeroic, displayMythic = GetDifficultyInfo(difficulty)
		label = name or fallbackLabel
		if displayMythic then
			tier = "mythic"
		elseif isHeroic or displayHeroic then
			tier = "heroic"
		end
	end

	local util = _G.DifficultyUtil
	if util and util.ID and (difficulty == util.ID.RaidLFR or difficulty == util.ID.PrimaryRaidLFR) then
		tier = "lfr"
	end

	return tier, label or ""
end

local function GetLockoutEntries()
	if not GetNumSavedInstances or not GetSavedInstanceInfo then
		return
	end

	local entries = {}
	for i = 1, GetNumSavedInstances() do
		local name, _, _, difficulty, locked, extended, _, isRaid, _, difficultyName, numEncounters, encounterProgress =
			GetSavedInstanceInfo(i)
		local held = name and (locked or extended)

		-- Dungeon rows only matter while the hold tracks real encounters; raids always show.
		if held and not isRaid and not (numEncounters and numEncounters > 0) then
			held = false
		end

		if held then
			local tier, diffLabel = LockoutTierAndLabel(difficulty, difficultyName)
			local right = diffLabel
			if numEncounters and numEncounters > 0 and encounterProgress and encounterProgress >= 0 then
				right = format("%s %d/%d", diffLabel, encounterProgress, numEncounters)
			end

			entries[#entries + 1] = {
				name = name,
				tier = tier,
				tierOrder = LOCKOUT_TIER_ORDER[tier] or LOCKOUT_TIER_ORDER.normal,
				right = right,
			}
		end
	end

	if #entries == 0 then
		return
	end

	sort(entries, function(a, b)
		if a.name ~= b.name then
			return a.name < b.name
		end
		return a.tierOrder < b.tierOrder
	end)

	return entries
end

local function GetServerTimeText()
	local hour, minute = GetGameTime()
	if C_CVar.GetCVar("timeMgrUseMilitaryTime") == "1" then
		return format("%02d:%02d", hour, minute)
	end

	local suffix = hour >= 12 and "PM" or "AM"
	hour = hour % 12
	if hour == 0 then
		hour = 12
	end

	return format("%d:%02d %s", hour, minute, suffix)
end

local function GetWeeklyResetText()
	local secs = C_DateAndTime
		and C_DateAndTime.GetSecondsUntilWeeklyReset
		and C_DateAndTime.GetSecondsUntilWeeklyReset()

	return secs and SecondsToTime(secs, true, nil, 3) or ""
end

local function ShowCalendarTooltip(self)
	_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	_G.GameTooltip:AddLine(L["Calendar"])

	-- Lockout reads can hand back secret values inside an active key or raid.
	if not F.InProtectedInstance() then
		if RequestRaidInfo then
			RequestRaidInfo()
		end

		local entries = GetLockoutEntries()
		if entries then
			_G.GameTooltip:AddLine(" ")
			for _, entry in ipairs(entries) do
				local color = LOCKOUT_TIER_COLOR[entry.tier] or LOCKOUT_TIER_COLOR.normal
				_G.GameTooltip:AddDoubleLine(entry.name, entry.right, 1, 1, 1, color[1], color[2], color[3])
			end
		end
	end

	_G.GameTooltip:AddLine(" ")
	_G.GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_REALMTIME, GetServerTimeText(), 0.8, 0.8, 0.8, 1, 1, 1)
	_G.GameTooltip:AddDoubleLine(L["Weekly Reset"], GetWeeklyResetText(), 0.8, 0.8, 0.8, 1, 1, 1)
	_G.GameTooltip:Show()
end

local function CreateCalendarButton(parent)
	local day = GetCalendarDay()
	local btn = CreateIndicatorButton(parent, "Calendar", CalendarAtlases(day), function()
		if ToggleCalendar then
			ToggleCalendar()
		end
	end)

	btn.calendarDay = day
	btn.ShowTooltip = ShowCalendarTooltip

	-- Swaps the icon over midnight; a no-op on every other tick.
	btn.RefreshDay = function(self)
		local today = GetCalendarDay()
		if today == self.calendarDay then
			return false
		end

		local atlases = CalendarAtlases(today)
		self.calendarDay = today
		self.upAtlas, self.overAtlas, self.downAtlas = atlases[1], atlases[2], atlases[3]
		self.Icon:SetAtlas(self:IsMouseOver() and self.overAtlas or self.upAtlas)

		return true
	end

	return btn
end

-------------------------------------------------------------------------------
-- Mail and crafting orders: shown only while there is something to report
-------------------------------------------------------------------------------
local function HasUnreadMail()
	if not HasNewMail then
		return false
	end

	local raw = HasNewMail()
	if issecretvalue and issecretvalue(raw) then
		return false
	end

	return raw and true or false
end

local function GetPersonalOrders()
	local infos = C_CraftingOrders
		and C_CraftingOrders.GetPersonalOrdersInfo
		and C_CraftingOrders.GetPersonalOrdersInfo()

	return (type(infos) == "table" and #infos > 0) and infos or nil
end

local function CreateMailButton(parent)
	local btn = CreateIndicatorButton(parent, "Mail", MAIL_ATLAS, nil)

	btn.ShouldShow = HasUnreadMail
	btn.ShowTooltip = function(self)
		local senders = GetLatestThreeSenders and { GetLatestThreeSenders() } or {}

		_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		_G.GameTooltip:AddLine(#senders > 0 and HAVE_MAIL_FROM or HAVE_MAIL)
		for _, sender in ipairs(senders) do
			_G.GameTooltip:AddLine(sender, 1, 1, 1)
		end
		_G.GameTooltip:Show()
	end

	return btn
end

local function CreateCraftingButton(parent)
	local btn = CreateIndicatorButton(parent, "CraftingOrders", CRAFTING_ATLAS, nil)

	btn.ShouldShow = function()
		return GetPersonalOrders() ~= nil
	end
	btn.ShowTooltip = function(self)
		_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		_G.GameTooltip:AddLine(MAILFRAME_CRAFTING_ORDERS_TOOLTIP_TITLE)
		for _, info in ipairs(GetPersonalOrders() or {}) do
			local line = format(PERSONAL_CRAFTING_ORDERS_AVAIL_FMT, info.numPersonalOrders, info.professionName)
			_G.GameTooltip:AddLine(line, 1, 1, 1)
		end
		_G.GameTooltip:Show()
	end

	return btn
end

-------------------------------------------------------------------------------
-- Layout / lifecycle
-------------------------------------------------------------------------------
function module:UpdateLayout()
	local db = self.db
	if not db or not self.holder or not self.buttons then
		return
	end

	local visible = { main = {}, elements = {} }

	for _, entry in ipairs(self.buttons) do
		local btn = entry.btn
		btn:Hide()
		btn:ClearAllPoints()

		-- Cached so RefreshIndicators can tell an actual change from a quiet tick.
		local available = (not btn.ShouldShow) or (btn.ShouldShow() and true or false)
		btn.available = available

		local settings = db[entry.key]
		if settings and settings.enable and available then
			local size = F.Dpi(BarDB(entry.bar).size)
			btn:SetSize(size, size)
			if btn.UpdateIcon then
				btn:UpdateIcon(size)
			end

			local list = visible[entry.bar]
			list[#list + 1] = btn
		end
	end

	for bar, list in pairs(visible) do
		local cfg = BarDB(bar)
		local holder = self[BAR_HOLDER[bar]]
		local grow = GROWTH[cfg.growth] or GROWTH.DOWN
		local spacing = F.Dpi(cfg.spacing)
		local prev

		for _, btn in ipairs(list) do
			if not prev then
				btn:SetPoint(grow.first, holder, grow.first, 0, 0)
			else
				btn:SetPoint(grow.point, prev, grow.rel, spacing * grow.x, spacing * grow.y)
			end
			btn:Show()
			prev = btn
		end
	end
end

-- Mail and crafting orders come and go on their own, and the calendar icon has
-- to survive midnight, so the stack is rebuilt whenever one of them changes.
function module:RefreshIndicators()
	if not self.db or not self.buttons or not self.holder or not self.holder:IsShown() then
		return
	end

	local changed = self.calendarButton and self.calendarButton:RefreshDay() or false

	for _, entry in ipairs(self.buttons) do
		local btn = entry.btn
		if btn.ShouldShow and (btn.ShouldShow() and true or false) ~= btn.available then
			changed = true
		end
	end

	if changed then
		self:UpdateLayout()
	end
end

function module:UpdatePosition()
	if not self.db or not self.holder then
		return
	end

	for bar, key in pairs(BAR_HOLDER) do
		local cfg = BarDB(bar)
		local holder = self[key]

		holder:ClearAllPoints()
		holder:SetPoint(cfg.point, Minimap, cfg.point, F.Dpi(cfg.xOffset), F.Dpi(cfg.yOffset))
	end
end

-- Mutes each Blizzard original whose MER replacement is switched on, and hands
-- it back the moment that replacement is switched off again.
function module:UpdateBlizzardIndicators(forceRestore)
	local db = self.db
	local cluster = _G.MinimapCluster
	local indicator = cluster and cluster.IndicatorFrame
	local tracking = cluster and cluster.Tracking

	local replaced = {
		tracking = { tracking, tracking and tracking.Button },
		calendar = { _G.GameTimeFrame },
		mail = { indicator and indicator.MailFrame },
		craftingOrders = { indicator and indicator.CraftingOrderFrame },
	}

	for key, frames in pairs(replaced) do
		local settings = db and db[key]
		local muted = not forceRestore and db and db.enable and settings and settings.enable

		for _, frame in ipairs(frames) do
			SetIndicatorMuted(frame, muted and true or false)
		end
	end
end

function module:SettingsUpdate()
	if not self.Initialized then
		return
	end

	if not self.holder then
		self:CreateButtons()
	end

	self:UpdateBlizzardIndicators()
	self:UpdatePosition()
	self:UpdateLayout()
end

local function CreateHolder(name)
	local holder = CreateFrame("Frame", name, Minimap)
	holder:SetSize(1, 1)
	holder:SetFrameLevel(Minimap:GetFrameLevel() + 10)
	holder:SetFrameStrata(Minimap:GetFrameStrata())
	E.FrameLocks[holder] = true

	return holder
end

function module:CreateButtons()
	local holder = CreateHolder("MER_MinimapButtonsHolder")
	local elementHolder = CreateHolder("MER_MinimapElementsHolder")
	self.holder = holder
	self.elementHolder = elementHolder

	self.greatVaultButton = CreateGreatVaultButton(holder)
	self.portalButton = CreatePortalButton(holder)
	self.trackingButton = CreateTrackingButton(elementHolder)
	self.calendarButton = CreateCalendarButton(elementHolder)
	self.mailButton = CreateMailButton(elementHolder)
	self.craftingButton = CreateCraftingButton(elementHolder)

	-- Order within each bar. Mail and crafting orders sit last so the always-on
	-- buttons keep their place when those two appear or vanish.
	self.buttons = {
		{ key = "greatVault", bar = "main", btn = self.greatVaultButton },
		{ key = "mplusPortals", bar = "main", btn = self.portalButton },
		{ key = "tracking", bar = "elements", btn = self.trackingButton },
		{ key = "calendar", bar = "elements", btn = self.calendarButton },
		{ key = "mail", bar = "elements", btn = self.mailButton },
		{ key = "craftingOrders", bar = "elements", btn = self.craftingButton },
	}

	-- Each button knows its bar, so its menu or flyout can open the way that bar grows.
	for _, entry in ipairs(self.buttons) do
		entry.btn.bar = entry.bar
	end

	local watcher = CreateFrame("Frame")
	watcher:RegisterEvent("UPDATE_PENDING_MAIL")
	watcher:RegisterEvent("MAIL_INBOX_UPDATE")
	watcher:RegisterEvent("MAIL_CLOSED")
	watcher:RegisterEvent("CRAFTINGORDERS_UPDATE_PERSONAL_ORDER_COUNTS")
	watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
	watcher:SetScript("OnEvent", function()
		module:RefreshIndicators()
	end)

	-- Nothing fires when the date rolls over, so the calendar icon is checked on
	-- a slow ticker instead.
	self.calendarTicker = C_Timer.NewTicker(60, function()
		module:RefreshIndicators()
	end)
end

function module:Disable()
	if not self.Initialized or not self.holder then
		return
	end

	self:UpdateBlizzardIndicators(true)
	self.holder:Hide()
	self.elementHolder:Hide()
end

function module:Enable()
	if not self.Initialized then
		return
	end

	self:SettingsUpdate()

	if self.holder then
		self.holder:Show()
		self.elementHolder:Show()
	end
end

function module:DatabaseUpdate()
	self:Disable()

	self.db = E.db.mui.minimapButtons

	F.Event.ContinueOutOfCombat(function()
		if self.db and self.db.enable then
			self:Enable()
		end
	end)
end

function module:Initialize()
	if self.Initialized then
		return
	end

	F.Event.RegisterOnceCallback("MER.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
	F.Event.RegisterCallback("MER.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("MinimapButtons.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("MinimapButtons.SettingsUpdate", self.SettingsUpdate, self)

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
