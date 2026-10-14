local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local LSM = E.LSM or E.Libs.LSM

local min = math.min
local CreateFrame = CreateFrame
local GetAverageItemLevel = GetAverageItemLevel

-- The Durability/ Ilevel datatext at full, warning and critical durability.
-- Used as `dialogControl` on a description named "durabilityIlevel". The text
-- comes from the datatext itself (MER.DurabilityIlevelText), with ElvUI's
-- datatext font and your equipped item level.

local HEIGHT = 34
local PANEL_HEIGHT = 22
local PANEL_MAX_WIDTH = 200
local PANEL_GAP = 8
local NUM_PANELS = 3

-- Without own colors the datatext only turns orange at 15% and below
local DEFAULT_SAMPLES = { 100, 50, 15 }

local function GetSamples(db)
	if db.colored.enable then
		return 100, db.colored.a.value, db.colored.b.value
	end

	return DEFAULT_SAMPLES[1], DEFAULT_SAMPLES[2], DEFAULT_SAMPLES[3]
end

local function Build(widget)
	widget.panels = {}
	for index = 1, NUM_PANELS do
		local panel = CreateFrame("Frame", nil, widget.frame, "BackdropTemplate")
		panel:SetTemplate("Transparent")
		panel.text = panel:CreateFontString(nil, "OVERLAY")
		panel.text:SetPoint("CENTER")
		widget.panels[index] = panel
	end
end

local function Update(widget)
	local db = E.db.mui.datatexts.durabilityIlevel
	if not MER.DurabilityIlevelText then
		return
	end

	local width = min((widget.frame:GetWidth() - PANEL_GAP * (NUM_PANELS - 1)) / NUM_PANELS, PANEL_MAX_WIDTH)
	width = width > 1 and width or 1
	local totalWidth = width * NUM_PANELS + PANEL_GAP * (NUM_PANELS - 1)

	local font = LSM:Fetch("font", E.db.datatexts.font)
	local _, avgEquipped = GetAverageItemLevel()
	local samples = { GetSamples(db) }

	for index, panel in ipairs(widget.panels) do
		panel:SetSize(width, PANEL_HEIGHT)
		panel:ClearAllPoints()
		panel:SetPoint("LEFT", widget.frame, "CENTER", -totalWidth / 2 + (index - 1) * (width + PANEL_GAP), 0)

		panel.text:FontTemplate(font, E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		panel.text:SetText(MER.DurabilityIlevelText(db, samples[index], avgEquipped))
	end
end

Preview.Register("MERDurabilityPreview", 1, HEIGHT, Build, Update)
