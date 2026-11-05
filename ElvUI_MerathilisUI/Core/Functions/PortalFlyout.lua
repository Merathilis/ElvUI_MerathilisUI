local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local S = E:GetModule("Skins") ---@type Skins
local WS = W:GetModule("Skins")

local _G = _G
local ipairs, pcall, tinsert = ipairs, pcall, table.insert
local ceil, floor, random = math.ceil, math.floor, math.random

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local UnitClass = UnitClass
local PlayerHasToy = PlayerHasToy
local C_Spell = C_Spell
local C_SpellBook = C_SpellBook
local C_ChallengeMode = C_ChallengeMode
local C_Container = C_Container
local C_Item = C_Item
local C_ToyBox = C_ToyBox

-------------------------------------------------------------------------------
-- Mythic+ portal flyout, shared by every button that opens it (Minimap bar,
-- chat sidebar). One frame for the whole UI: each caller only anchors it.
-------------------------------------------------------------------------------
F.PortalFlyout = {}
local PortalFlyout = F.PortalFlyout

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

-- Class and race travel spells plus travel items, in a row below the portals
-- while the player knows or carries them. supersededBy hides an entry while
-- the player knows its replacement.
local TRAVEL_ENTRIES = {
	{ spellID = 193753 }, -- Dreamwalk (Druid)
	{ spellID = 18960, supersededBy = 193753 }, -- Teleport: Moonglade (Druid)
	{ spellID = 50977 }, -- Death Gate (Death Knight)
	{ spellID = 193759 }, -- Teleport: Hall of the Guardian (Mage)
	{ spellID = 126892 }, -- Zen Pilgrimage (Monk)
	{ spellID = 1238686 }, -- Rootwalking (Haranir)
	{ itemID = 128353 }, -- Admiral's Compass
}

-- Cooldowns this short are the global cooldown, which the APIs also report
local GCD_MAX = 2

local _portalFlyout, _portalFlyoutButtons, _hearthButtons, _travelButtons
local _onHideCallbacks = {}

-- Spell cooldowns are secret while cooldowns are restricted (e.g. in an active key).
-- Tainted code can't compare them or pass them to SetCooldown, so let the engine feed
-- the swipe through a duration object instead.
local function SetSpellCooldown(cooldown, spellID)
	local cdInfo = C_Spell.GetSpellCooldown(spellID)
	if not cdInfo then
		cooldown:Clear()
	elseif E:IsSecretValue(cdInfo.startTime) or E:IsSecretValue(cdInfo.duration) then
		local duration = C_Spell.GetSpellCooldownDuration and C_Spell.GetSpellCooldownDuration(spellID)
		if duration then
			cooldown:SetCooldownFromDurationObject(duration)
		else
			cooldown:Clear()
		end
	elseif cdInfo.startTime and cdInfo.duration and cdInfo.duration > GCD_MAX then
		cooldown:SetCooldown(cdInfo.startTime, cdInfo.duration)
	else
		cooldown:Clear()
	end
end

-- start, duration of an item cooldown; nil when unreadable or secret
local function GetItemCooldown(itemID)
	if not (C_Container and C_Container.GetItemCooldown) then
		return
	end

	local ok, start, duration = pcall(C_Container.GetItemCooldown, itemID)
	if not ok or E:IsSecretValue(start) or E:IsSecretValue(duration) then
		return
	end

	return start, duration
end

local function SetItemCooldown(cooldown, itemID)
	local start, duration = GetItemCooldown(itemID)
	if start and duration > GCD_MAX then
		cooldown:SetCooldown(start, duration)
	else
		cooldown:Clear()
	end
end

local function RefreshPortalButtons()
	if not _portalFlyoutButtons then
		return
	end

	for _, btn in ipairs(_portalFlyoutButtons) do
		local known = C_SpellBook.IsSpellKnown(btn.spellID)
		btn.Icon:SetDesaturated(not known)
		btn.Icon:SetAlpha(known and 1 or 0.4)

		if known then
			SetSpellCooldown(btn.Cooldown, btn.spellID)
		else
			btn.Cooldown:Clear()
		end
	end
end

-------------------------------------------------------------------------------
-- Hearthstone row: Hearthstone slot, Dalaran Hearthstone, Housing Dashboard.
-- The first slot rotates through the owned hearthstone toys, with a Shaman
-- Astral Recall fallback in protected instances.
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
	281615, -- Shadeweaver's Hearthstone
}
-- Toys are account-wide, but these only work on the listed races
local HEARTH_TOY_RACES = {
	[210455] = { Draenei = true, LightforgedDraenei = true }, -- Draenic Hologem
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

-- M+/raid/PvP instance check -- guards cooldown and lockout reads against
-- tainted/secret values while a key or encounter is active.
function F.InProtectedInstance()
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
local InProtectedInstance = F.InProtectedInstance

local function IsHearthOnCD(id)
	if InProtectedInstance() then
		return true
	end
	local start, duration = GetItemCooldown(id)
	return start ~= nil and duration > GCD_MAX
end

-- Slot 1: Shamans with Astral Recall known prefer it in protected instances or
-- while the hearthstones are on cooldown (all hearth toys share one cooldown);
-- otherwise a random owned toy, falling back to the base Hearthstone (6948).
local function ResolveHearthSlot()
	local _, cls = UnitClass("player")
	local isShaman = cls == "SHAMAN" and C_SpellBook.IsSpellKnown(SHAMAN_ASTRAL_RECALL)

	if isShaman and InProtectedInstance() then
		local info = C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(SHAMAN_ASTRAL_RECALL)
		return "spell", SHAMAN_ASTRAL_RECALL, info and info.iconID or 136010
	end

	local owned = {}
	for _, id in ipairs(HEARTH_TOYS) do
		local races = HEARTH_TOY_RACES[id]
		if PlayerHasToy and PlayerHasToy(id) and (not races or races[E.myrace]) then
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
			SetSpellCooldown(btn.Cooldown, id)
		elseif hsType == "item" then
			SetItemCooldown(btn.Cooldown, id)
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

local function IsTravelEntryAvailable(entry)
	if entry.itemID then
		return (C_Item.GetItemCount(entry.itemID) or 0) > 0
	end
	if entry.supersededBy and C_SpellBook.IsSpellKnown(entry.supersededBy) then
		return false
	end
	return C_SpellBook.IsSpellKnown(entry.spellID)
end

local function RefreshTravelCooldowns()
	if not _travelButtons then
		return
	end

	for _, btn in ipairs(_travelButtons) do
		if btn:IsShown() then
			if btn.itemID then
				SetItemCooldown(btn.Cooldown, btn.itemID)
			else
				SetSpellCooldown(btn.Cooldown, btn.spellID)
			end
		end
	end
end

-- One flyout button: icon, cooldown swipe and cast highlight
local function CreateFlyoutButton(flyout, name, size)
	local btn = CreateFrame("Button", name, flyout, "SecureActionButtonTemplate")
	btn:SetSize(size, size)
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
	btn:SetScript("OnLeave", function()
		_G.GameTooltip:Hide()
	end)

	return btn
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

	local flyout = CreateFrame("Frame", "MER_PortalFlyout", E.UIParent)
	flyout:SetSize(width, height)
	flyout:SetFrameStrata("DIALOG")
	flyout:SetClampedToScreen(true)
	flyout:SetTemplate("Transparent")
	flyout:Hide()
	WS:CreateShadow(flyout)
	_G.tinsert(_G.UISpecialFrames, "MER_PortalFlyout")

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

		local btn = CreateFlyoutButton(flyout, "MER_PortalFlyoutButton" .. i, btnSize)
		btn:SetPoint("TOPLEFT", padding + col * (btnSize + spacing), -(padding + row * (btnSize + spacing)))
		btn.spellID = entry.spellID

		local spellInfo = C_Spell.GetSpellInfo(entry.spellID)
		if spellInfo then
			btn.Icon:SetTexture(spellInfo.iconID)
		end

		if entry.short then
			local label = F.CreateFS(btn, 8, entry.short, false, "BOTTOM", 0, 2)
			label:SetTextColor(1, 1, 1, 0.9)
		end

		btn:SetAttribute("type", "spell")
		btn:SetAttribute("spell", entry.spellID)

		btn:SetScript("OnEnter", function(self)
			_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			_G.GameTooltip:SetSpellByID(self.spellID)
			_G.GameTooltip:Show()
		end)

		_portalFlyoutButtons[i] = btn
	end

	_hearthButtons = {}
	for i = 1, hsCount do
		local btn = CreateFlyoutButton(flyout, "MER_PortalFlyoutHearth" .. i, hsH)
		btn:SetPoint("TOPLEFT", hsX, -(padding + (i - 1) * (hsH + spacing)))

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

	-- Travel row below the portals, only the available entries take a place
	_travelButtons = {}
	for i, entry in ipairs(TRAVEL_ENTRIES) do
		local btn = CreateFlyoutButton(flyout, "MER_PortalFlyoutTravel" .. i, btnSize)
		btn.entry = entry
		btn.spellID, btn.itemID = entry.spellID, entry.itemID

		if entry.itemID then
			btn.Icon:SetTexture(C_Item.GetItemIconByID(entry.itemID) or 134414)
			btn:SetAttribute("type", "macro")
			btn:SetAttribute("macrotext", "/use item:" .. entry.itemID)
			-- An item cast carries no spell ID to match, so the click marks it
			btn:HookScript("PostClick", function(self)
				self.CastHighlight:Show()
			end)
		else
			local spellInfo = C_Spell.GetSpellInfo(entry.spellID)
			btn.Icon:SetTexture(spellInfo and spellInfo.iconID or 134414)
			btn:SetAttribute("type", "spell")
			btn:SetAttribute("spell", entry.spellID)
		end

		btn:SetScript("OnEnter", function(self)
			_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			if self.itemID then
				_G.GameTooltip:SetItemByID(self.itemID)
			else
				_G.GameTooltip:SetSpellByID(self.spellID)
			end
			_G.GameTooltip:Show()
		end)

		btn:Hide()
		_travelButtons[i] = btn
	end

	-- Out of combat only: the flyout opens out of combat and closes when it starts
	local function LayoutTravelRow()
		local shown = 0
		for _, btn in ipairs(_travelButtons) do
			local available = IsTravelEntryAvailable(btn.entry)
			btn:SetShown(available)
			if available then
				local col = shown % cols
				local row = rows + (shown - col) / cols
				btn:ClearAllPoints()
				btn:SetPoint("TOPLEFT", padding + col * (btnSize + spacing), -(padding + row * (btnSize + spacing)))
				shown = shown + 1
			end
		end

		flyout:SetHeight(height + ceil(shown / cols) * (btnSize + spacing))
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
		LayoutTravelRow()
		RefreshTravelCooldowns()
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
		for _, btn in ipairs(_travelButtons) do
			btn.CastHighlight:Hide()
		end
		catcher:Hide()
		for _, callback in ipairs(_onHideCallbacks) do
			callback()
		end
	end)
	-- The spellcast events are registered for the player only, the payload may be secret
	flyout:SetScript("OnEvent", function(_, event, _, _, spellID)
		if event == "SPELL_UPDATE_COOLDOWN" then
			RefreshPortalButtons()
			RefreshHearthCooldowns()
			RefreshTravelCooldowns()
		else
			-- The spell ID is secret while spell casts are restricted, no highlight then
			local casting = (event == "UNIT_SPELLCAST_START" and not E:IsSecretValue(spellID)) and spellID or nil
			for _, btn in ipairs(_portalFlyoutButtons) do
				btn.CastHighlight:SetShown(casting ~= nil and casting == btn.spellID)
			end
			for _, btn in ipairs(_travelButtons) do
				if btn.spellID then
					btn.CastHighlight:SetShown(casting ~= nil and casting == btn.spellID)
				elseif not casting then
					btn.CastHighlight:Hide()
				end
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

-- Data access for other features that offer the same teleports (Quick Grid)
function PortalFlyout.GetSeasonPortals()
	return SEASON_PORTALS
end

-- type ("spell"/"item"), id and icon of the hearthstone slot, see ResolveHearthSlot
PortalFlyout.ResolveHearthstone = ResolveHearthSlot

-- type ("item"), id and icon of the Dalaran Hearthstone slot
PortalFlyout.ResolveDalaranHearthstone = ResolveDalaranSlot

function PortalFlyout.IsShown()
	return _portalFlyout ~= nil and _portalFlyout:IsShown()
end

-- For owners that follow the flyout's visibility (e.g. a mouseover fade)
function PortalFlyout.RegisterOnHide(callback)
	tinsert(_onHideCallbacks, callback)
end

function PortalFlyout.Hide()
	if _portalFlyout then
		_portalFlyout:Hide()
	end
end

-- Opens the flyout at the given anchor, or closes it when it is already open.
-- Out of combat only: the flyout carries secure action buttons.
function PortalFlyout.Toggle(anchor, point, relativePoint, x, y)
	if InCombatLockdown() then
		return
	end

	local flyout = CreatePortalFlyout()
	if flyout:IsShown() then
		flyout:Hide()
		return
	end

	flyout:ClearAllPoints()
	flyout:SetPoint(point, anchor, relativePoint, x or 0, y or 0)
	flyout:Show()
end
