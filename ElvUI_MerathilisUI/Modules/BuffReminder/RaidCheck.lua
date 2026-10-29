local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BuffReminder")
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

-------------------------------------------------------------------------------
--  Raid Buff Check: a window listing each group member's flask, food, augment
--  rune, vantus rune and missing raid buffs. Opens with /buffcheck, the button
--  on the options page and optionally on every ready check while you lead or
--  assist. Independent of the reminder icons, off by default.
--
--  Out of combat only, it hides when combat starts. Flask and raid buff IDs are
--  non-secret and looked up by ID. Food has no fixed ID and needs an index scan,
--  which errors under the aura restriction, so food reads as unknown there, and
--  so do augment and vantus runes while their IDs are secret. Durability,
--  weapon oils and healthstones of other players are not readable at all.
-------------------------------------------------------------------------------

local _G = _G
local ipairs, pairs, pcall, type = ipairs, pairs, pcall, type
local ceil, floor, max = math.ceil, math.floor, math.max
local format, sort, strlower, tinsert, wipe = format, sort, strlower, tinsert, wipe

local C_Timer = C_Timer
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetNumGroupMembers = GetNumGroupMembers
local GetNumSubgroupMembers = GetNumSubgroupMembers
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsVisible = UnitIsVisible
local UnitName = UnitName

local C_Item_GetItemIconByID = C_Item.GetItemIconByID
local C_Spell_GetSpellTexture = C_Spell.GetSpellTexture
local C_UnitAuras_GetAuraDataByIndex = C_UnitAuras.GetAuraDataByIndex
local C_UnitAuras_GetUnitAuraBySpellID = C_UnitAuras.GetUnitAuraBySpellID

local WELL_FED_ICON = 136000
local EATING_ICON = 133950
local AURA_SCAN_LIMIT = 255
local EXPIRE_SOON = 600 -- under 10 minutes left shows the time instead of a check
local TICK = 15 -- repaint interval for the countdowns while the window is open
local TEX_YES = "Interface\\RaidFrame\\ReadyCheck-Ready"
local TEX_NO = "Interface\\RaidFrame\\ReadyCheck-NotReady"
-- Header icons come from items, the buff spells have no cached texture
local FLASK_SPELL = 1235110
local RUNE_ITEM = 259085
local VANTUS_ITEM = 272195

-- Flasks on top of the ones the reminder tracks (module.FLASK_BUFF_ID_SET):
-- the other Midnight flask, its PvP variants and The War Within's
local EXTRA_FLASK_IDS = {
	1239355,
	1235113,
	1235114,
	1235115,
	1235116,
	432473,
	432021,
	431974,
	431973,
	431972,
	431971,
}
-- Older augment runes count as missing
local OLD_RUNE_IDS = { 1234969, 1242347, 453250, 393438, 347901 }
-- Midnight boss buffs of Vantus Runes (Season 1 and 2, both IDs of each boss)
local VANTUS_IDS = {
	1276666,
	1276669,
	1276682,
	1276683,
	1276685,
	1276686,
	1276687,
	1276688,
	1276691,
	1276698,
	1276704,
	1276705,
	1276708,
	1276709,
	1276711,
	1276712,
	1276714,
	1276715,
	1300173,
	1300174,
	1303172,
	1303173,
	1303174,
	1303175,
	1303176,
	1303177,
	1303178,
	1303179,
	1303180,
	1303181,
	1303182,
	1303183,
	1303184,
	1303185,
	1303186,
	1303187,
	1310437,
	1310439,
	1319284,
	1319286,
}

local PADDING, HEADER_HEIGHT, COLUMN_HEIGHT = 8, 26, 20
local ROW_HEIGHT, NAME_WIDTH, CELL_WIDTH, ICON_SIZE = 18, 110, 24, 14
local BUFF_SLOTS, BUFF_STEP = 6, 16
local CELLS = 4 -- flask, food, rune, vantus
local RUNE_COLUMN = 3
local BLOCK_GAP = 12
local ROWS_PER_BLOCK = 20
local TOTAL_ROWS = 3 -- missing, expiring soon, unknown
local MIN_WIDTH = 400
local NOTE_HEIGHT = 18
local CHECKBOX_HEIGHT = 24

local frame
local events = CreateFrame("Frame")
local flaskIDs
local rows, heads = {}, {}
local units = {} -- display order
local isMember = {} -- [unit] = true for listed group members
local states = {} -- [unit] = last computed state
local shownUnits = {}
local providers = {} -- [class] = true for connected members
local dirty, flushPending = {}, false
local runeReadable, vantusReadable -- every ID of the list is non-secret, set on the first open
local Render

-- Column geometry. The rune column drops out while Require Augment Rune is off,
-- SetColumns bumps columnsKey and rows, headers and totals re-place themselves.
local columnShown, columnX = { true, true, true, true }, {}
local buffsX, blockWidth
local columnsKey = 0

local function SetColumns(runeShown)
	if buffsX and columnShown[RUNE_COLUMN] == runeShown then
		return
	end
	columnShown[RUNE_COLUMN] = runeShown
	local x = NAME_WIDTH
	for k = 1, CELLS do
		columnX[k] = x
		if columnShown[k] then
			x = x + CELL_WIDTH
		end
	end
	buffsX = x + 4
	blockWidth = buffsX + BUFF_SLOTS * BUFF_STEP + 2
	columnsKey = columnsKey + 1
end
SetColumns(true)

local function GetDB()
	return module.db and module.db.raidCheck
end

local function Enabled()
	local db = GetDB()
	return db and db.enable
end

local function CanLead()
	if IsInRaid() then
		return UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")
	end
	return IsInGroup() and UnitIsGroupLeader("player")
end

-- Restricted while auras are secret, an index scan errors then
local function Restricted()
	if _G.C_Secrets and _G.C_Secrets.ShouldAurasBeSecret and _G.C_Secrets.ShouldAurasBeSecret() then
		return true
	end
	return not pcall(C_UnitAuras_GetAuraDataByIndex, "player", 1, "HELPFUL")
end

-------------------------------------------------------------------------------
--  Aura lookups
-------------------------------------------------------------------------------
local function AllReadable(ids)
	local should = _G.C_Secrets and _G.C_Secrets.ShouldSpellAuraBeSecret
	if not should then
		return true
	end
	for i = 1, #ids do
		local ok, secret = pcall(should, ids[i])
		if not ok or E:IsSecretValue(secret) or secret ~= false then
			return false
		end
	end
	return true
end

-- A present aura reads as its expiration time, or true when that is secret or
-- the aura never expires
local function Present(aura)
	local exp = aura.expirationTime
	if exp == nil or E:IsSecretValue(exp) or exp == 0 then
		return true
	end
	return exp
end

-- Non-nil means the aura is there, even when its fields are secret
local function FindID(unit, id)
	local ok, aura = pcall(C_UnitAuras_GetUnitAuraBySpellID, unit, id)
	if ok and aura ~= nil then
		return Present(aura)
	end
end

-- States: true or an expiration time = has it, false = missing,
-- nil = cannot tell, "eating" = food channel up
local function ListState(unit, ids, readable, restricted)
	for i = 1, #ids do
		local v = FindID(unit, ids[i])
		if v then
			return v
		end
	end
	if restricted and not readable then
		return nil
	end
	return false
end

local function FoodState(unit, restricted)
	if restricted then
		return nil
	end
	local sawReadable, eating = false, false
	for i = 1, AURA_SCAN_LIMIT do
		local ok, aura = pcall(C_UnitAuras_GetAuraDataByIndex, unit, i, "HELPFUL")
		if not ok then
			return nil
		end
		if not aura then
			break
		end
		local icon = aura.icon
		if icon ~= nil and not E:IsSecretValue(icon) then
			sawReadable = true
			if icon == WELL_FED_ICON then
				return Present(aura)
			end
			-- Eating only counts when no stat buff is up, refreshing one shows both
			if icon == EATING_ICON then
				eating = true
			end
		end
	end
	if eating then
		return "eating"
	end
	if not sawReadable then
		return nil
	end
	return false
end

-- Seconds left when under EXPIRE_SOON, else nil
local function SoonLeft(v, now)
	if type(v) ~= "number" then
		return nil
	end
	local left = v - now
	if left < EXPIRE_SOON then
		return max(0, left)
	end
end

local function MinutesText(left)
	return format(L["%dm"], ceil(left / 60))
end

local function UnitClassToken(unit)
	local _, class = UnitClass(unit)
	if class == nil or E:IsSecretValue(class) then
		return nil
	end
	return class
end

-------------------------------------------------------------------------------
--  Window
-------------------------------------------------------------------------------
local function CreateText(parent, size)
	local text = parent:CreateFontString(nil, "OVERLAY")
	text:FontTemplate(nil, size or 11, "OUTLINE")
	return text
end

local function SetCell(cell, state, now)
	if state == nil then
		cell.tex:Hide()
		cell.text:SetText("?")
		cell.text:SetTextColor(0.6, 0.6, 0.6)
		cell.text:Show()
		return
	end
	local left = SoonLeft(state, now)
	if left then
		cell.tex:Hide()
		cell.text:SetText(MinutesText(left))
		cell.text:SetTextColor(1, 0.8, 0.2)
		cell.text:Show()
		return
	end
	cell.text:Hide()
	if state == "eating" then
		cell.tex:SetTexture(EATING_ICON)
		cell.tex:SetTexCoord(unpack(E.TexCoords))
	else
		cell.tex:SetTexture(state and TEX_YES or TEX_NO)
		cell.tex:SetTexCoord(0, 1, 0, 1)
	end
	cell.tex:Show()
end

local function CreateCell(parent)
	local cell = CreateFrame("Frame", nil, parent)
	cell:SetSize(CELL_WIDTH, ROW_HEIGHT)
	cell.tex = cell:CreateTexture(nil, "ARTWORK")
	cell.tex:SetSize(ICON_SIZE, ICON_SIZE)
	cell.tex:SetPoint("CENTER")
	cell.text = CreateText(cell)
	cell.text:SetPoint("CENTER")
	return cell
end

local function CreateRow(index)
	local row = CreateFrame("Frame", nil, frame.Table)
	row:SetHeight(ROW_HEIGHT)
	if index % 2 == 0 then
		local stripe = row:CreateTexture(nil, "BACKGROUND")
		stripe:SetColorTexture(1, 1, 1, 0.03)
		stripe:SetAllPoints(row)
	end

	row.name = CreateText(row)
	row.name:SetPoint("LEFT", row, "LEFT", 4, 0)
	row.name:SetWidth(NAME_WIDTH - 6)
	row.name:SetJustifyH("LEFT")
	row.name:SetWordWrap(false)

	row.cells = {}
	for k = 1, CELLS do
		row.cells[k] = CreateCell(row)
	end

	row.buffs = {}
	for j = 1, BUFF_SLOTS do
		local tex = row:CreateTexture(nil, "ARTWORK")
		tex:SetSize(ICON_SIZE, ICON_SIZE)
		tex:SetTexCoord(unpack(E.TexCoords))
		row.buffs[j] = tex
	end
	row.buffsOk = row:CreateTexture(nil, "ARTWORK")
	row.buffsOk:SetSize(ICON_SIZE, ICON_SIZE)
	row.buffsOk:SetTexture(TEX_YES)
	row.buffsText = CreateText(row)
	row.buffsText:SetPoint("LEFT", row.buffsOk, "LEFT", 0, 0)

	rows[index] = row
	return row
end

local function PlaceRow(row)
	if row.columnsKey == columnsKey then
		return
	end
	row.columnsKey = columnsKey
	row:SetWidth(blockWidth)
	for k = 1, CELLS do
		local cell = row.cells[k]
		cell:ClearAllPoints()
		cell:SetPoint("LEFT", row, "LEFT", columnX[k], 0)
		cell:SetShown(columnShown[k])
	end
	for j = 1, BUFF_SLOTS do
		row.buffs[j]:ClearAllPoints()
		row.buffs[j]:SetPoint("LEFT", row, "LEFT", buffsX + (j - 1) * BUFF_STEP, 0)
	end
	row.buffsOk:ClearAllPoints()
	row.buffsOk:SetPoint("LEFT", row, "LEFT", buffsX, 0)
end

local function ShowTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOP")
	GameTooltip:SetText(self.tooltip)
	GameTooltip:Show()
end

local function CreateHeader(block)
	local head = CreateFrame("Frame", nil, frame.Table)
	head:SetHeight(COLUMN_HEIGHT)
	head.icons = {}

	local function AddIcon(texture, tooltip)
		local hit = CreateFrame("Frame", nil, head)
		hit:SetSize(CELL_WIDTH, COLUMN_HEIGHT)
		local tex = hit:CreateTexture(nil, "ARTWORK")
		tex:SetSize(ICON_SIZE + 2, ICON_SIZE + 2)
		tex:SetPoint("CENTER")
		tex:SetTexture(texture)
		tex:SetTexCoord(unpack(E.TexCoords))
		hit.tooltip = tooltip
		hit:EnableMouse(true)
		hit:SetScript("OnEnter", ShowTooltip)
		hit:SetScript("OnLeave", GameTooltip_Hide)
		head.icons[#head.icons + 1] = hit
	end
	AddIcon(C_Spell_GetSpellTexture(FLASK_SPELL), L["Flask"])
	AddIcon(WELL_FED_ICON, L["Food"])
	AddIcon(C_Item_GetItemIconByID(RUNE_ITEM), L["Augment Rune"])
	AddIcon(C_Item_GetItemIconByID(VANTUS_ITEM), L["Vantus Rune"])

	head.buffsLabel = CreateText(head)
	head.buffsLabel:SetTextColor(0.8, 0.8, 0.8)
	head.buffsLabel:SetText(L["Raid Buffs"])

	heads[block] = head
	return head
end

local function PlaceHeader(head)
	if head.columnsKey == columnsKey then
		return
	end
	head.columnsKey = columnsKey
	head:SetWidth(blockWidth)
	for k = 1, CELLS do
		local hit = head.icons[k]
		hit:ClearAllPoints()
		hit:SetPoint("LEFT", head, "LEFT", columnX[k], 0)
		hit:SetShown(columnShown[k])
	end
	head.buffsLabel:ClearAllPoints()
	head.buffsLabel:SetPoint("LEFT", head, "LEFT", buffsX, 0)
end

local function PlaceTotals(totalRow)
	if totalRow.columnsKey == columnsKey then
		return
	end
	totalRow.columnsKey = columnsKey
	totalRow:SetWidth(blockWidth)
	for k = 1, CELLS do
		local count = totalRow.counts[k]
		count:ClearAllPoints()
		count:SetPoint("CENTER", totalRow, "LEFT", columnX[k] + CELL_WIDTH / 2, 0)
		count:SetShown(columnShown[k])
	end
	totalRow.counts[CELLS + 1]:ClearAllPoints()
	totalRow.counts[CELLS + 1]:SetPoint("CENTER", totalRow, "LEFT", buffsX + ICON_SIZE / 2, 0)
end

-- Plain events only, the window's events follow the window, READY_CHECK the option
local function Listen(shown)
	events:UnregisterAllEvents()
	local db = GetDB()
	if Enabled() and db.onReadyCheck then
		events:RegisterEvent("READY_CHECK")
	end
	if shown then
		events:RegisterEvent("UNIT_AURA")
		events:RegisterEvent("GROUP_ROSTER_UPDATE")
		events:RegisterEvent("UNIT_CONNECTION")
		events:RegisterEvent("PLAYER_REGEN_DISABLED")
	end
end

-- Saved as a TOPLEFT offset: the size follows the roster and the filter, and
-- the top left corner has to stay put while it does
local function SavePosition()
	local left, top = frame:GetLeft(), frame:GetTop()
	if not (left and top) then
		return
	end
	local x, y = left, top - E.UIParent:GetTop()
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", x, y)
	GetDB().position = { x = x, y = y }
end

local function ApplyPosition()
	local position = GetDB().position
	frame:ClearAllPoints()
	if position then
		frame:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", position.x, position.y)
	else
		frame:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", E.UIParent:GetWidth() / 2 - MIN_WIDTH / 2, -150)
	end
end

local function CreateCheckBox(text, key)
	local checkBox = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
	checkBox:SetSize(18, 18)
	S:HandleCheckBox(checkBox)

	local label = CreateText(checkBox)
	label:SetPoint("LEFT", checkBox, "RIGHT", 4, 0)
	label:SetText(text)
	-- The label clicks the box too
	checkBox:SetHitRectInsets(0, -(label:GetStringWidth() + 4), 0, 0)
	checkBox.label = label

	checkBox:SetScript("OnClick", function(self)
		GetDB()[key] = self:GetChecked() and true or false
		Render()
	end)

	return checkBox
end

local function CreateWindow()
	frame = CreateFrame("Frame", "MER_RaidBuffCheck", E.UIParent)
	frame:SetFrameStrata("MEDIUM")
	frame:SetTemplate("Transparent")
	WS:CreateShadow(frame)
	frame:SetClampedToScreen(true)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		SavePosition()
	end)
	frame:Hide()
	frame:SetScript("OnHide", function(self)
		self:StopMovingOrSizing()
		Listen(false)
		if self.ticker then
			self.ticker:Cancel()
			self.ticker = nil
		end
	end)
	tinsert(_G.UISpecialFrames, "MER_RaidBuffCheck")

	local title = CreateText(frame, 13)
	title:SetPoint("LEFT", frame, "TOPLEFT", PADDING, -HEADER_HEIGHT / 2)
	title:SetText(L["Raid Buff Check"])

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("RIGHT", frame, "TOPRIGHT", 2, -HEADER_HEIGHT / 2)
	S:HandleCloseButton(close)

	local cc = E.myClassColor
	local accent = frame:CreateTexture(nil, "ARTWORK")
	accent:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -HEADER_HEIGHT)
	accent:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -HEADER_HEIGHT)
	accent:SetHeight(1)
	accent:SetColorTexture(cc.r, cc.g, cc.b, 0.8)

	frame.OnlyMissing = CreateCheckBox(L["Hide Fully Buffed"], "onlyMissing")
	frame.OnlyMissing:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", PADDING, NOTE_HEIGHT + (CHECKBOX_HEIGHT - 18) / 2)
	frame.RuneRequired = CreateCheckBox(L["Require Augment Rune"], "runeRequired")
	frame.RuneRequired:SetPoint("LEFT", frame.OnlyMissing.label, "RIGHT", 16, 0)

	frame.Empty = CreateText(frame)
	frame.Empty:SetPoint("TOPLEFT", frame, "TOPLEFT", PADDING + 4, -HEADER_HEIGHT - 8)
	frame.Empty:SetTextColor(0.4, 0.9, 0.4)
	frame.Empty:SetText(L["Everyone is fully buffed."])
	frame.Empty:Hide()

	-- Column headers, player rows and totals in one container, so "everyone
	-- fully buffed" hides them in one go
	frame.Table = CreateFrame("Frame", nil, frame)
	frame.Table:SetAllPoints(frame)

	local labels = { L["Missing"], L["Expiring Soon"], L["Unknown"] }
	frame.Totals = {}
	for t = 1, TOTAL_ROWS do
		local totalRow = CreateFrame("Frame", nil, frame.Table)
		totalRow:SetHeight(ROW_HEIGHT)
		local label = CreateText(totalRow)
		label:SetPoint("LEFT", totalRow, "LEFT", 4, 0)
		label:SetTextColor(0.85, 0.85, 0.85)
		label:SetText(labels[t])
		totalRow.counts = {}
		for k = 1, CELLS + 1 do
			totalRow.counts[k] = CreateText(totalRow)
		end
		frame.Totals[t] = totalRow
	end
	frame.Separator = frame.Table:CreateTexture(nil, "ARTWORK")
	frame.Separator:SetColorTexture(1, 1, 1, 0.15)
	frame.Separator:SetHeight(1)

	frame.Note = CreateText(frame, 10)
	frame.Note:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", PADDING, 5)
	frame.Note:SetTextColor(0.6, 0.6, 0.6)

	ApplyPosition()
end

-------------------------------------------------------------------------------
--  Roster and refresh: a state per unit, then Render draws the shown subset
-------------------------------------------------------------------------------
-- Alphabetical by name, a secret name sorts last by unit token
local sortName = {}
local function SortByName(a, b)
	local na, nb = sortName[a], sortName[b]
	if na ~= nb then
		if not na then
			return false
		end
		if not nb then
			return true
		end
		return na < nb
	end
	return a < b
end

local function CollectUnits()
	wipe(units)
	wipe(providers)
	wipe(isMember)
	if IsInRaid() then
		for i = 1, GetNumGroupMembers() do
			local unit = "raid" .. i
			if UnitExists(unit) then
				units[#units + 1] = unit
			end
		end
	else
		units[1] = "player"
		for i = 1, GetNumSubgroupMembers() do
			local unit = "party" .. i
			if UnitExists(unit) then
				units[#units + 1] = unit
			end
		end
	end

	wipe(sortName)
	for _, unit in ipairs(units) do
		local name = UnitName(unit)
		if name ~= nil and not E:IsSecretValue(name) then
			sortName[unit] = strlower(name)
		end
	end
	sort(units, SortByName)

	for _, unit in ipairs(units) do
		isMember[unit] = true
		local class = UnitIsConnected(unit) and UnitClassToken(unit)
		if class then
			providers[class] = true
		end
	end
end

local function ComputeState(unit, restricted)
	local state = states[unit]
	if not state then
		state = { icons = {} }
		states[unit] = state
	end

	local online, dead, visible = UnitIsConnected(unit), UnitIsDeadOrGhost(unit), UnitIsVisible(unit)
	if E:IsSecretValue(online) then
		online = true
	end
	if E:IsSecretValue(dead) then
		dead = false
	end
	if E:IsSecretValue(visible) then
		visible = true
	end
	state.online = online
	state.missing = 0
	state.buffsExp = nil

	local icons = state.icons
	if not online or dead or not visible then
		state.flask, state.food, state.rune, state.vantus = nil, nil, nil, nil
		wipe(icons)
		return
	end

	state.flask = ListState(unit, flaskIDs, true, false)
	state.food = FoodState(unit, restricted)
	state.rune = ListState(unit, module.RUNE_BUFF_IDS, runeReadable, restricted)
	if not state.rune and ListState(unit, OLD_RUNE_IDS, true, false) then
		state.rune = false
	end
	state.vantus = ListState(unit, VANTUS_IDS, vantusReadable, restricted)

	local n = 0
	for _, buff in ipairs(module.RAID_BUFFS) do
		if providers[buff.class] then
			local has
			for _, id in ipairs(buff.buffIDs) do
				has = FindID(unit, id)
				if has then
					break
				end
			end
			if not has then
				n = n + 1
				icons[n] = buff.castSpell
			elseif type(has) == "number" and (not state.buffsExp or has < state.buffsExp) then
				state.buffsExp = has
			end
		end
	end
	for j = #icons, n + 1, -1 do
		icons[j] = nil
	end
	state.missing = n
end

-- Missing, unknown and running out count, eating does not
local function NotFullyBuffed(state, now, runeRequired)
	if runeRequired and (not state.rune or SoonLeft(state.rune, now)) then
		return true
	end
	return not state.flask
		or not state.food
		or not state.vantus
		or state.missing > 0
		or SoonLeft(state.flask, now)
		or SoonLeft(state.food, now)
		or SoonLeft(state.vantus, now)
		or SoonLeft(state.buffsExp, now)
end

local function PaintRow(row, unit, now)
	local state = states[unit]
	local name = UnitName(unit)
	row.name:SetText(name ~= nil and not E:IsSecretValue(name) and name or "?")

	local class = UnitClassToken(unit)
	local color = class and E:ClassColor(class)
	if color and state.online then
		row.name:SetTextColor(color.r, color.g, color.b)
	else
		row.name:SetTextColor(0.5, 0.5, 0.5)
	end

	SetCell(row.cells[1], state.flask, now)
	SetCell(row.cells[2], state.food, now)
	SetCell(row.cells[3], state.rune, now)
	SetCell(row.cells[4], state.vantus, now)

	local icons = state.icons
	for j = 1, BUFF_SLOTS do
		local id = icons[j]
		if id then
			row.buffs[j]:SetTexture(C_Spell_GetSpellTexture(id))
			row.buffs[j]:Show()
		else
			row.buffs[j]:Hide()
		end
	end

	-- The flask is nil only for a row that was not read at all (offline, dead, out of range)
	local left = state.missing == 0 and SoonLeft(state.buffsExp, now)
	row.buffsOk:SetShown(state.flask ~= nil and state.missing == 0 and not left)
	if state.flask == nil then
		row.buffsText:SetText("?")
		row.buffsText:SetTextColor(0.6, 0.6, 0.6)
		row.buffsText:Show()
	elseif left then
		row.buffsText:SetText(MinutesText(left))
		row.buffsText:SetTextColor(1, 0.8, 0.2)
		row.buffsText:Show()
	else
		row.buffsText:Hide()
	end
end

local function Layout(n, numTotals)
	local footer = 6 + CHECKBOX_HEIGHT + NOTE_HEIGHT
	if n == 0 then
		frame:SetSize(MIN_WIDTH, HEADER_HEIGHT + 2 + ROW_HEIGHT + footer)
		return
	end

	local blocks = max(1, ceil(n / ROWS_PER_BLOCK))
	local perBlock = max(1, ceil(n / blocks))
	for b = 1, blocks do
		local head = heads[b] or CreateHeader(b)
		PlaceHeader(head)
		head:ClearAllPoints()
		head:SetPoint("TOPLEFT", frame, "TOPLEFT", PADDING + (b - 1) * (blockWidth + BLOCK_GAP), -HEADER_HEIGHT - 4)
		head:Show()
	end
	for b = blocks + 1, #heads do
		heads[b]:Hide()
	end

	for i = 1, n do
		local row = rows[i] or CreateRow(i)
		PlaceRow(row)
		local block = floor((i - 1) / perBlock)
		local slot = (i - 1) % perBlock
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", heads[block + 1], "BOTTOMLEFT", 0, -slot * ROW_HEIGHT)
		row:Show()
	end
	for i = n + 1, #rows do
		rows[i]:Hide()
	end

	frame:SetSize(
		max(MIN_WIDTH, PADDING * 2 + blocks * blockWidth + (blocks - 1) * BLOCK_GAP),
		HEADER_HEIGHT + 4 + COLUMN_HEIGHT + perBlock * ROW_HEIGHT + numTotals * ROW_HEIGHT + footer
	)
end

-- totals[row][column], the columns are flask, food, rune, vantus, raid buffs
local totals = { {}, {}, {} }

local function Tally(column, v, now)
	if v == false then
		totals[1][column] = totals[1][column] + 1
	elseif v == nil then
		totals[3][column] = totals[3][column] + 1
	elseif SoonLeft(v, now) then
		totals[2][column] = totals[2][column] + 1
	end
end

function Render()
	local db = GetDB()
	local onlyMissing, runeRequired = db.onlyMissing, db.runeRequired
	SetColumns(runeRequired)
	local now = GetTime()

	for t = 1, TOTAL_ROWS do
		for k = 1, CELLS + 1 do
			totals[t][k] = 0
		end
	end

	wipe(shownUnits)
	for _, unit in ipairs(units) do
		local state = states[unit]
		if state then
			Tally(1, state.flask, now)
			Tally(2, state.food, now)
			Tally(3, state.rune, now)
			Tally(4, state.vantus, now)
			-- Raid buffs: an unread row is unknown, a missing buff missing, else the soonest expiry
			if state.flask == nil then
				totals[3][5] = totals[3][5] + 1
			elseif state.missing > 0 then
				totals[1][5] = totals[1][5] + 1
			elseif SoonLeft(state.buffsExp, now) then
				totals[2][5] = totals[2][5] + 1
			end
			if not onlyMissing or NotFullyBuffed(state, now, runeRequired) then
				shownUnits[#shownUnits + 1] = unit
			end
		end
	end

	-- Totals rows with a non-zero count, stacked upward from the checkboxes
	local numTotals, top = 0, nil
	for t = TOTAL_ROWS, 1, -1 do
		local totalRow = frame.Totals[t]
		PlaceTotals(totalRow)
		local any = false
		for k = 1, CELLS + 1 do
			local count = totals[t][k]
			totalRow.counts[k]:SetText(count)
			if count == 0 then
				totalRow.counts[k]:SetTextColor(0.3, 0.9, 0.3)
			else
				totalRow.counts[k]:SetTextColor(1, 0.3, 0.3)
				-- A hidden column's count does not keep its row up
				if k > CELLS or columnShown[k] then
					any = true
				end
			end
		end
		totalRow:SetShown(any)
		if any then
			totalRow:ClearAllPoints()
			totalRow:SetPoint(
				"BOTTOMLEFT",
				frame,
				"BOTTOMLEFT",
				PADDING,
				NOTE_HEIGHT + CHECKBOX_HEIGHT + numTotals * ROW_HEIGHT
			)
			numTotals = numTotals + 1
			top = totalRow
		end
	end
	frame.Separator:ClearAllPoints()
	if top then
		frame.Separator:SetPoint("BOTTOMLEFT", top, "TOPLEFT", 0, 1)
		frame.Separator:SetPoint("BOTTOMRIGHT", top, "TOPRIGHT", 0, 1)
	end
	frame.Separator:SetShown(top ~= nil)

	local n = #shownUnits
	Layout(n, numTotals)
	for i = 1, n do
		PaintRow(rows[i], shownUnits[i], now)
	end

	-- Nobody listed: no headers and no totals either, even when a column the
	-- filter ignores has a count
	frame.Table:SetShown(n > 0)
	frame.Empty:SetShown(n == 0)
	frame.OnlyMissing:SetChecked(onlyMissing)
	frame.RuneRequired:SetChecked(runeRequired)
	if frame.restricted then
		frame.Note:SetText(L["Food and runes cannot be read here (aura restriction). ? = unknown"])
	else
		frame.Note:SetText(L["? = unknown (offline, dead or out of range)"])
	end
end

local function Rebuild()
	if not (frame and frame:IsShown()) or InCombatLockdown() then
		return
	end
	CollectUnits()
	local restricted = Restricted()
	frame.restricted = restricted
	wipe(states)
	for _, unit in ipairs(units) do
		ComputeState(unit, restricted)
	end
	Render()
end

local function Flush()
	flushPending = false
	if not (frame and frame:IsShown()) or InCombatLockdown() then
		wipe(dirty)
		return
	end
	local restricted = Restricted()
	frame.restricted = restricted
	for unit in pairs(dirty) do
		if isMember[unit] then
			ComputeState(unit, restricted)
		end
	end
	wipe(dirty)
	Render()
end

-------------------------------------------------------------------------------
--  Open, close, events
-------------------------------------------------------------------------------
local function Open()
	if InCombatLockdown() then
		F.Print(L["Raid Buff Check cannot be opened in combat."])
		return
	end

	if not flaskIDs then
		flaskIDs = {}
		for id in pairs(module.FLASK_BUFF_ID_SET) do
			flaskIDs[#flaskIDs + 1] = id
		end
		for _, id in ipairs(EXTRA_FLASK_IDS) do
			flaskIDs[#flaskIDs + 1] = id
		end
		runeReadable = AllReadable(module.RUNE_BUFF_IDS)
		vantusReadable = AllReadable(VANTUS_IDS)
	end

	if not frame then
		CreateWindow()
	end
	frame:Show()
	Listen(true)
	Rebuild()
	if not frame.ticker then
		frame.ticker = C_Timer.NewTicker(TICK, Render)
	end
end

events:SetScript("OnEvent", function(_, event, unit)
	if event == "UNIT_AURA" or event == "UNIT_CONNECTION" then
		if not isMember[unit] then
			return
		end
		dirty[unit] = true
		if not flushPending then
			flushPending = true
			C_Timer.After(0.2, Flush)
		end
	elseif event == "GROUP_ROSTER_UPDATE" then
		Rebuild()
	elseif event == "READY_CHECK" then
		if CanLead() then
			Open()
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		frame:Hide()
	end
end)

function module:ToggleRaidCheck()
	if not Enabled() then
		F.Print(L["Raid Buff Check is turned off, it can be enabled in the Buff Reminder options."])
		return
	end
	if frame and frame:IsShown() then
		frame:Hide()
	else
		Open()
	end
end

---Called on load, profile switch and option changes
function module:UpdateRaidCheck()
	if E.Forever then
		return
	end

	if not self.raidCheckCommand then
		self.raidCheckCommand = true
		MER:AddCommand("RAIDBUFFCHECK", "/buffcheck", function()
			module:ToggleRaidCheck()
		end)
	end

	if frame then
		if Enabled() then
			ApplyPosition()
		else
			frame:Hide()
		end
	end
	Listen(frame and frame:IsShown())
	if frame and frame:IsShown() then
		Render()
	end
end
