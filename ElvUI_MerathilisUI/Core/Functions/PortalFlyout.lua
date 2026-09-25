local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local S = E:GetModule("Skins") ---@type Skins
local WS = W:GetModule("Skins")

local _G = _G
local ipairs, pcall = ipairs, pcall
local ceil, floor, random = math.ceil, math.floor, math.random

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsPlayerSpell = IsPlayerSpell
local IsInInstance = IsInInstance
local UnitClass = UnitClass
local PlayerHasToy = PlayerHasToy
local C_Spell = C_Spell
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

		local btn = CreateFrame("Button", "MER_PortalFlyoutButton" .. i, flyout, "SecureActionButtonTemplate")
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
		local btn = CreateFrame("Button", "MER_PortalFlyoutHearth" .. i, flyout, "SecureActionButtonTemplate")
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

function PortalFlyout.IsShown()
	return _portalFlyout ~= nil and _portalFlyout:IsShown()
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
