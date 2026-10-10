local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories
local S = E:GetModule("Skins")

local _G = _G
local ipairs, pairs = ipairs, pairs
local tinsert, tremove, wipe = tinsert, tremove, wipe
local tsort = table.sort
local max, min, abs = math.max, math.min, math.abs

local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local IsMouseButtonDown = IsMouseButtonDown
local C_Item_GetItemInfo = C_Item.GetItemInfo
local C_Item_GetItemInfoInstant = C_Item.GetItemInfoInstant
local C_Item_GetDetailedItemLevelInfo = C_Item.GetDetailedItemLevelInfo
local C_Item_GetItemQualityColor = C_Item.GetItemQualityColor
local GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString

local ITEMCLASS_ARMOR = Enum.ItemClass.Armor
local ITEMCLASS_WEAPON = Enum.ItemClass.Weapon

-------------------------------------------------------------------------------
--  List display: one row per item, sortable columns
-------------------------------------------------------------------------------
-- The rows are the same secure item buttons as the Grid slots (a separate
-- pool, see CreateSlotPoolFor's isList), so every click, drag and tooltip
-- works the same; only the layout differs. A column header bar sits above
-- the scrolling content: click a column to sort by it, drag it to move it,
-- right-click it to pick the columns.
local COL_GAP = 6
local HEADER_BAR_HEIGHT = 20
local SECTION_GAP = 6

local IB = Enum.ItemBind
local BIND_UNTIL_EQUIPPED = IB.ToBnetAccountUntilEquipped or 9
local BIND_SHORT = {
	[IB.OnAcquire or 1] = L["BoP"],
	[IB.OnEquip or 2] = L["BoE"],
	[IB.OnUse or 3] = L["BoU"],
	[IB.Quest or 4] = L["Quest"],
	[IB.ToWoWAccount or 7] = L["BoA"],
	[IB.ToBnetAccount or 8] = L["WB"],
	[BIND_UNTIL_EQUIPPED] = L["WuE"],
}
-- Bound copies of these read as Soulbound, account binds keep their label
local BIND_BECOMES_SOULBOUND = {
	[IB.OnEquip or 2] = true,
	[IB.OnUse or 3] = true,
	[BIND_UNTIL_EQUIPPED] = true,
}

-- width nil = takes whatever the row has left (Name). field = the stamped
-- per-item value it sorts by; desc = numbers sort high to low on first click.
local COLUMNS = {
	icon = { label = "", menuLabel = L["Icon"] },
	name = { label = L["Name"], field = "lvName" },
	ilvl = { label = L["iLvl"], menuLabel = L["Item Level"], width = 36, field = "lvItemLevel", desc = true },
	reqlvl = { label = L["Req"], menuLabel = L["Required Level"], width = 32, field = "lvReqLevel", desc = true },
	type = { label = L["Type"], width = 96, field = "lvType" },
	bind = { label = L["Bind"], menuLabel = L["Bind Type"], width = 40, field = "lvBind" },
	count = { label = "#", menuLabel = L["Count"], width = 40, field = "lvCount", desc = true },
	sell = { label = L["Sell Price"], width = 100, field = "lvSell", desc = true },
}
local RIGHT_ALIGNED = { ilvl = true, reqlvl = true, count = true, sell = true }
local COLUMN_ORDER = { "icon", "name", "ilvl", "reqlvl", "type", "bind", "count", "sell" }
local DEFAULT_COLUMNS = { "icon", "name", "ilvl", "count", "sell" }

local function ListDB()
	return module.db.list
end

local function IndexOf(list, value)
	for i, v in ipairs(list) do
		if v == value then
			return i
		end
	end
end

-- Saved columns, unknown IDs (from an older version) dropped
local columnsScratch = {}
local function GetColumns()
	local saved = ListDB().columns
	if not saved then
		return DEFAULT_COLUMNS
	end

	wipe(columnsScratch)
	for _, id in ipairs(saved) do
		if COLUMNS[id] and not IndexOf(columnsScratch, id) then
			tinsert(columnsScratch, id)
		end
	end

	return #columnsScratch > 0 and columnsScratch or DEFAULT_COLUMNS
end

local function SetColumns(list)
	local copy = {}
	for i, id in ipairs(list) do
		copy[i] = id
	end
	ListDB().columns = copy
end

local function RowHeight()
	return ListDB().rowHeight
end

local function IconSize()
	return RowHeight() - 4
end

local function RefreshAll()
	if module.frame and module.frame:IsShown() then
		module:RefreshCategoryFrame()
	end
	if module.bankFrame and module.bankFrame:IsShown() and module.RefreshBankCategoryFrame then
		module:RefreshBankCategoryFrame()
	end
end

-------------------------------------------------------------------------------
--  Per-item values (stamped on the entries, which are recycled every refresh)
-------------------------------------------------------------------------------
local function StampEntry(entry)
	if entry.lvStamped then
		return
	end
	entry.lvStamped = true

	local link = entry.itemLink
	local name, _, _, _, reqLevel, _, _, _, _, _, sellPrice, classID, _, bindType = C_Item_GetItemInfo(link)
	local _, _, subType = C_Item_GetItemInfoInstant(link)

	entry.lvName = name or (link and link:match("%[(.-)%]")) or ""
	entry.lvQuality = entry.quality or 1
	entry.lvCount = entry.count or 1
	entry.lvReqLevel = (reqLevel and reqLevel > 1) and reqLevel or 0
	entry.lvType = subType or ""
	entry.lvSell = (sellPrice or 0) * entry.lvCount

	local itemLevel = 0
	if classID == ITEMCLASS_ARMOR or classID == ITEMCLASS_WEAPON then
		itemLevel = C_Item_GetDetailedItemLevelInfo(link) or 0
	end
	entry.lvItemLevel = itemLevel

	if entry.isUntilEquipped then
		bindType = BIND_UNTIL_EQUIPPED
	end
	if entry.isBound and BIND_BECOMES_SOULBOUND[bindType] then
		entry.lvBind = L["SB"]
	else
		entry.lvBind = bindType and BIND_SHORT[bindType] or ""
	end
end

-- One comparator, its key set before each sort (no closure per refresh)
local sortField, sortAscending = "lvName", true
local function CompareEntries(a, b)
	local va, vb = a[sortField], b[sortField]
	if va ~= vb then
		if sortAscending then
			return va < vb
		end
		return va > vb
	end
	if a.lvName ~= b.lvName then
		return a.lvName < b.lvName
	end
	if a.bagID ~= b.bagID then
		return a.bagID < b.bagID
	end
	return a.slotID < b.slotID
end

-- The column the list is sorted by, or nil for the normal section order
local function GetSortColumn()
	local key = ListDB().sortKey
	return key and COLUMNS[key] and COLUMNS[key].field and key or nil
end

-------------------------------------------------------------------------------
--  Row buttons
-------------------------------------------------------------------------------
local ICON_REGIONS = { "icon", "IconOverlay", "IconOverlay2", "IconQuestTexture", "newItemGlow", "Cooldown" }
local ICON_DECORATIONS = {
	"icon",
	"IconOverlay",
	"IconOverlay2",
	"IconQuestTexture",
	"newItemGlow",
	"Cooldown",
	"JunkIcon",
	"warboundIcon",
	"pinIcon",
	"UpgradeIcon",
	"equipIcon",
	"ProfessionQualityOverlay",
}

-- Called once per row button from CreateSlotPoolFor. The row has no backdrop
-- of its own: the icon and everything drawn on it move into a small bordered
-- frame at the left edge, one level below the button so the icon stays on top.
function module.SkinListRow(btn)
	btn.isListRow = true

	local iconFrame = CreateFrame("Frame", nil, btn)
	iconFrame:SetFrameLevel(max(0, btn:GetFrameLevel() - 1))
	iconFrame:Size(16)
	iconFrame:Point("LEFT")
	local ok = pcall(iconFrame.SetTemplate, iconFrame, nil, true)
	if not ok then
		pcall(iconFrame.SetTemplate, iconFrame)
	end
	btn.iconFrame = iconFrame

	for _, key in ipairs(ICON_REGIONS) do
		local region = btn[key]
		if region then
			region:ClearAllPoints()
			region:SetInside(iconFrame)
		end
	end

	btn.warboundIcon:ClearAllPoints()
	btn.warboundIcon:Point("TOPRIGHT", iconFrame, "TOPRIGHT", -1, -1)
	btn.pinIcon:ClearAllPoints()
	btn.pinIcon:Point("BOTTOMLEFT", iconFrame, "BOTTOMLEFT", 1, 1)
	btn.UpgradeIcon:ClearAllPoints()
	btn.UpgradeIcon:Point("CENTER", iconFrame, "CENTER")

	btn.stripe = btn:CreateTexture(nil, "BACKGROUND")
	btn.stripe:SetAllPoints()
	btn.stripe:SetColorTexture(1, 1, 1, 0.04)
	btn.stripe:Hide()

	btn.listCells = {}
end

local function GetCell(btn, id)
	local fs = btn.listCells[id]
	if not fs then
		fs = btn:CreateFontString(nil, "OVERLAY")
		fs:SetWordWrap(false)
		fs:SetJustifyH(RIGHT_ALIGNED[id] and "RIGHT" or "LEFT")
		btn.listCells[id] = fs
	end
	return fs
end

-- x and width of every shown column for a row width
local columnX, columnWidth = {}, {}
local function LayoutColumns(rowWidth)
	local columns = GetColumns()
	local fixed = 0
	for _, id in ipairs(columns) do
		if id == "icon" then
			fixed = fixed + IconSize()
		else
			fixed = fixed + (COLUMNS[id].width or 0)
		end
	end

	local flexWidth = max(60, rowWidth - fixed - COL_GAP * (#columns + 1))
	local x = COL_GAP
	for _, id in ipairs(columns) do
		local width = (id == "icon" and IconSize()) or COLUMNS[id].width or flexWidth
		columnX[id], columnWidth[id] = x, width
		x = x + width + COL_GAP
	end

	return columns
end

local function UpdateRow(btn, entry, columns, stripe)
	local db = module.db
	local fontName, fontStyle = db.headerFont.name, db.headerFont.style
	local fontSize = ListDB().fontSize

	btn.stripe:SetShown(stripe and ListDB().stripes)

	-- The grid texts are columns here
	if btn.Count then
		btn.Count:Hide()
	end
	btn.itemLevel:SetText("")
	btn.bindType:SetText("")
	if btn.hover then
		btn.hover:SetAlpha(0.4)
	end

	for _, fs in pairs(btn.listCells) do
		fs:Hide()
	end

	-- Everything drawn on the icon goes with it when the column is off
	local iconFrame = btn.iconFrame
	local hasIcon = IndexOf(columns, "icon") ~= nil
	iconFrame:SetShown(hasIcon)
	if hasIcon then
		iconFrame:ClearAllPoints()
		iconFrame:Point("LEFT", btn, "LEFT", columnX.icon, 0)
		iconFrame:Size(IconSize())

		-- Placed against the row by UpdateSlotVisual (the Grid slot layout)
		local equipIcon = btn.equipIcon
		if equipIcon:IsShown() then
			equipIcon:ClearAllPoints()
			equipIcon:Point("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT", 1, -1)
			equipIcon:Size(IconSize() * 0.5)
		end
	else
		for _, key in ipairs(ICON_DECORATIONS) do
			local region = btn[key]
			if region then
				region:Hide()
			end
		end
	end

	for _, id in ipairs(columns) do
		if id ~= "icon" then
			local fs = GetCell(btn, id)
			fs:FontTemplate(fontName, fontSize, fontStyle)
			fs:ClearAllPoints()
			fs:Point("LEFT", btn, "LEFT", columnX[id], 0)
			fs:Width(columnWidth[id])

			local text = ""
			if id == "name" then
				text = entry.lvName
				local r, g, b = C_Item_GetItemQualityColor(entry.lvQuality)
				fs:SetTextColor(r or 1, g or 1, b or 1)
			else
				fs:SetTextColor(0.85, 0.85, 0.85)
				if id == "ilvl" then
					text = entry.lvItemLevel > 0 and entry.lvItemLevel or ""
				elseif id == "reqlvl" then
					text = entry.lvReqLevel > 0 and entry.lvReqLevel or ""
				elseif id == "type" then
					text = entry.lvType
				elseif id == "bind" then
					text = entry.lvBind
				elseif id == "count" then
					text = entry.lvCount > 1 and entry.lvCount or ""
				elseif id == "sell" then
					text = entry.lvSell > 0 and GetCoinTextureString(entry.lvSell) or ""
				end
			end

			fs:SetText(text)
			fs:Show()
		end
	end
end

-------------------------------------------------------------------------------
--  Column header bar
-------------------------------------------------------------------------------
local function MoveColumn(id, toIndex)
	local columns = {}
	for _, column in ipairs(GetColumns()) do
		if column ~= id then
			tinsert(columns, column)
		end
	end
	toIndex = max(1, min(toIndex, #columns + 1))
	tinsert(columns, toIndex, id)
	SetColumns(columns)
	RefreshAll()
end

local function ToggleColumn(id)
	local columns = {}
	for i, column in ipairs(GetColumns()) do
		columns[i] = column
	end

	local index = IndexOf(columns, id)
	if index then
		if #columns == 1 then
			return
		end
		tremove(columns, index)
	else
		-- Back to its default spot relative to the shown ones
		local rank = IndexOf(COLUMN_ORDER, id)
		local insertAt = #columns + 1
		for i, column in ipairs(columns) do
			if IndexOf(COLUMN_ORDER, column) > rank then
				insertAt = i
				break
			end
		end
		tinsert(columns, insertAt, id)
	end

	SetColumns(columns)
	RefreshAll()
end

local function OpenColumnMenu(owner, id)
	if not _G.MenuUtil or not _G.MenuUtil.CreateContextMenu then
		return
	end

	_G.MenuUtil.CreateContextMenu(owner, function(_, root)
		root:CreateTitle(L["Columns"])
		for _, columnID in ipairs(COLUMN_ORDER) do
			local def = COLUMNS[columnID]
			root:CreateCheckbox(def.menuLabel or def.label, function()
				return IndexOf(GetColumns(), columnID) ~= nil
			end, function()
				ToggleColumn(columnID)
			end)
		end

		root:CreateDivider()
		local index = IndexOf(GetColumns(), id)
		if index and index > 1 then
			root:CreateButton(L["Move Left"], function()
				MoveColumn(id, index - 1)
			end)
		end
		if index and index < #GetColumns() then
			root:CreateButton(L["Move Right"], function()
				MoveColumn(id, index + 1)
			end)
		end
		if GetSortColumn() then
			root:CreateButton(L["Category Order"], function()
				ListDB().sortKey = nil
				RefreshAll()
			end)
		end
		root:CreateButton(L["Reset Columns"], function()
			ListDB().columns = nil
			ListDB().sortKey = nil
			RefreshAll()
		end)
	end)
end

-- Live drag: past a few pixels the column moves as soon as the cursor
-- crosses the middle of a neighbour. OnUpdate only while the button is held.
local function HeaderButton_OnUpdate(self)
	if not IsMouseButtonDown("LeftButton") then
		self:SetScript("OnUpdate", nil)
		return
	end

	local cursorX = GetCursorPosition()
	if not self.dragged then
		if abs(cursorX - self.downX) <= 6 then
			return
		end
		self.dragged = true
	end

	cursorX = cursorX / self:GetEffectiveScale()
	local columns = GetColumns()
	local buttons = self:GetParent().buttons
	local target = 1
	for _, id in ipairs(columns) do
		local other = buttons[id]
		if id ~= self.columnID and other and other:IsShown() then
			local left, right = other:GetLeft(), other:GetRight()
			if left and cursorX > (left + right) / 2 then
				target = target + 1
			end
		end
	end

	if target ~= IndexOf(columns, self.columnID) then
		MoveColumn(self.columnID, target)
	end
end

local function HeaderButton_OnMouseDown(self, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end

	self.downX = GetCursorPosition()
	self.dragged = nil
	self:SetScript("OnUpdate", HeaderButton_OnUpdate)
end

local function HeaderButton_OnMouseUp(self, mouseButton)
	if mouseButton == "RightButton" then
		OpenColumnMenu(self, self.columnID)
		return
	end
	if mouseButton ~= "LeftButton" or not self.downX then
		return
	end

	self:SetScript("OnUpdate", nil)
	self.downX = nil
	if self.dragged then
		self.dragged = nil
		return
	end

	local def = COLUMNS[self.columnID]
	if not def.field then
		return
	end

	local db = ListDB()
	if db.sortKey == self.columnID then
		db.sortAscending = not db.sortAscending
	else
		db.sortKey = self.columnID
		db.sortAscending = not def.desc
	end
	RefreshAll()
end

local function HeaderButton_OnEnter(self)
	local cc = E.myClassColor
	self.label:SetTextColor(cc.r, cc.g, cc.b)
	if self.glyph then
		self.glyph:SetVertexColor(cc.r, cc.g, cc.b)
	end

	if not GameTooltip:IsForbidden() then
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:AddLine(COLUMNS[self.columnID].menuLabel or COLUMNS[self.columnID].label, 1, 1, 1)
		if COLUMNS[self.columnID].field then
			GameTooltip:AddLine(L["Click to sort."], 0.6, 0.6, 0.6)
		end
		GameTooltip:AddLine(L["Drag to move. Right-click to choose the columns."], 0.6, 0.6, 0.6)
		GameTooltip:Show()
	end
end

local function HeaderButton_OnLeave(self)
	self.label:SetTextColor(0.6, 0.6, 0.6)
	if self.glyph then
		self.glyph:SetVertexColor(0.6, 0.6, 0.6)
	end
	GameTooltip_Hide()
end

local function GetHeaderButton(bar, id)
	local btn = bar.buttons[id]
	if btn then
		return btn
	end

	btn = CreateFrame("Button", nil, bar)
	btn:SetHeight(HEADER_BAR_HEIGHT)
	btn.columnID = id

	btn.label = btn:CreateFontString(nil, "OVERLAY")
	btn.label:FontTemplate(module.db.headerFont.name, max(8, ListDB().fontSize - 1), module.db.headerFont.style)
	btn.label:SetAllPoints()
	btn.label:SetJustifyH(RIGHT_ALIGNED[id] and "RIGHT" or "LEFT")
	btn.label:SetTextColor(0.6, 0.6, 0.6)
	btn.label:SetText(COLUMNS[id].label)

	btn.arrow = btn:CreateTexture(nil, "OVERLAY")
	btn.arrow:SetSize(10, 10)
	btn.arrow:SetTexture(E.Media.Textures.ArrowUp)
	local cc = E.myClassColor
	btn.arrow:SetVertexColor(cc.r, cc.g, cc.b)
	btn.arrow:Hide()

	if id == "icon" then
		btn.glyph = btn:CreateTexture(nil, "OVERLAY")
		btn.glyph:SetSize(12, 12)
		btn.glyph:Point("CENTER")
		btn.glyph:SetTexture(E.Media.Textures.Backpack)
		btn.glyph:SetVertexColor(0.6, 0.6, 0.6)
	end

	btn:RegisterForClicks("AnyUp")
	btn:SetScript("OnMouseDown", HeaderButton_OnMouseDown)
	btn:SetScript("OnMouseUp", HeaderButton_OnMouseUp)
	btn:SetScript("OnEnter", HeaderButton_OnEnter)
	btn:SetScript("OnLeave", HeaderButton_OnLeave)

	bar.buttons[id] = btn
	return btn
end

-- One bar per window, above its scroll frame (which moves down to make room)
local function UpdateHeaderBar(ctx, columns, rowWidth)
	local frame = ctx.frame
	local bar = frame.listHeaderBar
	if not bar then
		bar = CreateFrame("Frame", nil, frame)
		bar:SetHeight(HEADER_BAR_HEIGHT)
		bar.buttons = {}

		local cc = E.myClassColor
		bar.line = bar:CreateTexture(nil, "ARTWORK")
		bar.line:SetColorTexture(cc.r, cc.g, cc.b, 0.35)
		bar.line:Height(1)
		bar.line:Point("BOTTOMLEFT")
		bar.line:Point("BOTTOMRIGHT")

		frame.listHeaderBar = bar
	end

	if not frame.listHeaderActive then
		frame.listHeaderActive = true
		frame.mainScroll:Point("TOPLEFT", frame.sidebar, "TOPRIGHT", 8, -(HEADER_BAR_HEIGHT + 4))
	end

	bar:ClearAllPoints()
	bar:Point("TOPLEFT", frame.sidebar, "TOPRIGHT", 8, 0)
	bar:Width(rowWidth)
	bar:Show()

	for id, btn in pairs(bar.buttons) do
		if not IndexOf(columns, id) then
			btn:Hide()
		end
	end

	local db = module.db
	local sortKey = GetSortColumn()
	for _, id in ipairs(columns) do
		local btn = GetHeaderButton(bar, id)
		btn.label:FontTemplate(db.headerFont.name, max(8, ListDB().fontSize - 1), db.headerFont.style)
		btn:ClearAllPoints()
		btn:Point("TOPLEFT", bar, "TOPLEFT", columnX[id], 0)
		btn:Width(max(columnWidth[id], 12))

		if id == sortKey then
			btn.arrow:ClearAllPoints()
			local textWidth = btn.label:GetStringWidth()
			if RIGHT_ALIGNED[id] then
				btn.arrow:Point("RIGHT", btn, "RIGHT", -(textWidth + 3), 0)
			else
				btn.arrow:Point("LEFT", btn, "LEFT", textWidth + 3, 0)
			end
			btn.arrow:SetRotation(ListDB().sortAscending and S.ArrowRotation.up or S.ArrowRotation.down)
			btn.arrow:Show()
		else
			btn.arrow:Hide()
		end

		btn:Show()
	end
end

function module.HideListContent(ctx)
	local frame = ctx.frame
	if frame and frame.listHeaderActive then
		frame.listHeaderActive = nil
		frame.listHeaderBar:Hide()
		frame.mainScroll:Point("TOPLEFT", frame.sidebar, "TOPRIGHT", 8, 0)
	end
end

-------------------------------------------------------------------------------
--  Render
-------------------------------------------------------------------------------
local sortedScratch = {}

-- The items of one section in display order: the section's own order, or
-- sorted by the chosen column within each sub-header group.
local function GetDisplayItems(section, sortKey)
	local items = section.items
	if not sortKey or section.key == module.RecentCategory.key then
		return items
	end

	wipe(sortedScratch)
	for i, entry in ipairs(items) do
		sortedScratch[i] = entry
	end

	local subHeaders = section.subHeaders
	if not subHeaders then
		tsort(sortedScratch, CompareEntries)
		return sortedScratch
	end

	-- Sort each run between two sub-headers on its own
	local runStart = 1
	for i = 1, #subHeaders + 1 do
		local runEnd = (subHeaders[i] and subHeaders[i].index or (#items + 1)) - 1
		if runEnd > runStart then
			local run = {}
			for j = runStart, runEnd do
				tinsert(run, sortedScratch[j])
			end
			tsort(run, CompareEntries)
			for j, entry in ipairs(run) do
				sortedScratch[runStart + j - 1] = entry
			end
		end
		runStart = runEnd + 1
	end

	return sortedScratch
end

function module.RenderListContent(ctx, sections, contentWidth)
	local pools = ctx.pools
	local rowWidth = contentWidth
	local rowHeight = RowHeight()
	local iconSize = IconSize()
	local searching = module.searchText and module.searchText ~= ""

	local columns = LayoutColumns(rowWidth)
	UpdateHeaderBar(ctx, columns, rowWidth)

	local sortKey = GetSortColumn()
	if sortKey then
		sortField = COLUMNS[sortKey].field
		sortAscending = ListDB().sortAscending and true or false
	end

	local rowIndex, headerIndex, subHeaderIndex = 0, 0, 0
	local y = 0

	for _, section in ipairs(sections) do
		ctx.offsets[section.key] = y

		for _, entry in ipairs(section.items) do
			StampEntry(entry)
		end

		headerIndex = headerIndex + 1
		local header = pools.AcquireHeader(headerIndex)
		local headerHeight, collapsed = module.SetupSectionHeader(ctx, header, section, y, searching)
		if ListDB().sectionValue then
			local value = 0
			for _, entry in ipairs(section.items) do
				value = value + entry.lvSell
			end
			if value > 0 then
				header.text:SetText(header.text:GetText() .. "  " .. GetCoinTextureString(value))
			end
		end
		y = y + headerHeight

		if not collapsed then
			local items = GetDisplayItems(section, sortKey)
			local subHeaders = section.subHeaders
			local nextSubHeader = subHeaders and subHeaders[1]
			local nextSubHeaderPos = 2
			local stripe = false

			for itemIndex, entry in ipairs(items) do
				if nextSubHeader and nextSubHeader.index == itemIndex then
					subHeaderIndex = subHeaderIndex + 1
					local subHeader = pools.AcquireSubHeader(subHeaderIndex)
					y = y + module.SetupSubHeader(ctx, subHeader, nextSubHeader, y) + 2
					stripe = false

					nextSubHeader = subHeaders[nextSubHeaderPos]
					nextSubHeaderPos = nextSubHeaderPos + 1
				end

				rowIndex = rowIndex + 1
				local btn = pools.AcquireListRow(rowIndex)
				btn.listIconSize = iconSize
				module.UpdateSlotVisual(btn, entry)
				-- A sorted list has no manual order to drag items into
				btn.orderKey = not sortKey and section.orderKey or nil
				UpdateRow(btn, entry, columns, stripe)

				btn:ClearAllPoints()
				btn:Size(rowWidth, rowHeight)
				btn:Point("TOPLEFT", ctx.contentChild, "TOPLEFT", 0, -y)

				y = y + rowHeight
				stripe = not stripe
			end
		end

		y = y + SECTION_GAP
	end

	pools.ReleaseListRowsFrom(rowIndex + 1)
	pools.ReleaseHeadersFrom(headerIndex + 1)
	pools.ReleaseSubHeadersFrom(subHeaderIndex + 1)

	return y
end

-------------------------------------------------------------------------------
--  Display switch (title bar button of both windows)
-------------------------------------------------------------------------------
local DISPLAY_MODES = {
	{ key = "GRID", label = L["Grid"] },
	{ key = "LIST", label = L["List"] },
	{ key = "COMPACT", label = L["Compact"] },
}

function module:SetDisplayMode(isBank, mode)
	local db = module.db
	local field = isBank and "bankDisplayMode" or "displayMode"
	if db[field] == mode then
		return
	end

	db[field] = mode
	if isBank then
		if module.bankFrame and module.bankFrame:IsShown() then
			module.bankFrame.mainScroll:SetVerticalScroll(0)
			module:RefreshBankCategoryFrame()
		end
	elseif module.frame and module.frame:IsShown() then
		module.frame.mainScroll:SetVerticalScroll(0)
		module:RefreshCategoryFrame()
	end
end

function module:OpenDisplayMenu(owner, isBank)
	if not _G.MenuUtil or not _G.MenuUtil.CreateContextMenu then
		return
	end

	GameTooltip_Hide()
	_G.MenuUtil.CreateContextMenu(owner, function(_, root)
		root:CreateTitle(L["Display"])
		for _, def in ipairs(DISPLAY_MODES) do
			root:CreateRadio(def.label, function()
				return module.db[isBank and "bankDisplayMode" or "displayMode"] == def.key
			end, function()
				module:SetDisplayMode(isBank, def.key)
			end)
		end
	end)
end
