local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")
local LSM = E.LSM or E.Libs.LSM

local Type = "MERNameplateHealthPreview"
local Version = 1

local min = math.min
local CreateFrame, UIParent = CreateFrame, UIParent
local SetRaidTargetIconTexture = SetRaidTargetIconTexture

-- Sample health bars that explain the Hover Highlight, the Focus Highlight, the
-- Raid Marker Color and the Enemy Forces. Used as `dialogControl` on a
-- description whose name is the settings key under E.db.mui.nameplates
-- ("highlight", "focusHighlight", "markerColor" or "enemyForces"): one bar with
-- the highlight or focus texture, one bar per raid marker with its tint, or one
-- bar with the forces text.

local FORCES_SAMPLES = {
	PERCENT = "+1.25%",
	NUMBER = "+5",
	BOTH = "+5 (1.25%)",
}

local BAR_MAX_WIDTH = 360
local BAR_HEIGHT = 16
local BAR_SPACING = 6
local ICON_SIZE = 14
local HEALTH = 0.8
local NUM_MARKERS = 8
local RAID_ICONS = [[Interface\TargetingFrame\UI-RaidTargetingIcons]]

local function GetDB(key)
	local db = E.db.mui and E.db.mui.nameplates
	return db and db[key]
end

-- The color of a hostile unit, like a health bar without the indicator
local function GetBaseColor()
	local colors = E.db.nameplates and E.db.nameplates.colors
	local color = colors and colors.reactions and colors.reactions[1]
	if color then
		return color.r, color.g, color.b
	end

	return 0.8, 0.3, 0.21
end

-- Focus and hover highlight share the color modes
local function GetHighlightColor(db)
	if db.colorMode == "CUSTOM" then
		return db.customColor.r, db.customColor.g, db.customColor.b
	end

	local color = E:ClassColor(E.myclass, true)
	return color.r, color.g, color.b
end

local function Update(widget)
	local key = widget._key
	local db = key and GetDB(key)
	if not db then
		return
	end

	local isMarkers = key == "markerColor"
	local isForces = key == "enemyForces"
	local width = min(widget.frame:GetWidth(), BAR_MAX_WIDTH)
	local barWidth = width
	local barX = 0
	if isMarkers then
		barWidth = (width - BAR_SPACING * (NUM_MARKERS - 1)) / NUM_MARKERS
	elseif isForces then
		-- Room on both sides for a text next to the bar
		barWidth = width * 0.5
		barX = width * 0.25
	end

	local r, g, b = GetBaseColor()
	local barTexture = LSM:Fetch("statusbar", E.db.nameplates.statusbar)

	for index, bar in ipairs(widget.bars) do
		local shown = isMarkers or index == 1
		bar:SetShown(shown)

		if shown then
			bar:SetWidth(barWidth)
			bar:ClearAllPoints()
			bar:SetPoint(
				"TOPLEFT",
				widget.frame,
				"TOPLEFT",
				barX + (index - 1) * (barWidth + BAR_SPACING),
				-(ICON_SIZE + 4)
			)

			bar.fill:SetTexture(barTexture)
			bar.fill:SetVertexColor(r, g, b, 1)
			bar.fill:SetWidth(barWidth * HEALTH)

			bar.tint:SetShown(isMarkers)
			bar.icon:SetShown(isMarkers)
			bar.focus:SetShown(not isMarkers and not isForces)
			bar.text:SetShown(isForces)

			if isMarkers then
				local color = MER.RaidMarkerColors[index]
				bar.tint:SetColorTexture(color.r, color.g, color.b, db.alpha)
			elseif isForces then
				local text = bar.text
				text:SetFont(LSM:Fetch("font", E.db.nameplates.font), db.fontSize, E.db.nameplates.fontOutline)
				text:SetTextColor(db.color.r, db.color.g, db.color.b)
				text:SetText(FORCES_SAMPLES[db.format] or FORCES_SAMPLES.PERCENT)
				text:ClearAllPoints()
				text:SetPoint(E.InversePoints[db.position], bar, db.position, db.xOffset, db.yOffset)
			else
				-- The hover highlight sets its alpha on the texture and may blend additive
				local isHover = key == "highlight"
				local fr, fg, fb = GetHighlightColor(db)
				bar.focus:SetTexture(LSM:Fetch("statusbar", db.texture))
				bar.focus:SetVertexColor(fr, fg, fb, isHover and 1 or db.alpha)
				bar.focus:SetAlpha(isHover and db.alpha or 1)
				bar.focus:SetBlendMode(isHover and db.additive and "ADD" or "BLEND")
			end
		end
	end

	widget.frame:SetAlpha(db.enable and 1 or 0.4)
end

local function CreateBar(parent, index)
	local bar = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	bar:SetHeight(BAR_HEIGHT)
	bar:SetTemplate("Transparent")

	bar.fill = bar:CreateTexture(nil, "ARTWORK", nil, 1)
	bar.fill:SetPoint("TOPLEFT")
	bar.fill:SetPoint("BOTTOMLEFT")

	bar.tint = bar:CreateTexture(nil, "ARTWORK", nil, 2)
	bar.tint:SetAllPoints(bar.fill)

	bar.focus = bar:CreateTexture(nil, "ARTWORK", nil, 3)
	bar.focus:SetAllPoints(bar)

	bar.text = bar:CreateFontString(nil, "OVERLAY")
	bar.text:SetFont(F.GetFontPath(), 10, "OUTLINE")

	bar.icon = bar:CreateTexture(nil, "OVERLAY")
	bar.icon:SetSize(ICON_SIZE, ICON_SIZE)
	bar.icon:SetPoint("BOTTOM", bar, "TOP", 0, 2)
	bar.icon:SetTexture(RAID_ICONS)
	SetRaidTargetIconTexture(bar.icon, index)

	return bar
end

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetHeight(ICON_SIZE + BAR_HEIGHT + 12)
	frame:Hide()

	local bars = {}
	for index = 1, NUM_MARKERS do
		bars[index] = CreateBar(frame, index)
	end

	local widget = {
		type = Type,
		frame = frame,
		bars = bars,
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
