local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

-- Card widgets for the options pages, in the style of the installer cards:
--
-- MERLinkTile (dialogControl of an "execute"): a clickable tile with a logo,
-- title and subtitle. Give it `width = "relative"` + `relWidth` to put several
-- tiles in one row; `arg = { subtitle = "...", color = "rrggbb" }` sets the
-- second line and the hover color (default: accent), `arg.atlas` an atlas logo.
--
-- MERTextCard (dialogControl of a "description"): a full-width card with an
-- accent strip, an optional title line and the description text as body.
-- `arg = { title = "...", icon = path, color = "rrggbb" }`.
--
-- MERPresetCard (dialogControl of an "execute"): a clickable card with a preview
-- image on top (`image` + `imageCoords`, the logo when there is none), the
-- title and a muted description from `arg = { desc = "..." }`.
--
-- MERToggleCard (dialogControl of a "toggle"): a card with an optional icon,
-- the name as title, the description as muted body and a switch on the right;
-- a click anywhere on the card toggles it. Needs `descStyle = "inline"`, which
-- hands the description to the card and drops the tooltip. Full-width cards grow
-- with their text, cards in a row (`width = "relative"`) all reserve
-- `arg.lines` (default 2, 0 for none) body lines so a row lines up; longer text is cut and
-- shown in a tooltip. `image` sets the icon, `arg.atlas` an atlas icon.
--
-- AceConfigDialog hands `arg` to the widget via SetCustomData after the text
-- and image are set, so the widgets relayout there.
local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local _G = _G
local floor, max, min, pairs, select, type, unpack = math.floor, math.max, math.min, pairs, select, type, unpack
local CreateFrame, UIParent = CreateFrame, UIParent
local PlaySound = PlaySound

-- Gap to the next tile/card; the right edge is inset by it so relative-width
-- tiles leave a gap between them, AceGUI's Flow layout adds 3px between rows
local GAP = 8
local ROW_GAP = GAP - 3
local PADDING = 10
local SPACING = 4
local ACCENT_WIDTH = 2

local TILE_HEIGHT = 52
local ICON_SIZE = 32
local ARROW_SIZE = 14

local COLOR_ACCENT = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }
local COLOR_MUTED = { 0.62, 0.62, 0.62 }
local COLOR_TEXT = { 1, 1, 1 }

local function HexToColor(hex)
	if not hex then
		return COLOR_ACCENT
	end

	return { F.String.HexToRGB(hex) }
end

--[[-----------------------------------------------------------------------------
MERLinkTile
-------------------------------------------------------------------------------]]
do
	local Type, Version = "MERLinkTile", 1

	local function UpdateVisual(self)
		local tile = self.tile
		local hover = self.hover and not self.disabled
		local color = self.color

		-- Read every time instead of cached, so a changed ElvUI backdrop color
		-- applies to pooled tiles too
		local bg = E.media.backdropfadecolor
		if hover then
			tile.backdrop:SetBackdropColor(color[1] * 0.18, color[2] * 0.18, color[3] * 0.18, 0.9)
			tile.backdrop:SetBackdropBorderColor(color[1], color[2], color[3], 1)
			tile.arrow:SetVertexColor(color[1], color[2], color[3])
		else
			tile.backdrop:SetBackdropColor(bg[1], bg[2], bg[3], bg[4])
			tile.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
			tile.arrow:SetVertexColor(unpack(COLOR_MUTED))
		end

		tile.accent:SetColorTexture(color[1], color[2], color[3], 1)
		tile.accent:SetShown(hover)
		tile:SetAlpha(self.disabled and 0.5 or 1)
	end

	local function UpdateLayout(self)
		local tile = self.tile
		local hasSubtitle = tile.subtitle:GetText() and tile.subtitle:GetText() ~= ""

		tile.title:ClearAllPoints()
		if hasSubtitle then
			tile.title:SetPoint("BOTTOMLEFT", tile.icon, "RIGHT", PADDING, 1)
		else
			tile.title:SetPoint("LEFT", tile.icon, "RIGHT", PADDING, 0)
		end
		tile.title:SetPoint("RIGHT", tile.arrow, "LEFT", -SPACING, 0)
		tile.subtitle:SetShown(hasSubtitle)
	end

	local function Tile_OnEnter(tile)
		local self = tile.obj
		self.hover = true
		UpdateVisual(self)
		self:Fire("OnEnter")
	end

	local function Tile_OnLeave(tile)
		local self = tile.obj
		self.hover = nil
		UpdateVisual(self)
		self:Fire("OnLeave")
	end

	local function Tile_OnClick(tile, ...)
		local self = tile.obj
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
			self:SetHeight(TILE_HEIGHT + ROW_GAP)
			self.hover = nil
			self.color = COLOR_ACCENT
			self.tile.subtitle:SetText("")
			self:SetImage(nil)
			self:SetText("")
			self:SetDisabled(false)
			UpdateLayout(self)
		end,

		["SetText"] = function(self, text)
			self.tile.title:SetText(text or "")
		end,

		-- AceConfigDialog calls SetLabel instead of SetText when the option has an image
		["SetLabel"] = function(self, text)
			self:SetText(text)
		end,

		["SetImage"] = function(self, path, ...)
			local icon = self.tile.icon
			icon:SetTexture(path)
			if select("#", ...) >= 4 then
				icon:SetTexCoord(...)
			else
				icon:SetTexCoord(0, 1, 0, 1)
			end
			icon:SetShown(path and true or false)
		end,

		-- The logo always has the same size, so the titles line up
		["SetImageSize"] = function() end,

		["SetDisabled"] = function(self, disabled)
			self.disabled = disabled
			self.tile:EnableMouse(not disabled)
			if disabled then
				self.hover = nil
			end
			UpdateVisual(self)
		end,

		["SetCustomData"] = function(self, data)
			if type(data) ~= "table" then
				return
			end

			-- An atlas can't go through the option's `image`, it replaces that here
			if data.atlas then
				self.tile.icon:SetAtlas(data.atlas)
				self.tile.icon:Show()
			end

			self.tile.subtitle:SetText(data.subtitle or "")
			self.color = HexToColor(data.color)
			UpdateLayout(self)
			UpdateVisual(self)
		end,
	}

	local function Constructor()
		local frame = CreateFrame("Frame", nil, UIParent)
		frame:Hide()

		local tile = CreateFrame("Button", nil, frame)
		-- The backdrop sits 1px outside the tile, the scroll frame would clip it in the first column
		tile:SetPoint("TOPLEFT", 1, 0)
		tile:SetPoint("BOTTOMRIGHT", -GAP, ROW_GAP)
		-- ignoreUpdates=true keeps it out of E.frames, so ElvUI's async template
		-- sweep can't wipe the hover colors (see Button.lua)
		tile:CreateBackdrop("Transparent", nil, true)

		local accent = tile:CreateTexture(nil, "ARTWORK")
		accent:SetWidth(ACCENT_WIDTH)
		accent:SetPoint("TOPLEFT", 1, -1)
		accent:SetPoint("BOTTOMLEFT", 1, 1)

		local icon = tile:CreateTexture(nil, "ARTWORK")
		icon:SetSize(ICON_SIZE, ICON_SIZE)
		icon:SetPoint("LEFT", PADDING, 0)

		local arrow = tile:CreateTexture(nil, "ARTWORK")
		arrow:SetSize(ARROW_SIZE, ARROW_SIZE)
		arrow:SetPoint("RIGHT", -PADDING, 0)
		arrow:SetTexture(I.Media.Icons.Forward)

		local title = tile:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		title:SetJustifyH("LEFT")
		title:SetWordWrap(false)
		title:SetTextColor(unpack(COLOR_TEXT))

		local subtitle = tile:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		subtitle:SetJustifyH("LEFT")
		subtitle:SetWordWrap(false)
		subtitle:SetTextColor(unpack(COLOR_MUTED))
		subtitle:SetPoint("TOPLEFT", icon, "RIGHT", PADDING, -3)
		subtitle:SetPoint("RIGHT", arrow, "LEFT", -SPACING, 0)

		tile.accent = accent
		tile.icon = icon
		tile.arrow = arrow
		tile.title = title
		tile.subtitle = subtitle

		local widget = {
			frame = frame,
			tile = tile,
			type = Type,
		}
		for method, func in pairs(methods) do
			widget[method] = func
		end

		tile.obj = widget
		tile:RegisterForClicks("LeftButtonUp")
		tile:SetScript("OnEnter", Tile_OnEnter)
		tile:SetScript("OnLeave", Tile_OnLeave)
		tile:SetScript("OnClick", Tile_OnClick)

		UpdateLayout(widget)

		return AceGUI:RegisterAsWidget(widget)
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

--[[-----------------------------------------------------------------------------
MERTextCard
-------------------------------------------------------------------------------]]
do
	local Type, Version = "MERTextCard", 1

	local TITLE_HEIGHT = 16
	local TITLE_ICON_SIZE = 16

	local function UpdateLayout(self)
		if self.resizing then
			return
		end

		local frame = self.frame
		local card = self.card
		local width = frame.width or frame:GetWidth() or 0
		local textLeft = ACCENT_WIDTH + PADDING
		local textWidth = width - GAP - 1 - textLeft - PADDING

		local top = PADDING
		local hasTitle = card.title:GetText() and card.title:GetText() ~= ""
		card.title:SetShown(hasTitle)
		card.titleIcon:SetShown(hasTitle and card.titleIcon:GetTexture() ~= nil)

		if hasTitle then
			card.titleIcon:ClearAllPoints()
			card.titleIcon:SetPoint("TOPLEFT", textLeft, -top)
			card.title:ClearAllPoints()
			if card.titleIcon:IsShown() then
				card.title:SetPoint("LEFT", card.titleIcon, "RIGHT", SPACING + 2, 0)
			else
				card.title:SetPoint("TOPLEFT", textLeft, -top)
			end
			top = top + TITLE_HEIGHT + SPACING + 2
		end

		local body = card.body
		body:ClearAllPoints()
		body:SetPoint("TOPLEFT", textLeft, -top)
		body:SetWidth(textWidth > 1 and textWidth or 1)

		local bodyHeight = (body:GetText() and body:GetText() ~= "") and body:GetStringHeight() or 0
		local height = floor(top + bodyHeight + PADDING + 0.5) + ROW_GAP

		self.resizing = true
		frame:SetHeight(height)
		frame.height = height
		self.resizing = nil
	end

	local methods = {
		["OnAcquire"] = function(self)
			self.resizing = true
			self:SetWidth(200)
			self.resizing = nil

			self.card.title:SetText("")
			self.card.titleIcon:SetTexture(nil)
			self.card.accent:SetColorTexture(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 1)
			self.card.body:SetFontObject("GameFontHighlight")
			self:SetText("")
		end,

		["OnWidthSet"] = function(self)
			UpdateLayout(self)
		end,

		["SetText"] = function(self, text)
			self.card.body:SetText(text or "")
			UpdateLayout(self)
		end,

		["SetFontObject"] = function(self, font)
			self.card.body:SetFontObject(font or "GameFontHighlight")
			UpdateLayout(self)
		end,

		-- AceConfigDialog's description calls; the card has no image of its own,
		-- the title icon comes in through `arg`
		["SetImage"] = function() end,
		["SetImageSize"] = function() end,
		["SetColor"] = function() end,
		["SetJustifyH"] = function() end,
		["SetJustifyV"] = function() end,

		["SetCustomData"] = function(self, data)
			if type(data) ~= "table" then
				return
			end

			local card = self.card
			card.title:SetText(data.title or "")
			card.titleIcon:SetTexture(data.icon)
			local color = HexToColor(data.color)
			card.accent:SetColorTexture(color[1], color[2], color[3], 1)
			UpdateLayout(self)
		end,
	}

	local function Constructor()
		local frame = CreateFrame("Frame", nil, UIParent)
		frame:Hide()

		local card = CreateFrame("Frame", nil, frame)
		-- The backdrop sits 1px outside the card, the scroll frame would clip it
		card:SetPoint("TOPLEFT", 1, 0)
		card:SetPoint("BOTTOMRIGHT", -GAP, ROW_GAP)
		card:CreateBackdrop("Transparent", nil, true)

		local accent = card:CreateTexture(nil, "ARTWORK")
		accent:SetWidth(ACCENT_WIDTH)
		accent:SetPoint("TOPLEFT", 1, -1)
		accent:SetPoint("BOTTOMLEFT", 1, 1)

		local titleIcon = card:CreateTexture(nil, "ARTWORK")
		titleIcon:SetSize(TITLE_ICON_SIZE, TITLE_ICON_SIZE)

		local title = card:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		title:SetHeight(TITLE_HEIGHT)
		title:SetJustifyH("LEFT")
		title:SetWordWrap(false)
		title:SetTextColor(unpack(COLOR_TEXT))

		local body = card:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		body:SetJustifyH("LEFT")
		body:SetJustifyV("TOP")
		body:SetWordWrap(true)
		body:SetNonSpaceWrap(true)

		card.accent = accent
		card.titleIcon = titleIcon
		card.title = title
		card.body = body

		local widget = {
			frame = frame,
			card = card,
			type = Type,
		}
		for method, func in pairs(methods) do
			widget[method] = func
		end

		return AceGUI:RegisterAsWidget(widget)
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

--[[-----------------------------------------------------------------------------
MERPresetCard
-------------------------------------------------------------------------------]]
do
	local Type, Version = "MERPresetCard", 1

	-- Width : height of the preview; the image keeps it at every card width
	local PREVIEW_RATIO = 2.8
	local TITLE_HEIGHT = 16
	local DESC_LINES = 3
	local LOGO_SIZE = 40

	local function UpdateVisual(self)
		local card = self.card
		local hover = self.hover and not self.disabled
		local color = COLOR_ACCENT

		local bg = E.media.backdropfadecolor
		if hover then
			card.backdrop:SetBackdropColor(color[1] * 0.18, color[2] * 0.18, color[3] * 0.18, 0.9)
			card.backdrop:SetBackdropBorderColor(color[1], color[2], color[3], 1)
		else
			card.backdrop:SetBackdropColor(bg[1], bg[2], bg[3], bg[4])
			card.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end

		card.accent:SetColorTexture(color[1], color[2], color[3], 1)
		card.accent:SetShown(hover)
		card:SetAlpha(self.disabled and 0.5 or 1)
	end

	local function UpdateLayout(self)
		if self.resizing then
			return
		end

		local frame = self.frame
		local card = self.card
		local width = (frame.width or frame:GetWidth() or 0) - GAP - 1
		local previewHeight = floor(width / PREVIEW_RATIO + 0.5)

		card.preview:SetHeight(previewHeight > 1 and previewHeight or 1)

		local _, fontHeight = card.desc:GetFont()
		local descHeight = floor((fontHeight or 12) * 1.2 * DESC_LINES + 0.5)
		card.desc:SetHeight(descHeight)

		local height = 1 + previewHeight + PADDING + TITLE_HEIGHT + SPACING + descHeight + PADDING + ROW_GAP

		self.resizing = true
		frame:SetHeight(height)
		frame.height = height
		self.resizing = nil
	end

	local function Card_OnEnter(card)
		local self = card.obj
		self.hover = true
		UpdateVisual(self)
		self:Fire("OnEnter")
	end

	local function Card_OnLeave(card)
		local self = card.obj
		self.hover = nil
		UpdateVisual(self)
		self:Fire("OnLeave")
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
			self.resizing = true
			self:SetWidth(200)
			self.resizing = nil

			self.hover = nil
			self.card.desc:SetText("")
			self:SetImage(nil)
			self:SetText("")
			self:SetDisabled(false)
			UpdateLayout(self)
		end,

		["OnWidthSet"] = function(self)
			UpdateLayout(self)
		end,

		["SetText"] = function(self, text)
			self.card.title:SetText(text or "")
		end,

		-- AceConfigDialog calls SetLabel instead of SetText when the option has an image
		["SetLabel"] = function(self, text)
			self:SetText(text)
		end,

		-- Without a preview the card shows the logo on the plain background
		["SetImage"] = function(self, path, ...)
			local card = self.card
			card.image:SetTexture(path)
			if select("#", ...) >= 4 then
				card.image:SetTexCoord(...)
			else
				card.image:SetTexCoord(0, 1, 0, 1)
			end
			card.image:SetShown(path and true or false)
			card.logo:SetShown(not path)
		end,

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

			self.card.desc:SetText(data.desc or "")
			UpdateLayout(self)
		end,
	}

	local function Constructor()
		local frame = CreateFrame("Frame", nil, UIParent)
		frame:Hide()

		local card = CreateFrame("Button", nil, frame)
		-- The backdrop sits 1px outside the card, the scroll frame would clip it
		-- in the first column
		card:SetPoint("TOPLEFT", 1, 0)
		card:SetPoint("BOTTOMRIGHT", -GAP, ROW_GAP)
		-- ignoreUpdates=true keeps it out of E.frames, so ElvUI's async template
		-- sweep can't wipe the hover colors (see Button.lua)
		card:CreateBackdrop("Transparent", nil, true)

		local preview = CreateFrame("Frame", nil, card)
		preview:SetPoint("TOPLEFT", 1, -1)
		preview:SetPoint("TOPRIGHT", -1, -1)

		local previewBg = preview:CreateTexture(nil, "BACKGROUND", nil, 1)
		previewBg:SetAllPoints()
		previewBg:SetColorTexture(0, 0, 0, 0.35)

		local image = preview:CreateTexture(nil, "ARTWORK")
		image:SetAllPoints()

		local logo = preview:CreateTexture(nil, "ARTWORK")
		logo:SetSize(LOGO_SIZE, LOGO_SIZE)
		logo:SetPoint("CENTER")
		logo:SetTexture(I.Media.Icons.Brands.MerathilisUI)
		logo:SetAlpha(0.6)

		local accent = card:CreateTexture(nil, "OVERLAY")
		accent:SetHeight(ACCENT_WIDTH)
		accent:SetPoint("TOPLEFT", preview, "BOTTOMLEFT")
		accent:SetPoint("TOPRIGHT", preview, "BOTTOMRIGHT")

		local title = card:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		title:SetHeight(TITLE_HEIGHT)
		title:SetJustifyH("LEFT")
		title:SetWordWrap(false)
		title:SetTextColor(unpack(COLOR_TEXT))
		title:SetPoint("TOPLEFT", preview, "BOTTOMLEFT", PADDING - 1, -PADDING)
		title:SetPoint("RIGHT", -PADDING, 0)

		local desc = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		desc:SetJustifyH("LEFT")
		desc:SetJustifyV("TOP")
		desc:SetWordWrap(true)
		desc:SetTextColor(unpack(COLOR_MUTED))
		desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -SPACING)
		desc:SetPoint("RIGHT", -PADDING, 0)

		card.preview = preview
		card.image = image
		card.logo = logo
		card.accent = accent
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
end

--[[-----------------------------------------------------------------------------
MERToggleCard
-------------------------------------------------------------------------------]]
do
	local Type, Version = "MERToggleCard", 1

	local TITLE_HEIGHT = 16
	local DESC_LINES = 2

	-- Same switch as MERToggleSwitch
	local TRACK_WIDTH, TRACK_HEIGHT = 34, 16
	local KNOB_SIZE = 12
	local KNOB_INSET = 2
	local COLOR_TRACK_OFF = { 0.16, 0.16, 0.16, 1 }
	local COLOR_KNOB = { 0.92, 0.92, 0.92, 1 }

	local BADGE_SCALE = 0.6
	local BADGE_RESERVE = 28

	local function UpdateVisual(self)
		local card = self.card
		local hover = self.hover and not self.disabled
		local color = self.color

		local bg = E.media.backdropfadecolor
		if hover then
			card.backdrop:SetBackdropColor(color[1] * 0.18, color[2] * 0.18, color[3] * 0.18, 0.9)
			card.backdrop:SetBackdropBorderColor(color[1], color[2], color[3], 1)
		else
			card.backdrop:SetBackdropColor(bg[1], bg[2], bg[3], bg[4])
			card.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end

		local track, knob = card.track, card.knob
		knob:ClearAllPoints()
		if self.checked then
			track.backdrop:SetBackdropColor(color[1], color[2], color[3], 1)
			knob:SetPoint("RIGHT", track, "RIGHT", -KNOB_INSET, 0)
		else
			track.backdrop:SetBackdropColor(unpack(COLOR_TRACK_OFF))
			knob:SetPoint("LEFT", track, "LEFT", KNOB_INSET, 0)
		end
		knob.backdrop:SetBackdropColor(unpack(COLOR_KNOB))

		card.accent:SetColorTexture(color[1], color[2], color[3], 1)
		card.accent:SetShown(self.checked and true or false)
		card:SetAlpha(self.disabled and 0.5 or 1)
	end

	local function UpdateNewBadge(self)
		local card = self.card
		local badge = F.SyncNewFeatureBadge(self, "newBadge", self.isNew, function()
			return F.CreateNewFeatureBadge(card, "LEFT", card.title, "LEFT", 0, 0, BADGE_SCALE)
		end)
		if not badge then
			return
		end

		-- Right after the visible words; a truncated title ends where its room ends
		local room = card.title:GetWidth() - BADGE_RESERVE
		badge:ClearAllPoints()
		badge:SetPoint("LEFT", card.title, "LEFT", min(card.title:GetStringWidth(), room) + 4, 0)
	end

	local function UpdateLayout(self)
		if self.resizing then
			return
		end

		local frame = self.frame
		local card = self.card
		local cardWidth = (frame.width or frame:GetWidth() or 0) - GAP - 1
		local textLeft = ACCENT_WIDTH + PADDING
		if card.icon:IsShown() then
			textLeft = textLeft + ICON_SIZE + PADDING
		end
		local textWidth = max(cardWidth - textLeft - PADDING - TRACK_WIDTH - PADDING, 1)

		local title, desc = card.title, card.desc
		local hasDesc = desc:GetText() and desc:GetText() ~= ""
		desc:SetShown(hasDesc)
		desc:SetWidth(textWidth)

		-- AceGUI's Flow layout reads the height of a relative-width widget before
		-- it sets the width, so only full-width cards follow the text. The others
		-- reserve their lines even without a description, so a row lines up.
		local descHeight
		if self.width == "fill" then
			desc:SetMaxLines(0)
			descHeight = hasDesc and desc:GetStringHeight() or nil
		elseif self.lines == 0 then
			desc:Hide()
		else
			local _, fontHeight = desc:GetFont()
			desc:SetMaxLines(self.lines)
			descHeight = floor((fontHeight or 12) * 1.2 * self.lines + 0.5)
		end

		local block = TITLE_HEIGHT + (descHeight and SPACING + descHeight or 0)
		local height = max(TILE_HEIGHT, PADDING + block + PADDING)

		title:ClearAllPoints()
		title:SetPoint("TOPLEFT", textLeft, -floor((height - block) / 2 + 0.5))
		title:SetWidth(textWidth)

		frame:SetHeight(height + ROW_GAP)
		frame.height = height + ROW_GAP
		UpdateNewBadge(self)
	end

	local function Card_OnEnter(card)
		local self = card.obj
		self.hover = true
		UpdateVisual(self)
		self:Fire("OnEnter")

		-- descStyle "inline" drops AceConfigDialog's tooltip, so a cut description gets its own
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

	local function HideTooltip(self)
		if self.tooltip then
			self.tooltip:Hide()
			self.tooltip = nil
		end
	end

	local function Card_OnLeave(card)
		local self = card.obj
		self.hover = nil
		UpdateVisual(self)
		self:Fire("OnLeave")
		HideTooltip(self)
	end

	local function Card_OnClick(card)
		local self = card.obj
		if self.disabled then
			return
		end

		AceGUI:ClearFocus()
		self:ToggleChecked()
		PlaySound(self.checked and 856 or 857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON / _OFF
		self:Fire("OnValueChanged", self.checked)
	end

	local methods = {
		["OnAcquire"] = function(self)
			self.resizing = true
			self:SetWidth(200)
			self.resizing = nil

			self.hover = nil
			self.isNew = nil
			self.color = COLOR_ACCENT
			self.lines = DESC_LINES
			self.card.title:SetText("")
			self.card.desc:SetText("")
			self:SetImage(nil)
			self:SetTriState(nil)
			self:SetValue(false)
			self:SetDisabled(false)
		end,

		["OnRelease"] = function(self)
			HideTooltip(self)
		end,

		["OnWidthSet"] = function(self)
			UpdateLayout(self)
		end,

		["SetLabel"] = function(self, label)
			-- F.NewFeatureText marks the option as new, the marker becomes a NEW badge
			label = label or ""
			self.isNew = label:find(F.NewFeatureMarker, 1, true) ~= nil
			if self.isNew then
				label = label:gsub(F.NewFeatureMarker, "")
			end

			self.card.title:SetText(label)
			UpdateNewBadge(self)
		end,

		["SetDescription"] = function(self, desc)
			self.card.desc:SetText(desc or "")
			UpdateLayout(self)
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

		["SetValue"] = function(self, value)
			self.checked = value
			UpdateVisual(self)
		end,

		["GetValue"] = function(self)
			return self.checked
		end,

		["SetTriState"] = function(self, enabled)
			self.tristate = enabled
		end,

		["ToggleChecked"] = function(self)
			local value = self.checked
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
				self:SetValue(not value)
			end
		end,

		["SetDisabled"] = function(self, disabled)
			self.disabled = disabled
			if disabled then
				self.hover = nil
			end
			UpdateVisual(self)
		end,

		["SetCustomData"] = function(self, data)
			if type(data) ~= "table" then
				return
			end

			-- An atlas can't go through the option's `image`, it replaces that here
			if data.atlas then
				self.card.icon:SetAtlas(data.atlas)
				self.card.icon:Show()
			end

			self.color = HexToColor(data.color)
			self.lines = data.lines or DESC_LINES
			UpdateLayout(self)
			UpdateVisual(self)
		end,
	}

	local function Constructor()
		local frame = CreateFrame("Frame", nil, UIParent)
		frame:Hide()

		local card = CreateFrame("Button", nil, frame)
		-- The backdrop sits 1px outside the card, the scroll frame would clip it
		-- in the first column
		card:SetPoint("TOPLEFT", 1, 0)
		card:SetPoint("BOTTOMRIGHT", -GAP, ROW_GAP)
		-- ignoreUpdates=true keeps these out of E.frames, so ElvUI's async template
		-- sweep can't wipe the hover and switch colors (see Button.lua)
		card:CreateBackdrop("Transparent", nil, true)

		local accent = card:CreateTexture(nil, "ARTWORK")
		accent:SetWidth(ACCENT_WIDTH)
		accent:SetPoint("TOPLEFT", 1, -1)
		accent:SetPoint("BOTTOMLEFT", 1, 1)

		local icon = card:CreateTexture(nil, "ARTWORK")
		icon:SetSize(ICON_SIZE, ICON_SIZE)
		icon:SetPoint("LEFT", ACCENT_WIDTH + PADDING, 0)

		local track = CreateFrame("Frame", nil, card)
		track:SetSize(TRACK_WIDTH, TRACK_HEIGHT)
		track:SetPoint("RIGHT", -PADDING, 0)
		track:CreateBackdrop("Transparent", nil, true)

		local knob = CreateFrame("Frame", nil, track)
		knob:SetSize(KNOB_SIZE, KNOB_SIZE)
		knob:CreateBackdrop("Transparent", nil, true)

		local title = card:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		title:SetHeight(TITLE_HEIGHT)
		title:SetJustifyH("LEFT")
		title:SetWordWrap(false)
		title:SetTextColor(unpack(COLOR_TEXT))

		local desc = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		desc:SetJustifyH("LEFT")
		desc:SetJustifyV("TOP")
		desc:SetWordWrap(true)
		desc:SetTextColor(unpack(COLOR_MUTED))
		desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -SPACING)

		card.accent = accent
		card.icon = icon
		card.track = track
		card.knob = knob
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
end
