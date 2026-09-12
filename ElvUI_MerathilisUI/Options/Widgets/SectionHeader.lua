local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERSectionHeader"
local Version = 1

local pairs, unpack = pairs, unpack
local CreateFrame, UIParent = CreateFrame, UIParent

local ACCENT_WIDTH = 340

local COLOR_TEXT = { 1, 1, 1 }

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetText()
		self:SetFullWidth()
		self:SetHeight(38)
	end,

	["SetText"] = function(self, text)
		-- Callers mostly pass headers through F.cOption(..., "gradient") for an
		-- orange-to-white gradient, which is embedded as |c...|r escape codes
		-- and would otherwise override SetTextColor - clashing with the rest
		-- of the widget family, which never colors label text, only accents
		-- (knob/arrow/fill/underline). Strip those codes so headers read in
		-- the same plain white as everything else.
		text = text or ""

		local isNew = text:find(F.NewFeatureMarker, 1, true) ~= nil
		if isNew then
			text = text:gsub(F.NewFeatureMarker, "")
		end

		text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
		self.label:SetText(text)

		-- Anchored off the label's own rendered text width (not the label
		-- region, which spans the header's full width - the header's own
		-- TOPRIGHT is way out past the visible text, near the panel edge)
		-- so the badge sits right after the visible words. Repositioned on
		-- every SetText, not just on first creation, since the text (and so
		-- its width) can change on a later dialog refresh.
		local badge = F.SyncNewFeatureBadge(self, "newBadge", isNew, function()
			return F.CreateNewFeatureBadge(self.frame, "LEFT", self.label, "TOPLEFT", 0, -10, 0.7)
		end)
		if badge then
			badge:ClearAllPoints()
			badge:SetPoint("LEFT", self.label, "TOPLEFT", self.label:GetStringWidth() + 10, -10)
		end
	end,
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local label = frame:CreateFontString(nil, "BACKGROUND")
	label:SetPoint("TOPLEFT", 0, -2)
	label:SetPoint("RIGHT")
	label:SetHeight(20)
	label:SetJustifyH("LEFT")
	label:SetFont(F.GetFontPath(), 15, "")
	label:SetTextColor(unpack(COLOR_TEXT))
	label:SetShadowColor(0, 0, 0, 1)
	label:SetShadowOffset(2, -2)

	-- Short, solid accent underline below the label - flat like the rest of
	-- the widget family (MERToggleSwitch/MERSlider/etc.), not a fading glow.
	local underline = frame:CreateTexture(nil, "ARTWORK")
	underline:SetSize(ACCENT_WIDTH, 2)
	underline:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -5)
	underline:SetColorTexture(I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b, 1)

	local widget = {
		label = label,
		underline = underline,
		frame = frame,
		type = Type,
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
