local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERColorPicker"
local Version = 1

local floor = math.floor
local unpack, pairs = unpack, pairs
local CreateFrame, UIParent = CreateFrame, UIParent

-- Same box thickness/offset as MERSlider/MERDropdown/MEREditBox (18px from the
-- frame's top, 16px tall, 40px total frame height) so a color option sitting
-- in the same AceConfig row as a range/select/input option lines up.
local BOX_HEIGHT = 16
local BOX_TOP_OFFSET = 18
local LABEL_HEIGHT = 16
local FRAME_HEIGHT = 40

-- Same size/inset as MERSlider's knob so the swatch reads as part of the same
-- control family instead of Blizzard's default color chip.
local SWATCH_SIZE = 12
local SWATCH_INSET = 2

local COLOR_BOX = { 0.16, 0.16, 0.16, 1 }
local COLOR_BOX_HOVER = { 0.22, 0.22, 0.22, 1 }

local COLOR_TEXT_NORMAL = { 1, 1, 1 }
local COLOR_TEXT_DISABLED = { 0.5, 0.5, 0.5 }

-- Unfortunately we have no way to realistically detect if a client uses inverted
-- alpha as no API will tell you. Wrath uses the old colorpicker, era uses the new
-- one, both are inverted. Mirrors the stock AceGUI ColorPicker widget.
local INVERTED_ALPHA = (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE)

local function FormatHex(self)
	local r = floor((self.r or 0) * 255 + 0.5)
	local g = floor((self.g or 0) * 255 + 0.5)
	local b = floor((self.b or 0) * 255 + 0.5)
	if self.hasAlpha then
		local a = floor((self.a or 1) * 255 + 0.5)
		return ("#%02X%02X%02X%02X"):format(r, g, b, a)
	end
	return ("#%02X%02X%02X"):format(r, g, b)
end

local function UpdateVisual(self)
	local box = self.box
	box.backdrop:SetBackdropColor(unpack(self.hover and not self.disabled and COLOR_BOX_HOVER or COLOR_BOX))

	self.swatch:SetVertexColor(self.r or 0, self.g or 0, self.b or 0, self.hasAlpha and (self.a or 1) or 1)
	self.swatch:SetAlpha(self.disabled and 0.5 or 1)
	self.checkers:SetShown(self.hasAlpha and true or false)

	self.valueText:SetText(FormatHex(self))
	self.valueText:SetTextColor(unpack(self.disabled and COLOR_TEXT_DISABLED or COLOR_TEXT_NORMAL))
	self.label:SetTextColor(unpack(self.disabled and COLOR_TEXT_DISABLED or COLOR_TEXT_NORMAL))
end

-- Mirrors ColorCallback from the stock AceGUI ColorPicker widget: the color
-- callback fires continuously while the picker is open (OnValueChanged), the
-- alpha callback is always the final call after it closes, whether by
-- confirming or cancelling, so that one commits (OnValueConfirmed).
local function ColorCallback(self, r, g, b, a, isAlpha)
	if INVERTED_ALPHA and a then
		a = 1 - a
	end
	if not self.hasAlpha then
		a = 1
	end
	if r == self.r and g == self.g and b == self.b and a == self.a then
		return
	end

	self:SetColor(r, g, b, a)
	if ColorPickerFrame:IsVisible() then
		self:Fire("OnValueChanged", r, g, b, a)
	elseif isAlpha then
		self:Fire("OnValueConfirmed", r, g, b, a)
	end
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
	UpdateVisual(self)
	self:Fire("OnLeave")
end

local function Box_OnClick(frame)
	local self = frame.obj
	if self.disabled then
		return
	end

	ColorPickerFrame:Hide()
	ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG")
	ColorPickerFrame:SetFrameLevel(frame:GetFrameLevel() + 10)
	ColorPickerFrame:SetClampedToScreen(true)

	if ColorPickerFrame.SetupColorPickerAndShow then -- 10.2.5 color picker overhaul
		local r2, g2, b2, a2 = self.r, self.g, self.b, (self.a or 1)
		if INVERTED_ALPHA then
			a2 = 1 - a2
		end

		ColorPickerFrame:SetupColorPickerAndShow({
			swatchFunc = function()
				local r, g, b = ColorPickerFrame:GetColorRGB()
				local a = ColorPickerFrame:GetColorAlpha()
				ColorCallback(self, r, g, b, a)
			end,

			hasOpacity = self.hasAlpha,
			opacityFunc = function()
				local r, g, b = ColorPickerFrame:GetColorRGB()
				local a = ColorPickerFrame:GetColorAlpha()
				ColorCallback(self, r, g, b, a, true)
			end,
			opacity = a2,

			cancelFunc = function()
				ColorCallback(self, r2, g2, b2, a2, true)
			end,

			r = r2,
			g = g2,
			b = b2,
		})
	else
		ColorPickerFrame.func = function()
			local r, g, b = ColorPickerFrame:GetColorRGB()
			local a = OpacitySliderFrame:GetValue()
			ColorCallback(self, r, g, b, a)
		end

		ColorPickerFrame.hasOpacity = self.hasAlpha
		ColorPickerFrame.opacityFunc = function()
			local r, g, b = ColorPickerFrame:GetColorRGB()
			local a = OpacitySliderFrame:GetValue()
			ColorCallback(self, r, g, b, a, true)
		end

		local r, g, b, a = self.r, self.g, self.b, 1 - (self.a or 1)
		if self.hasAlpha then
			ColorPickerFrame.opacity = a
		end
		ColorPickerFrame:SetColorRGB(r, g, b)

		ColorPickerFrame.cancelFunc = function()
			ColorCallback(self, r, g, b, a, true)
		end

		ColorPickerFrame:Show()
	end

	AceGUI:ClearFocus()
end

local methods = {
	["OnAcquire"] = function(self)
		self:SetWidth(200)
		self:SetHeight(FRAME_HEIGHT)
		self:SetHasAlpha(false)
		self:SetColor(0, 0, 0, 1)
		self:SetDisabled(false)
		self:SetLabel("")
	end,

	["SetLabel"] = function(self, text)
		self.label:SetText(text or "")
	end,

	["SetColor"] = function(self, r, g, b, a)
		self.r = r or 0
		self.g = g or 0
		self.b = b or 0
		self.a = a or 1
		UpdateVisual(self)
	end,

	["SetHasAlpha"] = function(self, hasAlpha)
		self.hasAlpha = hasAlpha
		UpdateVisual(self)
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		self.box:EnableMouse(not disabled)
		UpdateVisual(self)
	end,
}

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	label:SetHeight(LABEL_HEIGHT)
	label:SetJustifyH("LEFT")
	label:SetWordWrap(false)
	label:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	label:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)

	local box = CreateFrame("Button", nil, frame)
	box:SetHeight(BOX_HEIGHT)
	box:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -BOX_TOP_OFFSET)
	box:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -BOX_TOP_OFFSET)
	-- ignoreUpdates=true keeps this out of E.frames, otherwise ElvUI's async
	-- E:UpdateFrameTemplates() coroutine (triggered by any "requires reload" option,
	-- e.g. Style's ForceRefresh) re-templates it a few frames later and wipes the
	-- colors UpdateVisual() just set, leaving the box blank until something happens
	-- to call SetDisabled again.
	box:CreateBackdrop("Transparent", nil, true)

	local checkers = box:CreateTexture(nil, "BACKGROUND")
	checkers:SetSize(SWATCH_SIZE, SWATCH_SIZE)
	checkers:SetPoint("LEFT", box, "LEFT", SWATCH_INSET, 0)
	checkers:SetTexture(188523) -- Tileset\Generic\Checkers
	checkers:SetTexCoord(0.25, 0, 0.5, 0.25)
	checkers:SetDesaturated(true)
	checkers:SetVertexColor(1, 1, 1, 0.75)
	checkers:Hide()

	local swatch = box:CreateTexture(nil, "ARTWORK")
	swatch:SetSize(SWATCH_SIZE, SWATCH_SIZE)
	swatch:SetPoint("LEFT", box, "LEFT", SWATCH_INSET, 0)
	swatch:SetColorTexture(1, 1, 1, 1)

	local valueText = box:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	valueText:SetJustifyH("LEFT")
	valueText:SetWordWrap(false)
	valueText:SetPoint("LEFT", swatch, "RIGHT", 6, 0)
	valueText:SetPoint("RIGHT", box, "RIGHT", -4, 0)

	local widget = {
		frame = frame,
		label = label,
		box = box,
		checkers = checkers,
		swatch = swatch,
		valueText = valueText,
		type = Type,
		-- See MERSlider/MERDropdown/MEREditBox - matches their alignoffset
		-- (BOX_TOP_OFFSET + BOX_HEIGHT / 2) so a color option sitting next to a
		-- range/select/input option in the same row lines up.
		alignoffset = BOX_TOP_OFFSET + (BOX_HEIGHT / 2),
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	box.obj = widget

	box:EnableMouse(true)
	box:RegisterForClicks("LeftButtonUp")
	box:SetScript("OnClick", Box_OnClick)
	box:SetScript("OnEnter", Box_OnEnter)
	box:SetScript("OnLeave", Box_OnLeave)

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
