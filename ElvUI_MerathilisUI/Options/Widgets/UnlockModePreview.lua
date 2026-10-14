local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local _G = _G
local ceil, floor, max, min = math.ceil, math.floor, math.max, math.min
local unpack = unpack
local CreateFrame = CreateFrame

-- A small screen in the mover mode: the grid, a few movers, the toolbar and
-- an Edit Mode hint. The target frame mover is dragged up to the player frame
-- again and again and snaps like UM:SnapMover does, with the guide line and the
-- pulsing target (UM:ShowOverlay). The castbar is selected and anchored to the
-- player frame, so the anchor line shows up as well.

local HEIGHT = 200
local GRID_SPACING = 16
local MAX_WIDTH = 460

-- Same values as the module (Anchors.lua, EditModeHints.lua)
local ANCHOR_LINE_COLOR = { r = 1, g = 0.82, b = 0 }
local EDIT_MODE_BORDER = { r = 0.5, g = 0.5, b = 0.5 }
local EDIT_MODE = _G.HUD_EDIT_MODE_MENU or "Edit Mode"

-- How far the dragged mover starts below its place and where it stops without snapping
local DRAG_START = 30
local DRAG_MISS = 4
-- Loop: wait, drag, hold
local LOOP_WAIT, LOOP_DRAG, LOOP_TOTAL = 0.5, 1.4, 3.4

local function GetUnlockMode()
	return MER:GetModule("MER_UnlockMode")
end

local function OutCubic(p)
	p = p - 1
	return p * p * p + 1
end

local function CreateMover(parent, text, width, height)
	local mover = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	mover:SetTemplate("Transparent", nil, nil, true)
	mover:SetSize(width, height)
	mover:SetFrameLevel(parent:GetFrameLevel() + 5)

	mover.text = mover:CreateFontString(nil, "OVERLAY")
	mover.text:FontTemplate(nil, 10)
	mover.text:SetPoint("CENTER")
	mover.text:SetText(text)
	mover.text:SetTextColor(unpack(E.media.rgbvaluecolor))

	return mover
end

local function SetSnapped(widget, snapped)
	if widget.snapped == snapped then
		return
	end
	widget.snapped = snapped

	local db = E.db.mui.unlockMode
	local UM = GetUnlockMode()
	if snapped then
		UM:ShowOverlay(widget.player, "MER_SnapOverlay", F.r, F.g, F.b, 0.15, true)
	else
		UM:HideOverlay(widget.player, "MER_SnapOverlay")
	end
	widget.guide:SetShown(snapped and db.snap.guides)
end

-- Moves the target frame mover along the loop
local function Screen_OnUpdate(screen, elapsed)
	local widget = screen.widget
	widget.elapsed = (widget.elapsed + elapsed) % LOOP_TOTAL

	local progress = min(max(widget.elapsed - LOOP_WAIT, 0) / LOOP_DRAG, 1)
	local snap = E.db.mui.unlockMode.snap
	local offset

	if snap.enable then
		offset = DRAG_START * (1 - OutCubic(progress))
		if offset <= snap.distance then
			offset = 0
		end
	else
		offset = DRAG_MISS + (DRAG_START - DRAG_MISS) * (1 - OutCubic(progress))
	end

	widget.target:SetPoint("BOTTOMLEFT", widget.player, "BOTTOMRIGHT", widget.gap, -floor(offset + 0.5))
	SetSnapped(widget, snap.enable and offset == 0)
end

local function UpdateGrid(widget, width, height, db)
	local lines = widget.gridLines
	local centerX, centerY = width * 0.5, height * 0.5
	local cols = ceil(centerX / GRID_SPACING)
	local rows = ceil(centerY / GRID_SPACING)
	local used = 0

	local function Line(vertical, offset)
		used = used + 1
		local line = lines[used]
		if not line then
			line = widget.gridFrame:CreateTexture(nil, "BACKGROUND", nil, 2)
			lines[used] = line
		end

		line:ClearAllPoints()
		if vertical then
			line:SetPoint("TOPLEFT", widget.screen, "TOPLEFT", centerX + offset, 0)
			line:SetPoint("BOTTOMRIGHT", widget.screen, "BOTTOMLEFT", centerX + offset + 1, 0)
		else
			line:SetPoint("TOPLEFT", widget.screen, "BOTTOMLEFT", 0, centerY + offset + 1)
			line:SetPoint("BOTTOMRIGHT", widget.screen, "BOTTOMRIGHT", 0, centerY + offset)
		end

		-- Like UM:StyleGrid, the center lines are red or in the class color
		if offset == 0 then
			if db.gridAccent then
				line:SetColorTexture(F.r, F.g, F.b, 0.8)
			else
				line:SetColorTexture(1, 0, 0, 0.8)
			end
		else
			line:SetColorTexture(0, 0, 0, 0.5)
		end
		line:Show()
	end

	for i = -cols, cols do
		Line(true, i * GRID_SPACING)
	end
	for i = -rows, rows do
		Line(false, i * GRID_SPACING)
	end

	for i = used + 1, #lines do
		lines[i]:Hide()
	end

	widget.gridFrame:SetShown(db.showGrid)
end

local function Build(widget)
	local frame = widget.frame

	local screen = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	screen:SetTemplate("Transparent", nil, nil, true)
	screen:SetBackdropColor(0.16, 0.17, 0.19, 1)
	screen:SetPoint("TOP", frame, "TOP", 0, -8)
	screen:SetClipsChildren(true)
	screen.widget = widget
	widget.screen = screen

	widget.gridFrame = CreateFrame("Frame", nil, screen)
	widget.gridFrame:SetAllPoints()
	widget.gridLines = {}

	widget.player = CreateMover(screen, L["Player Frame"], 96, 30)
	widget.target = CreateMover(screen, L["Target Frame"], 96, 30)
	widget.castbar = CreateMover(screen, L["Player Castbar"], 96, 14)
	widget.castbar:SetPoint("TOP", widget.player, "BOTTOM", 0, -16)

	-- Lines above the movers, like the guide and anchor line frames of the module
	local lineFrame = CreateFrame("Frame", nil, screen)
	lineFrame:SetAllPoints()
	lineFrame:SetFrameLevel(screen:GetFrameLevel() + 20)

	-- Along the bottom edge of the player frame, the screen clips it to its width
	widget.guide = lineFrame:CreateTexture(nil, "OVERLAY")
	widget.guide:SetPoint("BOTTOMLEFT", widget.player, "BOTTOMLEFT", -MAX_WIDTH, 0)
	widget.guide:SetPoint("BOTTOMRIGHT", widget.player, "BOTTOMRIGHT", MAX_WIDTH, 0)
	widget.guide:SetHeight(1)

	widget.anchorLine = lineFrame:CreateLine(nil, "OVERLAY")
	widget.anchorLine:SetThickness(2)
	widget.anchorLine:SetStartPoint("CENTER", widget.castbar)
	widget.anchorLine:SetEndPoint("CENTER", widget.player)

	-- ElvUI's mover popup is replaced by the toolbar at the top
	local toolbar = CreateFrame("Frame", nil, screen, "BackdropTemplate")
	toolbar:SetTemplate("Transparent", nil, nil, true)
	toolbar:SetFrameLevel(screen:GetFrameLevel() + 25)
	toolbar:SetPoint("TOP", screen, "TOP", 0, -8)
	toolbar:SetHeight(20)
	toolbar.title = toolbar:CreateFontString(nil, "OVERLAY")
	toolbar.title:FontTemplate(nil, 10)
	toolbar.title:SetPoint("LEFT", toolbar, "LEFT", 6, 0)
	toolbar.title:SetText(MER.Title .. L["Unlock Mode"])
	widget.toolbar = toolbar

	-- A Blizzard frame that the Edit Mode places, marked like UM:CreateEditModeMarker
	local marker = CreateFrame("Frame", nil, screen, "BackdropTemplate")
	marker:SetBackdrop({ bgFile = E.media.blankTex, edgeFile = E.media.blankTex, edgeSize = E.mult })
	marker:SetBackdropColor(0, 0, 0, 0.45)
	marker:SetBackdropBorderColor(EDIT_MODE_BORDER.r, EDIT_MODE_BORDER.g, EDIT_MODE_BORDER.b)
	marker:SetFrameLevel(screen:GetFrameLevel() + 3)
	marker:SetSize(84, 58)
	marker:SetPoint("BOTTOMRIGHT", screen, "BOTTOMRIGHT", -10, 10)
	marker.label = marker:CreateFontString(nil, "OVERLAY")
	marker.label:FontTemplate(nil, 11, "SHADOW")
	marker.label:SetPoint("CENTER", marker, "CENTER", 0, 6)
	marker.label:SetTextColor(0.85, 0.85, 0.85)
	marker.label:SetText(_G.OBJECTIVES_TRACKER_LABEL or _G.QUESTS_LABEL)
	marker.tag = marker:CreateFontString(nil, "OVERLAY")
	marker.tag:FontTemplate(nil, 9, "SHADOW")
	marker.tag:SetPoint("TOP", marker.label, "BOTTOM", 0, -2)
	marker.tag:SetTextColor(EDIT_MODE_BORDER.r, EDIT_MODE_BORDER.g, EDIT_MODE_BORDER.b)
	marker.tag:SetText(EDIT_MODE)
	widget.marker = marker

	widget.elapsed = 0
	screen:SetScript("OnUpdate", Screen_OnUpdate)
end

local function Update(widget)
	local db = E.db.mui.unlockMode
	local UM = GetUnlockMode()

	local width = Preview.Width(widget, MAX_WIDTH, 8)
	local height = HEIGHT - 16
	widget.frame:SetHeight(HEIGHT)
	widget.screen:SetSize(width, height)

	UpdateGrid(widget, width, height, db)

	-- Player frame left of the center line, the target frame mirrored on the right
	widget.gap = 40
	widget.player:ClearAllPoints()
	widget.player:SetPoint("RIGHT", widget.screen, "CENTER", -widget.gap * 0.5, 0)
	widget.target:ClearAllPoints()
	widget.target:SetPoint("BOTTOMLEFT", widget.player, "BOTTOMRIGHT", widget.gap, 0)

	-- The selected mover, see UM:Select
	UM:ShowOverlay(widget.castbar, "MER_SelectOverlay", 1, 1, 1, 0.12)

	widget.anchorLine:SetColorTexture(ANCHOR_LINE_COLOR.r, ANCHOR_LINE_COLOR.g, ANCHOR_LINE_COLOR.b, 1)
	widget.anchorLine:SetShown(db.anchorLines)

	widget.guide:SetColorTexture(F.r, F.g, F.b, 0.9)
	-- Snap state is set again by the next frame
	widget.snapped = nil
	SetSnapped(widget, false)

	widget.toolbar:SetWidth(min(width - 20, 260))
	widget.toolbar:SetShown(db.toolbar)
	widget.marker:SetShown(db.editModeHints)

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERUnlockModePreview", 1, HEIGHT, Build, Update)
