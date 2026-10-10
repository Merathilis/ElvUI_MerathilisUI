local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

-- MERTextLink (dialogControl of an "execute"): the option's name as a plain
-- accent-colored text link instead of a button box. Meant for small secondary
-- actions under a button, like "Show Details". Give it `width = "full"`
-- so it gets its own line; only the text itself is clickable.
-- `arg = { align = "CENTER" }` centers the link in its row instead.
local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERTextLink"
local Version = 1

local pairs, type = pairs, type
local CreateFrame, UIParent = CreateFrame, UIParent
local PlaySound = PlaySound

local FRAME_HEIGHT = 18
local ALPHA_NORMAL = 0.7

local function UpdateVisual(self)
	local accent = I.Colors.Accent
	if self.disabled then
		self.text:SetTextColor(0.5, 0.5, 0.5, 1)
	else
		self.text:SetTextColor(accent.r, accent.g, accent.b, self.hover and 1 or ALPHA_NORMAL)
	end
end

local function UpdateWidth(self)
	self.link:SetWidth(self.text:GetStringWidth() + 4)
end

local function UpdateAnchor(self)
	local link = self.link
	link:ClearAllPoints()
	if self.align == "CENTER" then
		link:SetPoint("TOP")
		link:SetPoint("BOTTOM")
	else
		link:SetPoint("TOPLEFT")
		link:SetPoint("BOTTOMLEFT")
	end
end

local function Link_OnEnter(frame)
	local self = frame.obj
	self.hover = true
	UpdateVisual(self)
	self:Fire("OnEnter")
end

local function Link_OnLeave(frame)
	local self = frame.obj
	self.hover = nil
	UpdateVisual(self)
	self:Fire("OnLeave")
end

local function Link_OnClick(frame, ...)
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
		self.hover = nil
		self.align = nil
		UpdateAnchor(self)
		self:SetDisabled(false)
		self:SetText("")
	end,

	["SetCustomData"] = function(self, data)
		if type(data) ~= "table" then
			return
		end

		self.align = data.align
		UpdateAnchor(self)
	end,

	["SetText"] = function(self, text)
		self.text:SetText(text or "")
		UpdateWidth(self)
	end,

	-- AceConfigDialog calls these for every execute, the link has no image
	["SetImage"] = function() end,
	["SetImageSize"] = function() end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		self.link:EnableMouse(not disabled)
		if disabled then
			self.hover = nil
		end
		UpdateVisual(self)
	end,
}

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local link = CreateFrame("Button", nil, frame)

	local text = link:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	text:SetPoint("LEFT", link, "LEFT", 2, 0)
	text:SetJustifyH("LEFT")
	text:SetWordWrap(false)

	local widget = {
		frame = frame,
		link = link,
		text = text,
		type = Type,
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	link.obj = widget

	link:EnableMouse(true)
	link:RegisterForClicks("LeftButtonUp")
	link:SetScript("OnClick", Link_OnClick)
	link:SetScript("OnEnter", Link_OnEnter)
	link:SetScript("OnLeave", Link_OnLeave)

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
