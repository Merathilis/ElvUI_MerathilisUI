local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERCastbarShieldPreview"
local Version = 1

local max, min = math.max, math.min
local unpack = unpack
local CreateColor = CreateColor
local CreateFrame, UIParent = CreateFrame, UIParent
local C_Spell_GetSpellName = C_Spell and C_Spell.GetSpellName
local C_Spell_GetSpellTexture = C_Spell and C_Spell.GetSpellTexture

-- Sample castbar that shows the Castbar Shield. Used as `dialogControl` on a
-- description whose name is the settings key ("unitframes" or "nameplates").
-- The bar has the height of the ElvUI castbar it stands for (target frame,
-- enemy nameplate), so the shield size and offsets look like in the game.

local BAR_MAX_WIDTH = 360
local MIN_HEIGHT, MAX_HEIGHT = 8, 40
local PADDING = 24
local CAST = 0.55
local SAMPLE_SPELL = 133 -- Fireball

local function GetDB(key)
	local db = E.db.mui and E.db.mui[key]
	return db and db.castbarShield
end

-- Height and icon of the ElvUI castbar the preview stands for
local function GetCastbarInfo(key)
	if key == "unitframes" then
		local castbar = E.db.unitframe.units.target.castbar
		return castbar.height, castbar.icon and castbar.iconAttached
	end

	return E.db.nameplates.units.ENEMY_NPC.castbar.height, false
end

-- The "not interruptible" cast color, from the Theme when it is on
local function ApplyColor(texture, key)
	local theme = E.db.mui.themes.gradientMode

	texture:SetColorTexture(1, 1, 1, 1)
	if theme.enable then
		local normal = theme.castColorMap[I.Enum.GradientMode.Color.NORMAL].NOINTERRUPT
		local shift = theme.castColorMap[I.Enum.GradientMode.Color.SHIFT].NOINTERRUPT
		texture:SetGradient(
			"HORIZONTAL",
			CreateColor(shift.r, shift.g, shift.b, 1),
			CreateColor(normal.r, normal.g, normal.b, 1)
		)
		return
	end

	local color = key == "unitframes" and E.db.unitframe.colors.castNoInterrupt
		or E.db.nameplates.colors.castNoInterruptColor
	texture:SetVertexColor(color.r, color.g, color.b, 1)
end

local function Update(widget)
	local key = widget._key
	local db = key and GetDB(key)
	if not db then
		return
	end

	local height, showIcon = GetCastbarInfo(key)
	height = min(max(height or MIN_HEIGHT, MIN_HEIGHT), MAX_HEIGHT)

	-- An attached icon is a square of the bar's height in front of it
	widget.icon:SetSize(height, height)
	widget.icon:SetShown(showIcon)
	local left = PADDING + (showIcon and height + 1 or 0)

	local bar = widget.bar
	local width = min(widget.frame:GetWidth() - left - PADDING, BAR_MAX_WIDTH)
	bar:ClearAllPoints()
	bar:SetPoint("LEFT", widget.frame, "LEFT", left, 0)
	bar:SetSize(width, height)

	local castX = width * CAST
	widget.fill:SetWidth(castX)
	ApplyColor(widget.fill, key)

	widget.spark:SetSize(12, height * 2)
	widget.spark:ClearAllPoints()
	widget.spark:SetPoint("CENTER", bar, "LEFT", castX, 0)

	-- The same math as the castbar in the game
	local shield = widget.shield
	shield:SetSize(db.size * MER.CastbarShield.ASPECT, db.size)
	shield:ClearAllPoints()
	shield:SetPoint("CENTER", bar, db.anchorPoint, db.xOffset, db.yOffset)

	widget.frame:SetAlpha(db.enable and 1 or 0.4)
end

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetHeight(MAX_HEIGHT + 30)
	frame:Hide()

	local bar = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	bar:SetTemplate("Transparent")

	local fill = bar:CreateTexture(nil, "ARTWORK", nil, 1)
	fill:SetPoint("TOPLEFT")
	fill:SetPoint("BOTTOMLEFT")

	local spark = bar:CreateTexture(nil, "OVERLAY", nil, 1)
	spark:SetTexture(E.Media.Textures.Spark)
	spark:SetBlendMode("ADD")

	local spellText = bar:CreateFontString(nil, "OVERLAY")
	spellText:SetFont(F.GetFontPath(), 11, "OUTLINE")
	spellText:SetPoint("LEFT", bar, "LEFT", 4, 0)
	spellText:SetText(C_Spell_GetSpellName and C_Spell_GetSpellName(SAMPLE_SPELL) or "")

	local icon = frame:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("RIGHT", bar, "LEFT", -1, 0)
	icon:SetTexture(C_Spell_GetSpellTexture and C_Spell_GetSpellTexture(SAMPLE_SPELL) or 136243)
	icon:SetTexCoord(unpack(E.TexCoords))

	-- Above the spell text, like on the castbar
	local overlay = CreateFrame("Frame", nil, frame)
	overlay:SetAllPoints(frame)
	overlay:SetFrameLevel(bar:GetFrameLevel() + 3)

	local shield = overlay:CreateTexture(nil, "OVERLAY")
	shield:SetAtlas(MER.CastbarShield.ATLAS)

	local widget = {
		type = Type,
		frame = frame,
		bar = bar,
		fill = fill,
		spark = spark,
		icon = icon,
		shield = shield,
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
