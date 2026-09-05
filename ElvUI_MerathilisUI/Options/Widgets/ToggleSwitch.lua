local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERToggleSwitch"
local Version = 1

local select, pairs = select, pairs
local PlaySound = PlaySound
local CreateFrame, UIParent = CreateFrame, UIParent

local TRACK_WIDTH, TRACK_HEIGHT = 34, 16
local KNOB_SIZE = 12
local KNOB_INSET = 2

local COLOR_TRACK_OFF = { 0.16, 0.16, 0.16, 1 }
local COLOR_TRACK_ON = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b, 1 }
local COLOR_KNOB = { 0.92, 0.92, 0.92, 1 }
local COLOR_KNOB_DISABLED = { 0.55, 0.55, 0.55, 1 }

local function AlignImage(self)
	local img = self.image:GetTexture()
	self.text:ClearAllPoints()
	if not img then
		self.text:SetPoint("LEFT", self.track, "RIGHT", 6, 0)
		self.text:SetPoint("RIGHT")
	else
		self.text:SetPoint("LEFT", self.image, "RIGHT", 1, 0)
		self.text:SetPoint("RIGHT")
	end
end

local function UpdateVisual(self)
	local track = self.track
	local knob = self.knob

	if self.checked then
		track.backdrop:SetBackdropColor(unpack(COLOR_TRACK_ON))
		knob:ClearAllPoints()
		knob:SetPoint("RIGHT", track, "RIGHT", -KNOB_INSET, 0)
	else
		track.backdrop:SetBackdropColor(unpack(COLOR_TRACK_OFF))
		knob:ClearAllPoints()
		knob:SetPoint("LEFT", track, "LEFT", KNOB_INSET, 0)
	end

	knob.backdrop:SetBackdropColor(unpack(self.disabled and COLOR_KNOB_DISABLED or COLOR_KNOB))
end

local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
end

local function ToggleSwitch_OnMouseUp(frame)
	local self = frame.obj
	if not self.disabled then
		self:ToggleChecked()

		if self.checked then
			PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
		else
			PlaySound(857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
		end

		self:Fire("OnValueChanged", self.checked)
		AlignImage(self)
	end
end

local methods = {
	["OnAcquire"] = function(self)
		self:SetType()
		self:SetValue(false)
		self:SetTriState(nil)
		self:SetWidth(200)
		self:SetImage()
		self:SetDisabled(nil)
		self:SetDescription(nil)
	end,

	["OnWidthSet"] = function(self, width)
		if self.desc then
			self.desc:SetWidth(width - 30)
			if self.desc:GetText() and self.desc:GetText() ~= "" then
				self:SetHeight(28 + self.desc:GetStringHeight())
			end
		end
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
			self.text:SetTextColor(0.5, 0.5, 0.5)
			if self.desc then
				self.desc:SetTextColor(0.5, 0.5, 0.5)
			end
		else
			self.frame:Enable()
			self.text:SetTextColor(1, 1, 1)
			if self.desc then
				self.desc:SetTextColor(1, 1, 1)
			end
		end
		UpdateVisual(self)
	end,

	["SetValue"] = function(self, value)
		self.checked = value
		UpdateVisual(self)
	end,

	["GetValue"] = function(self)
		return self.checked
	end,

	["SetTriState"] = function(self, enabled)
		self.tristate = enabled
		self:SetValue(self:GetValue())
	end,

	["SetType"] = function() end, -- No visual distinction for "radio" style; always renders as a switch

	["ToggleChecked"] = function(self)
		local value = self:GetValue()
		if self.tristate then
			-- cycle in true, nil, false order
			if value then
				self:SetValue(nil)
			elseif value == nil then
				self:SetValue(false)
			else
				self:SetValue(true)
			end
		else
			self:SetValue(not self:GetValue())
		end
	end,

	["SetLabel"] = function(self, label)
		self.text:SetText(label)
	end,

	["SetDescription"] = function(self, desc)
		if desc then
			if not self.desc then
				local f = self.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
				f:ClearAllPoints()
				f:SetPoint("TOPLEFT", self.track, "TOPRIGHT", 6, -21)
				f:SetWidth(self.frame.width - 30)
				f:SetPoint("RIGHT", self.frame, "RIGHT", -30, 0)
				f:SetJustifyH("LEFT")
				f:SetJustifyV("TOP")
				self.desc = f
			end
			self.desc:Show()
			self.desc:SetText(desc)
			self:SetHeight(28 + self.desc:GetStringHeight())
		else
			if self.desc then
				self.desc:SetText("")
				self.desc:Hide()
			end
			self:SetHeight(24)
		end
	end,

	["SetImage"] = function(self, path, ...)
		local image = self.image
		image:SetTexture(path)

		if image:GetTexture() then
			local n = select("#", ...)
			if n == 4 or n == 8 then
				image:SetTexCoord(...)
			else
				image:SetTexCoord(0, 1, 0, 1)
			end
		end
		AlignImage(self)
	end,
}

local function Constructor()
	local frame = CreateFrame("Button", nil, UIParent)
	frame:Hide()

	frame:EnableMouse(true)
	frame:SetScript("OnEnter", Control_OnEnter)
	frame:SetScript("OnLeave", Control_OnLeave)
	frame:SetScript("OnMouseUp", ToggleSwitch_OnMouseUp)

	local track = CreateFrame("Frame", nil, frame)
	track:SetSize(TRACK_WIDTH, TRACK_HEIGHT)
	track:SetPoint("LEFT", 0, 0)
	track:CreateBackdrop("Transparent")

	local knob = CreateFrame("Frame", nil, track)
	knob:SetSize(KNOB_SIZE, KNOB_SIZE)
	knob:CreateBackdrop("Transparent")

	local text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	text:SetJustifyH("LEFT")
	text:SetHeight(18)
	text:SetPoint("LEFT", track, "RIGHT", 6, 0)
	text:SetPoint("RIGHT")

	local image = frame:CreateTexture(nil, "OVERLAY")
	image:SetHeight(16)
	image:SetWidth(16)
	image:SetPoint("LEFT", track, "RIGHT", 1, 0)

	local widget = {
		track = track,
		knob = knob,
		text = text,
		image = image,
		frame = frame,
		type = Type,
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
