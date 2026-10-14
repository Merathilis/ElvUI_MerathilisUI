local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local format = format
local max, min = math.max, math.min
local CreateColor = CreateColor
local CreateFrame = CreateFrame

-- The Location Panel above the top of a sample Minimap, with your current zone
-- and live coordinates. Used as `dialogControl` on a description named
-- "locationPanel". Text, color, coordinates and the layout of the three texts
-- follow Modules/Maps/LocationPanel.lua; the zone text and its color come from
-- the module's own functions.

local PADDING = 8
-- How much of the Minimap is shown below the panel
local MINIMAP_PART = 46
local INSET = 3
local COORDS_INTERVAL = 0.1

local COORDS_SAMPLE = {
	["%.0f"] = "100",
	["%.1f"] = "100.0",
	["%.2f"] = "100.00",
}

local function UpdateCoords(widget)
	local db = E.db.mui.locationPanel
	local mapInfo = E.MapInfo
	local x, y = mapInfo and mapInfo.xText, mapInfo and mapInfo.yText
	widget.coordX:SetText(x and format(db.coordsFormat, x) or "-")
	widget.coordY:SetText(y and format(db.coordsFormat, y) or "-")
end

local function OnUpdate(frame, elapsed)
	frame.elapsed = (frame.elapsed or 0) + elapsed
	if frame.elapsed < COORDS_INTERVAL then
		return
	end

	frame.elapsed = 0
	if E.db.mui.locationPanel.coords then
		UpdateCoords(frame.obj)
	end
end

local function Build(widget)
	local frame = widget.frame
	frame.obj = widget
	frame:SetClipsChildren(true)

	-- The Minimap runs past the bottom edge, only its top is shown
	local minimap = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	minimap:SetTemplate()
	minimap.fill = minimap:CreateTexture(nil, "ARTWORK")
	minimap.fill:SetInside()
	minimap.fill:SetTexture(E.media.blankTex)
	minimap.fill:SetGradient("VERTICAL", CreateColor(0.12, 0.2, 0.14, 1), CreateColor(0.2, 0.3, 0.22, 1))
	widget.minimap = minimap

	local panel = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	panel:SetTemplate("Transparent")
	panel:SetFrameLevel(minimap:GetFrameLevel() + 5)
	widget.panel = panel

	widget.text = panel:CreateFontString(nil, "OVERLAY")
	widget.text:FontTemplate()
	widget.text:SetJustifyH("CENTER")
	widget.text:SetWordWrap(false)

	widget.coordX = panel:CreateFontString(nil, "OVERLAY")
	widget.coordX:FontTemplate()
	widget.coordX:SetJustifyH("LEFT")
	widget.coordX:SetWordWrap(false)

	widget.coordY = panel:CreateFontString(nil, "OVERLAY")
	widget.coordY:FontTemplate()
	widget.coordY:SetJustifyH("RIGHT")
	widget.coordY:SetWordWrap(false)

	frame:SetScript("OnUpdate", OnUpdate)
end

-- X left, zone in the middle, Y right; the zone keeps the same inset on both sides
local function LayoutTexts(widget, db)
	local panel = widget.panel
	local inset = INSET

	if db.coords then
		for _, coord in ipairs({ widget.coordX, widget.coordY }) do
			WF.SetFontWithDB(coord, db.font)
			WF.SetFontColorWithDB(coord, db.coordsColor)
		end

		widget.coordX:SetText(COORDS_SAMPLE[db.coordsFormat] or COORDS_SAMPLE["%.1f"])
		local coordWidth = widget.coordX:GetUnboundedStringWidth() + 1
		widget.coordX:SetWidth(coordWidth)
		widget.coordY:SetWidth(coordWidth)

		widget.coordX:ClearAllPoints()
		widget.coordX:SetPoint("LEFT", panel, "LEFT", INSET, 0)
		widget.coordY:ClearAllPoints()
		widget.coordY:SetPoint("RIGHT", panel, "RIGHT", -INSET, 0)
		inset = INSET + coordWidth + INSET

		UpdateCoords(widget)
	end

	widget.coordX:SetShown(db.coords)
	widget.coordY:SetShown(db.coords)

	widget.text:ClearAllPoints()
	widget.text:SetPoint("LEFT", panel, "LEFT", inset, 0)
	widget.text:SetPoint("RIGHT", panel, "RIGHT", -inset, 0)
end

local function Update(widget)
	local db = E.db.mui.locationPanel
	local width = min(E.db.general.minimap.size or 190, Preview.Width(widget, 400))

	widget.frame:SetHeight(PADDING + db.height + db.spacing + MINIMAP_PART)

	local panel = widget.panel
	panel:SetSize(width, db.height)
	panel:ClearAllPoints()
	panel:SetPoint("TOP", widget.frame, "TOP", 0, -PADDING)

	local minimap = widget.minimap
	minimap:SetSize(width, max(width, MINIMAP_PART + 10))
	minimap:ClearAllPoints()
	minimap:SetPoint("TOP", panel, "BOTTOM", 0, -db.spacing)

	-- The module's own text and color, called with the current settings
	local LocationPanel = MER:GetModule("MER_LocationPanel")
	local shim = { db = db }
	WF.SetFontWithDB(widget.text, db.font)
	widget.text:SetText(LocationPanel.GetLocationText(shim) or "")
	widget.text:SetTextColor(LocationPanel.GetTextColor(shim))

	LayoutTexts(widget, db)

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERLocationPanelPreview", 1, 80, Build, Update)
