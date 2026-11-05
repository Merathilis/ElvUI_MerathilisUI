local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Armory") ---@class Armory

--------------------------------------------------------------------------------
-- The Armory on WoW Forever's own character frame (Blizzard_UIPanels_Game/Camelot)
--
-- Core.lua runs on Forever as well (background, stage, lines, name header, slot
-- gradients and enchants through ElvUI's item level strings, flyouts, title search).
-- This file adapts it to Forever's frame:
--   - Classic slot ids: ranged 18, tabard 19, and the off hand between two weapons
--   - the name header sits a little higher, the model scene starts under a 36px strip
--   - the background is cropped to the wider two-pane frame
--   - the stats stay Blizzard's scroll box lists (player and pet), restyled with the
--     Armory's header, label and value fonts, and fading in on open
--   - each slot shows the item's main and secondary stat in place of its item level,
--     weapons their damage per second (item levels say little on Forever)
--   - enchants are read from the tooltip's enchant line, which lacks the
--     "Enchanted:" prefix ElvUI looks for
-- Stat picker, gear set panel, socket panel and upgrade tracks are Retail only.
--------------------------------------------------------------------------------
if not E.Forever then
	return
end

local _G = _G
local format, gsub, strmatch, utf8sub = string.format, string.gsub, string.match, string.utf8sub
local ipairs, pairs, select, tonumber, wipe = ipairs, pairs, select, tonumber, wipe

local GetInventoryItemLink = GetInventoryItemLink
local hooksecurefunc = hooksecurefunc

local GetItemInfoInstant = C_Item.GetItemInfoInstant
local GetItemStats = C_Item.GetItemStats
local GetTooltipInventoryItem = C_TooltipInfo and C_TooltipInfo.GetInventoryItem
local IsRangedSlotShown = C_PaperDollInfo.IsRangedSlotShown

local ENUM_ITEM_CLASS_WEAPON = Enum.ItemClass.Weapon
local ENCHANT_LINE_TYPE = Enum.TooltipDataLineType and Enum.TooltipDataLineType.ItemEnchantmentPermanent

--------------------------------------------------------------------------------
-- Slots
--------------------------------------------------------------------------------
-- Classic inventory ids: 18 is the ranged slot, the tabard moved to 19
module.characterSlots.TabardSlot.id = 19
module.characterSlots.RangedSlot = {
	id = 18,
	needsEnchant = false,
	needsSocket = false,
	direction = module.enumDirection.LEFT,
}

wipe(module.slotIdToName)
for slot, options in pairs(module.characterSlots) do
	module.slotIdToName[options.id] = slot
end

module.noInfoSlots = { [4] = true, [19] = true }

-- The model scene starts 56px below the frame top, under the 20px title bar and Blizzard's
-- 36px level strip (hidden by ElvUI). Name and level line sit below the decorative top
-- line, the name at the strip's top, the level line under it, above the head slots
module.nameOffsetY = 32
module.levelOffsetY = 10

---Weapons sit in one row under the model. With a ranged slot the off hand is the
---middle one and gets no quality gradient (it would run into its neighbours)
local function UpdateWeaponDirections()
	local rangedShown = not IsRangedSlotShown or IsRangedSlotShown()
	module.characterSlots.SecondaryHandSlot.direction = rangedShown and module.enumDirection.BOTTOM
		or module.enumDirection.LEFT
end

--------------------------------------------------------------------------------
-- Slot text: the item's stats in place of the item level
--------------------------------------------------------------------------------
-- C_Item.GetItemStats keys in tie order (an earlier key wins a tie). The main stat
-- is the largest of the primaries, else of stamina and spirit; the secondary one
-- the largest of every other listed key. Built on first use.
local STAT_KEYS
local NUM_PRIMARY, NUM_MAIN = 3, 5

local function GetStatKeys()
	if STAT_KEYS then
		return STAT_KEYS
	end

	local crit, hit, mp5, hp5 = L["Crit"], L["Hit"], L["MP5"], L["HP5"]
	STAT_KEYS = {
		{ "ITEM_MOD_STRENGTH_SHORT", L["Str"] },
		{ "ITEM_MOD_AGILITY_SHORT", L["Agi"] },
		{ "ITEM_MOD_INTELLECT_SHORT", L["Int"] },
		{ "ITEM_MOD_STAMINA_SHORT", L["Stam"] },
		{ "ITEM_MOD_SPIRIT_SHORT", L["Spi"] },
		{ "ITEM_MOD_ATTACK_POWER_SHORT", L["AP"] },
		{ "ITEM_MOD_RANGED_ATTACK_POWER_SHORT", L["RAP"] },
		{ "ITEM_MOD_SPELL_POWER_SHORT", L["SP"] },
		{ "ITEM_MOD_SPELL_DAMAGE_DONE_SHORT", L["SP"] },
		{ "ITEM_MOD_SPELL_HEALING_DONE_SHORT", L["Heal"] },
		{ "ITEM_MOD_CRIT_RATING_SHORT", crit },
		{ "ITEM_MOD_CRIT_MELEE_RATING_SHORT", crit },
		{ "ITEM_MOD_CRIT_RANGED_RATING_SHORT", crit },
		{ "ITEM_MOD_CRIT_SPELL_RATING_SHORT", L["Spell Crit"] },
		{ "ITEM_MOD_HIT_RATING_SHORT", hit },
		{ "ITEM_MOD_HIT_MELEE_RATING_SHORT", hit },
		{ "ITEM_MOD_HIT_RANGED_RATING_SHORT", hit },
		{ "ITEM_MOD_HIT_SPELL_RATING_SHORT", L["Spell Hit"] },
		{ "ITEM_MOD_HASTE_RATING_SHORT", L["Haste"] },
		{ "ITEM_MOD_MANA_REGENERATION_SHORT", mp5 },
		{ "ITEM_MOD_POWER_REGEN0_SHORT", mp5 },
		{ "ITEM_MOD_HEALTH_REGEN_SHORT", hp5 },
		{ "ITEM_MOD_HEALTH_REGENERATION_SHORT", hp5 },
		{ "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", L["Def"] },
		{ "ITEM_MOD_DODGE_RATING_SHORT", L["Dodge"] },
		{ "ITEM_MOD_PARRY_RATING_SHORT", L["Parry"] },
		{ "ITEM_MOD_BLOCK_RATING_SHORT", L["Block"] },
		{ "ITEM_MOD_SPELL_PENETRATION_SHORT", L["Spell Pen"] },
	}

	-- Resistances by their own (localized) name, "Fire Resistance" -> "Fire Res"
	for school = 1, 6 do
		local name = _G["RESISTANCE" .. school .. "_NAME"]
		if name then
			STAT_KEYS[#STAT_KEYS + 1] = { "RESISTANCE" .. school .. "_NAME", gsub(name, " Resistance$", " Res") }
		end
	end

	return STAT_KEYS
end

-- Memoized per item link (it carries item, suffix and enchant), items whose data is
-- not loaded yet are not stored: ElvUI scans them again once the data is there
local statTextCache, dpsTextCache = {}, {}

---"+14 Int / +9 Stam", one stat when there is only one, the armor without any
---@param link string
---@return string?
local function GetStatText(link)
	local text = statTextCache[link]
	if text then
		return text
	end

	local stats = GetItemStats(link)
	if not stats then
		return
	end

	local keys = GetStatKeys()
	local main, mainValue = nil, 0
	for index = 1, NUM_PRIMARY do
		local value = stats[keys[index][1]]
		if value and value > mainValue then
			main, mainValue = index, value
		end
	end
	if not main then
		for index = NUM_PRIMARY + 1, NUM_MAIN do
			local value = stats[keys[index][1]]
			if value and value > mainValue then
				main, mainValue = index, value
			end
		end
	end

	local second, secondValue = nil, 0
	for index = 1, #keys do
		local value = index ~= main and stats[keys[index][1]]
		if value and value > secondValue then
			second, secondValue = index, value
		end
	end

	if main and second then
		text = format("+%d %s / +%d %s", mainValue, keys[main][2], secondValue, keys[second][2])
	elseif main or second then
		text = format("+%d %s", main and mainValue or secondValue, keys[main or second][2])
	else
		local armor = stats.RESISTANCE0_NAME
		text = (armor and armor > 0) and format("%d %s", armor, L["Armor"]) or ""
	end

	statTextCache[link] = text
	return text
end

---"45.2 DPS" for a weapon, "" for anything else (shields, held off hands, relics)
---@param link string
---@return string?
local function GetDpsText(link)
	local text = dpsTextCache[link]
	if text then
		return text
	end

	if select(6, GetItemInfoInstant(link)) ~= ENUM_ITEM_CLASS_WEAPON then
		dpsTextCache[link] = ""
		return ""
	end

	local stats = GetItemStats(link)
	if not stats then
		return
	end

	local dps = stats.ITEM_MOD_DAMAGE_PER_SECOND_SHORT
	text = (dps and dps > 0) and format("%.1f %s", dps, L["DPS"]) or ""

	dpsTextCache[link] = text
	return text
end

local WEAPON_SLOTS = { [16] = true, [17] = true, [18] = true }

---Called from UpdatePageStrings after ElvUI wrote the item level. Weapons show their
---dps (short enough for the narrow room above the weapon row), other slots their stats.
---ElvUI's quality color of the item level stays.
---@param slotItem Button item slot with ElvUI's iLvlText
---@param slotId number
function module:SetForeverSlotStats(slotItem, slotId)
	if not self.db.pageInfo.itemStatsText then
		return
	end

	local link = GetInventoryItemLink("player", slotId)
	if not link then
		return
	end

	local text
	if WEAPON_SLOTS[slotId] then
		text = GetDpsText(link)
		if text == "" then
			text = GetStatText(link)
		end
	else
		text = GetStatText(link)
	end

	-- Not loaded yet or nothing to show: the item level stays
	if text and text ~= "" then
		slotItem.iLvlText:SetText(text)
	end

	self:AnchorForeverSlotText(slotItem, slotId)
end

-- Gap between the slot icon and its text, the same as ElvUI's enchant line above it
-- (45px from the far edge of a 37px slot)
local SLOT_TEXT_GAP = 8

---ElvUI centers the item level 40px beside the slot, made for a short number: the longer
---stats text ran into the icon. The side columns get it on the slot's inner edge instead,
---on ElvUI's baseline, growing away from the icon. Weapons keep ElvUI's spot above the slot.
---ElvUI anchors it again on its own settings changes, so this runs on every update
---@param slotItem Button
---@param slotId number
function module:AnchorForeverSlotText(slotItem, slotId)
	if WEAPON_SLOTS[slotId] or E.db.general.itemLevel.showOnItem then
		return
	end

	local slotName = self:GetSlotNameByID(slotId)
	local options = slotName and self.characterSlots[slotName]
	if not options then
		return
	end

	local text = slotItem.iLvlText
	text:ClearAllPoints()
	if options.direction == self.enumDirection.LEFT then
		-- Left column, the text goes right of the slot
		text:SetPoint("BOTTOMLEFT", slotItem, "BOTTOMRIGHT", SLOT_TEXT_GAP, 3)
		text:SetJustifyH("LEFT")
	else
		text:SetPoint("BOTTOMRIGHT", slotItem, "BOTTOMLEFT", -SLOT_TEXT_GAP, 3)
		text:SetJustifyH("RIGHT")
	end
end

--------------------------------------------------------------------------------
-- Enchants
--------------------------------------------------------------------------------
local ENCHANT_PREFIX = _G.ENCHANTED_TOOLTIP_LINE and strmatch(_G.ENCHANTED_TOOLTIP_LINE, "^(.-)%%s")
local enchantCache = {}

---Name of the permanent enchant of an equipped item from its tooltip line, nil without one.
---Vanilla lines are the effect itself ("+7 Agility"), an "Enchanted: " prefix comes off
---@param slotId number
---@return string?
local function GetEnchantName(slotId)
	local link = GetInventoryItemLink("player", slotId)
	local enchantID = link and tonumber(strmatch(link, "item:%d+:(%d*)") or "")
	if not enchantID or enchantID == 0 then
		return
	end

	local cached = enchantCache[enchantID]
	if cached then
		return cached
	end

	local data = GetTooltipInventoryItem and GetTooltipInventoryItem("player", slotId)
	if not (data and data.lines and ENCHANT_LINE_TYPE) then
		return
	end

	for _, line in ipairs(data.lines) do
		if line.type == ENCHANT_LINE_TYPE and line.leftText and line.leftText ~= "" then
			local text = F.String.StripColor(line.leftText)
			if ENCHANT_PREFIX and ENCHANT_PREFIX ~= "" and text:sub(1, #ENCHANT_PREFIX) == ENCHANT_PREFIX then
				text = text:sub(#ENCHANT_PREFIX + 1)
			end

			-- Not cached while empty, the item data may still be on its way
			if text ~= "" then
				enchantCache[enchantID] = text
				return text
			end
		end
	end
end

---Fills ElvUI's slot info with the enchant when ElvUI found none, GetSlotEnchantText
---handles it from there like on Retail
---@param slotId number
---@param slotInfo table from E:GetGearSlotInfo
function module:FillForeverEnchant(slotId, slotInfo)
	if slotInfo.enchantText and slotInfo.enchantText ~= "" then
		return
	end

	local name = GetEnchantName(slotId)
	if not name then
		return
	end

	slotInfo.enchantText = name
	slotInfo.enchantTextShort = utf8sub(name, 1, 20)

	local colors = slotInfo.enchantColors
	if colors then
		colors[1], colors[2], colors[3] = 0, 1, 0
	end
end

--------------------------------------------------------------------------------
-- Stats lists
--------------------------------------------------------------------------------
local STAT_BOXES = { "CharacterStatsPaneScrollBox", "CharacterStatsPanePetScrollBox" }

-- Bumped by every settings update, so pooled rows style themselves again
local styleVersion = 0

local function IsActive()
	return module.db and module.db.enable
end

---Header row: Blizzard's title art goes, the Armory's header font and dividers come in.
---The dividers keep both anchors (no grow animation): the rows are laid out by the
---scroll box after this runs, a measured width could still be 0 here.
local function StyleHeader(frame)
	local title = frame.Title
	if not title then
		return
	end

	if frame.Background then
		frame.Background:SetAlpha(0)
	end
	-- ElvUI's category backdrop
	if frame.backdrop then
		frame.backdrop:SetAlpha(0)
	end

	local text = title:GetText()
	if frame.MERStyledText == text and frame.MERStyleVersion == styleVersion then
		return
	end

	local leftDivider = frame.MERLeftDivider
	local rightDivider = frame.MERRightDivider
	if not leftDivider then
		leftDivider = frame:CreateTexture(nil, "ARTWORK")
		rightDivider = frame:CreateTexture(nil, "ARTWORK")
		frame.MERLeftDivider = leftDivider
		frame.MERRightDivider = rightDivider
	end

	module:StyleCategoryHeader(title, leftDivider, rightDivider)

	leftDivider:ClearAllPoints()
	leftDivider:SetPoint("LEFT", frame, "LEFT", 3, 0)
	leftDivider:SetPoint("RIGHT", title, "LEFT", -3, 0)
	rightDivider:ClearAllPoints()
	rightDivider:SetPoint("RIGHT", frame, "RIGHT", -3, 0)
	rightDivider:SetPoint("LEFT", title, "RIGHT", 3, 0)

	frame.MERStyledText = title:GetText()
	frame.MERStyleVersion = styleVersion
end

---Stat row: the Armory's label and value fonts and its alternating gradient on the
---rows Blizzard marks (its own stripe and ElvUI's shade go)
local function StyleRow(frame, elementData)
	-- ElvUI's alternating shade
	if frame.shade then
		frame.shade:SetAlpha(0)
	end

	local label = frame.Label
	local text = label and label:GetText()
	if frame.MERStyledText == text and frame.MERStyleVersion == styleVersion then
		return
	end

	local striped = elementData and elementData.statIndex and (elementData.statIndex % 2) == 1
	module:UpdateCharacterStat(frame, striped)

	frame.MERStyledText = label and label:GetText()
	frame.MERStyleVersion = styleVersion
end

local function StyleElement(frame, elementData)
	elementData = elementData or (frame.GetElementData and frame:GetElementData())
	if not elementData then
		return
	end

	if elementData.isHeader then
		StyleHeader(frame)
	else
		StyleRow(frame, elementData)
	end
end

-- Runs after every layout pass of a stats list (data change, scrolling, resize)
local function ScrollBox_OnUpdate(scrollBox)
	if IsActive() then
		scrollBox:ForEachFrame(StyleElement)
	end
end

-- Blizzard's stats update refills the lists, the scroll box hook above styles the new rows.
-- The hook itself stays (Core.lua's Enable/Disable check it)
function module:OnPaperDollUpdateStats() end

---Restyles the shown rows and sets up their fade-in, top to bottom. Replaces Retail's
---own stats list (Core.lua), runs on open and on settings changes
function module:UpdateCharacterStats()
	styleVersion = styleVersion + 1
	self:ClearAnimations(true)

	local order = 1
	for _, name in ipairs(STAT_BOXES) do
		local box = _G[name]
		if box and box.ScrollBox and box:IsShown() then
			box.ScrollBox:ForEachFrame(function(frame, elementData)
				StyleElement(frame, elementData)
				self:SetupFadeAnimation(frame, order)
				order = order + 1
			end)
		end
	end
end

--------------------------------------------------------------------------------
-- Frame
--------------------------------------------------------------------------------
---Square background images, cropped to the frame's aspect: full width with the top
---cut off (as on Retail), or centered when the frame is taller than wide
local function CropBackground(background)
	local width, height = background:GetSize()
	if not (width and height) or width <= 0 or height <= 0 then
		return
	end

	if width >= height then
		background.Texture:SetTexCoord(0, 1, 1 - (height / width), 1)
	else
		local cut = (1 - (width / height)) / 2
		background.Texture:SetTexCoord(cut, 1 - cut, 0, 1)
	end
end

local HEADER_TEXTS = { "nameText", "classSymbol", "titleText", "levelTitleText", "levelText", "specIcon", "classText" }

---The pet view shows the pet in the model scene with Blizzard's own pet level line
local function SetHeaderShown(shown)
	for _, key in ipairs(HEADER_TEXTS) do
		local region = module[key]
		if region then
			region:SetAlpha(shown and 1 or 0)
		end
	end
end

local function PetBox_OnShow()
	SetHeaderShown(not IsActive())
end

local function PetBox_OnHide()
	SetHeaderShown(true)
end

-- Panes over the background (it sits right under the model scene, level 49), as on Retail
local STRATA_FRAMES = { "CharacterStatsPaneScrollBox", "CharacterStatsPanePetScrollBox" }

local foreverHooked = false

---Called from Enable (Core.lua). Hooks are set once and check the module state, AceHook's
---UnhookAll on Disable does not reach them
function module:EnableForever()
	UpdateWeaponDirections()

	for _, name in ipairs(STRATA_FRAMES) do
		local frame = _G[name]
		if frame then
			frame:SetFrameStrata("HIGH")
		end
	end
	local paperDoll = _G.PaperDollFrame
	for _, pane in ipairs({ paperDoll.TitleManagerPane, paperDoll.EquipmentManagerPane }) do
		if pane then
			pane:SetFrameStrata("HIGH")
		end
	end

	if foreverHooked then
		return
	end
	foreverHooked = true

	local background = self.frame.MERBackground
	background:HookScript("OnSizeChanged", CropBackground)
	CropBackground(background)

	-- The frame's bottom right corner is the stats list on Forever, the logo goes to the model's
	local leftPane = self.frame.LeftPaneHost
	if self.waterMark and leftPane then
		self.waterMark:ClearAllPoints()
		self.waterMark:SetPoint("BOTTOMRIGHT", leftPane, "BOTTOMRIGHT", -10, 15)
	end

	for _, name in ipairs(STAT_BOXES) do
		local box = _G[name]
		if box and box.ScrollBox then
			hooksecurefunc(box.ScrollBox, "Update", ScrollBox_OnUpdate)
		end
	end

	local petBox = _G.CharacterStatsPanePetScrollBox
	if petBox then
		petBox:HookScript("OnShow", PetBox_OnShow)
		petBox:HookScript("OnHide", PetBox_OnHide)
	end
end
