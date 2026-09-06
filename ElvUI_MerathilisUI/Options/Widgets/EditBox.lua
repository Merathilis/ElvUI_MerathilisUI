local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MEREditBox"
local Version = 1

local pairs, tostring, unpack = pairs, tostring, unpack
local CreateFrame, UIParent = CreateFrame, UIParent
local PlaySound = PlaySound

-- Same box thickness/offset as MERSlider/MERDropdown (18px from the frame's
-- top, 16px tall, 40px total frame height) so an input option sitting in the
-- same AceConfig row as a range/select option lines up without any Blizzard-
-- template offset math - all three widgets just agree on the same numbers.
local BOX_HEIGHT = 16
local BOX_TOP_OFFSET = 18
local LABEL_HEIGHT = 16
local FRAME_HEIGHT = 40
local TEXT_INSET = 6

local COLOR_BOX = { 0.16, 0.16, 0.16, 1 }
local COLOR_BOX_HOVER = { 0.22, 0.22, 0.22, 1 }

local COLOR_TEXT_NORMAL = { 1, 1, 1 }
local COLOR_TEXT_DISABLED = { 0.5, 0.5, 0.5 }

-- Focus reads as the same "lit up" state as hover (mirrors MERDropdown, which
-- has no separate "open" visual either) instead of a third color.
local function UpdateVisual(self)
	local highlighted = (self.hover or self.focused) and not self.disabled
	self.box.backdrop:SetBackdropColor(unpack(highlighted and COLOR_BOX_HOVER or COLOR_BOX))
	self.label:SetTextColor(unpack(self.disabled and COLOR_TEXT_DISABLED or COLOR_TEXT_NORMAL))
	self.editbox:SetTextColor(unpack(self.disabled and COLOR_TEXT_DISABLED or COLOR_TEXT_NORMAL))
end

local function Control_OnEnter(frame)
	local self = frame.obj
	self.hover = true
	UpdateVisual(self)
	self:Fire("OnEnter")
end

local function Control_OnLeave(frame)
	local self = frame.obj
	self.hover = nil
	UpdateVisual(self)
	self:Fire("OnLeave")
end

local function EditBox_OnEscapePressed(frame)
	frame:ClearFocus()
end

local function EditBox_OnEnterPressed(frame)
	local self = frame.obj
	local value = frame:GetText()
	local cancel = self:Fire("OnEnterPressed", value)
	if not cancel then
		PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
	end
end

local function EditBox_OnTextChanged(frame)
	local self = frame.obj
	local value = frame:GetText()
	if tostring(value) ~= tostring(self.lasttext) then
		self.lasttext = value
		self:Fire("OnTextChanged", value)
	end
end

local function EditBox_OnFocusGained(frame)
	local self = frame.obj
	self.focused = true
	UpdateVisual(self)
	AceGUI:SetFocus(self)
end

local function EditBox_OnFocusLost(frame)
	local self = frame.obj
	self.focused = nil
	UpdateVisual(self)
end

local methods = {
	["OnAcquire"] = function(self)
		self:SetWidth(200)
		self:SetHeight(FRAME_HEIGHT)
		self:SetDisabled(false)
		self:SetLabel("")
		self:SetText("")
		self:SetMaxLetters(0)
	end,

	["OnRelease"] = function(self)
		self:ClearFocus()
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		self.editbox:EnableMouse(not disabled)
		if disabled then
			self.editbox:ClearFocus()
		end
		UpdateVisual(self)
	end,

	["SetText"] = function(self, text)
		self.lasttext = text or ""
		self.editbox:SetText(text or "")
		self.editbox:SetCursorPosition(0)
	end,

	["GetText"] = function(self)
		return self.editbox:GetText()
	end,

	["SetLabel"] = function(self, text)
		self.label:SetText(text or "")
	end,

	["SetMaxLetters"] = function(self, num)
		self.editbox:SetMaxLetters(num or 0)
	end,

	["ClearFocus"] = function(self)
		self.editbox:ClearFocus()
	end,

	["SetFocus"] = function(self)
		self.editbox:SetFocus()
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

	local box = CreateFrame("Frame", nil, frame)
	box:SetHeight(BOX_HEIGHT)
	box:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -BOX_TOP_OFFSET)
	box:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -BOX_TOP_OFFSET)
	-- ignoreUpdates=true keeps this out of E.frames, otherwise ElvUI's async
	-- E:UpdateFrameTemplates() coroutine (triggered by any "requires reload" option,
	-- e.g. Style's ForceRefresh) re-templates it a few frames later and wipes the
	-- colors UpdateVisual() just set, leaving the box blank until something happens
	-- to call SetDisabled again.
	box:CreateBackdrop("Transparent", nil, true)

	local editbox = CreateFrame("EditBox", nil, box)
	editbox:SetAutoFocus(false)
	editbox:SetFontObject(GameFontHighlightSmall)
	editbox:SetJustifyH("LEFT")
	editbox:SetTextInsets(0, 0, 0, 0)
	editbox:SetMaxLetters(0)
	editbox:SetPoint("TOPLEFT", box, "TOPLEFT", TEXT_INSET, 0)
	editbox:SetPoint("BOTTOMRIGHT", box, "BOTTOMRIGHT", -TEXT_INSET, 0)
	editbox:SetScript("OnEnter", Control_OnEnter)
	editbox:SetScript("OnLeave", Control_OnLeave)
	editbox:SetScript("OnEscapePressed", EditBox_OnEscapePressed)
	editbox:SetScript("OnEnterPressed", EditBox_OnEnterPressed)
	editbox:SetScript("OnTextChanged", EditBox_OnTextChanged)
	editbox:SetScript("OnEditFocusGained", EditBox_OnFocusGained)
	editbox:SetScript("OnEditFocusLost", EditBox_OnFocusLost)

	local widget = {
		frame = frame,
		label = label,
		box = box,
		editbox = editbox,
		type = Type,
		-- See MERSlider/MERDropdown - matches their alignoffset (BOX_TOP_OFFSET +
		-- BOX_HEIGHT / 2) so an input sitting next to a range/select option in the
		-- same row lines up.
		alignoffset = BOX_TOP_OFFSET + (BOX_HEIGHT / 2),
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	editbox.obj = widget

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
