local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_AddonManager") ---@class AddonManager

-- Filter for the addon list (all, on, off, changed since opening, locked) and
-- the version behind each title. The filter works on the tree Blizzard built,
-- after the search, and lasts for the session.

local _G = _G
local ipairs, unpack = ipairs, unpack

local CreateFrame = CreateFrame
local MenuUtil = MenuUtil

local GetAddOnEnableState = C_AddOns.GetAddOnEnableState
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local GetAddOnName = C_AddOns.GetAddOnName

local ENABLE_STATE_NONE = Enum.AddOnEnableState.None
local VERSION_MAX_LENGTH = 16

local FILTERS = {
	{ key = "all", text = L["All Addons"] },
	{ key = "enabled", text = L["Enabled Addons"] },
	{ key = "disabled", text = L["Disabled Addons"] },
	{ key = "changed", text = L["Changed Addons"] },
	{ key = "locked", text = L["Locked Addons"] },
}

local filter = "all"

local function IsEnabled(index)
	return GetAddOnEnableState(index, module.GetListCharacter()) > ENABLE_STATE_NONE
end

local MATCHES = {
	enabled = IsEnabled,
	disabled = function(index)
		return not IsEnabled(index)
	end,
	-- Blizzard's own "requires reload" check: the state differs from the one at opening
	changed = function(index)
		local startStatus = _G.AddonList.startStatus
		return startStatus and IsEnabled(index) ~= startStatus[index]
	end,
	locked = function(index)
		return module:IsLocked(GetAddOnName(index))
	end,
}

-- Keeps a node when it matches or one of its children does, empty categories go
local function Prune(node, matches)
	local keep = false
	local children = node:GetNodes()
	for i = #children, 1, -1 do
		local child = children[i]
		if Prune(child, matches) then
			keep = true
		else
			node:Remove(child, true)
		end
	end

	local index = node:GetData().addonIndex
	if index and matches(index) then
		keep = true
	end

	return keep
end

---Removes the rows the filter hides, called after every list update
function module:ApplyFilter()
	local matches = MATCHES[filter]
	local provider = matches and _G.AddonList.ScrollBox:GetDataProvider()
	if not provider then
		return
	end

	local root = provider:GetRootNode()
	local children = root:GetNodes()
	for i = #children, 1, -1 do
		if not Prune(children[i], matches) then
			root:Remove(children[i], true)
		end
	end

	provider:Invalidate()
end

local function SetFilter(key)
	filter = key
	module:UpdateFilterButton()
	_G.AddonList_Update()
end

local function IsSelected(key)
	return filter == key
end

local function FilterMenu(_, root)
	root:SetTag("MENU_MER_ADDON_FILTER")
	root:CreateTitle(L["Show"])
	for _, entry in ipairs(FILTERS) do
		root:CreateRadio(entry.text, IsSelected, SetFilter, entry.key)
	end
end

function module:UpdateFilterButton()
	local button = self.filterButton
	if not button then
		return
	end

	button:SetShown(self.db.enable)

	-- Accent while something is filtered out
	if filter ~= "all" then
		button.icon:SetVertexColor(unpack(self.colors.accent))
	else
		button.icon:SetVertexColor(0.8, 0.8, 0.8)
	end
end

---Filter button left of the search box
---@param list Frame AddonList
function module:CreateFilterButton(list)
	local button = CreateFrame("Button", nil, list)
	button:SetSize(18, 18)
	button:SetPoint("RIGHT", list.SearchBox, "LEFT", -8, 0)

	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetAllPoints()
	button.icon:SetTexture(I.Media.Icons.Filter)

	button:SetScript("OnClick", function()
		MenuUtil.CreateContextMenu(button, FilterMenu)
	end)
	button:SetScript("OnEnter", function()
		_G.GameTooltip:SetOwner(button, "ANCHOR_TOP")
		_G.GameTooltip:AddLine(L["Filter"])
		for _, entry in ipairs(FILTERS) do
			if entry.key == filter then
				_G.GameTooltip:AddLine(entry.text, 1, 1, 1)
			end
		end
		_G.GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		_G.GameTooltip:Hide()
	end)

	self.filterButton = button
	self:UpdateFilterButton()
end

---Adds the version behind the title of a row
---@param entry Button AddonListEntryTemplate
function module:AddVersion(entry)
	if not self.db.enable or not self.db.showVersion then
		return
	end

	local version = GetAddOnMetadata(entry:GetID(), "Version")
	-- Unpackaged addons still carry the packager's placeholder
	if not version or version == "" or version:find("@", 1, true) then
		return
	end

	if #version > VERSION_MAX_LENGTH then
		version = version:sub(1, VERSION_MAX_LENGTH) .. "..."
	end

	local title = entry.Title:GetText() or ""
	entry.Title:SetText(title .. " |cff808080" .. version .. "|r")
end
