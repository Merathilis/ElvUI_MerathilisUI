local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local QG = MER:GetModule("MER_QuickGrid")

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERQuickGridPreview"
local Version = 1

local format, ipairs, min, random = format, ipairs, math.min, math.random
local CreateFrame, UIParent = CreateFrame, UIParent
local GetBindingKey = GetBindingKey
local GetBindingText = GetBindingText

-- Plays the Quick Grid in a loop, so the page shows right away what it does:
-- the grid opens, a cursor points in a direction, the tile lights up and the
-- key is released. Every round picks the next deck and a random action of it.
-- The tiles come from the module itself (CreateView, LayoutView, FillView,
-- PaintView), so they follow the tile size, spacing and name settings.
-- Used as `dialogControl` on a description and laid out like the cards in
-- InfoCards.lua.

local GAP = 8
local ROW_GAP = GAP - 3
local HEIGHT = 190
-- Room for the grid; bigger grids are scaled down to fit
local GRID_SPACE = 130
local GRID_OFFSET = 14
local HINT_INSET = 10
local CURSOR_SIZE = 20
local CURSOR_TEXTURE = "Interface\\CURSOR\\Point"

-- Round timeline in seconds
local FADE_IN = 0.15
local MOVE_START = 0.45
local MOVE_END = 1.05
local RELEASE = 1.9
local FADE_OUT = 2.1
local ROUND = 2.7

local function DB()
	return E.db.mui.quickGrid
end

local function SmoothStep(progress)
	return progress * progress * (3 - 2 * progress)
end

-- Enabled decks with at least one usable action, markers as a fallback
local function GetDecks()
	local decks = {}
	for _, key in ipairs(QG.DeckOrder) do
		if DB().decks[key] and QG:IsDeckAvailable(key) then
			decks[#decks + 1] = key
		end
	end

	if #decks == 0 then
		decks[1] = "markers"
	end

	return decks
end

local function UsableCells(cells)
	local usable = {}
	for i = 1, QG.NUM_CELLS do
		if cells[i] and not cells[i].inactive then
			usable[#usable + 1] = i
		end
	end
	return usable
end

local function SetHint(widget, released)
	local key = GetBindingKey(QG.Decks[widget.deckKey].binding)
	if released then
		widget.hint:SetText(L["Release the key"])
	elseif key then
		widget.hint:SetText(format(L["Hold %s"], GetBindingText(key)))
	else
		widget.hint:SetText(L["Hold the key"])
	end
end

-- Next deck with something to point at, then a random target in it
local function NextRound(widget)
	local decks = GetDecks()
	local cells, usable

	for _ = 1, #decks do
		widget.deckIndex = widget.deckIndex % #decks + 1
		widget.deckKey = decks[widget.deckIndex]
		cells = QG:ResolveDeck(widget.deckKey)
		usable = UsableCells(cells)
		if #usable > 0 then
			break
		end
	end

	QG:FillView(widget, widget.deckKey, cells)

	-- Not the same direction twice in a row
	local target
	repeat
		target = usable[random(#usable)]
	until #usable == 1 or target ~= widget.target
	widget.target = target

	widget.elapsed = 0
	widget.cell = false
	widget.released = nil
	widget.cursor:ClearAllPoints()
	widget.cursor:SetPoint("TOPLEFT", widget.grid, "CENTER", 0, 0)
	QG:PaintView(widget, widget.deckKey, nil)
	SetHint(widget, false)
end

local function OnUpdate(frame, elapsed)
	local widget = frame.obj
	if not widget.deckKey then
		return
	end

	widget.elapsed = widget.elapsed + elapsed
	local t = widget.elapsed

	if t >= ROUND then
		NextRound(widget)
		t = 0
	end

	-- Grid fades in on key down and out after the release
	local alpha = 1
	if t < FADE_IN then
		alpha = t / FADE_IN
	elseif t >= FADE_OUT then
		alpha = 0
	elseif t >= RELEASE then
		alpha = 1 - (t - RELEASE) / (FADE_OUT - RELEASE)
	end
	widget.grid:SetAlpha(alpha)
	widget.cursor:SetAlpha(t < FADE_OUT and 1 or 0)
	widget.hint:SetAlpha(t < FADE_OUT and 1 or 0)

	if t >= RELEASE and not widget.released then
		widget.released = true
		SetHint(widget, true)
	end
	if t < MOVE_START or t >= RELEASE then
		return
	end

	-- Glide from the center to the target tile
	local db = DB()
	local step = db.tileSize + db.spacing
	local offset = QG.CELL_OFFSETS[widget.target]
	local progress = SmoothStep(min(1, (t - MOVE_START) / (MOVE_END - MOVE_START)))
	local dx, dy = offset[1] * step * progress, offset[2] * step * progress
	widget.cursor:ClearAllPoints()
	widget.cursor:SetPoint("TOPLEFT", widget.grid, "CENTER", dx, dy)

	-- Same direction rules as the real grid; on the way out of the center it
	-- shows the deck name instead of flashing "Cancel"
	local cell = QG.GetSector(dx, dy, db.tileSize / 2 + db.spacing / 2)
	if cell == 0 then
		cell = nil
	end
	if cell ~= widget.cell then
		widget.cell = cell
		QG:PaintView(widget, widget.deckKey, cell)
	end
end

local function Update(widget)
	local db = DB()
	QG:LayoutView(widget, db)

	local full = db.tileSize * 3 + db.spacing * 2
	local scale = min(1, GRID_SPACE / full)
	widget.grid:SetSize(full, full)
	widget.grid:SetScale(scale)
	-- Keeps the cursor its own size on a scaled down grid
	widget.cursor:SetSize(CURSOR_SIZE / scale, CURSOR_SIZE / scale)

	widget.deckIndex = 0
	widget.target = nil
	NextRound(widget)
end

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetHeight(HEIGHT + ROW_GAP)
	frame:Hide()

	local card = CreateFrame("Frame", nil, frame)
	-- Same inset as the cards in InfoCards.lua, so the edges line up
	card:SetPoint("TOPLEFT", 1, 0)
	card:SetPoint("BOTTOMRIGHT", -GAP, ROW_GAP)
	card:CreateBackdrop("Transparent", nil, true)

	local grid = CreateFrame("Frame", nil, card)
	grid:SetPoint("CENTER", card, "CENTER", 0, GRID_OFFSET)

	local cursor = CreateFrame("Frame", nil, grid)
	cursor:SetFrameLevel(grid:GetFrameLevel() + 10)
	local cursorTexture = cursor:CreateTexture(nil, "OVERLAY")
	cursorTexture:SetAllPoints()
	cursorTexture:SetTexture(CURSOR_TEXTURE)

	local hint = card:CreateFontString(nil, "OVERLAY")
	hint:SetFont(F.GetFontPath(), 11, "OUTLINE")
	hint:SetTextColor(0.7, 0.7, 0.7)
	hint:SetPoint("BOTTOMLEFT", card, "BOTTOMLEFT", HINT_INSET, HINT_INSET)

	local widget = {
		type = Type,
		frame = frame,
		card = card,
		grid = grid,
		cursor = cursor,
		hint = hint,
		elapsed = 0,
	}
	QG:CreateView(grid, widget)

	frame.obj = widget
	frame:SetScript("OnUpdate", OnUpdate)

	widget.OnAcquire = function(self)
		self.frame:Show()
	end

	widget.OnRelease = function(self)
		self.frame:Hide()
		self.deckKey = nil
	end

	widget.SetText = function(self)
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
