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
local UnitLevel = UnitLevel
local UnitSex = UnitSex

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
local IsCosmeticItem = C_Item and C_Item.IsCosmeticItem or IsCosmeticItem
local GetMinItemLevel = C_PaperDollInfo and C_PaperDollInfo.GetMinItemLevel or GetMinItemLevel
local ENUM_ITEM_CLASS_WEAPON = _G.Enum.ItemClass.Weapon

local ClassSymbolFrame
local CharacterText

module.enumDirection = F.Enum({ "LEFT", "RIGHT", "BOTTOM" })
module.colors = {
	LIGHT_GREEN = "#12E626",
	DARK_GREEN = "#00B01C",
	RED = "#F0544F",
}
module.characterSlots = {
	["HeadSlot"] = {
		id = 1,
		needsEnchant = true,
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
		needsSocket = false,
		direction = module.enumDirection.RIGHT,
	},
	["Finger1Slot"] = {
		id = 12,
		needsEnchant = true,
		warningCondition = {
			level = I.MaxLevelTable[MER.MetaFlavor],
		},
		needsSocket = false,
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
	if frame.leftGrad then
		frame.leftGrad:StripTextures()
	end
	if frame.rightGrad then
		frame.rightGrad:StripTextures()
	end

	frame.leftGrad = frame:CreateTexture(nil, "BORDER")
	frame.leftGrad:SetWidth(80)
	frame.leftGrad:SetHeight(frame:GetHeight())
	frame.leftGrad:SetPoint("LEFT", frame, "CENTER")
	frame.leftGrad:SetTexture(E.media.blankTex)
	frame.leftGrad:SetGradient("Horizontal", CreateColor(F.r, F.g, F.b, 0.75), CreateColor(F.r, F.g, F.b, 0))

	frame.rightGrad = frame:CreateTexture(nil, "BORDER")
	frame.rightGrad:SetWidth(80)
	frame.rightGrad:SetHeight(frame:GetHeight())
	frame.rightGrad:SetPoint("RIGHT", frame, "CENTER")
	frame.rightGrad:SetTexture(E.media.blankTex)
	frame.rightGrad:SetGradient("Horizontal", CreateColor(F.r, F.g, F.b, 0), CreateColor(F.r, F.g, F.b, 0.75))
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

function module:AddCharacterIcon()
	local CharacterFrameTitleText = _G.CharacterFrameTitleText
	local CharacterLevelText = _G.CharacterLevelText

	-- Class Icon Holder
	local ClassIconHolder = CreateFrame("Frame", "MER_ClassIcon", _G.PaperDollFrame)
	ClassIconHolder:SetSize(20, 20)

	local ClassIconTexture = ClassIconHolder:CreateTexture()
	ClassIconTexture:SetAllPoints(ClassIconHolder)

	CharacterLevelText:SetWidth(300)

	ClassSymbolFrame = ("|T" .. (MER.ClassIcons[E.myclass] .. ".tga:0:0:0:0|t"))

	hooksecurefunc("PaperDollFrame_SetLevel", function()
		CharacterFrameTitleText:SetDrawLayer("OVERLAY")
		CharacterFrameTitleText:SetFont(
			E.LSM:Fetch("font", E.db.general.font),
			E.db.general.fontSize + 2,
			E.db.general.fontStyle
		)

		CharacterLevelText:SetDrawLayer("OVERLAY")
	end)

	local titleText, coloredTitleText

	local function colorTitleText()
		CharacterText = CharacterFrameTitleText:GetText()
		coloredTitleText = E:TextGradient(
			CharacterText,
			F.ClassGradient[E.myclass]["r1"],
			F.ClassGradient[E.myclass]["g1"],
			F.ClassGradient[E.myclass]["b1"],
			F.ClassGradient[E.myclass]["r2"],
			F.ClassGradient[E.myclass]["g2"],
			F.ClassGradient[E.myclass]["b2"]
		)
		if not CharacterText:match("|T") then
			titleText = ClassSymbolFrame .. " " .. coloredTitleText
		end
		CharacterFrameTitleText:SetText(titleText)
	end

	hooksecurefunc("CharacterFrame_Collapse", function()
		if _G.PaperDollFrame:IsShown() then
			colorTitleText()
		end
	end)

	hooksecurefunc("CharacterFrame_Expand", function()
		if _G.PaperDollFrame:IsShown() then
			colorTitleText()
		end
	end)

	hooksecurefunc("ReputationFrame_Update", function()
		if _G.ReputationFrame:IsShown() then
			colorTitleText()
		end
	end)

	hooksecurefunc("TokenFrame_Update", function()
		if _G.TokenFrame:IsShown() then
			colorTitleText()
		end
	end)

	hooksecurefunc(_G.CharacterFrame, "SetTitle", function()
		colorTitleText()
	end)

	if E.db.general.itemLevel.displayCharacterInfo then
		M:UpdatePageInfo(_G.CharacterFrame, "Character")
	end
end

function module:SkinCharacterFrame()
	-- Remove the background
	local modelScene = module.frameModel
	modelScene:DisableDrawLayer("BACKGROUND")
	modelScene:DisableDrawLayer("BORDER")
	modelScene:DisableDrawLayer("OVERLAY")
	modelScene.backdrop:Kill()

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

	if not C_AddOns_IsAddOnLoaded("DejaCharacterStats") then
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

		hooksecurefunc("PaperDollFrame_UpdateStats", function()
			for _, Table in ipairs({ pane.statsFramePool:EnumerateActive() }) do
				if type(Table) == "table" then
					for statFrame in pairs(Table) do
						ColorizeStatPane(statFrame)
						if statFrame.Background:IsShown() then
							statFrame.leftGrad:Show()
							statFrame.rightGrad:Show()
						else
							statFrame.leftGrad:Hide()
							statFrame.rightGrad:Hide()
						end
					end
				end
			end
		end)
	end

	module:AddCharacterIcon()
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
		local epicComplete = select(13, GetAchievementInfo(18977))

		if epicComplete then
			module.frame.ItemLevelText:SetText(F.String.FastGradient(itemLevelText, 0.78, 0.13, 0.57, 0.42, 0.08, 0.82))
		else
			local rareComplete = select(13, GetAchievementInfo(18976))

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

function module:UpdatePageInfo(_, _, which)
	if not module:CheckOptions("Character") then
		return
	end

	for slot, options in pairs(module.characterSlots) do
		if (options.id ~= 4) and (options.id ~= 18) then
			local slotFrame = _G["Character" .. slot]

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
	if module.db.pageInfo.enchantTextEnabled and slotInfo.itemLevelColors and next(slotInfo.itemLevelColors) then
		if slotInfo.enchantColors and next(slotInfo.enchantColors) then
			if slotInfo.enchantText and (slotInfo.enchantText ~= "") then
				local text = slotInfo.enchantTextShort
				if module.db.pageInfo.abbreviateEnchantText then
					text = module:EnchantAbbreviate(slotInfo.enchantText)
				end
				if slotOptions.direction == module.enumDirection.LEFT then
					slotItem.enchantText:SetText(
						F.String.FastGradientHex(text, module.colors.DARK_GREEN, module.colors.LIGHT_GREEN)
					)
				elseif slotOptions.direction == module.enumDirection.RIGHT then
					slotItem.enchantText:SetText(
						F.String.FastGradientHex(text, module.colors.LIGHT_GREEN, module.colors.DARK_GREEN)
					)
				end
			end
		elseif module.db.pageInfo.missingEnchantText and slotOptions.needsEnchant then
			if not slotOptions.warningCondition or (module:CheckMessageCondition(slotOptions)) then
				slotItem.enchantText:SetText(F.String.Error("Missing"))
			else
				slotItem.enchantText:SetText("")
			end
		elseif module.db.pageInfo.missingSocketText and slotOptions.needsSocket then
			if not slotOptions.warningCondition or (module:CheckMessageCondition(slotOptions)) then
				local missingGemSlots = 3 - #slotInfo.gems
				if missingGemSlots > 0 then
					local text = format("Missing %d", missingGemSlots)
					local missingColor = {
						F.String.FastColorGradientHex(
							missingGemSlots / 3,
							module.colors.LIGHT_GREEN,
							module.colors.RED
						),
					}
					slotItem.enchantText:SetText(F.String.RGB(text, missingColor))
				end
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
		slotItem.MERGradient:SetSize(
			module.db.pageInfo.itemQualityGradientWidth,
			module.db.pageInfo.itemQualityGradientHeight
		)

		-- Update Colors
		if slotOptions.direction == module.enumDirection.LEFT then
			F.SetGradientRGB(
				slotItem.MERGradient.Texture,
				"HORIZONTAL",
				r,
				g,
				b,
				module.db.pageInfo.itemQualityGradientStartAlpha,
				r,
				g,
				b,
				module.db.pageInfo.itemQualityGradientEndAlpha
			)
		elseif slotOptions.direction == module.enumDirection.RIGHT then
			F.SetGradientRGB(
				slotItem.MERGradient.Texture,
				"HORIZONTAL",
				r,
				g,
				b,
				module.db.pageInfo.itemQualityGradientEndAlpha,
				r,
				g,
				b,
				module.db.pageInfo.itemQualityGradientStartAlpha
			)
		end

		if module.db.pageInfo.itemQualityGradientEnabled then
			slotItem.MERGradient:Show()
		else
			slotItem.MERGradient:Hide()
		end
	end

	-- iLvL Text Handling
	if not module.db.pageInfo.itemLevelTextEnabled then
		slotItem.iLvlText:SetText("")
	end

	-- Icons Handling
	if not module.db.pageInfo.itemLevelTextEnabled or not module.db.pageInfo.iconsEnabled then
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

function module:HandleEvent(event, unit)
	if not module.frame:IsShown() then
		return
	end

	if event == "PLAYER_AVG_ITEM_LEVEL_UPDATE" then
		module:UpdateItemLevel()
	end
end

function module:CheckOptions(which)
	if not E.private.skins.blizzard.enable then
		return false
	end

	if which == "Character" and not E.private.skins.blizzard.character then
		return false
	end

	return true
end

function module:Initialize()
	module.db = E.db.mui.armory

	if not module.db.enable or not module:CheckOptions() or module.initialized then
		return
	end

	-- Check if ElvUI's Character Info is enabled
	if not E.db.general.itemLevel.displayCharacterInfo then
		return
	end

	-- Vars
	module.frame = _G.CharacterFrame
	module.frameModel = _G.CharacterModelScene
	module.frameName = self.frame:GetName()

	module:SkinCharacterFrame()

	hooksecurefunc(M, "UpdateCharacterInfo", module.UpdateItemLevel)
	hooksecurefunc(M, "UpdateAverageString", module.UpdateItemLevel)
	hooksecurefunc(M, "UpdatePageInfo", module.UpdatePageInfo)
	hooksecurefunc(M, "CreateSlotStrings", module.UpdatePageInfo)
	hooksecurefunc(M, "UpdatePageStrings", module.UpdatePageStrings) --should be ok to call

	module:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_UPDATE", module.HandleEvent)

	module.initialized = true
end

MER:RegisterModule(module:GetName())
