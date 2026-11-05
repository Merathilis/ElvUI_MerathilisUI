local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Armory") ---@class Armory
local S = E:GetModule("Skins")

-- Stat picker of the character stats pane:
-- * the cog button toggles an edit mode that shows every stat the character can have, hidden ones dimmed
-- * a click on a row shows or hides it, dragging a row changes the order inside its category
-- * a right click on a row resets its mode, a right click on the cog in edit mode resets all stats
-- * a list longer than the pane scrolls with the mouse wheel, or when a dragged row nears an edge
-- Visibility writes the same per-stat modes as the options, the order lives in stats.order per category.

local _G = _G
local format = string.format
local ipairs, pairs = ipairs, pairs
local abs, max, min = math.abs, math.max, math.min
local tinsert, twipe = table.insert, table.wipe

local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local InCombatLockdown = InCombatLockdown

local COG_TEXTURE = "Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\Icons\\Chat\\settings"
local COG_SIZE = 14
local HIDDEN_ALPHA = 0.3
local DRAG_THRESHOLD = 4
local SCROLL_STEP = 24 -- pixels per mouse wheel notch
local SCROLL_PADDING = 6 -- free space below the last row when scrolled to the end
local EDGE_SCROLL_ZONE = 18 -- dragging a row this close to the top or bottom scrolls the list
local EDGE_SCROLL_SPEED = 240 -- pixels per second
local SCROLLBAR_INSET = 4 -- space between the scroll bar and the right edge of the pane
local SCROLLBAR_GAP = 4 -- space between the rows and the scroll bar

local MODE_HIDE, MODE_SMART, MODE_ALWAYS = 0, 1, 3

local picker -- cog button and the edit overlay above the stat rows
local rows = {} -- rows laid out in edit mode, top to bottom
local orderedStats = {} -- [catIndex] = stats of the category in the saved order
local drag -- { row, startY, moved, target, below }
local scrollOffset = 0 -- how far the list is scrolled up in edit mode
local Scroll

---Stats of a category in the saved order, stats missing from it keep their default spot at the end
---@param catIndex number
---@return table
function module:GetOrderedStats(catIndex)
	local cached = orderedStats[catIndex]
	if cached then
		return cached
	end

	local category = self.StatCategories[catIndex]
	local saved = self.db.stats.order[category.categoryFrame]
	if not saved then
		orderedStats[catIndex] = category.stats
		return category.stats
	end

	local byId, used, list = {}, {}, {}
	for _, stat in ipairs(category.stats) do
		byId[stat.stat] = stat
	end
	for _, id in ipairs(saved) do
		local stat = byId[id]
		if stat and not used[id] then
			used[id] = true
			list[#list + 1] = stat
		end
	end
	for _, stat in ipairs(category.stats) do
		if not used[stat.stat] then
			list[#list + 1] = stat
		end
	end

	orderedStats[catIndex] = list
	return list
end

function module:ClearOrderedStats()
	twipe(orderedStats)
end

function module:ClearStatPickerRows()
	twipe(rows)
end

---@param frame Frame stat row
---@param stat table entry of module.StatCategories
---@param catIndex number
---@param visible boolean shown outside the edit mode
---@param smartVisible boolean the smart mode would show it right now
function module:AddStatPickerRow(frame, stat, catIndex, visible, smartVisible)
	tinsert(rows, { frame = frame, stat = stat, catIndex = catIndex, visible = visible, smartVisible = smartVisible })
end

---Dims the whole row, background bar included (its gradient ignores its own alpha). The rows
---come from Blizzard's frame pool, so a dimmed one is set back once it is laid out normally again,
---only then, as the fade-in animation owns the alpha of the rows while the frame opens.
---@param frame Frame
---@param dimmed boolean
function module:SetStatRowDimmed(frame, dimmed)
	if dimmed then
		frame:SetAlpha(HIDDEN_ALPHA)
		frame.MERDimmed = true
	elseif frame.MERDimmed then
		frame:SetAlpha(1)
		frame.MERDimmed = nil
	end
end

local function GetCursorY(frame)
	local _, y = GetCursorPosition()
	return y / frame:GetEffectiveScale()
end

local function GetRowAt(y)
	for _, row in ipairs(rows) do
		local top, bottom = row.frame:GetTop(), row.frame:GetBottom()
		if top and bottom and y <= top and y >= bottom then
			return row
		end
	end
end

---Drop spot inside the dragged row's category: before the first row whose center lies below
---the cursor, after the last row of the category otherwise
local function GetDropTarget(y)
	local last
	for _, row in ipairs(rows) do
		if row.catIndex == drag.row.catIndex then
			local top, bottom = row.frame:GetTop(), row.frame:GetBottom()
			if top and bottom then
				if y > (top + bottom) / 2 then
					return row, false
				end
				last = row
			end
		end
	end
	return last, true
end

local function Refresh()
	if module.frame then
		module:UpdateCharacterStats()
	end
	E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
end

local function ToggleStat(row)
	local entry = module.db.stats.mode[row.stat.stat]
	if row.visible then
		entry.mode = MODE_HIDE
	else
		-- smart keeps following spec and role where it already fits, everything else is forced on
		entry.mode = row.smartVisible and MODE_SMART or MODE_ALWAYS
	end
end

local function ResetStat(row)
	local default = P.armory.stats.mode[row.stat.stat]
	if default then
		module.db.stats.mode[row.stat.stat].mode = default.mode
	end
end

local function MoveStat(source, target, below)
	if target == source then
		return
	end

	local list = {}
	for _, stat in ipairs(module:GetOrderedStats(source.catIndex)) do
		if stat ~= source.stat then
			list[#list + 1] = stat.stat
		end
	end

	local index = #list + 1
	for i, id in ipairs(list) do
		if id == target.stat.stat then
			index = below and (i + 1) or i
			break
		end
	end
	tinsert(list, index, source.stat.stat)

	local category = module.StatCategories[source.catIndex]
	module.db.stats.order[category.categoryFrame] = list
	orderedStats[source.catIndex] = nil
end

function module:ResetStatPicker()
	twipe(self.db.stats.order)
	twipe(orderedStats)
	for id, default in pairs(P.armory.stats.mode) do
		self.db.stats.mode[id].mode = default.mode
	end
	Refresh()
end

local function ClickHint(button, text)
	local mouse = button == "RIGHT" and L["Right Click:"] or L["Left Click:"]
	_G.GameTooltip:AddDoubleLine(
		format("%s |cffffffff%s|r", F.Icon(MER.Media.Mouse[button]), mouse),
		text,
		1,
		1,
		1,
		1,
		1,
		1
	)
end

local function ShowRowTooltip(overlay, row)
	local tooltip = _G.GameTooltip
	tooltip:SetOwner(overlay, "ANCHOR_NONE")
	tooltip:ClearAllPoints()
	tooltip:SetPoint("RIGHT", row.frame, "LEFT", -8, 0)
	tooltip:AddLine(row.frame.Label and row.frame.Label:GetText() or row.stat.stat, 1, 1, 1)
	if row.visible then
		tooltip:AddLine(_G.SHOW, 0.1, 1, 0.1)
	else
		tooltip:AddLine(_G.HIDE, 1, 0.3, 0.3)
	end
	tooltip:AddLine(" ")
	ClickHint("LEFT", row.visible and _G.HIDE or _G.SHOW)
	ClickHint("RIGHT", L["Reset to Default"])
	tooltip:AddDoubleLine(format("|cffffffff%s|r", L["Drag:"]), L["Change Order"], 1, 1, 1, 1, 1, 1)
	tooltip:Show()
end

local function PlaceHighlight(texture, row)
	texture:ClearAllPoints()
	texture:SetPoint("TOPLEFT", row.frame, "TOPLEFT")
	texture:SetPoint("BOTTOMRIGHT", row.frame, "BOTTOMRIGHT")
	texture:Show()
end

local function Overlay_OnUpdate(overlay, elapsed)
	local y = GetCursorY(overlay)

	if drag then
		if not drag.moved and abs(y - drag.startY) > DRAG_THRESHOLD then
			drag.moved = true
			_G.GameTooltip:Hide()
		end
		if drag.moved then
			local top, bottom = overlay:GetTop(), overlay:GetBottom()
			if top and y > top - EDGE_SCROLL_ZONE then
				Scroll(-EDGE_SCROLL_SPEED * elapsed)
			elseif bottom and y < bottom + EDGE_SCROLL_ZONE then
				Scroll(EDGE_SCROLL_SPEED * elapsed)
			end

			drag.target, drag.below = GetDropTarget(y)
			local line = overlay.DropLine
			line:ClearAllPoints()
			if drag.target then
				local point = drag.below and "BOTTOM" or "TOP"
				line:SetPoint(point .. "LEFT", drag.target.frame, point .. "LEFT", 0, 0)
				line:SetPoint(point .. "RIGHT", drag.target.frame, point .. "RIGHT", 0, 0)
				line:Show()
			else
				line:Hide()
			end
			PlaceHighlight(overlay.Highlight, drag.row)
			return
		end
	end

	local row = overlay:IsMouseOver() and GetRowAt(y)
	if row ~= overlay.hoveredRow then
		overlay.hoveredRow = row
		if row then
			PlaceHighlight(overlay.Highlight, row)
			ShowRowTooltip(overlay, row)
		else
			overlay.Highlight:Hide()
			_G.GameTooltip:Hide()
		end
	end
end

local function Overlay_OnMouseDown(overlay, button)
	if button ~= "LeftButton" or InCombatLockdown() then
		return
	end

	local y = GetCursorY(overlay)
	local row = GetRowAt(y)
	if row then
		drag = { row = row, startY = y }
	end
end

local function Overlay_OnMouseUp(overlay, button)
	local current = drag
	drag = nil
	overlay.DropLine:Hide()
	overlay.hoveredRow = nil

	if InCombatLockdown() then
		return
	end

	if button == "RightButton" then
		local row = GetRowAt(GetCursorY(overlay))
		if row then
			ResetStat(row)
			Refresh()
		end
	elseif current then
		if current.moved then
			if current.target then
				MoveStat(current.row, current.target, current.below)
			end
		else
			ToggleStat(current.row)
		end
		Refresh()
	end
end

local function Overlay_OnHide(overlay)
	drag = nil
	overlay.hoveredRow = nil
	overlay.Highlight:Hide()
	overlay.DropLine:Hide()
	if _G.GameTooltip:IsOwned(overlay) then
		_G.GameTooltip:Hide()
	end
	picker.scrollBar:Hide()
end

local function Overlay_OnShow()
	module:UpdateStatPickerOverlay()
end

local function Overlay_OnMouseWheel(_, delta)
	if not drag then
		Scroll(-delta * SCROLL_STEP)
	end
end

---Moves the list, every other row hangs below the first category
local function ApplyScroll()
	local first = _G.CharacterStatsPane.AttributesCategory
	first:ClearAllPoints()
	first:Point("TOP", _G.CharacterStatsPane, "TOP", -(picker.shiftX or 0), -2 + scrollOffset)
	picker.overlay.hoveredRow = nil
end

local function ScrollBar_OnScroll(_, percentage)
	scrollOffset = percentage * (picker.maxScroll or 0)
	ApplyScroll()
end

local function UpdateCogColor()
	local icon = picker.button.Icon
	if module.statEditMode then
		local color = E:ClassColor(E.myclass, true)
		icon:SetVertexColor(color.r, color.g, color.b, 1)
	elseif picker.button:IsMouseOver() then
		icon:SetVertexColor(1, 1, 1, 1)
	else
		icon:SetVertexColor(0.8, 0.8, 0.8, 0.8)
	end
end

local function Button_OnEnter(button)
	UpdateCogColor()
	local tooltip = _G.GameTooltip
	tooltip:SetOwner(button, "ANCHOR_RIGHT")
	tooltip:AddLine(L["Edit Stats"], 1, 1, 1)
	tooltip:AddLine(" ")
	ClickHint("LEFT", module.statEditMode and _G.DONE or L["Edit Stats"])
	if module.statEditMode then
		ClickHint("RIGHT", L["Reset All"])
	end
	tooltip:Show()
end

local function Button_OnLeave()
	UpdateCogColor()
	_G.GameTooltip:Hide()
end

local function Button_OnClick(button, mouseButton)
	if mouseButton == "RightButton" then
		if module.statEditMode and not InCombatLockdown() then
			module:ResetStatPicker()
		end
	else
		module:SetStatEditMode(not module.statEditMode)
	end
	Button_OnEnter(button)
end

local function CreatePicker()
	local pane = _G.CharacterStatsPane
	if picker or not pane then
		return
	end

	picker = {}

	local overlay = CreateFrame("Frame", nil, pane)
	overlay:SetAllPoints(pane)
	overlay:SetFrameLevel(pane:GetFrameLevel() + 20)
	overlay:EnableMouse(true)
	overlay:EnableMouseWheel(true)
	overlay:Hide()
	overlay:SetScript("OnUpdate", Overlay_OnUpdate)
	overlay:SetScript("OnMouseDown", Overlay_OnMouseDown)
	overlay:SetScript("OnMouseUp", Overlay_OnMouseUp)
	overlay:SetScript("OnMouseWheel", Overlay_OnMouseWheel)
	overlay:SetScript("OnShow", Overlay_OnShow)
	overlay:SetScript("OnHide", Overlay_OnHide)
	picker.overlay = overlay

	-- Sits right of the pane, outside its clipping, and follows the overlay's visibility
	local scrollBar = CreateFrame("EventFrame", nil, pane:GetParent(), "MinimalScrollBar")
	scrollBar:SetPoint("TOPRIGHT", pane, "TOPRIGHT", -SCROLLBAR_INSET, -2)
	scrollBar:SetPoint("BOTTOMRIGHT", pane, "BOTTOMRIGHT", -SCROLLBAR_INSET, 2)
	scrollBar:SetFrameLevel(pane:GetFrameLevel() + 30)
	scrollBar:RegisterCallback("OnScroll", ScrollBar_OnScroll, picker)
	scrollBar:Hide()
	S:HandleTrimScrollBar(scrollBar)
	picker.scrollBar = scrollBar

	local color = E:ClassColor(E.myclass, true)

	local highlight = overlay:CreateTexture(nil, "ARTWORK")
	highlight:SetTexture(E.media.blankTex)
	highlight:SetVertexColor(color.r, color.g, color.b, 0.15)
	highlight:Hide()
	overlay.Highlight = highlight

	local dropLine = overlay:CreateTexture(nil, "OVERLAY")
	dropLine:SetTexture(E.media.blankTex)
	dropLine:SetVertexColor(color.r, color.g, color.b, 1)
	dropLine:SetHeight(2)
	dropLine:Hide()
	overlay.DropLine = dropLine

	local button = CreateFrame("Button", nil, pane)
	button:SetSize(COG_SIZE, COG_SIZE)
	button:SetPoint("TOPLEFT", pane, "TOPLEFT", 2, -2)
	button:SetFrameLevel(pane:GetFrameLevel() + 30)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetScript("OnEnter", Button_OnEnter)
	button:SetScript("OnLeave", Button_OnLeave)
	button:SetScript("OnClick", Button_OnClick)
	picker.button = button

	local icon = button:CreateTexture(nil, "OVERLAY")
	icon:SetAllPoints()
	icon:SetTexture(COG_TEXTURE)
	button.Icon = icon

	UpdateCogColor()
end

---The full list can reach below the stats pane. While editing, the pane clips its children and the
---list scrolls by moving the first category, every other row hangs below it.
function module:UpdateStatPickerOverlay()
	if not (picker and self.statEditMode) then
		return
	end

	local pane = _G.CharacterStatsPane
	local lastRow = rows[#rows]

	local contentHeight = 0
	if lastRow then
		local top, bottom = pane.AttributesCategory:GetTop(), lastRow.frame:GetBottom()
		if top and bottom then
			contentHeight = top - bottom + SCROLL_PADDING
		end
	end

	local viewHeight = pane:GetHeight()
	local maxScroll = max(0, contentHeight - viewHeight)
	scrollOffset = min(max(scrollOffset, 0), maxScroll)
	picker.maxScroll = maxScroll

	-- The scroll bar sits inside the pane, the list moves left until it clears the bar, but never
	-- past the left edge of the pane. Measured from the unshifted spot, a rebuild resets the shift.
	local scrollBar = picker.scrollBar
	local shiftX = 0
	local firstRow = rows[1] and rows[1].frame
	if maxScroll > 0 and firstRow then
		local paneLeft, paneRight = pane:GetLeft(), pane:GetRight()
		local rowLeft, rowRight = firstRow:GetLeft(), firstRow:GetRight()
		local paneCenter, listCenter = pane:GetCenter(), pane.AttributesCategory:GetCenter()
		if paneLeft and rowLeft and paneCenter and listCenter then
			local current = paneCenter - listCenter
			rowLeft, rowRight = rowLeft + current, rowRight + current
			local limit = paneRight - SCROLLBAR_INSET - scrollBar:GetWidth() - SCROLLBAR_GAP
			shiftX = min(max(rowRight - limit, 0), max(rowLeft - paneLeft, 0))
		end
	end
	picker.shiftX = shiftX
	ApplyScroll()

	if maxScroll > 0 then
		scrollBar:SetVisibleExtentPercentage(viewHeight / contentHeight)
		scrollBar:SetPanExtentPercentage(SCROLL_STEP / maxScroll)
		scrollBar:SetScrollPercentage(scrollOffset / maxScroll, true)
		scrollBar:Show()
	else
		scrollBar:Hide()
	end
end

---@param delta number pixels, positive moves the list up
function Scroll(delta)
	local maxScroll = picker.maxScroll or 0
	if maxScroll > 0 then
		-- the bar's OnScroll moves the list
		picker.scrollBar:SetScrollPercentage(min(max(scrollOffset + delta, 0), maxScroll) / maxScroll, true)
	end
end

---@param enabled boolean
function module:SetStatEditMode(enabled)
	enabled = enabled and true or false
	if enabled == (self.statEditMode or false) then
		return
	end
	if enabled and InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
		return
	end

	self.statEditMode = enabled
	scrollOffset = 0
	if not enabled then
		twipe(rows)
	end

	if picker then
		picker.overlay:SetShown(enabled)
		UpdateCogColor()
	end

	-- The pane clips the scrolled list while editing, the old state comes back afterwards
	local pane = _G.CharacterStatsPane
	if pane then
		if enabled then
			self.statPaneClipped = pane:DoesClipChildren()
			pane:SetClipsChildren(true)
		elseif self.statPaneClipped ~= nil then
			pane:SetClipsChildren(self.statPaneClipped)
			self.statPaneClipped = nil
		end
	end

	if enabled then
		self:ClearStatSlotHighlight()
		if self.socketPanel then
			self:CloseSocketFlyout()
			self:StopSocketSlotGlow()
		end
	end

	if self.frame and self.db and self.db.enable then
		self:UpdateCharacterStats()
		-- The socket panel covers the lower rows, it steps aside while editing
		if self.socketPanel and self.frame:IsShown() then
			self:RebuildSocketPanel()
		end
	end
end

function module:UpdateStatPickerButton()
	local show = self.db and self.db.enable and self.db.stats.pickerButton
	if show then
		CreatePicker()
	end

	if picker then
		picker.button:SetShown(show and true or false)
	end

	if not show then
		self:SetStatEditMode(false)
	end
end
