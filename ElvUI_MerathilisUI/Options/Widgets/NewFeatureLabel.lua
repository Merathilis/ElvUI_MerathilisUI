local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

-- Duplicate of AceGUI-3.0's stock "Label" widget, registered under our own
-- type name so it can be opted into per-option via
-- `dialogControl = "MERNewFeatureLabel"` without touching the shared "Label"
-- type every other addon's descriptions render through (same reasoning as
-- Options/Widgets/TabGroup.lua's comment on why "TabGroup" itself is never
-- touched directly).
--
-- Only addition over stock Label: if the text passed to SetText carries
-- F.NewFeatureTrailingMarker (via F.NewFeatureTrailingText), that marker is
-- stripped and a real pulsing "NEW" badge (F.CreateNewFeatureBadge - the
-- same one used on tab labels) is attached right after the *last rendered
-- line* of the text. The text is often multi-line and word-wrapped, so that
-- line's pixel width is measured with a hidden helper FontString sharing the
-- label's own font object rather than assumed - keeps the badge landing in
-- the right spot across locales and panel widths instead of just at a fixed
-- offset.
local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type, Version = "MERNewFeatureLabel", 1

local max, select, pairs = math.max, select, pairs
local CreateFrame, UIParent = CreateFrame, UIParent

local UpdateNewBadge

local function UpdateImageAnchor(self)
	if self.resizing then
		return
	end
	local frame = self.frame
	local width = frame.width or frame:GetWidth() or 0
	local image = self.image
	local label = self.label
	local height

	label:ClearAllPoints()
	image:ClearAllPoints()

	if self.imageshown then
		local imagewidth = image:GetWidth()
		if (width - imagewidth) < 200 or (label:GetText() or "") == "" then
			image:SetPoint("TOP")
			label:SetPoint("TOP", image, "BOTTOM")
			label:SetPoint("LEFT")
			label:SetWidth(width)
			height = image:GetHeight() + label:GetStringHeight()
		else
			image:SetPoint("TOPLEFT")
			if image:GetHeight() > label:GetStringHeight() then
				label:SetPoint("LEFT", image, "RIGHT", 4, 0)
			else
				label:SetPoint("TOPLEFT", image, "TOPRIGHT", 4, 0)
			end
			label:SetWidth(width - imagewidth - 4)
			height = max(image:GetHeight(), label:GetStringHeight())
		end
	else
		label:SetPoint("TOPLEFT")
		label:SetWidth(width)
		height = label:GetStringHeight()
	end

	if not height or height == 0 then
		height = 1
	end

	self.resizing = true
	frame:SetHeight(height)
	frame.height = height
	self.resizing = nil

	UpdateNewBadge(self)
end

-- Re-run on every layout pass (called from UpdateImageAnchor, so on every
-- SetText/SetImage/SetFontObject/width change), not just once - AceGUI
-- re-lays this widget out with a placeholder width before the real panel
-- width is known, which changes how many lines the text wraps into.
UpdateNewBadge = function(self)
	local text = self.merLastText
	local isNew = text and text:find(F.NewFeatureTrailingMarker, 1, true) ~= nil

	local badge = F.SyncNewFeatureBadge(self, "merNewBadge", isNew, function()
		return F.CreateNewFeatureBadge(self.frame, "LEFT", self.label, "BOTTOMLEFT", 6, 9, 0.75)
	end)
	if not badge then
		return
	end

	local measure = self.merMeasure
	if not measure then
		measure = self.frame:CreateFontString(nil, "BACKGROUND")
		measure:Hide()
		self.merMeasure = measure
	end

	local lastLine = text:gsub(F.NewFeatureTrailingMarker, ""):match("([^\n]*)$") or ""
	measure:SetFontObject(self.label:GetFontObject())
	measure:SetText(lastLine)

	-- BOTTOMLEFT of a multi-line label sits at the last line's descender, not
	-- its vertical center - a plain y offset of half the line's own rendered
	-- height re-centers the badge on the text instead of hanging below it.
	badge:ClearAllPoints()
	badge:SetPoint("LEFT", self.label, "BOTTOMLEFT", measure:GetStringWidth() + 6, measure:GetStringHeight() / 2 + 2)
end

local methods = {
	["OnAcquire"] = function(self)
		self.resizing = true
		self:SetWidth(200)
		self:SetText()
		self:SetImage(nil)
		self:SetImageSize(16, 16)
		self:SetColor()
		self:SetFontObject()
		self:SetJustifyH("LEFT")
		self:SetJustifyV("TOP")

		self.resizing = nil
		UpdateImageAnchor(self)
	end,

	["OnWidthSet"] = function(self, width)
		UpdateImageAnchor(self)
	end,

	["SetText"] = function(self, text)
		text = text or ""
		self.merLastText = text
		self.label:SetText((text:gsub(F.NewFeatureTrailingMarker, "")))
		UpdateImageAnchor(self)
	end,

	["SetColor"] = function(self, r, g, b)
		if not (r and g and b) then
			r, g, b = 1, 1, 1
		end
		self.label:SetVertexColor(r, g, b)
	end,

	["SetImage"] = function(self, path, ...)
		local image = self.image
		image:SetTexture(path)

		if image:GetTexture() then
			self.imageshown = true
			local n = select("#", ...)
			if n == 4 or n == 8 then
				image:SetTexCoord(...)
			else
				image:SetTexCoord(0, 1, 0, 1)
			end
		else
			self.imageshown = nil
		end
		UpdateImageAnchor(self)
	end,

	["SetFont"] = function(self, font, height, flags)
		if not self.fontObject then
			self.fontObject = CreateFont("MERNewFeatureLabelFont" .. AceGUI:GetNextWidgetNum(Type))
		end
		self.fontObject:SetFont(font, height, flags)
		self:SetFontObject(self.fontObject)
	end,

	["SetFontObject"] = function(self, font)
		self.label:SetFontObject(font or GameFontHighlightSmall)
		UpdateImageAnchor(self)
	end,

	["SetImageSize"] = function(self, width, height)
		self.image:SetWidth(width)
		self.image:SetHeight(height)
		UpdateImageAnchor(self)
	end,

	["SetJustifyH"] = function(self, justifyH)
		self.label:SetJustifyH(justifyH)
	end,

	["SetJustifyV"] = function(self, justifyV)
		self.label:SetJustifyV(justifyV)
	end,
}

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local label = frame:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall")
	local image = frame:CreateTexture(nil, "BACKGROUND")

	local widget = {
		label = label,
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
