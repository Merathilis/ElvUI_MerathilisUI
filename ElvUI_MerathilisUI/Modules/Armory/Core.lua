local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Armory")
local M = E:GetModule("Misc")

local _G = _G
local gsub, next, pairs, select = gsub, next, pairs, select
local utf8sub = string.utf8sub

local CreateColor = CreateColor
local GetInventoryItemID = GetInventoryItemID
local GetInventoryItemTexture = GetInventoryItemTexture
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetCurrentTitle = GetCurrentTitle
local GetTitleName = GetTitleName
local UnitLevel = UnitLevel
local UnitSex = UnitSex

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local GetItemInfo = C_Item.GetItemInfo
local IsCosmeticItem = C_Item.IsCosmeticItem
local GetMinItemLevel = C_PaperDollInfo.GetMinItemLevel
local ENUM_ITEM_CLASS_WEAPON = _G.Enum.ItemClass.Weapon

module.enumDirection = F.Enum({ "LEFT", "RIGHT", "BOTTOM" })
module.colors = {
	LIGHT_GREEN = "#12E626",
	DARK_GREEN = "#00B01C",
	RED = "#F0544F",
}
module.characterSlots = {
	["HeadSlot"] = {
		id = 1,
		needsEnchant = false,
		needsSocket = false,
		direction = module.enumDirection.LEFT,
	},
	["NeckSlot"] = {
		id = 2,
		needsEnchant = false,
		needsSocket = true,
		warningCondition = {
			level = I.MaxLevelTable[MER.MetaFlavor],
		},
		direction = module.enumDirection.LEFT,
	},
	["ShoulderSlot"] = {
		id = 3,
		needsEnchant = false,
		needsSocket = false,
		direction = module.enumDirection.LEFT,
	},
	["BackSlot"] = {
		id = 15,
		needsEnchant = true,
		warningCondition = {
			level = I.MaxLevelTable[MER.MetaFlavor],
		},
		needsSocket = false,
		direction = module.enumDirection.LEFT,
	},
	["ChestSlot"] = {
		id = 5,
		needsEnchant = true,
		warningCondition = {
			level = I.MaxLevelTable[MER.MetaFlavor],
		},
		needsSocket = false,
		direction = module.enumDirection.LEFT,
	},
	["ShirtSlot"] = {
		id = 4,
		needsEnchant = false,
		needsSocket = false,
		direction = module.enumDirection.LEFT,
	},
	["TabardSlot"] = {
		id = 18,
		needsEnchant = false,
		needsSocket = false,
		direction = module.enumDirection.LEFT,
	},
	["WristSlot"] = {
		id = 9,
		needsEnchant = true,
		warningCondition = {
			level = I.MaxLevelTable[MER.MetaFlavor],
		},
		needsSocket = false,
		direction = module.enumDirection.LEFT,
	},
	["HandsSlot"] = {
		id = 10,
		needsEnchant = false,
		needsSocket = false,
		direction = module.enumDirection.RIGHT,
	},
	["WaistSlot"] = {
		id = 6,
		needsEnchant = false,
		needsSocket = false,
		direction = module.enumDirection.RIGHT,
	},
	["LegsSlot"] = {
		id = 7,
		needsEnchant = true,
		warningCondition = {
			level = I.MaxLevelTable[MER.MetaFlavor],
		},
		needsSocket = false,
		direction = module.enumDirection.RIGHT,
	},
	["FeetSlot"] = {
		id = 8,
		needsEnchant = true,
		warningCondition = {
			level = I.MaxLevelTable[MER.MetaFlavor],
		},
		needsSocket = false,
		direction = module.enumDirection.RIGHT,
	},
	["Finger0Slot"] = {
		id = 11,
		needsEnchant = true,
		warningCondition = {
			level = I.MaxLevelTable[MER.MetaFlavor],
		},
		needsSocket = true,
		direction = module.enumDirection.RIGHT,
	},
	["Finger1Slot"] = {
		id = 12,
		needsEnchant = true,
		warningCondition = {
			level = I.MaxLevelTable[MER.MetaFlavor],
		},
		needsSocket = true,
		direction = module.enumDirection.RIGHT,
	},
	["Trinket0Slot"] = {
		id = 13,
		needsEnchant = false,
		needsSocket = false,
		direction = module.enumDirection.RIGHT,
	},
	["Trinket1Slot"] = {
		id = 14,
		needsEnchant = false,
		needsSocket = false,
		direction = module.enumDirection.RIGHT,
	},
	["MainHandSlot"] = {
		id = 16,
		needsEnchant = true,
		warningCondition = {
			level = I.MaxLevelTable[MER.MetaFlavor],
		},
		needsSocket = false,
		direction = module.enumDirection.RIGHT,
	},
	["SecondaryHandSlot"] = {
		id = 17,
		needsEnchant = true,
		warningCondition = {
			itemType = ENUM_ITEM_CLASS_WEAPON,
			level = I.MaxLevelTable[MER.MetaFlavor],
		},
		needsSocket = false,
		direction = module.enumDirection.LEFT,
	},
	--[[
	["RangedSlot"] = {
		id = 19,
		needsEnchant = false,
		needsSocket = false,
		direction = module.enumDirection.LEFT,
	},]]
}

function module:GetPrimaryTalentIndex()
	local primaryTalentTreeIdx = 0
	local primaryTalentTree = GetSpecialization()

	if primaryTalentTree then
		primaryTalentTreeIdx = GetSpecializationInfo(primaryTalentTree) or 0
	end

	return primaryTalentTreeIdx
end

function module:GetSlotNameByID(slotId)
	for slot, options in pairs(module.characterSlots) do
		if options.id == slotId then
			return slot
		end
	end
end

function module:CheckMessageCondition(slotOptions)
	local conditions = slotOptions.warningCondition
	local enchantNeeded = true

	-- Level Condition
	if enchantNeeded and conditions.level then
		enchantNeeded = (conditions.level == UnitLevel("player"))
	end

	-- Primary Stat Condition
	if enchantNeeded and conditions.primary then
		enchantNeeded = false
		local spec = GetSpecialization()
		if spec then
			local primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")))
			enchantNeeded = (conditions.primary == primaryStat)
		end
	end

	-- ItemType and ItemSubtype check
	if enchantNeeded and conditions.itemType then
		local itemType = select(12, GetItemInfo(GetInventoryItemID("player", slotOptions.id)))
		enchantNeeded = (itemType == conditions.itemType)
	end

	return enchantNeeded
end

function module:EnchantAbbreviate(str)
	local abbrevs = {
		-- Primary
		[_G["SPELL_STAT" .. _G.LE_UNIT_STAT_STRENGTH .. "_NAME"]] = "Str.",
		[_G["SPELL_STAT" .. _G.LE_UNIT_STAT_AGILITY .. "_NAME"]] = "Agi.",
		[_G["SPELL_STAT" .. _G.LE_UNIT_STAT_INTELLECT .. "_NAME"]] = "Int.",
		[_G["SPELL_STAT" .. _G.LE_UNIT_STAT_STAMINA .. "_NAME"]] = "Stam.",
		-- Secondary
		[_G["STAT_VERSATILITY"]] = "Vers.",
		[_G["STAT_CRITICAL_STRIKE"]] = "Crit.",
		[_G["STAT_MASTERY"]] = "Mast.",
		-- Tertiary
		[_G["STAT_AVOIDANCE"]] = "Avoid.",
	}

	local text = gsub(gsub(str, "%s?|A.-|a", ""), "|cn.-:(.-)|r", "%1")
	local short = F.String.Abbreviate(text)
	for stat, abbrev in pairs(abbrevs) do
		short = short:gsub(stat, abbrev)
	end

	return utf8sub(short, 1, 18)
end

local function StatsPane(type)
	_G.CharacterStatsPane[type]:StripTextures()

	if _G.CharacterStatsPane[type] and _G.CharacterStatsPane[type].backdrop then
		_G.CharacterStatsPane[type].backdrop:Hide()
	end

	if _G.CharacterStatsPane[type].Title then
		_G.CharacterStatsPane[type].Title:FontTemplate(nil, 13, "SHADOWOUTLINE")
	end
end

local function CharacterStatFrameCategoryTemplate(frame)
	frame:StripTextures()

	local bg = frame.Background
	bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
	bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
	bg:ClearAllPoints()
	bg:SetPoint("CENTER", 0, -5)
	bg:SetSize(210, 30)
	bg:SetVertexColor(F.r, F.g, F.b)
end

local function ColorizeStatPane(frame)
	frame.Background:SetAlpha(0)

	local gradientFrom, gradientTo = CreateColor(F.r, F.g, F.b, 0.75), CreateColor(F.r, F.g, F.b, 0)

	if frame.leftGrad then
		frame.leftGrad:SetGradient("Horizontal", gradientFrom, gradientTo)
	end

	if frame.rightGrad then
		frame.rightGrad:SetGradient("Horizontal", gradientTo, gradientFrom)
	end
end

-- needed for Shadow&Light
local function SkinAdditionalStats()
	if CharacterStatsPane.OffenseCategory then
		if CharacterStatsPane.OffenseCategory.Title then
			CharacterStatsPane.OffenseCategory.Title:SetText(
				E:TextGradient(
					CharacterStatsPane.OffenseCategory.Title:GetText(),
					F.ClassGradient[E.myclass]["r1"],
					F.ClassGradient[E.myclass]["g1"],
					F.ClassGradient[E.myclass]["b1"],
					F.ClassGradient[E.myclass]["r2"],
					F.ClassGradient[E.myclass]["g2"],
					F.ClassGradient[E.myclass]["b2"]
				)
			)
		end
		StatsPane("OffenseCategory")
		CharacterStatFrameCategoryTemplate(CharacterStatsPane.OffenseCategory)
	end

	if CharacterStatsPane.DefenseCategory then
		if CharacterStatsPane.DefenseCategory.Title then
			CharacterStatsPane.DefenseCategory.Title:SetText(
				E:TextGradient(
					CharacterStatsPane.DefenseCategory.Title:GetText(),
					F.ClassGradient[E.myclass]["r1"],
					F.ClassGradient[E.myclass]["g1"],
					F.ClassGradient[E.myclass]["b1"],
					F.ClassGradient[E.myclass]["r2"],
					F.ClassGradient[E.myclass]["g2"],
					F.ClassGradient[E.myclass]["b2"]
				)
			)
		end
		StatsPane("DefenseCategory")
		CharacterStatFrameCategoryTemplate(CharacterStatsPane.DefenseCategory)
	end
end

local function UpdateHighlight(self)
	local highlight = self:GetHighlightTexture()
	highlight:SetColorTexture(1, 1, 1, 0.25)
	highlight:SetInside(self.bg)
end

local function UpdateCosmetic(self)
	local itemLink = GetInventoryItemLink("player", self:GetID())
	self.IconOverlay:SetShown(itemLink and IsCosmeticItem(itemLink))
end

local slots = {
	"Head",
	"Neck",
	"Shoulder",
	"Shirt",
	"Chest",
	"Waist",
	"Legs",
	"Feet",
	"Wrist",
	"Hands",
	"Finger0",
	"Finger1",
	"Trinket0",
	"Trinket1",
	"Back",
	"MainHand",
	"SecondaryHand",
	"Tabard",
}

function module:SkinCharacterFrame()
	-- Remove the background
	local modelScene = module.frameModel
	modelScene:DisableDrawLayer("BACKGROUND")
	modelScene:DisableDrawLayer("BORDER")
	modelScene:DisableDrawLayer("OVERLAY")
	modelScene.backdrop:Kill()

	for i = 1, #slots do
		local slot = _G["Character" .. slots[i] .. "Slot"]

		slot.ignoreTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent")
		slot.IconOverlay:SetAtlas("CosmeticIconFrame")
		slot.IconOverlay:SetInside()
	end

	hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
		if button.popoutButton then
			button.icon:SetShown(GetInventoryItemTexture("player", button:GetID()) ~= nil)
		end
		UpdateCosmetic(button)
		UpdateHighlight(button)
	end)

	if _G.PaperDollSidebarTabs.DecorRight then
		_G.PaperDollSidebarTabs.DecorRight:Hide()
	end

	hooksecurefunc(_G.PaperDollFrame.EquipmentManagerPane.ScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if child.icon and not child.styled then
				child.HighlightBar:SetColorTexture(1, 1, 1, 0.25)
				child.HighlightBar:SetDrawLayer("BACKGROUND")
				child.SelectedBar:SetColorTexture(F.r, F.g, F.b, 0.25)
				child.SelectedBar:SetDrawLayer("BACKGROUND")

				child.styled = true
			end
		end
	end)

	if not IsAddOnLoaded("DejaCharacterStats") then
		local pane = CharacterStatsPane
		pane.ClassBackground:Hide()
		pane.ItemLevelFrame.Corruption:SetPoint("RIGHT", 22, -8)

		pane.ItemLevelCategory.Title:SetText(
			E:TextGradient(
				pane.ItemLevelCategory.Title:GetText(),
				F.ClassGradient[E.myclass]["r1"],
				F.ClassGradient[E.myclass]["g1"],
				F.ClassGradient[E.myclass]["b1"],
				F.ClassGradient[E.myclass]["r2"],
				F.ClassGradient[E.myclass]["g2"],
				F.ClassGradient[E.myclass]["b2"]
			)
		)
		pane.AttributesCategory.Title:SetText(
			E:TextGradient(
				pane.AttributesCategory.Title:GetText(),
				F.ClassGradient[E.myclass]["r1"],
				F.ClassGradient[E.myclass]["g1"],
				F.ClassGradient[E.myclass]["b1"],
				F.ClassGradient[E.myclass]["r2"],
				F.ClassGradient[E.myclass]["g2"],
				F.ClassGradient[E.myclass]["b2"]
			)
		)
		pane.EnhancementsCategory.Title:SetText(
			E:TextGradient(
				pane.EnhancementsCategory.Title:GetText(),
				F.ClassGradient[E.myclass]["r1"],
				F.ClassGradient[E.myclass]["g1"],
				F.ClassGradient[E.myclass]["b1"],
				F.ClassGradient[E.myclass]["r2"],
				F.ClassGradient[E.myclass]["g2"],
				F.ClassGradient[E.myclass]["b2"]
			)
		)

		StatsPane("EnhancementsCategory")
		StatsPane("ItemLevelCategory")
		StatsPane("AttributesCategory")

		CharacterStatFrameCategoryTemplate(pane.ItemLevelCategory)
		CharacterStatFrameCategoryTemplate(pane.AttributesCategory)
		CharacterStatFrameCategoryTemplate(pane.EnhancementsCategory)

		ColorizeStatPane(pane.ItemLevelFrame)
		E:Delay(0.2, SkinAdditionalStats)
	end
end

function module:UpdateItemLevel()
	if not module.frame:IsShown() then
		return
	end

	F.SetFontDB(module.frame.ItemLevelText, module.db.stats.itemLevelFont)

	local itemLevelText

	local avgItemLevel, avgItemLevelEquipped = GetAverageItemLevel()
	local minItemLevel = GetMinItemLevel()
	local displayItemLevel = max(minItemLevel or 0, avgItemLevelEquipped)

	if module.db.stats.showAvgItemLevel then
		itemLevelText = format(
			format("%s / %s", module.db.stats.itemLevelFormat, module.db.stats.itemLevelFormat),
			displayItemLevel,
			avgItemLevel
		)
	else
		itemLevelText = format(module.db.stats.itemLevelFormat, displayItemLevel)
	end

	if module.db.stats.itemLevelFont.itemLevelFontColor == "GRADIENT" then
		local epicComplete = select(13, GetAchievementInfo(40147))

		if epicComplete then
			module.frame.ItemLevelText:SetText(F.String.FastGradient(itemLevelText, 0.78, 0.13, 0.57, 0.42, 0.08, 0.82))
		else
			local rareComplete = select(13, GetAchievementInfo(40146))

			if rareComplete then
				module.frame.ItemLevelText:SetText(
					F.String.FastGradient(itemLevelText, 0.01, 0.78, 0.98, 0, 0.38, 0.90)
				)
			else
				module.frame.ItemLevelText:SetText(
					F.String.FastGradient(itemLevelText, 0.07, 0.90, 0.15, 0, 0.69, 0.11)
				)
			end
		end
	elseif module.db.stats.itemLevelFont.itemLevelFontColor == "VALUE" then
		module.frame.ItemLevelText:SetText(F.String.ElvUIValue(itemLevelText))
	elseif module.db.stats.itemLevelFont.itemLevelFontColor == "CUSTOM" then
		module.frame.ItemLevelText:SetText(itemLevelText)
		F.SetFontColorDB(module.frame.ItemLevelText, module.db.stats.itemLevelFont.color)
	else
		module.frame.ItemLevelText:SetText(itemLevelText)
	end
end

function module:UpdateTitle()
	F.SetFontDB(self.nameText, module.db.nameText)
	F.SetFontDB(self.titleText, module.db.titleText)
	F.SetFontDB(self.levelTitleText, module.db.levelTitleText)
	F.SetFontDB(self.levelText, module.db.levelText)
	F.SetFontDB(self.classText, module.db.classText)
	F.SetFontDB(self.specIcon, module.db.specIcon)

	local titleId = GetCurrentTitle()
	local titleName = GetTitleName(titleId) or ""
	local classNames = LOCALIZED_CLASS_NAMES_MALE
	local level = UnitLevel("player")
	local playerEffectiveLevel = UnitEffectiveLevel("player")

	if playerEffectiveLevel ~= level then
		level = EFFECTIVE_LEVEL_FORMAT:format(playerEffectiveLevel, level)
	end

	local currentClass = E.myclass
	if UnitSex("player") == 3 then
		classNames = LOCALIZED_CLASS_NAMES_FEMALE
	end

	local primaryTalentTreeIdx = module:GetPrimaryTalentIndex()

	-- Those cannot be empty
	if not currentClass or not level then
		return
	end

	local classColorNormal = E.db.mui.themes.classColorMap[I.Enum.GradientMode.Color.NORMAL][currentClass]

	if module.db.nameText.fontColor == "GRADIENT" then
		self.nameText:SetText(F.String.FastGradient(E.myname, 0, 0.6, 1, 0, 0.9, 1))
	elseif module.db.nameText.fontColor == "CLASS" then
		self.nameText:SetText(F.String.GradientClass(E.myname))
	else
		self.nameText:SetText(E.myname)
		F.SetFontColorDB(self.nameText, module.db.nameText.color)
	end

	self.classSymbol:SetTexture(MER.ClassIcons[E.myclass])

	if module.db.titleText.fontColor == "GRADIENT" then
		self.titleText:SetText(F.String.FastGradient(titleName, 0, 0.9, 1, 0, 0.6, 1))
	else
		self.titleText:SetText(titleName)
		F.SetFontColorDB(self.titleText, module.db.titleText.color)
	end

	if module.db.levelTitleText.short then
		self.levelTitleText:SetText("Lvl")
	else
		self.levelTitleText:SetText("Level")
	end

	self.levelText:SetText(level)

	local fontIcon = E.db.mui.armory.icons[primaryTalentTreeIdx] or E.db.mui.armory.icons[0]
	if module.db.specIcon.fontColor == "CLASS" then
		self.specIcon:SetText(F.String.RGB(fontIcon, classColorNormal))
	else
		self.specIcon:SetText(fontIcon)
		F.SetFontColorDB(self.specIcon, module.db.specIcon.color)
	end

	if module.db.classText.fontColor == "CLASS" then
		self.classText:SetText(F.String.GradientClass(classNames[currentClass], nil, true))
	else
		self.classText:SetText(classNames[currentClass])
		F.SetFontColorDB(self.classText, module.db.classText.color)
	end

	self.nameText:ClearAllPoints()
	self.nameText:SetPoint("TOP", self.frameModel, module.db.nameText.offsetX, 59 + module.db.nameText.offsetY)
	self.nameText:SetJustifyH("CENTER")
	self.nameText:SetJustifyV("BOTTOM")

	self.classSymbol:ClearAllPoints()
	self.classSymbol:SetSize(16, 16)
	self.classSymbol:SetPoint("RIGHT", self.nameText, "LEFT", -5, 0)

	self.titleText:ClearAllPoints()
	self.titleText:SetPoint("LEFT", self.nameText, "RIGHT", module.db.titleText.offsetX, module.db.titleText.offsetY)
	self.titleText:SetJustifyH("LEFT")
	self.titleText:SetJustifyV("BOTTOM")

	local iconPadding = 10
	local textPadding = 2

	local leftWidth = self.levelText:GetStringWidth() + self.levelTitleText:GetStringWidth() + textPadding
	local rightWidth = self.classText:GetStringWidth()
	local iconWidth = self.specIcon:GetStringWidth() + (iconPadding * 2)
	local totalWidth = leftWidth + rightWidth + iconWidth
	local anchorWidth = totalWidth - (leftWidth + (iconWidth / 2))
	local centerOffset = (totalWidth / 2) - anchorWidth

	self.specIcon:ClearAllPoints()
	self.specIcon:SetPoint("TOP", module.frameModel, centerOffset, 30)
	self.specIcon:SetJustifyH("CENTER")
	self.specIcon:SetJustifyV("BOTTOM")

	self.levelText:ClearAllPoints()
	self.levelText:SetPoint(
		"RIGHT",
		self.specIcon,
		"LEFT",
		(-iconPadding + module.db.levelText.offsetX),
		module.db.levelText.offsetY
	)
	self.levelText:SetJustifyH("LEFT")
	self.levelText:SetJustifyV("BOTTOM")

	self.levelTitleText:ClearAllPoints()
	self.levelTitleText:SetPoint(
		"RIGHT",
		self.levelText,
		"LEFT",
		(-textPadding + module.db.levelTitleText.offsetX),
		module.db.levelTitleText.offsetY
	)
	self.levelTitleText:SetJustifyH("LEFT")
	self.levelTitleText:SetJustifyV("BOTTOM")

	self.classText:ClearAllPoints()
	self.classText:SetPoint(
		"LEFT",
		self.specIcon,
		"RIGHT",
		(iconPadding + module.db.classText.offsetX),
		module.db.classText.offsetY
	)
	self.classText:SetJustifyH("RIGHT")
	self.classText:SetJustifyV("BOTTOM")
end

function module:UpdatePageInfo(_, _, which)
	if (which ~= nil) and (which ~= "Character") then
		return
	end

	for slot, options in pairs(module.characterSlots) do
		if (options.id ~= 4) and (options.id ~= 18) then
			local slotFrame = _G["Character" .. slot]

			if module.db.pageInfo.moveSockets then
				local slotWidth, slotHeight = slotFrame:GetWidth(), slotFrame:GetHeight()

				for i = 1, 3 do
					local socket = slotFrame["textureSlot" .. i]
					local socketWidth, socketHeight = 16, 8
					socket:SetSize(socketWidth, socketHeight)
					local left, right, top, bottom = E:CropRatio(socket)
					socket:SetTexCoord(left, right, top, bottom)
					socket:ClearAllPoints()

					if i == 1 then
						if options.direction == module.enumDirection.LEFT then
							socket:SetPoint(
								"BOTTOMLEFT",
								slotFrame,
								"BOTTOMLEFT",
								slotWidth + 10,
								slotHeight - socketHeight - E.Border
							)
						elseif options.direction == module.enumDirection.RIGHT then
							socket:SetPoint(
								"BOTTOMRIGHT",
								slotFrame,
								"BOTTOMRIGHT",
								-(slotWidth + 10),
								slotHeight - socketHeight - E.Border
							)
						end
					else
						local prevSocket = slotFrame["textureSlot" .. i - 1]
						if options.direction == module.enumDirection.LEFT then
							socket:SetPoint("BOTTOMLEFT", prevSocket, "BOTTOMRIGHT", 0, 0)
						elseif options.direction == module.enumDirection.RIGHT then
							socket:SetPoint("BOTTOMRIGHT", prevSocket, "BOTTOMLEFT", 0, 0)
						end
					end
				end
			end

			-- ItemLevel Slot Text
			if slotFrame.iLvlText then
				F.SetFontDB(slotFrame.iLvlText, module.db.pageInfo.iLvLFont)
			end

			-- Enchant Slot Text
			if slotFrame.enchantText then
				F.SetFontDB(slotFrame.enchantText, module.db.pageInfo.enchantFont)
			end
		end
	end

	module:UpdateItemLevel()
end

function module:UpdatePageStrings(slotId, _, slotItem, slotInfo, which)
	local db = E.db.mui.armory
	if which ~= "Character" then
		return
	end
	if not slotItem.enchantText or not slotItem.iLvlText then
		return
	end

	local slotName = module:GetSlotNameByID(slotId)
	if not slotName then
		return
	end

	local slotOptions = module.characterSlots[slotName]
	if not slotOptions then
		return
	end

	-- Enchant/Socket Text Handling
	if db.pageInfo.enchantTextEnabled and slotInfo.itemLevelColors and next(slotInfo.itemLevelColors) then
		if db.pageInfo.missingSocketText and slotOptions.needsSocket then
			if not slotOptions.warningCondition or module:CheckMessageCondition(slotOptions) then
				local missingGemSlots = 2 - #slotInfo.gems
				if missingGemSlots > 0 then
					local text = format("Add %d sockets", missingGemSlots)
					local missingColor = {
						F.String.FastColorGradientHex(
							missingGemSlots / 2,
							module.colors.LIGHT_GREEN,
							module.colors.RED
						),
					}
					slotItem.enchantText:SetText(F.String.RGB(text, missingColor))
				end
			else
				slotItem.enchantText:SetText("")
			end
		elseif slotInfo.enchantColors and next(slotInfo.enchantColors) then
			if slotInfo.enchantText and slotInfo.enchantText ~= "" then
				local text = slotInfo.enchantTextShort
				-- Strip color
				text = F.String.StripColor(text)
				if db.pageInfo.abbreviateEnchantText then
					text = module:EnchantAbbreviate(slotInfo.enchantText)
				end

				if db.pageInfo.useEnchantClassColor then
					slotItem.enchantText:SetText(F.String.Class(text))
				else
					slotItem.enchantText:SetText(text)
				end
			end
		elseif db.pageInfo.missingEnchantText and slotOptions.needsEnchant and not E.TimerunningID then
			if not slotOptions.warningCondition or module:CheckMessageCondition(slotOptions) then
				slotItem.enchantText:SetText(F.String.Error("Add enchant"))
			else
				slotItem.enchantText:SetText("")
			end
		else
			slotItem.enchantText:SetText("")
		end
	else
		slotItem.enchantText:SetText("")
	end

	-- Hide Gradient
	if slotItem.MERGradient then
		slotItem.MERGradient:Hide()
	end

	-- If we got an item color, show gradient and set color
	if slotInfo.itemLevelColors and next(slotInfo.itemLevelColors) then
		local r, g, b = unpack(slotInfo.itemLevelColors)

		-- Create Gradient if it doesen't exist
		if not slotItem.MERGradient then
			slotItem.MERGradient = CreateFrame("Frame", nil, slotItem)
			slotItem.MERGradient:SetFrameLevel(module.frameModel:GetFrameLevel() - 1)

			slotItem.MERGradient.Texture = slotItem.MERGradient:CreateTexture(nil, "OVERLAY")
			slotItem.MERGradient.Texture:SetInside()
			slotItem.MERGradient.Texture:SetTexture(E.media.blankTex)
			slotItem.MERGradient.Texture:SetVertexColor(1, 1, 1, 1)

			if slotOptions.direction == module.enumDirection.LEFT then
				slotItem.MERGradient:SetPoint("BOTTOMLEFT", slotItem, "BOTTOMRIGHT", -1, -1)
			elseif slotOptions.direction == module.enumDirection.RIGHT then
				slotItem.MERGradient:SetPoint("BOTTOMRIGHT", slotItem, "BOTTOMLEFT", 1, -1)
			end
		end

		-- Update Size
		slotItem.MERGradient:SetSize(db.pageInfo.itemQualityGradientWidth, db.pageInfo.itemQualityGradientHeight)

		-- Update Colors
		if slotOptions.direction == module.enumDirection.LEFT then
			F.SetGradientRGB(
				slotItem.MERGradient.Texture,
				"HORIZONTAL",
				r,
				g,
				b,
				db.pageInfo.itemQualityGradientStartAlpha,
				r,
				g,
				b,
				db.pageInfo.itemQualityGradientEndAlpha
			)
		elseif slotOptions.direction == module.enumDirection.RIGHT then
			F.SetGradientRGB(
				slotItem.MERGradient.Texture,
				"HORIZONTAL",
				r,
				g,
				b,
				db.pageInfo.itemQualityGradientEndAlpha,
				r,
				g,
				b,
				db.pageInfo.itemQualityGradientStartAlpha
			)
		end

		if db.pageInfo.itemQualityGradientEnabled then
			slotItem.MERGradient:Show()
		else
			slotItem.MERGradient:Hide()
		end
	end

	-- iLvL Text Handling
	if not db.pageInfo.itemLevelTextEnabled then
		slotItem.iLvlText:SetText("")
	end

	-- Icons Handling
	if not db.pageInfo.itemLevelTextEnabled or not db.pageInfo.iconsEnabled then
		for x = 1, 10 do
			local essenceType = slotItem["textureSlotEssenceType" .. x]
			if essenceType then
				essenceType:Hide()
			end
			slotItem["textureSlot" .. x]:SetTexture()
			slotItem["textureSlotBackdrop" .. x]:Hide()
		end
	end
end

function module:UpdateCharacterStats()
	if not module.frame:IsShown() then
		return
	end

	local characterStatsPane = _G.CharacterStatsPane
	local titlePane = _G.PaperDollFrame.TitleManagerPane
	local equipmentPane = _G.PaperDollFrame.EquipmentManagerPane
	local sidebarTabs = _G.PaperDollSidebarTabs
	if not characterStatsPane then
		return
	end

	local strataFrames = { characterStatsPane, titlePane, equipmentPane, sidebarTabs }
	for _, frame in ipairs(strataFrames) do
		if frame then
			frame:SetFrameStrata("HIGH")
		end
	end

	for frame in CharacterStatsPane.statsFramePool:EnumerateActive() do
		if frame.leftGrad then -- Check if the ElvUI Element is there
			ColorizeStatPane(frame)
		end

		local shown = frame.Background:IsShown()
		frame.leftGrad:SetShown(shown)
		frame.rightGrad:SetShown(shown)
	end
end

function module:HandleEvent(event, unit)
	if not module.frame:IsShown() then
		return
	end

	if event == "UNIT_NAME_UPDATE" then
		if unit == "player" then
			self:UpdateTitle()
		end
	elseif event == "UNIT_LEVEL" then
		self:UpdateTitle()
	elseif (event == "PLAYER_PVP_RANK_CHANGED") or (event == "PLAYER_TALENT_UPDATE") then
		self:UpdateTitle()
	elseif event == "PLAYER_AVG_ITEM_LEVEL_UPDATE" then
		module:UpdateItemLevel()
	end
end

local isHooked = false
function module:UpdateBackground()
	if module.db.general.hideControls then
		local controlFrame = _G.CharacterModelScene and _G.CharacterModelScene.ControlFrame
		if controlFrame and not isHooked then
			controlFrame:SetScript("OnShow", function(frame)
				frame:Hide()
			end)
			isHooked = true
		end
	end
end

function module:UpdateLineColors()
	local orientation = "HORIZONTAL"
	local white = CreateColor(1, 1, 1, 1)

	local top = module.frame.topLine.Texture
	local bottom = module.frame.bottomLine.Texture

	-- Reset gradient
	top:SetGradient(orientation, white, white)
	bottom:SetGradient(orientation, white, white)

	if module.db.lines.enable then
		local alpha = module.db.lines.alpha

		top:SetColorTexture(1, 1, 1, alpha)
		bottom:SetColorTexture(1, 1, 1, alpha)

		if module.db.lines.color == "CLASS" then
			local classColor = E:ClassColor(E.myclass, true)
			local r, g, b = classColor.r, classColor.g, classColor.b

			top:SetColorTexture(r, g, b, alpha)
			bottom:SetColorTexture(r, g, b, alpha)
		end

		if module.db.lines.color == "GRADIENT" then
			if E.db.mui.themes.classColorMap then
				local colorMap = E.db.mui.themes.classColorMap

				local left = colorMap[1][E.myclass] -- Left (player UF)
				local right = colorMap[2][E.myclass] -- Right (player UF)

				if left and left.r and right and right.r then
					top:SetGradient(
						orientation,
						{ r = left.r, g = left.g, b = left.b, a = alpha },
						{ r = right.r, g = right.g, b = right.b, a = alpha }
					)
					bottom:SetGradient(
						orientation,
						{ r = left.r, g = left.g, b = left.b, a = alpha },
						{ r = right.r, g = right.g, b = right.b, a = alpha }
					)
				else
					F.DebugPrint("Armory Lines >> Left or Right gradient not found", "error")
				end
			else
				F.DebugPrint("Armory Lines >> Gradient color map not found", "error")
			end
		end
	else
		top:SetColorTexture(0, 0, 0, 0)
		bottom:SetColorTexture(0, 0, 0, 0)
	end
end

function module:UpdateLines()
	local height = module.db.lines.height

	module.frame.topLine:SetHeight(height)
	module.frame.bottomLine:SetHeight(height)

	self:UpdateLineColors()
end

function module:KillBlizzard()
	local killList = { "CharacterLevelText", "CharacterFrameTitleText", "CharacterModelFrameBackgroundOverlay" }
	for _, frame in ipairs(killList) do
		if _G[frame] then
			_G[frame]:Kill()
		end
	end

	if module.frameModel.backdrop then
		module.frameModel.backdrop:Kill()
	end

	for _, corner in pairs({ "TopLeft", "TopRight", "BotLeft", "BotRight" }) do
		local bg = _G["CharacterModelFrameBackground" .. corner]
		if bg then
			bg:Kill()
		end
	end

	module.frameModel:DisableDrawLayer("BACKGROUND")
	module.frameModel:DisableDrawLayer("BORDER")
	module.frameModel:DisableDrawLayer("OVERLAY")
end

function module:UpdateCharacterArmory()
	if not module.db or not module.db.enable then
		return
	end

	module:KillBlizzard()
	module:UpdateBackground()
	module:UpdateLines()
	module:UpdateTitle()
	module:UpdatePageInfo()
	module:UpdateCharacterStats()

	if module.frame:IsShown() then
		M:UpdateCharacterInfo()
	end
end

function module:OpenCharacterArmory()
	E:Delay(0.01, function()
		module:UpdateCharacterArmory()
	end)
end

function module:CreateElements()
	if module.frame then
		return
	end

	-- Vars
	module.frame = _G.CharacterFrame
	module.frameModel = _G.CharacterModelScene
	module.frameName = module.frame:GetName()
	module.frameHolder = CreateFrame("FRAME", nil, module.frameModel)

	local nameText = module.frameHolder:CreateFontString(nil, "OVERLAY")
	local classSymbol = module.frameHolder:CreateTexture()
	local titleText = module.frameHolder:CreateFontString(nil, "OVERLAY")
	local levelTitleText = module.frameHolder:CreateFontString(nil, "OVERLAY")
	local levelText = module.frameHolder:CreateFontString(nil, "OVERLAY")
	local specIcon = module.frameHolder:CreateFontString(nil, "OVERLAY")
	local classText = module.frameHolder:CreateFontString(nil, "OVERLAY")

	local frameHeight, frameWidth = module.frame:GetSize()
	local cutOffPercentage = (1 - (frameHeight / frameWidth))

	local background = CreateFrame("Frame", nil, module.frameHolder)
	background:SetInside(module.frame)
	background:SetFrameLevel(module.frameModel:GetFrameLevel() - 1)
	background.Texture = background:CreateTexture(nil, "BACKGROUND")
	background.Texture:SetInside()
	background.Texture:SetTexCoord(0, 1, cutOffPercentage, 1)

	module.frame.MERBackground = background

	local lineHeight = 1
	local topLine = CreateFrame("Frame", nil, module.frameHolder)
	local bottomLine = CreateFrame("Frame", nil, module.frameHolder)
	local classColor = E:ClassColor(E.myclass, true)

	topLine:SetHeight(lineHeight)
	bottomLine:SetHeight(lineHeight)
	topLine:SetPoint("TOPLEFT", module.frame.MERBackground, "TOPLEFT", 0, 0)
	topLine:SetPoint("TOPRIGHT", module.frame.MERBackground, "TOPRIGHT", 0, 0)
	bottomLine:SetPoint("BOTTOMLEFT", module.frame.MERBackground, "BOTTOMLEFT", 0, 1)
	bottomLine:SetPoint("BOTTOMRIGHT", module.frame.MERBackground, "BOTTOMRIGHT", 0, 1)
	topLine.Texture = topLine:CreateTexture(nil, "BACKGROUND")
	bottomLine.Texture = bottomLine:CreateTexture(nil, "BACKGROUND")
	topLine.Texture:SetAllPoints()
	bottomLine.Texture:SetAllPoints()

	module.frame.topLine = topLine
	module.frame.bottomLine = bottomLine

	module:UpdateLineColors()

	module.nameText = nameText
	module.classSymbol = classSymbol
	module.titleText = titleText
	module.levelTitleText = levelTitleText
	module.levelText = levelText
	module.specIcon = specIcon
	module.classText = classText
end

function module:Initialize()
	module.db = E.db.mui.armory

	if self:IsHooked(_G, "PaperDollFrame_UpdateStats") then
		return
	end

	if not module.db.enable or module.initialized then
		return
	end

	-- Check if ElvUI's Character Info is enabled
	if not E.db.general.itemLevel.displayCharacterInfo then
		return
	end

	self:CreateElements()
	self:SkinCharacterFrame()

	hooksecurefunc(M, "UpdateCharacterInfo", self.UpdateItemLevel)
	hooksecurefunc(M, "UpdateAverageString", self.UpdateItemLevel)
	hooksecurefunc(M, "UpdatePageInfo", self.UpdatePageInfo)
	hooksecurefunc(M, "CreateSlotStrings", self.UpdatePageInfo)
	hooksecurefunc(M, "UpdatePageStrings", self.UpdatePageStrings)
	hooksecurefunc("PaperDollFrame_UpdateStats", self.UpdateCharacterStats)

	-- Register Events
	F.Event.RegisterFrameEventAndCallback("UNIT_NAME_UPDATE", self.HandleEvent, self, "UNIT_NAME_UPDATE")
	F.Event.RegisterFrameEventAndCallback("UNIT_LEVEL", self.HandleEvent, self, "UNIT_LEVEL")
	F.Event.RegisterFrameEventAndCallback("PLAYER_PVP_RANK_CHANGED", self.HandleEvent, self, "PLAYER_PVP_RANK_CHANGED")
	F.Event.RegisterFrameEventAndCallback(
		"PLAYER_AVG_ITEM_LEVEL_UPDATE",
		self.HandleEvent,
		self,
		"PLAYER_AVG_ITEM_LEVEL_UPDATE"
	)
	F.Event.RegisterFrameEventAndCallback("PLAYER_TALENT_UPDATE", self.HandleEvent, self, "PLAYER_TALENT_UPDATE")

	self:SecureHookScript(module.frame, "OnShow", "OpenCharacterArmory")

	module.initialized = true
end

MER:RegisterModule(module:GetName())
