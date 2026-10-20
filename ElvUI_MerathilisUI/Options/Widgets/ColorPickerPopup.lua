local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Own color picker for MERColorPicker (ColorPicker.lua), instead of Blizzard's
-- ColorPickerFrame: a saturation/brightness field, hue and opacity bars, the new
-- and the current color side by side, hex and opacity inputs, quick picks
-- (the option's default, class and accent color), favorites and recent colors.
-- Built on the first open, one popup for all color options.
--
-- module.ColorPickerPopup.Open(owner, info) - `owner` is the widget that opened
-- it, `info` = { r, g, b, a, hasAlpha, default = { r, g, b, a } | nil,
-- onChange(r, g, b, a), onConfirm(r, g, b, a) }. onChange fires live while
-- picking, onConfirm once at the end: with the picked color on OK, with the
-- original one on Cancel / Escape / the close button.
-- module.ColorPickerPopup.Detach(owner) closes it without any callback, for a
-- widget that gets released while the popup is open.
local S = E:GetModule("Skins")

local _G = _G
local abs, floor, max, min = math.abs, math.floor, math.max, math.min
local format, ipairs, tinsert, tonumber, tremove, unpack = format, ipairs, tinsert, tonumber, tremove, unpack
local CreateColor, CreateFrame, UIParent = CreateColor, CreateFrame, UIParent
local GetCursorPosition, IsMouseButtonDown = GetCursorPosition, IsMouseButtonDown
local InCombatLockdown = InCombatLockdown
local PlaySound = PlaySound

local PAD = 12
local TITLE_HEIGHT = 26
local FIELD_SIZE = 180
local BAR_WIDTH = 16
local GAP = 8
local RIGHT_WIDTH = 84
local LABEL_HEIGHT = 14
local INPUT_HEIGHT = 20
local BUTTON_HEIGHT = 20
local SWATCH_SIZE = 18
local SWATCH_SPACING = 4
local MAX_SWATCHES = 9
local ROW_HEIGHT = LABEL_HEIGHT + 2 + SWATCH_SIZE
local ROW_GAP = 6
local MARKER_ARM = 5

local COLOR_ACCENT = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }
local COLOR_MUTED = { 0.62, 0.62, 0.62 }
local COLOR_BOX = { 0.16, 0.16, 0.16, 1 }
local COLOR_BOX_HOVER = { I.Colors.Accent.r * 0.3, I.Colors.Accent.g * 0.3, I.Colors.Accent.b * 0.3, 1 }

local HUE_STOPS = {
	{ 1, 0, 0 },
	{ 1, 1, 0 },
	{ 0, 1, 0 },
	{ 0, 1, 1 },
	{ 0, 0, 1 },
	{ 1, 0, 1 },
	{ 1, 0, 0 },
}

local function HSVtoRGB(h, s, v)
	local c = v * s
	local x = c * (1 - abs((h / 60) % 2 - 1))
	local m = v - c
	local r, g, b
	if h < 60 then
		r, g, b = c, x, 0
	elseif h < 120 then
		r, g, b = x, c, 0
	elseif h < 180 then
		r, g, b = 0, c, x
	elseif h < 240 then
		r, g, b = 0, x, c
	elseif h < 300 then
		r, g, b = x, 0, c
	else
		r, g, b = c, 0, x
	end
	return r + m, g + m, b + m
end

local function RGBtoHSV(r, g, b)
	local high, low = max(r, g, b), min(r, g, b)
	local delta = high - low
	local h = 0
	if delta > 0 then
		if high == r then
			h = 60 * (((g - b) / delta) % 6)
		elseif high == g then
			h = 60 * (((b - r) / delta) + 2)
		else
			h = 60 * (((r - g) / delta) + 4)
		end
	end
	return h, high == 0 and 0 or delta / high, high
end

local function To255(value)
	return floor(value * 255 + 0.5)
end

local function ToHex(r, g, b)
	return format("%02X%02X%02X", To255(r), To255(g), To255(b))
end

local function SameColor(c, r, g, b)
	return To255(c[1]) == To255(r) and To255(c[2]) == To255(g) and To255(c[3]) == To255(b)
end

-- Favorites and recent colors are account wide
local function GetStore()
	local db = E.global.mui.colorPicker
	db.recent = db.recent or {}
	db.favorites = db.favorites or {}
	return db
end

local function RemoveColor(list, r, g, b)
	for i = #list, 1, -1 do
		if SameColor(list[i], r, g, b) then
			tremove(list, i)
			return true
		end
	end
	return false
end

local function AddColor(list, r, g, b)
	RemoveColor(list, r, g, b)
	tinsert(list, 1, { r, g, b })
	while #list > MAX_SWATCHES do
		tremove(list)
	end
end

local function IsFavorite(r, g, b)
	for _, color in ipairs(GetStore().favorites) do
		if SameColor(color, r, g, b) then
			return true
		end
	end
	return false
end

local function CreateText(parent, size, color)
	local text = parent:CreateFontString(nil, "OVERLAY")
	text:FontTemplate(nil, size or 11)
	text:SetJustifyH("LEFT")
	text:SetTextColor(unpack(color or COLOR_MUTED))
	return text
end

local function ShowTooltip(owner, title, line)
	local tooltip = _G.GameTooltip
	tooltip:SetOwner(owner, "ANCHOR_TOP")
	tooltip:SetText(title, 1, 1, 1)
	if line then
		tooltip:AddLine(line, COLOR_MUTED[1], COLOR_MUTED[2], COLOR_MUTED[3], true)
	end
	tooltip:Show()
end

local function HideTooltip()
	_G.GameTooltip:Hide()
end

-- Flat button in the style of MERButton
local function Button_Update(button)
	button.backdrop:SetBackdropColor(unpack(button.hover and COLOR_BOX_HOVER or COLOR_BOX))
end

local function Button_OnEnter(button)
	button.hover = true
	Button_Update(button)
end

local function Button_OnLeave(button)
	button.hover = nil
	Button_Update(button)
end

local function CreateButton(parent, text, onClick)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(RIGHT_WIDTH, BUTTON_HEIGHT)
	-- ignoreUpdates=true keeps it out of E.frames, see Button.lua
	button:CreateBackdrop("Transparent", nil, true)

	local label = CreateText(button, 11, { 1, 1, 1 })
	label:SetPoint("CENTER")
	label:SetText(text)

	button:SetScript("OnEnter", Button_OnEnter)
	button:SetScript("OnLeave", Button_OnLeave)
	button:SetScript("OnClick", onClick)
	Button_Update(button)
	return button
end

local function CreateInput(parent, maxLetters)
	local input = CreateFrame("EditBox", nil, parent)
	input:SetSize(RIGHT_WIDTH, INPUT_HEIGHT)
	input:SetAutoFocus(false)
	input:SetMaxLetters(maxLetters)
	input:SetJustifyH("CENTER")
	input:SetFont(F.GetFontPath(), 11, "")
	input:SetTextColor(1, 1, 1)
	input:SetTextInsets(4, 4, 0, 0)
	input:CreateBackdrop("Transparent", nil, true)
	input.backdrop:SetBackdropColor(unpack(COLOR_BOX))
	input:SetScript("OnEditFocusGained", input.HighlightText)
	return input
end

-- One border line per side, so the fields keep a thin frame without a backdrop
local function AddBorder(frame)
	local r, g, b = unpack(E.media.bordercolor)
	for _, points in ipairs({
		{ "TOPLEFT", "TOPRIGHT", 0, 1 },
		{ "BOTTOMLEFT", "BOTTOMRIGHT", 0, -1 },
		{ "TOPLEFT", "BOTTOMLEFT", -1, 0 },
		{ "TOPRIGHT", "BOTTOMRIGHT", 1, 0 },
	}) do
		local line = frame:CreateTexture(nil, "OVERLAY", nil, 6)
		line:SetColorTexture(r, g, b, 1)
		line:SetPoint(points[1], points[3], points[4])
		line:SetPoint(points[2], points[3], points[4])
		if points[3] == 0 then
			line:SetHeight(1)
		else
			line:SetWidth(1)
		end
	end
end

local popup
local state = {
	h = 0,
	s = 1,
	v = 1,
	a = 1,
	original = { 1, 1, 1, 1 },
}

local function CurrentRGBA()
	local r, g, b = HSVtoRGB(state.h, state.s, state.v)
	return r, g, b, state.hasAlpha and state.a or 1
end

-- fromHide: the popup is already hiding (Popup_OnHide)
local function Finish(confirm, fromHide)
	if not fromHide and not popup:IsShown() then
		return
	end

	local onConfirm = state.onConfirm
	local r, g, b, a
	if confirm then
		r, g, b, a = CurrentRGBA()
		AddColor(GetStore().recent, r, g, b)
	else
		r, g, b, a = unpack(state.original)
	end

	state.owner, state.onChange, state.onConfirm = nil, nil, nil
	if not fromHide then
		popup:Hide()
	end
	if onConfirm then
		onConfirm(r, g, b, a)
	end
end

local function Refresh(skipInputs)
	local r, g, b, a = CurrentRGBA()

	local hr, hg, hb = HSVtoRGB(state.h, 1, 1)
	popup.fieldHue:SetColorTexture(hr, hg, hb, 1)

	local x = state.s * FIELD_SIZE
	local y = -(1 - state.v) * FIELD_SIZE
	local marker = popup.marker
	marker.top:SetPoint("BOTTOM", popup.field, "TOPLEFT", x, y + 2)
	marker.bottom:SetPoint("TOP", popup.field, "TOPLEFT", x, y - 2)
	marker.left:SetPoint("RIGHT", popup.field, "TOPLEFT", x - 2, y)
	marker.right:SetPoint("LEFT", popup.field, "TOPLEFT", x + 2, y)

	popup.hueMarker:SetPoint("CENTER", popup.hueBar, "TOP", 0, -(state.h / 360) * FIELD_SIZE)

	popup.alphaBottom:SetRGBA(r, g, b, 0)
	popup.alphaTop:SetRGBA(r, g, b, 1)
	popup.alphaGradient:SetGradient("VERTICAL", popup.alphaBottom, popup.alphaTop)
	popup.alphaMarker:SetPoint("CENTER", popup.alphaBar, "TOP", 0, -(1 - state.a) * FIELD_SIZE)

	popup.newSwatch:SetColorTexture(r, g, b, a)

	if not skipInputs then
		if not popup.hexInput:HasFocus() then
			popup.hexInput:SetText(ToHex(r, g, b))
		end
		if not popup.alphaInput:HasFocus() then
			popup.alphaInput:SetText(floor(state.a * 100 + 0.5))
		end
	end
end

local function Changed(skipInputs)
	Refresh(skipInputs)
	if state.onChange then
		state.onChange(CurrentRGBA())
	end
end

local function SetRGB(r, g, b)
	state.h, state.s, state.v = RGBtoHSV(r, g, b)
	Changed()
end

-- Field and bars follow the cursor while the left button is held
local function DragArea_OnUpdate(area)
	if not IsMouseButtonDown("LeftButton") then
		area:SetScript("OnUpdate", nil)
		return
	end

	local x, y = GetCursorPosition()
	local scale = area:GetEffectiveScale()
	x, y = x / scale, y / scale
	local fx = max(0, min(1, (x - area:GetLeft()) / area:GetWidth()))
	local fy = max(0, min(1, (area:GetTop() - y) / area:GetHeight()))
	area.apply(fx, fy)
	Changed()
end

local function DragArea_OnMouseDown(area, button)
	if button ~= "LeftButton" then
		return
	end

	popup.hexInput:ClearFocus()
	popup.alphaInput:ClearFocus()
	DragArea_OnUpdate(area)
	area:SetScript("OnUpdate", DragArea_OnUpdate)
end

local function CreateDragArea(parent, width, apply)
	local area = CreateFrame("Frame", nil, parent)
	area:SetSize(width, FIELD_SIZE)
	area:EnableMouse(true)
	area.apply = apply
	area:SetScript("OnMouseDown", DragArea_OnMouseDown)
	AddBorder(area)
	return area
end

local function CreateBarMarker(bar)
	local marker = bar:CreateTexture(nil, "OVERLAY", nil, 7)
	marker:SetSize(BAR_WIDTH + 4, 2)
	marker:SetColorTexture(1, 1, 1, 1)
	return marker
end

local function Swatch_OnEnter(swatch)
	local c = swatch.color
	local title = swatch.title or ("|cff" .. ToHex(c[1], c[2], c[3]) .. "#" .. ToHex(c[1], c[2], c[3]) .. "|r")
	ShowTooltip(swatch, title, swatch.hint)
end

local function Swatch_OnClick(swatch, button)
	local c = swatch.color
	if button == "RightButton" then
		local favorites = GetStore().favorites
		if swatch.row == "favorites" then
			RemoveColor(favorites, c[1], c[2], c[3])
		elseif swatch.row == "recent" and not IsFavorite(c[1], c[2], c[3]) then
			AddColor(favorites, c[1], c[2], c[3])
		else
			return
		end
		HideTooltip()
		popup.UpdateRows()
		return
	end

	PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
	if c[4] and state.hasAlpha then
		state.a = c[4]
	end
	SetRGB(c[1], c[2], c[3])
end

local function CreateSwatch(parent)
	local swatch = CreateFrame("Button", nil, parent)
	swatch:SetSize(SWATCH_SIZE, SWATCH_SIZE)
	swatch:CreateBackdrop("Transparent", nil, true)
	swatch.tex = swatch:CreateTexture(nil, "ARTWORK")
	swatch.tex:SetAllPoints()
	swatch:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	swatch:SetScript("OnEnter", Swatch_OnEnter)
	swatch:SetScript("OnLeave", HideTooltip)
	swatch:SetScript("OnClick", Swatch_OnClick)
	return swatch
end

-- A labeled row of swatches below the field. `entries` = list of { color, title, hint }.
local function FillRow(row, entries)
	for i = 1, MAX_SWATCHES do
		local swatch = row.swatches[i]
		local entry = entries[i]
		if entry then
			if not swatch then
				swatch = CreateSwatch(row)
				swatch:SetPoint(
					"TOPLEFT",
					row,
					"TOPLEFT",
					(i - 1) * (SWATCH_SIZE + SWATCH_SPACING),
					-(LABEL_HEIGHT + 2)
				)
				row.swatches[i] = swatch
			end
			swatch.color = entry.color
			swatch.title = entry.title
			swatch.hint = entry.hint
			swatch.row = row.key
			swatch.tex:SetColorTexture(entry.color[1], entry.color[2], entry.color[3], 1)
			swatch:Show()
		elseif swatch then
			swatch:Hide()
		end
	end
	row.empty:SetShown(#entries == 0)
end

local function CreateRow(parent, key, title, emptyText)
	local row = CreateFrame("Frame", nil, parent)
	row:SetSize(FIELD_SIZE, ROW_HEIGHT)
	row.key = key
	row.swatches = {}

	local label = CreateText(row, 10)
	label:SetPoint("TOPLEFT")
	label:SetText(title)

	row.empty = CreateText(row, 10, { 0.4, 0.4, 0.4 })
	row.empty:SetPoint("TOPLEFT", 0, -(LABEL_HEIGHT + 4))
	row.empty:SetText(emptyText)
	return row
end

local function UpdateRows()
	local quick = {}
	if state.default then
		local d = state.default
		tinsert(quick, { color = { d[1], d[2], d[3], d[4] }, title = L["Default"] })
	end
	local class = E:ClassColor(E.myclass, true)
	tinsert(quick, { color = { class.r, class.g, class.b }, title = L["Class Color"] })
	tinsert(quick, { color = { COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3] }, title = L["Accent Color"] })
	FillRow(popup.quickRow, quick)

	local store = GetStore()
	local favorites = {}
	for i, color in ipairs(store.favorites) do
		favorites[i] = { color = color, hint = L["Right-click to remove it from your favorites."] }
	end
	FillRow(popup.favoritesRow, favorites)

	local recent = {}
	for i, color in ipairs(store.recent) do
		recent[i] = { color = color, hint = L["Right-click to add it to your favorites."] }
	end
	FillRow(popup.recentRow, recent)
end

local function CommitHex(input)
	local text = input:GetText():upper():gsub("[^%dA-F]", "")
	if #text == 6 then
		local r = tonumber(text:sub(1, 2), 16) / 255
		local g = tonumber(text:sub(3, 4), 16) / 255
		local b = tonumber(text:sub(5, 6), 16) / 255
		state.h, state.s, state.v = RGBtoHSV(r, g, b)
		Changed(true)
		return true
	end
	return false
end

local function CommitAlpha(input)
	local value = tonumber(input:GetText())
	if value then
		state.a = max(0, min(100, value)) / 100
		Changed(true)
		return true
	end
	return false
end

local function SetupInput(input, commit)
	input:SetScript("OnTextChanged", function(self, userInput)
		if userInput then
			commit(self)
		end
	end)
	input:SetScript("OnEnterPressed", function(self)
		commit(self)
		self:ClearFocus()
		Refresh()
	end)
	input:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
		Refresh()
	end)
	input:SetScript("OnEditFocusLost", function()
		Refresh()
	end)
end

-- Escape cancels. Only out of combat: a keyboard-enabled frame that stops
-- passing keys on would otherwise eat every key while the popup is open.
local function Popup_OnKeyDown(frame, key)
	if InCombatLockdown() then
		return
	end

	if key == "ESCAPE" then
		frame:SetPropagateKeyboardInput(false)
		Finish(false)
	else
		frame:SetPropagateKeyboardInput(true)
	end
end

local function Popup_OnShow(frame)
	if InCombatLockdown() then
		frame:EnableKeyboard(false)
	else
		frame:EnableKeyboard(true)
		frame:SetPropagateKeyboardInput(true)
	end
end

local function Popup_OnHide(frame)
	frame.field:SetScript("OnUpdate", nil)
	frame.hueBar:SetScript("OnUpdate", nil)
	frame.alphaBar:SetScript("OnUpdate", nil)
	-- Hidden some other way (e.g. a UI reload of the options): treat as cancel
	if state.onConfirm then
		Finish(false, true)
	end
end

local function BuildPopup()
	popup = CreateFrame("Frame", "MER_ColorPickerPopup", UIParent)
	popup:SetFrameStrata("FULLSCREEN_DIALOG")
	popup:SetToplevel(true)
	popup:SetClampedToScreen(true)
	popup:SetMovable(true)
	popup:EnableMouse(true)
	popup:Hide()
	popup:CreateBackdrop("Transparent")
	W:GetModule("Skins"):CreateShadow(popup.backdrop)

	-- Title bar, drags the popup
	local titleBar = CreateFrame("Frame", nil, popup)
	titleBar:SetPoint("TOPLEFT")
	titleBar:SetPoint("TOPRIGHT")
	titleBar:SetHeight(TITLE_HEIGHT)
	titleBar:EnableMouse(true)
	titleBar:RegisterForDrag("LeftButton")
	titleBar:SetScript("OnDragStart", function()
		popup:StartMoving()
	end)
	titleBar:SetScript("OnDragStop", function()
		popup:StopMovingOrSizing()
	end)

	local accentBar = titleBar:CreateTexture(nil, "OVERLAY")
	accentBar:SetSize(3, 12)
	accentBar:SetPoint("LEFT", PAD, -2)
	accentBar:SetColorTexture(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 1)

	local title = CreateText(titleBar, 12, { 1, 1, 1 })
	title:SetPoint("LEFT", accentBar, "RIGHT", 6, 0)
	title:SetText(L["Color Picker"])

	local close = CreateFrame("Button", nil, popup, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 2, 2)
	S:HandleCloseButton(close)
	close:SetScript("OnClick", function()
		Finish(false)
	end)

	-- Saturation (left to right) / brightness (bottom to top) field
	local field = CreateDragArea(popup, FIELD_SIZE, function(fx, fy)
		state.s, state.v = fx, 1 - fy
	end)
	field:SetPoint("TOPLEFT", PAD, -(TITLE_HEIGHT + 4))

	local fieldHue = field:CreateTexture(nil, "BACKGROUND")
	fieldHue:SetAllPoints()

	local fieldWhite = field:CreateTexture(nil, "BORDER")
	fieldWhite:SetAllPoints()
	fieldWhite:SetColorTexture(1, 1, 1, 1)
	fieldWhite:SetGradient("HORIZONTAL", CreateColor(1, 1, 1, 1), CreateColor(1, 1, 1, 0))

	local fieldBlack = field:CreateTexture(nil, "ARTWORK")
	fieldBlack:SetAllPoints()
	fieldBlack:SetColorTexture(1, 1, 1, 1)
	fieldBlack:SetGradient("VERTICAL", CreateColor(0, 0, 0, 1), CreateColor(0, 0, 0, 0))

	-- Crosshair with a gap in the middle, so the picked color stays visible
	local marker = {}
	for _, key in ipairs({ "top", "bottom", "left", "right" }) do
		local line = field:CreateTexture(nil, "OVERLAY", nil, 7)
		line:SetColorTexture(1, 1, 1, 0.9)
		if key == "top" or key == "bottom" then
			line:SetSize(1, MARKER_ARM)
		else
			line:SetSize(MARKER_ARM, 1)
		end
		marker[key] = line
	end

	-- Hue bar, red on top through the spectrum back to red
	local hueBar = CreateDragArea(popup, BAR_WIDTH, function(_, fy)
		state.h = min(fy * 360, 359.99)
	end)
	hueBar:SetPoint("TOPLEFT", field, "TOPRIGHT", GAP, 0)

	local segment = FIELD_SIZE / 6
	for i = 1, 6 do
		local tex = hueBar:CreateTexture(nil, "BACKGROUND")
		tex:SetSize(BAR_WIDTH, segment)
		tex:SetPoint("TOPLEFT", 0, -(i - 1) * segment)
		tex:SetColorTexture(1, 1, 1, 1)
		local top, bottom = HUE_STOPS[i], HUE_STOPS[i + 1]
		tex:SetGradient(
			"VERTICAL",
			CreateColor(bottom[1], bottom[2], bottom[3], 1),
			CreateColor(top[1], top[2], top[3], 1)
		)
	end

	-- Opacity bar over a checkerboard, only for options with alpha
	local alphaBar = CreateDragArea(popup, BAR_WIDTH, function(_, fy)
		state.a = 1 - fy
	end)
	alphaBar:SetPoint("TOPLEFT", hueBar, "TOPRIGHT", GAP, 0)

	local cell = BAR_WIDTH / 2
	for row = 0, (FIELD_SIZE / cell) - 1 do
		for col = 0, 1 do
			local shade = ((row + col) % 2 == 0) and 0.32 or 0.16
			local tex = alphaBar:CreateTexture(nil, "BACKGROUND")
			tex:SetSize(cell, cell)
			tex:SetPoint("TOPLEFT", col * cell, -row * cell)
			tex:SetColorTexture(shade, shade, shade, 1)
		end
	end

	local alphaGradient = alphaBar:CreateTexture(nil, "ARTWORK")
	alphaGradient:SetAllPoints()
	alphaGradient:SetColorTexture(1, 1, 1, 1)

	-- Right column: new / current color, hex, opacity, buttons
	local right = CreateFrame("Frame", nil, popup)
	right:SetWidth(RIGHT_WIDTH)
	right:SetPoint("TOP", field, "TOP")
	right:SetPoint("BOTTOMRIGHT", -PAD, PAD)

	local newLabel = CreateText(right, 10)
	newLabel:SetPoint("TOPLEFT")
	newLabel:SetText(L["New"])

	local currentLabel = CreateText(right, 10)
	currentLabel:SetPoint("TOPRIGHT")
	currentLabel:SetText(L["Current"])

	local preview = CreateFrame("Frame", nil, right)
	preview:SetSize(RIGHT_WIDTH, 32)
	preview:SetPoint("TOPLEFT", 0, -(LABEL_HEIGHT + 2))
	preview:CreateBackdrop("Transparent", nil, true)

	local newSwatch = preview:CreateTexture(nil, "ARTWORK")
	newSwatch:SetPoint("TOPLEFT")
	newSwatch:SetPoint("BOTTOMRIGHT", preview, "BOTTOM")

	-- A click on the current color goes back to it
	local current = CreateFrame("Button", nil, preview)
	current:SetPoint("TOPLEFT", preview, "TOP")
	current:SetPoint("BOTTOMRIGHT")
	local currentSwatch = current:CreateTexture(nil, "ARTWORK")
	currentSwatch:SetAllPoints()
	current:SetScript("OnEnter", function(self)
		ShowTooltip(self, L["Current"], L["Click to go back to this color."])
	end)
	current:SetScript("OnLeave", HideTooltip)
	current:SetScript("OnClick", function()
		local o = state.original
		state.a = o[4]
		SetRGB(o[1], o[2], o[3])
	end)

	local hexLabel = CreateText(right, 10)
	hexLabel:SetPoint("TOPLEFT", preview, "BOTTOMLEFT", 0, -10)
	hexLabel:SetText(L["Hex"])

	local hexInput = CreateInput(right, 7)
	hexInput:SetPoint("TOPLEFT", hexLabel, "BOTTOMLEFT", 0, -2)
	SetupInput(hexInput, CommitHex)

	local alphaLabel = CreateText(right, 10)
	alphaLabel:SetPoint("TOPLEFT", hexInput, "BOTTOMLEFT", 0, -10)
	alphaLabel:SetText(L["Opacity"] .. " %")

	local alphaInput = CreateInput(right, 3)
	alphaInput:SetNumeric(true)
	alphaInput:SetPoint("TOPLEFT", alphaLabel, "BOTTOMLEFT", 0, -2)
	SetupInput(alphaInput, CommitAlpha)

	local okButton = CreateButton(right, _G.OKAY, function()
		PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
		Finish(true)
	end)
	okButton:SetPoint("BOTTOMLEFT")

	local cancelButton = CreateButton(right, _G.CANCEL, function()
		PlaySound(857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
		Finish(false)
	end)
	cancelButton:SetPoint("BOTTOMLEFT", okButton, "TOPLEFT", 0, 4)

	-- Swatch rows below the field
	local quickRow = CreateRow(popup, "quick", L["Quick Colors"], "")
	quickRow:SetPoint("TOPLEFT", field, "BOTTOMLEFT", 0, -10)
	local favoritesRow = CreateRow(popup, "favorites", L["Favorites"], L["Right-click a recent color to add it."])
	favoritesRow:SetPoint("TOPLEFT", quickRow, "BOTTOMLEFT", 0, -ROW_GAP)
	local recentRow = CreateRow(popup, "recent", L["Recent Colors"], L["Colors you confirm show up here."])
	recentRow:SetPoint("TOPLEFT", favoritesRow, "BOTTOMLEFT", 0, -ROW_GAP)

	popup.field = field
	popup.fieldHue = fieldHue
	popup.marker = marker
	popup.hueBar = hueBar
	popup.hueMarker = CreateBarMarker(hueBar)
	popup.alphaBar = alphaBar
	popup.alphaGradient = alphaGradient
	popup.alphaMarker = CreateBarMarker(alphaBar)
	popup.alphaBottom = CreateColor(1, 1, 1, 0)
	popup.alphaTop = CreateColor(1, 1, 1, 1)
	popup.alphaLabel = alphaLabel
	popup.alphaInput = alphaInput
	popup.hexInput = hexInput
	popup.newSwatch = newSwatch
	popup.currentSwatch = currentSwatch
	popup.right = right
	popup.quickRow = quickRow
	popup.favoritesRow = favoritesRow
	popup.recentRow = recentRow
	popup.UpdateRows = UpdateRows

	popup:SetScript("OnKeyDown", Popup_OnKeyDown)
	popup:SetScript("OnShow", Popup_OnShow)
	popup:SetScript("OnHide", Popup_OnHide)
end

local function UpdateSize()
	local barsWidth = BAR_WIDTH + GAP + (state.hasAlpha and (BAR_WIDTH + GAP) or 0)
	local width = PAD + FIELD_SIZE + GAP + barsWidth + GAP + RIGHT_WIDTH + PAD
	local height = TITLE_HEIGHT + 4 + FIELD_SIZE + 10 + (ROW_HEIGHT * 3) + (ROW_GAP * 2) + PAD
	popup:SetSize(width, height)

	popup.alphaBar:SetShown(state.hasAlpha and true or false)
	popup.alphaLabel:SetShown(state.hasAlpha and true or false)
	popup.alphaInput:SetShown(state.hasAlpha and true or false)
end

-- Below the box that opened it, or above when there's no room below
local function Place(anchor)
	popup:ClearAllPoints()
	if not anchor then
		popup:SetPoint("CENTER")
		return
	end

	local scale = anchor:GetEffectiveScale() / popup:GetEffectiveScale()
	local bottom = (anchor:GetBottom() or 0) * scale
	if bottom - popup:GetHeight() - 4 < 0 then
		popup:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, 4)
	else
		popup:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -4)
	end
end

module.ColorPickerPopup = {}

---@param owner table widget that opens the picker
---@param info table see the comment at the top of this file
---@param anchor Frame? the popup opens next to it
function module.ColorPickerPopup.Open(owner, info, anchor)
	if not popup then
		BuildPopup()
	end

	-- Another color option was still being picked: keep what it got so far
	if popup:IsShown() then
		Finish(true)
	end

	state.owner = owner
	state.onChange = info.onChange
	state.onConfirm = info.onConfirm
	state.hasAlpha = info.hasAlpha
	state.default = info.default
	state.original = { info.r or 0, info.g or 0, info.b or 0, info.hasAlpha and (info.a or 1) or 1 }
	state.h, state.s, state.v = RGBtoHSV(info.r or 0, info.g or 0, info.b or 0)
	state.a = state.original[4]

	popup.currentSwatch:SetColorTexture(unpack(state.original))
	UpdateSize()
	UpdateRows()
	Refresh()
	Place(anchor)
	popup:Show()
	popup:Raise()
end

---@param owner table
function module.ColorPickerPopup.Detach(owner)
	if popup and popup:IsShown() and state.owner == owner then
		state.owner, state.onChange, state.onConfirm = nil, nil, nil
		popup:Hide()
	end
end
