local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERInterruptReadyPreview"
local Version = 1

local min = math.min
local CreateColor = CreateColor
local CreateFrame, UIParent = CreateFrame, UIParent

-- Sample castbar that explains the Interrupt Ready indicator. Used as
-- `dialogControl` on a description whose name is the settings key
-- ("unitframes" or "nameplates"), so it shows the colors and toggles of that
-- module: the cast is at CAST, the interrupt is ready again at READY.

local BAR_MAX_WIDTH = 360
local BAR_HEIGHT = 18
local LABEL_GAP = 4
local CAST = 0.55
local READY = 0.75

local function GetDB(key)
	local db = E.db.mui and E.db.mui[key]
	return db and db.interruptReady
end

local function ApplyColor(texture, entry)
	local theme = E.db.mui.themes.gradientMode
	local normal = theme.castColorMap[I.Enum.GradientMode.Color.NORMAL][entry]
	local shift = theme.castColorMap[I.Enum.GradientMode.Color.SHIFT][entry]

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

	local width = min(widget.frame:GetWidth(), BAR_MAX_WIDTH)
	widget.bar:SetWidth(width)

	local castX, readyX = width * CAST, width * READY

	widget.tint:SetWidth(castX)
	ApplyColor(widget.tint, "INTERRUPTCD")
	widget.tint:SetShown(db.tint)
	widget.tintLabel:SetShown(db.tint)
	widget.tintLabel:ClearAllPoints()
	widget.tintLabel:SetPoint("BOTTOM", widget.bar, "TOPLEFT", castX / 2, LABEL_GAP)

	widget.window:ClearAllPoints()
	widget.window:SetPoint("TOPLEFT", widget.bar, "TOPLEFT", readyX, 0)
	widget.window:SetPoint("BOTTOMRIGHT", widget.bar, "BOTTOMRIGHT")
	ApplyColor(widget.window, "INTERRUPTSOON")
	widget.window:SetShown(db.window)
	widget.windowLabel:SetShown(db.window)
	widget.windowLabel:ClearAllPoints()
	widget.windowLabel:SetPoint("TOP", widget.bar, "BOTTOMLEFT", (readyX + width) / 2, -LABEL_GAP)

	widget.tick:ClearAllPoints()
	widget.tick:SetPoint("TOP", widget.bar, "TOPLEFT", readyX, 0)
	widget.tick:SetPoint("BOTTOM", widget.bar, "BOTTOMLEFT", readyX, 0)
	widget.tick:SetColorTexture(db.tickColor.r, db.tickColor.g, db.tickColor.b, 1)
	widget.tick:SetShown(db.tick)
	widget.tickLabel:SetShown(db.tick)
	widget.tickLabel:ClearAllPoints()
	widget.tickLabel:SetPoint("BOTTOM", widget.bar, "TOPLEFT", readyX, LABEL_GAP)

	widget.spark:ClearAllPoints()
	widget.spark:SetPoint("CENTER", widget.bar, "LEFT", castX, 0)

	-- Keep the labels apart when both sit above the bar
	if db.tint and db.tick then
		widget.tintLabel:ClearAllPoints()
		widget.tintLabel:SetPoint("BOTTOMRIGHT", widget.tickLabel, "BOTTOMLEFT", -12, 0)
	end

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
	frame:SetHeight(BAR_HEIGHT + 42)
	frame:Hide()

	-- The bar sits in the middle, the labels above and below it
	local bar = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	bar:SetHeight(BAR_HEIGHT)
	bar:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -20)
	bar:SetTemplate("Transparent")

	local tint = bar:CreateTexture(nil, "ARTWORK", nil, 1)
	tint:SetPoint("TOPLEFT")
	tint:SetPoint("BOTTOMLEFT")

	local window = bar:CreateTexture(nil, "ARTWORK", nil, 2)

	local spark = bar:CreateTexture(nil, "OVERLAY", nil, 1)
	spark:SetTexture(E.Media.Textures.Spark)
	spark:SetBlendMode("ADD")
	spark:SetSize(12, BAR_HEIGHT * 2)

	local tick = bar:CreateTexture(nil, "OVERLAY", nil, 3)
	tick:SetWidth(2)

	local widget = {
		type = Type,
		frame = frame,
		bar = bar,
		tint = tint,
		window = window,
		spark = spark,
		tick = tick,
		tintLabel = CreateLabel(frame, L["Cooldown Color"]),
		tickLabel = CreateLabel(frame, L["Ready Tick"]),
		windowLabel = CreateLabel(frame, L["Ready Window"]),
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
