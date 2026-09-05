local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERSectionHeader"
local Version = 1

local pairs = pairs
local CreateFrame, UIParent = CreateFrame, UIParent

local ACCENT_WIDTH = 340

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
		-- Visual restyle only - text is passed through unmodified so any embedded
		-- WoW color escape codes (e.g. from F.cOption) keep working.
		self.label:SetText(text or "")
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
	label:SetTextColor(0.62, 0.62, 0.65)

	-- Short, subtle accent underline below the label - not a full-width bar
	local underline = frame:CreateTexture(nil, "ARTWORK")
	underline:SetSize(ACCENT_WIDTH, 2)
	underline:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -5)
	underline:SetBlendMode("ADD")
	underline:SetColorTexture(1, 1, 1, 1)
	F.Color.SetGradientRGB(underline, "HORIZONTAL", I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b, 0.5, I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b, 0)

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
