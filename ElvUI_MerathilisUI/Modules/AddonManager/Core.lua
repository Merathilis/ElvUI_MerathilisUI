local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_AddonManager") ---@class AddonManager

-- Addon Manager: addon profiles, locked addons and a wider search for Blizzard's
-- addon list (AddonList of Blizzard_AddOnList, loaded at login). Everything is a
-- hook, no Blizzard function or global gets replaced. Profiles and locks are
-- account wide (E.global), a profile switches the addons of the current character.

local _G = _G
local format, next, pairs, sort, strfind, strlower, strtrim, tconcat, tinsert, unpack =
	format, next, pairs, sort, strfind, strlower, strtrim, table.concat, tinsert, unpack

local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame
local IsAltKeyDown = IsAltKeyDown
local GameTooltip = GameTooltip

local DisableAddOn = C_AddOns.DisableAddOn
local DoesAddOnExist = C_AddOns.DoesAddOnExist
local EnableAddOn = C_AddOns.EnableAddOn
local GetAddOnEnableState = C_AddOns.GetAddOnEnableState
local GetAddOnInfo = C_AddOns.GetAddOnInfo
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local GetAddOnName = C_AddOns.GetAddOnName
local GetAddOnTitle = C_AddOns.GetAddOnTitle
local GetNumAddOns = C_AddOns.GetNumAddOns
local SaveAddOns = C_AddOns.SaveAddOns
local C_UI_Reload = C_UI.Reload

local ENABLE_STATE_NONE = Enum.AddOnEnableState.None

local function IsEnabled(addon, character)
	return GetAddOnEnableState(addon, character) > ENABLE_STATE_NONE
end

-- Blizzard's own addons (Blizzard_*) are never part of a profile
local function IsUserAddOn(index)
	local _, _, _, _, _, security = GetAddOnInfo(index)
	return security ~= "SECURE"
end

local function IsListShown()
	local list = _G.AddonList
	return list and list:IsShown()
end

local function RefreshList()
	if IsListShown() then
		_G.AddonList_Update()
	end
end

-- Options page and profile panel
local function RefreshOptions()
	E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
	module:UpdateProfilePanel()
end
module.OnProfilesChanged = RefreshOptions

--[[----------------------------------
--	Locks
--]]
----------------------------------
---@param name string addon folder name
function module:IsLocked(name)
	return self.db.locked[name] == true
end

---@param name string addon folder name
---@param locked boolean
function module:SetLocked(name, locked)
	-- false instead of nil, so the default locks (ElvUI, MerathilisUI) stay unlocked
	self.db.locked[name] = locked and true or false
	if locked and self:EnforceLocks() and not IsListShown() then
		-- Outside the list nothing saves the change, and the list's Cancel would undo it
		SaveAddOns()
	end
	RefreshList()
	RefreshOptions()
end

---Turns locked addons back on that a click in the list or a profile turned off.
---The list keeps its character selection to itself, so this covers the current
---character and "All Characters", the two choices the list offers in the game.
---@return boolean changed
function module:EnforceLocks()
	local changed = false

	for name, locked in pairs(self.db.locked) do
		if locked and DoesAddOnExist(name) then
			if not IsEnabled(name) then
				EnableAddOn(name)
				changed = true
			end

			if not IsEnabled(name, E.myguid) then
				EnableAddOn(name, E.myguid)
				changed = true
			end
		end
	end

	return changed
end

E.PopupDialogs.MER_ADDON_LOCKED_RESTORED = {
	text = L["These locked addons were off and are turned on again: %s\n\nReload the UI to load them?"],
	button1 = _G.RELOADUI,
	button2 = L["Later"],
	OnAccept = C_UI_Reload,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3,
}

---Locked addons turned off outside the game (character select) or by another
---addon don't load. They are turned on again and a reload is offered.
function module:CheckLocksAtLogin()
	if not self.db.enable or not self.db.lockWarning then
		return
	end

	local restored = {}
	for name, locked in pairs(self.db.locked) do
		if locked and DoesAddOnExist(name) and not IsEnabled(name, E.myguid) then
			EnableAddOn(name, E.myguid)
			local title = GetAddOnTitle(name)
			tinsert(restored, title ~= "" and title or name)
		end
	end

	if #restored > 0 then
		sort(restored)
		SaveAddOns()
		E:StaticPopup_Show("MER_ADDON_LOCKED_RESTORED", tconcat(restored, ", "))
	end
end

--[[----------------------------------
--	Profiles
--]]
----------------------------------
---@return string[] names sorted profile names
function module:GetProfileNames()
	local names = {}
	for name in pairs(self.db.profiles) do
		tinsert(names, name)
	end
	sort(names)

	return names
end

---@param name string
---@return number count addons in the profile
function module:GetProfileSize(name)
	local count = 0
	for _ in pairs(self.db.profiles[name] or {}) do
		count = count + 1
	end

	return count
end

---Stores the addons that are on for the current character
---@param name string
function module:SaveProfile(name)
	local addons = {}
	for i = 1, GetNumAddOns() do
		if IsUserAddOn(i) and IsEnabled(i, E.myguid) then
			addons[GetAddOnName(i)] = true
		end
	end

	self.db.profiles[name] = addons
	RefreshOptions()
	F.Print(format(L["Addon profile %s saved."], F.String.MERATHILISUI(name)))
end

---Turns the addons of a profile on and every other addon off, locked addons stay on.
---Inside the addon list the change waits for its Reload button (Cancel undoes it),
---elsewhere it is saved and the UI reloads.
---@param name string
---@return boolean found
function module:LoadProfile(name)
	local addons = self.db.profiles[name]
	if not addons then
		F.Print(format(L["There is no addon profile called %s."], F.String.MERATHILISUI(name)))
		return false
	end

	for i = 1, GetNumAddOns() do
		local addon = GetAddOnName(i)
		if IsUserAddOn(i) and not self:IsLocked(addon) then
			if addons[addon] then
				EnableAddOn(i, E.myguid)
			else
				DisableAddOn(i, E.myguid)
			end
		end
	end

	self:EnforceLocks()

	if IsListShown() then
		_G.AddonList_Update()
	else
		SaveAddOns()
		C_UI_Reload()
	end

	return true
end

---@param oldName string
---@param newName string
function module:RenameProfile(oldName, newName)
	local profiles = self.db.profiles
	if not profiles[oldName] or oldName == newName then
		return
	end

	profiles[newName] = profiles[oldName]
	profiles[oldName] = nil
	self:RenameInstanceProfile(oldName, newName)
	RefreshOptions()
end

---@param name string
function module:DeleteProfile(name)
	self.db.profiles[name] = nil
	self:RenameInstanceProfile(name, nil)
	RefreshOptions()
end

-- Save As (no data.rename) or Rename (data.rename = old name)
local function AcceptProfileName(popup)
	local data = popup.data or {}
	local name = strtrim(popup.editBox:GetText() or "")
	if name == "" then
		return
	end

	if module.db.profiles[name] and name ~= data.rename then
		F.Print(format(L["There already is an addon profile called %s."], F.String.MERATHILISUI(name)))
		return
	end

	if data.rename then
		module:RenameProfile(data.rename, name)
	else
		module:SaveProfile(name)
	end
end

E.PopupDialogs.MER_ADDON_PROFILE_NAME = {
	text = L["Name of the addon profile:"],
	button1 = _G.ACCEPT,
	button2 = _G.CANCEL,
	hasEditBox = 1,
	maxLetters = 40,
	OnShow = function(self, data)
		self.editBox:SetText(data and data.rename or "")
		self.editBox:HighlightText()
		self.editBox:SetFocus()
	end,
	OnAccept = AcceptProfileName,
	EditBoxOnEnterPressed = function(self)
		local popup = self:GetParent()
		AcceptProfileName(popup)
		popup:Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3,
}

E.PopupDialogs.MER_ADDON_PROFILE_DELETE = {
	text = L["Delete the addon profile %s?"],
	button1 = _G.DELETE,
	button2 = _G.CANCEL,
	OnAccept = function(_, name)
		module:DeleteProfile(name)
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3,
}

function module:ShowSaveProfilePopup()
	E:StaticPopup_Show("MER_ADDON_PROFILE_NAME", nil, nil, {})
end

---@param name string
function module:ShowRenameProfilePopup(name)
	E:StaticPopup_Show("MER_ADDON_PROFILE_NAME", nil, nil, { rename = name })
end

---@param name string
function module:ShowDeleteProfilePopup(name)
	E:StaticPopup_Show("MER_ADDON_PROFILE_DELETE", name, nil, name)
end

--[[----------------------------------
--	Addon list: rows
--]]
----------------------------------
local function UpdateLockButton(entry)
	local button = entry.MERLock
	if not button then
		return
	end

	local name = GetAddOnName(entry:GetID())
	local locked = module.db.enable and module:IsLocked(name)

	-- Unlocked rows only show the lock while hovered
	button:SetShown(module.db.enable and (locked or entry:IsMouseOver()))
	if locked then
		button.icon:SetVertexColor(unpack(module.colors.accent))
		button.icon:SetAlpha(1)
	else
		button.icon:SetVertexColor(1, 1, 1)
		button.icon:SetAlpha(0.35)
	end

	entry.Enabled:SetEnabled(not locked)
end

local function OnRowHover(entry)
	UpdateLockButton(entry)
	module.UpdateRowHover(entry)
end

local function LockButton_OnClick(button)
	local name = GetAddOnName(button:GetParent():GetID())
	module:SetLocked(name, not module:IsLocked(name))
end

local function LockButton_OnEnter(button)
	local name = GetAddOnName(button:GetParent():GetID())

	GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
	GameTooltip:AddLine(module:IsLocked(name) and L["Locked"] or L["Lock"])
	GameTooltip:AddLine(
		L["A locked addon stays on: Disable All, a profile or a click in the list can't turn it off."],
		1,
		1,
		1,
		true
	)
	GameTooltip:AddLine(
		L["Covers this character and All Characters, not other characters picked in the list."],
		0.6,
		0.6,
		0.6,
		true
	)
	GameTooltip:Show()
end

local function LockButton_OnLeave(button)
	GameTooltip:Hide()
	OnRowHover(button:GetParent())
end

local function CreateLockButton(entry)
	local button = CreateFrame("Button", nil, entry)
	button:SetSize(14, 14)
	module:PlaceLock(button)

	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetAllPoints()
	button.icon:SetTexture(I.Media.Icons.Lock)

	button:SetScript("OnClick", LockButton_OnClick)
	button:SetScript("OnEnter", LockButton_OnEnter)
	button:SetScript("OnLeave", LockButton_OnLeave)

	-- Moving onto the lock leaves the row, IsMouseOver keeps the lock shown then
	entry:HookScript("OnEnter", OnRowHover)
	entry:HookScript("OnLeave", OnRowHover)
	entry:HookScript("OnClick", function(row, mouseButton)
		if mouseButton == "LeftButton" and IsAltKeyDown() and module.db.enable then
			module:OnRowAltClick(row)
		end
	end)

	entry.MERLock = button
end

local function InitEntry(entry)
	if not entry.MERLock then
		if not module.db.enable then
			return
		end
		CreateLockButton(entry)
	end

	UpdateLockButton(entry)
	module:StyleEntry(entry, module.db.enable and module:IsLocked(GetAddOnName(entry:GetID())))
	module:AddVersion(entry)
end

-- Runs after Blizzard's initializer (and ElvUI's hook on it) for every shown row
local function OnRowInitialized(_, row, node)
	local data = node and node:GetData()
	if not data then
		return
	end

	if data.addonIndex then
		InitEntry(row)
	elseif data.category then
		module:StyleCategory(row)
	end
end

--[[----------------------------------
--	Addon list: search
--]]
----------------------------------
local function Contains(text, search)
	return text and strfind(strlower(text), search, 1, true)
end

-- Blizzard's search covers title, group and category, this adds the folder name,
-- the author and the notes. Matches are added on top of Blizzard's own result.
function module:ExtendSearch()
	local list = _G.AddonList
	local search = strlower(list.SearchBox:GetText() or "")
	local provider = list.ScrollBox:GetDataProvider()
	if search == "" or not provider then
		return
	end

	local listed = {}
	provider:ForEach(function(node)
		local index = node:GetData().addonIndex
		if index then
			listed[index] = true
		end
	end, _G.TreeDataProviderConstants.IncludeCollapsed)

	for i = 1, GetNumAddOns() do
		if not listed[i] then
			local name, _, notes = GetAddOnInfo(i)
			if Contains(name, search) or Contains(GetAddOnMetadata(i, "Author"), search) or Contains(notes, search) then
				provider:Insert({ addonIndex = i })
			end
		end
	end
end

local updating = false
local function OnListUpdate()
	if updating or not module.db.enable then
		return
	end

	module:ClearDependencyCache()

	if module:EnforceLocks() then
		updating = true
		_G.AddonList_Update()
		updating = false
	end

	if module.db.extendedSearch then
		module:ExtendSearch()
	end

	module:ApplyFilter()
end

--[[----------------------------------
--	Setup
--]]
----------------------------------
function module:SetupList()
	local list = _G.AddonList
	if self.listReady or not list then
		return
	end

	self.listReady = true

	-- Every change in the list ends in the AddonList_Update global, only the search
	-- box calls the function it got at load and needs its own hook
	hooksecurefunc("AddonList_Update", OnListUpdate)
	list.SearchBox:HookScript("OnTextChanged", OnListUpdate)
	_G.ScrollUtil.AddInitializedFrameCallback(list.ScrollBox, OnRowInitialized, self)
	self:SetupDependencies()

	-- The frame parts build on ElvUI's skin, so they wait for the first open
	list:HookScript("OnShow", function()
		if not self.style then
			self:StyleList(list)
			self:UpdateStyle()
		end
	end)

	self:CreateProfilePanel(list)
	self:CreateFilterButton(list)
end

---Applies the enable toggle, hooks are only set the first time it is on
function module:UpdateState()
	if self.db.enable then
		self:SetupList()
	end

	if self.profileButton then
		self.profileButton:SetShown(self.db.enable)
		self:SetProfilePanelShown(self.db.profilePanel)
	end

	self:UpdateStyle()
	self:UpdateFilterButton()
	self:UpdateInstanceProfiles()

	RefreshList()
end

function module:Initialize()
	self.db = E.global.mui.addonManager
	self:UpdateState()

	F.Event.RegisterOnceCallback("MER.InitializedSafe", function()
		E:Delay(2, function()
			-- A running search for a faulty addon goes on after its reload, also with the module off
			if self.db.bisect then
				self:ResumeBisect()
			else
				self:CheckLocksAtLogin()
			end
		end)
	end)
end

MER:AddCommand("ADDONPROFILES", { "/muiaddons" }, function(msg)
	if not module.db.enable then
		F.Print(L["The Addon Manager is off, turn it on in the options under Modules."])
		return
	end

	local name = strtrim(msg or "")
	if name ~= "" then
		module:LoadProfile(name)
		return
	end

	local names = module:GetProfileNames()
	F.Print(L["Usage: /muiaddons <profile> loads an addon profile and reloads the UI."])
	F.Print(L["Addon Profiles"] .. ": " .. (next(names) and tconcat(names, ", ") or L["No profiles yet"]))
end)

MER:RegisterModule(module:GetName())
