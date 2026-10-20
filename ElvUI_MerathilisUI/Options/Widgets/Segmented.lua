local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- MERSegmented (dialogControl of a "select"): the values side by side as one
-- pill-shaped bar instead of a dropdown, for selects with two to four short
-- values. Use module.Segmented / module.ColorModeSelect (Options/Core.lua),
-- they also set the order (`sorting`) and the width.
--
-- `arg = { chips = { [value] = color }, pick = { ... } }` turns it into a color
-- mode picker: a chip in front of a value shows its color, `{ r, g, b }` or a
-- function returning r, g, b. `pick` is the value with an own color
-- (`pick = { value = "CUSTOM", get = function() return r, g, b, a, dr, dg, db, da end,
-- set = function(r, g, b, a) end, hasAlpha = false }`): its chip shows that color
-- and a click on it selects the value and opens the color picker for it.
local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERSegmented"
local Version = 1

local ipairs, pairs, sort, tostring, type, unpack, wipe = ipairs, pairs, sort, tostring, type, unpack, wipe
local CreateFrame, UIParent = CreateFrame, UIParent
local PlaySound = PlaySound

-- Same row geometry as MERDropdown: label on top, the bar centered where the
-- dropdown box is (18px + 16 / 2 from the top), 46px in total
local LABEL_HEIGHT = 16
local BAR_TOP_OFFSET = 17
local BAR_HEIGHT = 18
local FRAME_HEIGHT = 46
local INSET = 2
local CHIP_SIZE = 8
local TEXT_PADDING = 4

local COLOR_ACCENT = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }
local COLOR_BAR = { 0.16, 0.16, 0.16, 1 }
local COLOR_TEXT_NORMAL = { 1, 1, 1 }
local COLOR_TEXT_IDLE = { 0.7, 0.7, 0.7 }
local COLOR_TEXT_DISABLED = { 0.5, 0.5, 0.5 }

local function ResolveColor(color)
	if type(color) == "function" then
		return color()
	end
	if type(color) == "table" then
		return color[1], color[2], color[3]
	end
end

local function UpdateVisual(self)
	local disabled = self.disabled
	self.label:SetTextColor(unpack(disabled and COLOR_TEXT_DISABLED or COLOR_TEXT_NORMAL))
	self.bar:SetAlpha(disabled and 0.5 or 1)

	local chips, pick = self.chips, self.pick
	for _, segment in ipairs(self.segments) do
		if segment:IsShown() then
			local selected = segment.value == self.value
			if selected then
				segment.fill:SetColorTexture(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 0.85)
			elseif segment.hover and not disabled then
				segment.fill:SetColorTexture(1, 1, 1, 0.08)
			else
				segment.fill:SetColorTexture(0, 0, 0, 0)
			end
			segment.text:SetTextColor(unpack((selected or segment.hover) and COLOR_TEXT_NORMAL or COLOR_TEXT_IDLE))

			local r, g, b
			if pick and segment.value == pick.value then
				r, g, b = pick.get()
			elseif chips then
				r, g, b = ResolveColor(chips[segment.value])
			end
			segment.chip:SetShown(r and true or false)
			if r then
				segment.chip.tex:SetColorTexture(r, g, b, 1)
			end
			segment.text:ClearAllPoints()
			if r then
				segment.chip:SetPoint("RIGHT", segment.text, "LEFT", -TEXT_PADDING, 0)
				segment.text:SetPoint("CENTER", (CHIP_SIZE + TEXT_PADDING) / 2, 0)
			else
				segment.text:SetPoint("CENTER")
			end
		end
	end
end

local function Layout(self)
	local count = #self.order
	local width = (self.frame.width or self.frame:GetWidth() or 0) - INSET * 2
	if count == 0 or width <= 0 then
		return
	end

	local segmentWidth = width / count
	for i, segment in ipairs(self.segments) do
		if i <= count then
			segment:ClearAllPoints()
			segment:SetPoint("TOPLEFT", self.bar, "TOPLEFT", INSET + (i - 1) * segmentWidth, -INSET)
			segment:SetSize(segmentWidth, BAR_HEIGHT - INSET * 2)
			segment.text:SetWidth(segmentWidth - TEXT_PADDING * 2 - (segment.chip:IsShown() and CHIP_SIZE or 0))
			segment.divider:SetShown(i > 1)
		end
	end
end

local function Segment_OnEnter(segment)
	local self = segment.obj
	segment.hover = true
	UpdateVisual(self)
	self:Fire("OnEnter")
end

local function Segment_OnLeave(segment)
	local self = segment.obj
	segment.hover = nil
	UpdateVisual(self)
	self:Fire("OnLeave")
end

local function OpenPicker(self, segment)
	local pick = self.pick
	local r, g, b, a, dr, dg, db, da = pick.get()
	-- The pick table is the owner, not this widget: selecting the value below
	-- rebuilds the page and releases the widget while the picker stays open
	module.ColorPickerPopup.Open(pick, {
		r = r,
		g = g,
		b = b,
		a = a,
		hasAlpha = pick.hasAlpha,
		default = dr and { dr, dg, db, da or 1 } or nil,
		onChange = pick.set,
		onConfirm = function(...)
			pick.set(...)
			E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
		end,
	}, segment)
end

local function Segment_OnClick(segment)
	local self = segment.obj
	if self.disabled then
		return
	end

	AceGUI:ClearFocus()
	local value = segment.value
	local pick = self.pick
	if pick and value == pick.value then
		OpenPicker(self, segment)
	end
	if value ~= self.value then
		PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
		self.value = value
		UpdateVisual(self)
		self:Fire("OnValueChanged", value)
	end
end

local function CreateSegment(self)
	local segment = CreateFrame("Button", nil, self.bar)
	segment.obj = self

	segment.fill = segment:CreateTexture(nil, "BACKGROUND")
	segment.fill:SetAllPoints()

	segment.divider = segment:CreateTexture(nil, "BORDER")
	segment.divider:SetWidth(1)
	segment.divider:SetPoint("TOPLEFT", 0, -2)
	segment.divider:SetPoint("BOTTOMLEFT", 0, 2)
	segment.divider:SetColorTexture(1, 1, 1, 0.08)

	segment.chip = CreateFrame("Frame", nil, segment)
	segment.chip:SetSize(CHIP_SIZE, CHIP_SIZE)
	segment.chip:CreateBackdrop(nil, nil, true)
	segment.chip.tex = segment.chip:CreateTexture(nil, "ARTWORK")
	segment.chip.tex:SetAllPoints()

	segment.text = segment:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	segment.text:SetWordWrap(false)

	segment:RegisterForClicks("LeftButtonUp")
	segment:SetScript("OnEnter", Segment_OnEnter)
	segment:SetScript("OnLeave", Segment_OnLeave)
	segment:SetScript("OnClick", Segment_OnClick)
	return segment
end

local function SortByKey(a, b)
	return tostring(a) < tostring(b)
end

local methods = {
	["OnAcquire"] = function(self)
		self:SetWidth(200)
		self:SetHeight(FRAME_HEIGHT)
		self.value = nil
		self.chips = nil
		self.pick = nil
		self:SetLabel("")
		self:SetList({})
		self:SetDisabled(false)
	end,

	["OnWidthSet"] = function(self)
		Layout(self)
	end,

	["SetLabel"] = function(self, text)
		self.label:SetText(text or "")
	end,

	["SetList"] = function(self, values, sorting)
		local order = self.order
		wipe(order)
		if type(sorting) == "table" then
			for _, value in ipairs(sorting) do
				order[#order + 1] = value
			end
		elseif type(values) == "table" then
			for value in pairs(values) do
				order[#order + 1] = value
			end
			sort(order, SortByKey)
		end

		for i, value in ipairs(order) do
			local segment = self.segments[i] or CreateSegment(self)
			self.segments[i] = segment
			segment.value = value
			segment.hover = nil
			segment.text:SetText(values[value] or tostring(value))
			segment:Show()
		end
		for i = #order + 1, #self.segments do
			self.segments[i]:Hide()
		end

		Layout(self)
		UpdateVisual(self)
	end,

	["SetValue"] = function(self, value)
		self.value = value
		UpdateVisual(self)
	end,

	["GetValue"] = function(self)
		return self.value
	end,

	-- AceConfigDialog's select API, nothing to do for a bar
	["SetMultiselect"] = function() end,
	["SetItemValue"] = function() end,
	["SetItemDisabled"] = function() end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		for _, segment in ipairs(self.segments) do
			segment:EnableMouse(not disabled)
			if disabled then
				segment.hover = nil
			end
		end
		UpdateVisual(self)
	end,

	["SetCustomData"] = function(self, data)
		if type(data) ~= "table" then
			return
		end

		self.chips = data.chips
		self.pick = data.pick
		UpdateVisual(self)
		Layout(self)
	end,
}

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	label:SetHeight(LABEL_HEIGHT)
	label:SetJustifyH("LEFT")
	label:SetWordWrap(false)
	label:SetPoint("TOPLEFT")
	label:SetPoint("TOPRIGHT")

	local bar = CreateFrame("Frame", nil, frame)
	bar:SetHeight(BAR_HEIGHT)
	bar:SetPoint("TOPLEFT", 0, -BAR_TOP_OFFSET)
	bar:SetPoint("TOPRIGHT", 0, -BAR_TOP_OFFSET)
	-- ignoreUpdates=true keeps it out of E.frames, see Button.lua
	bar:CreateBackdrop("Transparent", nil, true)
	bar.backdrop:SetBackdropColor(unpack(COLOR_BAR))

	local widget = {
		frame = frame,
		label = label,
		bar = bar,
		segments = {},
		order = {},
		type = Type,
		-- Same as MERDropdown, so a bar next to a dropdown or slider lines up
		alignoffset = BAR_TOP_OFFSET + (BAR_HEIGHT / 2),
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
