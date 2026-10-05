local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local max = math.max
local next, type, unpack = next, type, unpack
local CreateFrame = CreateFrame
local GetInventoryItemTexture = GetInventoryItemTexture

-- The Armory on the character frame, drawn with the module's own functions.
-- Used as `dialogControl` on a description whose name is the part to show:
-- "slots" - your equipped items from the left column with the item level, the
-- enchant or missing socket/enchant text (GetSlotEnchantText) and the quality
-- gradient, placed like ElvUI places them on the character frame;
-- "header" - name, title, level, spec icon and class text (UpdateTitle).

local SLOT_SIZE = 37
local SLOT_SPACING = 6
local NUM_SLOTS = 3
-- Left column slots that often carry an enchant or a socket
local SAMPLE_SLOTS = { "HeadSlot", "ShoulderSlot", "ChestSlot", "WristSlot", "BackSlot" }
local HEADER_HEIGHT = 100

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

	if isHeader then
		UpdateHeader(widget)
	else
		UpdateSlots(widget)
	end

	Preview.SetEnabled(widget, E.db.mui.armory.enable)
end

Preview.Register("MERArmoryPreview", 1, HEADER_HEIGHT, Build, Update)
