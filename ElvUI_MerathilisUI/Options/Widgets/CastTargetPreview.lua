local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERCastTargetPreview"
local Version = 1

local min = math.min
local pairs = pairs
local CreateColor = CreateColor
local CreateFrame, UIParent = CreateFrame, UIParent
local C_Spell_GetSpellName = C_Spell and C_Spell.GetSpellName

-- Sample castbar that explains the Cast on You indicator. Used as
-- `dialogControl` on a description whose name is the settings key
-- ("nameplates"), so it shows the color and toggles of that module: a cast
-- on the player that is at CAST.

local BAR_MAX_WIDTH = 360
local BAR_HEIGHT = 18
local LABEL_GAP = 4
local CAST = 0.55
local SAMPLE_SPELL = 133 -- Fireball

local BORDER_SIDES = { "top", "bottom", "left", "right" }

local function GetDB(key)
	local db = E.db.mui and E.db.mui[key]
	return db and db.castTarget
end

-- The default cast color of the Theme, like a castbar without the indicator
local function ApplyThemeColor(texture)
	local theme = E.db.mui.themes.gradientMode
	local normal = theme.castColorMap[I.Enum.GradientMode.Color.NORMAL].DEFAULT
	local shift = theme.castColorMap[I.Enum.GradientMode.Color.SHIFT].DEFAULT

	texture:SetColorTexture(1, 1, 1, 1)
	if theme.enable then
		texture:SetGradient(
			"HORIZONTAL",
			CreateColor(shift.r, shift.g, shift.b, 1),
			CreateColor(normal.r, normal.g, normal.b, 1)
		)
	else
		texture:SetVertexColor(normal.r, normal.g, normal.b, 1)
	end
end

local function Update(widget)
	local db = widget._key and GetDB(widget._key)
	if not db then
		return
	end

	local bar = widget.bar
	-- The bar is inset by the widest border on both sides
	local width = min(widget.frame:GetWidth() - 10, BAR_MAX_WIDTH)
	bar:SetWidth(width)

	local castX = width * CAST
	local color = db.color
	local size = db.borderSize

	widget.fill:SetWidth(castX)
	if db.tint then
		widget.fill:SetColorTexture(color.r, color.g, color.b, 1)
	else
		ApplyThemeColor(widget.fill)
	end

	for _, side in pairs(BORDER_SIDES) do
		local texture = widget.border[side]
		texture:ClearAllPoints()
		texture:SetColorTexture(color.r, color.g, color.b, 1)
		texture:SetShown(db.border)
	end

	widget.border.top:SetPoint("BOTTOMLEFT", bar, "TOPLEFT", -size, 0)
	widget.border.top:SetPoint("BOTTOMRIGHT", bar, "TOPRIGHT", size, 0)
	widget.border.top:SetHeight(size)

	widget.border.bottom:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", -size, 0)
	widget.border.bottom:SetPoint("TOPRIGHT", bar, "BOTTOMRIGHT", size, 0)
	widget.border.bottom:SetHeight(size)

	widget.border.left:SetPoint("TOPRIGHT", bar, "TOPLEFT")
	widget.border.left:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT")
	widget.border.left:SetWidth(size)

	widget.border.right:SetPoint("TOPLEFT", bar, "TOPRIGHT")
	widget.border.right:SetPoint("BOTTOMLEFT", bar, "BOTTOMRIGHT")
	widget.border.right:SetWidth(size)

	-- The labels stay clear of the border
	local gap = LABEL_GAP + (db.border and size or 0)

	widget.borderLabel:SetShown(db.border)
	widget.borderLabel:ClearAllPoints()
	widget.borderLabel:SetPoint("BOTTOM", bar, "TOP", 0, gap)

	widget.tintLabel:SetShown(db.tint)
	widget.tintLabel:ClearAllPoints()
	widget.tintLabel:SetPoint("TOP", bar, "BOTTOMLEFT", castX / 2, -gap)

	widget.spark:ClearAllPoints()
	widget.spark:SetPoint("CENTER", bar, "LEFT", castX, 0)

	widget.frame:SetAlpha(db.enable and 1 or 0.4)
end

local function CreateLabel(parent, text)
	local label = parent:CreateFontString(nil, "OVERLAY")
	label:SetFont(F.GetFontPath(), 11, "OUTLINE")
	label:SetTextColor(1, 1, 1)
	label:SetText(text)
	return label
end

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetHeight(BAR_HEIGHT + 52)
	frame:Hide()

	-- The bar sits in the middle, the labels above and below it
	local bar = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	bar:SetHeight(BAR_HEIGHT)
	bar:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -25)
	bar:SetTemplate("Transparent")

	local fill = bar:CreateTexture(nil, "ARTWORK", nil, 1)
	fill:SetPoint("TOPLEFT")
	fill:SetPoint("BOTTOMLEFT")

	local spark = bar:CreateTexture(nil, "OVERLAY", nil, 1)
	spark:SetTexture(E.Media.Textures.Spark)
	spark:SetBlendMode("ADD")
	spark:SetSize(12, BAR_HEIGHT * 2)

	-- Spell and target, the way ElvUI writes them with Display Target
	local classColor = E:ClassColor(E.myclass, true)
	local spellText = bar:CreateFontString(nil, "OVERLAY")
	spellText:SetFont(F.GetFontPath(), 11, "OUTLINE")
	spellText:SetPoint("LEFT", bar, "LEFT", 4, 0)
	spellText:SetFormattedText(
		"%s: |c%s%s|r",
		C_Spell_GetSpellName and C_Spell_GetSpellName(SAMPLE_SPELL) or "",
		classColor.colorStr,
		E.myname
	)

	local border = {}
	for _, side in pairs(BORDER_SIDES) do
		border[side] = frame:CreateTexture(nil, "OVERLAY")
	end

	local widget = {
		type = Type,
		frame = frame,
		bar = bar,
		fill = fill,
		spark = spark,
		border = border,
		borderLabel = CreateLabel(frame, L["Castbar Border"]),
		tintLabel = CreateLabel(frame, L["Castbar Color"]),
	}

	widget.OnAcquire = function(self)
		self.frame:Show()
	end

	widget.OnRelease = function(self)
		self.frame:Hide()
		self._key = nil
	end

	widget.SetText = function(self, text)
		self._key = text ~= "" and text or nil
		Update(self)
	end

	widget.SetWidth = function(self, width)
		self.frame:SetWidth(width)
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
