local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local _G = _G
local format = string.format
local ipairs = ipairs
local max, min = math.max, math.min
local CreateFrame = CreateFrame

local GetItemCount = C_Item.GetItemCount

-- The extra panes of the Armory, drawn with the module's own functions.
-- Used as `dialogControl` on a description whose name is the part to show:
-- "sockets" - the sockets of your equipped items at the bottom of the stats
-- pane (CollectSocketRecords, PaintSocketIcon) and the gem flyout below the
-- first one (ScanSocketGems, SetSocketRowFont, GetGemStatText);
-- "gearsets" - the gear set panel with your sets (GetEquipmentSetList,
-- StyleEquipmentTile, StyleCategoryHeader).

-- Stand-in for the bottom of the character stats pane
local PANE_WIDTH, PANE_HEIGHT = 200, 56
local MAX_SOCKETS = 16
-- The flyout shows at most this many rows here, the rest only changes its length in game
local MAX_GEM_ROWS = 5

-- Same values as EquipmentManager.lua
local TILE_HEIGHT, TILE_GAP = 24, 2
local MAX_TILES = 5

local function GetArmory()
	local armory = MER:GetModule("MER_Armory")
	armory.db = E.db.mui.armory
	return armory
end

-------------------------------------------------------------------------------
--  Sockets
-------------------------------------------------------------------------------
local function CreateGemRow(parent)
	local row = CreateFrame("Frame", nil, parent)

	row.icon = row:CreateTexture(nil, "ARTWORK")
	row.icon:SetPoint("LEFT", 2, 0)

	row.label = row:CreateFontString(nil, "OVERLAY")
	row.label:FontTemplate()
	row.label:SetPoint("LEFT", row.icon, "RIGHT", E:Scale(5), 0)
	row.label:SetJustifyH("LEFT")

	row.count = row:CreateFontString(nil, "OVERLAY")
	row.count:FontTemplate()
	row.count:SetPoint("RIGHT", -E:Scale(6), 0)
	row.count:SetJustifyH("RIGHT")
	row.count:SetTextColor(0.7, 0.7, 0.7)

	-- Keeps a long gem text away from the count
	row.label:SetPoint("RIGHT", row.count, "LEFT", -4, 0)
	row.label:SetWordWrap(false)

	return row
end

local function BuildSockets(widget)
	local view = CreateFrame("Frame", nil, widget.frame)
	view:SetAllPoints()

	view.pane = CreateFrame("Frame", nil, view, "BackdropTemplate")
	view.pane:SetTemplate("Transparent", nil, nil, true)
	view.pane:SetSize(PANE_WIDTH, PANE_HEIGHT)

	view.panel = CreateFrame("Frame", nil, view)
	view.panel:SetFrameLevel(view.pane:GetFrameLevel() + 5)

	view.icons = {}
	for index = 1, MAX_SOCKETS do
		local button = CreateFrame("Frame", nil, view.panel)
		button.icon = button:CreateTexture(nil, "ARTWORK")
		button.icon:SetAllPoints()
		view.icons[index] = button
	end

	-- Like BuildSocketFlyout: dark background with a thin gray border
	local flyout = CreateFrame("Frame", nil, view, "BackdropTemplate")
	flyout:SetBackdrop({ bgFile = E.media.blankTex, edgeFile = E.media.blankTex, edgeSize = 1 })
	flyout:SetBackdropColor(0.06, 0.06, 0.06, 0.95)
	flyout:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
	flyout:SetFrameLevel(view.panel:GetFrameLevel() + 5)
	view.flyout = flyout

	view.rows = {}
	for index = 1, MAX_GEM_ROWS do
		view.rows[index] = CreateGemRow(flyout)
	end

	widget.sockets = view
end

local function GetSocketRecords(armory)
	local records = {}
	armory:CollectSocketRecords(records)

	-- Nothing socketed or no sockets: show a few empty ones
	if #records == 0 then
		for index = 1, 3 do
			records[index] = { socketIndex = index }
		end
	end

	return records
end

local function UpdateGemRows(armory, view, db)
	armory:ScanSocketGems()
	local gems = armory.socketGemCache or {}

	local rowHeight = E:Scale(db.rowHeight)
	local visible = min(#gems, db.maxRows, MAX_GEM_ROWS)
	local shown = max(visible, 1)

	for index, row in ipairs(view.rows) do
		local gem = gems[index]
		local show = index <= shown

		row:SetShown(show)
		if show then
			armory:SetSocketRowFont(row)

			if visible == 0 then
				row.icon:SetTexture(nil)
				row.label:SetText(L["No gems in bags."] or "No gems in bags.")
				row.label:SetTextColor(0.5, 0.5, 0.5)
				row.count:SetText("")
			else
				row.icon:SetTexture(gem.texture)
				row.label:SetTextColor(1, 1, 1)
				row.label:SetText(gem.link and armory:GetGemStatText(gem.link) or (L["Loading..."] or "Loading..."))
				row.count:SetText(format("%dx", GetItemCount(gem.itemID) or 1))
			end

			row:ClearAllPoints()
			row:SetPoint("TOPLEFT", 4, -4 - (index - 1) * rowHeight)
			row:SetPoint("TOPRIGHT", -4, -4 - (index - 1) * rowHeight)
		end
	end

	return E:Scale(8 + shown * db.rowHeight)
end

local function UpdateSockets(widget)
	local armory = GetArmory()
	local db = armory.db.socketPanel
	local view = widget.sockets

	local records = GetSocketRecords(armory)
	local count = min(#records, MAX_SOCKETS)
	local iconSize = E:Scale(db.iconSize)
	local spacing = E:Scale(db.spacing)
	local anchorX, anchorY = E:Scale(db.anchorX), E:Scale(db.anchorY)

	for index, button in ipairs(view.icons) do
		local record = records[index]
		button:SetShown(index <= count)
		if index <= count then
			button:SetSize(iconSize, iconSize)
			armory:PaintSocketIcon(button, record)
			button:ClearAllPoints()
			button:SetPoint("LEFT", view.panel, "LEFT", (index - 1) * (iconSize + spacing), 0)
		end
	end

	-- Placed like BuildSocketPanel: bottom right corner of the stats pane plus the offsets
	local panelWidth = max(iconSize, count * (iconSize + spacing) - spacing)
	view.panel:SetSize(panelWidth, iconSize)
	view.panel:ClearAllPoints()
	view.panel:SetPoint("BOTTOMRIGHT", view.pane, "BOTTOMRIGHT", anchorX, anchorY)

	-- Pane and sockets together are centered, the sockets may stick out of the pane
	local left = min(-PANE_WIDTH, anchorX - panelWidth)
	local right = max(0, anchorX)
	local top = 8 + max(0, anchorY + iconSize - PANE_HEIGHT)
	view.pane:ClearAllPoints()
	view.pane:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT", widget.frame:GetWidth() * 0.5 - (left + right) * 0.5, -top)

	local flyoutWidth = Preview.Width(widget, E:Scale(db.flyoutWidth), 8)
	local flyoutHeight = UpdateGemRows(armory, view, db)
	view.flyout:SetSize(flyoutWidth, flyoutHeight)
	view.flyout:ClearAllPoints()
	view.flyout:SetPoint("TOPLEFT", view.icons[1], "BOTTOMLEFT", 0, -E:Scale(4))

	local below = max(0, -anchorY)
	widget.frame:SetHeight(top + PANE_HEIGHT + below + E:Scale(4) + flyoutHeight + 12)

	Preview.SetEnabled(widget, armory.db.enable and db.enable)
end

-------------------------------------------------------------------------------
--  Gear sets
-------------------------------------------------------------------------------
local function CreateTextLink(parent, text)
	local link = parent:CreateFontString(nil, "OVERLAY")
	link:FontTemplate(E.media.normFont, 11, "NONE")
	link:SetText(text)
	link:SetTextColor(1, 1, 1, 0.8)
	return link
end

-- The parts of an AcquireEquipmentTile tile that StyleEquipmentTile paints
local function CreateTile(parent)
	local tile = CreateFrame("Frame", nil, parent)
	tile:SetHeight(TILE_HEIGHT)

	tile._bg = tile:CreateTexture(nil, "BACKGROUND")
	tile._bg:SetAllPoints()

	tile._selection = tile:CreateTexture(nil, "ARTWORK", nil, -1)
	tile._selection:SetAllPoints()

	tile._text = tile:CreateFontString(nil, "OVERLAY")
	tile._text:FontTemplate()
	tile._text:SetPoint("LEFT", tile, "LEFT", 10, 0)
	tile._text:SetPoint("RIGHT", tile, "RIGHT", -45, 0)
	tile._text:SetJustifyH("LEFT")

	tile._specIcon = tile:CreateTexture(nil, "OVERLAY")
	tile._specIcon:SetSize(16, 16)
	tile._specIcon:SetPoint("RIGHT", tile, "RIGHT", -45, 0)

	return tile
end

local function BuildGearSets(widget)
	local panel = CreateFrame("Frame", nil, widget.frame)
	panel:SetPoint("TOP", widget.frame, "TOP", 0, -8)

	panel.bg = panel:CreateTexture(nil, "BACKGROUND")
	panel.bg:SetAllPoints()
	panel.bg:SetColorTexture(0, 0, 0, 0.6)

	local header = CreateFrame("Frame", nil, panel)
	header:SetHeight(14)
	header:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -4)
	header:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -4, -4)

	panel.headerText = header:CreateFontString(nil, "OVERLAY")
	panel.headerText:FontTemplate()
	panel.headerText:SetPoint("CENTER", header, "CENTER", 0, 0)

	panel.headerLeftLine = header:CreateTexture(nil, "ARTWORK")
	panel.headerLeftLine:SetPoint("LEFT", header, "LEFT", 3, 0)
	panel.headerLeftLine:SetPoint("RIGHT", panel.headerText, "LEFT", -3, 0)
	panel.headerRightLine = header:CreateTexture(nil, "ARTWORK")
	panel.headerRightLine:SetPoint("LEFT", panel.headerText, "RIGHT", 3, 0)
	panel.headerRightLine:SetPoint("RIGHT", header, "RIGHT", -3, 0)

	local links = CreateFrame("Frame", nil, panel)
	links:SetHeight(14)
	links:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -8)
	links:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", 0, -8)

	CreateTextLink(links, L["New"] or "New"):SetPoint("LEFT", links, "LEFT", 4, 0)
	CreateTextLink(links, L["Equip"] or "Equip"):SetPoint("CENTER", links, "CENTER", 0, 0)
	panel.save = CreateTextLink(links, L["Save"] or "Save")
	panel.save:SetPoint("RIGHT", links, "RIGHT", -4, 0)

	panel.tiles = {}
	for index = 1, MAX_TILES + 1 do
		local tile = CreateTile(panel)
		tile:SetPoint("TOPLEFT", links, "BOTTOMLEFT", 0, -6 - (index - 1) * (TILE_HEIGHT + TILE_GAP))
		tile:SetPoint("TOPRIGHT", links, "BOTTOMRIGHT", -2, -6 - (index - 1) * (TILE_HEIGHT + TILE_GAP))
		panel.tiles[index] = tile
	end

	widget.gearSets = panel
end

-- Without own sets, samples show every look a set can have
local function GetSampleSets()
	return {
		{ name = _G.RAID or "Raid", numLost = 0, id = 1 },
		{ name = _G.PLAYER_DIFFICULTY_MYTHIC_PLUS or "Mythic+", numLost = 0, id = 2 },
		{ name = _G.PVP or "PvP", numLost = 2, id = 3 },
	},
		1
end

local function UpdateGearSets(widget)
	local armory = GetArmory()
	local db = armory.db.equipmentManager
	local panel = widget.gearSets

	local sets, activeSetID = armory:GetEquipmentSetList()
	if #sets == 0 then
		sets, activeSetID = GetSampleSets()
	end

	local count = min(#sets, MAX_TILES)
	local width = Preview.Width(widget, 220, 8)
	local height = 4 + 14 + 8 + 14 + 6 + (count + 1) * (TILE_HEIGHT + TILE_GAP) + 4
	panel:SetSize(width, height)
	widget.frame:SetHeight(height + 16)

	panel.bg:SetShown(db.showBackdrop)

	panel.headerText:SetText(L["Gear Sets"] or "Gear Sets")
	armory:StyleCategoryHeader(panel.headerText, panel.headerLeftLine, panel.headerRightLine)

	for index, tile in ipairs(panel.tiles) do
		local set = sets[index]
		tile:SetShown(index <= count + 1)
		tile._specIcon:Hide()

		if index <= count then
			local state = (set.id == activeSetID and "active") or (set.numLost > 0 and "incomplete") or nil
			-- The equipped set is the selected one when the pane opens
			armory:StyleEquipmentTile(tile, set.name, state, set.id == activeSetID)
			tile._specIcon:SetTexture(set.specIcon)
			tile._specIcon:SetShown(set.specIcon ~= nil)
		elseif index == count + 1 then
			armory:StyleEquipmentTile(tile, L["+ New Set"] or "+ New Set", "new")
		end
	end

	-- Saving the equipped set again does nothing, the module dims the link then
	panel.save:SetAlpha(activeSetID and 0.5 or 1)

	Preview.SetEnabled(widget, armory.db.enable and db.enable)
end

-------------------------------------------------------------------------------
--  Widget
-------------------------------------------------------------------------------
local function Build(widget)
	widget.frame:SetClipsChildren(true)
	BuildSockets(widget)
	BuildGearSets(widget)
end

local function Update(widget, key)
	local isSockets = key == "sockets"
	widget.sockets:SetShown(isSockets)
	widget.gearSets:SetShown(not isSockets)

	if isSockets then
		UpdateSockets(widget)
	else
		UpdateGearSets(widget)
	end
end

Preview.Register("MERArmoryPanesPreview", 1, 160, Build, Update)
