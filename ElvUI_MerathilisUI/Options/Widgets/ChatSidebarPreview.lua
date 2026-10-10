local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local gmatch = gmatch
local max, min = math.max, math.min
local tinsert = tinsert
local CreateFrame = CreateFrame

-- A sample chat panel with the Chat Sidebar. Used as `dialogControl` on a
-- description named "sidebar". Side, inside/outside, distance, divider, width,
-- icon size, spacing, counters, colors and the button order follow
-- Modules/Chat/Sidebar.lua; the first icon shows the hover color. With
-- Mouseover visibility the icons fade in while the mouse is over the preview.

local PANEL_MAX_WIDTH, PANEL_MAX_HEIGHT = 320, 180
local PADDING = 8
local EDGE_INSET = 2
local CHAT_INSET = 5
local DIVIDER_ALPHA = 0.8
local FADE_SPEED = 5

-- Same order as the module's BUTTONS; scroll stays pinned to the bottom
local BUTTON_KEYS = { "friends", "guild", "durability", "copy", "portals", "voice", "settings" }
local KNOWN_KEYS = {}
for _, key in ipairs(BUTTON_KEYS) do
	KNOWN_KEYS[key] = true
end
local COUNTERS = { friends = "12", guild = "34", durability = "87%" }

local SAMPLE_LINES = {
	"|cff40ff40[" .. _G.GUILD .. "]|r |cffabd473Hunter|r: o/",
	"|cffaaaaff[" .. _G.PARTY .. "]|r |cfff58cbaPaladin|r: ready",
	"|cff40ff40[" .. _G.GUILD .. "]|r |cff69ccf0Mage|r: portals up",
	"|cffaaaaff[" .. _G.PARTY .. "]|r |cffc79c6eWarrior|r: pull in 5",
}

-- Configured order first, then the buttons it does not name, like GetButtonOrder
local function GetButtonOrder(db)
	local order, seen = {}, {}
	for key in gmatch(db.order or "", "[^,]+") do
		if KNOWN_KEYS[key] and not seen[key] then
			seen[key] = true
			tinsert(order, key)
		end
	end

	for _, key in ipairs(BUTTON_KEYS) do
		if not seen[key] then
			tinsert(order, key)
		end
	end

	return order
end

local function GetHoverColor(db)
	if db.hoverClassColor then
		local color = E.myClassColor
		return color.r, color.g, color.b
	end

	return db.hoverColor.r, db.hoverColor.g, db.hoverColor.b
end

local function OnUpdate(frame, elapsed)
	local widget = frame.obj
	local holder = widget.bar.holder
	local target = 1
	if E.db.mui.chat.sidebar.visibility == "MOUSEOVER" then
		target = frame:IsMouseOver() and 1 or 0
	end

	local alpha = holder:GetAlpha()
	if alpha ~= target then
		local step = elapsed * FADE_SPEED
		alpha = target > alpha and min(target, alpha + step) or max(target, alpha - step)
		holder:SetAlpha(alpha)
	end
end

local function CreateButton(parent, key)
	local button = CreateFrame("Frame", nil, parent)
	button.key = key
	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetAllPoints()
	button.icon:SetTexture(I.Media.Icons.Chat[key])

	if COUNTERS[key] then
		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:FontTemplate()
		button.text:SetPoint("TOP", button, "BOTTOM", 0, 0)
		button.text:SetText(COUNTERS[key])
	end

	return button
end

local function Build(widget)
	local frame = widget.frame
	frame.obj = widget

	local panel = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	panel:SetTemplate("Transparent")
	widget.panel = panel

	widget.lines = {}
	for index, line in ipairs(SAMPLE_LINES) do
		local text = panel:CreateFontString(nil, "OVERLAY")
		text:FontTemplate()
		text:SetJustifyH("LEFT")
		text:SetWordWrap(false)
		text:SetText(line)
		widget.lines[index] = text
	end

	local bar = CreateFrame("Frame", nil, frame)
	bar:SetFrameLevel(panel:GetFrameLevel() + 5)
	bar:CreateBackdrop("Transparent")
	widget.bar = bar

	bar.holder = CreateFrame("Frame", nil, bar)
	bar.holder:SetAllPoints()

	bar.dividerTop = bar:CreateTexture(nil, "OVERLAY")
	bar.dividerTop:SetTexture(E.media.blankTex)
	bar.dividerBottom = bar:CreateTexture(nil, "OVERLAY")
	bar.dividerBottom:SetTexture(E.media.blankTex)

	widget.buttons = {}
	for _, key in ipairs(BUTTON_KEYS) do
		widget.buttons[key] = CreateButton(bar.holder, key)
	end
	widget.buttons.scroll = CreateButton(bar.holder, "scroll")

	frame:SetScript("OnUpdate", OnUpdate)
end

-- Class gradient fading out towards both ends, like UpdateDivider
local function UpdateDivider(bar, db, isLeft)
	local edge = isLeft and "RIGHT" or "LEFT"
	local top, bottom = bar.dividerTop, bar.dividerBottom
	local colorMap = E.db.mui.themes.gradientMode.classColorMap
	local normal = colorMap[I.Enum.GradientMode.Color.NORMAL][E.myclass]
	local shift = colorMap[I.Enum.GradientMode.Color.SHIFT][E.myclass]

	top:ClearAllPoints()
	top:SetWidth(E.mult)
	top:SetPoint("TOP" .. edge)
	top:SetPoint("BOTTOM" .. edge, bar, edge)

	bottom:ClearAllPoints()
	bottom:SetWidth(E.mult)
	bottom:SetPoint("BOTTOM" .. edge)
	bottom:SetPoint("TOP" .. edge, bar, edge)

	F.Color.SetGradientRGB(top, "VERTICAL", shift.r, shift.g, shift.b, DIVIDER_ALPHA, normal.r, normal.g, normal.b, 0)
	F.Color.SetGradientRGB(
		bottom,
		"VERTICAL",
		normal.r,
		normal.g,
		normal.b,
		0,
		shift.r,
		shift.g,
		shift.b,
		DIVIDER_ALPHA
	)

	local shown = db.divider and db.attach ~= "OUTSIDE"
	top:SetShown(shown)
	bottom:SetShown(shown)
end

local function ColorButton(button, db, hovered)
	if hovered then
		local r, g, b = GetHoverColor(db)
		button.icon:SetVertexColor(r, g, b, 1)
	else
		button.icon:SetVertexColor(db.iconColor.r, db.iconColor.g, db.iconColor.b, db.iconAlpha)
	end
end

-- Stack from the top, scroll pinned to the bottom, whatever does not fit is left out
local function LayoutButtons(widget, db, panelHeight)
	local bar = widget.bar
	local size, spacing = db.iconSize, db.spacing
	local counterHeight = db.counterFontSize
	local available = panelHeight - EDGE_INSET * 2 - spacing * 2
	if db.buttons.scroll then
		available = available - size - spacing
	end

	local used, prev, first = 0, nil, nil
	for _, key in ipairs(GetButtonOrder(db)) do
		local button = widget.buttons[key]
		button:ClearAllPoints()
		button:SetSize(size, size)
		if button.text then
			button.text:FontTemplate(nil, db.counterFontSize, "SHADOWOUTLINE")
		end

		local show = db.buttons[key]
		if show then
			local height = size + (button.text and counterHeight or 0)
			if used + height > available then
				show = false
			else
				if prev then
					button:SetPoint("TOP", prev, "BOTTOM", 0, -(spacing + (prev.text and counterHeight or 0)))
				else
					button:SetPoint("TOP", bar, "TOP", 0, -spacing)
				end
				used = used + height + spacing
				prev = button
				first = first or button
			end
		end

		button:SetShown(show)
	end

	local scroll = widget.buttons.scroll
	scroll:ClearAllPoints()
	scroll:SetSize(size, size)
	scroll:SetPoint("BOTTOM", bar, "BOTTOM", 0, spacing)
	scroll:SetShown(db.buttons.scroll)

	for _, button in pairs(widget.buttons) do
		ColorButton(button, db, button == first)
	end
end

local function Update(widget)
	local db = E.db.mui.chat.sidebar
	local chatDB = E.db.chat
	local isRight = db.panel == "RIGHT"
	local panelWidth = isRight and chatDB.separateSizes and chatDB.panelWidthRight or chatDB.panelWidth
	local panelHeight = isRight and chatDB.separateSizes and chatDB.panelHeightRight or chatDB.panelHeight
	panelWidth = min(panelWidth, PANEL_MAX_WIDTH)
	panelHeight = min(panelHeight, PANEL_MAX_HEIGHT)

	local inside = db.attach ~= "OUTSIDE"
	local isLeft = db.side ~= "RIGHT"
	widget.frame:SetHeight(panelHeight + PADDING * 2)

	-- Outside the sidebar sits next to the panel, the pair stays centered
	local panel = widget.panel
	panel:SetSize(panelWidth, panelHeight)
	panel:ClearAllPoints()
	local shift = inside and 0 or (db.width + db.attachSpacing) / 2 * (isLeft and 1 or -1)
	panel:SetPoint("CENTER", widget.frame, "CENTER", shift, 0)

	local bar = widget.bar
	bar:ClearAllPoints()
	if inside then
		local x = isLeft and EDGE_INSET or -EDGE_INSET
		local side = isLeft and "LEFT" or "RIGHT"
		bar:SetPoint("TOP" .. side, panel, "TOP" .. side, x, -EDGE_INSET)
		bar:SetPoint("BOTTOM" .. side, panel, "BOTTOM" .. side, x, EDGE_INSET)
	elseif isLeft then
		bar:SetPoint("TOPRIGHT", panel, "TOPLEFT", -db.attachSpacing, 0)
		bar:SetPoint("BOTTOMRIGHT", panel, "BOTTOMLEFT", -db.attachSpacing, 0)
	else
		bar:SetPoint("TOPLEFT", panel, "TOPRIGHT", db.attachSpacing, 0)
		bar:SetPoint("BOTTOMLEFT", panel, "BOTTOMRIGHT", db.attachSpacing, 0)
	end
	bar:SetWidth(db.width)
	bar.backdrop:SetShown(not inside)

	UpdateDivider(bar, db, isLeft)
	LayoutButtons(widget, db, panelHeight)

	-- Inside, the chat text makes room for the sidebar
	local textLeft, textRight = CHAT_INSET, CHAT_INSET
	if inside then
		if isLeft then
			textLeft = textLeft + db.width
		else
			textRight = textRight + db.width
		end
	end

	local font = E.LSM:Fetch("font", chatDB.font)
	local fontSize = min(chatDB.fontSize or 12, 14)
	for index, line in ipairs(widget.lines) do
		line:FontTemplate(font, fontSize, chatDB.fontOutline)
		line:ClearAllPoints()
		line:SetPoint(
			"BOTTOMLEFT",
			panel,
			"BOTTOMLEFT",
			textLeft,
			CHAT_INSET + (#widget.lines - index) * (fontSize + 4)
		)
		line:SetPoint("RIGHT", panel, "RIGHT", -textRight, 0)
	end

	bar.holder:SetAlpha(db.visibility == "MOUSEOVER" and 0 or 1)
	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERChatSidebarPreview", 1, PANEL_MAX_HEIGHT, Build, Update)
