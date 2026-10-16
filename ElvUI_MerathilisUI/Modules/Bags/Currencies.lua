local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

local _G = _G
local ipairs, pairs, tostring = ipairs, pairs, tostring
local max = math.max
local tinsert, tremove = tinsert, tremove
local tsort = table.sort

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GameTooltip_Hide = GameTooltip_Hide
local HandleModifiedItemClick = HandleModifiedItemClick
local InCombatLockdown = InCombatLockdown
local C_CurrencyInfo = C_CurrencyInfo

-------------------------------------------------------------------------------
--  Footer currencies
-------------------------------------------------------------------------------
-- Our own per-character list of currencies for the bag footer, so it is not
-- bound to Blizzard's "Show on Backpack" limit of 3. Ticking or unticking a
-- currency in the Currency tab still adds or removes it here; anything added
-- through the options list stays independent of Blizzard's watch state.
--
-- db.currenciesByChar[char] = {
--     tracked = { currencyID, ... }, -- footer order
--     watched = { [currencyID] = true }, -- Blizzard's watch set at the last sync
-- }

-- Blizzard has no fixed upper bound for watched tokens (it depends on the
-- backpack width), so scan until the first gap.
local MAX_WATCHED_SCAN = 20

local BUTTON_SIZE = 20
local ICON_TEXT_GAP = 2
local ITEM_GAP = 14
local ROW_GAP = 4
local RIGHT_PADDING = 6
local GOLD_GAP = 20

-- Base footer height and the frame offsets that sit on top of it, see
-- ConstructFrame in CategoryFrame.lua.
local FOOTER_HEIGHT = 20
local MAINSCROLL_BOTTOM = 36
local SIDEBAR_BOTTOM = 60

local function CharKey()
	return E.myname .. "-" .. E.myrealm
end

local function ReadWatched()
	local watched = {}
	for index = 1, MAX_WATCHED_SCAN do
		local info = C_CurrencyInfo.GetBackpackCurrencyInfo(index)
		if not info then
			break
		end
		if info.currencyTypesID then
			tinsert(watched, info.currencyTypesID)
		end
	end
	return watched
end

local function IndexOf(list, value)
	for index, entry in ipairs(list) do
		if entry == value then
			return index
		end
	end
end

-- Returns this character's state, seeded from Blizzard's watch list in the
-- old drag order (db.currencyOrder) on first use. Without create, a character
-- whose currency data isn't loaded yet gets nil instead of an empty seed, so
-- an early call during login can't lock in an empty list.
function module:GetCurrencyState(create)
	local db = module.db
	local key = CharKey()
	local state = db.currenciesByChar and db.currenciesByChar[key]
	if state then
		return state
	end

	local watched = ReadWatched()
	if #watched == 0 and not create then
		return
	end

	local legacyPosition = {}
	for index, currencyID in ipairs(db.currencyOrder or {}) do
		legacyPosition[currencyID] = index
	end

	local blizzardPosition = {}
	for index, currencyID in ipairs(watched) do
		blizzardPosition[currencyID] = index
	end

	state = { tracked = {}, watched = {} }
	for _, currencyID in ipairs(watched) do
		tinsert(state.tracked, currencyID)
		state.watched[currencyID] = true
	end

	tsort(state.tracked, function(a, b)
		local posA = legacyPosition[a] or (1000 + blizzardPosition[a])
		local posB = legacyPosition[b] or (1000 + blizzardPosition[b])
		return posA < posB
	end)

	db.currenciesByChar = db.currenciesByChar or {}
	db.currenciesByChar[key] = state
	return state
end

function module:IsCurrencyTracked(currencyID)
	local state = module:GetCurrencyState()
	return state and IndexOf(state.tracked, currencyID) and true or false
end

function module:SetCurrencyTracked(currencyID, tracked)
	local state = module:GetCurrencyState(true)
	local index = IndexOf(state.tracked, currencyID)

	if tracked and not index then
		tinsert(state.tracked, currencyID)
	elseif not tracked and index then
		tremove(state.tracked, index)
	end

	module:UpdateFooter()
end

-- Drops this character's list, the next read seeds it from Blizzard's watch
-- list again.
function module:ResetTrackedCurrencies()
	local db = module.db
	if db.currenciesByChar then
		db.currenciesByChar[CharKey()] = nil
	end
	db.currencyOrder = {}

	module:UpdateFooter()
end

-- Applies a "Show on Backpack" change from the Currency tab: a newly watched
-- currency is appended, a no longer watched one removed. Only runs from the
-- watch-change callback, never from a plain footer refresh, so a watch list
-- that is still empty during login can't wipe the tracked ones.
function module:SyncWatchedCurrencies()
	local state = module:GetCurrencyState(true)
	local current = {}
	for _, currencyID in ipairs(ReadWatched()) do
		current[currencyID] = true
	end

	for currencyID in pairs(current) do
		if not state.watched[currencyID] and not IndexOf(state.tracked, currencyID) then
			tinsert(state.tracked, currencyID)
		end
	end

	for currencyID in pairs(state.watched) do
		if not current[currencyID] then
			local index = IndexOf(state.tracked, currencyID)
			if index then
				tremove(state.tracked, index)
			end
		end
	end

	state.watched = current
end

local function MoveCurrency(draggedID, targetID)
	if not draggedID or not targetID or draggedID == targetID then
		return
	end

	local tracked = module:GetCurrencyState(true).tracked
	local from = IndexOf(tracked, draggedID)
	if not from then
		return
	end
	tremove(tracked, from)

	local to = IndexOf(tracked, targetID)
	if to then
		tinsert(tracked, to, draggedID)
	else
		tinsert(tracked, draggedID)
	end
end

-------------------------------------------------------------------------------
--  Options list
-------------------------------------------------------------------------------
-- Every currency of the Currency tab, grouped under its headers, plus a
-- "Retired" block on top for tracked ones that dropped out of that list
-- (seasonal currencies at rollover) so they can still be unticked. Returns
-- the id -> "Name (id)" values and the display order, header entries in the
-- order are { header = name }.
function module:GetCurrencyOptionList()
	local values, order = {}, {}
	local listed = {}

	-- The list only returns rows of expanded headers, so open the collapsed
	-- ones for the scan and close them again afterwards (in reverse, so the
	-- indices of the earlier ones stay valid).
	local collapsed = {}
	local index = 1
	while index <= C_CurrencyInfo.GetCurrencyListSize() do
		local info = C_CurrencyInfo.GetCurrencyListInfo(index)
		if info and info.isHeader and not info.isHeaderExpanded then
			tinsert(collapsed, index)
			C_CurrencyInfo.ExpandCurrencyList(index, true)
		end
		index = index + 1
	end

	local liveOrder = {}
	for i = 1, C_CurrencyInfo.GetCurrencyListSize() do
		local info = C_CurrencyInfo.GetCurrencyListInfo(i)
		if info and info.name then
			if info.isHeader then
				tinsert(liveOrder, { header = info.name })
			elseif info.currencyID and not listed[info.currencyID] then
				listed[info.currencyID] = true
				values[info.currencyID] = info.name .. " (" .. info.currencyID .. ")"
				tinsert(liveOrder, info.currencyID)
			end
		end
	end

	for i = #collapsed, 1, -1 do
		C_CurrencyInfo.ExpandCurrencyList(collapsed[i], false)
	end

	local state = module:GetCurrencyState()
	if state then
		local retired = {}
		for _, currencyID in ipairs(state.tracked) do
			if not listed[currencyID] then
				local info = C_CurrencyInfo.GetCurrencyInfo(currencyID)
				values[currencyID] = (info and info.name or tostring(currencyID)) .. " (" .. currencyID .. ")"
				tinsert(retired, currencyID)
			end
		end

		if #retired > 0 then
			tinsert(order, { header = L["Retired"] })
			for _, currencyID in ipairs(retired) do
				tinsert(order, currencyID)
			end
		end
	end

	for _, entry in ipairs(liveOrder) do
		tinsert(order, entry)
	end

	return values, order
end

-------------------------------------------------------------------------------
--  Footer buttons
-------------------------------------------------------------------------------
local function Currency_OnEnter(self)
	if module.draggingCurrencyID then
		module.dragHoverCurrencyID = self.currencyID
	end

	if not self.currencyID or GameTooltip:IsForbidden() then
		return
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetCurrencyByID(self.currencyID)
	GameTooltip:Show()
end

local function Currency_OnLeave()
	module.dragHoverCurrencyID = nil
	GameTooltip_Hide()
end

-- Shift-click links the currency in chat, like Blizzard's own token buttons.
local function Currency_OnClick(self)
	if self.currencyID then
		HandleModifiedItemClick(C_CurrencyInfo.GetCurrencyLink(self.currencyID))
	end
end

-- Drag one currency onto another to reorder the footer cluster, the same
-- interaction the sidebar categories already use.
local function Currency_OnDragStart(self)
	if InCombatLockdown() or not self.currencyID then
		return
	end

	module.draggingCurrencyID = self.currencyID
	self:SetAlpha(0.4)
end

local function Currency_OnDragStop(self)
	self:SetAlpha(1)

	local draggedID = module.draggingCurrencyID
	local targetID = module.dragHoverCurrencyID
	module.draggingCurrencyID = nil
	module.dragHoverCurrencyID = nil

	if draggedID and targetID then
		MoveCurrency(draggedID, targetID)
		module:UpdateFooter()
	end
end

local function AcquireButton(footer, index)
	local btn = footer.currencyButtons[index]
	if btn then
		return btn
	end

	btn = CreateFrame("Button", nil, footer)
	btn:Size(BUTTON_SIZE)
	pcall(btn.SetTemplate, btn)

	btn.icon = btn:CreateTexture(nil, "ARTWORK")
	btn.icon:SetInside()
	btn.icon:SetTexCoords()

	btn.text = btn:CreateFontString(nil, "OVERLAY")
	btn.text:FontTemplate()
	btn.text:Point("LEFT", btn, "RIGHT", ICON_TEXT_GAP, 0)

	btn:RegisterForClicks("LeftButtonUp")
	btn:RegisterForDrag("LeftButton")
	btn:SetScript("OnEnter", Currency_OnEnter)
	btn:SetScript("OnLeave", Currency_OnLeave)
	btn:SetScript("OnClick", Currency_OnClick)
	btn:SetScript("OnDragStart", Currency_OnDragStart)
	btn:SetScript("OnDragStop", Currency_OnDragStop)

	footer.currencyButtons[index] = btn
	return btn
end

function module:CreateCurrencyButtons(f)
	f.footer.currencyButtons = {}

	-- Relayout when the window gets wider or narrower, the footer's own height
	-- changes from the relayout itself are skipped.
	f.footer:HookScript("OnSizeChanged", function(footer, width)
		if footer.currencyLayoutWidth and math.abs(width - footer.currencyLayoutWidth) >= 1 then
			module:UpdateCurrencies(f)
		end
	end)

	-- Fires when a "Show on Backpack" checkbox in the Currency tab changes
	-- Blizzard's watch count.
	_G.EventRegistry:RegisterCallback("TokenFrame.OnTokenWatchChanged", function()
		module:SyncWatchedCurrencies()
		if f:IsShown() then
			module:UpdateFooter()
		end
	end, module)
end

-- Currencies wrap into as many right-aligned rows as they need, next to the
-- gold text on the bottom row. The footer grows by the extra rows and the
-- sidebar and item area move up with it.
function module:UpdateCurrencies(f)
	local footer = f.footer
	local footerWidth = footer:GetWidth()
	if not footerWidth or footerWidth <= 1 then
		footerWidth = f:GetWidth() - 16
	end
	footer.currencyLayoutWidth = footerWidth

	local available = max(BUTTON_SIZE * 3, footerWidth - footer.goldText:GetStringWidth() - GOLD_GAP - RIGHT_PADDING)

	local state = module:GetCurrencyState()
	local rows, row, rowWidth = {}, {}, 0
	local shown = 0

	for _, currencyID in ipairs(state and state.tracked or {}) do
		local info = C_CurrencyInfo.GetCurrencyInfo(currencyID)
		if info and info.iconFileID and info.discovered ~= false then
			shown = shown + 1
			local btn = AcquireButton(footer, shown)
			btn.currencyID = currencyID
			btn.icon:SetTexture(info.iconFileID)
			btn.text:SetText(info.quantity or 0)

			local width = BUTTON_SIZE + ICON_TEXT_GAP + btn.text:GetStringWidth()
			local needed = (#row > 0 and ITEM_GAP or 0) + width
			if #row > 0 and rowWidth + needed > available then
				tinsert(rows, { buttons = row, width = rowWidth })
				row, rowWidth = {}, 0
				needed = width
			end

			tinsert(row, { btn = btn, width = width })
			rowWidth = rowWidth + needed
		end
	end
	if #row > 0 then
		tinsert(rows, { buttons = row, width = rowWidth })
	end

	for i = shown + 1, #footer.currencyButtons do
		local btn = footer.currencyButtons[i]
		btn.currencyID = nil
		btn:Hide()
	end

	-- Rows read top to bottom, the last one shares its line with the gold.
	local numRows = max(1, #rows)
	for rowIndex, rowData in ipairs(rows) do
		local y = (numRows - rowIndex) * (FOOTER_HEIGHT + ROW_GAP)
		local x = footerWidth - RIGHT_PADDING - rowData.width
		for _, entry in ipairs(rowData.buttons) do
			entry.btn:ClearAllPoints()
			entry.btn:Point("BOTTOMLEFT", footer, "BOTTOMLEFT", x, y)
			entry.btn:Show()
			x = x + entry.width + ITEM_GAP
		end
	end

	local extra = (numRows - 1) * (FOOTER_HEIGHT + ROW_GAP)
	footer:Height(FOOTER_HEIGHT + extra)

	if footer.currencyExtra ~= extra then
		-- Moving the item area is blocked in combat (it holds the secure slot
		-- buttons), the combat-end refresh lands here again.
		if InCombatLockdown() then
			module:DeferRefreshForCombat()
			return
		end

		footer.currencyExtra = extra
		f.sidebar:Point("BOTTOMLEFT", f, "BOTTOMLEFT", 8, SIDEBAR_BOTTOM + extra)
		f.mainScroll:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", -28, MAINSCROLL_BOTTOM + extra)
	end
end
