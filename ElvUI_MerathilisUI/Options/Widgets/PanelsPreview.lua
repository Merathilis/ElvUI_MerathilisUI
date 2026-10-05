local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local pairs = pairs
local CreateColor = CreateColor
local CreateFrame = CreateFrame

-- The top and the bottom edge of the screen with the Panels module. Used as
-- `dialogControl` on a description named "panels". The width is squeezed to
-- fit the options (the style panels keep their share of the screen width),
-- heights are drawn in real size so the thin style bars stay visible. Layout
-- and colors follow Modules/Panels/Panels.lua.

local HEIGHT = 150
local TOP_STRIP = 70
local STRIP_GAP = 12
local BOTTOM_STRIP = HEIGHT - TOP_STRIP - STRIP_GAP
local STYLE_HEIGHT = 4
local TOP_EXTRA, BOTTOM_EXTRA = 36, 28

local CLEAR = CreateColor(0, 0, 0, 0)
local SHADE = CreateColor(0, 0, 0, 0.5)
local BLACK = CreateColor(0, 0, 0, 1)

-- key, strip, horizontal side and vertical direction of each style panel
local STYLES = {
	topLeftPanel = { extra = "topLeftExtraPanel", top = true, left = true },
	topRightPanel = { extra = "topRightExtraPanel", top = true, left = false },
	bottomLeftPanel = { extra = "bottomLeftExtraPanel", top = false, left = true },
	bottomRightPanel = { extra = "bottomRightExtraPanel", top = false, left = false },
}

local function GetPanelColor(db)
	if db.colorType == "CUSTOM" then
		return db.customColor.r, db.customColor.g, db.customColor.b
	elseif db.colorType == "CLASS" then
		local color = E:ClassColor(E.myclass, true)
		return color.r, color.g, color.b
	end

	return 1, 1, 1
end

local function CreateStrip(parent)
	local strip = CreateFrame("Frame", nil, parent)
	strip:SetClipsChildren(true)

	-- A dim stand-in for the game world behind the panels
	strip.bg = strip:CreateTexture(nil, "BACKGROUND")
	strip.bg:SetAllPoints()
	strip.bg:SetColorTexture(0.25, 0.27, 0.3, 0.6)

	strip.panel = CreateFrame("Frame", nil, strip, "BackdropTemplate")
	strip.panel:SetTemplate("Transparent")

	-- Style panels draw above the full width panel
	strip.styleLayer = CreateFrame("Frame", nil, strip)
	strip.styleLayer:SetAllPoints()
	strip.styleLayer:SetFrameLevel(strip.panel:GetFrameLevel() + 2)

	return strip
end

local function Build(widget)
	local frame = widget.frame
	widget.top = CreateStrip(frame)
	widget.top:SetPoint("TOPLEFT")
	widget.top:SetPoint("TOPRIGHT")
	widget.top:SetHeight(TOP_STRIP)

	widget.bottom = CreateStrip(frame)
	widget.bottom:SetPoint("BOTTOMLEFT")
	widget.bottom:SetPoint("BOTTOMRIGHT")
	widget.bottom:SetHeight(BOTTOM_STRIP)

	widget.styles = {}
	for key, info in pairs(STYLES) do
		local layer = (info.top and widget.top or widget.bottom).styleLayer
		widget.styles[key] = {
			bar = layer:CreateTexture(nil, "ARTWORK"),
			extra = layer:CreateTexture(nil, "BORDER"),
			line = layer:CreateTexture(nil, "ARTWORK"),
		}
		for _, texture in pairs(widget.styles[key]) do
			texture:SetTexture(E.media.blankTex)
		end
	end
end

local function PlaceFullPanel(strip, isTop, height)
	local panel = strip.panel
	panel:ClearAllPoints()
	-- The panels reach 3 pixels past the screen edge and 8 past its sides
	if isTop then
		panel:SetPoint("TOPLEFT", strip, "TOPLEFT", -8, 3)
		panel:SetPoint("TOPRIGHT", strip, "TOPRIGHT", 8, 3)
	else
		panel:SetPoint("BOTTOMLEFT", strip, "BOTTOMLEFT", -8, -3)
		panel:SetPoint("BOTTOMRIGHT", strip, "BOTTOMRIGHT", 8, -3)
	end
	panel:SetHeight(height)
end

local function UpdateStyle(widget, key, info, db, width, r, g, b)
	local parts = widget.styles[key]
	local strip = info.top and widget.top or widget.bottom
	local shown = db.stylePanels[key]
	local extraShown = shown and db.stylePanels[info.extra]

	parts.bar:SetShown(shown)
	parts.extra:SetShown(extraShown)
	parts.line:SetShown(extraShown)
	if not shown then
		return
	end

	local side = info.left and "LEFT" or "RIGHT"
	local edge = info.top and "TOP" or "BOTTOM"
	local x = info.left and 2 or -2
	local sign = info.top and -1 or 1
	local extraHeight = info.top and TOP_EXTRA or BOTTOM_EXTRA

	-- The bar fades from the panel color to black, like SkinPanel
	local bar = parts.bar
	bar:SetSize(width, STYLE_HEIGHT)
	bar:ClearAllPoints()
	bar:SetPoint(edge .. side, strip, edge .. side, x, sign * (info.top and 8 or 10))
	bar:SetGradient("VERTICAL", CreateColor(r, g, b, 1), BLACK)

	-- A shade that fades out towards the screen center, with a colored line at its inner edge
	local extra = parts.extra
	extra:SetSize(width, extraHeight)
	extra:ClearAllPoints()
	extra:SetPoint(edge .. side, strip, edge .. side, x, sign * (info.top and 14 or 16))

	local line = parts.line
	line:SetSize(width, E.mult)
	line:ClearAllPoints()
	if info.top then
		line:SetPoint("TOP", extra, "BOTTOM")
	else
		line:SetPoint("BOTTOM", extra, "TOP")
	end

	local strong = CreateColor(r, g, b, 0.7)
	local faded = CreateColor(r, g, b, 0)
	if info.left then
		extra:SetGradient("HORIZONTAL", SHADE, CLEAR)
		line:SetGradient("HORIZONTAL", strong, faded)
	else
		extra:SetGradient("HORIZONTAL", CLEAR, SHADE)
		line:SetGradient("HORIZONTAL", faded, strong)
	end
end

local function Update(widget)
	local db = E.db.mui.panels
	local frameWidth = widget.frame:GetWidth()

	widget.top.panel:SetShown(db.topPanel)
	PlaceFullPanel(widget.top, true, db.topPanelHeight)
	widget.bottom.panel:SetShown(db.bottomPanel)
	PlaceFullPanel(widget.bottom, false, db.bottomPanelHeight)

	-- Style panels keep their share of the screen width
	local screenWidth = E.UIParent:GetWidth()
	local width = screenWidth > 0 and db.panelSize * frameWidth / screenWidth or db.panelSize
	width = width > 1 and width or 1

	local r, g, b = GetPanelColor(db)
	for key, info in pairs(STYLES) do
		UpdateStyle(widget, key, info, db, width, r, g, b)
	end
end

Preview.Register("MERPanelsPreview", 1, HEIGHT, Build, Update)
