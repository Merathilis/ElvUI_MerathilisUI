local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")
local LSM = E.LSM or E.Libs.LSM

local Type = "MERTagPreview"
local Version = 1

local _G = _G
local floor, ipairs, max, min, tinsert = math.floor, ipairs, math.max, math.min, tinsert
local CreateFrame, UIParent = CreateFrame, UIParent

-- Sample unit frames with the [name:MER:gradient] tag of Core/Tags.lua, so the
-- Tags page shows how it looks in game: the player and a few classes in the
-- first row, the NPC reactions in the second. Used as `dialogControl` on a
-- description and laid out like the cards in InfoCards.lua.

local GAP = 8
local ROW_GAP = GAP - 3
local PADDING = 10
local SPACING = 6
local COLUMNS = 4
local ROWS = 2
local BAR_HEIGHT = 22
local BAR_MAX_WIDTH = 180
local TEXT_INSET = 4

-- Health of the sample frames per column, so the bars don't all look the same
local HEALTH = { 1, 0.82, 0.64, 0.45 }

-- Picked in this order, the player's own class is skipped
local SAMPLE_CLASSES = { "WARRIOR", "MAGE", "HUNTER", "PRIEST" }

-- Gradient key of F.GradientName -> reaction label, same keys as Core/Tags.lua
local SAMPLE_REACTIONS = {
	{ "NPCHOSTILE", _G.FACTION_STANDING_LABEL2 },
	{ "NPCUNFRIENDLY", _G.FACTION_STANDING_LABEL3 },
	{ "NPCNEUTRAL", _G.FACTION_STANDING_LABEL4 },
	{ "NPCFRIENDLY", _G.FACTION_STANDING_LABEL5 },
}

local samples

local function GetSamples()
	if samples then
		return samples
	end

	samples = { { name = E.myname, key = E.myclass } }
	for _, class in ipairs(SAMPLE_CLASSES) do
		if class ~= E.myclass and #samples < COLUMNS then
			tinsert(samples, { name = _G.LOCALIZED_CLASS_NAMES_MALE[class] or class, key = class })
		end
	end

	for _, reaction in ipairs(SAMPLE_REACTIONS) do
		tinsert(samples, { name = reaction[2], key = reaction[1] })
	end

	return samples
end

local function Update(widget)
	local db = E.db.unitframe
	local barTexture = LSM:Fetch("statusbar", db.statusbar)
	local healthColor = db.colors and db.colors.health
	local r, g, b = 0.31, 0.31, 0.31
	if healthColor then
		r, g, b = healthColor.r, healthColor.g, healthColor.b
	end

	local width = (widget.frame.width or widget.frame:GetWidth() or 0) - GAP - 1 - PADDING * 2
	local barWidth = max(min(floor((width - SPACING * (COLUMNS - 1)) / COLUMNS), BAR_MAX_WIDTH), 1)

	for index, sample in ipairs(GetSamples()) do
		local bar = widget.bars[index]
		local column = (index - 1) % COLUMNS
		local row = floor((index - 1) / COLUMNS)
		local health = HEALTH[column + 1]

		bar:SetSize(barWidth, BAR_HEIGHT)
		bar:ClearAllPoints()
		bar:SetPoint(
			"TOPLEFT",
			widget.card,
			"TOPLEFT",
			PADDING + column * (barWidth + SPACING),
			-(PADDING + row * (BAR_HEIGHT + SPACING))
		)

		bar.fill:SetTexture(barTexture)
		bar.fill:SetVertexColor(r, g, b, 1)
		bar.fill:SetWidth(max((barWidth - 2) * health, 1))

		-- isUnit like the tag, so it also shows the flat color it falls back to in instances
		bar.name:FontTemplate(db.font, db.fontSize, db.fontOutline, true)
		bar.name:SetText(F.GradientName(sample.name, sample.key, false, true))
		bar.value:FontTemplate(db.font, db.fontSize, db.fontOutline, true)
		bar.value:SetText(floor(health * 100 + 0.5) .. "%")
	end
end

local function CreateBar(parent)
	local bar = CreateFrame("Frame", nil, parent)
	bar:SetTemplate()

	bar.fill = bar:CreateTexture(nil, "ARTWORK")
	bar.fill:SetPoint("TOPLEFT", 1, -1)
	bar.fill:SetPoint("BOTTOMLEFT", 1, 1)

	bar.value = bar:CreateFontString(nil, "OVERLAY")
	bar.value:SetPoint("RIGHT", -TEXT_INSET, 0)
	bar.value:SetJustifyH("RIGHT")

	bar.name = bar:CreateFontString(nil, "OVERLAY")
	bar.name:SetPoint("LEFT", TEXT_INSET, 0)
	bar.name:SetPoint("RIGHT", bar.value, "LEFT", -TEXT_INSET, 0)
	bar.name:SetJustifyH("LEFT")
	bar.name:SetWordWrap(false)

	return bar
end

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetHeight(PADDING + ROWS * BAR_HEIGHT + (ROWS - 1) * SPACING + PADDING + ROW_GAP)
	frame:Hide()

	local card = CreateFrame("Frame", nil, frame)
	-- Same inset as the cards in InfoCards.lua, so the edges line up
	card:SetPoint("TOPLEFT", 1, 0)
	card:SetPoint("BOTTOMRIGHT", -GAP, ROW_GAP)
	card:CreateBackdrop("Transparent", nil, true)

	local bars = {}
	for index = 1, COLUMNS * ROWS do
		bars[index] = CreateBar(card)
	end

	local widget = {
		type = Type,
		frame = frame,
		card = card,
		bars = bars,
	}

	widget.OnAcquire = function(self)
		self.frame:Show()
	end

	widget.OnRelease = function(self)
		self.frame:Hide()
	end

	widget.SetText = function(self)
		Update(self)
	end

	-- Full width rows get their width from the layout after SetText
	widget.OnWidthSet = function(self)
		Update(self)
	end

	widget.SetLabel = function() end
	widget.SetDisabled = function() end
	widget.SetImage = function() end
	widget.SetImageSize = function() end
	widget.SetFontObject = function() end
	widget.SetJustifyH = function() end
	widget.SetJustifyV = function() end
	widget.SetColor = function() end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
