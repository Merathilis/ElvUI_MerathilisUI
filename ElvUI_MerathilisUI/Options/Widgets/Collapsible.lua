local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Widgets of the collapsible option sections, see module.ModuleCard and
-- module.LessCommon in Options/Core.lua for how they are put into a page:
--
-- MERModuleCard (dialogControl of a "toggle" or a "description"): the header
-- row of a module card. A chevron, the title, a muted one-line description
-- and, as a toggle, a switch on the right. A click on the switch changes the
-- option, a click anywhere else opens or closes the card. The card box itself
-- is the untitled inline group around it, the rest of that group's args are
-- hidden while the card is closed.
-- `arg = { id = "...", title = "...", desc = "...", icon = path, atlas = "..." }`
--
-- MERExpanderLink (dialogControl of an "execute"): a centered text link between
-- two thin lines with a chevron, used as "Show more options" toggle.
-- `arg = { id = "..." }`
--
-- Both read and flip the open state through module.IsSectionExpanded /
-- module.ToggleSectionExpanded, the option args hide themselves by it.
local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")
local S = E:GetModule("Skins")

local _G = _G
local min, pairs, select, type, unpack = math.min, pairs, select, type, unpack
local CreateFrame, UIParent = CreateFrame, UIParent
local PlaySound = PlaySound

local COLOR_ACCENT = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }
local COLOR_TEXT = { 1, 1, 1 }
local COLOR_MUTED = { 0.62, 0.62, 0.62 }
local COLOR_CHEVRON = { 0.6, 0.6, 0.6 }

local function Section_OnClick(self)
	if not self.id then
		return
	end

	AceGUI:ClearFocus()
	PlaySound(module.IsSectionExpanded(self.id) and 857 or 856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF / _ON
	module.ToggleSectionExpanded(self.id)
end

--[[-----------------------------------------------------------------------------
MERModuleCard
-------------------------------------------------------------------------------]]
do
	local Type, Version = "MERModuleCard", 1

	local HEADER_HEIGHT = 40
	local EXPANDED_GAP = 8 -- between the divider and the first body row
	local PADDING = 6
	local CHEVRON_SIZE = 12
	local ICON_SIZE = 24
	local TITLE_FONT_SIZE = 13
	local TITLE_HEIGHT = 16
	local SPACING = 2

	-- Same switch as MERToggleSwitch / MERToggleCard
	local TRACK_WIDTH, TRACK_HEIGHT = 34, 16
	local KNOB_SIZE = 12
	local KNOB_INSET = 2
	local COLOR_TRACK_OFF = { 0.16, 0.16, 0.16, 1 }
	local COLOR_KNOB = { 0.92, 0.92, 0.92, 1 }
	local COLOR_KNOB_DISABLED = { 0.55, 0.55, 0.55, 1 }

	local BADGE_SCALE = 0.6
	local BADGE_RESERVE = 28

	local function UpdateNewBadge(self)
		local title = self.header.title
		local badge = F.SyncNewFeatureBadge(self, "newBadge", self.isNew, function()
			return F.CreateNewFeatureBadge(self.header, "LEFT", title, "LEFT", 0, 0, BADGE_SCALE)
		end)
		if not badge then
			return
		end

		-- Right after the visible words; a truncated title ends where its room ends.
		-- The room comes from the widget's own width: the title's anchored width
		-- is not resolved yet while AceGUI lays the card out.
		local width = self.frame.width or self.frame:GetWidth() or 0
		local room = width - (self.textLeft or 0) - (self.textRight or 0) - BADGE_RESERVE
		badge:ClearAllPoints()
		badge:SetPoint("LEFT", title, "LEFT", min(title:GetStringWidth(), room) + 4, 0)
	end

	-- F.NewFeatureText marks the card as new, the marker becomes a NEW badge
	local function SetTitle(self, text)
		text = text or ""
		self.isNew = text:find(F.NewFeatureMarker, 1, true) ~= nil
		if self.isNew then
			text = text:gsub(F.NewFeatureMarker, "")
		end

		self.header.title:SetText(text)
		UpdateNewBadge(self)
	end

	local function UpdateVisual(self)
		local header = self.header
		local expanded = self.id and module.IsSectionExpanded(self.id)

		header.hoverTex:SetShown(self.hover and true or false)
		header.chevron:SetRotation(expanded and S.ArrowRotation.down or S.ArrowRotation.right)
		if self.hover then
			header.chevron:SetVertexColor(unpack(COLOR_ACCENT))
		else
			header.chevron:SetVertexColor(unpack(COLOR_CHEVRON))
		end
		header.divider:SetShown(expanded and true or false)

		local track, knob = self.track, self.knob
		track:SetShown(self.hasSwitch and true or false)
		if self.hasSwitch then
			knob:ClearAllPoints()
			if self.checked then
				local alpha = self.disabled and 0.4 or 1
				track.backdrop:SetBackdropColor(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], alpha)
				knob:SetPoint("RIGHT", track, "RIGHT", -KNOB_INSET, 0)
			else
				track.backdrop:SetBackdropColor(unpack(COLOR_TRACK_OFF))
				knob:SetPoint("LEFT", track, "LEFT", KNOB_INSET, 0)
			end
			knob.backdrop:SetBackdropColor(unpack(self.disabled and COLOR_KNOB_DISABLED or COLOR_KNOB))
		end

		-- A switched off module reads as inactive, the card still opens
		local inactive = self.hasSwitch and not self.checked
		header.title:SetAlpha(inactive and 0.6 or 1)
		header.icon:SetDesaturated(inactive and true or false)
	end

	local function UpdateLayout(self)
		local header = self.header
		local expanded = self.id and module.IsSectionExpanded(self.id)

		local textLeft = PADDING + CHEVRON_SIZE + PADDING
		header.icon:ClearAllPoints()
		if header.icon:IsShown() then
			header.icon:SetPoint("LEFT", textLeft, 0)
			textLeft = textLeft + ICON_SIZE + PADDING
		end

		local textRight = PADDING + (self.hasSwitch and (TRACK_WIDTH + PADDING * 2) or 0)
		local title, desc = header.title, header.desc
		local hasDesc = desc:GetText() and desc:GetText() ~= ""
		desc:SetShown(hasDesc)

		local block = TITLE_HEIGHT + (hasDesc and (SPACING + TITLE_HEIGHT) or 0)
		local top = -((HEADER_HEIGHT - block) / 2)
		title:ClearAllPoints()
		title:SetPoint("TOPLEFT", textLeft, top)
		title:SetPoint("TOPRIGHT", -textRight, top)
		self.textLeft, self.textRight = textLeft, textRight

		local height = HEADER_HEIGHT + (expanded and EXPANDED_GAP or 0)
		self:SetHeight(height)
		UpdateNewBadge(self)
	end

	local function HideTooltip(self)
		if self.tooltip then
			self.tooltip:Hide()
			self.tooltip = nil
		end
	end

	local function Header_OnEnter(header)
		local self = header.obj
		self.hover = true
		UpdateVisual(self)

		-- The description is cut to one line, the full text goes into a tooltip
		local desc = header.desc
		if desc:IsShown() and desc:IsTruncated() then
			local dialog = E.Libs.AceConfigDialog
			local tooltip = dialog and dialog.tooltip or _G.GameTooltip
			tooltip:SetOwner(header, "ANCHOR_TOPRIGHT")
			tooltip:SetText(header.title:GetText(), 1, 1, 1)
			tooltip:AddLine(desc:GetText(), nil, nil, nil, true)
			tooltip:Show()
			self.tooltip = tooltip
		end
	end

	local function Header_OnLeave(header)
		local self = header.obj
		self.hover = nil
		UpdateVisual(self)
		HideTooltip(self)
	end

	local function Header_OnClick(header)
		Section_OnClick(header.obj)
	end

	local function Track_OnClick(track)
		local self = track.obj
		if self.disabled then
			return
		end

		AceGUI:ClearFocus()
		self.checked = not self.checked
		PlaySound(self.checked and 856 or 857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON / _OFF
		UpdateVisual(self)
		self:Fire("OnValueChanged", self.checked)
	end

	-- No OnEnter/OnLeave fire: AceConfigDialog's tooltip would only repeat the title
	local function Track_OnEnter(track)
		local self = track.obj
		self.hover = true
		UpdateVisual(self)
	end

	local function Track_OnLeave(track)
		local self = track.obj
		self.hover = nil
		UpdateVisual(self)
	end

	local methods = {
		["OnAcquire"] = function(self)
			self:SetWidth(200)
			self.hover = nil
			self.id = nil
			self.hasSwitch = nil
			self.checked = nil
			self.disabled = nil
			SetTitle(self, "")
			self.header.desc:SetText("")
			self.header.icon:SetTexture(nil)
			self.header.icon:Hide()
			UpdateLayout(self)
			UpdateVisual(self)
		end,

		["OnRelease"] = function(self)
			HideTooltip(self)
		end,

		-- OnAcquire lays the card out at a temporary width, the badge follows the real one
		["OnWidthSet"] = function(self)
			UpdateNewBadge(self)
		end,

		-- "toggle" path
		["SetLabel"] = function(self, text)
			SetTitle(self, text)
		end,

		["SetDescription"] = function(self, text)
			self.header.desc:SetText(text or "")
			UpdateLayout(self)
		end,

		["SetValue"] = function(self, value)
			self.hasSwitch = true
			self.checked = value and true or false
			UpdateLayout(self)
			UpdateVisual(self)
		end,

		["GetValue"] = function(self)
			return self.checked
		end,

		["SetTriState"] = function() end,

		-- "description" path
		["SetText"] = function(self, text)
			SetTitle(self, text)
		end,

		["SetFontObject"] = function() end,
		["SetImageSize"] = function() end,

		["SetImage"] = function(self, path, ...)
			local icon = self.header.icon
			icon:SetTexture(path)
			if select("#", ...) >= 4 then
				icon:SetTexCoord(...)
			else
				icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			end
			icon:SetShown(path and true or false)
			UpdateLayout(self)
		end,

		["SetDisabled"] = function(self, disabled)
			self.disabled = disabled
			self.track:EnableMouse(not disabled)
			UpdateVisual(self)
		end,

		["SetCustomData"] = function(self, data)
			if type(data) ~= "table" then
				return
			end

			self.id = data.id
			if data.title then
				SetTitle(self, data.title)
			end
			if data.desc then
				local desc = data.desc
				if type(desc) == "function" then
					desc = desc()
				end
				self.header.desc:SetText(desc or "")
			end
			if data.atlas then
				self.header.icon:SetAtlas(data.atlas)
				self.header.icon:SetTexCoord(0, 1, 0, 1)
				self.header.icon:Show()
			elseif data.icon then
				self:SetImage(data.icon)
			end

			UpdateLayout(self)
			UpdateVisual(self)
		end,
	}

	local function Constructor()
		local frame = CreateFrame("Frame", nil, UIParent)
		frame:Hide()

		local header = CreateFrame("Button", nil, frame)
		header:SetPoint("TOPLEFT")
		header:SetPoint("TOPRIGHT")
		header:SetHeight(HEADER_HEIGHT)

		local hoverTex = header:CreateTexture(nil, "BACKGROUND")
		hoverTex:SetAllPoints()
		hoverTex:SetColorTexture(1, 1, 1, 0.04)
		hoverTex:Hide()

		local chevron = header:CreateTexture(nil, "ARTWORK")
		chevron:SetSize(CHEVRON_SIZE, CHEVRON_SIZE)
		chevron:SetPoint("LEFT", PADDING, 0)
		chevron:SetTexture(E.Media.Textures.ArrowUp)

		local icon = header:CreateTexture(nil, "ARTWORK")
		icon:SetSize(ICON_SIZE, ICON_SIZE)
		icon:Hide()

		local title = header:CreateFontString(nil, "OVERLAY")
		title:SetFont(F.GetFontPath(), TITLE_FONT_SIZE, "")
		title:SetShadowColor(0, 0, 0, 1)
		title:SetShadowOffset(1, -1)
		title:SetHeight(TITLE_HEIGHT)
		title:SetJustifyH("LEFT")
		title:SetWordWrap(false)
		title:SetTextColor(unpack(COLOR_TEXT))

		local desc = header:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		desc:SetHeight(TITLE_HEIGHT)
		desc:SetJustifyH("LEFT")
		desc:SetWordWrap(false)
		desc:SetTextColor(unpack(COLOR_MUTED))
		desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -SPACING)
		desc:SetPoint("TOPRIGHT", title, "BOTTOMRIGHT", 0, -SPACING)

		local divider = header:CreateTexture(nil, "ARTWORK")
		divider:SetHeight(1)
		divider:SetPoint("BOTTOMLEFT")
		divider:SetPoint("BOTTOMRIGHT")
		divider:SetColorTexture(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 0.35)
		divider:Hide()

		local track = CreateFrame("Button", nil, header)
		track:SetSize(TRACK_WIDTH, TRACK_HEIGHT)
		track:SetPoint("RIGHT", -PADDING * 2, 0)
		-- ignoreUpdates=true keeps these out of E.frames, so ElvUI's async template
		-- sweep can't wipe the switch colors (see Button.lua)
		track:CreateBackdrop("Transparent", nil, true)
		track:Hide()

		local knob = CreateFrame("Frame", nil, track)
		knob:SetSize(KNOB_SIZE, KNOB_SIZE)
		knob:CreateBackdrop("Transparent", nil, true)
		knob:EnableMouse(false)

		header.hoverTex = hoverTex
		header.chevron = chevron
		header.icon = icon
		header.title = title
		header.desc = desc
		header.divider = divider

		local widget = {
			frame = frame,
			header = header,
			track = track,
			knob = knob,
			type = Type,
		}
		for method, func in pairs(methods) do
			widget[method] = func
		end

		header.obj = widget
		track.obj = widget

		header:RegisterForClicks("LeftButtonUp")
		header:SetScript("OnEnter", Header_OnEnter)
		header:SetScript("OnLeave", Header_OnLeave)
		header:SetScript("OnClick", Header_OnClick)

		track:RegisterForClicks("LeftButtonUp")
		track:SetScript("OnEnter", Track_OnEnter)
		track:SetScript("OnLeave", Track_OnLeave)
		track:SetScript("OnClick", Track_OnClick)

		return AceGUI:RegisterAsWidget(widget)
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

--[[-----------------------------------------------------------------------------
MERExpanderLink
-------------------------------------------------------------------------------]]
do
	local Type, Version = "MERExpanderLink", 1

	local FRAME_HEIGHT = 26
	local CHEVRON_SIZE = 10
	local LINE_GAP = 10 -- between a line and the link
	local ALPHA_NORMAL = 0.75

	local function UpdateVisual(self)
		local link = self.link
		local expanded = self.id and module.IsSectionExpanded(self.id)
		local alpha = self.hover and 1 or ALPHA_NORMAL

		if self.disabled then
			link.text:SetTextColor(0.5, 0.5, 0.5, 1)
			link.chevron:SetVertexColor(0.5, 0.5, 0.5, 1)
		else
			link.text:SetTextColor(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], alpha)
			link.chevron:SetVertexColor(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], alpha)
		end
		link.chevron:SetRotation(expanded and S.ArrowRotation.up or S.ArrowRotation.down)

		local lineAlpha = self.hover and 0.5 or 0.25
		self.leftLine:SetAlpha(lineAlpha)
		self.rightLine:SetAlpha(lineAlpha)
	end

	local function UpdateWidth(self)
		local link = self.link
		link:SetWidth(link.text:GetStringWidth() + CHEVRON_SIZE + 6)
	end

	local function Link_OnEnter(link)
		local self = link.obj
		self.hover = true
		UpdateVisual(self)
	end

	local function Link_OnLeave(link)
		local self = link.obj
		self.hover = nil
		UpdateVisual(self)
	end

	local function Link_OnClick(link)
		local self = link.obj
		if self.disabled then
			return
		end

		Section_OnClick(self)
	end

	local methods = {
		["OnAcquire"] = function(self)
			self:SetWidth(200)
			self:SetHeight(FRAME_HEIGHT)
			self.hover = nil
			self.id = nil
			self:SetDisabled(false)
			self:SetText("")
		end,

		["SetText"] = function(self, text)
			self.link.text:SetText(text or "")
			UpdateWidth(self)
		end,

		-- AceConfigDialog calls these for every execute, the link has no image
		["SetImage"] = function() end,
		["SetImageSize"] = function() end,

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

			self.id = data.id
			UpdateVisual(self)
		end,
	}

	local function Constructor()
		local frame = CreateFrame("Frame", nil, UIParent)
		frame:Hide()

		local link = CreateFrame("Button", nil, frame)
		link:SetPoint("TOP")
		link:SetPoint("BOTTOM")

		local text = link:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		text:SetPoint("LEFT")
		text:SetJustifyH("LEFT")
		text:SetWordWrap(false)

		local chevron = link:CreateTexture(nil, "ARTWORK")
		chevron:SetSize(CHEVRON_SIZE, CHEVRON_SIZE)
		chevron:SetPoint("LEFT", text, "RIGHT", 4, 0)
		chevron:SetTexture(E.Media.Textures.ArrowUp)

		local leftLine = frame:CreateTexture(nil, "ARTWORK")
		leftLine:SetHeight(1)
		leftLine:SetPoint("LEFT", frame, "LEFT", 0, 0)
		leftLine:SetPoint("RIGHT", link, "LEFT", -LINE_GAP, 0)
		leftLine:SetColorTexture(1, 1, 1, 1)

		local rightLine = frame:CreateTexture(nil, "ARTWORK")
		rightLine:SetHeight(1)
		rightLine:SetPoint("LEFT", link, "RIGHT", LINE_GAP, 0)
		rightLine:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
		rightLine:SetColorTexture(1, 1, 1, 1)

		link.text = text
		link.chevron = chevron

		local widget = {
			frame = frame,
			link = link,
			leftLine = leftLine,
			rightLine = rightLine,
			type = Type,
		}
		for method, func in pairs(methods) do
			widget[method] = func
		end

		link.obj = widget
		link:RegisterForClicks("LeftButtonUp")
		link:SetScript("OnEnter", Link_OnEnter)
		link:SetScript("OnLeave", Link_OnLeave)
		link:SetScript("OnClick", Link_OnClick)

		return AceGUI:RegisterAsWidget(widget)
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end
