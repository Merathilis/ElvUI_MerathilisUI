local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local HC = MER:GetModule("MER_HoverCast")

-- MERHoverCastPage (dialogControl of a "description"): the whole HoverCast
-- editor as one widget, since AceConfig can't lay out two sidebars next to a
-- column of options. Layout: Global bindings | options of the selected binding
-- | Spec bindings | spell strip. Every change rebuilds the page.
local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local ipairs, pairs, select, unpack = ipairs, pairs, select, unpack
local floor, ceil, min, max, abs = math.floor, math.ceil, math.min, math.max, math.abs
local format, tconcat = string.format, table.concat

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local IsMouseButtonDown = IsMouseButtonDown
local PlaySound = PlaySound
local UIParent = UIParent
local C_Timer_After = C_Timer.After

local Type, Version = "MERHoverCastPage", 1

local ACCENT = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }
local COLOR_BOX = { 0.16, 0.16, 0.16, 1 }
local COLOR_BOX_HOVER = { ACCENT[1] * 0.3, ACCENT[2] * 0.3, ACCENT[3] * 0.3, 1 }
local COLOR_WARNING = { 1, 0.25, 0.15 }

local MIN_HEIGHT = 420
local TILE_H = 56
local ICON_SZ = 36
local ADD_BTN_H = 30
local ADD_BTN_PAD = 10
local SPELL_STRIP_W = 57
local SIDEBAR_PCT = 0.24
local C_PAD = 16
local ROW_H = 50
local SIDE_PAD = 20
local POPUP_H = 400
local POPUP_INSET = 15

-- Icon grid metrics shared by every picker popup
local GRID_COLS = 5
local GRID_ICON = 32
local GRID_CELL = 48
local GRID_GAP = 19
local GRID_LABEL_FONT = 10
local GRID_LABEL_GAP = 4
local GRID_ROW_GAP = 8
local GRID_LABEL_H = 14
local GRID_INNER_W = GRID_COLS * GRID_CELL + (GRID_COLS - 1) * GRID_GAP
local POPUP_W = GRID_INNER_W + POPUP_INSET * 2

-------------------------------------------------------------------------------
--  Helpers
-------------------------------------------------------------------------------
local function MakeFont(parent, size, r, g, b, a)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(E.media.normFont, size, "")
	fs:SetShadowOffset(1, -1)
	fs:SetShadowColor(0, 0, 0, 1)
	fs:SetTextColor(r or 1, g or 1, b or 1, a or 1)
	return fs
end

local function SolidTex(parent, layer, r, g, b, a)
	local tex = parent:CreateTexture(nil, layer)
	tex:SetColorTexture(r, g, b, a)
	return tex
end

-- A border of four edge textures, so it never ends up in ElvUI's template sweep
local function CreateEdge(frame, r, g, b, a, size)
	size = size or E.mult
	local edges = {}
	local function Edge(p1, p2, horizontal)
		local t = frame:CreateTexture(nil, "OVERLAY", nil, 7)
		t:SetColorTexture(r, g, b, a)
		t:SetPoint(p1)
		t:SetPoint(p2)
		if horizontal then
			t:SetHeight(size)
		else
			t:SetWidth(size)
		end
		edges[#edges + 1] = t
	end
	Edge("TOPLEFT", "TOPRIGHT", true)
	Edge("BOTTOMLEFT", "BOTTOMRIGHT", true)
	Edge("TOPLEFT", "BOTTOMLEFT", false)
	Edge("TOPRIGHT", "BOTTOMRIGHT", false)
	return edges
end

local function ShowTip(owner, text, color)
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
	GameTooltip:ClearLines()
	local r, g, b = 1, 1, 1
	if color then
		r, g, b = color[1], color[2], color[3]
	end
	for line in text:gmatch("[^\n]+") do
		GameTooltip:AddLine(line, r, g, b, true)
	end
	GameTooltip:Show()
end

local function HideTip()
	GameTooltip:Hide()
end

-- Picker tooltip for a WoW Forever ranked spell entry; false when the entry
-- carries no rank (the caller keeps its own tooltip, if any)
local function RankTip(owner, item)
	if not (item and (item.lowRank or item.ranked)) then
		return false
	end
	local text
	if item.lowRank then
		text = item.rankText and (item.name .. " (" .. item.rankText .. ")") or item.name
	else
		text = item.name .. "\n" .. L["Always casts your highest rank."]
	end
	ShowTip(owner, text)
	return true
end

-- The options window is a toplevel frame: every click into it raises it above
-- everything else in its strata, so a popup with a fixed level ends up behind it.
-- Popups are children of the window instead, far above its content (the close
-- button alone sits at +900), and move up with it when it gets raised.
local POPUP_LEVEL_OFFSET = 1500

local function GetPopupHost()
	return E:Config_GetWindow() or UIParent
end

local function PopupLevel(host, offset)
	return min(9000, host:GetFrameLevel() + (offset or POPUP_LEVEL_OFFSET))
end

-- A dark ElvUI-styled popup above the options window. ignoreUpdates keeps it out
-- of E.frames, so the template sweep can't recolor it
local function CreatePopup(parent, width, height, offset)
	local host = parent or GetPopupHost()
	local popup = CreateFrame("Frame", nil, host)
	popup:Hide()
	popup:SetSize(width, height)
	popup:SetFrameStrata("FULLSCREEN_DIALOG")
	popup:SetFrameLevel(PopupLevel(host, offset))
	popup:SetTemplate("Transparent", nil, true)
	popup:EnableMouse(true)
	return popup
end

-- Closes a popup on a left click anywhere outside of it and its opener
local function AutoClose(popup, opener)
	popup:SetScript("OnShow", function(p)
		p:SetScript("OnUpdate", function(m)
			if not m:IsMouseOver() and not opener:IsMouseOver() and IsMouseButtonDown("LeftButton") then
				m:Hide()
			end
		end)
	end)
end

local function CreateScroll(parent, child)
	local scroll = CreateFrame("ScrollFrame", nil, parent)
	child:SetParent(scroll)
	scroll:SetScrollChild(child)
	scroll:EnableMouseWheel(true)
	scroll:SetScript("OnMouseWheel", function(self, delta)
		local s = self:GetVerticalScroll()
		local mx = max(0, child:GetHeight() - self:GetHeight())
		self:SetVerticalScroll(max(0, min(mx, s - delta * 30)))
	end)
	return scroll
end

-- Accent (or gray) filled text button
local function CreateFillButton(parent, width, text, primary, fontSize)
	local btn = CreateFrame("Button", nil, parent)
	btn:SetSize(width, ADD_BTN_H)
	local bg = btn:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	local lbl = MakeFont(btn, fontSize or 12, 1, 1, 1, primary and 1 or 0.5)
	lbl:SetPoint("CENTER")
	lbl:SetText(text)
	local function Normal()
		if primary then
			bg:SetColorTexture(ACCENT[1], ACCENT[2], ACCENT[3], 0.8)
		else
			bg:SetColorTexture(0.25, 0.25, 0.25, 0.6)
			lbl:SetAlpha(0.5)
		end
	end
	Normal()
	btn:SetScript("OnEnter", function()
		if primary then
			bg:SetColorTexture(ACCENT[1], ACCENT[2], ACCENT[3], 1)
		else
			bg:SetColorTexture(0.35, 0.35, 0.35, 0.8)
			lbl:SetAlpha(0.9)
		end
	end)
	btn:SetScript("OnLeave", Normal)
	return btn
end

-- A row of mode tabs (Spells / Macros / Items) at the top of a picker popup
local function CreateModeTabs(popup, modes, topY, onSelect)
	local inner = POPUP_W - POPUP_INSET * 2
	local tabW = floor(inner / #modes) - 2
	local tabs = {}
	for i, mode in ipairs(modes) do
		local tab = CreateFrame("Button", nil, popup)
		tab:SetSize(tabW, 26)
		if i == 1 then
			tab:SetPoint("TOPLEFT", popup, "TOPLEFT", POPUP_INSET, topY)
		else
			tab:SetPoint("LEFT", tabs[i - 1], "RIGHT", 3, 0)
		end
		tab.bg = tab:CreateTexture(nil, "BACKGROUND")
		tab.bg:SetAllPoints()
		local hl = tab:CreateTexture(nil, "HIGHLIGHT")
		hl:SetAllPoints()
		hl:SetColorTexture(1, 1, 1, 0.1)
		local lbl = MakeFont(tab, 12, 1, 1, 1, 0.9)
		lbl:SetPoint("CENTER")
		lbl:SetText(mode.label)
		tab:SetScript("OnClick", function()
			onSelect(mode.key)
		end)
		tab.key = mode.key
		tabs[i] = tab
	end
	local function Update(selected)
		for _, tab in ipairs(tabs) do
			if tab.key == selected then
				tab.bg:SetColorTexture(ACCENT[1], ACCENT[2], ACCENT[3], 0.25)
			else
				tab.bg:SetColorTexture(1, 1, 1, 0.05)
			end
		end
	end
	return Update
end

-- Fills an icon grid. opts: isDimmed(item), labelText(item), onClick(item, button),
-- onEnter(cell, item), onLeave(cell, item), setup(cell, item)
local function PopulateGrid(gridChild, items, opts)
	for _, c in ipairs({ gridChild:GetChildren() }) do
		c:Hide()
		c:SetParent(nil)
	end
	for _, r in ipairs({ gridChild:GetRegions() }) do
		r:Hide()
	end

	local totalRows = ceil(#items / GRID_COLS)
	local rowHasText = {}
	for r = 0, totalRows - 1 do
		rowHasText[r] = false
		for c = 0, GRID_COLS - 1 do
			local item = items[r * GRID_COLS + c + 1]
			if item and item.name and item.name ~= "" then
				rowHasText[r] = true
				break
			end
		end
	end
	local rowY, rowH = {}, {}
	local curY = 0
	for r = 0, totalRows - 1 do
		if r > 0 then
			curY = curY + GRID_ROW_GAP
		end
		rowY[r] = -curY
		rowH[r] = rowHasText[r] and (GRID_LABEL_H + GRID_LABEL_GAP + GRID_ICON) or GRID_ICON
		curY = curY + rowH[r]
	end

	for i, item in ipairs(items) do
		local col = (i - 1) % GRID_COLS
		local r = floor((i - 1) / GRID_COLS)
		local cx = col * (GRID_CELL + GRID_GAP)
		local cy = rowY[r]

		if col == 0 and r > 0 then
			local div = gridChild:CreateTexture(nil, "ARTWORK")
			div:SetHeight(E.mult)
			div:SetPoint("TOPLEFT", gridChild, "TOPLEFT", 0, cy + GRID_ROW_GAP / 2)
			div:SetPoint("TOPRIGHT", gridChild, "TOPRIGHT", 0, cy + GRID_ROW_GAP / 2)
			div:SetColorTexture(1, 1, 1, 0.06)
		end

		local cell = CreateFrame("Button", nil, gridChild)
		cell:SetSize(GRID_CELL, rowH[r])
		cell:SetPoint("TOPLEFT", gridChild, "TOPLEFT", cx, cy)
		cell:RegisterForClicks("AnyUp")

		local iconFrame = CreateFrame("Frame", nil, cell)
		iconFrame:SetSize(GRID_ICON, GRID_ICON)
		local iconTex = iconFrame:CreateTexture(nil, "ARTWORK")
		iconTex:SetAllPoints()
		iconTex:SetTexCoord(unpack(E.TexCoords))
		iconTex:SetTexture(item.icon or 134400)
		local dimmed = opts.isDimmed and opts.isDimmed(item)
		if dimmed then
			iconTex:SetAlpha(0.3)
		end

		local iconBorder = CreateFrame("Frame", nil, iconFrame)
		iconBorder:SetAllPoints()
		iconBorder:SetFrameLevel(iconFrame:GetFrameLevel() + 1)
		CreateEdge(iconBorder, ACCENT[1], ACCENT[2], ACCENT[3], 1, 2)
		iconBorder:Hide()

		local label
		local text = opts.labelText and opts.labelText(item) or item.name
		if rowHasText[r] and text and text ~= "" then
			label = MakeFont(cell, GRID_LABEL_FONT, 1, 1, 1, dimmed and 0.3 or 0.7)
			label:SetPoint("TOP", cell, "TOP", 0, 0)
			label:SetWidth(GRID_CELL + 4)
			label:SetJustifyH("CENTER")
			label:SetWordWrap(false)
			label:SetText(text)
			iconFrame:SetPoint("TOP", label, "BOTTOM", 0, -GRID_LABEL_GAP)
		else
			iconFrame:SetPoint("TOP", cell, "TOP", 0, 0)
		end

		cell:SetScript("OnEnter", function()
			iconBorder:Show()
			if label then
				label:SetAlpha(1)
			end
			if opts.onEnter then
				opts.onEnter(cell, item)
			end
		end)
		cell:SetScript("OnLeave", function()
			iconBorder:Hide()
			if label then
				label:SetAlpha(dimmed and 0.3 or 0.7)
			end
			if opts.onLeave then
				opts.onLeave(cell, item)
			end
		end)
		cell:SetScript("OnClick", function(_, button)
			opts.onClick(item, button)
		end)
		if opts.setup then
			opts.setup(cell, item)
		end
	end
	gridChild:SetHeight(max(10, curY))
end

-- Pill toggle in the look of MERToggleSwitch
local function BuildToggle(parent, getValue, setValue)
	local track = CreateFrame("Button", nil, parent)
	track:SetSize(34, 16)
	track:SetFrameLevel(parent:GetFrameLevel() + 2)
	track:CreateBackdrop("Transparent", nil, true)
	local knob = track:CreateTexture(nil, "OVERLAY")
	knob:SetSize(12, 12)
	local function Refresh()
		if getValue() then
			track.backdrop:SetBackdropColor(ACCENT[1], ACCENT[2], ACCENT[3], 1)
			knob:SetColorTexture(0.92, 0.92, 0.92, 1)
			knob:ClearAllPoints()
			knob:SetPoint("RIGHT", track, "RIGHT", -2, 0)
		else
			track.backdrop:SetBackdropColor(0.16, 0.16, 0.16, 1)
			knob:SetColorTexture(0.55, 0.55, 0.55, 1)
			knob:ClearAllPoints()
			knob:SetPoint("LEFT", track, "LEFT", 2, 0)
		end
	end
	Refresh()
	track:SetScript("OnClick", function()
		local value = not getValue()
		PlaySound(value and 856 or 857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON/OFF
		setValue(value)
		Refresh()
	end)
	return track, Refresh
end

-- Dropdown box in the look of MERDropdown. With items (a list of
-- { key, label, tooltip }) and getChecked/setChecked it is a checkbox list that
-- shows "All" / "None" / the ticked labels; otherwise a single choice from
-- values/order. disabledTip(key) returns a tooltip for an entry that can't be picked.
local function BuildDropdown(owner, parent, width, opts)
	local box = CreateFrame("Button", nil, parent)
	box:SetSize(width, 22)
	box:SetFrameLevel(parent:GetFrameLevel() + 2)
	box:CreateBackdrop("Transparent", nil, true)
	box.backdrop:SetBackdropColor(unpack(COLOR_BOX))

	local arrow = box:CreateTexture(nil, "ARTWORK")
	arrow:SetTexture(E.Media.Textures.ArrowUp)
	arrow:SetRotation(3.14)
	arrow:SetSize(12, 12)
	arrow:SetPoint("RIGHT", box, "RIGHT", -4, 0)
	arrow:SetVertexColor(ACCENT[1], ACCENT[2], ACCENT[3])

	local text = MakeFont(box, 12, 1, 1, 1, 1)
	text:SetJustifyH("LEFT")
	text:SetWordWrap(false)
	text:SetPoint("LEFT", box, "LEFT", 6, 0)
	text:SetPoint("RIGHT", arrow, "LEFT", -4, 0)

	local multi = opts.items ~= nil
	local function Refresh()
		if multi then
			local on = {}
			for _, item in ipairs(opts.items) do
				if opts.getChecked(item.key) then
					on[#on + 1] = item.label
				end
			end
			if #on == #opts.items then
				text:SetText(L["All"])
			elseif #on == 0 then
				text:SetText(L["None"])
			else
				text:SetText(tconcat(on, ", "))
			end
		else
			text:SetText(opts.values[opts.get()] or "")
		end
	end
	Refresh()

	local list
	local function CloseList()
		if list then
			list:Hide()
		end
	end

	local function OpenList()
		local entries = {}
		if multi then
			for _, item in ipairs(opts.items) do
				entries[#entries + 1] = { key = item.key, label = item.label, tooltip = item.tooltip }
			end
		else
			for _, key in ipairs(opts.order) do
				entries[#entries + 1] = { key = key, label = opts.values[key] }
			end
		end

		local ENTRY_H = 20
		list = CreatePopup(nil, width, #entries * ENTRY_H + 8)
		list:SetPoint("TOPLEFT", box, "BOTTOMLEFT", 0, -2)
		owner.dropdownList = list

		for i, entry in ipairs(entries) do
			local row = CreateFrame("Button", nil, list)
			row:SetHeight(ENTRY_H)
			row:SetPoint("TOPLEFT", list, "TOPLEFT", 4, -4 - (i - 1) * ENTRY_H)
			row:SetPoint("TOPRIGHT", list, "TOPRIGHT", -4, -4 - (i - 1) * ENTRY_H)
			local hl = row:CreateTexture(nil, "HIGHLIGHT")
			hl:SetAllPoints()
			hl:SetColorTexture(ACCENT[1], ACCENT[2], ACCENT[3], 0.25)

			local mark = row:CreateTexture(nil, "ARTWORK")
			mark:SetSize(10, 10)
			mark:SetPoint("LEFT", row, "LEFT", 4, 0)
			local function UpdateMark()
				local on
				if multi then
					on = opts.getChecked(entry.key)
				else
					on = opts.get() == entry.key
				end
				if on then
					mark:SetColorTexture(ACCENT[1], ACCENT[2], ACCENT[3], 1)
				else
					mark:SetColorTexture(1, 1, 1, multi and 0.12 or 0)
				end
			end
			UpdateMark()

			local lbl = MakeFont(row, 12, 1, 1, 1, 1)
			lbl:SetPoint("LEFT", mark, "RIGHT", 6, 0)
			lbl:SetPoint("RIGHT", row, "RIGHT", -4, 0)
			lbl:SetJustifyH("LEFT")
			lbl:SetWordWrap(false)
			lbl:SetText(entry.label)

			local blockedTip = opts.disabledTip and opts.disabledTip(entry.key)
			if blockedTip then
				lbl:SetAlpha(0.35)
				mark:SetAlpha(0.35)
			end

			row:SetScript("OnEnter", function(self)
				local tip = blockedTip or entry.tooltip
				if tip then
					ShowTip(self, tip)
				end
			end)
			row:SetScript("OnLeave", HideTip)
			row:SetScript("OnClick", function()
				if blockedTip then
					return
				end
				if multi then
					opts.setChecked(entry.key, not opts.getChecked(entry.key))
					UpdateMark()
					Refresh()
				else
					CloseList()
					opts.set(entry.key)
					Refresh()
				end
			end)
		end

		AutoClose(list, box)
		list:SetScript("OnHide", function(p)
			p:SetScript("OnUpdate", nil)
			if owner.dropdownList == p then
				owner.dropdownList = nil
			end
		end)
		list:Show()
	end

	box:SetScript("OnClick", function()
		if list and list:IsShown() then
			CloseList()
		else
			OpenList()
		end
	end)
	box:SetScript("OnEnter", function()
		box.backdrop:SetBackdropColor(unpack(COLOR_BOX_HOVER))
	end)
	box:SetScript("OnLeave", function()
		box.backdrop:SetBackdropColor(unpack(COLOR_BOX))
	end)
	box:SetScript("OnHide", CloseList)

	return box
end

-- Keybind capture button: left-click starts listening, then any key, mouse
-- button (bare left-click included) or wheel turn is the binding; right-click
-- clears it, Escape cancels
local function BuildKeybindButton(parent, width, getCurrentKey, onKeySet, onKeyClear)
	local kbBtn = CreateFrame("Button", nil, parent)
	kbBtn:SetSize(width, 30)
	kbBtn:SetFrameLevel(parent:GetFrameLevel() + 2)
	kbBtn:RegisterForClicks("AnyUp")
	kbBtn:CreateBackdrop("Transparent", nil, true)
	kbBtn.backdrop:SetBackdropColor(unpack(COLOR_BOX))
	local kbLbl = MakeFont(kbBtn, 13, 1, 1, 1, 0.9)
	kbLbl:SetPoint("CENTER")

	local listening = false
	local function RefreshLabel()
		local key = getCurrentKey and getCurrentKey()
		kbLbl:SetText(key and HC:FormatKey(key) or L["Not Bound"])
	end
	RefreshLabel()

	-- Stops capturing: disables keyboard + wheel so the page scrolls normally again
	local function StopListening()
		listening = false
		kbBtn:EnableKeyboard(false)
		kbBtn:EnableMouseWheel(false)
		kbBtn.backdrop:SetBackdropColor(unpack(COLOR_BOX))
		RefreshLabel()
	end

	kbBtn:SetScript("OnClick", function(_, button)
		if not listening then
			if button == "LeftButton" then
				listening = true
				kbLbl:SetText(L["Press a key, click, or scroll..."])
				kbBtn.backdrop:SetBackdropColor(unpack(COLOR_BOX_HOVER))
				kbBtn:EnableKeyboard(true)
				kbBtn:EnableMouseWheel(true)
			elseif button == "RightButton" then
				if onKeyClear then
					onKeyClear()
				end
				RefreshLabel()
			end
			return
		end
		-- While listening, any click is a binding (including bare left-click)
		local mods = HC:GetModifierPrefix()
		local normalized = HC.MOUSE_BUTTON_MAP[button] or ("BUTTON" .. (button:match("%d+") or button))
		StopListening()
		if onKeySet then
			onKeySet(mods .. normalized)
		end
	end)

	kbBtn:SetScript("OnKeyDown", function(self, key)
		if not listening then
			self:SetPropagateKeyboardInput(true)
			return
		end
		if HC.MODIFIER_KEYS[key] then
			self:SetPropagateKeyboardInput(true)
			return
		end
		self:SetPropagateKeyboardInput(false)
		if key == "ESCAPE" then
			StopListening()
			return
		end
		local mods = HC:GetModifierPrefix()
		StopListening()
		if onKeySet then
			onKeySet(mods .. key)
		end
	end)

	-- Wheel binding only via this capture button; MOUSEWHEELUP/DOWN bind through
	-- the keybind path (SetBindingClick), same as keyboard keys
	kbBtn:SetScript("OnMouseWheel", function(_, delta)
		if not listening then
			return
		end
		local mods = HC:GetModifierPrefix()
		local wheel = delta > 0 and "MOUSEWHEELUP" or "MOUSEWHEELDOWN"
		StopListening()
		if onKeySet then
			onKeySet(mods .. wheel)
		end
	end)

	kbBtn:SetScript("OnEnter", function(self)
		if not listening then
			kbBtn.backdrop:SetBackdropColor(unpack(COLOR_BOX_HOVER))
		end
		ShowTip(self, L["Left-click to set keybind.\nRight-click to clear."])
	end)
	kbBtn:SetScript("OnLeave", function()
		HideTip()
		if not listening then
			kbBtn.backdrop:SetBackdropColor(unpack(COLOR_BOX))
		end
	end)
	kbBtn:SetScript("OnHide", function()
		if listening then
			StopListening()
		end
	end)

	return kbBtn
end

local function NewSpellBinding(item, key)
	return {
		type = "spell",
		spell = item.name,
		spellID = item.id,
		icon = item.icon,
		key = key,
		enabled = true,
		oocOnly = false,
		hovercast = false,
		hoverFriendly = true,
		hoverEnemy = true,
		-- A WoW Forever lower rank keeps casting that rank
		rankPinned = item.lowRank,
	}
end

-- Macros default to BOTH reactions (unlike spells, which are friendly-only
-- for the click-cast healing case): a macro is general-purpose (e.g. mouseover
-- focus/target), so friendly-only would leave it dead on enemies
local function NewMacroBinding(item, key)
	return {
		type = "macro",
		macroName = item.macroName,
		icon = item.icon,
		key = key,
		enabled = true,
		oocOnly = false,
		hovercast = false,
		hoverFriendly = true,
		hoverEnemy = true,
	}
end

local function NewItemBinding(item, key)
	return {
		type = "item",
		itemSlot = item.itemSlot,
		itemName = item.itemName or item.name,
		icon = item.icon,
		key = key,
		enabled = true,
		oocOnly = false,
		hovercast = false,
		hoverFriendly = true,
		hoverEnemy = true,
	}
end

local function MacroItems(global)
	local items = {}
	local macros = global and HC:GetGlobalMacros() or HC:GetAllMacros()
	for _, m in ipairs(macros) do
		local prefix = m.isGlobal and "" or "(C) "
		items[#items + 1] = { name = prefix .. m.name, icon = m.icon, macroName = m.name }
	end
	return items
end

-------------------------------------------------------------------------------
--  Page
-------------------------------------------------------------------------------
-- The reference is dropped before the hide, so the Quickbind dimmer's OnHide
-- doesn't rebuild a page that is being released
local function HidePopups(self, includeQuickbind)
	for _, key in ipairs({ "gridPopup", "dropdownList", includeQuickbind and "qbPopup" or nil }) do
		local popup = self[key]
		if popup then
			self[key] = nil
			popup:Hide()
		end
	end
end

local BuildPage

local function RebuildPage(self)
	BuildPage(self)
end

local function SelectBinding(self, side, idx)
	HC.selSide = side
	HC.selIndex = idx
	RebuildPage(self)
end

-- One sidebar binding tile
local function BuildTile(self, scrollChild, tileY, width, binding, isSelected, side, idx, onDelete)
	local tile = CreateFrame("Button", nil, scrollChild)
	tile:SetSize(width, TILE_H)
	tile:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, tileY)
	tile:SetFrameLevel(scrollChild:GetFrameLevel() + 1)

	local tileBg = SolidTex(tile, "BACKGROUND", 1, 1, 1, isSelected and 0.06 or 0)
	tileBg:SetAllPoints()

	if isSelected then
		local accent = tile:CreateTexture(nil, "ARTWORK", nil, 2)
		accent:SetSize(2, TILE_H)
		accent:SetPoint("TOPLEFT", tile, "TOPLEFT", 0, 0)
		accent:SetColorTexture(ACCENT[1], ACCENT[2], ACCENT[3], 1)
	end

	local iconFrame = CreateFrame("Frame", nil, tile)
	iconFrame:SetSize(ICON_SZ, ICON_SZ)
	iconFrame:SetPoint("LEFT", tile, "LEFT", 8, 0)
	local iconTex = iconFrame:CreateTexture(nil, "ARTWORK")
	iconTex:SetAllPoints()
	iconTex:SetTexCoord(unpack(E.TexCoords))
	iconTex:SetTexture(HC:GetBindingIcon(binding))
	CreateEdge(iconFrame, 0, 0, 0, 0.6, 1)

	local textX = 8 + ICON_SZ + 8
	local title = MakeFont(tile, 13, 1, 1, 1, 1)
	title:SetPoint("TOPLEFT", tile, "TOPLEFT", textX, -11)
	title:SetPoint("RIGHT", tile, "RIGHT", -30, 0)
	title:SetJustifyH("LEFT")
	title:SetWordWrap(false)
	title:SetText(HC:GetBindingName(binding))

	local keySub = MakeFont(tile, 11, 0.75, 0.75, 0.75, 0.65)
	keySub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -3)
	keySub:SetPoint("RIGHT", tile, "RIGHT", -30, 0)
	keySub:SetJustifyH("LEFT")
	keySub:SetWordWrap(false)
	-- A pinned WoW Forever rank names its rank beside the key
	local rankTxt = HC:GetBindingRankText(binding)
	keySub:SetText(
		(binding.key and HC:FormatKey(binding.key) or L["Not Bound"]) .. (rankTxt and ("  -  " .. rankTxt) or "")
	)

	-- A spell the character has not got right now dims when another binding
	-- took its key; the binding stays for the loadout that has it
	local untalented = HC:IsShadowedBinding(binding)
	if untalented then
		iconTex:SetAlpha(0.35)
		title:SetAlpha(0.45)
		keySub:SetAlpha(0.45)
	end

	-- Complementary Friendly/Enemy spell pairs may share a key. Mark only real
	-- collisions, in the action area so the marker never covers the icon.
	if HC:IsReactionBinding(binding) and HC:IsBindingActive(binding) and binding.key then
		local conflicts = HC:FindKeyConflicts(binding.key, binding)
		if #conflicts > 0 then
			local warning = CreateFrame("Button", nil, tile)
			warning:SetSize(18, 18)
			warning:SetPoint("TOPRIGHT", tile, "TOPRIGHT", -26, -7)
			warning:SetFrameLevel(tile:GetFrameLevel() + 2)
			local warningText = MakeFont(warning, 15, COLOR_WARNING[1], COLOR_WARNING[2], COLOR_WARNING[3], 1)
			warningText:SetAllPoints()
			warningText:SetJustifyH("CENTER")
			warningText:SetText("!")
			local lines = {
				L["Conflicting Keybind"],
				format(L["%s is also assigned to:"], HC:FormatKey(binding.key)),
			}
			for _, name in ipairs(conflicts) do
				lines[#lines + 1] = "- " .. name
			end
			local tooltip = tconcat(lines, "\n")
			warning:SetScript("OnEnter", function(btn)
				ShowTip(btn, tooltip, COLOR_WARNING)
			end)
			warning:SetScript("OnLeave", HideTip)
			warning:SetScript("OnClick", function()
				SelectBinding(self, side, idx)
			end)
		end
	end

	if onDelete then
		local delBtn = CreateFrame("Button", nil, tile)
		delBtn:SetSize(16, 16)
		delBtn:SetPoint("TOPRIGHT", tile, "TOPRIGHT", -8, -8)
		delBtn:SetFrameLevel(tile:GetFrameLevel() + 2)
		local delTex = delBtn:CreateTexture(nil, "ARTWORK")
		delTex:SetAllPoints()
		delTex:SetTexture(I.Media.Icons.Delete)
		delTex:SetVertexColor(0.75, 0.75, 0.75)
		delTex:SetAlpha(0.5)
		delBtn:SetScript("OnEnter", function()
			delTex:SetAlpha(0.9)
		end)
		delBtn:SetScript("OnLeave", function()
			delTex:SetAlpha(0.5)
		end)
		delBtn:SetScript("OnClick", function()
			onDelete(idx)
		end)
	end

	local sep = SolidTex(tile, "ARTWORK", 1, 1, 1, 0.04)
	sep:SetHeight(E.mult)
	sep:SetPoint("BOTTOMLEFT", tile, "BOTTOMLEFT", 0, 0)
	sep:SetPoint("BOTTOMRIGHT", tile, "BOTTOMRIGHT", 0, 0)

	tile:SetScript("OnClick", function()
		SelectBinding(self, side, idx)
	end)
	tile:SetScript("OnEnter", function(btn)
		if not isSelected then
			tileBg:SetColorTexture(1, 1, 1, 0.04)
		end
		if untalented then
			ShowTip(btn, L["Not currently talented"])
		end
	end)
	tile:SetScript("OnLeave", function()
		if not isSelected then
			tileBg:SetColorTexture(1, 1, 1, 0)
		end
		if untalented then
			HideTip()
		end
	end)

	return tile
end

-- A sidebar: header, scrolling tile list and the add button(s) under the last
-- tile, which stick to the bottom once the list is taller than the sidebar
local function BuildSidebar(root, width, height, titleText)
	local outer = CreateFrame("Frame", nil, root)
	outer:SetSize(width, height)
	outer:SetFrameLevel(root:GetFrameLevel() + 1)
	local bg = SolidTex(outer, "BACKGROUND", 0, 0, 0, 0.25)
	bg:SetAllPoints()

	local headerText = MakeFont(outer, 13, 1, 1, 1, 0.75)
	headerText:SetPoint("TOP", outer, "TOP", 0, -18)
	headerText:SetText(titleText)

	local child = CreateFrame("Frame", nil, outer)
	child:SetWidth(width)
	local scroll = CreateScroll(outer, child)
	scroll:SetPoint("TOPLEFT", outer, "TOPLEFT", 0, -38)
	scroll:SetPoint("BOTTOMRIGHT", outer, "BOTTOMRIGHT", 0, 0)
	scroll:SetFrameLevel(outer:GetFrameLevel() + 1)

	return outer, scroll, child
end

local function AddStickyButtons(outer, scroll, buttonsBottom, inline, sticky)
	local stickyBg = CreateFrame("Frame", nil, outer)
	stickyBg:SetHeight(ADD_BTN_H + 20)
	stickyBg:SetPoint("BOTTOMLEFT", outer, "BOTTOMLEFT", 0, 0)
	stickyBg:SetPoint("BOTTOMRIGHT", outer, "BOTTOMRIGHT", 0, 0)
	stickyBg:SetFrameLevel(outer:GetFrameLevel() + 4)
	stickyBg:EnableMouse(true)
	local bgTex = SolidTex(stickyBg, "BACKGROUND", 0.06, 0.06, 0.06, 1)
	bgTex:SetAllPoints()

	for _, btn in ipairs(sticky) do
		btn:SetFrameLevel(outer:GetFrameLevel() + 5)
	end

	local function Update()
		local overflow = buttonsBottom > scroll:GetVerticalScroll() + scroll:GetHeight()
		stickyBg:SetShown(overflow)
		for _, btn in ipairs(sticky) do
			btn:SetShown(overflow)
		end
		for _, btn in ipairs(inline) do
			btn:SetAlpha(overflow and 0 or 1)
		end
	end
	local origWheel = scroll:GetScript("OnMouseWheel")
	scroll:SetScript("OnMouseWheel", function(frame, delta)
		origWheel(frame, delta)
		Update()
	end)
	-- The scroll frame only has its height once the layout ran
	C_Timer_After(0, Update)
	Update()
end

-- Picker popup next to a sidebar: mode tabs on top, icon grid below
local function OpenPickerPopup(self, opener, sidebar, side, modes, startMode, fill)
	if self.gridPopup and self.gridPopup:IsShown() then
		self.gridPopup:Hide()
		return
	end

	local popup = CreatePopup(nil, POPUP_W, POPUP_H)
	-- Flush with the sidebar's inner edge, centered vertically on the opener and
	-- clamped so the bottom doesn't go below the page
	local btnMidY = select(2, opener:GetCenter()) or 0
	local sidebarMidY = select(2, sidebar:GetCenter()) or 0
	local offsetY = btnMidY - sidebarMidY
	local rootBottom = self.root:GetBottom() or 0
	local popupBottom = btnMidY - POPUP_H / 2
	if popupBottom < rootBottom then
		offsetY = offsetY + (rootBottom - popupBottom)
	end
	if side == "left" then
		popup:SetPoint("LEFT", sidebar, "RIGHT", 0, offsetY)
	else
		popup:SetPoint("RIGHT", sidebar, "LEFT", 0, offsetY)
	end
	self.gridPopup = popup

	local gridChild = CreateFrame("Frame", nil, popup)
	gridChild:SetWidth(GRID_INNER_W)
	local gridScroll = CreateScroll(popup, gridChild)
	gridScroll:SetPoint("TOPLEFT", popup, "TOPLEFT", POPUP_INSET, -(POPUP_INSET + 40))
	gridScroll:SetPoint("BOTTOMRIGHT", popup, "BOTTOMRIGHT", -POPUP_INSET, POPUP_INSET)
	gridScroll:SetFrameLevel(popup:GetFrameLevel() + 2)

	local UpdateTabs
	local function SelectMode(mode)
		UpdateTabs(mode)
		gridScroll:SetVerticalScroll(0)
		fill(mode, gridChild, popup)
	end
	UpdateTabs = CreateModeTabs(popup, modes, -POPUP_INSET, SelectMode)
	SelectMode(startMode)

	AutoClose(popup, opener)
	popup:SetScript("OnHide", function(p)
		p:SetScript("OnUpdate", nil)
		HideTip()
		if self.gridPopup == p then
			self.gridPopup = nil
		end
	end)
	popup:Show()
end

local function OpenQuickbind(self, bound)
	if self.qbPopup and self.qbPopup:IsShown() then
		self.qbPopup:Hide()
		return
	end

	-- Covers the whole screen including the options window, so it is a child of
	-- that window like the other popups
	local host = GetPopupHost()
	local dimmer = CreateFrame("Frame", nil, host)
	dimmer:SetFrameStrata("FULLSCREEN_DIALOG")
	dimmer:SetFrameLevel(PopupLevel(host))
	dimmer:SetAllPoints(UIParent)
	dimmer:EnableMouse(true)
	local dimBg = SolidTex(dimmer, "BACKGROUND", 0, 0, 0, 0.6)
	dimBg:SetAllPoints()

	local popup = CreatePopup(dimmer, POPUP_W, POPUP_H, 100)
	popup:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	popup:Show()
	self.qbPopup = dimmer

	local titleLbl = MakeFont(popup, 13, 1, 1, 1, 0.9)
	titleLbl:SetPoint("TOP", popup, "TOP", 0, -POPUP_INSET)
	titleLbl:SetText(L["Quickbind: hover a spell, press a key"])

	local tabTop = -(POPUP_INSET + 22)
	local gridChild = CreateFrame("Frame", nil, popup)
	gridChild:SetWidth(GRID_INNER_W)
	local gridScroll = CreateScroll(popup, gridChild)
	gridScroll:SetPoint("TOPLEFT", popup, "TOPLEFT", POPUP_INSET, tabTop - 36)
	gridScroll:SetPoint("BOTTOMRIGHT", popup, "BOTTOMRIGHT", -POPUP_INSET, POPUP_INSET + 38)
	gridScroll:SetFrameLevel(popup:GetFrameLevel() + 2)

	local mode = "spell"
	local UpdateTabs
	local Fill

	-- Binds the hovered entry to the captured key/button as a spec binding
	local function BindItem(item, captured)
		local binding
		if item.id then
			binding = NewSpellBinding(item, captured)
		elseif item.macroName then
			binding = NewMacroBinding(item, captured)
		elseif item.itemSlot or item.itemName then
			binding = NewItemBinding(item, captured)
		end
		if not binding then
			return
		end
		HC:AddSpecBinding(binding)
		if item.macroName then
			bound.macros[item.macroName] = true
		elseif item.itemSlot then
			bound.items[item.itemSlot] = true
		else
			bound.spells[HC:SpellBoundKey(item.id, item.name or "", item.lowRank)] = true
		end
		Fill()
		RebuildPage(self)
	end

	function Fill()
		UpdateTabs(mode)
		local items
		if mode == "spell" then
			items = HC:GetClassSpells()
		elseif mode == "macro" then
			items = MacroItems(false)
		else
			items = HC:GetEquippedItems()
		end
		PopulateGrid(gridChild, items, {
			isDimmed = function(item)
				return (item.id and HC:IsSpellBound(bound.spells, item.id, item.name, item.lowRank))
					or (item.macroName and bound.macros[item.macroName])
					or (item.itemSlot and bound.items[item.itemSlot])
			end,
			-- A WoW Forever lower rank labels itself by its rank
			labelText = function(item)
				return item.lowRank and item.rankText or item.name
			end,
			onEnter = function(cell, item)
				cell:EnableKeyboard(true)
				RankTip(cell, item)
			end,
			onLeave = function(cell, item)
				cell:EnableKeyboard(false)
				if item.lowRank or item.ranked then
					HideTip()
				end
			end,
			-- Mouse click while hovering: bind with modifier+button
			onClick = function(item, button)
				local normalized = HC.MOUSE_BUTTON_MAP[button] or ("BUTTON" .. (button:match("%d+") or button))
				BindItem(item, HC:GetModifierPrefix() .. normalized)
			end,
			-- Key press while hovering: bind this entry to that key
			setup = function(cell, item)
				cell:EnableKeyboard(false)
				cell:SetScript("OnKeyDown", function(frame, key)
					if HC.MODIFIER_KEYS[key] then
						frame:SetPropagateKeyboardInput(true)
						return
					end
					frame:SetPropagateKeyboardInput(false)
					if key == "ESCAPE" then
						dimmer:Hide()
						return
					end
					local captured = HC:CaptureKey(key)
					if captured then
						BindItem(item, captured)
					end
				end)
			end,
		})
	end

	UpdateTabs = CreateModeTabs(
		popup,
		{
			{ key = "spell", label = L["Spells"] },
			{ key = "macro", label = L["Macros"] },
			{ key = "item", label = L["Items"] },
		},
		tabTop,
		function(newMode)
			mode = newMode
			gridScroll:SetVerticalScroll(0)
			Fill()
		end
	)
	Fill()

	local doneBtn = CreateFillButton(popup, 100, L["Done"], false, 11)
	doneBtn:SetPoint("BOTTOM", popup, "BOTTOM", 0, POPUP_INSET)
	doneBtn:SetFrameLevel(popup:GetFrameLevel() + 3)
	doneBtn:SetScript("OnClick", function()
		dimmer:Hide()
	end)

	dimmer:SetScript("OnMouseDown", function()
		if not popup:IsMouseOver() then
			dimmer:Hide()
		end
	end)
	dimmer:SetScript("OnHide", function()
		HideTip()
		if self.qbPopup == dimmer then
			self.qbPopup = nil
			RebuildPage(self)
		end
	end)

	dimmer:Show()
end

function BuildPage(self)
	HidePopups(self)
	if self.root then
		self.root:Hide()
		self.root:SetParent(nil)
		self.root = nil
	end

	local cc = HC:GetDB()
	local parentW = floor(self.frame:GetWidth() or 0)
	local visibleH = self.pageHeight or MIN_HEIGHT
	if not cc or parentW < 300 then
		return
	end
	self.builtWidth = parentW

	local root = CreateFrame("Frame", nil, self.frame)
	root:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, 0)
	root:SetSize(parentW, visibleH)
	self.root = root
	root:SetScript("OnHide", function()
		HidePopups(self)
	end)

	local usableW = parentW - SPELL_STRIP_W
	local sidebarW = floor(usableW * SIDEBAR_PCT)
	local centerW = usableW - sidebarW * 2

	-- Selected binding (persists across rebuilds)
	local selectedBinding
	local selectedSide, selectedIndex = HC.selSide, HC.selIndex
	if selectedSide == "global" and selectedIndex then
		selectedBinding = HC:GetGlobalBindings()[selectedIndex]
	elseif selectedSide == "spec" and selectedIndex then
		selectedBinding = HC:GetSpecBindings()[selectedIndex]
	end

	-- Lookup sets for already-bound spells/macros/items (dimmed in the pickers)
	local bound = { spells = {}, macros = {}, items = {} }
	local function Collect(list)
		for _, b in ipairs(list) do
			if b.spell then
				bound.spells[HC:SpellBoundKey(b.spellID, b.spell, b.rankPinned)] = true
			end
			if b.macroName then
				bound.macros[b.macroName] = true
			end
			if b.itemSlot then
				bound.items[b.itemSlot] = true
			end
		end
	end
	Collect(HC:GetGlobalBindings())
	Collect(HC:GetSpecBindings())
	-- An enabled preset already casts its class spells
	for _, gb in ipairs(HC:GetGlobalBindings()) do
		if gb.enabled and gb.key and (gb.type == "dispel" or gb.type == "external" or gb.type == "dynamicrez") then
			for _, name in ipairs(HC:GetPresetSpellNames(gb.type)) do
				bound.spells[name] = true
			end
		end
	end

	---------------------------------------------------------------------------
	--  LEFT SIDEBAR (Global Bindings)
	---------------------------------------------------------------------------
	local leftOuter, leftScroll, leftChild = BuildSidebar(root, sidebarW, visibleH, L["Global Bindings"])
	leftOuter:SetPoint("TOPLEFT", root, "TOPLEFT", 0, 0)

	local leftY = 0
	for i, gb in ipairs(HC:GetGlobalBindings()) do
		local isSel = selectedSide == "global" and selectedIndex == i
		-- The built-in actions and presets stay, they can only be unbound
		local canDelete = gb.type ~= "target"
			and gb.type ~= "menu"
			and gb.type ~= "dispel"
			and gb.type ~= "external"
			and gb.type ~= "trinket1"
			and gb.type ~= "trinket2"
			and gb.type ~= "dynamicrez"
		BuildTile(self, leftChild, leftY, sidebarW, gb, isSel, "global", i, canDelete and function(idx)
			HC:RemoveGlobalBinding(idx)
			HC.selSide, HC.selIndex = nil, nil
			RebuildPage(self)
		end or nil)
		leftY = leftY - TILE_H
	end

	local function OpenGlobalPicker(opener)
		OpenPickerPopup(
			self,
			opener,
			leftOuter,
			"left",
			{
				{ key = "macro", label = L["Macros"] },
				{ key = "item", label = L["Items"] },
			},
			"macro",
			function(mode, gridChild, popup)
				local items = mode == "macro" and MacroItems(true) or HC:GetEquippedItems()
				PopulateGrid(gridChild, items, {
					isDimmed = function(item)
						return (item.macroName and bound.macros[item.macroName])
							or (item.itemSlot and bound.items[item.itemSlot])
					end,
					onClick = function(item)
						popup:Hide()
						local binding = mode == "macro" and NewMacroBinding(item) or NewItemBinding(item)
						HC:AddGlobalBinding(binding)
						HC.selSide, HC.selIndex = "global", #HC:GetGlobalBindings()
						RebuildPage(self)
					end,
				})
			end
		)
	end

	local addGlobalBtn = CreateFillButton(leftChild, floor(sidebarW * 0.8), L["Add Global Binding"], true)
	addGlobalBtn:SetPoint("TOP", leftChild, "TOPLEFT", sidebarW / 2, leftY - ADD_BTN_PAD)
	addGlobalBtn:SetFrameLevel(leftChild:GetFrameLevel() + 1)
	addGlobalBtn:SetScript("OnClick", OpenGlobalPicker)
	leftY = leftY - ADD_BTN_PAD - ADD_BTN_H - 10
	leftChild:SetHeight(max(10, abs(leftY)))

	local stickyGlobalBtn = CreateFillButton(leftOuter, floor(sidebarW * 0.8), L["Add Global Binding"], true)
	stickyGlobalBtn:SetPoint("BOTTOM", leftOuter, "BOTTOM", 0, 10)
	stickyGlobalBtn:SetScript("OnClick", OpenGlobalPicker)
	AddStickyButtons(leftOuter, leftScroll, abs(leftY), { addGlobalBtn }, { stickyGlobalBtn })

	---------------------------------------------------------------------------
	--  RIGHT SIDEBAR (Spec Bindings)
	---------------------------------------------------------------------------
	local rightOuter, rightScroll, rightChild = BuildSidebar(root, sidebarW, visibleH, L["Spec Bindings"])
	rightOuter:SetPoint("TOPRIGHT", root, "TOPRIGHT", -SPELL_STRIP_W, 0)

	local rightY = 0
	for i, sb in ipairs(HC:GetSpecBindings()) do
		local isSel = selectedSide == "spec" and selectedIndex == i
		BuildTile(self, rightChild, rightY, sidebarW, sb, isSel, "spec", i, function(idx)
			HC:RemoveSpecBinding(idx)
			HC.selSide, HC.selIndex = nil, nil
			RebuildPage(self)
		end)
		rightY = rightY - TILE_H
	end

	local function OpenSpecPicker(opener)
		OpenPickerPopup(
			self,
			opener,
			rightOuter,
			"right",
			{
				{ key = "spell", label = L["Spells"] },
				{ key = "macro", label = L["Macros"] },
				{ key = "item", label = L["Items"] },
			},
			"spell",
			function(mode, gridChild, popup)
				local items
				if mode == "spell" then
					items = HC:GetClassSpells()
				elseif mode == "macro" then
					items = MacroItems(false)
				else
					items = HC:GetEquippedItems()
				end
				PopulateGrid(gridChild, items, {
					isDimmed = function(item)
						return (item.id and HC:IsSpellBound(bound.spells, item.id, item.name, item.lowRank))
							or (item.macroName and bound.macros[item.macroName])
							or (item.itemSlot and bound.items[item.itemSlot])
					end,
					-- A WoW Forever lower rank labels itself by its rank
					labelText = function(item)
						return item.lowRank and item.rankText or item.name
					end,
					onEnter = function(cell, item)
						RankTip(cell, item)
					end,
					onLeave = function(_, item)
						if item.lowRank or item.ranked then
							HideTip()
						end
					end,
					onClick = function(item)
						popup:Hide()
						local binding
						if mode == "spell" then
							binding = NewSpellBinding(item)
						elseif mode == "macro" then
							binding = NewMacroBinding(item)
						else
							binding = NewItemBinding(item)
						end
						HC:AddSpecBinding(binding)
						HC.selSide, HC.selIndex = "spec", #HC:GetSpecBindings()
						RebuildPage(self)
					end,
				})
			end
		)
	end

	local btnW = floor(sidebarW * 0.42)
	local btnX = floor((sidebarW - btnW * 2 - 8) / 2)
	local addSpecBtn = CreateFillButton(rightChild, btnW, L["Add New"], true, 11)
	addSpecBtn:SetPoint("TOPLEFT", rightChild, "TOPLEFT", btnX, rightY - ADD_BTN_PAD)
	addSpecBtn:SetFrameLevel(rightChild:GetFrameLevel() + 1)
	addSpecBtn:SetScript("OnClick", OpenSpecPicker)

	local qbBtn = CreateFillButton(rightChild, btnW, L["Quickbind"], false, 11)
	qbBtn:SetPoint("LEFT", addSpecBtn, "RIGHT", 8, 0)
	qbBtn:SetFrameLevel(rightChild:GetFrameLevel() + 1)
	qbBtn:SetScript("OnClick", function()
		OpenQuickbind(self, bound)
	end)
	rightY = rightY - ADD_BTN_PAD - ADD_BTN_H - 10
	rightChild:SetHeight(max(10, abs(rightY)))

	local stickySpecBtn = CreateFillButton(rightOuter, btnW, L["Add New"], true, 11)
	stickySpecBtn:SetPoint("BOTTOMLEFT", rightOuter, "BOTTOMLEFT", btnX, 10)
	stickySpecBtn:SetScript("OnClick", OpenSpecPicker)
	local stickyQBBtn = CreateFillButton(rightOuter, btnW, L["Quickbind"], false, 11)
	stickyQBBtn:SetPoint("LEFT", stickySpecBtn, "RIGHT", 8, 0)
	stickyQBBtn:SetScript("OnClick", function()
		OpenQuickbind(self, bound)
	end)
	AddStickyButtons(rightOuter, rightScroll, abs(rightY), { addSpecBtn, qbBtn }, { stickySpecBtn, stickyQBBtn })

	---------------------------------------------------------------------------
	--  CENTER CONTENT
	---------------------------------------------------------------------------
	local centerFrame = CreateFrame("Frame", nil, root)
	centerFrame:SetSize(centerW, visibleH)
	centerFrame:SetPoint("TOPLEFT", leftOuter, "TOPRIGHT", 0, 0)
	centerFrame:SetFrameLevel(root:GetFrameLevel() + 1)

	local rowW = centerW - C_PAD * 2
	local centerY = 0
	local rowCount = 0
	-- Everything below Enable Click Casting gates on it; rows parent to bodyHost
	-- so a dimmable container can be swapped in after that first row
	local bodyHost = centerFrame

	local function MakeRow(yPos)
		local row = CreateFrame("Frame", nil, bodyHost)
		row:SetSize(rowW, ROW_H)
		row:SetPoint("TOPLEFT", bodyHost, "TOPLEFT", C_PAD, yPos)
		rowCount = rowCount + 1
		local bg = SolidTex(row, "BACKGROUND", 1, 1, 1, rowCount % 2 == 1 and 0.03 or 0.015)
		bg:SetAllPoints()
		return row
	end

	local function RowLabel(row, text, indent)
		local lbl = MakeFont(row, 14, 1, 1, 1, 1)
		lbl:SetPoint("LEFT", row, "LEFT", SIDE_PAD + (indent or 0), 0)
		lbl:SetText(text)
		return lbl
	end

	local function RowToggle(row, getValue, setValue)
		local pill, refresh = BuildToggle(row, getValue, setValue)
		pill:SetPoint("RIGHT", row, "RIGHT", -SIDE_PAD, 0)
		return pill, refresh
	end

	local function SectionHeader(parentFrame, text, gap)
		centerY = centerY - gap
		local secLabel = MakeFont(parentFrame, 11, ACCENT[1], ACCENT[2], ACCENT[3], 1)
		secLabel:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", C_PAD, centerY - 14)
		secLabel:SetText(text)
		local secLine = SolidTex(parentFrame, "ARTWORK", 1, 1, 1, 0.08)
		secLine:SetHeight(E.mult)
		secLine:SetPoint("LEFT", secLabel, "RIGHT", 8, 0)
		secLine:SetPoint("RIGHT", parentFrame, "RIGHT", -C_PAD, 0)
		centerY = centerY - 33
	end

	-------------------------------------------------------------------
	--  GLOBAL OPTIONS section
	-------------------------------------------------------------------
	SectionHeader(centerFrame, L["Global Options"], 6)

	-- Enable Click Casting (everything else gates on it). Locked while Clique is
	-- loaded -- both would bind clicks on the same frames, and that can't change
	-- without a reload.
	do
		local row = MakeRow(centerY)
		local lbl = RowLabel(row, L["Enable Click Casting"])
		local pill = RowToggle(row, function()
			return cc.enabled
		end, function(v)
			HC:SetEnabled(v)
			RebuildPage(self)
		end)
		if HC:IsCliqueLoaded() then
			lbl:SetAlpha(0.4)
			pill:SetAlpha(0.3)
			pill:SetScript("OnClick", nil)
			pill:SetScript("OnEnter", function(frame)
				ShowTip(frame, L['Please disable the addon "Clique" to use this feature.'])
			end)
			pill:SetScript("OnLeave", HideTip)
		end
		centerY = centerY - ROW_H
	end

	-- Holds every gated center control: dimmed + click-blocked when click-casting is off
	local centerBody = CreateFrame("Frame", nil, centerFrame)
	centerBody:SetAllPoints(centerFrame)
	centerBody:SetFrameLevel(centerFrame:GetFrameLevel() + 1)
	bodyHost = centerBody
	local gatedTop = centerY

	do
		local row = MakeRow(centerY)
		RowLabel(row, L["Trigger Bindings on Down"])
		RowToggle(row, function()
			return cc.downClick
		end, function(v)
			HC:SetDownClick(v)
		end)
		centerY = centerY - ROW_H
	end

	do
		local row = MakeRow(centerY)
		RowLabel(row, L["Mouseover Frames"])
		local dd = BuildDropdown(self, row, 160, {
			values = { all = L["All Unit Frames"], group = L["ElvUI Group Frames"] },
			order = { "all", "group" },
			get = function()
				return cc.allFrames and "all" or "group"
			end,
			set = function(v)
				HC:SetAllFrames(v == "all")
			end,
		})
		dd:SetPoint("RIGHT", row, "RIGHT", -SIDE_PAD, 0)
		centerY = centerY - ROW_H
	end

	-------------------------------------------------------------------
	--  PER-SPELL OPTIONS section
	-------------------------------------------------------------------
	SectionHeader(bodyHost, L["Per-Spell Options"], 12)

	if selectedBinding then
		-- Title with icon (centered, type label above name)
		do
			centerY = centerY - 10
			local titleRow = CreateFrame("Frame", nil, bodyHost)
			titleRow:SetSize(rowW, 44)
			titleRow:SetPoint("TOPLEFT", bodyHost, "TOPLEFT", C_PAD, centerY)

			local t = selectedBinding.type
			local typeStr = L["Spell"]
			if t == "macro" then
				typeStr = L["Macro"]
			elseif t == "item" then
				typeStr = L["Item"]
			elseif t == "target" or t == "menu" then
				typeStr = L["Action"]
			elseif t == "dispel" or t == "external" then
				typeStr = L["Preset"]
			end
			local tType = MakeFont(titleRow, 11, 1, 1, 1, 0.4)
			-- A pinned WoW Forever rank names its rank beside the type
			local rankTxt = HC:GetBindingRankText(selectedBinding)
			tType:SetText(typeStr .. (rankTxt and ("  -  " .. rankTxt) or ""))

			local tName = MakeFont(titleRow, 15, 1, 1, 1, 0.9)
			tName:SetText(HC:GetBindingName(selectedBinding))

			local textW = max(tType:GetStringWidth(), tName:GetStringWidth())
			local iconSz, gap = 32, 10
			local totalW = iconSz + gap + textW

			local tIcon = titleRow:CreateTexture(nil, "ARTWORK")
			tIcon:SetSize(iconSz, iconSz)
			tIcon:SetPoint("LEFT", titleRow, "CENTER", -totalW / 2, 0)
			tIcon:SetTexCoord(unpack(E.TexCoords))
			tIcon:SetTexture(HC:GetBindingIcon(selectedBinding))

			tType:SetPoint("TOPLEFT", tIcon, "TOPRIGHT", gap, 0)
			tName:SetPoint("BOTTOMLEFT", tIcon, "BOTTOMRIGHT", gap, 0)

			centerY = centerY - 53
		end

		-- Keybind
		do
			local row = MakeRow(centerY)
			RowLabel(row, L["Keybind"])
			local kbBtn = BuildKeybindButton(row, 180, function()
				return selectedBinding.key
			end, function(newKey)
				selectedBinding.key = newKey
				HC:ApplyBindings()
				RebuildPage(self)
			end, function()
				selectedBinding.key = nil
				HC:ApplyBindings()
				RebuildPage(self)
			end)
			kbBtn:SetPoint("RIGHT", row, "RIGHT", -SIDE_PAD, 0)
			centerY = centerY - ROW_H
		end

		-- Dynamic Rez: a dead unit gets the class rez, a living one the binding's
		-- own action. Only for macro-expressible actions (a [dead] /cast can lead);
		-- target/menu have no macro fallback.
		local t = selectedBinding.type
		local canSmartRez = t == "spell"
			or t == "macro"
			or t == "item"
			or t == "dispel"
			or t == "external"
			or t == "trinket1"
			or t == "trinket2"
		if canSmartRez then
			local row = MakeRow(centerY)
			RowLabel(row, L["Enable Dynamic Rez"])
			RowToggle(row, function()
				return selectedBinding.smartRez
			end, function(v)
				selectedBinding.smartRez = v
				HC:ApplyBindings()
			end)
			centerY = centerY - ROW_H
		end

		local hasAdvancedOpts = canSmartRez or t == "dynamicrez"
		-- Out of combat only applies to every action; menu/target are gated
		-- securely through an attribute driver
		if hasAdvancedOpts or t == "menu" or t == "target" then
			local row = MakeRow(centerY)
			local oocLabel = L["Only Cast Out of Combat"]
			if t == "menu" then
				oocLabel = L["Only Open Menu Out of Combat"]
			elseif t == "target" then
				oocLabel = L["Only Target Out of Combat"]
			end
			RowLabel(row, oocLabel)
			RowToggle(row, function()
				return selectedBinding.oocOnly
			end, function(v)
				selectedBinding.oocOnly = v
				HC:ApplyBindings()
			end)
			centerY = centerY - ROW_H
		end

		-- Content gate: outside the chosen contexts the binding is not applied,
		-- so its key keeps doing whatever the player normally has bound.
		-- groupCtx stays nil while everything is on, the default.
		do
			local row = MakeRow(centerY)
			RowLabel(row, L["Active In"])
			local dd = BuildDropdown(self, row, 160, {
				items = {
					{ key = "solo", label = L["Solo"], tooltip = L["Active while you are not in a group."] },
					{ key = "party", label = L["Party"], tooltip = L["Active in a PvE party."] },
					{ key = "raid", label = L["Raid"], tooltip = L["Active in a PvE raid."] },
					{ key = "pvp", label = L["PvP"], tooltip = L["Active in battlegrounds and arenas."] },
				},
				getChecked = function(key)
					return HC:CtxEnabled(selectedBinding, key)
				end,
				setChecked = function(key, v)
					-- nil means all-on, so materialize the full set before the
					-- first tick turns one context off; collapse back to nil
					-- once everything is on again
					local set = selectedBinding.groupCtx
					if not set then
						set = {}
						for _, c in ipairs(HC.CTX_ORDER) do
							set[c] = true
						end
						selectedBinding.groupCtx = set
					end
					set[key] = v and true or false
					local n = 0
					for _, c in ipairs(HC.CTX_ORDER) do
						if set[c] == true then
							n = n + 1
						end
					end
					if n == #HC.CTX_ORDER then
						selectedBinding.groupCtx = nil
					end
					HC:ApplyBindings()
				end,
			})
			dd:SetPoint("RIGHT", row, "RIGHT", -SIDE_PAD, 0)
			centerY = centerY - ROW_H
		end

		if hasAdvancedOpts then
			-- Cast On: hovercast is unavailable for bare left/right click, so
			-- those two entries are shown disabled with the reason as a tooltip
			do
				local row = MakeRow(centerY)
				local isBareMouseBtn = selectedBinding.key == "BUTTON1" or selectedBinding.key == "BUTTON2"
				RowLabel(row, L["Cast On"])
				if isBareMouseBtn and selectedBinding.hovercast then
					selectedBinding.hovercast = false
					HC:ApplyBindings()
				end
				local dd = BuildDropdown(self, row, 160, {
					values = {
						frames = L["Frames"],
						units = L["Mouseover"],
						both = L["Frames and Mouseover"],
					},
					order = { "frames", "units", "both" },
					get = function()
						if selectedBinding.hovercast == "both" then
							return "both"
						end
						return selectedBinding.hovercast and "units" or "frames"
					end,
					set = function(v)
						selectedBinding.hovercast = (v == "both" and "both") or (v == "units" and true) or false
						HC:ApplyBindings()
						RebuildPage(self)
					end,
					disabledTip = function(key)
						if isBareMouseBtn and key ~= "frames" then
							return L["Hovercast is not available for unmodified left/right click"]
						end
						return false
					end,
				})
				dd:SetPoint("RIGHT", row, "RIGHT", -SIDE_PAD, 0)
				centerY = centerY - ROW_H
			end

			-- Spell and item reactions use the same Friendly/Enemy toggles as
			-- hovercast. Frame-only custom macros cannot safely share a key with
			-- a complementary action, so they do not expose reactions.
			if t == "spell" or t == "item" or selectedBinding.hovercast then
				local row = MakeRow(centerY)
				RowLabel(row, L["Unit Types"], 20)
				local ePill = RowToggle(row, function()
					return selectedBinding.hoverEnemy == true
				end, function(v)
					selectedBinding.hoverEnemy = v
					HC:ApplyBindings()
					RebuildPage(self)
				end)
				local eLbl = MakeFont(row, 13, 1, 1, 1, 0.8)
				eLbl:SetPoint("RIGHT", ePill, "LEFT", -8, 0)
				eLbl:SetText(L["Enemy"])

				local fPill = RowToggle(row, function()
					return selectedBinding.hoverFriendly ~= false
				end, function(v)
					selectedBinding.hoverFriendly = v
					HC:ApplyBindings()
					RebuildPage(self)
				end)
				fPill:ClearAllPoints()
				fPill:SetPoint("RIGHT", eLbl, "LEFT", -18, 0)
				local fLbl = MakeFont(row, 13, 1, 1, 1, 0.8)
				fLbl:SetPoint("RIGHT", fPill, "LEFT", -8, 0)
				fLbl:SetText(L["Friendly"])
				centerY = centerY - ROW_H

				if t == "spell" or t == "item" then
					local note = MakeFont(bodyHost, 11, 1, 1, 1, 0.45)
					note:SetPoint("TOPLEFT", bodyHost, "TOPLEFT", C_PAD + SIDE_PAD + 20, centerY - 5)
					note:SetText(L["Disabling both disables this binding."])
					centerY = centerY - 22
				end
			end
		end
	else
		local hint = MakeFont(bodyHost, 12, 1, 1, 1, 0.25)
		hint:SetPoint("TOP", bodyHost, "TOP", 0, centerY - 50)
		hint:SetWidth(rowW)
		hint:SetJustifyH("CENTER")
		hint:SetText(L["Select a binding from either sidebar to edit its options"])
	end

	---------------------------------------------------------------------------
	--  SPELL STRIP (right edge): class/spec spell icons, click to add
	---------------------------------------------------------------------------
	do
		local SS_ICON, SS_PAD, SS_GAP = 32, 10, 4

		local stripOuter = CreateFrame("Frame", nil, root)
		stripOuter:SetSize(SPELL_STRIP_W, visibleH)
		stripOuter:SetPoint("TOPRIGHT", root, "TOPRIGHT", 0, 0)
		stripOuter:SetFrameLevel(root:GetFrameLevel() + 10)
		local stripBg = SolidTex(stripOuter, "BACKGROUND", 0, 0, 0, 0.6)
		stripBg:SetAllPoints()
		stripOuter:SetAlpha(0.35)
		local stripOverlay = CreateFrame("Frame", nil, stripOuter)
		stripOverlay:SetAllPoints()
		stripOverlay:SetFrameLevel(stripOuter:GetFrameLevel() + 20)
		stripOverlay:EnableMouse(false)
		local overlayTex = SolidTex(stripOverlay, "OVERLAY", 0, 0, 0, 0.5)
		overlayTex:SetAllPoints()

		-- Hover state settles one frame later, so moving between two icons
		-- doesn't flicker through the dimmed state
		local wantHover, pending = false, false
		local function StripUpdate()
			pending = false
			stripOuter:SetAlpha(wantHover and 1 or 0.35)
			overlayTex:SetAlpha(wantHover and 0 or 0.5)
		end
		local function StripEnter()
			wantHover = true
			if not pending then
				pending = true
				C_Timer_After(0, StripUpdate)
			end
		end
		local function StripLeave()
			wantHover = false
			if not pending then
				pending = true
				C_Timer_After(0, StripUpdate)
			end
		end
		stripOuter:SetScript("OnEnter", StripEnter)
		stripOuter:SetScript("OnLeave", StripLeave)

		local stripChild = CreateFrame("Frame", nil, stripOuter)
		stripChild:SetWidth(SPELL_STRIP_W)
		local stripScroll = CreateScroll(stripOuter, stripChild)
		stripScroll:SetPoint("TOPLEFT", stripOuter, "TOPLEFT", 0, -SS_PAD)
		stripScroll:SetPoint("BOTTOMRIGHT", stripOuter, "BOTTOMRIGHT", 0, SS_PAD)
		stripScroll:SetFrameLevel(stripOuter:GetFrameLevel() + 1)

		-- Icons only here: a WoW Forever spell shows its top rank alone (the
		-- lower ranks are picked from the Add and Quickbind grids, which label them)
		local stripY = 0
		for _, sp in ipairs(HC:GetClassSpells(true)) do
			local cell = CreateFrame("Button", nil, stripChild)
			cell:SetSize(SS_ICON, SS_ICON)
			cell:SetPoint("TOPLEFT", stripChild, "TOPLEFT", 12, stripY)

			local iconTex = cell:CreateTexture(nil, "ARTWORK")
			iconTex:SetAllPoints()
			iconTex:SetTexCoord(unpack(E.TexCoords))
			iconTex:SetTexture(sp.icon or 134400)
			if HC:IsSpellBound(bound.spells, sp.id, sp.name) then
				iconTex:SetAlpha(0.3)
			end

			local iconBorder = CreateFrame("Frame", nil, cell)
			iconBorder:SetAllPoints()
			iconBorder:SetFrameLevel(cell:GetFrameLevel() + 1)
			CreateEdge(iconBorder, ACCENT[1], ACCENT[2], ACCENT[3], 1, 2)
			iconBorder:Hide()

			cell:SetScript("OnEnter", function()
				iconBorder:Show()
				StripEnter()
				if not RankTip(cell, sp) then
					ShowTip(cell, sp.name)
				end
			end)
			cell:SetScript("OnLeave", function()
				iconBorder:Hide()
				StripLeave()
				HideTip()
			end)
			cell:SetScript("OnClick", function()
				HC:AddSpecBinding(NewSpellBinding(sp))
				HC.selSide, HC.selIndex = "spec", #HC:GetSpecBindings()
				RebuildPage(self)
			end)

			stripY = stripY - (SS_ICON + SS_GAP)
		end
		stripChild:SetHeight(max(10, abs(stripY)))
	end

	-- Click-casting off: the whole editor gates on Enable. Sidebars dim and
	-- swallow clicks via an overlay; the center's gated body dims and blocks
	-- clicks below the Enable row, which stays usable.
	if not cc.enabled then
		for _, sb in ipairs({ leftOuter, rightOuter }) do
			sb:SetAlpha(0.6)
			local ov = CreateFrame("Frame", nil, root)
			ov:SetAllPoints(sb)
			ov:SetFrameLevel(sb:GetFrameLevel() + 100)
			ov:EnableMouse(true)
			ov:EnableMouseWheel(true)
			ov:SetScript("OnMouseWheel", function() end)
			local ovTex = SolidTex(ov, "OVERLAY", 0.08, 0.08, 0.08, 0.4)
			ovTex:SetAllPoints()
		end

		centerBody:SetAlpha(0.4)
		local blocker = CreateFrame("Frame", nil, centerBody)
		blocker:SetPoint("TOPLEFT", centerBody, "TOPLEFT", 0, gatedTop)
		blocker:SetPoint("BOTTOMRIGHT", centerBody, "BOTTOMRIGHT", 0, 0)
		blocker:SetFrameLevel(centerBody:GetFrameLevel() + 100)
		blocker:EnableMouse(true)
		blocker:EnableMouseWheel(true)
		blocker:SetScript("OnMouseWheel", function() end)
	end
end

-------------------------------------------------------------------------------
--  Widget
-------------------------------------------------------------------------------
-- Fills the options window: its height minus the title, tree and button rows
local function GetPageHeight()
	local dialog = E.Libs.AceConfigDialog
	local open = dialog and dialog.OpenFrames and dialog.OpenFrames.ElvUI
	local height = open and open.frame and open.frame:GetHeight()
	if not height then
		return 560
	end
	return max(MIN_HEIGHT, floor(height - 150))
end

local function QueueBuild(self)
	if self.buildQueued then
		return
	end
	self.buildQueued = true
	C_Timer_After(0, function()
		self.buildQueued = nil
		if self.frame:IsShown() then
			BuildPage(self)
		end
	end)
end

local methods = {
	["OnAcquire"] = function(self)
		self.pageHeight = GetPageHeight()
		self.builtWidth = nil
		self:SetHeight(self.pageHeight)
		self:SetFullWidth(true)
		QueueBuild(self)
	end,

	["OnRelease"] = function(self)
		HidePopups(self, true)
		if self.root then
			self.root:Hide()
			self.root:SetParent(nil)
			self.root = nil
		end
	end,

	["OnWidthSet"] = function(self, width)
		if not self.builtWidth or abs(floor(width) - self.builtWidth) > 1 then
			QueueBuild(self)
		end
	end,

	-- AceConfigDialog treats the widget as a Label
	["SetText"] = function() end,
	["SetFontObject"] = function() end,
	["SetImage"] = function() end,
	["SetImageSize"] = function() end,
	["SetJustifyH"] = function() end,
	["SetJustifyV"] = function() end,
	["SetCustomData"] = function() end,
	["SetDisabled"] = function() end,
}

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local widget = {
		frame = frame,
		type = Type,
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	frame:SetScript("OnSizeChanged", function(_, width)
		widget:OnWidthSet(width)
	end)
	frame:SetScript("OnHide", function()
		HidePopups(widget, true)
	end)

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
