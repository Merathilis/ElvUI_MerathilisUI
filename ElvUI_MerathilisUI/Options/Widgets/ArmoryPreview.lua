local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local _G = _G
local format, max = string.format, math.max
local next, type, unpack = next, type, unpack
local CreateFrame = CreateFrame
local GetCombatRatingBonus = GetCombatRatingBonus
local GetCritChance = GetCritChance
local GetHaste = GetHaste
local GetInventoryItemTexture = GetInventoryItemTexture
local GetMasteryEffect = GetMasteryEffect
local GetVersatilityBonus = GetVersatilityBonus

-- FrameXML global from PaperDollFrame
local CR_VERSATILITY_DAMAGE_DONE = _G.CR_VERSATILITY_DAMAGE_DONE or 29

-- The Armory on the character frame, drawn with the module's own functions.
-- Used as `dialogControl` on a description whose name is the part to show:
-- "slots" - your equipped items from the left column with the item level, the
-- enchant or missing socket/enchant text (GetSlotEnchantText) and the quality
-- gradient, placed like ElvUI places them on the character frame;
-- "header" - name, title, level, spec icon and class text (UpdateTitle);
-- "frame" - the background, the decorative lines and the item level with its
-- category header (SetBackgroundTexture, SetLineColor, SetItemLevelText);
-- "stats" - a stats category with a few rows (StyleCategoryHeader, UpdateCharacterStat).

local SLOT_SIZE = 37
local SLOT_SPACING = 6
local NUM_SLOTS = 3
-- Left column slots that often carry an enchant or a socket
local SAMPLE_SLOTS = { "HeadSlot", "ShoulderSlot", "ChestSlot", "WristSlot", "BackSlot" }
local HEADER_HEIGHT = 100
local FRAME_HEIGHT = 150
-- Size of a stats row of the character frame
local STAT_WIDTH, STAT_HEIGHT = 187, 15
local CATEGORY_HEIGHT = 28

local SAMPLE_STATS = {
	{
		label = STAT_CRITICAL_STRIKE,
		value = function()
			return GetCritChance()
		end,
	},
	{
		label = STAT_HASTE,
		value = function()
			return GetHaste()
		end,
	},
	{
		label = STAT_MASTERY,
		value = function()
			return (GetMasteryEffect())
		end,
	},
	{
		label = STAT_VERSATILITY,
		value = function()
			return GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
		end,
	},
}

local function GetArmory()
	local armory = MER:GetModule("MER_Armory")
	armory.db = E.db.mui.armory
	return armory
end

local function CreateSlot(parent)
	local slot = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	slot:SetTemplate()
	slot:SetSize(SLOT_SIZE, SLOT_SIZE)
	slot:SetFrameLevel(parent:GetFrameLevel() + 3)

	slot.icon = slot:CreateTexture(nil, "ARTWORK")
	slot.icon:SetInside()
	slot.icon:SetTexCoord(unpack(E.TexCoords))

	-- ElvUI's spots for the left column (M:GetInspectPoints)
	slot.iLvlText = slot:CreateFontString(nil, "OVERLAY")
	slot.iLvlText:FontTemplate()
	slot.iLvlText:SetPoint("BOTTOM", slot, "BOTTOM", 40, 3)

	slot.enchantText = slot:CreateFontString(nil, "OVERLAY")
	slot.enchantText:FontTemplate()
	slot.enchantText:SetPoint("BOTTOMLEFT", slot, "BOTTOMLEFT", 45, 18)

	-- Behind the slot, growing out of its right edge like UpdatePageStrings
	slot.gradient = CreateFrame("Frame", nil, parent)
	slot.gradient:SetFrameLevel(parent:GetFrameLevel() + 1)
	slot.gradient:SetPoint("BOTTOMLEFT", slot, "BOTTOMRIGHT", -1, -1)
	slot.gradient.texture = slot.gradient:CreateTexture(nil, "OVERLAY")
	slot.gradient.texture:SetInside()
	slot.gradient.texture:SetTexture(E.media.blankTex)

	return slot
end

-- A stats category header like the ones of the character frame
local function CreateCategory(parent)
	local category = CreateFrame("Frame", nil, parent)
	category:SetSize(STAT_WIDTH, CATEGORY_HEIGHT)

	category.Title = category:CreateFontString(nil, "OVERLAY")
	category.Title:FontTemplate()
	category.Title:SetPoint("CENTER")

	-- Both edges anchored, so the dividers have the width they grow to on the character frame
	category.leftDivider = category:CreateTexture(nil, "ARTWORK")
	category.leftDivider:SetPoint("LEFT", category, "LEFT", 3, 0)
	category.leftDivider:SetPoint("RIGHT", category.Title, "LEFT", -3, 0)
	category.rightDivider = category:CreateTexture(nil, "ARTWORK")
	category.rightDivider:SetPoint("RIGHT", category, "RIGHT", -3, 0)
	category.rightDivider:SetPoint("LEFT", category.Title, "RIGHT", 3, 0)

	return category
end

local function UpdateCategory(armory, category, text)
	category.Title:SetText(text)
	armory:StyleCategoryHeader(category.Title, category.leftDivider, category.rightDivider)
end

local function CreateStatRow(parent)
	local row = CreateFrame("Frame", nil, parent)
	row:SetSize(STAT_WIDTH, STAT_HEIGHT)

	row.Label = row:CreateFontString(nil, "OVERLAY")
	row.Label:FontTemplate()
	row.Label:SetPoint("LEFT", row, "LEFT", 11, 0)

	row.Value = row:CreateFontString(nil, "OVERLAY")
	row.Value:FontTemplate()
	row.Value:SetPoint("RIGHT", row, "RIGHT", -8, 0)

	return row
end

-- E:GetGearSlotInfo reuses one table, so the parts we need are copied right away
local function GetSlotSample(armory, slotName)
	local options = armory.characterSlots[slotName]
	local texture = options and GetInventoryItemTexture("player", options.id)
	if not texture then
		return
	end

	local info = E:GetGearSlotInfo("player", options.id, true)
	if type(info) ~= "table" or not (info.itemLevelColors and next(info.itemLevelColors)) then
		return
	end

	return {
		texture = texture,
		iLvl = info.iLvl,
		color = { unpack(info.itemLevelColors) },
		enchant = armory:GetSlotEnchantText(options, info),
	}
end

local function UpdateSlots(widget)
	local armory = GetArmory()
	local db = armory.db.pageInfo

	local samples = {}
	for _, slotName in ipairs(SAMPLE_SLOTS) do
		local sample = GetSlotSample(armory, slotName)
		if sample then
			samples[#samples + 1] = sample
			if #samples == NUM_SLOTS then
				break
			end
		end
	end

	local count = #samples
	widget.frame:SetHeight(max(count, 1) * (SLOT_SIZE + SLOT_SPACING) + 16)

	for index, slot in ipairs(widget.slots) do
		local sample = samples[index]
		slot:SetShown(sample ~= nil)
		slot.gradient:SetShown(sample ~= nil and db.itemQualityGradientEnabled)
		if sample then
			local r, g, b = unpack(sample.color)
			slot:ClearAllPoints()
			slot:SetPoint("TOPLEFT", widget.frame, "TOPLEFT", 40, -8 - (index - 1) * (SLOT_SIZE + SLOT_SPACING))
			slot.icon:SetTexture(sample.texture)
			slot:SetBackdropBorderColor(r, g, b)

			WF.SetFontWithDB(slot.iLvlText, db.iLvLFont)
			slot.iLvlText:SetText(db.itemLevelTextEnabled and sample.iLvl or "")
			slot.iLvlText:SetTextColor(r, g, b)

			WF.SetFontWithDB(slot.enchantText, db.enchantFont)
			slot.enchantText:SetText(sample.enchant)

			slot.gradient:SetSize(db.itemQualityGradientWidth, db.itemQualityGradientHeight)
			F.Color.SetGradientRGB(
				slot.gradient.texture,
				"HORIZONTAL",
				r,
				g,
				b,
				db.itemQualityGradientStartAlpha,
				r,
				g,
				b,
				db.itemQualityGradientEndAlpha
			)
		end
	end
end

local function UpdateHeader(widget)
	local armory = GetArmory()
	local target = widget.header

	widget.frame:SetHeight(HEADER_HEIGHT)
	-- Fonts are only applied while the flag is not false, the preview always wants them
	target._titleFontDirty = nil
	armory:UpdateTitle(target)
end

local function UpdateFrame(widget)
	local armory = GetArmory()
	local view = widget.frameView

	widget.frame:SetHeight(FRAME_HEIGHT)

	local width = Preview.Width(widget, 320, 8)
	local height = FRAME_HEIGHT - 16
	view:SetSize(width, height)

	-- Square textures, cut from the top like on the character frame
	armory:SetBackgroundTexture(view.background)
	view.background:SetTexCoord(0, 1, max(1 - height / width, 0), 1)

	local lineHeight = armory.db.lines.height
	view.topLine:SetHeight(lineHeight)
	view.bottomLine:SetHeight(lineHeight)
	armory:SetLineColor(view.topLine)
	armory:SetLineColor(view.bottomLine)

	UpdateCategory(armory, view.category, STAT_AVERAGE_ITEM_LEVEL)
	-- The DEFAULT color keeps the color the text already has
	view.itemLevel:SetTextColor(1, 1, 1)
	armory:SetItemLevelText(view.itemLevel)
end

local function UpdateStats(widget)
	local armory = GetArmory()
	local view = widget.statsView

	widget.frame:SetHeight(CATEGORY_HEIGHT + #SAMPLE_STATS * STAT_HEIGHT + 24)

	UpdateCategory(armory, view.category, STAT_CATEGORY_ENHANCEMENTS)

	for index, row in ipairs(view.rows) do
		local stat = SAMPLE_STATS[index]
		-- UpdateCharacterStat restyles the plain text, like on the character frame
		row.Label:SetText(format(STAT_FORMAT, stat.label))
		row.Value:SetText(format("%.2f%%", stat.value() or 0))
		row.Value:SetTextColor(1, 1, 1)
		armory:UpdateCharacterStat(row, index % 2 == 0)
	end
end

local function Build(widget)
	local frame = widget.frame
	frame:SetClipsChildren(true)

	widget.slots = {}
	for index = 1, NUM_SLOTS do
		widget.slots[index] = CreateSlot(frame)
	end

	-- The texts are placed above the character model, a thin line stands in for its top
	local header = { frameModel = CreateFrame("Frame", nil, frame) }
	header.frameModel:SetSize(200, 1)
	header.frameModel:SetPoint("TOP", frame, "TOP", 0, -(HEADER_HEIGHT - 16))
	for _, key in ipairs({ "nameText", "titleText", "levelTitleText", "levelText", "classText", "specIcon" }) do
		header[key] = frame:CreateFontString(nil, "OVERLAY")
		header[key]:FontTemplate()
	end
	header.classSymbol = frame:CreateTexture(nil, "OVERLAY")
	widget.header = header

	-- A cut-out of the character frame: background, lines and the item level
	local frameView = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	frameView:SetTemplate("Transparent")
	frameView:SetPoint("TOP", frame, "TOP", 0, -8)
	frameView.background = frameView:CreateTexture(nil, "BACKGROUND", nil, 1)
	frameView.background:SetInside()
	frameView.topLine = frameView:CreateTexture(nil, "ARTWORK")
	frameView.topLine:SetPoint("TOPLEFT", frameView.background)
	frameView.topLine:SetPoint("TOPRIGHT", frameView.background)
	frameView.bottomLine = frameView:CreateTexture(nil, "ARTWORK")
	frameView.bottomLine:SetPoint("BOTTOMLEFT", frameView.background)
	frameView.bottomLine:SetPoint("BOTTOMRIGHT", frameView.background)
	frameView.category = CreateCategory(frameView)
	frameView.category:SetPoint("CENTER", frameView, "CENTER", 0, 14)
	frameView.itemLevel = frameView:CreateFontString(nil, "OVERLAY")
	frameView.itemLevel:FontTemplate()
	frameView.itemLevel:SetPoint("TOP", frameView.category, "BOTTOM", 0, -2)
	frameView.waterMark = frameView:CreateTexture(nil, "ARTWORK")
	frameView.waterMark:SetSize(40, 40)
	frameView.waterMark:SetPoint("BOTTOMRIGHT", frameView, "BOTTOMRIGHT", -6, 8)
	frameView.waterMark:SetTexture(I.Media.Logos.Logo)
	frameView.waterMark:SetAlpha(0.35)
	widget.frameView = frameView

	local statsView = CreateFrame("Frame", nil, frame)
	statsView:SetSize(STAT_WIDTH, CATEGORY_HEIGHT + #SAMPLE_STATS * STAT_HEIGHT)
	statsView:SetPoint("TOP", frame, "TOP", 0, -8)
	statsView.category = CreateCategory(statsView)
	statsView.category:SetPoint("TOP")
	statsView.rows = {}
	for index = 1, #SAMPLE_STATS do
		local row = CreateStatRow(statsView)
		row:SetPoint("TOP", statsView.category, "BOTTOM", 0, -2 - (index - 1) * STAT_HEIGHT)
		statsView.rows[index] = row
	end
	widget.statsView = statsView
end

local function Update(widget, key)
	local isHeader = key == "header"

	for _, slot in ipairs(widget.slots) do
		slot:SetShown(false)
		slot.gradient:SetShown(false)
	end
	-- The header table also carries UpdateTitle's font flag, only regions are toggled
	for name, region in pairs(widget.header) do
		if name ~= "frameModel" and type(region) == "table" then
			region:SetShown(isHeader)
		end
	end
	widget.frameView:SetShown(key == "frame")
	widget.statsView:SetShown(key == "stats")

	if isHeader then
		UpdateHeader(widget)
	elseif key == "frame" then
		UpdateFrame(widget)
	elseif key == "stats" then
		UpdateStats(widget)
	else
		UpdateSlots(widget)
	end

	Preview.SetEnabled(widget, E.db.mui.armory.enable)
end

Preview.Register("MERArmoryPreview", 2, HEADER_HEIGHT, Build, Update)
