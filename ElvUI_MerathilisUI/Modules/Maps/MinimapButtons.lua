local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_MinimapButtons")
local S = E:GetModule("Skins") ---@type Skins
local WS = W:GetModule("Skins")

local _G = _G
local ipairs, format, ceil, floor, random = ipairs, string.format, math.ceil, math.floor, math.random

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsPlayerSpell = IsPlayerSpell
local IsInInstance = IsInInstance
local UnitClass = UnitClass
local PlayerHasToy = PlayerHasToy
local C_AddOns = C_AddOns
local C_Spell = C_Spell
local C_WeeklyRewards = C_WeeklyRewards
local C_ChallengeMode = C_ChallengeMode
local C_Container = C_Container
local C_Item = C_Item
local C_ToyBox = C_ToyBox
local C_Timer = C_Timer
local Enum = Enum

local Minimap = _G.Minimap

-------------------------------------------------------------------------------
-- Current Mythic+ season portals. Update this list once per season -- spellID
-- is the teleport spell, short is the abbreviated flyout button label.
-------------------------------------------------------------------------------
local SEASON_PORTALS = {
	{ spellID = 1286801, short = "BV" }, -- The Blinding Vale
	{ spellID = 1286804, short = "VA" }, -- Voidscar Arena
	{ spellID = 1286807, short = "DoN" }, -- Den of Nalorakk
	{ spellID = 1286809, short = "MR" }, -- Murder Row
	{ spellID = 1286812, short = "AoF" }, -- Altar of Fangs
	{ spellID = 393256, short = "RLP" }, -- Ruby Life Pools
	{ spellID = 1286828, short = "ToS" }, -- Temple of Sethraliss
	{ spellID = 1286831, short = "KR" }, -- Kings' Rest
}

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
	local hasRewards = btn.testPulse or (C_WeeklyRewards and C_WeeklyRewards.HasAvailableRewards and C_WeeklyRewards.HasAvailableRewards())

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
-- Mythic+ Portals button + flyout
-------------------------------------------------------------------------------
local _portalFlyout, _portalFlyoutButtons, _hearthButtons

local function RefreshPortalButtons()
	if not _portalFlyoutButtons then
		return
	end

	for _, btn in ipairs(_portalFlyoutButtons) do
		local known = IsPlayerSpell(btn.spellID)
		btn.Icon:SetDesaturated(not known)
		btn.Icon:SetAlpha(known and 1 or 0.4)

		if known then
			local cdInfo = C_Spell.GetSpellCooldown(btn.spellID)
			if cdInfo and cdInfo.startTime and cdInfo.duration and cdInfo.duration > 0 then
				btn.Cooldown:SetCooldown(cdInfo.startTime, cdInfo.duration)
			else
				btn.Cooldown:Clear()
			end
		else
			btn.Cooldown:Clear()
		end
	end
end

-------------------------------------------------------------------------------
-- Hearthstone row: Hearthstone slot, Dalaran Hearthstone, Housing Dashboard.
-- Resolver logic ported from EllesmereUI (owned-toy rotation + Shaman Astral
-- Recall fallback in protected instances).
-------------------------------------------------------------------------------
local HEARTH_TOYS = {
	54452, -- Ethereal Portal
	64488, -- The Innkeeper's Daughter
	93672, -- Dark Portal
	28585, -- Ruby Slippers
	142542, -- Tome of Town Portal
	163045, -- Headless Horseman's Hearthstone
	162973, -- Greatfather Winter's Hearthstone
	165669, -- Lunar Elder's Hearthstone
	165670, -- Peddlefeet's Lovely Hearthstone
	165802, -- Noble Gardener's Hearthstone
	166746, -- Fire Eater's Hearthstone
	166747, -- Brewfest Reveler's Hearthstone
	168907, -- Holographic Digitalization Hearthstone
	172179, -- Eternal Traveler's Hearthstone
	184353, -- Kyrian Hearthstone
	180290, -- Night Fae Hearthstone
	182773, -- Necrolord Hearthstone
	183716, -- Venthyr Sinstone
	188952, -- Dominated Hearthstone
	190237, -- Broker Translocation Matrix
	190196, -- Enlightened Hearthstone
	193588, -- Timewalker's Hearthstone
	200630, -- Ohn'ir Windsage's Hearthstone
	206195, -- Path of the Naaru
	209035, -- Hearthstone of the Flame
	210455, -- Draenic Hologem
	208704, -- Deepdweller's Earthen Hearthstone
	212337, -- Stone of the Hearth
	228940, -- Notorious Thread's Hearthstone
	235016, -- Redeployment Module
	236687, -- Explosive Hearthstone
	245970, -- P.O.S.T. Master's Express Hearthstone
	246565, -- Cosmic Hearthstone
	250411, -- Timerunner's Hearthstone
	257736, -- Lightcalled Hearthstone
	263489, -- Naaru's Enfold
	263933, -- Preyseeker's Hearthstone
	265100, -- Corewarden's Hearthstone
	142298, -- Astonishingly Scarlet Slippers
	264367, -- Mushroom
}
local SHAMAN_ASTRAL_RECALL = 556
local DALARAN_HS = 253629
local DALARAN_HS_FALLBACK = 140192

-- Real toy icon (not the "learn" item icon).
local function ToyIcon(id)
	if C_ToyBox and C_ToyBox.GetToyInfo then
		local _, _, icon = C_ToyBox.GetToyInfo(id)
		if icon then
			return icon
		end
	end
	return C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(id) or 134414
end

-- Same "teleport to house" icon Blizzard's own Housing Dashboard uses.
local HOUSING_ATLAS = "dashboard-panel-homestone-teleport-button"

-- M+/raid/PvP instance check -- guards hearth-toy cooldown reads against
-- tainted/secret values while a key or encounter is active.
local function InProtectedInstance()
	local _, instanceType = IsInInstance()
	if instanceType == "raid" and InCombatLockdown() then
		return true
	end
	if
		instanceType == "party"
		and C_ChallengeMode
		and C_ChallengeMode.IsChallengeModeActive
		and C_ChallengeMode.IsChallengeModeActive()
	then
		return true
	end
	if (instanceType == "pvp" or instanceType == "arena") and InCombatLockdown() then
		return true
	end
	return false
end

local function IsHearthOnCD(id)
	if InProtectedInstance() then
		return true
	end
	if C_Container and C_Container.GetItemCooldown then
		local ok, start, dur = pcall(C_Container.GetItemCooldown, id)
		if ok and start and dur and dur > 1.5 then
			return true
		end
	end
	return false
end

-- Slot 1: Shamans with Astral Recall known prefer it in protected instances or
-- when every owned hearth toy is on cooldown; otherwise a random owned toy,
-- falling back to the base Hearthstone (6948) if none are known.
local function ResolveHearthSlot()
	local _, cls = UnitClass("player")
	local isShaman = cls == "SHAMAN" and IsPlayerSpell(SHAMAN_ASTRAL_RECALL)

	if isShaman and InProtectedInstance() then
		local info = C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(SHAMAN_ASTRAL_RECALL)
		return "spell", SHAMAN_ASTRAL_RECALL, info and info.iconID or 136010
	end

	local owned = {}
	for _, id in ipairs(HEARTH_TOYS) do
		if PlayerHasToy and PlayerHasToy(id) then
			owned[#owned + 1] = id
		end
	end

	if isShaman and #owned > 0 then
		local anyOnCD = false
		for _, id in ipairs(owned) do
			if IsHearthOnCD(id) then
				anyOnCD = true
				break
			end
		end
		if anyOnCD then
			local info = C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(SHAMAN_ASTRAL_RECALL)
			return "spell", SHAMAN_ASTRAL_RECALL, info and info.iconID or 136010
		end
	end

	if #owned == 0 then
		local icon = C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(6948) or 134414
		return "item", 6948, icon
	end

	local pick = owned[random(#owned)]
	return "item", pick, ToyIcon(pick)
end

-- Slot 2: Dalaran Hearthstone, falling back to the older variant.
local function ResolveDalaranSlot()
	local id = (PlayerHasToy and PlayerHasToy(DALARAN_HS)) and DALARAN_HS or DALARAN_HS_FALLBACK
	return "item", id, ToyIcon(id)
end

-- Slot 3: Housing Dashboard toggle (not a spell/item).
local function ResolveHousingSlot()
	return "housing", 0, HOUSING_ATLAS
end

local HEARTH_RESOLVERS = { ResolveHearthSlot, ResolveDalaranSlot, ResolveHousingSlot }

local function RefreshHearthCooldowns()
	if not _hearthButtons then
		return
	end

	for _, btn in ipairs(_hearthButtons) do
		local hsType, id = btn.hsType, btn.hsID
		if hsType == "spell" then
			local cdInfo = C_Spell.GetSpellCooldown(id)
			if cdInfo and cdInfo.startTime and cdInfo.duration and cdInfo.duration > 0 then
				btn.Cooldown:SetCooldown(cdInfo.startTime, cdInfo.duration)
			else
				btn.Cooldown:Clear()
			end
		elseif hsType == "item" and C_Container and C_Container.GetItemCooldown then
			local ok, start, dur = pcall(C_Container.GetItemCooldown, id)
			if ok and start and dur and dur > 0 then
				btn.Cooldown:SetCooldown(start, dur)
			else
				btn.Cooldown:Clear()
			end
		else
			btn.Cooldown:Clear()
		end
	end
end

local function ResolveHearthButtons()
	if not _hearthButtons or InCombatLockdown() then
		return
	end

	for i, btn in ipairs(_hearthButtons) do
		local hsType, id, icon = HEARTH_RESOLVERS[i]()
		btn.hsType = hsType
		btn.hsID = id

		if hsType == "housing" then
			btn.Icon:SetAtlas(icon)
			btn:SetAttribute("type", nil)
			btn:SetAttribute("macrotext", nil)
		elseif hsType == "spell" then
			btn.Icon:SetTexture(icon or 134414)
			btn:SetAttribute("type", "macro")
			local info = C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(id)
			btn:SetAttribute("macrotext", "/cast " .. (info and info.name or ""))
		else
			btn.Icon:SetTexture(icon or 134414)
			btn:SetAttribute("type", "macro")
			if id == 6948 then
				btn:SetAttribute("macrotext", "/use item:" .. id)
			else
				local toyName
				if C_ToyBox and C_ToyBox.GetToyInfo then
					local _, tn = C_ToyBox.GetToyInfo(id)
					toyName = tn
				end
				btn:SetAttribute("macrotext", toyName and ("/use " .. toyName) or ("/use item:" .. id))
			end
		end
	end

	RefreshHearthCooldowns()
end

local function CreatePortalFlyout()
	if _portalFlyout then
		return _portalFlyout
	end

	local btnSize, spacing, padding, cols = F.Dpi(32), F.Dpi(2), F.Dpi(4), 4
	local rows = ceil(#SEASON_PORTALS / cols)
	local height = padding * 2 + btnSize * rows + spacing * (rows - 1)

	-- Hearthstone column: 3 icons stacked to the right, matching the grid's height.
	local hsCount = 3
	local hsH = floor((height - padding * 2 - spacing * (hsCount - 1)) / hsCount)
	local hsX = padding + cols * btnSize + (cols - 1) * spacing + spacing
	local width = hsX + hsH + padding

	local flyout = CreateFrame("Frame", "MER_MinimapPortalFlyout", E.UIParent)
	flyout:SetSize(width, height)
	flyout:SetFrameStrata("DIALOG")
	flyout:SetClampedToScreen(true)
	flyout:SetTemplate("Transparent")
	flyout:Hide()
	WS:CreateShadow(flyout)
	_G.tinsert(_G.UISpecialFrames, "MER_MinimapPortalFlyout")

	local guard = CreateFrame("Frame")
	guard:RegisterEvent("PLAYER_REGEN_DISABLED")
	guard:SetScript("OnEvent", function()
		flyout:Hide()
	end)

	-- Click anywhere outside the flyout to close it. Strata sits above the
	-- default world UI but below the flyout itself, so its own buttons stay clickable.
	local catcher = CreateFrame("Button", nil, E.UIParent)
	catcher:SetFrameStrata("HIGH")
	catcher:SetAllPoints(E.UIParent)
	catcher:Hide()
	catcher:SetScript("OnClick", function()
		flyout:Hide()
	end)

	_portalFlyoutButtons = {}
	for i, entry in ipairs(SEASON_PORTALS) do
		local col = (i - 1) % cols
		local row = (i - 1 - col) / cols

		local btn = CreateFrame("Button", "MER_MinimapPortal" .. i, flyout, "SecureActionButtonTemplate")
		btn:SetSize(btnSize, btnSize)
		btn:SetPoint("TOPLEFT", padding + col * (btnSize + spacing), -(padding + row * (btnSize + spacing)))
		btn:SetFrameStrata("DIALOG")
		btn:SetTemplate("Default")
		btn.spellID = entry.spellID

		local icon = btn:CreateTexture(nil, "ARTWORK")
		icon:SetPoint("TOPLEFT", 1, -1)
		icon:SetPoint("BOTTOMRIGHT", -1, 1)
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		local spellInfo = C_Spell.GetSpellInfo(entry.spellID)
		if spellInfo then
			icon:SetTexture(spellInfo.iconID)
		end
		btn.Icon = icon
		S:HandleIcon(icon)

		local cooldown = CreateFrame("Cooldown", nil, btn, "CooldownFrameTemplate")
		cooldown:SetAllPoints(icon)
		cooldown:SetHideCountdownNumbers(true)
		cooldown:SetDrawBling(false)
		btn.Cooldown = cooldown

		local castHL = btn:CreateTexture(nil, "OVERLAY", nil, 1)
		castHL:SetAllPoints(icon)
		castHL:SetColorTexture(1, 1, 1, 0.4)
		castHL:Hide()
		btn.CastHighlight = castHL

		if entry.short then
			local label = F.CreateFS(btn, 8, entry.short, false, "BOTTOM", 0, 2)
			label:SetTextColor(1, 1, 1, 0.9)
		end

		btn:RegisterForClicks("AnyUp", "AnyDown")
		btn:SetAttribute("type", "spell")
		btn:SetAttribute("spell", entry.spellID)

		btn:SetScript("OnEnter", function(self)
			_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			_G.GameTooltip:SetSpellByID(self.spellID)
			_G.GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", function()
			_G.GameTooltip:Hide()
		end)

		_portalFlyoutButtons[i] = btn
	end

	_hearthButtons = {}
	for i = 1, hsCount do
		local btn = CreateFrame("Button", "MER_MinimapHearth" .. i, flyout, "SecureActionButtonTemplate")
		btn:SetSize(hsH, hsH)
		btn:SetPoint("TOPLEFT", hsX, -(padding + (i - 1) * (hsH + spacing)))
		btn:SetFrameStrata("DIALOG")
		btn:SetTemplate("Default")

		local icon = btn:CreateTexture(nil, "ARTWORK")
		icon:SetPoint("TOPLEFT", 1, -1)
		icon:SetPoint("BOTTOMRIGHT", -1, 1)
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		btn.Icon = icon
		S:HandleIcon(icon)

		local cooldown = CreateFrame("Cooldown", nil, btn, "CooldownFrameTemplate")
		cooldown:SetAllPoints(icon)
		cooldown:SetHideCountdownNumbers(true)
		cooldown:SetDrawBling(false)
		btn.Cooldown = cooldown

		local castHL = btn:CreateTexture(nil, "OVERLAY", nil, 1)
		castHL:SetAllPoints(icon)
		castHL:SetColorTexture(1, 1, 1, 0.4)
		castHL:Hide()
		btn.CastHighlight = castHL

		btn:RegisterForClicks("AnyUp", "AnyDown")

		btn:SetScript("OnEnter", function(self)
			_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			if self.hsType == "spell" then
				_G.GameTooltip:SetSpellByID(self.hsID)
			elseif self.hsType == "item" then
				_G.GameTooltip:SetItemByID(self.hsID)
			else
				_G.GameTooltip:AddLine(L["Housing Dashboard"])
			end
			_G.GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", function()
			_G.GameTooltip:Hide()
		end)
		btn:HookScript("PostClick", function(self)
			if self.hsType == "housing" then
				if _G.HousingFramesUtil and _G.HousingFramesUtil.ToggleHousingDashboard then
					_G.HousingFramesUtil.ToggleHousingDashboard()
				end
				flyout:Hide()
			else
				self.CastHighlight:Show()
			end
		end)

		_hearthButtons[i] = btn
	end

	flyout:SetScript("OnShow", function(self)
		self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		self:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
		self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
		self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
		self:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
		self:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
		RefreshPortalButtons()
		ResolveHearthButtons()
		catcher:Show()
	end)
	flyout:SetScript("OnHide", function(self)
		self:UnregisterAllEvents()
		for _, btn in ipairs(_portalFlyoutButtons) do
			btn.CastHighlight:Hide()
		end
		for _, btn in ipairs(_hearthButtons) do
			btn.CastHighlight:Hide()
		end
		catcher:Hide()
	end)
	flyout:SetScript("OnEvent", function(_, event, unit, _, spellID)
		if event == "SPELL_UPDATE_COOLDOWN" then
			RefreshPortalButtons()
			RefreshHearthCooldowns()
		elseif unit == "player" then
			local casting = (event == "UNIT_SPELLCAST_START") and spellID or nil
			for _, btn in ipairs(_portalFlyoutButtons) do
				btn.CastHighlight:SetShown(casting ~= nil and casting == btn.spellID)
			end
			if not casting then
				for _, btn in ipairs(_hearthButtons) do
					btn.CastHighlight:Hide()
				end
			end
		end
	end)

	_portalFlyout = flyout
	return flyout
end

local function TogglePortalFlyout(anchorBtn)
	if InCombatLockdown() then
		return
	end

	local flyout = CreatePortalFlyout()
	if flyout:IsShown() then
		flyout:Hide()
		return
	end

	flyout:ClearAllPoints()
	flyout:SetPoint("TOPRIGHT", anchorBtn, "BOTTOMRIGHT", 0, -F.Dpi(4))
	flyout:Show()
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
		if _portalFlyout and _portalFlyout:IsShown() then
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
-- Layout / lifecycle
-------------------------------------------------------------------------------
function module:UpdateLayout()
	local db = self.db
	if not db or not self.holder then
		return
	end

	local size = F.Dpi(db.size)
	local visible = {}

	if db.greatVault.enable then
		self.greatVaultButton:SetSize(size, size)
		visible[#visible + 1] = self.greatVaultButton
	end
	if db.mplusPortals.enable then
		self.portalButton:SetSize(size, size)
		visible[#visible + 1] = self.portalButton
	end

	for _, btn in ipairs({ self.greatVaultButton, self.portalButton }) do
		btn:Hide()
		btn:ClearAllPoints()
	end

	local spacing = F.Dpi(db.spacing)
	local prev
	for _, btn in ipairs(visible) do
		if not prev then
			btn:SetPoint("TOP", self.holder, "TOP", 0, 0)
		else
			btn:SetPoint("TOP", prev, "BOTTOM", 0, -spacing)
		end
		btn:Show()
		prev = btn
	end
end

function module:UpdatePosition()
	local db = self.db
	if not db or not self.holder then
		return
	end

	self.holder:ClearAllPoints()
	self.holder:SetPoint(db.point, Minimap, db.point, F.Dpi(db.xOffset), F.Dpi(db.yOffset))
end

function module:SettingsUpdate()
	if not self.Initialized then
		return
	end

	if not self.holder then
		self:CreateButtons()
	end

	self:UpdatePosition()
	self:UpdateLayout()
end

function module:CreateButtons()
	local holder = CreateFrame("Frame", "MER_MinimapButtonsHolder", Minimap)
	holder:SetSize(1, 1)
	holder:SetFrameLevel(Minimap:GetFrameLevel() + 10)
	holder:SetFrameStrata(Minimap:GetFrameStrata())
	E.FrameLocks[holder] = true
	self.holder = holder

	self.greatVaultButton = CreateGreatVaultButton(holder)
	self.portalButton = CreatePortalButton(holder)
end

function module:Disable()
	if not self.Initialized or not self.holder then
		return
	end

	self.holder:Hide()
end

function module:Enable()
	if not self.Initialized then
		return
	end

	self:SettingsUpdate()

	if self.holder then
		self.holder:Show()
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
