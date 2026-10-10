local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERButton"
local Version = 2

local pairs, type, unpack = pairs, type, unpack
local CreateFrame, UIParent = CreateFrame, UIParent
local PlaySound = PlaySound

-- The button's name is the box's content (no label line above it like
-- MERSlider/MERDropdown/MEREditBox/MERColorPicker have), so the frame only
-- pads the box evenly instead of reserving their 18px label offset. AceGUI's
-- Flow layout lines up every widget in a row on its alignoffset and takes the
-- tallest one as row height, so next to a labeled control the button still
-- centers on that control's box, while a row of buttons only stays compact.
local BOX_HEIGHT = 22
local BOX_PADDING = 4

-- Standalone variant via the option's `arg` (AceConfigDialog hands it over
-- through SetCustomData after SetText): `arg = { boxWidth = 300, large = true }`
-- centers a box of that width in the row (give the option `width = "full"`),
-- `large` makes it taller with a bigger font.
local LARGE_BOX_HEIGHT = 30

local COLOR_BOX = { 0.16, 0.16, 0.16, 1 }
-- Muted Accent tint instead of a flat gray, so hover reads as the same
-- bläulich highlight as the TabGroup's selected-tab color/underline.
local COLOR_BOX_HOVER = { I.Colors.Accent.r * 0.3, I.Colors.Accent.g * 0.3, I.Colors.Accent.b * 0.3, 1 }
local COLOR_BOX_PRESSED = { 0.12, 0.12, 0.12, 1 }

local COLOR_TEXT_NORMAL = { 1, 1, 1 }
local COLOR_TEXT_DISABLED = { 0.5, 0.5, 0.5 }

local function UpdateVisual(self)
	local color = COLOR_BOX
	if not self.disabled then
		if self.pressed then
			color = COLOR_BOX_PRESSED
		elseif self.hover then
			color = COLOR_BOX_HOVER
		end
	end

	self.box.backdrop:SetBackdropColor(unpack(color))
	self.text:SetTextColor(unpack(self.disabled and COLOR_TEXT_DISABLED or COLOR_TEXT_NORMAL))
end

local function UpdateLayout(self)
	local box = self.box
	local boxWidth = self.boxWidth
	local boxHeight = self.large and LARGE_BOX_HEIGHT or BOX_HEIGHT

	box:ClearAllPoints()
	box:SetHeight(boxHeight)
	if boxWidth then
		box:SetWidth(boxWidth)
		box:SetPoint("TOP", self.frame, "TOP", 0, -BOX_PADDING)
	else
		box:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -BOX_PADDING)
		box:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", 0, -BOX_PADDING)
	end
	self:SetHeight(boxHeight + (BOX_PADDING * 2))

	self.text:SetFontObject(self.large and "GameFontHighlightMedium" or "GameFontHighlightSmall")
	self.alignoffset = BOX_PADDING + (boxHeight / 2)
end

local function Box_OnEnter(frame)
	local self = frame.obj
	self.hover = true
	UpdateVisual(self)
	self:Fire("OnEnter")
end

local function Box_OnLeave(frame)
	local self = frame.obj
	self.hover = nil
	self.pressed = nil
	UpdateVisual(self)
	self:Fire("OnLeave")
end

local function Box_OnMouseDown(frame)
	local self = frame.obj
	if self.disabled then
		return
	end
	self.pressed = true
	UpdateVisual(self)
end

local function Box_OnMouseUp(frame)
	local self = frame.obj
	self.pressed = nil
	UpdateVisual(self)
end

local function Box_OnClick(frame, ...)
	local self = frame.obj
	if self.disabled then
		return
	end

	AceGUI:ClearFocus()
	PlaySound(852) -- SOUNDKIT.IG_MAINMENU_OPTION
	self:Fire("OnClick", ...)
end

local methods = {
	["OnAcquire"] = function(self)
		self:SetWidth(200)
		self.boxWidth = nil
		self.large = nil
		UpdateLayout(self)
		self:SetDisabled(false)
		self:SetAutoWidth(false)
		self:SetText("")
	end,

	["SetText"] = function(self, text)
		self.text:SetText(text or "")
		if self.autoWidth then
			self:SetWidth(self.text:GetStringWidth() + 30)
		end
	end,

	["SetAutoWidth"] = function(self, autoWidth)
		self.autoWidth = autoWidth
		if self.autoWidth then
			self:SetWidth(self.text:GetStringWidth() + 30)
		end
	end,

	["SetCustomData"] = function(self, data)
		if type(data) ~= "table" then
			return
		end

		self.boxWidth = data.boxWidth
		self.large = data.large
		UpdateLayout(self)
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		self.box:EnableMouse(not disabled)
		if disabled then
			self.pressed = nil
			self.hover = nil
		end
		UpdateVisual(self)
	end,
}

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local box = CreateFrame("Button", nil, frame)
	box:SetHeight(BOX_HEIGHT)
	box:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -BOX_PADDING)
	box:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -BOX_PADDING)
	-- ignoreUpdates=true keeps this out of E.frames, otherwise ElvUI's async
	-- E:UpdateFrameTemplates() coroutine (triggered by any "requires reload" option,
	-- e.g. Style's ForceRefresh) re-templates it a few frames later and wipes the
	-- colors UpdateVisual() just set, leaving the box blank until something happens
	-- to call SetDisabled again.
	box:CreateBackdrop("Transparent", nil, true)

	local text = box:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	text:SetPoint("TOPLEFT", box, "TOPLEFT", 4, 0)
	text:SetPoint("BOTTOMRIGHT", box, "BOTTOMRIGHT", -4, 0)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetWordWrap(false)

	local widget = {
		frame = frame,
		box = box,
		text = text,
		type = Type,
		-- Box center, the Flow layout aligns it with the box center of
		-- MERSlider/MERDropdown/MEREditBox/MERColorPicker in the same row.
		alignoffset = BOX_PADDING + (BOX_HEIGHT / 2),
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	box.obj = widget

	box:EnableMouse(true)
	box:RegisterForClicks("LeftButtonUp", "LeftButtonDown")
	box:SetScript("OnClick", Box_OnClick)
	box:SetScript("OnMouseDown", Box_OnMouseDown)
	box:SetScript("OnMouseUp", Box_OnMouseUp)
	box:SetScript("OnEnter", Box_OnEnter)
	box:SetScript("OnLeave", Box_OnLeave)

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
