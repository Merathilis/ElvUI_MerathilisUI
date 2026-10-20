local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_AddonManager") ---@class AddonManager

-- Dependencies in the addon list: turning an addon on also turns on what it
-- needs, turning off an addon others need asks whether those go off too, and
-- the addon tooltip colors the dependencies and lists who needs the addon.

local _G = _G
local format, ipairs, next, select, strsub, tconcat, tinsert, unpack, wipe =
	format, ipairs, next, select, strsub, table.concat, tinsert, unpack, wipe

local hooksecurefunc = hooksecurefunc

local DisableAddOn = C_AddOns.DisableAddOn
local DoesAddOnExist = C_AddOns.DoesAddOnExist
local EnableAddOn = C_AddOns.EnableAddOn
local GetAddOnDependencies = C_AddOns.GetAddOnDependencies
local GetAddOnEnableState = C_AddOns.GetAddOnEnableState
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local GetAddOnName = C_AddOns.GetAddOnName
local GetAddOnOptionalDependencies = C_AddOns.GetAddOnOptionalDependencies
local GetNumAddOns = C_AddOns.GetNumAddOns

local ENABLE_STATE_NONE = Enum.AddOnEnableState.None

local COLOR_ON = "ff33dd55"
local COLOR_OFF = "ffff9933"
local COLOR_MISSING = "ffff4040"

-- [addon] = { addons that require it }, built once, dependencies don't change while playing
local dependents
-- [addon index] = extra tooltip lines, cleared on every list update (enable states change)
local tooltipCache = {}

---The character the list shows: "All" (nil) or the player, the only two choices in the game.
---Read from the dropdown text, Blizzard keeps the selection itself to itself.
---@return string? character
local function GetListCharacter()
	local dropdown = _G.AddonList.Dropdown
	local text = dropdown and dropdown.Text and dropdown.Text:GetText()
	if text == _G.ALL then
		return nil
	end

	return E.myguid
end

local function IsEnabled(addon, character)
	return GetAddOnEnableState(addon, character) > ENABLE_STATE_NONE
end

local function GetDependents()
	if not dependents then
		dependents = {}
		for i = 1, GetNumAddOns() do
			local name = GetAddOnName(i)
			for _, dep in ipairs({ GetAddOnDependencies(i) }) do
				dependents[dep] = dependents[dep] or {}
				tinsert(dependents[dep], name)
			end
		end
	end

	return dependents
end

---Required addons of an addon and theirs, each once, the deepest first
---@param addon string|number
---@param result table?
---@param seen table?
---@return string[] result
local function CollectDependencies(addon, result, seen)
	result, seen = result or {}, seen or {}
	for _, dep in ipairs({ GetAddOnDependencies(addon) }) do
		if not seen[dep] and DoesAddOnExist(dep) then
			seen[dep] = true
			CollectDependencies(dep, result, seen)
			tinsert(result, dep)
		end
	end

	return result
end

---Enabled addons that need this addon, directly or through another one
---@param name string
---@param character string?
---@param result table?
---@param seen table?
---@return string[] result
local function CollectEnabledDependents(name, character, result, seen)
	result, seen = result or {}, seen or { [name] = true }
	for _, dependent in ipairs(GetDependents()[name] or {}) do
		if not seen[dependent] and IsEnabled(dependent, character) then
			seen[dependent] = true
			tinsert(result, dependent)
			CollectEnabledDependents(dependent, character, result, seen)
		end
	end

	return result
end

--[[----------------------------------
--	Enable and disable
--]]
----------------------------------
local function DisableDependents(_, data)
	for _, dependent in ipairs(data.dependents) do
		DisableAddOn(dependent, data.character)
	end
	_G.AddonList_Update()
end

E.PopupDialogs.MER_ADDON_DEPENDENTS = {
	text = L["%s is needed by %s. Turn those off as well?"],
	button1 = L["Turn Off"],
	button2 = L["Keep"],
	OnAccept = DisableDependents,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3,
}

-- Runs after Blizzard switched a single addon by its check button
local function OnAddonEnable(index, enabled)
	local db = module.db
	if not db.enable then
		return
	end

	local character = GetListCharacter()
	local name = GetAddOnName(index)

	if enabled and db.enableDependencies then
		local changed = false
		for _, dep in ipairs(CollectDependencies(index)) do
			if not IsEnabled(dep, character) then
				EnableAddOn(dep, character)
				changed = true
			end
		end

		if changed then
			_G.AddonList_Update()
		end
	elseif not enabled and db.warnDependents then
		local found = CollectEnabledDependents(name, character)
		if next(found) then
			local title = _G.C_AddOns.GetAddOnTitle(index)
			E:StaticPopup_Show(
				"MER_ADDON_DEPENDENTS",
				title ~= "" and title or name,
				tconcat(found, ", "),
				{ dependents = found, character = character }
			)
		end
	end
end

--[[----------------------------------
--	Tooltip
--]]
----------------------------------
local function ColorAddOn(addon)
	local color
	if not DoesAddOnExist(addon) then
		color = COLOR_MISSING
	elseif IsEnabled(addon, GetListCharacter()) then
		color = COLOR_ON
	else
		color = COLOR_OFF
	end

	return format("|c%s%s|r", color, addon)
end

local function ColorList(...)
	local list = {}
	for i = 1, select("#", ...) do
		local addon = select(i, ...)
		if addon then
			tinsert(list, ColorAddOn(addon))
		end
	end

	return tconcat(list, ", ")
end

local function BuildTooltipInfo(index)
	local name = GetAddOnName(index)
	local info = {
		deps = ColorList(GetAddOnDependencies(index)),
		optional = ColorList(GetAddOnOptionalDependencies(index)),
		author = GetAddOnMetadata(index, "Author"),
		locked = module:IsLocked(name),
	}

	local needed = GetDependents()[name]
	info.requiredBy = needed and ColorList(unpack(needed)) or ""

	return info
end

-- Blizzard rebuilds the tooltip every frame while a row is hovered, so the
-- lines are cached per addon until the list changes
local function OnTooltipUpdate(owner)
	local db = module.db
	if not db.enable or not db.extendedTooltip then
		return
	end

	local tooltip = _G.AddonTooltip
	local index = owner:GetID()
	local info = tooltipCache[index]
	if not info then
		info = BuildTooltipInfo(index)
		tooltipCache[index] = info
	end

	-- Blizzard's plain "Dependencies:" line gets the colored names
	local prefix = _G.ADDON_DEPENDENCIES
	if info.deps ~= "" then
		for i = 2, tooltip:NumLines() do
			local line = _G["AddonTooltipTextLeft" .. i]
			local text = line and line:GetText()
			if text and strsub(text, 1, #prefix) == prefix then
				line:SetText(prefix .. info.deps)
				break
			end
		end
	end

	local normal = _G.NORMAL_FONT_COLOR
	local added = false
	local function AddLine(label, text)
		if text and text ~= "" then
			if not added then
				tooltip:AddLine(" ")
				added = true
			end
			tooltip:AddLine(normal:WrapTextInColorCode(label) .. text, 1, 1, 1, true)
		end
	end

	AddLine(L["Optional: "], info.optional)
	AddLine(L["Required by: "], info.requiredBy)
	AddLine(L["Author: "], info.author)

	if info.locked then
		local accent = module.colors.accent
		tooltip:AddLine(L["Locked"], accent[1], accent[2], accent[3])
	end

	tooltip:Show()
end

---Cached tooltip lines follow the next hover, called on every list update
function module:ClearDependencyCache()
	wipe(tooltipCache)
end

function module:SetupDependencies()
	-- Both globals are looked up on every call (row scripts), so the hooks see them all
	hooksecurefunc("AddonList_Enable", OnAddonEnable)
	hooksecurefunc("AddonTooltip_Update", OnTooltipUpdate)
end
