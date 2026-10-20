local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_AddonManager") ---@class AddonManager

-- Look of the addon list while the Addon Manager is on: the flat colors of the
-- options widgets (MERToggleSwitch, MERButton, MERSectionHeader), the accent
-- color and a resize grip. Only own textures and frames get colored, ElvUI's
-- skin stays underneath and is back as soon as the module is turned off.

local _G = _G
local ipairs, max, min, tinsert, unpack = ipairs, max, min, tinsert, unpack

local CreateFont = CreateFont
local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local PlaySound = PlaySound
local UIParent = UIParent

local ACCENT = I.Colors.Accent

local COLORS = {
	accent = { ACCENT.r, ACCENT.g, ACCENT.b },
	box = { 0.16, 0.16, 0.16, 1 },
	boxHover = { ACCENT.r * 0.3, ACCENT.g * 0.3, ACCENT.b * 0.3, 1 },
	boxPressed = { 0.12, 0.12, 0.12, 1 },
	border = { 1, 1, 1, 0.08 },
	muted = { 0.62, 0.62, 0.62 },
	trackSome = { ACCENT.r * 0.5, ACCENT.g * 0.5, ACCENT.b * 0.5, 1 },
	knob = { 0.92, 0.92, 0.92, 1 },
	knobDisabled = { 0.55, 0.55, 0.55, 1 },
	rowHover = { ACCENT.r, ACCENT.g, ACCENT.b, 0.12 },
}
module.colors = COLORS

local SOUND_CLICK = 852 -- SOUNDKIT.IG_MAINMENU_OPTION

local TRACK_WIDTH, TRACK_HEIGHT = 24, 12
local KNOB_SIZE, KNOB_INSET = 8, 2

-- Row columns: switch 5-29, lock 34-48, title from 54. Blizzard's title sits at 32.
local LOCK_OFFSET = 34
local TITLE_OFFSET = 54

local CATEGORY_FONT_SIZE = 14
local CATEGORY_TITLE_HEIGHT = 18
local BLIZZARD_TITLE_OFFSET = 32
local BLIZZARD_TITLE_WIDTH = 300
local STATUS_ROOM = 170 -- right part of a row, where Blizzard writes the status

local MIN_WIDTH, MIN_HEIGHT = 600, 450
local DEFAULT_WIDTH, DEFAULT_HEIGHT = 600, 550 -- AddonList.xml
local GRIP_SIZE = 16

local function IsStyled()
	return module.db.enable
end

--[[----------------------------------
--	Shared widgets
--]]
----------------------------------
---@param parent Frame
---@param size number
---@param color table?
---@param justify string?
---@return FontString
function module.CreateText(parent, size, color, justify)
	local text = parent:CreateFontString(nil, "OVERLAY")
	text:FontTemplate(nil, size)
	text:SetJustifyH(justify or "CENTER")
	if color then
		text:SetTextColor(unpack(color))
	end

	return text
end

-- Flat button like the installer and the compatibility check, the primary one
-- filled with the accent color. Own backdrop instead of SetTemplate: ElvUI's
-- template sweep would reset the hover colors.
local function FlatButton_UpdateVisual(button)
	local accent = COLORS.accent
	if button.disabled then
		button:SetBackdropColor(unpack(COLORS.boxPressed))
		button:SetBackdropBorderColor(unpack(COLORS.border))
		button.text:SetTextColor(0.5, 0.5, 0.5)
		return
	end

	button.text:SetTextColor(1, 1, 1)
	if button.primary then
		local mult = button.hover and 1 or 0.75
		button:SetBackdropColor(accent[1] * mult, accent[2] * mult, accent[3] * mult, 1)
		button:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1)
	elseif button.hover then
		button:SetBackdropColor(unpack(COLORS.boxHover))
		button:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1)
	else
		button:SetBackdropColor(unpack(COLORS.box))
		button:SetBackdropBorderColor(unpack(COLORS.border))
	end
end

local function FlatButton_OnEnter(button)
	button.hover = true
	FlatButton_UpdateVisual(button)

	if button.tooltip then
		_G.GameTooltip:SetOwner(button, "ANCHOR_TOP")
		_G.GameTooltip:SetText(button.tooltip, 1, 1, 1, 1, true)
		_G.GameTooltip:Show()
	end
end

local function FlatButton_OnLeave(button)
	button.hover = nil
	FlatButton_UpdateVisual(button)
	_G.GameTooltip:Hide()
end

local function FlatButton_OnClick(button, mouseButton)
	if button.disabled then
		return
	end

	PlaySound(SOUND_CLICK)
	button.onClick(button, mouseButton)
end

local function FlatButton_SetDisabled(button, disabled)
	button.disabled = disabled or nil
	FlatButton_UpdateVisual(button)
end

---@param parent Frame
---@param text string
---@param width number
---@param height number
---@param primary boolean?
---@param onClick function
---@return Button
function module.CreateFlatButton(parent, text, width, height, primary, onClick)
	local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
	button:SetBackdrop({ bgFile = E.media.blankTex, edgeFile = E.media.blankTex, edgeSize = E.mult })
	button:SetSize(width, height)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button.primary = primary
	button.onClick = onClick
	button.SetDisabled = FlatButton_SetDisabled
	button.UpdateVisual = FlatButton_UpdateVisual
	button:SetScript("OnEnter", FlatButton_OnEnter)
	button:SetScript("OnLeave", FlatButton_OnLeave)
	button:SetScript("OnClick", FlatButton_OnClick)

	button.text = module.CreateText(button, 12)
	button.text:SetPoint("CENTER")
	button.text:SetText(text)

	FlatButton_UpdateVisual(button)
	return button
end

-- Blizzard's own (ElvUI skinned) controls get the look of the flat buttons: an
-- own box replaces ElvUI's backdrop while styled (ElvUI's template sweep would
-- reset colors painted on its backdrop), buttons get white text.
local buttonFont

local function FlatBox_Update(frame)
	local box = frame.MERBox
	local accent = COLORS.accent
	local lit = frame.MERHover or frame.MERActive or (frame.HasFocus and frame:HasFocus())

	if frame.MERPrimary then
		local mult = lit and 1 or 0.75
		box:SetBackdropColor(accent[1] * mult, accent[2] * mult, accent[3] * mult, 1)
		box:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1)
	elseif frame.MERPressed then
		box:SetBackdropColor(unpack(COLORS.boxPressed))
		box:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1)
	elseif lit then
		box:SetBackdropColor(unpack(COLORS.boxHover))
		box:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1)
	else
		box:SetBackdropColor(unpack(COLORS.box))
		box:SetBackdropBorderColor(unpack(COLORS.border))
	end
end
module.UpdateFlatBox = function(frame)
	if frame.MERBox then
		FlatBox_Update(frame)
	end
end

local function FlatBox_OnEnter(frame)
	frame.MERHover = true
	FlatBox_Update(frame)
end

local function FlatBox_OnLeave(frame)
	frame.MERHover = nil
	frame.MERPressed = nil
	FlatBox_Update(frame)
end

local function FlatBox_OnMouseDown(frame)
	frame.MERPressed = true
	FlatBox_Update(frame)
end

local function FlatBox_OnMouseUp(frame)
	frame.MERPressed = nil
	FlatBox_Update(frame)
end

---@param frame Frame
---@param primary boolean? filled with the accent color
---@return Frame? box
local function AddFlatBox(frame, primary)
	local backdrop = frame.backdrop
	if not backdrop then
		return -- not skinned by ElvUI, Blizzard's art stays
	end

	-- Same level as ElvUI's backdrop, below the control's own text
	local box = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	box:SetAllPoints(backdrop)
	box:SetFrameLevel(backdrop:GetFrameLevel())
	box:SetBackdrop({ bgFile = E.media.blankTex, edgeFile = E.media.blankTex, edgeSize = E.mult })
	box.elvBackdrop = backdrop
	frame.MERBox = box
	frame.MERPrimary = primary

	frame:HookScript("OnEnter", FlatBox_OnEnter)
	frame:HookScript("OnLeave", FlatBox_OnLeave)
	if frame:IsObjectType("EditBox") then
		frame:HookScript("OnEditFocusGained", FlatBox_Update)
		frame:HookScript("OnEditFocusLost", FlatBox_Update)
	else
		frame:HookScript("OnMouseDown", FlatBox_OnMouseDown)
		frame:HookScript("OnMouseUp", FlatBox_OnMouseUp)
	end

	-- White text on buttons, Blizzard's disabled font stays
	if frame:IsObjectType("Button") and frame.GetFontString and frame:GetFontString() and frame.GetNormalFontObject then
		if not buttonFont then
			buttonFont = CreateFont("MER_AddonManagerButtonFont")
			buttonFont:SetFont(frame:GetFontString():GetFont())
			buttonFont:SetTextColor(1, 1, 1)
		end
		box.fonts = { frame:GetNormalFontObject(), frame:GetHighlightFontObject() }
	end

	FlatBox_Update(frame)
	return box
end

local function SetFlatBoxShown(frame, shown)
	local box = frame.MERBox
	box:SetShown(shown)
	box.elvBackdrop:SetAlpha(shown and 0 or 1)

	if box.fonts then
		frame:SetNormalFontObject(shown and buttonFont or box.fonts[1])
		frame:SetHighlightFontObject(shown and buttonFont or box.fonts[2])
	end
end

--[[----------------------------------
--	Toggle switch on a CheckButton
--]]
----------------------------------
-- Drawn as a child of the check button, so clicks still reach Blizzard's button.
-- Blizzard's and ElvUI's checkbox art only gets an alpha of 0 while it shows.
local function CreateSwitch(check)
	local switch = CreateFrame("Frame", nil, check)
	switch:SetSize(TRACK_WIDTH, TRACK_HEIGHT)
	switch:SetPoint("LEFT")
	switch:SetFrameLevel(check:GetFrameLevel() + 5)
	switch:CreateBackdrop("Transparent", nil, true)

	local knob = CreateFrame("Frame", nil, switch)
	knob:SetSize(KNOB_SIZE, KNOB_SIZE)
	knob:CreateBackdrop("Transparent", nil, true)
	switch.knob = knob

	-- Textures only, a label (Force Load) stays
	switch.hidden = {}
	for _, region in ipairs({ check:GetRegions() }) do
		if region:IsObjectType("Texture") then
			tinsert(switch.hidden, region)
		end
	end
	if check.backdrop then
		tinsert(switch.hidden, check.backdrop)
	end

	switch.width, switch.height = check:GetSize()
	switch.insets = { check:GetHitRectInsets() }

	check.MERSwitch = switch
	return switch
end

local function SetSwitchShown(check, shown)
	local switch = check.MERSwitch
	if not switch or switch:IsShown() == shown and switch.applied then
		return
	end

	switch.applied = true
	switch:SetShown(shown)
	for _, region in ipairs(switch.hidden) do
		region:SetAlpha(shown and 0 or 1)
	end

	if shown then
		check:SetSize(TRACK_WIDTH, TRACK_HEIGHT)
		check:SetHitRectInsets(0, 0, 0, 0)
	else
		check:SetSize(switch.width, switch.height)
		check:SetHitRectInsets(unpack(switch.insets))
	end
end

---@param check CheckButton
---@param on boolean
---@param partly boolean? on for some characters only
---@param disabled boolean?
local function PaintSwitch(check, on, partly, disabled)
	local switch = check.MERSwitch
	local accent = COLORS.accent

	if not on then
		switch.backdrop:SetBackdropColor(unpack(COLORS.box))
	elseif partly then
		switch.backdrop:SetBackdropColor(unpack(COLORS.trackSome))
	else
		switch.backdrop:SetBackdropColor(accent[1], accent[2], accent[3], 1)
	end

	local knob = switch.knob
	knob:ClearAllPoints()
	if on then
		knob:SetPoint("RIGHT", switch, "RIGHT", -KNOB_INSET, 0)
	else
		knob:SetPoint("LEFT", switch, "LEFT", KNOB_INSET, 0)
	end
	knob.backdrop:SetBackdropColor(unpack(disabled and COLORS.knobDisabled or COLORS.knob))
end

--[[----------------------------------
--	Rows
--]]
----------------------------------
local function UpdateRowHover(entry)
	local hover = entry.MERHover
	if hover then
		hover:SetShown(IsStyled() and entry:IsMouseOver())
	end
end
module.UpdateRowHover = UpdateRowHover

---Restyles an addon row, called after Blizzard (and ElvUI) set it up
---@param entry Button AddonListEntryTemplate
---@param locked boolean
function module:StyleEntry(entry, locked)
	local styled = IsStyled()
	local check = entry.Enabled

	if not check.MERSwitch then
		if not styled then
			return
		end

		CreateSwitch(check)

		local hover = entry:CreateTexture(nil, "BACKGROUND")
		hover:SetPoint("TOPLEFT", 0, 3)
		hover:SetPoint("BOTTOMRIGHT", 0, -3)
		hover:SetColorTexture(unpack(COLORS.rowHover))
		hover:Hide()
		entry.MERHover = hover

		-- Font after ElvUI's skin, rows are reused for parents and plain addons
		entry.MERTitleFont = { entry.Title:GetFont() }
		entry.MERTitleHeight = entry.Title:GetHeight()
	end

	SetSwitchShown(check, styled)

	local highlight = entry:GetHighlightTexture()
	if highlight then
		highlight:SetAlpha(styled and 0 or 1)
	end

	entry.Title:ClearAllPoints()
	if styled then
		local state = check.state or (check:GetChecked() and 2 or 0)
		PaintSwitch(check, state > 0, state == 1, locked)

		entry.Title:SetPoint("LEFT", TITLE_OFFSET, 0)
		entry.Title:SetWidth(max(BLIZZARD_TITLE_WIDTH, entry:GetWidth() - TITLE_OFFSET - STATUS_ROOM))
	else
		entry.Title:SetPoint("LEFT", BLIZZARD_TITLE_OFFSET, 0)
		entry.Title:SetWidth(BLIZZARD_TITLE_WIDTH)
	end

	-- The main addon of a group (its children are listed below it) gets the category size
	local node = entry.treeNode
	local isGroupParent = styled and node and node.nodes and #node.nodes > 0
	if isGroupParent then
		entry.Title:FontTemplate(nil, CATEGORY_FONT_SIZE)
		entry.Title:SetHeight(CATEGORY_TITLE_HEIGHT)
	else
		entry.Title:SetFont(unpack(entry.MERTitleFont))
		entry.Title:SetHeight(entry.MERTitleHeight)
	end

	UpdateRowHover(entry)
end

---@param button Button the row's lock
function module:PlaceLock(button)
	button:ClearAllPoints()
	button:SetPoint("LEFT", button:GetParent(), "LEFT", LOCK_OFFSET, 0)
end

-- Category rows look like the section headers of the options: white title, short accent line
function module:StyleCategory(row)
	local styled = IsStyled()

	if not row.MERUnderline then
		if not styled then
			return
		end

		local underline = row:CreateTexture(nil, "ARTWORK")
		underline:SetSize(24, 2)
		underline:SetPoint("TOPLEFT", row.Title, "BOTTOMLEFT", 0, 0)
		underline:SetColorTexture(unpack(COLORS.accent))
		row.MERUnderline = underline
		row.MERTitleColor = { row.Title:GetTextColor() }
		row.MERTitleFont = { row.Title:GetFont() }
		row.MERTitleHeight = row.Title:GetHeight()
	end

	row.MERUnderline:SetShown(styled)
	if styled then
		row.Title:SetTextColor(1, 1, 1)
		row.Title:FontTemplate(nil, CATEGORY_FONT_SIZE)
		row.Title:SetHeight(CATEGORY_TITLE_HEIGHT)
	else
		row.Title:SetTextColor(unpack(row.MERTitleColor))
		row.Title:SetFont(unpack(row.MERTitleFont))
		row.Title:SetHeight(row.MERTitleHeight)
	end

	local arrow = row.CollapseExpand
	if arrow and arrow.Normal then
		local accent = COLORS.accent
		arrow.Normal:SetVertexColor(styled and accent[1] or 1, styled and accent[2] or 1, styled and accent[3] or 1)
	end
end

--[[----------------------------------
--	Frame
--]]
----------------------------------
local function ApplySize(list)
	local db = module.db
	if IsStyled() and db.width and db.height then
		list:SetSize(db.width, db.height)
	else
		list:SetSize(DEFAULT_WIDTH, DEFAULT_HEIGHT)
	end
end

local function Grip_OnUpdate(grip)
	local list = _G.AddonList
	local scale = list:GetEffectiveScale()
	local x, y = GetCursorPosition()
	x, y = x / scale, y / scale

	local maxWidth = UIParent:GetWidth() * UIParent:GetEffectiveScale() / scale
	local maxHeight = UIParent:GetHeight() * UIParent:GetEffectiveScale() / scale

	local width = min(max(x + grip.offsetX - list:GetLeft(), MIN_WIDTH), maxWidth)
	local height = min(max(list:GetTop() - y + grip.offsetY, MIN_HEIGHT), maxHeight)
	list:SetSize(width, height)
end

-- Sized by hand instead of StartSizing, so the list doesn't become "user placed"
local function Grip_OnMouseDown(grip, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end

	local list = _G.AddonList
	local left, top = list:GetLeft(), list:GetTop()
	list:ClearAllPoints()
	list:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)

	-- Keeps the distance between cursor and corner, the corner doesn't jump to the cursor
	local scale = list:GetEffectiveScale()
	local x, y = GetCursorPosition()
	grip.offsetX = list:GetRight() - x / scale
	grip.offsetY = y / scale - list:GetBottom()

	grip:SetScript("OnUpdate", Grip_OnUpdate)
end

local function Grip_OnMouseUp(grip)
	if not grip:GetScript("OnUpdate") then
		return
	end

	grip:SetScript("OnUpdate", nil)

	local list = _G.AddonList
	module.db.width, module.db.height = list:GetSize()
	_G.AddonList_Update() -- rows pick up the new title width
end

local function Grip_OnDoubleClick()
	module.db.width, module.db.height = nil, nil
	ApplySize(_G.AddonList)
	_G.AddonList_Update()
end

local function CreateGrip(list)
	local grip = CreateFrame("Button", nil, list)
	grip:SetSize(GRIP_SIZE, GRIP_SIZE)
	grip:SetPoint("BOTTOMRIGHT", -2, 2)
	grip:SetFrameLevel(list:GetFrameLevel() + 20)
	grip:SetNormalTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Up]])
	grip:SetHighlightTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Highlight]])
	grip:SetPushedTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Down]])
	grip:GetNormalTexture():SetVertexColor(unpack(COLORS.accent))

	grip:SetScript("OnMouseDown", Grip_OnMouseDown)
	grip:SetScript("OnMouseUp", Grip_OnMouseUp)
	grip:SetScript("OnDoubleClick", Grip_OnDoubleClick)
	grip:SetScript("OnEnter", function()
		_G.GameTooltip:SetOwner(grip, "ANCHOR_RIGHT")
		_G.GameTooltip:AddLine(L["Drag to resize"])
		_G.GameTooltip:AddLine(L["Double-click to reset the size."], 1, 1, 1)
		_G.GameTooltip:Show()
	end)
	grip:SetScript("OnLeave", function()
		_G.GameTooltip:Hide()
	end)

	return grip
end

---One-time setup of the frame parts, UpdateStyle switches them on and off
---@param list Frame AddonList
function module:StyleList(list)
	local style = {}
	self.style = style

	-- Title in the accent color
	local titleText = list.TitleContainer and list.TitleContainer.TitleText
	if titleText then
		style.titleText = titleText
		style.titleColor = { titleText:GetTextColor() }
	end

	-- Performance block: accent header and a thin accent line instead of the divider
	local performance = list.Performance
	if performance then
		style.performanceHeader = performance.Header
		style.performanceHeaderColor = { performance.Header:GetTextColor() }

		local line = performance:CreateTexture(nil, "ARTWORK")
		line:SetHeight(1)
		line:SetPoint("LEFT", performance.Divider, "LEFT")
		line:SetPoint("RIGHT", performance.Divider, "RIGHT")
		line:SetPoint("BOTTOM", performance.Divider, "BOTTOM")
		local accent = COLORS.accent
		line:SetColorTexture(accent[1], accent[2], accent[3], 0.4)
		style.performanceLine = line
		style.performanceDivider = performance.Divider
	end

	-- Flat boxes on the controls ElvUI skinned, Okay / Reload UI is the primary one
	style.boxes = {}
	for _, control in ipairs({
		list.EnableAllButton,
		list.DisableAllButton,
		self.profileButton,
		list.OkayButton,
		list.CancelButton,
		list.SearchBox,
		list.Dropdown,
	}) do
		if AddFlatBox(control, control == list.OkayButton) then
			tinsert(style.boxes, control)
		end
	end

	-- "Force load out of date addons" becomes a switch too
	if list.ForceLoad then
		local function PaintForceLoad(check)
			if IsStyled() then
				PaintSwitch(check, check:GetChecked())
			end
		end

		CreateSwitch(list.ForceLoad)
		list.ForceLoad:HookScript("OnClick", PaintForceLoad)
		list.ForceLoad:HookScript("OnShow", PaintForceLoad)
	end

	-- Room for the grip in the corner
	style.cancelPoint = { list.CancelButton:GetPoint(1) }
	style.grip = CreateGrip(list)

	list:HookScript("OnShow", ApplySize)
end

---Shows or hides everything StyleList added, rows follow on the next list update
function module:UpdateStyle()
	local style = self.style
	local list = _G.AddonList
	if not style or not list then
		return
	end

	local styled = IsStyled()
	local accent = COLORS.accent

	if style.titleText then
		if styled then
			style.titleText:SetTextColor(unpack(accent))
		else
			style.titleText:SetTextColor(unpack(style.titleColor))
		end
	end

	if style.performanceLine then
		style.performanceLine:SetShown(styled)
		style.performanceDivider:SetAlpha(styled and 0 or 1)
		if styled then
			style.performanceHeader:SetTextColor(unpack(accent))
		else
			style.performanceHeader:SetTextColor(unpack(style.performanceHeaderColor))
		end
	end

	for _, control in ipairs(style.boxes) do
		SetFlatBoxShown(control, styled)
	end

	if list.ForceLoad then
		SetSwitchShown(list.ForceLoad, styled)
		if styled then
			PaintSwitch(list.ForceLoad, list.ForceLoad:GetChecked())
		end
	end

	local point, relativeTo, relativePoint, x, y = unpack(style.cancelPoint)
	list.CancelButton:ClearAllPoints()
	list.CancelButton:SetPoint(point, relativeTo, relativePoint, styled and x - GRIP_SIZE - 2 or x, y)

	style.grip:SetShown(styled)
	if list:IsShown() then
		ApplySize(list)
	end
end
