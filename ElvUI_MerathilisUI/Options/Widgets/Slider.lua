local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERSlider"
local Version = 1

local floor, max = math.floor, math.max
local tonumber, pairs, unpack = tonumber, pairs, unpack
local CreateFrame, UIParent = CreateFrame, UIParent
local GetCursorPosition = GetCursorPosition
local IsMouseButtonDown = IsMouseButtonDown

-- Same colors as MERToggleSwitch so both controls read as one family, but a
-- thicker track/knob than the toggle's small checkbox-sized switch - the
-- slider stretches across the full column width, and at the toggle's 16px
-- thickness it reads as a squeezed sliver next to a dropdown in the same row.
local TRACK_HEIGHT = 16
local KNOB_SIZE = 12
local KNOB_INSET = 2
local LABEL_HEIGHT = 16
-- MERDropdown (Dropdown.lua) uses these same two numbers for its own box, so
-- a select option sitting in the same AceConfig row as a range option lines
-- up automatically - see its alignoffset for the row-alignment mechanism.
local TRACK_TOP_OFFSET = 18
local FRAME_HEIGHT = 40

local COLOR_TRACK_OFF = { 0.16, 0.16, 0.16, 1 }
local COLOR_TRACK_ON = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b, 1 }
local COLOR_KNOB = { 0.92, 0.92, 0.92, 1 }
local COLOR_KNOB_DISABLED = { 0.55, 0.55, 0.55, 1 }

local COLOR_TEXT_NORMAL = { 1, 1, 1 }
local COLOR_TEXT_DISABLED = { 0.5, 0.5, 0.5 }

-- The value is rendered inline as part of the label string (see UpdateLabel)
-- instead of a separately-anchored FontString, so it always travels glued to
-- its own slider's name no matter how AceConfig sizes the surrounding column.
local VALUE_HEX = E:RGBToHex(I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b)
local VALUE_HEX_DISABLED = E:RGBToHex(unpack(COLOR_TEXT_DISABLED))

local function Clamp(value, lo, hi)
	if value < lo then
		return lo
	elseif value > hi then
		return hi
	end
	return value
end

local function Round(value, step, minValue)
	if step and step > 0 then
		return floor((value - minValue) / step + 0.5) * step + minValue
	end
	return value
end

local function FormatValue(self)
	local value = self.value or 0
	if self.ispercent then
		return ("%d%%"):format(floor(value * 100 + 0.5))
	end
	return tostring(floor(value * 100 + 0.5) / 100)
end

local function UpdateLabel(self)
	local hex = self.disabled and VALUE_HEX_DISABLED or VALUE_HEX
	self.label:SetFormattedText("%s  %s%s|r", self.labelName or "", hex, FormatValue(self))
end

-- Mirrors the on/off fill + knob styling from MERToggleSwitch so range options
-- read as the same control family instead of Blizzard's default slider bar.
local function UpdateVisual(self)
	local track = self.track
	local fill = self.fill
	local knob = self.knob

	local minValue, maxValue = self.min or 0, self.max or 100
	local range = maxValue - minValue
	local percent = range > 0 and Clamp(((self.value or minValue) - minValue) / range, 0, 1) or 0

	local trackWidth = track:GetWidth()
	if trackWidth and trackWidth > 0 then
		-- Knob travels between the same two insets MERToggleSwitch parks its
		-- knob at (KNOB_INSET from either edge), just continuously in between.
		local travel = max(trackWidth - KNOB_SIZE - (2 * KNOB_INSET), 0.0001)
		local knobLeft = KNOB_INSET + travel * percent

		knob:ClearAllPoints()
		knob:SetPoint("LEFT", track, "LEFT", knobLeft, 0)
		fill:SetWidth(max(knobLeft + KNOB_SIZE / 2 - KNOB_INSET, 0.0001))
	end

	track.backdrop:SetBackdropColor(unpack(COLOR_TRACK_OFF))
	fill:SetVertexColor(unpack(COLOR_TRACK_ON))
	knob.backdrop:SetBackdropColor(unpack(self.disabled and COLOR_KNOB_DISABLED or COLOR_KNOB))

	UpdateLabel(self)
end

local function CommitValue(self, value, fireChanged)
	local minValue, maxValue = self.min or 0, self.max or 100
	value = Clamp(value, minValue, maxValue)
	value = Clamp(Round(value, self.step, minValue), minValue, maxValue)

	local changed = value ~= self.value
	self.value = value
	UpdateVisual(self)

	if changed and fireChanged then
		self:Fire("OnValueChanged", value)
	end
end

local function ValueFromCursorX(self, cursorX)
	local track = self.track
	local left = track:GetLeft()
	local width = track:GetWidth()
	if not left or not width or width <= 0 then
		return self.value
	end

	local scale = track:GetEffectiveScale()
	local relativeX = cursorX / scale - left
	local travel = max(width - KNOB_SIZE - (2 * KNOB_INSET), 0.0001)
	local percent = Clamp((relativeX - KNOB_INSET - KNOB_SIZE / 2) / travel, 0, 1)

	local minValue, maxValue = self.min or 0, self.max or 100
	return minValue + percent * (maxValue - minValue)
end

local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
end

local function Track_OnSizeChanged(track)
	UpdateVisual(track.obj)
end

local function Track_OnUpdate(track)
	local self = track.obj
	if not IsMouseButtonDown("LeftButton") then
		track:SetScript("OnUpdate", nil)
		self:Fire("OnMouseUp", self.value)
		return
	end

	CommitValue(self, ValueFromCursorX(self, GetCursorPosition()), true)
end

local function Track_OnMouseDown(track, button)
	local self = track.obj
	if self.disabled or button ~= "LeftButton" then
		return
	end

	CommitValue(self, ValueFromCursorX(self, GetCursorPosition()), true)
	track:SetScript("OnUpdate", Track_OnUpdate)
end

local function Track_OnMouseWheel(track, delta)
	local self = track.obj
	if self.disabled then
		return
	end

	local minValue, maxValue = self.min or 0, self.max or 100
	local step = (self.step and self.step > 0) and self.step or (maxValue - minValue) / 100
	CommitValue(self, (self.value or minValue) + (delta > 0 and step or -step), true)
end

local methods = {
	["OnAcquire"] = function(self)
		self:SetLabel("")
		self:SetDisabled(false)
		self:SetIsPercent(nil)
		self:SetSliderValues(0, 100, 1)
		self:SetValue(0)
		self:SetWidth(200)
		self:SetHeight(FRAME_HEIGHT)
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		self.track:EnableMouse(not disabled)
		self.label:SetTextColor(unpack(disabled and COLOR_TEXT_DISABLED or COLOR_TEXT_NORMAL))
		UpdateVisual(self)
	end,

	["SetValue"] = function(self, value)
		local minValue = self.min or 0
		value = Clamp(Round(tonumber(value) or minValue, self.step, minValue), minValue, self.max or 100)
		self.value = value
		UpdateVisual(self)
	end,

	["GetValue"] = function(self)
		return self.value
	end,

	["SetLabel"] = function(self, text)
		self.labelName = text or ""
		UpdateLabel(self)
	end,

	["SetSliderValues"] = function(self, minValue, maxValue, step)
		self.min = minValue or 0
		self.max = maxValue or 100
		self.step = step
		self:SetValue(self.value or self.min)
	end,

	["SetIsPercent"] = function(self, flag)
		self.ispercent = flag
		UpdateLabel(self)
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

	local track = CreateFrame("Frame", nil, frame)
	track:SetHeight(TRACK_HEIGHT)
	track:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -TRACK_TOP_OFFSET)
	track:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -TRACK_TOP_OFFSET)
	-- ignoreUpdates=true keeps these out of E.frames, otherwise ElvUI's async
	-- E:UpdateFrameTemplates() coroutine (triggered by any "requires reload" option,
	-- e.g. Style's ForceRefresh) re-templates them a few frames later and wipes the
	-- fill/knob colors UpdateVisual() just set, leaving the slider blank until
	-- something happens to call SetValue/SetDisabled again.
	track:CreateBackdrop("Transparent", nil, true)

	-- Plain inset texture (no border of its own) so the fill reads as one
	-- continuous bar inside the track's border instead of a nested, seamed box.
	local fill = track:CreateTexture(nil, "ARTWORK")
	fill:SetColorTexture(1, 1, 1, 1)
	fill:SetWidth(0.0001)
	fill:SetPoint("TOPLEFT", track, "TOPLEFT", KNOB_INSET, -KNOB_INSET)
	fill:SetPoint("BOTTOMLEFT", track, "BOTTOMLEFT", KNOB_INSET, KNOB_INSET)

	local knob = CreateFrame("Frame", nil, track)
	knob:SetSize(KNOB_SIZE, KNOB_SIZE)
	knob:CreateBackdrop("Transparent", nil, true)

	local widget = {
		frame = frame,
		label = label,
		track = track,
		fill = fill,
		knob = knob,
		type = Type,
		-- AceGUI's Flow layout aligns same-row controls by this offset (distance
		-- from the frame's top to its visual center-line) instead of by frame
		-- top, falling back to frameheight/2 when unset - that fallback (20) is
		-- off from Dropdown-ElvUI's own alignoffset (26, the center of its box),
		-- which is what pushed the dropdown down relative to the slider. This
		-- is the center of our track (TRACK_TOP_OFFSET + TRACK_HEIGHT / 2 = 26),
		-- matching it exactly.
		alignoffset = TRACK_TOP_OFFSET + (TRACK_HEIGHT / 2),
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	track.obj = widget

	track:EnableMouse(true)
	track:EnableMouseWheel(true)
	track:SetScript("OnMouseDown", Track_OnMouseDown)
	track:SetScript("OnMouseWheel", Track_OnMouseWheel)
	track:SetScript("OnEnter", Control_OnEnter)
	track:SetScript("OnLeave", Control_OnLeave)
	track:SetScript("OnSizeChanged", Track_OnSizeChanged)

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
