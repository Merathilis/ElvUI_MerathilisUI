local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

local ipairs, next = ipairs, next
local tinsert = tinsert

-------------------------------------------------------------------------------
--  Sidebar views
-------------------------------------------------------------------------------
-- The fixed rows at the top of the bag and bank sidebars are views: the bag's
-- All Items / OneBag / MultiBag and the bank's All Bank Tabs / OneBank /
-- All Warband Tabs / OneWarband. A right-click on one of them (or on the
-- Pinned Items / Recent Items rows) opens a checkbox menu to pick which of
-- them the sidebar lists. Hiding a view only drops its row, the view itself
-- keeps working (the bag bar still jumps into MultiBag, a bank tab click
-- still opens its bank). The last listed view of a frame can't be hidden.
-- Pinned Items and Recent Items are their Show switches from the options.

local BAG_VIEWS = { "ALL", "CATEGORY", "BAG" }

local function GetBankViews()
	local views = {}
	if #module.BankBagIDs > 0 then
		tinsert(views, "BANK_ALL")
		tinsert(views, "ONEBANK")
	end
	if #module.WarbandBagIDs > 0 then
		tinsert(views, "WARBAND_ALL")
		tinsert(views, "ONEWARBAND")
	end
	return views
end

local function GetHiddenTable(isBank, create)
	local db = module.db
	local field = isBank and "hiddenBankViews" or "hiddenViews"
	if create and not db[field] then
		db[field] = {}
	end
	return db[field]
end

function module:IsSidebarViewShown(key, isBank)
	local hidden = GetHiddenTable(isBank)
	return not (hidden and hidden[key])
end

local function CountShownViews(isBank)
	local count = 0
	for _, key in ipairs(isBank and GetBankViews() or BAG_VIEWS) do
		if module:IsSidebarViewShown(key, isBank) then
			count = count + 1
		end
	end
	return count
end

-- The view the bags open on: the profile default (OneBag) while it is listed,
-- else the first listed one.
function module:GetOpeningBagView()
	local default = P.bags.categorizedBags.viewMode
	if module:IsSidebarViewShown(default) then
		return default
	end

	for _, key in ipairs(BAG_VIEWS) do
		if module:IsSidebarViewShown(key) then
			return key
		end
	end

	return default
end

-- The bank opens on its "All ... Tabs" view of the bank the player can use
-- (preferred), falling back to that bank's flat view and then to any listed one.
local FLAT_BANK_VIEW = { BANK_ALL = "ONEBANK", WARBAND_ALL = "ONEWARBAND" }

function module:GetOpeningBankView(preferred)
	if module:IsSidebarViewShown(preferred, true) then
		return preferred
	end

	local flat = FLAT_BANK_VIEW[preferred]
	if flat and module:IsSidebarViewShown(flat, true) then
		return flat
	end

	for _, key in ipairs(GetBankViews()) do
		if module:IsSidebarViewShown(key, true) then
			return key
		end
	end

	return preferred
end

-- The open view lost its row: switch to the one the frame opens on.
function module:EnsureShownBagView()
	local db = module.db
	if not module:IsSidebarViewShown(db.viewMode) then
		db.viewMode = module:GetOpeningBagView()
		if module.frame and module.frame.mainScroll then
			module.frame.mainScroll:SetVerticalScroll(0)
		end
		return true
	end
end

function module:EnsureShownBankView()
	if not module:IsSidebarViewShown(module.bankViewMode, true) then
		local isWarband = module.bankViewMode == "WARBAND_ALL" or module.bankViewMode == "ONEWARBAND"
		module.bankViewMode = module:GetOpeningBankView(isWarband and "WARBAND_ALL" or "BANK_ALL")
		module.bankTabFilter = nil
		if module.bankFrame and module.bankFrame.mainScroll then
			module.bankFrame.mainScroll:SetVerticalScroll(0)
		end
		return true
	end
end

local function RefreshBoth()
	module:RefreshCategoryFrame()
	module:RefreshBankCategoryFrame()
end

local function ToggleView(data)
	local key, isBank = data.key, data.isBank
	if module:IsSidebarViewShown(key, isBank) then
		if CountShownViews(isBank) <= 1 then
			return
		end
		GetHiddenTable(isBank, true)[key] = true
	else
		local hidden = GetHiddenTable(isBank)
		hidden[key] = nil
		if next(hidden) == nil then
			module.db[isBank and "hiddenBankViews" or "hiddenViews"] = nil
		end
	end

	if isBank then
		module:EnsureShownBankView()
		module:RefreshBankCategoryFrame()
	else
		module:EnsureShownBagView()
		module:RefreshCategoryFrame()
		module:RefreshBagBarPopout()
	end
end

local function IsViewChecked(data)
	return module:IsSidebarViewShown(data.key, data.isBank)
end

local SHOW_SWITCHES = { "showPinned", "showRecent" }

local function IsSwitchOn(field)
	return module.db[field] and true or false
end

local function ToggleSwitch(field)
	module.db[field] = not module.db[field]
	RefreshBoth()
	-- An open options page shows the switch as it is now
	E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
end

-- The views of the frame the menu was opened on, under the names its rows show
function module:OpenSidebarViewsMenu(owner, isBank)
	if not _G.MenuUtil or not _G.MenuUtil.CreateContextMenu then
		return
	end

	local labels = {}
	if isBank then
		local f = module.bankFrame
		for _, def in ipairs(f and f.bankModeDefs or {}) do
			labels[def.bankViewMode] = def.label
		end
	else
		local f = module.frame
		for _, row in ipairs(f and f.viewModeRows or {}) do
			labels[row.viewModeKey] = row.text:GetText()
		end
	end

	_G.MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
		rootDescription:CreateTitle(L["Show in Sidebar"])

		for _, key in ipairs(isBank and GetBankViews() or BAG_VIEWS) do
			local data = { key = key, isBank = isBank }
			local box = rootDescription:CreateCheckbox(labels[key] or key, IsViewChecked, ToggleView, data)
			box:SetEnabled(function()
				return not module:IsSidebarViewShown(key, isBank) or CountShownViews(isBank) > 1
			end)
		end

		rootDescription:CreateDivider()

		local names = {
			showPinned = module.PinnedCategory.name,
			showRecent = module.RecentCategory.name,
		}
		for _, field in ipairs(SHOW_SWITCHES) do
			rootDescription:CreateCheckbox(names[field], IsSwitchOn, ToggleSwitch, field)
		end
	end)
end

-- Stacks a frame's fixed sidebar rows (the listed views, then Pinned Items
-- while it is shown) from the top, hides the rest, and moves the separator
-- and the scrollable list right below whatever is left.
-- rows: { { frame = row, shown = bool }, ... }
function module.LayoutFixedSidebarRows(f, rows, pinnedShown)
	local rowHeight = module.VIEW_MODE_ROW_HEIGHT
	local y = 18
	local last

	for _, entry in ipairs(rows) do
		local row = entry.frame
		row:SetShown(entry.shown)
		if entry.shown then
			row:ClearAllPoints()
			row:Point("TOPLEFT", f.sidebar, "TOPLEFT", 4, -y)
			row:Point("TOPRIGHT", f.sidebar, "TOPRIGHT", -4, -y)
			y = y + rowHeight
			last = row
		end
	end

	f.pinnedRow:SetShown(pinnedShown)
	if pinnedShown then
		f.pinnedRow:ClearAllPoints()
		f.pinnedRow:Point("TOPLEFT", f.sidebar, "TOPLEFT", 4, -y)
		f.pinnedRow:Point("TOPRIGHT", f.sidebar, "TOPRIGHT", -4, -y)
		y = y + rowHeight
		last = f.pinnedRow
	end

	f.sidebarSeparator:ClearAllPoints()
	if last then
		f.sidebarSeparator:Point("TOPLEFT", last, "BOTTOMLEFT", 2, -3)
		f.sidebarSeparator:Point("TOPRIGHT", last, "BOTTOMRIGHT", -2, -3)
	end
	f.sidebarSeparator:SetShown(last ~= nil)

	f.sidebarScroll:ClearAllPoints()
	f.sidebarScroll:Point("TOPLEFT", 4, -y - 10)
	f.sidebarScroll:Point("BOTTOMRIGHT", -module.SIDEBAR_SCROLLBAR_INSET, 4)
end
