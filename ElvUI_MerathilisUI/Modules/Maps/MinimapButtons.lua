local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_MinimapButtons")
local WS = W:GetModule("Skins")

local _G = _G
local ipairs, pairs, format, unpack = ipairs, pairs, string.format, unpack
local ceil, floor, max, min = math.ceil, math.floor, math.max, math.min
local sort, tinsert = table.sort, table.insert
local gmatch, gsub, strfind, strlower, strtrim = string.gmatch, string.gsub, string.find, string.lower, strtrim

local CreateFrame = CreateFrame
local GetMouseFoci = GetMouseFoci
local IsMouseButtonDown = IsMouseButtonDown
local issecurevariable = issecurevariable
local GetGameTime = GetGameTime
local HasNewMail = HasNewMail
local GetLatestThreeSenders = GetLatestThreeSenders
local GetNumSavedInstances = GetNumSavedInstances
local GetSavedInstanceInfo = GetSavedInstanceInfo
local GetDifficultyInfo = GetDifficultyInfo
local RequestRaidInfo = RequestRaidInfo
local SecondsToTime = SecondsToTime
local ToggleCalendar = ToggleCalendar
local hooksecurefunc = hooksecurefunc
local C_AddOns = C_AddOns
local C_WeeklyRewards = C_WeeklyRewards
local C_Timer = C_Timer
local C_Texture = C_Texture
local C_CVar = C_CVar
local C_DateAndTime = C_DateAndTime
local C_CraftingOrders = C_CraftingOrders
local Enum = Enum

local ADDONS = ADDONS
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
-- Attention pulse
-------------------------------------------------------------------------------
-- Mirrors the world map's ExpandAndFade pin highlight (MapPinAnimatedHighlightTemplate):
-- a desaturated additive copy of the icon grows to twice its size while fading out.
-- It lives on a raised child frame so neighbouring bar buttons don't draw over it.
-- Stored as btn.PulseGroup; the caller decides when it plays.
local function CreateExpandPulse(btn, icon, atlas)
	local pulseFrame = CreateFrame("Frame", nil, btn)
	pulseFrame:SetAllPoints(icon)
	pulseFrame:SetFrameLevel(btn:GetFrameLevel() + 5)

	local expand = pulseFrame:CreateTexture(nil, "OVERLAY")
	expand:SetAtlas(atlas)
	expand:SetAllPoints()
	expand:SetBlendMode("ADD")
	expand:SetDesaturated(true)
	expand:SetAlpha(0)

	local pulse = expand:CreateAnimationGroup()
	pulse:SetLooping("REPEAT")
	pulse:SetToFinalAlpha(false)

	local fadeIn = pulse:CreateAnimation("Alpha")
	fadeIn:SetFromAlpha(0)
	fadeIn:SetToAlpha(0.3)
	fadeIn:SetDuration(0.4)
	fadeIn:SetOrder(1)

	local grow = pulse:CreateAnimation("Scale")
	grow:SetOrigin("CENTER", 0, 0)
	grow:SetScaleFrom(1, 1)
	grow:SetScaleTo(2, 2)
	grow:SetDuration(1)
	grow:SetOrder(1)

	local fadeOut = pulse:CreateAnimation("Alpha")
	fadeOut:SetFromAlpha(0.3)
	fadeOut:SetToAlpha(0)
	fadeOut:SetDuration(0.4)
	fadeOut:SetOrder(2)

	btn.PulseGroup = pulse
end

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

-- Plays the world-map-style expand pulse while at least one weekly reward is ready to claim.
local function UpdateGreatVaultPulse(btn)
	local hasRewards = C_WeeklyRewards and C_WeeklyRewards.HasAvailableRewards and C_WeeklyRewards.HasAvailableRewards()

	-- HasAvailableRewards can stay true after claiming until the vault is opened again,
	-- so a claim suppresses the pulse until the API confirms or the vault reopens.
	if btn.rewardClaimed then
		local vaultFrame = _G.WeeklyRewardsFrame
		if not hasRewards or (vaultFrame and vaultFrame:IsShown()) then
			btn.rewardClaimed = nil
		else
			hasRewards = false
		end
	end

	if btn.testPulse or hasRewards then
		if not btn.PulseGroup:IsPlaying() then
			btn.PulseGroup:Play()
		end
	elseif btn.PulseGroup:IsPlaying() then
		btn.PulseGroup:Stop()
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

local function CreateGreatVaultButton(parent)
	local btn = CreateFrame("Button", "MER_MinimapGreatVaultButton", parent)
	btn:EnableMouse(true)
	btn:SetTemplate("Transparent")

	local icon = btn:CreateTexture(nil, "ARTWORK")
	icon:SetAtlas(GREAT_VAULT_ATLAS)
	icon:SetPoint("TOPLEFT", 2, -2)
	icon:SetPoint("BOTTOMRIGHT", -2, 2)
	btn.Icon = icon

	CreateExpandPulse(btn, icon, GREAT_VAULT_ATLAS)

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

	-- The vault closes right after the claim and no fresh update may follow, so stop the pulse
	-- here and re-check once the server has had time to confirm.
	if C_WeeklyRewards and C_WeeklyRewards.ClaimReward then
		hooksecurefunc(C_WeeklyRewards, "ClaimReward", function()
			btn.rewardClaimed = true
			UpdateGreatVaultPulse(btn)
			C_Timer.After(3, function()
				UpdateGreatVaultPulse(btn)
			end)
		end)
	end

	icon:SetVertexColor(0.85, 0.85, 0.85)
	UpdateGreatVaultPulse(btn)

	return btn
end

-------------------------------------------------------------------------------
-- Mythic+ Portals button (the flyout itself is shared, see F.PortalFlyout)
-------------------------------------------------------------------------------
-- Flyouts hang below their button (above it on an upward bar) and open away from the minimap.
local function GetFlyoutAnchor(btn)
	local edge = GrowsRight(btn.bar) and "LEFT" or "RIGHT"
	local gap = F.Dpi(4)

	if GrowsUp(btn.bar) then
		return "BOTTOM" .. edge, "TOP" .. edge, 0, gap
	end

	return "TOP" .. edge, "BOTTOM" .. edge, 0, -gap
end

local function TogglePortalFlyout(anchorBtn)
	local point, relativePoint, x, y = GetFlyoutAnchor(anchorBtn)
	F.PortalFlyout.Toggle(anchorBtn, point, relativePoint, x, y)
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

-------------------------------------------------------------------------------
-- Addon compartment: same approach as tracking, Blizzard's dropdown with our anchor
-------------------------------------------------------------------------------
local function GetAddonCount()
	local compartment = _G.AddonCompartmentFrame
	return compartment and compartment.registeredAddons and #compartment.registeredAddons or 0
end

local function ToggleCompartmentMenu(self)
	local compartment = _G.AddonCompartmentFrame
	if not compartment or not compartment.OpenMenu then
		return
	end

	if compartment.menu and compartment.menu:IsShown() then
		compartment:CloseMenu()
		return
	end

	compartment:OpenMenu()

	local menu = compartment.menu
	if menu then
		menu:ClearAllPoints()
		if GrowsRight(self.bar) then
			menu:SetPoint("TOPLEFT", self, "TOPRIGHT", F.Dpi(4), 0)
		else
			menu:SetPoint("TOPRIGHT", self, "TOPLEFT", -F.Dpi(4), 0)
		end
	end
end

local function CreateCompartmentButton(parent)
	local btn = CreateFrame("Button", "MER_MinimapAddonCompartmentButton", parent)
	btn:EnableMouse(true)
	btn:SetTemplate("Transparent")

	local icon = btn:CreateTexture(nil, "ARTWORK")
	icon:SetTexture(I.Media.Icons.List)
	icon:SetPoint("CENTER")
	icon:SetVertexColor(0.85, 0.85, 0.85)
	btn.Icon = icon

	-- The glyph fills its whole texture, so it gets more room around it than the atlas icons.
	btn.UpdateIcon = function(self, size)
		local iconSize = F.Round(size * 0.6)
		self.Icon:SetSize(iconSize, iconSize)
	end

	-- Blizzard hides its own button while no addon registered, and so does this one.
	-- ElvUI's "hide" option parks the original on a hidden parent, where its menu cannot open.
	btn.ShouldShow = function()
		return GetAddonCount() > 0 and not E.db.general.addonCompartment.hide
	end

	btn:SetScript("OnEnter", function(self)
		self.Icon:SetVertexColor(1, 1, 1)
		_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		_G.GameTooltip:AddDoubleLine(ADDONS, GetAddonCount(), nil, nil, nil, 1, 1, 1)
		_G.GameTooltip:Show()
	end)
	btn:SetScript("OnLeave", function(self)
		self.Icon:SetVertexColor(0.85, 0.85, 0.85)
		_G.GameTooltip:Hide()
	end)
	btn:SetScript("OnClick", ToggleCompartmentMenu)

	return btn
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
	if E:IsSecretValue(raw) and raw then
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

-- These buttons only exist while something is waiting, so they pulse for as long as they are shown.
local function PulseWhileShown(btn)
	CreateExpandPulse(btn, btn.Icon, btn.upAtlas)
	btn:SetScript("OnShow", function(self)
		if not self.PulseGroup:IsPlaying() then
			self.PulseGroup:Play()
		end
	end)
	btn:SetScript("OnHide", function(self)
		self.PulseGroup:Stop()
	end)
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

	PulseWhileShown(btn)

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

	PulseWhileShown(btn)

	return btn
end

-------------------------------------------------------------------------------
-- Addon buttons: the minimap buttons of other addons (LibDBIcon and friends)
-- move off the Minimap into a grid that opens from the main bar. A collected
-- button stays reparented for the rest of the session, so switching the
-- collector off takes a reload.
-------------------------------------------------------------------------------
local LDB_PREFIX = "LibDBIcon10_"

-- Addon frames that belong on the Minimap itself. Blizzard's own frames never
-- get this far, see IsCollectable.
local IGNORED_NAMES = {
	ElvConfigToggle = true,
	ElvUIConfigToggle = true,
	ElvUI_ConsolidatedBuffs = true,
	-- Replaces the expansion landing page button, a feature button rather than an addon button.
	PlumberLandingPageMinimapButton = true,
}

-- Map pins and other overlays share the Minimap with the buttons.
local IGNORED_PATTERNS = {
	"^ElvUI",
	"^MER_",
	"^HandyNotes",
	"^TomTom",
	"^HereBeDragons",
	"^Questie",
	"^GatherMate",
	"^GatherNote",
	"^Archy",
	"^ZGVMarker",
	"^poiMinimap",
	"Pin",
	"POI",
	"Node",
}

-- Ring, background and highlight of the round minimap button look.
local JUNK_TEXTURE_IDS = {
	[136430] = true, -- MiniMap-TrackingBorder
	[136467] = true, -- UI-Minimap-Background
	[136477] = true, -- UI-Minimap-ZoomButton-Highlight
}

-- A click into a menu or window one of the buttons opened keeps the grid open:
-- those sit in the dialog strata or above.
local POPUP_STRATA = { DIALOG = true, FULLSCREEN = true, FULLSCREEN_DIALOG = true, TOOLTIP = true }

local _addonButtons = {}
local _collected = {}
local _userIgnored = {}
-- Set around our own SetParent/SetPoint calls, so the hooks only answer the addon's.
local _anchoring = false
local _collectPending, _gridPending

-- Another collector takes the same buttons, and two of them would fight over each one.
function module:GetForeignCollector()
	local wt = E.private.WT and E.private.WT.maps and E.private.WT.maps.minimapButtons
	if wt and wt.enable then
		return "WindTools"
	end

	local smb = _G.SquareMinimapButtons
	if smb and smb.db and smb.db.Enable then
		return "ProjectAzilroka"
	end
end

local function IsJunkTexture(region)
	if not region:IsObjectType("Texture") then
		return false
	end

	local fileID = region:GetTextureFileID()
	if fileID and JUNK_TEXTURE_IDS[fileID] then
		return true
	end

	local tex = region:GetTexture()
	return type(tex) == "string" and (strfind(tex, "Border") or strfind(tex, "Background")) ~= nil
end

local function MatchesIgnoreList(name)
	if IGNORED_NAMES[name] then
		return true
	end

	local lower = strlower(name)
	for _, part in ipairs(_userIgnored) do
		if strfind(lower, part, 1, true) then
			return true
		end
	end

	return false
end

local function IsCollectable(child)
	if _collected[child] or child:IsForbidden() or child:IsProtected() then
		return false
	end

	local name = child:GetName()
	if not name or not child:IsObjectType("Button") or MatchesIgnoreList(name) then
		return false
	end

	if strfind(name, "^" .. LDB_PREFIX) then
		return true
	end

	-- Blizzard creates its frames from secure code, an addon's globals are tainted.
	if issecurevariable(name) or strfind(name, "%d+$") then
		return false
	end

	for _, pattern in ipairs(IGNORED_PATTERNS) do
		if strfind(name, pattern) then
			return false
		end
	end

	-- Pins are small, real buttons are not. Only checked here, before the grid resizes them.
	return (child:GetWidth() or 0) >= 20
end

local function GetButtonLabel(btn)
	local label = gsub(btn:GetName(), "^" .. LDB_PREFIX, "")
	label = gsub(label, "_?[Mm]ini[Mm]ap_?[Bb]utton$", "")
	return strlower(label)
end

local function FindButtonIcon(btn)
	local icon = btn.icon or btn.Icon
	if icon and icon.IsObjectType and icon:IsObjectType("Texture") then
		return icon
	end

	local highlight = btn:GetHighlightTexture()
	for _, region in ipairs({ btn:GetRegions() }) do
		if
			region ~= highlight
			and region:IsObjectType("Texture")
			and region:IsShown()
			and region:GetAlpha() > 0
			and not IsJunkTexture(region)
		then
			return region
		end
	end
end

local function PlaceButton(btn)
	local panel, slot = module.addonPanel, btn.merSlot
	if not panel or not slot then
		return
	end

	_anchoring = true
	if btn:GetParent() ~= panel then
		btn:SetParent(panel)
	end
	btn:ClearAllPoints()
	btn:SetPoint("TOPLEFT", panel, "TOPLEFT", slot.x, slot.y)
	_anchoring = false
end

local function SkinButton(btn)
	for _, region in ipairs({ btn:GetRegions() }) do
		if IsJunkTexture(region) then
			region:SetAlpha(0)
		end
	end

	-- LibDBIcon keeps its ring and background on named keys, and an addon may swap their art.
	if btn.border and btn.border.SetAlpha then
		btn.border:SetAlpha(0)
	end
	if btn.background and btn.background.SetAlpha then
		btn.background:SetAlpha(0)
	end

	local highlight = btn:GetHighlightTexture()
	if highlight then
		highlight:SetAlpha(0)
	end

	-- Without a pushed texture the icon stays in place while the button is held down.
	if btn:GetPushedTexture() then
		btn:SetPushedTexture(E.ClearTexture)
	end

	local icon = FindButtonIcon(btn)
	if icon then
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", btn, "TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -2, 2)

		-- LibDBIcon crops its icon again on every press. Other icons are cropped once,
		-- unless they already show only part of their texture (sprite sheets).
		if not btn.dataObject then
			local left, top, _, _, _, _, right, bottom = icon:GetTexCoord()
			if left == 0 and top == 0 and right == 1 and bottom == 1 then
				icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			end
		end
	end

	local backdrop = CreateFrame("Frame", nil, btn)
	backdrop:SetAllPoints()
	backdrop:SetFrameLevel(max(btn:GetFrameLevel() - 1, 0))
	backdrop:SetTemplate("Transparent")
	btn.merBackdrop = backdrop

	btn:HookScript("OnEnter", function(self)
		local color = E.db.general.valuecolor
		self.merBackdrop:SetBackdropBorderColor(color.r, color.g, color.b)
	end)
	btn:HookScript("OnLeave", function(self)
		self.merBackdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end)
end

local function QueueGridUpdate()
	if _gridPending then
		return
	end

	_gridPending = true
	C_Timer.After(0, function()
		_gridPending = nil
		module:UpdateAddonGrid()
		module:RefreshIndicators()
	end)
end

local function HookButton(btn)
	-- LibDBIcon re-anchors its buttons on the Minimap whenever it refreshes them.
	hooksecurefunc(btn, "SetPoint", function(self)
		if not _anchoring then
			PlaceButton(self)
		end
	end)
	hooksecurefunc(btn, "SetParent", function(self)
		if not _anchoring then
			PlaceButton(self)
		end
	end)

	-- The addon's own Show/Hide (e.g. LibDBIcon's "hide minimap button") decides
	-- whether the button takes a slot in the grid.
	hooksecurefunc(btn, "Show", QueueGridUpdate)
	hooksecurefunc(btn, "Hide", QueueGridUpdate)
	hooksecurefunc(btn, "SetShown", QueueGridUpdate)

	-- LibDBIcon's "show on mouseover" fades the button out once the cursor leaves the Minimap.
	if btn.fadeOut then
		hooksecurefunc(btn.fadeOut, "Play", function(anim)
			anim:Stop()
			btn:SetAlpha(1)
		end)
	end
end

local function CaptureButton(btn)
	local panel = module.addonPanel

	_collected[btn] = true
	_addonButtons[#_addonButtons + 1] = btn
	btn.merLabel = GetButtonLabel(btn)
	btn.merSlot = { x = 0, y = 0 }

	PlaceButton(btn)

	-- LibDBIcon pins strata and level, so they are unlocked, set, and pinned again.
	btn:SetFixedFrameStrata(false)
	btn:SetFixedFrameLevel(false)
	btn:SetFrameStrata("DIALOG")
	btn:SetFrameLevel(panel:GetFrameLevel() + 2)
	btn:SetFixedFrameStrata(true)
	btn:SetFixedFrameLevel(true)

	if btn.fadeOut then
		btn.fadeOut:Stop()
	end
	btn:SetAlpha(1)

	-- Dragging would move the button around the Minimap it no longer sits on.
	if btn:HasScript("OnDragStart") then
		btn:SetScript("OnDragStart", nil)
		btn:SetScript("OnDragStop", nil)
	end

	SkinButton(btn)
	HookButton(btn)
end

local function CollectAddonButtons()
	if not module.addonCollectorActive then
		return
	end

	local found = false
	for _, child in ipairs({ Minimap:GetChildren() }) do
		if IsCollectable(child) then
			CaptureButton(child)
			found = true
		end
	end

	if found then
		QueueGridUpdate()
	end
end

-- Addons create their buttons at load or a little later, so every new addon
-- triggers one batched scan.
local function QueueCollect()
	if _collectPending then
		return
	end

	_collectPending = true
	C_Timer.After(0.5, function()
		_collectPending = nil
		CollectAddonButtons()
	end)
end

function module:UpdateAddonGrid()
	local panel = self.addonPanel
	local cfg = self.db and self.db.addonButtons
	if not panel or not cfg then
		return
	end

	local shown = {}
	for _, btn in ipairs(_addonButtons) do
		if btn:IsShown() then
			shown[#shown + 1] = btn
		end
	end

	sort(shown, function(a, b)
		return a.merLabel < b.merLabel
	end)

	local count = #shown
	local size, spacing, padding = F.Dpi(cfg.size), F.Dpi(cfg.spacing), F.Dpi(4)
	local cols = max(min(count, cfg.perRow), 1)
	local rows = max(ceil(count / cols), 1)

	panel:SetSize(padding * 2 + cols * size + (cols - 1) * spacing, padding * 2 + rows * size + (rows - 1) * spacing)

	for i, btn in ipairs(shown) do
		local col = (i - 1) % cols
		local row = floor((i - 1) / cols)

		btn.merSlot.x = padding + col * (size + spacing)
		btn.merSlot.y = -(padding + row * (size + spacing))
		btn:SetSize(size, size)
		PlaceButton(btn)
	end

	self.addonButtonCount = count
	if count == 0 then
		panel:Hide()
	end
end

local function CloseOnClickOutside(panel)
	if not (IsMouseButtonDown("LeftButton") or IsMouseButtonDown("RightButton")) then
		return
	end

	if panel:IsMouseOver() or (module.addonToggle and module.addonToggle:IsMouseOver()) then
		return
	end

	local focus = GetMouseFoci and GetMouseFoci()[1]
	if focus and not focus:IsForbidden() and POPUP_STRATA[focus:GetFrameStrata()] then
		return
	end

	panel:Hide()
end

local function CreateAddonPanel()
	local panel = CreateFrame("Frame", "MER_MinimapAddonButtonsPanel", E.UIParent)
	panel:SetSize(1, 1)
	panel:SetFrameStrata("DIALOG")
	panel:SetClampedToScreen(true)
	panel:SetTemplate("Transparent")
	panel:Hide()
	WS:CreateShadow(panel)
	tinsert(_G.UISpecialFrames, "MER_MinimapAddonButtonsPanel")

	panel:SetScript("OnShow", function(self)
		self:SetScript("OnUpdate", CloseOnClickOutside)
	end)
	panel:SetScript("OnHide", function(self)
		self:SetScript("OnUpdate", nil)
	end)

	return panel
end

local function ToggleAddonPanel(btn)
	local panel = module.addonPanel
	if not panel then
		return
	end

	if panel:IsShown() then
		panel:Hide()
		return
	end

	_G.GameTooltip:Hide()
	module:UpdateAddonGrid()

	local point, relativePoint, x, y = GetFlyoutAnchor(btn)
	panel:ClearAllPoints()
	panel:SetPoint(point, btn, relativePoint, x, y)
	panel:Show()
end

local function CreateAddonButtonsToggle(parent)
	local btn = CreateFrame("Button", "MER_MinimapAddonButtonsButton", parent)
	btn:EnableMouse(true)
	btn:SetTemplate("Transparent")

	local icon = btn:CreateTexture(nil, "ARTWORK")
	icon:SetTexture(I.Media.Icons.Categories.System)
	icon:SetPoint("CENTER")
	icon:SetVertexColor(0.85, 0.85, 0.85)
	btn.Icon = icon

	btn.UpdateIcon = function(self, size)
		local iconSize = F.Round(size * 0.6)
		self.Icon:SetSize(iconSize, iconSize)
	end

	btn.ShouldShow = function()
		return module.addonCollectorActive and (module.addonButtonCount or 0) > 0
	end

	btn:SetScript("OnEnter", function(self)
		self.Icon:SetVertexColor(1, 1, 1)
		if module.addonPanel and module.addonPanel:IsShown() then
			return
		end
		_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		_G.GameTooltip:AddDoubleLine(L["Addon Buttons"], module.addonButtonCount or 0, nil, nil, nil, 1, 1, 1)
		_G.GameTooltip:Show()
	end)
	btn:SetScript("OnLeave", function(self)
		self.Icon:SetVertexColor(0.85, 0.85, 0.85)
		_G.GameTooltip:Hide()
	end)
	btn:SetScript("OnClick", ToggleAddonPanel)

	return btn
end

-- Runs once per session, as soon as the option is on. The first scan waits a
-- moment so a foreign collector has set itself up and can be detected.
function module:StartAddonCollector()
	if self.addonCollectorStarted or not self.db.addonButtons.enable then
		return
	end
	self.addonCollectorStarted = true

	C_Timer.After(1, function()
		local db = self.db
		if not (db and db.enable and db.addonButtons.enable) or self:GetForeignCollector() then
			self.addonCollectorStarted = nil
			return
		end

		for part in gmatch(db.addonButtons.ignore or "", "[^,]+") do
			part = strtrim(part)
			if part ~= "" then
				_userIgnored[#_userIgnored + 1] = strlower(part)
			end
		end

		self.addonPanel = CreateAddonPanel()
		self.addonCollectorActive = true

		local watcher = CreateFrame("Frame")
		watcher:RegisterEvent("ADDON_LOADED")
		watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
		watcher:SetScript("OnEvent", QueueCollect)

		local LDBIcon = _G.LibStub and _G.LibStub("LibDBIcon-1.0", true)
		if LDBIcon and LDBIcon.RegisterCallback then
			LDBIcon.RegisterCallback(self, "LibDBIcon_IconCreated", QueueCollect)
		end

		CollectAddonButtons()
	end)
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
		addonCompartment = { _G.AddonCompartmentFrame },
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
	-- Disable() hid the bars, a layout option changed afterwards must not build or show them again
	if not self.Initialized or not (self.db and self.db.enable) then
		return
	end

	if not self.holder then
		self:CreateButtons()
	end

	self:UpdateBlizzardIndicators()
	self:UpdatePosition()
	self:UpdateLayout()
	self:UpdateAddonGrid()
	self:StartAddonCollector()
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
	self.addonToggle = CreateAddonButtonsToggle(holder)
	self.trackingButton = CreateTrackingButton(elementHolder)
	self.calendarButton = CreateCalendarButton(elementHolder)
	self.compartmentButton = CreateCompartmentButton(elementHolder)
	self.mailButton = CreateMailButton(elementHolder)
	self.craftingButton = CreateCraftingButton(elementHolder)

	-- Order within each bar. Mail and crafting orders sit last so the always-on
	-- buttons keep their place when those two appear or vanish.
	self.buttons = {
		{ key = "greatVault", bar = "main", btn = self.greatVaultButton },
		{ key = "mplusPortals", bar = "main", btn = self.portalButton },
		{ key = "addonButtons", bar = "main", btn = self.addonToggle },
		{ key = "tracking", bar = "elements", btn = self.trackingButton },
		{ key = "calendar", bar = "elements", btn = self.calendarButton },
		{ key = "addonCompartment", bar = "elements", btn = self.compartmentButton },
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

	-- The compartment collects its addons on PLAYER_ENTERING_WORLD, possibly after our watcher ran.
	local compartment = _G.AddonCompartmentFrame
	if compartment and compartment.UpdateDisplay then
		hooksecurefunc(compartment, "UpdateDisplay", function()
			module:RefreshIndicators()
		end)
	end

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

	if self.addonPanel then
		self.addonPanel:Hide()
	end
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
	F.Event.RegisterCallback("MinimapButtons.SettingsUpdate", self.SettingsUpdate, self)

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
