local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local ceil, floor, max = math.ceil, math.floor, math.max
local unpack = unpack
local CreateColor = CreateColor
local CreateFrame = CreateFrame
local GetExpansionLevel = GetExpansionLevel
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetItemInfoInstant = C_Item.GetItemInfoInstant

-- A category of the Categorized Bags with items from your own bags. Used as
-- `dialogControl` on a description whose name is "categorized" (header,
-- sub-header, item grid with count, item level and bind texts, the new item
-- glow and badge, pin and warband markers and empty slots) or
-- "equipmentManager" (gear with the equipment set marker). Sizes, fonts and
-- effects follow Modules/Bags/CategoryFrame.lua, whose helpers it reuses.
-- Display only, nothing is moved or used from here.

local PADDING = 8
local MAX_ITEMS = 10
local NUM_PLACEHOLDERS = 2
local NUM_SLOTS = MAX_ITEMS + NUM_PLACEHOLDERS
local LAST_BAG = 4
local ITEMCLASS_ARMOR = Enum.ItemClass.Armor
local ITEMCLASS_WEAPON = Enum.ItemClass.Weapon

local function GetBags()
	return MER:GetModule("MER_BagCategories")
end

-- Items from the backpack and the bags; gear only for the equipment set marker
local function CollectItems(gearOnly)
	local items = {}
	for bagID = 0, LAST_BAG do
		for slotID = 1, GetContainerNumSlots(bagID) or 0 do
			local info = GetContainerItemInfo(bagID, slotID)
			if info and info.hyperlink then
				local _, _, _, _, _, classID = GetItemInfoInstant(info.hyperlink)
				local isGear = classID == ITEMCLASS_ARMOR or classID == ITEMCLASS_WEAPON
				if not gearOnly or isGear then
					items[#items + 1] = info
					if #items == MAX_ITEMS then
						return items
					end
				end
			end
		end
	end
	return items
end

local function CreateSlot(parent)
	local slot = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	slot:SetTemplate()

	slot.icon = slot:CreateTexture(nil, "ARTWORK")
	slot.icon:SetInside()
	slot.icon:SetTexCoord(unpack(E.TexCoords))

	slot.count = slot:CreateFontString(nil, "OVERLAY")
	slot.count:FontTemplate()
	slot.itemLevel = slot:CreateFontString(nil, "OVERLAY")
	slot.itemLevel:FontTemplate()
	slot.bindType = slot:CreateFontString(nil, "OVERLAY")
	slot.bindType:FontTemplate()

	slot.newItemGlow = slot:CreateTexture(nil, "OVERLAY", nil, 1)
	slot.newItemGlow:SetTexture(E.Media.Textures.BagNewItemGlow)
	slot.newItemGlow:SetInside()
	local pulse = slot.newItemGlow:CreateAnimationGroup()
	pulse:SetLooping("BOUNCE")
	local fade = pulse:CreateAnimation("Alpha")
	fade:SetFromAlpha(1)
	fade:SetToAlpha(0)
	fade:SetDuration(0.7)
	slot.newItemPulse = pulse

	slot.warboundIcon = slot:CreateTexture(nil, "OVERLAY", nil, 3)
	slot.warboundIcon:SetAtlas("warbands-icon")
	slot.warboundIcon:SetPoint("TOPRIGHT", -1, -1)

	slot.pinIcon = slot:CreateTexture(nil, "OVERLAY", nil, 3)
	slot.pinIcon:SetAtlas("friendslist-recentallies-Pin-yellow")
	slot.pinIcon:SetPoint("BOTTOMLEFT", 1, 1)

	slot.junkIcon = slot:CreateTexture(nil, "OVERLAY", nil, 2)
	slot.junkIcon:SetAtlas("bags-junkcoin", true)
	slot.junkIcon:SetPoint("TOPRIGHT", -1, -1)

	slot.equipIcon = slot:CreateTexture(nil, "OVERLAY")

	return slot
end

local function Build(widget)
	local frame = widget.frame
	frame:SetClipsChildren(true)
	local classColor = E.myClassColor

	-- Category header like CreateHeaderPoolFor
	local header = CreateFrame("Frame", nil, frame)
	header.arrow = header:CreateTexture(nil, "OVERLAY")
	header.arrow:SetSize(12, 12)
	header.arrow:SetPoint("RIGHT", -2, 0)
	header.arrow:SetTexture(E.Media.Textures.ArrowUp)
	header.arrow:SetVertexColor(0.6, 0.6, 0.6)
	header.icon = header:CreateTexture(nil, "ARTWORK")
	header.icon:SetSize(16, 16)
	header.icon:SetPoint("LEFT", 2, 0)
	header.icon:SetAtlas("bags-icon-equipment")
	header.text = header:CreateFontString(nil, "OVERLAY")
	header.text:FontTemplate()
	header.text:SetPoint("LEFT", header.icon, "RIGHT", 6, 0)
	header.line = header:CreateTexture(nil, "ARTWORK")
	header.line:SetColorTexture(classColor.r, classColor.g, classColor.b, 0.35)
	header.line:SetHeight(1)
	header.line:SetPoint("LEFT", header.text, "RIGHT", 8, 0)
	header.line:SetPoint("RIGHT", header.arrow, "LEFT", -6, 0)
	widget.header = header

	-- Sub-header like CreateSubHeaderPoolFor
	local subHeader = CreateFrame("Frame", nil, frame)
	subHeader.bg = subHeader:CreateTexture(nil, "BACKGROUND")
	subHeader.bg:SetTexture(E.media.blankTex)
	subHeader.bg:SetPoint("TOPLEFT")
	subHeader.bg:SetPoint("BOTTOMLEFT")
	subHeader.bg:SetGradient("HORIZONTAL", CreateColor(0, 0, 0, 0.45), CreateColor(0, 0, 0, 0))
	subHeader.accent = subHeader:CreateTexture(nil, "ARTWORK")
	subHeader.accent:SetColorTexture(classColor.r, classColor.g, classColor.b, 0.8)
	subHeader.accent:SetWidth(2)
	subHeader.accent:SetPoint("TOPLEFT")
	subHeader.accent:SetPoint("BOTTOMLEFT")
	subHeader.text = subHeader:CreateFontString(nil, "OVERLAY")
	subHeader.text:FontTemplate(nil, 11)
	subHeader.text:SetTextColor(0.9, 0.9, 0.9)
	subHeader.text:SetPoint("LEFT", 8, 0)
	widget.subHeader = subHeader

	widget.slots = {}
	for index = 1, NUM_SLOTS do
		widget.slots[index] = CreateSlot(frame)
	end
end

local function StyleItem(slot, info, db, bags, index, forEquipment)
	local r, g, b = E:GetItemQualityColor(info.quality)
	local effects = db.effects
	local isJunk = info.quality == 0 and not info.hasNoValue

	slot.icon:SetTexture(info.iconFileID)
	slot.icon:SetDesaturated(isJunk and effects.desaturateJunk or false)
	slot.icon:SetAlpha(1)
	slot:SetBackdropBorderColor(r, g, b)

	local countFont = db.itemCountFont
	slot.count:FontTemplate(countFont.name, countFont.size, countFont.style)
	bags.PositionSlotText(slot.count, countFont.position)
	slot.count:SetText((info.stackCount or 1) > 1 and info.stackCount or "")

	local levelFont = db.itemLevel.font
	slot.itemLevel:FontTemplate(levelFont.name, levelFont.size, levelFont.style)
	bags.PositionSlotText(slot.itemLevel, levelFont.position)
	local itemLevel = db.itemLevel.enable and bags.GetDisplayItemLevel(info.hyperlink, info.quality)
	slot.itemLevel:SetText(itemLevel or "")
	slot.itemLevel:SetTextColor(r, g, b)

	local infoFont = db.itemInfo.font
	slot.bindType:FontTemplate(infoFont.name, infoFont.size, infoFont.style)
	bags.PositionSlotText(slot.bindType, infoFont.position)
	local bindText = db.itemInfo.enable and bags.GetBindText(info.hyperlink, info.isBound, false)
	slot.bindType:SetText(bindText or "")
	slot.bindType:SetTextColor(r, g, b)

	local size = db.itemSize
	slot.junkIcon:SetSize(size * 0.5, size * 0.5)
	slot.junkIcon:SetShown(isJunk)

	-- Sample markers: the first item is new, the second pinned, the third warbound
	local isNew = index == 1 and not forEquipment
	slot.newItemGlow:SetShown(isNew and effects.newItemGlow)
	slot.newItemGlow:SetVertexColor(r, g, b)
	if isNew and effects.newItemGlow then
		slot.newItemPulse:Play()
	else
		slot.newItemPulse:Stop()
	end
	F.SyncNewFeatureBadge(slot, "newBadge", isNew and effects.newItemBadge, function()
		return F.CreateNewFeatureBadge(slot, "CENTER", slot, "TOP", 0, 0, 0.6, true)
	end)

	slot.pinIcon:SetSize(size * 0.4, size * 0.4)
	slot.pinIcon:SetShown(index == 2 and not forEquipment and effects.pinMarker)
	slot.warboundIcon:SetSize(size * 0.4, size * 0.4)
	slot.warboundIcon:SetShown(index == 3 and not forEquipment and effects.warboundMarker and not isJunk)

	local equipDB = E.db.mui.bags.equipmentManager
	slot.equipIcon:SetShown(forEquipment and equipDB.enable)
	if forEquipment and equipDB.enable then
		bags.StyleEquipSetIcon(slot.equipIcon, equipDB)
	end
end

-- Empty slots after a category's items, at their resting opacity
local function StylePlaceholder(slot, db)
	slot.icon:SetTexture(nil)
	slot.count:SetText("")
	slot.itemLevel:SetText("")
	slot.bindType:SetText("")
	slot.newItemGlow:Hide()
	slot.newItemPulse:Stop()
	slot.junkIcon:Hide()
	slot.pinIcon:Hide()
	slot.warboundIcon:Hide()
	slot.equipIcon:Hide()
	F.SyncNewFeatureBadge(slot, "newBadge", false)
	slot:SetBackdropBorderColor(unpack(E.media.bordercolor))
	slot:SetAlpha(db.effects.placeholderAlpha)
end

local function Update(widget, key)
	local bags = GetBags()
	local db = E.db.mui.bags.categorizedBags
	local forEquipment = key == "equipmentManager"
	local items = CollectItems(forEquipment)
	local width = Preview.Width(widget, 600, PADDING)

	local y = -PADDING
	local header, subHeader = widget.header, widget.subHeader
	header:SetShown(not forEquipment)
	subHeader:SetShown(not forEquipment)

	if not forEquipment then
		local headerFont = db.headerFont
		header.text:FontTemplate(headerFont.name, headerFont.size, headerFont.style)
		header.text:SetText(L["Equipment"] .. " |cff999999(" .. #items .. ")|r")
		header:SetSize(width, max(db.headerHeight, headerFont.size + 8))
		header:ClearAllPoints()
		header:SetPoint("TOPLEFT", widget.frame, "TOPLEFT", PADDING, y)
		y = y - header:GetHeight() - 2

		local subHeaderFont = db.subHeaderFont
		subHeader.text:FontTemplate(subHeaderFont.name, subHeaderFont.size, subHeaderFont.style)
		subHeader.text:SetText(_G["EXPANSION_NAME" .. GetExpansionLevel()] or "")
		subHeader:SetSize(width, max(16, subHeaderFont.size + 5))
		subHeader.bg:SetWidth(max(width / 2, subHeader.text:GetStringWidth() + 24))
		subHeader:ClearAllPoints()
		subHeader:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -2)
		y = y - subHeader:GetHeight() - 6
	end

	-- Grid like RenderCategorySections: as many columns as fit the width
	local size = db.itemSize
	local stepX, stepY = size + db.itemSpacingH, size + db.itemSpacingV
	local columns = max(1, floor((width + db.itemSpacingH) / stepX))
	local placeholders = forEquipment and 0 or NUM_PLACEHOLDERS
	local total = #items + placeholders

	for index, slot in ipairs(widget.slots) do
		local shown = index <= total
		slot:SetShown(shown)
		if shown then
			slot:SetSize(size, size)
			slot:SetAlpha(1)
			slot:ClearAllPoints()
			local column = (index - 1) % columns
			local row = floor((index - 1) / columns)
			slot:SetPoint("TOPLEFT", widget.frame, "TOPLEFT", PADDING + column * stepX, y - row * stepY)

			local info = items[index]
			if info then
				StyleItem(slot, info, db, bags, index, forEquipment)
			else
				StylePlaceholder(slot, db)
			end
		end
	end

	local rows = ceil(max(total, 1) / columns)
	widget.frame:SetHeight(-y + rows * stepY + PADDING)

	if forEquipment then
		Preview.SetEnabled(widget, E.db.mui.bags.equipmentManager.enable)
	else
		Preview.SetEnabled(widget, db.enable)
	end
end

Preview.Register("MERBagsPreview", 1, 120, Build, Update)
