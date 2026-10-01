local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERToggleSwitch"
local Version = 1

local _G = _G
local min, select, pairs = math.min, select, pairs
local PlaySound = PlaySound
local CreateFrame, UIParent = CreateFrame, UIParent

local TRACK_WIDTH, TRACK_HEIGHT = 34, 16
local KNOB_SIZE = 12
local KNOB_INSET = 2

-- NEW badge of a label marked with F.NewFeatureText, the label keeps room for it
local BADGE_SCALE = 0.6
local BADGE_RESERVE = 28
local TEXT_OFFSET = 6

local COLOR_TRACK_OFF = { 0.16, 0.16, 0.16, 1 }
local COLOR_TRACK_ON = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b, 1 }
local COLOR_KNOB = { 0.92, 0.92, 0.92, 1 }
local COLOR_KNOB_DISABLED = { 0.55, 0.55, 0.55, 1 }

local COLOR_TEXT_NORMAL = { 1, 1, 1 }
local COLOR_TEXT_DISABLED = { 0.5, 0.5, 0.5 }
local COLOR_TEXT_ENABLE_ON = { 0.1, 0.9, 0.1 }
local COLOR_TEXT_ENABLE_OFF = { 0.9, 0.15, 0.15 }

local function UpdateNewBadge(self)
	local badge = F.SyncNewFeatureBadge(self, "newBadge", self.isNew, function()
		return F.CreateNewFeatureBadge(self.frame, "LEFT", self.text, "LEFT", 0, 0, BADGE_SCALE)
	end)
	if not badge then
		return
	end

	-- Right after the visible words; a truncated label ends where its room ends
	local room = self.frame:GetWidth() - TRACK_WIDTH - TEXT_OFFSET - BADGE_RESERVE
	badge:ClearAllPoints()
	badge:SetPoint("LEFT", self.text, "LEFT", min(self.text:GetStringWidth(), room) + 4, 0)
end

local function AlignImage(self)
	local img = self.image:GetTexture()
	local right = self.isNew and -BADGE_RESERVE or 0
	self.text:ClearAllPoints()
	if not img then
		self.text:SetPoint("LEFT", self.track, "RIGHT", TEXT_OFFSET, 0)
		self.text:SetPoint("RIGHT", right, 0)
	else
		self.text:SetPoint("LEFT", self.image, "RIGHT", 1, 0)
		self.text:SetPoint("RIGHT", right, 0)
	end
	UpdateNewBadge(self)
end

local function UpdateTextColor(self)
	if self.disabled then
		self.text:SetTextColor(unpack(COLOR_TEXT_DISABLED))
	elseif self.isEnableToggle then
		self.text:SetTextColor(unpack(self.checked and COLOR_TEXT_ENABLE_ON or COLOR_TEXT_ENABLE_OFF))
	else
		self.text:SetTextColor(unpack(COLOR_TEXT_NORMAL))
	end

	if self.desc then
		self.desc:SetTextColor(unpack(self.disabled and COLOR_TEXT_DISABLED or COLOR_TEXT_NORMAL))
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
	UpdateTextColor(self)
end

local function Control_OnEnter(frame)
	local self = frame.obj
	self:Fire("OnEnter")

	-- AceConfigDialog puts the raw option name into the tooltip title
	if self.isNew then
		local dialog = E.Libs.AceConfigDialog
		local tooltip = dialog and dialog.tooltip
		local title = tooltip and tooltip:GetName() and _G[tooltip:GetName() .. "TextLeft1"]
		local text = title and title:GetText()
		if text and text:find(F.NewFeatureMarker, 1, true) then
			title:SetText((text:gsub(F.NewFeatureMarker, "")))
		end
	end
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
		self.isEnableToggle = nil
		self.isNew = nil
		self:SetValue(false)
		self:SetTriState(nil)
		self:SetWidth(200)
		self:SetImage()
		self:SetDisabled(nil)
		self:SetDescription(nil)
	end,

	["OnWidthSet"] = function(self, width)
		UpdateNewBadge(self)
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
		else
			self.frame:Enable()
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
		-- F.NewFeatureText marks the option as new, the marker becomes a NEW badge
		local isNew = label and label:find(F.NewFeatureMarker, 1, true) ~= nil
		if isNew then
			label = label:gsub(F.NewFeatureMarker, "")
		end

		self.isNew = isNew
		self.text:SetText(label)
		self.isEnableToggle = label == L["Enable"]
		UpdateTextColor(self)
		AlignImage(self)
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

	-- ignoreUpdates=true keeps these out of E.frames, otherwise ElvUI's async
	-- E:UpdateFrameTemplates() coroutine (triggered by any "requires reload" option,
	-- e.g. Style's ForceRefresh) re-templates them a few frames later and wipes the
	-- on/off/disabled color UpdateVisual() just set, leaving the switch blank until
	-- something happens to call SetValue/SetDisabled again.
	local track = CreateFrame("Frame", nil, frame)
	track:SetSize(TRACK_WIDTH, TRACK_HEIGHT)
	track:SetPoint("LEFT", 0, 0)
	track:CreateBackdrop("Transparent", nil, true)

	local knob = CreateFrame("Frame", nil, track)
	knob:SetSize(KNOB_SIZE, KNOB_SIZE)
	knob:CreateBackdrop("Transparent", nil, true)

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
