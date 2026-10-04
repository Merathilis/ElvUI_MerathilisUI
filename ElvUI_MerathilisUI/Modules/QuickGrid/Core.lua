local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_QuickGrid")
local WS = W:GetModule("Skins")

local _G = _G
local abs, min = math.abs, math.min
local ipairs, pairs, pcall, select, tonumber, unpack = ipairs, pairs, pcall, select, tonumber, unpack
local format, strmatch = format, strmatch
local sort, tconcat, wipe = sort, table.concat, wipe

local C_Container = C_Container
local C_MountJournal = C_MountJournal
local C_Spell = C_Spell
local C_Timer = C_Timer
local ClearOverrideBindings = ClearOverrideBindings
local CreateColor = CreateColor
local CreateFrame = CreateFrame
local GetBindingAction = GetBindingAction
local GetBindingKey = GetBindingKey
local GetCursorPosition = GetCursorPosition
local InCombatLockdown = InCombatLockdown
local IsMounted = IsMounted
local IsShiftKeyDown = IsShiftKeyDown
local SecureButton_GetModifiedAttribute = SecureButton_GetModifiedAttribute
local SecureHandlerSetFrameRef = SecureHandlerSetFrameRef
local SecureHandlerWrapScript = SecureHandlerWrapScript
local SetOverrideBindingClick = SetOverrideBindingClick
local UIParent = UIParent

-------------------------------------------------------------------------------
--  Quick Grid
--
--  Hold a deck's key and a 3x3 grid of actions opens. Point in a direction and
--  release the key to use the action in that direction; the empty center and
--  a release without moving the mouse cancel.
--
--  Every deck owns a hidden secure action button. Its keys are routed to it
--  with override bindings and it is registered for down and up:
--
--    key down  the wrapped OnClick snippet places the grid and shows it, the
--              click itself does nothing
--    key up    the snippet hides the grid, works out the direction and turns
--              the click into button "cellN", whose "*type-cellN" attributes
--              hold that cell's action
--
--  The cell attributes are written out of combat whenever a deck changes, so
--  nothing has to be written while the grid is in use and it works in combat.
-------------------------------------------------------------------------------

-- Grid offsets of the cells, clockwise from the top, see Decks.lua
local CELL_OFFSETS = {
	{ 0, 1 },
	{ 1, 1 },
	{ 1, 0 },
	{ 1, -1 },
	{ 0, -1 },
	{ -1, -1 },
	{ -1, 0 },
	{ -1, 1 },
}

-- tan(22.5°): the eight directions split the circle into 45° sectors
local SECTOR_SLOPE = 0.41421356

-- A release closer than this to where the key went down cancels
local MOVE_THRESHOLD = 6

local FADE_TIME = 0.08
local LABEL_GAP = 8
local QUESTION_MARK = 134400
local CANCEL_COLOR = { r = 0.85, g = 0.25, b = 0.25 }

-- Every modifier combination a deck key is bound in, so pressing or releasing
-- a modifier while the key is held still reaches the deck
local MODIFIER_COMBOS = { "", "SHIFT-", "CTRL-", "ALT-", "CTRL-SHIFT-", "ALT-SHIFT-", "ALT-CTRL-", "ALT-CTRL-SHIFT-" }
local MODIFIERS = { ALT = true, CTRL = true, SHIFT = true, META = true }

local CELL_ATTRIBUTES = { "type", "spell", "item", "toy", "macro", "mount", "panel", "marker", "action" }

-- Runs in the restricted environment on every key down and up of a deck button.
-- Must stay in sync with GetSector below.
local CLICK_SNIPPET = [=[
	local grid = self:GetFrameRef("grid")
	local screen = self:GetFrameRef("screen")
	local width, height = screen:GetWidth(), screen:GetHeight()
	local x, y = screen:GetMousePosition()

	if down then
		local mx, my = width / 2, height / 2
		if x then
			mx, my = x * width, y * height
		end

		local cx, cy = width / 2, height / 2
		if grid:GetAttribute("anchor") == "CURSOR" then
			local halfWidth, halfHeight = grid:GetAttribute("halfwidth"), grid:GetAttribute("halfheight")
			cx = min(max(mx, halfWidth), width - halfWidth)
			cy = min(max(my, halfHeight), height - halfHeight)
		end

		grid:SetAttribute("cx", cx)
		grid:SetAttribute("cy", cy)
		grid:SetAttribute("ox", mx)
		grid:SetAttribute("oy", my)
		grid:SetAttribute("deck", self:GetAttribute("deck"))
		grid:ClearAllPoints()
		grid:SetPoint("CENTER", screen, "BOTTOMLEFT", cx, cy)
		grid:Show()
		return false
	end

	if not grid:IsShown() or grid:GetAttribute("deck") ~= self:GetAttribute("deck") then
		return false
	end
	grid:Hide()

	if not x then
		return false
	end

	local mx, my = x * width, y * height
	local moveX, moveY = mx - grid:GetAttribute("ox"), my - grid:GetAttribute("oy")
	local threshold = grid:GetAttribute("movethreshold")
	if moveX * moveX + moveY * moveY < threshold * threshold then
		return false
	end

	local dx, dy = mx - grid:GetAttribute("cx"), my - grid:GetAttribute("cy")
	local deadzone = grid:GetAttribute("deadzone")
	if abs(dx) <= deadzone and abs(dy) <= deadzone then
		return false
	end

	local slope = grid:GetAttribute("slope")
	local ax, ay = abs(dx), abs(dy)
	local cell
	if ax <= ay * slope then
		cell = dy > 0 and 1 or 5
	elseif ay <= ax * slope then
		cell = dx > 0 and 3 or 7
	elseif dx > 0 then
		cell = dy > 0 and 2 or 4
	else
		cell = dy < 0 and 6 or 8
	end

	return "cell" .. cell
]=]

_G.BINDING_HEADER_MER_QUICKGRID = L["Quick Grid"]
for _, key in ipairs(module.DeckOrder) do
	local deck = module.Decks[key]
	_G["BINDING_NAME_" .. deck.binding] = format("%s: %s", L["Quick Grid"], deck.name)
end

-------------------------------------------------------------------------------
--  Helpers
-------------------------------------------------------------------------------
-- Cell under the cursor offset (dx, dy) from the grid center, 0 = center
local function GetSector(dx, dy, deadzone)
	if abs(dx) <= deadzone and abs(dy) <= deadzone then
		return 0
	end

	local ax, ay = abs(dx), abs(dy)
	if ax <= ay * SECTOR_SLOPE then
		return dy > 0 and 1 or 5
	elseif ay <= ax * SECTOR_SLOPE then
		return dx > 0 and 3 or 7
	elseif dx > 0 then
		return dy > 0 and 2 or 4
	end
	return dy < 0 and 6 or 8
end

-- "ALT-SHIFT-Q" -> "Q"
local function BaseKey(key)
	local base = key
	while true do
		local modifier, rest = strmatch(base, "^(%u+)%-(.+)$")
		if not MODIFIERS[modifier] then
			return base
		end
		base = rest
	end
end

-- Spell cooldowns are secret while cooldowns are restricted, the engine then
-- feeds the swipe through a duration object
local function SetSpellCooldown(cooldown, spellID)
	local info = C_Spell.GetSpellCooldown(spellID)
	if not info then
		cooldown:Clear()
	elseif E:IsSecretValue(info.startTime) or E:IsSecretValue(info.duration) then
		local duration = C_Spell.GetSpellCooldownDuration and C_Spell.GetSpellCooldownDuration(spellID)
		if duration then
			cooldown:SetCooldownFromDurationObject(duration)
		else
			cooldown:Clear()
		end
	elseif info.duration and info.duration > 1.5 then
		cooldown:SetCooldown(info.startTime, info.duration)
	else
		cooldown:Clear()
	end
end

local function SetItemCooldown(cooldown, itemID)
	local ok, start, duration = pcall(C_Container.GetItemCooldown, itemID)
	if ok and not E:IsSecretValue(start) and not E:IsSecretValue(duration) and duration and duration > 1.5 then
		cooldown:SetCooldown(start, duration)
	else
		cooldown:Clear()
	end
end

-------------------------------------------------------------------------------
--  Custom action types
--  Called by SecureActionButton's PerformAction for types it doesn't know,
--  looked up as a field of the button.
-------------------------------------------------------------------------------
local function MountAction(self, _, button)
	local mountID = tonumber(SecureButton_GetModifiedAttribute(self, "mount", button))
	if not mountID then
		return
	end

	if IsMounted() then
		C_MountJournal.Dismiss()
	else
		C_MountJournal.SummonByID(mountID)
	end
end

local function PanelAction(self, _, button)
	local panel = SecureButton_GetModifiedAttribute(self, "panel", button)
	if panel == "professionsBook" and _G.ToggleProfessionsBook then
		_G.ToggleProfessionsBook()
	end
end

-------------------------------------------------------------------------------
--  Cell attributes
-------------------------------------------------------------------------------
local function WriteCell(button, index, entry)
	local suffix = "-cell" .. index
	for _, name in ipairs(CELL_ATTRIBUTES) do
		button:SetAttribute("*" .. name .. suffix, nil)
		button:SetAttribute("shift-" .. name .. suffix, nil)
	end

	if not entry or entry.inactive then
		return
	end

	local function Set(name, value, prefix)
		button:SetAttribute((prefix or "*") .. name .. suffix, value)
	end

	local kind = entry.kind
	if kind == "spell" then
		Set("type", "spell")
		Set("spell", entry.id)
	elseif kind == "item" then
		Set("type", "item")
		Set("item", "item:" .. entry.id)
	elseif kind == "toy" then
		Set("type", "toy")
		Set("toy", entry.id)
	elseif kind == "macro" then
		Set("type", "macro")
		Set("macro", entry.id)
	elseif kind == "mount" then
		Set("type", "quickGridMount")
		Set("mount", entry.id)
	elseif kind == "panel" then
		Set("type", "quickGridPanel")
		Set("panel", entry.id)
	elseif kind == "marker" then
		Set("type", "raidtarget")
		Set("marker", entry.id)
		Set("action", "toggle")
		Set("type", "worldmarker", "shift-")
		Set("marker", entry.world, "shift-")
		Set("action", "toggle", "shift-")
	end
end

function module:RefreshDeck(key)
	local button = self.buttons[key]
	if not button then
		return
	end

	if InCombatLockdown() then
		self.pendingRefresh = true
		return
	end

	local cells = self:ResolveDeck(key)
	self.cells[key] = cells
	for i = 1, self.NUM_CELLS do
		WriteCell(button, i, cells[i])
	end
end

function module:RefreshAllDecks()
	for key in pairs(self.buttons) do
		self:RefreshDeck(key)
	end
end

-- Coalesces bursts of events into one refresh of the given decks
function module:ScheduleRefresh(...)
	self.dirtyDecks = self.dirtyDecks or {}
	for i = 1, select("#", ...) do
		self.dirtyDecks[select(i, ...)] = true
	end

	if self.refreshTimer then
		return
	end

	self.refreshTimer = C_Timer.NewTimer(0.3, function()
		self.refreshTimer = nil
		for key in pairs(self.dirtyDecks) do
			self:RefreshDeck(key)
		end
		wipe(self.dirtyDecks)
	end)
end

-------------------------------------------------------------------------------
--  View
--  Insecure children of the protected grid: they only draw what the secure
--  side does, so they may change at any time, in combat too.
-------------------------------------------------------------------------------
local function CreateTile(parent)
	local tile = CreateFrame("Frame", nil, parent)
	tile:SetTemplate("Transparent", nil, true)
	WS:CreateShadow(tile)
	if tile.shadow then
		tile.shadowColor = { tile.shadow:GetBackdropBorderColor() }
	end

	tile.icon = tile:CreateTexture(nil, "ARTWORK")
	tile.icon:SetInside()
	tile.icon:SetTexCoord(unpack(E.TexCoords))

	-- Class colored glow from the bottom of the selected tile
	tile.glow = tile:CreateTexture(nil, "OVERLAY")
	tile.glow:SetInside()
	tile.glow:SetTexture(E.media.blankTex)
	tile.glow:SetBlendMode("ADD")
	tile.glow:Hide()

	tile.cooldown = CreateFrame("Cooldown", nil, tile, "CooldownFrameTemplate")
	tile.cooldown:SetInside()
	tile.cooldown:SetDrawEdge(false)
	tile.cooldown:SetDrawBling(false)
	tile.cooldown:SetHideCountdownNumbers(true)
	E:RegisterCooldown(tile.cooldown)

	tile.label = tile:CreateFontString(nil, "OVERLAY")
	tile.label:SetPoint("BOTTOM", 0, 3)
	tile.label:SetFont(F.GetFontPath(I.Fonts.Primary), 10, "OUTLINE")

	return tile
end

local function SetTileHighlight(tile, color)
	if color then
		tile:SetBackdropBorderColor(color.r, color.g, color.b)
		if tile.shadow then
			tile.shadow:SetBackdropBorderColor(color.r, color.g, color.b, 0.9)
		end
	else
		tile:SetBackdropBorderColor(unpack(E.media.bordercolor))
		if tile.shadow then
			tile.shadow:SetBackdropBorderColor(unpack(tile.shadowColor))
		end
	end
end

function module:CreateFrames()
	if self.grid then
		return
	end

	-- Protected, screen sized reference for the snippet's cursor position
	local screen = CreateFrame("Frame", "MER_QuickGridScreen", UIParent, "SecureFrameTemplate")
	screen:SetAllPoints(UIParent)
	self.screen = screen

	local grid = CreateFrame("Frame", "MER_QuickGrid", screen, "SecureHandlerBaseTemplate")
	grid:SetFrameStrata("FULLSCREEN_DIALOG")
	grid:SetPoint("CENTER")
	grid:SetAttribute("movethreshold", MOVE_THRESHOLD)
	grid:SetAttribute("slope", SECTOR_SLOPE)
	grid:Hide()
	grid:SetScript("OnShow", function()
		self:OnGridShow()
	end)
	grid:SetScript("OnHide", function()
		self:OnGridHide()
	end)
	self.grid = grid

	local view = CreateFrame("Frame", nil, grid)
	view:SetAllPoints()
	view:SetScript("OnUpdate", function(_, elapsed)
		self:UpdateSelection(elapsed)
	end)
	view:SetScript("OnEvent", function()
		self:UpdateCooldowns()
	end)
	self.view = view

	self.tiles = {}
	for i = 1, self.NUM_CELLS do
		self.tiles[i] = CreateTile(view)
	end

	local center = CreateTile(view)
	center.icon:SetDesaturated(true)
	center.icon:SetAlpha(0.35)
	self.center = center

	local label = view:CreateFontString(nil, "OVERLAY")
	label:SetPoint("TOP", view, "BOTTOM", 0, -LABEL_GAP)
	label:SetWordWrap(false)
	self.label = label

	self.bindingOwner = CreateFrame("Frame")
end

function module:CreateDeckButton(key)
	local button = CreateFrame("Button", "MER_QuickGridDeck_" .. key, UIParent, "SecureActionButtonTemplate")
	button:Hide()
	button:RegisterForClicks("AnyDown", "AnyUp")
	button:SetAttribute("useOnKeyDown", false)
	button:SetAttribute("deck", key)
	button.deckKey = key
	button.quickGridMount = MountAction
	button.quickGridPanel = PanelAction

	SecureHandlerSetFrameRef(button, "grid", self.grid)
	SecureHandlerSetFrameRef(button, "screen", self.screen)
	SecureHandlerWrapScript(button, "OnClick", self.grid, CLICK_SNIPPET)

	-- Runs before the snippet: fill the view for this deck
	button:SetScript("PreClick", function(btn, _, down)
		if down then
			self:OpenDeck(btn.deckKey)
		end
	end)

	self.buttons[key] = button
	return button
end

function module:UpdateLayout()
	if InCombatLockdown() then
		self.pendingLayout = true
		return
	end

	local db = self.db
	local size, spacing = db.tileSize, db.spacing
	local step = size + spacing
	local full = size * 3 + spacing * 2

	local grid = self.grid
	grid:SetSize(full, full)
	grid:SetAttribute("anchor", db.anchor)
	grid:SetAttribute("deadzone", size / 2 + spacing / 2)
	grid:SetAttribute("halfwidth", full / 2 + LABEL_GAP)
	-- Room for the label below the grid
	grid:SetAttribute("halfheight", full / 2 + LABEL_GAP * 2 + db.labelSize)

	for i, tile in ipairs(self.tiles) do
		local offset = CELL_OFFSETS[i]
		tile:SetSize(size, size)
		tile:ClearAllPoints()
		tile:SetPoint("CENTER", self.view, "CENTER", offset[1] * step, offset[2] * step)
		tile.cooldown:SetShown(db.showCooldowns)
	end

	self.center:SetSize(size, size)
	self.center:ClearAllPoints()
	self.center:SetPoint("CENTER")
	self.center.icon:ClearAllPoints()
	self.center.icon:SetPoint("CENTER")
	self.center.icon:SetSize(size * 0.6, size * 0.6)
	self.center.cooldown:Hide()

	self.label:SetFont(F.GetFontPath(I.Fonts.Primary), db.labelSize, "OUTLINE")
	self.label:SetShown(db.showLabel)
end

-- Fills the view with a deck, right before the snippet shows the grid
function module:OpenDeck(key)
	-- Out of combat every opening picks up the latest state (random hearthstone,
	-- new favorites, learned spells)
	if not InCombatLockdown() then
		self:RefreshDeck(key)
	end

	local deck = self.Decks[key]
	local cells = self.cells[key] or {}
	self.deckKey = key

	for i, tile in ipairs(self.tiles) do
		local entry = cells[i]
		tile.entry = entry
		if entry then
			tile.icon:SetTexture(entry.icon or QUESTION_MARK)
			tile.icon:SetDesaturated(entry.inactive)
			tile.icon:SetAlpha(entry.inactive and 0.4 or 1)
			tile.label:SetText(entry.label or "")
			tile:Show()
		else
			tile.cooldown:Clear()
			tile:Hide()
		end
	end

	self.center.icon:SetTexture(deck.icon)
	self:Debug("open", key, InCombatLockdown() and "(combat)" or "")
end

function module:OnGridShow()
	self.fade = 0
	self.view:SetAlpha(0)
	self.selected = false
	self.world = nil
	self:ApplySelection(nil, false)

	if self.db.showCooldowns then
		self.view:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		self.view:RegisterEvent("BAG_UPDATE_COOLDOWN")
		self:UpdateCooldowns()
	end
end

function module:OnGridHide()
	self.view:UnregisterAllEvents()
end

function module:UpdateCooldowns()
	for _, tile in ipairs(self.tiles) do
		local entry = tile.entry
		if not entry or entry.inactive then
			tile.cooldown:Clear()
		elseif entry.kind == "spell" then
			SetSpellCooldown(tile.cooldown, entry.id)
		elseif entry.kind == "item" or entry.kind == "toy" then
			SetItemCooldown(tile.cooldown, entry.id)
		else
			tile.cooldown:Clear()
		end
	end
end

-- Same direction rules as the snippet, for the highlight only
function module:UpdateSelection(elapsed)
	if self.fade < 1 then
		self.fade = min(1, self.fade + elapsed / FADE_TIME)
		self.view:SetAlpha(self.fade)
	end

	local grid = self.grid
	local ox, oy = grid:GetAttribute("ox"), grid:GetAttribute("oy")
	local cx, cy = grid:GetAttribute("cx"), grid:GetAttribute("cy")
	if not (ox and cx) then
		return
	end

	local scale = self.screen:GetEffectiveScale()
	local x, y = GetCursorPosition()
	x, y = x / scale, y / scale

	local cell
	local moveX, moveY = x - ox, y - oy
	if moveX * moveX + moveY * moveY >= MOVE_THRESHOLD * MOVE_THRESHOLD then
		cell = GetSector(x - cx, y - cy, grid:GetAttribute("deadzone"))
	end

	local world = self.deckKey == "markers" and IsShiftKeyDown()
	if cell ~= self.selected or world ~= self.world then
		self:ApplySelection(cell, world)
	end
end

-- cell: 1-8, 0 = center (cancel), nil = not moved yet
function module:ApplySelection(cell, world)
	self.selected = cell
	self.world = world

	local classColor = E:ClassColor(E.myclass, true)
	local entry
	for i, tile in ipairs(self.tiles) do
		local active = i == cell and tile.entry and not tile.entry.inactive
		if active then
			entry = tile.entry
			tile.glow:SetGradient(
				"VERTICAL",
				CreateColor(classColor.r, classColor.g, classColor.b, 0.35),
				CreateColor(classColor.r, classColor.g, classColor.b, 0)
			)
		end
		tile.glow:SetShown(active)
		SetTileHighlight(tile, active and classColor)
	end

	SetTileHighlight(self.center, cell == 0 and CANCEL_COLOR)

	local label = self.label
	if entry then
		local name = entry.name or ""
		if world then
			name = format("%s: %s", L["World Marker"], name)
		end
		label:SetText(name)
		label:SetTextColor(1, 1, 1)
	elseif cell == 0 then
		label:SetText(_G.CANCEL)
		label:SetTextColor(CANCEL_COLOR.r, CANCEL_COLOR.g, CANCEL_COLOR.b)
	else
		label:SetText(self.Decks[self.deckKey].name)
		label:SetTextColor(classColor.r, classColor.g, classColor.b)
	end
end

-------------------------------------------------------------------------------
--  Key bindings
-------------------------------------------------------------------------------
function module:ApplyBindings()
	if not self.bindingOwner then
		return
	end

	if InCombatLockdown() then
		self.pendingBindings = true
		return
	end

	local wanted = {}
	if self.db.enable then
		for _, key in ipairs(self.DeckOrder) do
			local button = self.buttons[key]
			if button and self.db.decks[key] then
				for _, bound in ipairs({ GetBindingKey(self.Decks[key].binding) }) do
					local base = BaseKey(bound)
					for _, modifier in ipairs(MODIFIER_COMBOS) do
						local combo = modifier .. base
						-- The bound key itself, and the variants nothing else uses
						if not wanted[combo] and (combo == bound or GetBindingAction(combo) == "") then
							wanted[combo] = button:GetName()
						end
					end
				end
			end
		end
	end

	-- Override bindings fire UPDATE_BINDINGS themselves, skip when nothing changed
	local list = {}
	for combo, name in pairs(wanted) do
		list[#list + 1] = combo .. "=" .. name
	end
	sort(list)
	local signature = tconcat(list, ";")
	if signature == self.bindingSignature then
		return
	end
	self.bindingSignature = signature

	ClearOverrideBindings(self.bindingOwner)
	for combo, name in pairs(wanted) do
		SetOverrideBindingClick(self.bindingOwner, false, combo, name, "LeftButton")
	end
	self:Debug("bindings", signature)
end

-------------------------------------------------------------------------------
--  Events
-------------------------------------------------------------------------------
-- Event -> decks it can change
local CONTENT_EVENTS = {
	SPELLS_CHANGED = { "teleports", "professions", "custom" },
	SKILL_LINES_CHANGED = { "professions" },
	UPDATE_MACROS = { "custom" },
	NEW_MOUNT_ADDED = { "travel", "custom" },
	NEW_TOY_ADDED = { "travel", "custom" },
	TOYS_UPDATED = { "travel", "custom" },
	BAG_UPDATE_DELAYED = { "custom" },
}

function module:OnContentEvent(event)
	self:ScheduleRefresh(unpack(CONTENT_EVENTS[event]))
end

function module:PLAYER_ENTERING_WORLD()
	self:ScheduleRefresh(unpack(self.DeckOrder))
end

function module:UPDATE_BINDINGS()
	self:ApplyBindings()
end

function module:PLAYER_REGEN_ENABLED()
	if self.pendingEnable then
		self.pendingEnable = nil
		self:SettingsUpdate()
		return
	end

	if self.pendingLayout then
		self.pendingLayout = nil
		self:UpdateLayout()
	end

	if self.pendingRefresh then
		self.pendingRefresh = nil
		self:RefreshAllDecks()
	end

	if self.pendingBindings then
		self.pendingBindings = nil
		self:ApplyBindings()
	end
end

-------------------------------------------------------------------------------
--  Lifecycle
-------------------------------------------------------------------------------
function module:EnableGrid()
	self:CreateFrames()
	for _, key in ipairs(self.DeckOrder) do
		if not self.buttons[key] and self:IsDeckAvailable(key) then
			self:CreateDeckButton(key)
		end
	end

	self:UpdateLayout()
	self:RefreshAllDecks()

	if not self.enabled then
		self.enabled = true
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("UPDATE_BINDINGS")
		for event in pairs(CONTENT_EVENTS) do
			self:RegisterEvent(event, "OnContentEvent")
		end
	end

	self:ApplyBindings()
end

function module:DisableGrid()
	if not self.enabled then
		return
	end

	self.enabled = false
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("UPDATE_BINDINGS")
	for event in pairs(CONTENT_EVENTS) do
		self:UnregisterEvent(event)
	end

	-- Clears every override binding, so the deck keys do their own thing again
	self:ApplyBindings()
end

-- Called by the options after any setting changed
function module:SettingsUpdate()
	if not self.db then
		return
	end

	-- Secure frames, attributes and bindings can only change out of combat
	if InCombatLockdown() then
		self.pendingEnable = true
		return
	end

	if self.db.enable then
		self:EnableGrid()
	else
		self:DisableGrid()
	end
end

function module:Initialize()
	self.db = E.db.mui.quickGrid
	self.buttons = {}
	self.cells = {}

	-- Also catches a /reload in combat before the module could set itself up
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:SettingsUpdate()
end

function module:ProfileUpdate()
	self.db = E.db.mui.quickGrid
	self:SettingsUpdate()
end

MER:RegisterModule(module:GetName())
