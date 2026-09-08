local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERButton"
local Version = 1

local pairs, unpack = pairs, unpack
local CreateFrame, UIParent = CreateFrame, UIParent
local PlaySound = PlaySound

-- Same box thickness/offset as MERSlider/MERDropdown/MEREditBox/MERColorPicker
-- (18px from the frame's top, 16px tall, 40px total frame height) so an
-- execute option sitting in the same AceConfig row as any of those lines up.
-- Unlike them, the button's own name is the box's content (there's no separate
-- label line above it), so the top offset just reads as breathing room above
-- a button that shares a row with a labeled control.
local BOX_HEIGHT = 16
local BOX_TOP_OFFSET = 18
local FRAME_HEIGHT = 40

local COLOR_BOX = { 0.16, 0.16, 0.16, 1 }
local COLOR_BOX_HOVER = { 0.22, 0.22, 0.22, 1 }
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
		self:SetHeight(FRAME_HEIGHT)
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
	box:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -BOX_TOP_OFFSET)
	box:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -BOX_TOP_OFFSET)
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
		-- See MERSlider/MERDropdown/MEREditBox/MERColorPicker - matches their
		-- alignoffset (BOX_TOP_OFFSET + BOX_HEIGHT / 2) so a button sitting next
		-- to any of those in the same row lines up.
		alignoffset = BOX_TOP_OFFSET + (BOX_HEIGHT / 2),
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
