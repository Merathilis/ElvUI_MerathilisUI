local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

-- MERActionCard (dialogControl of an "execute"): an action as a card with the
-- icon on top, the name as title and a short muted description below, the
-- whole card is the button. Meant for a row of equal cards (`width =
-- "relative"` + `relWidth`), see module.ActionCard in Options/Core.lua.
-- `arg = { desc = "...", lines = 2, atlas = "...", color = "rrggbb" }`: `lines`
-- is the number of description lines every card in a row reserves (0 for
-- none), `color` the hover color (default: accent), `image` the icon.
local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERActionCard"
local Version = 1

local _G = _G
local floor, pairs, select, type, unpack = math.floor, pairs, select, type, unpack
local CreateFrame, UIParent = CreateFrame, UIParent
local PlaySound = PlaySound

-- Gap to the next card, the Flow layout adds 3px between rows
local GAP = 8
local ROW_GAP = GAP - 3
local PADDING = 10
local ICON_SIZE = 26
local TITLE_HEIGHT = 16
local SPACING = 4
local DESC_LINES = 2
local ACCENT_HEIGHT = 2

local COLOR_ACCENT = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }
local COLOR_MUTED = { 0.62, 0.62, 0.62 }

local function UpdateVisual(self)
	local card = self.card
	local hover = self.hover and not self.disabled
	local color = self.color

	local bg = E.media.backdropfadecolor
	if hover then
		card.backdrop:SetBackdropColor(color[1] * 0.18, color[2] * 0.18, color[3] * 0.18, 0.9)
		card.backdrop:SetBackdropBorderColor(color[1], color[2], color[3], 1)
		card.title:SetTextColor(color[1], color[2], color[3])
	else
		card.backdrop:SetBackdropColor(bg[1], bg[2], bg[3], bg[4])
		card.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		card.title:SetTextColor(1, 1, 1)
	end

	card.accent:SetColorTexture(color[1], color[2], color[3], 1)
	card.accent:SetShown(hover)
	card.icon:SetDesaturated(self.disabled and true or false)
	card:SetAlpha(self.disabled and 0.5 or 1)
end

local function UpdateLayout(self)
	local card = self.card
	local desc = card.desc
	local hasIcon = card.icon:IsShown()

	local descHeight = 0
	if self.lines > 0 then
		local _, fontHeight = desc:GetFont()
		desc:SetMaxLines(self.lines)
		descHeight = floor((fontHeight or 12) * 1.2 * self.lines + 0.5)
		desc:SetHeight(descHeight)
	end
	desc:SetShown(self.lines > 0)

	-- Title right under the icon, or at the top of a card without one
	local titleTop = PADDING + (hasIcon and (ICON_SIZE + SPACING) or 0)
	card.title:ClearAllPoints()
	card.title:SetPoint("TOPLEFT", PADDING, -titleTop)
	card.title:SetPoint("TOPRIGHT", -PADDING, -titleTop)

	local height = titleTop + TITLE_HEIGHT + (self.lines > 0 and (SPACING + descHeight) or 0) + PADDING

	self.frame:SetHeight(height + ROW_GAP)
	self.frame.height = height + ROW_GAP
end

local function HideTooltip(self)
	if self.tooltip then
		self.tooltip:Hide()
		self.tooltip = nil
	end
end

local function Card_OnEnter(card)
	local self = card.obj
	self.hover = true
	UpdateVisual(self)
	self:Fire("OnEnter")

	-- A cut description gets the full text in a tooltip
	if card.desc:IsShown() and card.desc:IsTruncated() then
		local dialog = E.Libs.AceConfigDialog
		local tooltip = dialog and dialog.tooltip or _G.GameTooltip
		tooltip:SetOwner(card, "ANCHOR_TOPRIGHT")
		tooltip:SetText(card.title:GetText(), 1, 1, 1)
		tooltip:AddLine(card.desc:GetText(), nil, nil, nil, true)
		tooltip:Show()
		self.tooltip = tooltip
	end
end

local function Card_OnLeave(card)
	local self = card.obj
	self.hover = nil
	UpdateVisual(self)
	self:Fire("OnLeave")
	HideTooltip(self)
end

local function Card_OnClick(card, ...)
	local self = card.obj
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
		self.hover = nil
		self.color = COLOR_ACCENT
		self.lines = 0
		self.card.desc:SetText("")
		self:SetImage(nil)
		self:SetText("")
		self:SetDisabled(false)
		UpdateLayout(self)
	end,

	["OnRelease"] = function(self)
		HideTooltip(self)
	end,

	["SetText"] = function(self, text)
		self.card.title:SetText(text or "")
	end,

	-- AceConfigDialog calls SetLabel instead of SetText when the option has an image
	["SetLabel"] = function(self, text)
		self:SetText(text)
	end,

	["SetImage"] = function(self, path, ...)
		local icon = self.card.icon
		icon:SetTexture(path)
		if select("#", ...) >= 4 then
			icon:SetTexCoord(...)
		else
			icon:SetTexCoord(0, 1, 0, 1)
		end
		icon:SetShown(path and true or false)
		UpdateLayout(self)
	end,

	-- The icon always has the same size, so the titles of a row line up
	["SetImageSize"] = function() end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		self.card:EnableMouse(not disabled)
		if disabled then
			self.hover = nil
		end
		UpdateVisual(self)
	end,

	["SetCustomData"] = function(self, data)
		if type(data) ~= "table" then
			return
		end

		if data.atlas then
			self.card.icon:SetAtlas(data.atlas)
			self.card.icon:SetTexCoord(0, 1, 0, 1)
			self.card.icon:Show()
		end

		local desc = data.desc
		if type(desc) == "function" then
			desc = desc()
		end
		self.card.desc:SetText(desc or "")
		self.lines = data.lines or (desc and desc ~= "" and DESC_LINES or 0)
		self.color = data.color and { F.String.HexToRGB(data.color) } or COLOR_ACCENT
		UpdateLayout(self)
		UpdateVisual(self)
	end,
}

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local card = CreateFrame("Button", nil, frame)
	-- The backdrop sits 1px outside the card, the scroll frame would clip it in the first column
	card:SetPoint("TOPLEFT", 1, 0)
	card:SetPoint("BOTTOMRIGHT", -GAP, ROW_GAP)
	-- ignoreUpdates=true keeps it out of E.frames, so ElvUI's async template
	-- sweep can't wipe the hover colors (see Button.lua)
	card:CreateBackdrop("Transparent", nil, true)

	local accent = card:CreateTexture(nil, "ARTWORK")
	accent:SetHeight(ACCENT_HEIGHT)
	accent:SetPoint("TOPLEFT", 1, -1)
	accent:SetPoint("TOPRIGHT", -1, -1)

	local icon = card:CreateTexture(nil, "ARTWORK")
	icon:SetSize(ICON_SIZE, ICON_SIZE)
	icon:SetPoint("TOP", 0, -PADDING)

	local title = card:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	title:SetHeight(TITLE_HEIGHT)
	title:SetJustifyH("CENTER")
	title:SetWordWrap(false)

	local desc = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	desc:SetJustifyH("CENTER")
	desc:SetJustifyV("TOP")
	desc:SetWordWrap(true)
	desc:SetTextColor(unpack(COLOR_MUTED))
	desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -SPACING)
	desc:SetPoint("TOPRIGHT", title, "BOTTOMRIGHT", 0, -SPACING)

	card.accent = accent
	card.icon = icon
	card.title = title
	card.desc = desc

	local widget = {
		frame = frame,
		card = card,
		type = Type,
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	card.obj = widget
	card:RegisterForClicks("LeftButtonUp")
	card:SetScript("OnEnter", Card_OnEnter)
	card:SetScript("OnLeave", Card_OnLeave)
	card:SetScript("OnClick", Card_OnClick)

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
