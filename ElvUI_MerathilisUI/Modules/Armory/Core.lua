local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Armory")
local M = E:GetModule("Misc")

local _G = _G
local gsub, next, pairs, select = gsub, next, pairs, select
local utf8sub = string.utf8sub
local twipe = table.wipe

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

function module:AnimationsAllowed()
	return (not InCombatLockdown()) and module.db.animations
end

function module:ClearAnimations(stats)
	if stats then
		self.statsCount = 1
		twipe(self.statsObjects)
	else
		twipe(self.animationObjects)
	end
end

function module:GetAnimationSlot(stats)
	if stats then
		local count = self.statsCount
		self.statsCount = self.statsCount + 1
		return count
	end
end

function module:AddAnimation(anim, stats, slot)
	if stats then
		if not slot then
			self.statsCount = self.statsCount + 1
		end
		self.statsObjects[anim] = true
	else
		self.animationObjects[anim] = true
	end
end

function module:PlayAnimations()
	for anim, _ in pairs(self.statsObjects) do
		if anim:IsPlaying() then
			anim:Stop()
		end
		if self:AnimationsAllowed() then
			anim:Play()
		end
	end

	for anim, _ in pairs(self.animationObjects) do
		if anim:IsPlaying() then
			anim:Stop()
		end
		if self:AnimationsAllowed() then
			anim:Play()
		end
	end
end

function module:SetupGrowAnimation(obj, hold)
	local holdDuration, fadeDuration, growDuration = 0.02, 0.15, 1

	if obj.GrowIn then
		if hold and hold > 0 then
			obj.GrowIn.Hold:SetDuration(
				((hold * holdDuration) * module.db.animationsMult) + ((fadeDuration * 0.3) * module.db.animationsMult)
			)
		else
			obj.GrowIn.Hold:SetDuration(0)
		end

		obj.GrowIn.Grow:SetDuration(growDuration * module.db.animationsMult)
		return
	end

	obj.GrowIn = F.Animation.CreateAnimationGroup(obj)

	obj.GrowIn.ResetGrow = obj.GrowIn:CreateAnimation("Width")
	obj.GrowIn.ResetGrow:SetDuration(0)
	obj.GrowIn.ResetGrow:SetChange(0)
	obj.GrowIn.ResetGrow:SetOrder(1)

	obj.GrowIn.Hold = obj.GrowIn:CreateAnimation("Sleep")
	obj.GrowIn.Hold:SetOrder(2)

	obj.GrowIn.Grow = obj.GrowIn:CreateAnimation("Width")
	obj.GrowIn.Grow:SetEasing("out-quintic")
	obj.GrowIn.Grow:SetDuration(growDuration * module.db.animationsMult)
	obj.GrowIn.Grow:SetOrder(3)

	if hold and hold > 0 then
		obj.GrowIn.Hold:SetDuration(
			((hold * holdDuration) * module.db.animationsMult) + ((fadeDuration * 0.3) * module.db.animationsMult)
		)
	else
		obj.GrowIn.Hold:SetDuration(0)
	end

	self:AddAnimation(obj.GrowIn)
end

function module:SetupFadeAnimation(obj, slot)
	local holdDuration, fadeDuration = 0.02, 0.15

	if obj.FadeIn then
		obj.FadeIn.Hold:SetDuration(((slot or self.statsCount) * holdDuration) * module.db.animationsMult)
		obj.FadeIn.Fade:SetDuration(fadeDuration * module.db.animationsMult)
		self:AddAnimation(obj.FadeIn, true, slot)
		return
	end

	obj.FadeIn = F.Animation.CreateAnimationGroup(obj)

	obj.FadeIn.ResetFade = obj.FadeIn:CreateAnimation("Fade")
	obj.FadeIn.ResetFade:SetDuration(0)
	obj.FadeIn.ResetFade:SetChange(0)
	obj.FadeIn.ResetFade:SetOrder(1)

	obj.FadeIn.Hold = obj.FadeIn:CreateAnimation("Sleep")
	obj.FadeIn.Hold:SetDuration(((slot or self.statsCount) * holdDuration) * module.db.animationsMult)
	obj.FadeIn.Hold:SetOrder(2)

	obj.FadeIn.Fade = obj.FadeIn:CreateAnimation("Fade")
	obj.FadeIn.Fade:SetDuration(fadeDuration * module.db.animationsMult)
	obj.FadeIn.Fade:SetEasing("out-quintic")
	obj.FadeIn.Fade:SetChange(1)
	obj.FadeIn.Fade:SetOrder(3)

	self:AddAnimation(obj.FadeIn, true, slot)
end

function module:UpdateItemLevel()
	module.db = E.db.mui.armory

	if not module.db or not module.frame:IsShown() then
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
	self.nameText:Point("TOP", self.frameModel, module.db.nameText.offsetX, 59 + module.db.nameText.offsetY)
	self.nameText:SetJustifyH("CENTER")
	self.nameText:SetJustifyV("BOTTOM")

	self.classSymbol:ClearAllPoints()
	self.classSymbol:SetSize(16, 16)
	self.classSymbol:Point("RIGHT", self.nameText, "LEFT", -5, 0)

	self.titleText:ClearAllPoints()
	self.titleText:Point("LEFT", self.nameText, "RIGHT", module.db.titleText.offsetX, module.db.titleText.offsetY)
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
	self.specIcon:Point("TOP", module.frameModel, centerOffset, 30)
	self.specIcon:SetJustifyH("CENTER")
	self.specIcon:SetJustifyV("BOTTOM")

	self.levelText:ClearAllPoints()
	self.levelText:Point(
		"RIGHT",
		self.specIcon,
		"LEFT",
		(-iconPadding + module.db.levelText.offsetX),
		module.db.levelText.offsetY
	)
	self.levelText:SetJustifyH("LEFT")
	self.levelText:SetJustifyV("BOTTOM")

	self.levelTitleText:ClearAllPoints()
	self.levelTitleText:Point(
		"RIGHT",
		self.levelText,
		"LEFT",
		(-textPadding + module.db.levelTitleText.offsetX),
		module.db.levelTitleText.offsetY
	)
	self.levelTitleText:SetJustifyH("LEFT")
	self.levelTitleText:SetJustifyV("BOTTOM")

	self.classText:ClearAllPoints()
	self.classText:Point(
		"LEFT",
		self.specIcon,
		"RIGHT",
		(iconPadding + module.db.classText.offsetX),
		module.db.classText.offsetY
	)
	self.classText:SetJustifyH("RIGHT")
	self.classText:SetJustifyV("BOTTOM")
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

function module:UpdatePageStrings(_, slotId, _, slotItem, slotInfo, which)
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
	if self.db.pageInfo.enchantTextEnabled and slotInfo.itemLevelColors and next(slotInfo.itemLevelColors) then
		if self.db.pageInfo.missingSocketText and slotOptions.needsSocket then
			if not slotOptions.warningCondition or module:CheckMessageCondition(slotOptions) then
				local missingGemSlots = 2 - #slotInfo.gems
				if missingGemSlots > 0 then
					local text = format(L["Add %d sockets"], missingGemSlots)
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
				if self.db.pageInfo.abbreviateEnchantText then
					text = module:EnchantAbbreviate(slotInfo.enchantText)
				end

				if self.db.pageInfo.useEnchantClassColor then
					slotItem.enchantText:SetText(F.String.Class(text))
				else
					slotItem.enchantText:SetText(text)
				end
			end
		elseif self.db.pageInfo.missingEnchantText and slotOptions.needsEnchant and not E.TimerunningID then
			if not slotOptions.warningCondition or module:CheckMessageCondition(slotOptions) then
				slotItem.enchantText:SetText(F.String.Error(L["Add enchant"]))
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
			slotItem.MERGradient:OffsetFrameLevel(-1, module.frameModel)

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

		-- Setup Animations
		self:SetupGrowAnimation(slotItem.MERGradient)

		-- Update Size
		slotItem.MERGradient:SetSize(
			self.db.pageInfo.itemQualityGradientWidth,
			self.db.pageInfo.itemQualityGradientHeight
		)

		-- Update Size
		slotItem.MERGradient.GrowIn.Grow:SetChange(E:Scale(self.db.pageInfo.itemQualityGradientWidth))
		slotItem.MERGradient:SetSize(
			self.db.pageInfo.itemQualityGradientWidth,
			self.db.pageInfo.itemQualityGradientHeight
		)

		-- Update Colors
		if slotOptions.direction == module.enumDirection.LEFT then
			F.Color.SetGradientRGB(
				slotItem.MERGradient.Texture,
				"HORIZONTAL",
				r,
				g,
				b,
				self.db.pageInfo.itemQualityGradientStartAlpha,
				r,
				g,
				b,
				self.db.pageInfo.itemQualityGradientEndAlpha
			)
		elseif slotOptions.direction == module.enumDirection.RIGHT then
			F.Color.SetGradientRGB(
				slotItem.MERGradient.Texture,
				"HORIZONTAL",
				r,
				g,
				b,
				self.db.pageInfo.itemQualityGradientEndAlpha,
				r,
				g,
				b,
				self.db.pageInfo.itemQualityGradientStartAlpha
			)
		end

		if self.db.pageInfo.itemQualityGradientEnabled then
			slotItem.MERGradient:Show()
		else
			slotItem.MERGradient:Hide()
		end
	end

	-- iLvL Text Handling
	if not self.db.pageInfo.itemLevelTextEnabled then
		slotItem.iLvlText:SetText("")
	end

	-- Icons Handling
	if not self.db.pageInfo.itemLevelTextEnabled or not self.db.pageInfo.iconsEnabled then
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

function module:UpdateCategoryHeader(frame, animationSlot)
	if frame.StripTextures then
		frame:StripTextures()
	end
	if frame.backdrop then
		frame.backdrop:Kill()
	end
	if frame.Background then
		frame.Background:Kill()
	end

	local currentClass = E.myclass
	local classColorNormal = E.db.mui.themes.classColorMap[I.Enum.GradientMode.Color.NORMAL][currentClass]
	local classColorShift = E.db.mui.themes.classColorMap[I.Enum.GradientMode.Color.SHIFT][currentClass]

	-- Set custom font
	F.SetFontDB(frame.Title, module.db.stats.headerFont)

	local categoryHeader = F.String.StripColor(frame.Title:GetText())

	-- Set color gradient
	if module.db.stats.headerFont.headerFontColor == "GRADIENT" then
		frame.Title:SetText(F.String.FastGradient(categoryHeader, 0, 0.9, 1, 0, 0.6, 1))
	elseif module.db.stats.headerFont.headerFontColor == "CLASS" then
		frame.Title:SetText(F.String.GradientClass(categoryHeader))
	else
		frame.Title:SetText(categoryHeader)
		F.SetFontColorDB(frame.Title, module.db.stats.headerFont.color)
	end

	-- Create left divider
	local leftDivider = frame.Title.MERLeftDivider or frame:CreateTexture(nil, "ARTWORK")
	leftDivider:SetHeight(2)
	leftDivider:SetTexture(E.media.blankTex)
	leftDivider:SetVertexColor(1, 1, 1, 1)

	if module.db.stats.headerFont.headerFontColor == "GRADIENT" then
		F.Color.SetGradientRGB(leftDivider, "HORIZONTAL", 0, 0.6, 1, 0, 0, 0.9, 1, 1)
	elseif module.db.stats.headerFont.headerFontColor == "CLASS" then
		F.Color.SetGradientRGB(
			leftDivider,
			"HORIZONTAL",
			classColorNormal.r,
			classColorNormal.g,
			classColorNormal.b,
			0,
			classColorShift.r,
			classColorShift.g,
			classColorShift.b,
			1
		)
	else
		local fontColor = F.GetFontColorFromDB(self.db.stats, "header")
		F.Color.SetGradientRGB(
			leftDivider,
			"HORIZONTAL",
			fontColor.r,
			fontColor.g,
			fontColor.b,
			0,
			fontColor.r,
			fontColor.g,
			fontColor.b,
			fontColor.a
		)
	end

	-- Create right divider
	local rightDivider = frame.Title.MERRightDivider or frame:CreateTexture(nil, "ARTWORK")
	rightDivider:SetHeight(2)
	rightDivider:SetTexture(E.media.blankTex)
	rightDivider:SetVertexColor(1, 1, 1, 1)
	F.Color.SetGradientRGB(rightDivider, "HORIZONTAL", 0, 0.9, 1, 1, 0, 0.6, 1, 0)
	if module.db.stats.headerFont.headerFontColor == "GRADIENT" then
		F.Color.SetGradientRGB(rightDivider, "HORIZONTAL", 0, 0.9, 1, 1, 0, 0.6, 1, 0)
	elseif module.db.stats.headerFont.headerFontColor == "CLASS" then
		F.Color.SetGradientRGB(
			rightDivider,
			"HORIZONTAL",
			classColorShift.r,
			classColorShift.g,
			classColorShift.b,
			1,
			classColorNormal.r,
			classColorNormal.g,
			classColorNormal.b,
			0
		)
	else
		local fontColor = F.GetFontColorFromDB(self.db.stats, "header")
		F.Color.SetGradientRGB(
			rightDivider,
			"HORIZONTAL",
			fontColor.r,
			fontColor.g,
			fontColor.b,
			fontColor.a,
			fontColor.r,
			fontColor.g,
			fontColor.b,
			0
		)
	end

	-- Setup Animations
	self:SetupGrowAnimation(leftDivider, animationSlot)
	self:SetupGrowAnimation(rightDivider, animationSlot)

	-- Anchor to calculate size
	leftDivider:ClearAllPoints()
	leftDivider:SetPoint("LEFT", frame, "LEFT", 3, 0)
	leftDivider:SetPoint("RIGHT", frame.Title, "LEFT", -3, 0)
	rightDivider:ClearAllPoints()
	rightDivider:SetPoint("RIGHT", frame, "RIGHT", -3, 0)
	rightDivider:SetPoint("LEFT", frame.Title, "RIGHT", 3, 0)

	-- Vars
	local leftDividerWidth = leftDivider:GetWidth()
	local rightDividerWidth = leftDivider:GetWidth()

	-- Update Animations
	leftDivider.GrowIn.Grow:SetChange(leftDividerWidth)
	rightDivider.GrowIn.Grow:SetChange(rightDividerWidth)

	-- Set Final Anchor
	leftDivider:ClearAllPoints()
	leftDivider:SetPoint("RIGHT", frame.Title, "LEFT", -3, 0)

	rightDivider:ClearAllPoints()
	rightDivider:SetPoint("LEFT", frame.Title, "RIGHT", 3, 0)

	-- Set refs
	frame.Title.MERLeftDivider = leftDivider
	frame.Title.MERRightDivider = rightDivider
end

function module:CleanupCharacterStat(frame)
	-- Kill Blizzard and ElvUI Stuff
	if frame.Background then
		frame.Background:Kill()
	end
	if frame.leftGrad then
		frame.leftGrad:Kill()
	end
	if frame.rightGrad then
		frame.rightGrad:Kill()
	end
end

function module:UpdateCharacterStat(frame, showGradient)
	module:CleanupCharacterStat(frame)

	-- Set custom font gradient for label
	if frame.Label then
		F.SetFontDB(frame.Label, module.db.stats.labelFont)

		local labelString = F.String.StripColor(frame.Label:GetText())

		if module.db.stats.labelFont.abbreviateLabels then
			labelString = E:ShortenString(E.TagFunctions.Abbrev(labelString), 12)
		end

		if module.db.stats.labelFont.labelFontColor == "GRADIENT" then
			frame.Label:SetText(F.String.FastGradient(labelString, 0, 0.6, 1, 0, 0.9, 1))
		elseif module.db.stats.labelFont.labelFontColor == "CLASS" then
			frame.Label:SetText(F.String.GradientClass(labelString, nil, true))
		else
			frame.Label:SetText(labelString)
			F.SetFontColorDB(frame.Label, module.db.stats.labelFont.color)
		end
	end

	local currentClass = E.myclass
	local classColorNormal = E.db.mui.themes.classColorMap[I.Enum.GradientMode.Color.NORMAL][currentClass]
	local classColorShift = E.db.mui.themes.classColorMap[I.Enum.GradientMode.Color.SHIFT][currentClass]

	-- Set custom for value
	if frame.Value then
		F.SetFontDB(frame.Value, module.db.stats.valueFont)
	end

	-- Set custom background gradient
	if frame.MERGradient then
		frame.MERGradient:Hide()
	end
	if showGradient and module.db.stats.alternatingBackgroundEnabled then
		frame.MERGradient = frame.MERGradient or frame:CreateTexture(nil, "ARTWORK")
		frame.MERGradient:SetPoint("LEFT", frame, "CENTER")
		frame.MERGradient:SetSize(90, frame:GetHeight())
		frame.MERGradient:SetTexture(E.media.blankTex)

		if module.db.stats.labelFont.labelFontColor == "GRADIENT" then
			F.Color.SetGradientRGB(
				frame.MERGradient,
				"HORIZONTAL",
				0,
				0.6,
				1,
				0,
				0,
				0.9,
				1,
				module.db.stats.alternatingBackgroundAlpha
			)
		elseif module.db.stats.labelFont.labelFontColor == "CLASS" then
			F.Color.SetGradientRGB(
				frame.MERGradient,
				"HORIZONTAL",
				classColorNormal.r,
				classColorNormal.g,
				classColorNormal.b,
				0,
				classColorShift.r,
				classColorShift.g,
				classColorShift.b,
				module.db.stats.alternatingBackgroundAlpha
			)
		else
			local fontColor = F.GetFontColorFromDB(self.db.stats, "label")
			F.Color.SetGradientRGB(
				frame.MERGradient,
				"HORIZONTAL",
				fontColor.r,
				fontColor.g,
				fontColor.b,
				0,
				fontColor.r,
				fontColor.g,
				fontColor.b,
				module.db.stats.alternatingBackgroundAlpha
			)
		end

		frame.MERGradient:Show()
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

	local spec = GetSpecialization()
	local level = UnitLevel("player")
	local categoryYOffset = 0
	local statYOffset = 0
	local lastAnchor, role

	module:ClearAnimations(true)

	if spec then
		role = GetSpecializationRole(spec)
	end

	if level >= (MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY or 0) then
		module:CleanupCharacterStat(characterStatsPane.ItemLevelFrame)

		local animationSlot = module:GetAnimationSlot(true)
		module:SetupFadeAnimation(characterStatsPane.ItemLevelFrame)
		module:SetupFadeAnimation(characterStatsPane.ItemLevelCategory, animationSlot)
		module:UpdateCategoryHeader(characterStatsPane.ItemLevelCategory, animationSlot)

		characterStatsPane.ItemLevelCategory:Show()
		characterStatsPane.ItemLevelFrame:Show()
		characterStatsPane.AttributesCategory:ClearAllPoints()
		characterStatsPane.AttributesCategory:Point("TOP", characterStatsPane.ItemLevelFrame, "BOTTOM", 0, 0)
	else
		characterStatsPane.ItemLevelCategory:Hide()
		characterStatsPane.ItemLevelFrame:Hide()
		characterStatsPane.AttributesCategory:ClearAllPoints()
		characterStatsPane.AttributesCategory:Point("TOP", characterStatsPane, "TOP", 0, -2)
		categoryYOffset = -11
		statYOffset = -5
	end

	characterStatsPane.statsFramePool:ReleaseAll()
	local statFrame = characterStatsPane.statsFramePool:Acquire()
	local categories = _G.PAPERDOLL_STATCATEGORIES

	for catIndex = 1, #categories do
		local catFrame = characterStatsPane[categories[catIndex].categoryFrame]
		local animationSlot = module:GetAnimationSlot(true)
		local numStatInCat = 0
		for statIndex = 1, #categories[catIndex].stats do
			local stat = categories[catIndex].stats[statIndex]
			local hideAt = stat.hideAt
			local showStat = true
			local statMode = 1

			-- Append ID string to stat frame
			statFrame.stringId = stat.stat

			if module.db.stats.mode[stat.stat] ~= nil then
				statMode = module.db.stats.mode[stat.stat].mode
			else
				showStat = false
			end

			-- Mode 0 - Always Hide
			if showStat and (statMode == 0) then
				showStat = false
			end

			-- Mode 1 - Smart
			if showStat and (statMode == 1) then
				if showStat and (stat.primary and spec) then
					local primaryStat

					primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")))
					if stat.primary ~= primaryStat then
						showStat = false
					end
				end

				if showStat and (stat.primaries and spec) then
					local primaryStat

					primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")))

					local foundPrimary = false
					for _, primary in pairs(stat.primaries) do
						if primaryStat == primary then
							foundPrimary = true
							break
						end
					end

					showStat = foundPrimary
				end

				if showStat and stat.roles then
					local foundRole = false

					for _, statRole in pairs(stat.roles) do
						if role == statRole then
							foundRole = true
							break
						end
					end

					showStat = foundRole
				end

				if showStat and stat.classes then
					local foundClass = false

					for _, statClass in pairs(stat.classes) do
						if E.myclass == statClass then
							foundClass = true
							break
						end
					end

					showStat = foundClass
				end

				if showStat and stat.showFunc then
					showStat = stat.showFunc()
				end
			end

			-- Mode 2 - Always Show if not empty
			if showStat and (statMode == 2) and (hideAt == nil) then
				hideAt = 0
			end

			-- Mode 3 - Always Show
			-- This is not needed here, just added here to make the logic more clearer
			if showStat and (statMode == 3) then
				showStat = true
			end

			if showStat then
				statFrame.onEnterFunc = nil
				statFrame.UpdateTooltip = nil

				_G.PAPERDOLL_STATINFO[stat.stat].updateFunc(statFrame, "player")

				-- Mode 1/2 - Validate hideAt value in Smart Mode/Always Show if not empty mode
				if (hideAt ~= nil) and ((statMode == 1) or (statMode == 2)) then
					showStat = (stat.hideAt ~= statFrame.numericValue)
				end

				if showStat then
					if numStatInCat == 0 then
						if lastAnchor then
							catFrame:SetPoint("TOP", lastAnchor, "BOTTOM", 0, categoryYOffset)
						end

						statFrame:SetPoint("TOP", catFrame, "BOTTOM", 0, -2)
					else
						statFrame:SetPoint("TOP", lastAnchor, "BOTTOM", 0, statYOffset)
					end

					numStatInCat = numStatInCat + 1
					module:UpdateCharacterStat(statFrame, (numStatInCat % 2) == 0)
					module:SetupFadeAnimation(statFrame)

					lastAnchor = statFrame
					statFrame = characterStatsPane.statsFramePool:Acquire()
				end
			end
		end

		if numStatInCat > 0 then
			catFrame:Show()
			module:SetupFadeAnimation(catFrame, animationSlot)
			module:UpdateCategoryHeader(catFrame, animationSlot)
		else
			catFrame:Hide()
		end
	end

	characterStatsPane.statsFramePool:Release(statFrame)
end

function module:UpdateAttackSpeed(statFrame, unit)
	local meleeHaste = GetMeleeHaste()
	local speed, offhandSpeed = UnitAttackSpeed(unit)

	local displaySpeed = format("%.2f", speed)
	if offhandSpeed then
		offhandSpeed = format("%.2f", offhandSpeed)
	end
	if offhandSpeed then
		displaySpeed = BreakUpLargeNumbers(displaySpeed) .. " / " .. offhandSpeed
	else
		displaySpeed = BreakUpLargeNumbers(displaySpeed)
	end

	_G.PaperDollFrame_SetLabelAndText(statFrame, _G.WEAPON_SPEED, displaySpeed, false, speed)

	statFrame.tooltip = _G.HIGHLIGHT_FONT_COLOR_CODE
		.. format(_G.PAPERDOLLFRAME_TOOLTIP_FORMAT, _G.ATTACK_SPEED)
		.. " "
		.. displaySpeed
		.. _G.FONT_COLOR_CODE_CLOSE
	statFrame.tooltip2 = format(_G.STAT_ATTACK_SPEED_BASE_TOOLTIP, BreakUpLargeNumbers(meleeHaste))

	statFrame:Show()
end

function module:ApplyCustomStatCategories()
	_G.PAPERDOLL_STATCATEGORIES = {
		[1] = {
			categoryFrame = "AttributesCategory",
			stats = {
				[1] = {
					stat = "STRENGTH",
					primary = LE_UNIT_STAT_STRENGTH,
				},
				[2] = {
					stat = "AGILITY",
					primary = LE_UNIT_STAT_AGILITY,
				},
				[3] = {
					stat = "INTELLECT",
					primary = LE_UNIT_STAT_INTELLECT,
				},
				[4] = {
					stat = "STAMINA",
				},
				[5] = {
					stat = "HEALTH",
					roles = { "TANK" },
				}, -- Added
				[6] = {
					stat = "POWER",
					roles = { "HEALER" },
				}, -- Added
				[7] = {
					stat = "ARMOR",
					roles = { "TANK" },
				}, -- Modified Smart
				[8] = {
					stat = "STAGGER",
					hideAt = 0,
					roles = { "TANK" },
					classes = { "MONK" },
				}, -- Modified Smart
				[9] = {
					stat = "MANAREGEN",
					roles = { "HEALER" },
				},
				[10] = {
					stat = "ENERGY_REGEN",
					hideAt = 0,
					roles = { "TANK", "DAMAGER" },
					classes = { "ROGUE", "DRUID", "MONK" },
				}, -- Added
				[11] = {
					stat = "RUNE_REGEN",
					hideAt = 0,
					classes = { "DEATHKNIGHT" },
				}, -- Added
				[12] = {
					stat = "FOCUS_REGEN",
					hideAt = 0,
					classes = { "HUNTER" },
				}, -- Added
				[13] = {
					stat = "MOVESPEED",
					hideAt = 0,
				}, -- Added
			},
		},
		[2] = {
			categoryFrame = "EnhancementsCategory",
			stats = {
				{
					stat = "ATTACK_DAMAGE",
					hideAt = 0,
					primaries = { LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY },
					roles = { "DAMAGER" },
				}, -- Added
				{
					stat = "ATTACK_AP",
					hideAt = 0,
					primaries = { LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY },
					roles = { "DAMAGER" },
				}, -- Added
				{
					stat = "ATTACK_ATTACKSPEED",
					hideAt = 0,
					primaries = { LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY },
					roles = { "DAMAGER" },
				}, -- Added
				{
					stat = "SPELLPOWER",
					hideAt = 0,
					primary = LE_UNIT_STAT_INTELLECT,
					roles = { "HEALER", "DAMAGER" },
				}, -- Added
				{
					stat = "CRITCHANCE",
					hideAt = 0,
				}, -- 1
				{
					stat = "HASTE",
					hideAt = 0,
				}, -- 2
				{
					stat = "MASTERY",
					hideAt = 0,
				}, -- 3
				{
					stat = "VERSATILITY",
					hideAt = 0,
				}, -- 4
				{
					stat = "LIFESTEAL",
					hideAt = 0,
				}, -- 5
				{
					stat = "AVOIDANCE",
					hideAt = 0,
				}, -- 6
				{
					stat = "SPEED",
					hideAt = 0,
				}, -- 7
				{
					stat = "DODGE",
					roles = { "TANK" },
				}, -- 8
				{
					stat = "PARRY",
					hideAt = 0,
					roles = { "TANK" },
				}, -- 9
				{
					stat = "BLOCK",
					hideAt = 0,
					showFunc = C_PaperDollInfo.OffhandHasShield,
				}, -- 10
			},
		},
	}
end

local isHooked = false
function module:UpdateBackground()
	if module.db.background.enable then
		if module.db.background.hideControls then
			local controlFrame = _G.CharacterModelScene and _G.CharacterModelScene.ControlFrame
			if controlFrame and not isHooked then
				controlFrame:SetScript("OnShow", function(frame)
					frame:Hide()
				end)
				isHooked = true
			end
		end

		if self.db.background.class then
			self.frame.MERBackground.Texture:SetTexture(I.Media.Armory["MERATHILISUI-" .. E.myclass])
		else
			self.frame.MERBackground.Texture:SetTexture(I.Media.Armory["BG" .. self.db.background.style])
		end
		self.frame.MERBackground.Texture:SetVertexColor(1, 1, 1, self.db.background.alpha)
	else
		self.frame.MERBackground.Texture:SetTexture(nil)
		self.frame.MERBackground.Texture:SetVertexColor(0, 0, 0, 0)
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
	module:UpdateCharacterArmory()
	E:Delay(0.01, function()
		module:PlayAnimations()
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

	module.animationObjects = {}
	module.statsObjects = {}
	module.statsCount = 1

	local background = CreateFrame("Frame", nil, self.frameHolder)
	local nameText = module.frameHolder:CreateFontString(nil, "OVERLAY")
	local classSymbol = module.frameHolder:CreateTexture()
	local titleText = module.frameHolder:CreateFontString(nil, "OVERLAY")
	local levelTitleText = module.frameHolder:CreateFontString(nil, "OVERLAY")
	local levelText = module.frameHolder:CreateFontString(nil, "OVERLAY")
	local specIcon = module.frameHolder:CreateFontString(nil, "OVERLAY")
	local classText = module.frameHolder:CreateFontString(nil, "OVERLAY")
	local waterMark = module.frameHolder:CreateTexture(nil, "BACKGROUND")

	local frameHeight, frameWidth = module.frame:GetSize()
	local cutOffPercentage = (1 - (frameHeight / frameWidth))

	background:SetInside(module.frame)
	background:OffsetFrameLevel(-1, module.frameModel)
	background.Texture = background:CreateTexture(nil, "BACKGROUND")
	background.Texture:SetInside()
	background.Texture:SetTexCoord(0, 1, cutOffPercentage, 1)

	module.frame.MERBackground = background

	waterMark:SetPoint("BOTTOMRIGHT", module.frame, "BOTTOMRIGHT", 0, 0)
	waterMark:Size(72)
	waterMark:SetTexture(I.Media.Logos.Logo)
	waterMark:SetAlpha(0.35)

	module.waterMark = waterMark

	local lineHeight = 1
	local topLine = CreateFrame("Frame", nil, module.frameHolder)
	local bottomLine = CreateFrame("Frame", nil, module.frameHolder)

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

function module:ElvOptionsCheck()
	if not E.db.general.itemLevel.displayCharacterInfo then
		E.db.general.itemLevel.displayCharacterInfo = true
		M:ToggleItemLevelInfo(false)
		self:UpdateItemLevel()
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

function module:Disable()
	if not self.Initialized then
		return
	end
	if not self:IsHooked(_G, "PaperDollFrame_UpdateStats") then
		return
	end

	self:CancelAllTimers()
	self:UnhookAll()

	F.Event.UnregisterFrameEventAndCallback("UNIT_NAME_UPDATE", self)
	F.Event.UnregisterFrameEventAndCallback("PLAYER_PVP_RANK_CHANGED", self)
	F.Event.UnregisterFrameEventAndCallback("PLAYER_AVG_ITEM_LEVEL_UPDATE", self)
	F.Event.UnregisterFrameEventAndCallback("PLAYER_TALENT_UPDATE", self)
end

function module:Enable()
	if not self.Initialized then
		return
	end
	if self:IsHooked(_G, "PaperDollFrame_UpdateStats") then
		return
	end

	self:CreateElements()

	-- Hook ElvUI Overrides
	local m = E:GetModule("Misc")
	self:SecureHook(m, "UpdateCharacterInfo", F.Event.GenerateClosure(self.UpdateItemLevel, self))
	self:SecureHook(m, "UpdateAverageString", F.Event.GenerateClosure(self.UpdateItemLevel, self))
	self:SecureHook(m, "UpdatePageStrings", F.Event.GenerateClosure(self.UpdatePageStrings, self))
	self:SecureHook(m, "CreateSlotStrings", F.Event.GenerateClosure(self.UpdatePageInfo, self))
	self:SecureHook(m, "ToggleItemLevelInfo", F.Event.GenerateClosure(self.ElvOptionsCheck, self))
	self:SecureHook(_G, "PaperDollFrame_UpdateStats", F.Event.GenerateClosure(self.UpdateCharacterStats, self))

	-- Register Events
	F.Event.RegisterFrameEventAndCallback("UNIT_NAME_UPDATE", self.HandleEvent, self, "UNIT_NAME_UPDATE")
	F.Event.RegisterFrameEventAndCallback("PLAYER_PVP_RANK_CHANGED", self.HandleEvent, self, "PLAYER_PVP_RANK_CHANGED")
	F.Event.RegisterFrameEventAndCallback(
		"PLAYER_AVG_ITEM_LEVEL_UPDATE",
		self.HandleEvent,
		self,
		"PLAYER_AVG_ITEM_LEVEL_UPDATE"
	)
	F.Event.RegisterFrameEventAndCallback("PLAYER_TALENT_UPDATE", self.HandleEvent, self, "PLAYER_TALENT_UPDATE")

	-- Hook Blizzard OnShow
	self:SecureHookScript(self.frame, "OnShow", "OpenCharacterArmory")

	-- Hook broken blizzard function
	self:RawHook(_G, "PaperDollFrame_SetAttackSpeed", "UpdateAttackSpeed", true)

	-- Apply our custom stat categories
	self:ApplyCustomStatCategories()

	-- Check ElvUI Options
	self:ElvOptionsCheck()

	-- Update instantly if frame is currently open
	if self.frame:IsShown() then
		self:UpdateCharacterArmory()
	end
end

function module:DatabaseUpdate()
	-- Set db
	self.db = F.GetDBFromPath("mui.armory")

	-- Enable/Disable only out of combat
	F.Event.ContinueOutOfCombat(function()
		-- Disable
		self:Disable()

		-- Enable
		if self.db and self.db.enable then
			self:Enable()
		end
	end)
end

function module:Initialize()
	if self.Initialized then
		return
	end

	F.Event.RegisterOnceCallback("MER.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
	F.Event.RegisterCallback("MER.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("Armory.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("Armory.SettingsUpdate", self.UpdateCharacterArmory, self)

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
