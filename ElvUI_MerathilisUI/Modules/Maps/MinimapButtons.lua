local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_MinimapButtons")
local S = E:GetModule("Skins") ---@type Skins
local WS = W:GetModule("Skins")

local _G = _G
local ipairs, format, ceil = ipairs, string.format, math.ceil

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsPlayerSpell = IsPlayerSpell
local C_AddOns = C_AddOns
local C_Spell = C_Spell
local C_WeeklyRewards = C_WeeklyRewards
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

local function CreateGreatVaultButton(parent)
	local btn = CreateFrame("Button", "MER_MinimapGreatVaultButton", parent)
	btn:EnableMouse(true)
	btn:SetTemplate("Transparent")

	local icon = btn:CreateTexture(nil, "ARTWORK")
	icon:SetAtlas(GREAT_VAULT_ATLAS)
	icon:SetPoint("TOPLEFT", 2, -2)
	icon:SetPoint("BOTTOMRIGHT", -2, 2)
	btn.Icon = icon

	btn:SetScript("OnEnter", function(self)
		self.Icon:SetVertexColor(1, 1, 1)
		ShowVaultTooltip(self)
	end)
	btn:SetScript("OnLeave", function(self)
		self.Icon:SetVertexColor(0.85, 0.85, 0.85)
		_G.GameTooltip:Hide()
	end)
	btn:SetScript("OnClick", ToggleGreatVault)

	icon:SetVertexColor(0.85, 0.85, 0.85)

	return btn
end

-------------------------------------------------------------------------------
-- Mythic+ Portals button + flyout
-------------------------------------------------------------------------------
local _portalFlyout, _portalFlyoutButtons

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

local function CreatePortalFlyout()
	if _portalFlyout then
		return _portalFlyout
	end

	local btnSize, spacing, padding, cols = F.Dpi(32), F.Dpi(2), F.Dpi(4), 4
	local rows = ceil(#SEASON_PORTALS / cols)
	local width = padding * 2 + btnSize * cols + spacing * (cols - 1)
	local height = padding * 2 + btnSize * rows + spacing * (rows - 1)

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

	flyout:SetScript("OnShow", function(self)
		self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		RefreshPortalButtons()
		catcher:Show()
	end)
	flyout:SetScript("OnHide", function(self)
		self:UnregisterAllEvents()
		catcher:Hide()
	end)
	flyout:SetScript("OnEvent", RefreshPortalButtons)

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
