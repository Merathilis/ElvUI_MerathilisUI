local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Armory") ---@class Armory
local M = E:GetModule("Misc")
local S = E:GetModule("Skins")
local LSM = E.Libs.LSM

local _G = _G
local format, gsub, utf8sub = string.format, string.gsub, string.utf8sub
local next, ipairs, pairs, pcall, select, max, min, unpack = next, ipairs, pairs, pcall, select, max, min, unpack
local abs = math.abs
local twipe, tsort = table.wipe, table.sort

local CreateColor = CreateColor
local CreateFrame = CreateFrame
local ClampedPercentageBetween = ClampedPercentageBetween
local GetCursorPosition = GetCursorPosition
local GetTime = GetTime
local Lerp = Lerp
local PlaySound = PlaySound
local GetInventoryItemID = GetInventoryItemID
local GetInventoryItemLink = GetInventoryItemLink
local InCombatLockdown = InCombatLockdown
local GetSpecializationRole = GetSpecializationRole
local GetCurrentTitle = GetCurrentTitle
local GetTitleName = GetTitleName
local GetNumTitles = GetNumTitles
local IsTitleKnown = IsTitleKnown
local UnitLevel = UnitLevel
local UnitSex = UnitSex
local GetAverageItemLevel = GetAverageItemLevel
local GetMeleeHaste = GetMeleeHaste
local UnitAttackSpeed = UnitAttackSpeed
local UnitEffectiveLevel = UnitEffectiveLevel
local BreakUpLargeNumbers = BreakUpLargeNumbers
local GetAchievementInfo = GetAchievementInfo
local CreateAnimationGroup = CreateAnimationGroup -- ElvUI LibAnim

local C_SpecializationInfo_GetSpecialization = C_SpecializationInfo.GetSpecialization
local C_SpecializationInfo_GetSpecializationInfo = C_SpecializationInfo.GetSpecializationInfo
local GetItemInfo = C_Item.GetItemInfo
local GetItemGem = C_Item.GetItemGem
local GetItemStats = C_Item.GetItemStats
local GetItemUpgradeInfo = C_Item.GetItemUpgradeInfo
local GetMinItemLevel = C_PaperDollInfo.GetMinItemLevel
local OffhandHasShield = C_PaperDollInfo.OffhandHasShield
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE
local LOCALIZED_CLASS_NAMES_FEMALE = LOCALIZED_CLASS_NAMES_FEMALE
local EFFECTIVE_LEVEL_FORMAT = EFFECTIVE_LEVEL_FORMAT
local MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY = MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY
local LE_UNIT_STAT_STRENGTH = LE_UNIT_STAT_STRENGTH
local LE_UNIT_STAT_AGILITY = LE_UNIT_STAT_AGILITY
local LE_UNIT_STAT_INTELLECT = LE_UNIT_STAT_INTELLECT
local ENUM_ITEM_CLASS_WEAPON = Enum.ItemClass.Weapon

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
		needsSocket = true,
		direction = module.enumDirection.LEFT,
	},
	["NeckSlot"] = {
		id = 2,
		needsEnchant = false,
		needsSocket = false,
		warningCondition = {
			level = I.MaxLevelTable[MER.MetaFlavor],
		},
		direction = module.enumDirection.LEFT,
	},
	["ShoulderSlot"] = {
		id = 3,
		needsEnchant = true,
		needsSocket = false,
		direction = module.enumDirection.LEFT,
	},
	["BackSlot"] = {
		id = 15,
		needsEnchant = false,
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
		needsEnchant = false,
		warningCondition = {
			level = I.MaxLevelTable[MER.MetaFlavor],
		},
		needsSocket = true,
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
		needsSocket = true,
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

function module:GetPrimaryTalentIndex()
	local primaryTalentTreeIdx = 0
	local primaryTalentTree = C_SpecializationInfo_GetSpecialization()

	if primaryTalentTree then
		primaryTalentTreeIdx = C_SpecializationInfo_GetSpecializationInfo(primaryTalentTree) or 0
	end

	return primaryTalentTreeIdx
end

module.slotIdToName = {}
for slot, options in pairs(module.characterSlots) do
	module.slotIdToName[options.id] = slot
end

function module:GetSlotNameByID(slotId)
	return module.slotIdToName[slotId]
end

function module:CheckMessageCondition(slotOptions)
	local conditions = slotOptions.warningCondition
	local enchantNeeded = true

	-- Level Condition
	if enchantNeeded and conditions.level then
		enchantNeeded = (conditions.level == UnitLevel("player"))
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

function module:PlayAnimation(anim)
	if not anim then
		return
	end

	if anim:IsPlaying() then
		anim:Stop()
	end
	if self:AnimationsAllowed() then
		anim:Play()
	end
end

function module:PlayAnimations()
	for anim, _ in pairs(self.statsObjects) do
		self:PlayAnimation(anim)
	end

	for anim, _ in pairs(self.animationObjects) do
		self:PlayAnimation(anim)
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

	obj.GrowIn = CreateAnimationGroup(obj)

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

	obj.FadeIn = CreateAnimationGroup(obj)

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

---Same look for the flyouts around the character frame (gem flyout, Blizzard's item
---swap flyout): ElvUI's transparent template, a line in the class gradient on top like
---the stats headers and a short fade-in when it opens (FadeInFlyout)
---@param frame Frame
function module:StyleFlyout(frame)
	if not frame.template then
		frame:SetTemplate("Transparent")
	end

	local accent = frame.MERFlyoutAccent
	if not accent then
		accent = frame:CreateTexture(nil, "OVERLAY")
		accent:SetTexture(E.media.blankTex)
		accent:SetHeight(2)
		accent:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
		accent:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
		frame.MERFlyoutAccent = accent
		module.styledFlyouts[frame] = true
	end

	local classColorMap = E.db.mui.themes.gradientMode.classColorMap
	local normal = classColorMap[I.Enum.GradientMode.Color.NORMAL][E.myclass]
	local shift = classColorMap[I.Enum.GradientMode.Color.SHIFT][E.myclass]
	accent:SetVertexColor(1, 1, 1, 1)
	F.Color.SetGradientRGB(accent, "HORIZONTAL", shift.r, shift.g, shift.b, 1, normal.r, normal.g, normal.b, 1)
	accent:Show()
end

---@param frame Frame a frame styled with StyleFlyout
function module:FadeInFlyout(frame)
	local fade = frame.MERFlyoutFade
	if not fade then
		fade = CreateAnimationGroup(frame)

		fade.ResetFade = fade:CreateAnimation("Fade")
		fade.ResetFade:SetDuration(0)
		fade.ResetFade:SetChange(0)
		fade.ResetFade:SetOrder(1)

		fade.Fade = fade:CreateAnimation("Fade")
		fade.Fade:SetEasing("inout-sinusoidal")
		fade.Fade:SetChange(1)
		fade.Fade:SetOrder(2)

		frame.MERFlyoutFade = fade
	end

	if fade:IsPlaying() then
		fade:Stop()
	end

	if self:AnimationsAllowed() then
		fade.Fade:SetDuration(0.06 * module.db.animationsMult)
		fade:Play()
	else
		-- A fade stopped halfway on the last open keeps its alpha
		frame:SetAlpha(1)
	end
end

---Removes the accent line from the flyouts again, the module is turned off
function module:ResetFlyouts()
	for frame in pairs(module.styledFlyouts) do
		if frame.MERFlyoutFade and frame.MERFlyoutFade:IsPlaying() then
			frame.MERFlyoutFade:Stop()
		end
		frame:SetAlpha(1)
		frame.MERFlyoutAccent:Hide()
	end
end

-- Blizzard's item swap flyout (Alt over a slot). ElvUI gives its button frame the
-- transparent template in its own EquipmentFlyout_UpdateItems hook, which runs first
function module:StyleEquipmentFlyout()
	local flyout = _G.EquipmentFlyoutFrame
	if flyout and flyout.buttonFrame then
		self:StyleFlyout(flyout.buttonFrame)
	end
end

function module:OnEquipmentFlyoutShow(flyout)
	self:FadeInFlyout(flyout)
end

-- Stat rows of the character frame and the key C_Item.GetItemStats uses for them
module.statHighlightKeys = {
	CRITCHANCE = "ITEM_MOD_CRIT_RATING_SHORT",
	HASTE = "ITEM_MOD_HASTE_RATING_SHORT",
	MASTERY = "ITEM_MOD_MASTERY_RATING_SHORT",
	VERSATILITY = "ITEM_MOD_VERSATILITY",
	LIFESTEAL = "ITEM_MOD_CR_LIFESTEAL_SHORT",
	AVOIDANCE = "ITEM_MOD_CR_AVOIDANCE_SHORT",
	SPEED = "ITEM_MOD_CR_SPEED_SHORT",
}

local STAT_HIGHLIGHT_DIM_ALPHA = 0.25
local slotStatCache = {}

-- Adds the stats of an item or gem link to stats, false while its data is not loaded yet
local function AddItemStats(stats, link)
	local itemStats = GetItemStats(link)
	if not itemStats then
		return false
	end

	for key, value in pairs(itemStats) do
		if type(value) == "number" and value > 0 then
			stats[key] = (stats[key] or 0) + value
		end
	end

	return true
end

---Stats of the item in a slot with its gems, kept until the item link changes
---(a new gem changes the link as well)
---@param slotId number
---@return table?
function module:GetSlotStats(slotId)
	local link = GetInventoryItemLink("player", slotId)
	if not link then
		return
	end

	local cached = slotStatCache[slotId]
	if cached and cached.link == link then
		return cached.stats
	end

	local stats = {}
	local complete = AddItemStats(stats, link)
	for socketIndex = 1, 4 do
		local _, gemLink = GetItemGem(link, socketIndex)
		if gemLink and not AddItemStats(stats, gemLink) then
			complete = false
		end
	end

	-- Read again on the next hover until the item and gem data is there
	if complete then
		slotStatCache[slotId] = { link = link, stats = stats }
	end

	return stats
end

---Dims the item slots without the hovered stat
---@param statFrame Frame stat row of the character frame
function module:HighlightStatSlots(statFrame)
	local db = self.db
	local key = statFrame.stringId and module.statHighlightKeys[statFrame.stringId]
	if not (key and db and db.enable and db.stats.highlightSlots) then
		return
	end

	for slot, options in pairs(module.characterSlots) do
		local slotFrame = _G["Character" .. slot]
		if slotFrame then
			local stats = self:GetSlotStats(options.id)
			slotFrame:SetAlpha((stats and stats[key]) and 1 or STAT_HIGHLIGHT_DIM_ALPHA)
		end
	end

	self.statSlotsHighlighted = true
end

function module:ClearStatSlotHighlight()
	if not self.statSlotsHighlighted then
		return
	end
	self.statSlotsHighlighted = nil

	for slot in pairs(module.characterSlots) do
		local slotFrame = _G["Character" .. slot]
		if slotFrame then
			slotFrame:SetAlpha(1)
		end
	end
end

local function StatFrame_OnEnter(frame)
	module:HighlightStatSlots(frame)
end

local function StatFrame_OnLeave()
	module:ClearStatSlotHighlight()
end

---The stat rows come from Blizzard's frame pool, each one is hooked once and
---reads its current stat on hover
---@param statFrame Frame
function module:HookStatHighlight(statFrame)
	if statFrame.MERHighlightHooked then
		return
	end

	statFrame:HookScript("OnEnter", StatFrame_OnEnter)
	statFrame:HookScript("OnLeave", StatFrame_OnLeave)
	statFrame.MERHighlightHooked = true
end

---Writes the average item level into fontString with the font and color of the settings.
---The options preview passes its own font string
---@param fontString FontString
function module:SetItemLevelText(fontString)
	local db = module.db.stats

	WF.SetFontWithDB(fontString, db.itemLevelFont)

	local itemLevelText

	local avgItemLevel, avgItemLevelEquipped = GetAverageItemLevel()
	local minItemLevel = GetMinItemLevel()
	local displayItemLevel = max(minItemLevel or 0, avgItemLevelEquipped)

	if db.showAvgItemLevel then
		itemLevelText =
			format(format("%s / %s", db.itemLevelFormat, db.itemLevelFormat), displayItemLevel, avgItemLevel)
	else
		itemLevelText = format(db.itemLevelFormat, displayItemLevel)
	end

	if db.itemLevelFont.itemLevelFontColor == "GRADIENT" then
		local epicComplete = select(13, GetAchievementInfo(40147))

		if epicComplete then
			fontString:SetText(F.String.FastGradient(itemLevelText, 0.78, 0.13, 0.57, 0.42, 0.08, 0.82))
		else
			local rareComplete = select(13, GetAchievementInfo(40146))

			if rareComplete then
				fontString:SetText(F.String.FastGradient(itemLevelText, 0.01, 0.78, 0.98, 0, 0.38, 0.90))
			else
				fontString:SetText(F.String.FastGradient(itemLevelText, 0.07, 0.90, 0.15, 0, 0.69, 0.11))
			end
		end
	elseif db.itemLevelFont.itemLevelFontColor == "VALUE" then
		fontString:SetText(F.String.ElvUIValue(itemLevelText))
	elseif db.itemLevelFont.itemLevelFontColor == "CUSTOM" then
		fontString:SetText(itemLevelText)
		WF.SetFontColorWithDB(fontString, db.itemLevelFont.color)
	else
		fontString:SetText(itemLevelText)
	end
end

function module:UpdateItemLevel()
	module.db = E.db.mui.armory

	if not module.db or not module.frame:IsShown() then
		return
	end

	module:SetItemLevelText(module.frame.ItemLevelText)
end

---Fills the name, title, level, spec and class texts. target holds those font strings and
---the frameModel they are placed on, the options preview passes its own (defaults to module)
function module:UpdateTitle(target)
	target = target or self

	-- Only re-apply fonts when settings changed (or first run)
	if target._titleFontDirty ~= false then
		target.nameText:SetFont(
			LSM:Fetch("font", module.db.nameText.name),
			module.db.nameText.size,
			module.db.nameText.style
		)
		target.titleText:SetFont(
			LSM:Fetch("font", module.db.titleText.name),
			module.db.titleText.size,
			module.db.titleText.style
		)
		target.levelTitleText:SetFont(
			LSM:Fetch("font", module.db.levelTitleText.name),
			module.db.levelTitleText.size,
			module.db.levelTitleText.style
		)
		target.levelText:SetFont(
			LSM:Fetch("font", module.db.levelText.name),
			module.db.levelText.size,
			module.db.levelText.style
		)
		target.classText:SetFont(
			LSM:Fetch("font", module.db.classText.name),
			module.db.classText.size,
			module.db.classText.style
		)
		target.specIcon:SetFont(
			LSM:Fetch("font", module.db.specIcon.name),
			module.db.specIcon.size,
			module.db.specIcon.style
		)
		target._titleFontDirty = false
	end

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

	local classColorNormal = E.db.mui.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.NORMAL][currentClass]

	if module.db.nameText.fontColor == "GRADIENT" then
		target.nameText:SetText(F.String.FastGradient(E.myname, 0, 0.6, 1, 0, 0.9, 1))
	elseif module.db.nameText.fontColor == "CLASS" then
		target.nameText:SetText(F.String.GradientClass(E.myname))
	else
		target.nameText:SetText(E.myname)
		WF.SetFontColorWithDB(target.nameText, module.db.nameText.color)
	end

	target.classSymbol:SetTexture(MER.ClassIcons[E.myclass])

	if module.db.titleText.fontColor == "GRADIENT" then
		target.titleText:SetText(F.String.FastGradient(titleName, 0, 0.9, 1, 0, 0.6, 1))
	elseif module.db.titleText.fontColor == "CLASS" then
		target.titleText:SetText(F.String.GradientClass(titleName))
	else
		target.titleText:SetText(titleName)
		WF.SetFontColorWithDB(target.titleText, module.db.titleText.color)
	end

	if module.db.levelTitleText.short then
		target.levelTitleText:SetText("Lvl")
	else
		target.levelTitleText:SetText("Level")
	end

	target.levelText:SetText(level)

	local fontIcon = E.db.mui.armory.icons[primaryTalentTreeIdx] or E.db.mui.armory.icons[0]
	if module.db.specIcon.fontColor == "CLASS" then
		target.specIcon:SetText(F.String.RGB(fontIcon, classColorNormal))
	else
		target.specIcon:SetText(fontIcon)
		WF.SetFontColorWithDB(target.specIcon, module.db.specIcon.color)
	end

	if module.db.classText.fontColor == "CLASS" then
		target.classText:SetText(F.String.GradientClass(classNames[currentClass], nil, true))
	else
		target.classText:SetText(classNames[currentClass])
		WF.SetFontColorWithDB(target.classText, module.db.classText.color)
	end

	target.nameText:ClearAllPoints()
	target.nameText:Point("TOP", target.frameModel, module.db.nameText.offsetX, 59 + module.db.nameText.offsetY)
	target.nameText:SetJustifyH("CENTER")
	target.nameText:SetJustifyV("BOTTOM")

	target.classSymbol:ClearAllPoints()
	target.classSymbol:SetSize(16, 16)
	target.classSymbol:Point("RIGHT", target.nameText, "LEFT", -5, 0)

	target.titleText:ClearAllPoints()
	target.titleText:Point("LEFT", target.nameText, "RIGHT", module.db.titleText.offsetX, module.db.titleText.offsetY)
	target.titleText:SetJustifyH("LEFT")
	target.titleText:SetJustifyV("BOTTOM")

	local iconPadding = 10
	local textPadding = 4

	local leftWidth = target.levelText:GetStringWidth() + target.levelTitleText:GetStringWidth() + textPadding
	local rightWidth = target.classText:GetStringWidth()
	local iconWidth = target.specIcon:GetStringWidth() + (iconPadding * 2)
	local totalWidth = leftWidth + rightWidth + iconWidth
	local anchorWidth = totalWidth - (leftWidth + (iconWidth / 2))
	local centerOffset = (totalWidth / 2) - anchorWidth

	target.specIcon:ClearAllPoints()
	target.specIcon:Point("TOP", target.frameModel, centerOffset, 30)
	target.specIcon:SetJustifyH("CENTER")
	target.specIcon:SetJustifyV("BOTTOM")

	target.levelText:ClearAllPoints()
	target.levelText:Point(
		"BOTTOMRIGHT",
		target.specIcon,
		"BOTTOMLEFT",
		(-iconPadding + module.db.levelText.offsetX),
		module.db.levelText.offsetY
	)
	target.levelText:SetJustifyH("LEFT")
	target.levelText:SetJustifyV("BOTTOM")

	target.levelTitleText:ClearAllPoints()
	target.levelTitleText:Point(
		"BOTTOMRIGHT",
		target.levelText,
		"BOTTOMLEFT",
		(-textPadding + module.db.levelTitleText.offsetX),
		module.db.levelTitleText.offsetY
	)
	target.levelTitleText:SetJustifyH("LEFT")
	target.levelTitleText:SetJustifyV("BOTTOM")

	target.classText:ClearAllPoints()
	target.classText:Point(
		"BOTTOMLEFT",
		target.specIcon,
		"BOTTOMRIGHT",
		(iconPadding + module.db.classText.offsetX),
		module.db.classText.offsetY
	)
	target.classText:SetJustifyH("RIGHT")
	target.classText:SetJustifyV("BOTTOM")
end

local ENCHANT_ABBREVS
local function BuildEnchantAbbrevs()
	ENCHANT_ABBREVS = {
		[_G["SPELL_STAT" .. _G.LE_UNIT_STAT_STRENGTH .. "_NAME"]] = "Str.",
		[_G["SPELL_STAT" .. _G.LE_UNIT_STAT_AGILITY .. "_NAME"]] = "Agi.",
		[_G["SPELL_STAT" .. _G.LE_UNIT_STAT_INTELLECT .. "_NAME"]] = "Int.",
		[_G["SPELL_STAT" .. _G.LE_UNIT_STAT_STAMINA .. "_NAME"]] = "Stam.",
		[_G["STAT_VERSATILITY"]] = "Vers.",
		[_G["STAT_CRITICAL_STRIKE"]] = "Crit.",
		[_G["STAT_MASTERY"]] = "Mast.",
		[_G["STAT_AVOIDANCE"]] = "Avoid.",
	}
end

function module:EnchantAbbreviate(str)
	if not ENCHANT_ABBREVS then
		BuildEnchantAbbrevs()
	end
	local text = gsub(gsub(str, "%s?|A.-|a", ""), "|cn.-:(.-)|r", "%1")
	local short = F.String.Abbreviate(text)
	for stat, abbrev in pairs(ENCHANT_ABBREVS) do
		short = short:gsub(stat, abbrev)
	end
	return utf8sub(short, 1, 18)
end

---Enchant or missing socket/enchant text of a slot, also used by the options preview
---(Options/Widgets/ArmoryPreview.lua)
---@param slotOptions table entry of module.characterSlots
---@param slotInfo table from E:GetGearSlotInfo
---@return string
function module:GetSlotEnchantText(slotOptions, slotInfo)
	if self.db.pageInfo.enchantTextEnabled and slotInfo.itemLevelColors and next(slotInfo.itemLevelColors) then
		-- A missing socket wins over the enchant text. Slots that have their socket
		-- (e.g. a socketed helm) still go through the enchant handling below.
		local missingGemSlots = 0
		if
			self.db.pageInfo.missingSocketText
			and slotOptions.needsSocket
			and not E.TimerunningID
			and (not slotOptions.warningCondition or module:CheckMessageCondition(slotOptions))
		then
			missingGemSlots = 1 - #slotInfo.gems
		end

		if missingGemSlots > 0 then
			local text = format(L["Add %d socket"], missingGemSlots)
			local missingColor = {
				F.String.FastColorGradientHex(missingGemSlots, module.colors.LIGHT_GREEN, module.colors.RED),
			}
			return F.String.RGB(text, missingColor)
		elseif slotInfo.enchantColors and next(slotInfo.enchantColors) then
			if slotInfo.enchantText and slotInfo.enchantText ~= "" then
				local text = slotInfo.enchantTextShort
				-- Strip color
				text = F.String.StripColor(text)
				if self.db.pageInfo.abbreviateEnchantText then
					text = module:EnchantAbbreviate(slotInfo.enchantText)
				end

				if self.db.pageInfo.useEnchantClassColor then
					return F.String.Class(text)
				else
					return text
				end
			end
		elseif self.db.pageInfo.missingEnchantText and slotOptions.needsEnchant and not E.TimerunningID then
			if not slotOptions.warningCondition or module:CheckMessageCondition(slotOptions) then
				return F.String.Error(L["Add enchant"])
			else
				return ""
			end
		else
			return ""
		end
	end

	return ""
end

local UPGRADE_SEGMENT_WIDTH = 3
local UPGRADE_SEGMENT_GAP = 1
-- Room between the icon and the bar, ElvUI's texts start further out
local UPGRADE_BAR_OFFSET = 3
local UPGRADE_EMPTY_ALPHA = 0.2
local UPGRADE_TRACK_TEXT_INSET = 2

---Upgrade level as a bar of segments along the inner edge of an item slot, filled
---from the bottom. Colored by the upgrade track (Adventurer to Myth) when that
---option is on, otherwise and for unknown tracks like a traffic light by the
---progress (red, yellow, fully upgraded green). The options preview passes its own slot
---@param slot Frame item slot the bar sits next to
---@param isLeft boolean? slot of the left column, the bar goes on its right edge
---@param current number? upgrade level, nil hides the bar
---@param maximum number? highest upgrade level of the track
---@param trackID number? trackStringID of the upgrade track
function module:SetUpgradeBar(slot, isLeft, current, maximum, trackID)
	local bar = slot.MERUpgradeBar

	if not (current and maximum and maximum > 0) then
		if bar then
			bar:Hide()
		end
		return
	end

	if not bar then
		bar = CreateFrame("Frame", nil, slot)
		bar.segments = {}

		if isLeft then
			bar:SetPoint("TOPLEFT", slot, "TOPRIGHT", UPGRADE_BAR_OFFSET, 0)
			bar:SetPoint("BOTTOMLEFT", slot, "BOTTOMRIGHT", UPGRADE_BAR_OFFSET, 0)
		else
			bar:SetPoint("TOPRIGHT", slot, "TOPLEFT", -UPGRADE_BAR_OFFSET, 0)
			bar:SetPoint("BOTTOMRIGHT", slot, "BOTTOMLEFT", -UPGRADE_BAR_OFFSET, 0)
		end
		bar:SetWidth(UPGRADE_SEGMENT_WIDTH)

		slot.MERUpgradeBar = bar
	end

	local segmentHeight = (slot:GetHeight() - (maximum - 1) * UPGRADE_SEGMENT_GAP) / maximum
	local r, g, b
	if self.db.pageInfo.upgradeTrackColor then
		r, g, b = F.GetUpgradeTrackColor(trackID)
	end
	if not r then
		-- Red at the start, yellow halfway, green once fully upgraded (module.colors)
		r, g, b = E:ColorGradient(current / maximum, 0.94, 0.33, 0.31, 1, 0.82, 0, 0.07, 0.9, 0.15)
	end

	for index = 1, max(maximum, #bar.segments) do
		local segment = bar.segments[index]

		if index <= maximum then
			if not segment then
				segment = bar:CreateTexture(nil, "OVERLAY")
				segment:SetTexture(E.media.blankTex)
				bar.segments[index] = segment
			end

			segment:ClearAllPoints()
			segment:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, (index - 1) * (segmentHeight + UPGRADE_SEGMENT_GAP))
			segment:SetSize(UPGRADE_SEGMENT_WIDTH, segmentHeight)
			segment:SetVertexColor(r, g, b, index <= current and 1 or UPGRADE_EMPTY_ALPHA)
			segment:Show()
		elseif segment then
			segment:Hide()
		end
	end

	bar:Show()
end

---First letter of the upgrade track in the top corner of the item icon on the side
---of the upgrade bar, e.g. "H" for Hero, in the color of the track. Next to the item
---level ElvUI places the sockets, and the texts above both weapons meet. The letter
---comes from the localized track name. The options preview passes its own slot
---@param slot Frame item slot
---@param isLeft boolean? slot of the left column, the letter goes in the top right corner
---@param trackID number? trackStringID of the upgrade track, nil hides the letter
---@param trackName string? localized name of the upgrade track
function module:SetUpgradeTrackText(slot, isLeft, trackID, trackName)
	local text = slot.MERUpgradeTrackText

	if not (trackID and trackName and trackName ~= "") then
		if text then
			text:SetText("")
		end
		return
	end

	if not text then
		text = slot:CreateFontString(nil, "OVERLAY")
		if isLeft then
			text:SetPoint("TOPRIGHT", slot, "TOPRIGHT", -UPGRADE_TRACK_TEXT_INSET, -UPGRADE_TRACK_TEXT_INSET)
		else
			text:SetPoint("TOPLEFT", slot, "TOPLEFT", UPGRADE_TRACK_TEXT_INSET, -UPGRADE_TRACK_TEXT_INSET)
		end
		slot.MERUpgradeTrackText = text
	end

	WF.SetFontWithDB(text, self.db.pageInfo.iLvLFont)
	text:SetText(utf8sub(trackName, 1, 1))

	local r, g, b = F.GetUpgradeTrackColor(trackID)
	text:SetTextColor(r or 1, g or 1, b or 1)
end

---Upgrade level, maximum, track ID and localized track name of an equipped item,
---nil for items without a track
---@param slotId number
---@return number?, number?, number?, string?
function module:GetSlotUpgradeLevel(slotId)
	local link = GetInventoryItemLink("player", slotId)
	local info = link and GetItemUpgradeInfo(link)
	if info then
		-- /muidev debug Armory, to check the track IDs of F.GetUpgradeTrackColor
		F.Developer.Debug(
			"Armory",
			"Slot",
			slotId,
			"trackStringID",
			info.trackStringID,
			"trackString",
			info.trackString,
			"level",
			info.currentLevel,
			"/",
			info.maxLevel
		)
		return info.currentLevel, info.maxLevel, info.trackStringID, info.trackString
	end
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
	slotItem.enchantText:SetText(self:GetSlotEnchantText(slotOptions, slotInfo))

	-- Hide Gradient (no item color to show it for)
	if slotItem.MERGradient and not (slotInfo.itemLevelColors and next(slotInfo.itemLevelColors)) then
		slotItem.MERGradient:Hide()
	end

	-- If we got an item color, show gradient and set color
	if slotInfo.itemLevelColors and next(slotInfo.itemLevelColors) then
		local r, g, b = unpack(slotInfo.itemLevelColors)
		local gradientWidth = self.db.pageInfo.itemQualityGradientWidth
		local gradientHeight = self.db.pageInfo.itemQualityGradientHeight
		local gradientEnabled = self.db.pageInfo.itemQualityGradientEnabled

		-- ElvUI's tooltip-derived item level color keeps shifting by a hair for
		-- a couple seconds after login/open while the average item level
		-- settles (PLAYER_AVG_ITEM_LEVEL_UPDATE), firing UpdatePageStrings for
		-- every slot again with a marginally different color. That alone must
		-- NOT replay the grow-in animation, or every gradient restarts
		-- mid-flight in lockstep and never visibly finishes until the color
		-- stops drifting. Only structural changes (size, direction, enabled
		-- state) or the bar (re-)appearing should do that; color is refreshed
		-- unconditionally below since re-tinting is instant and has no
		-- animation to interrupt.
		local isNew = not slotItem.MERGradient
		local structuralSignature =
			strjoin(":", slotOptions.direction, gradientWidth, gradientHeight, tostring(gradientEnabled))
		local needsReveal = isNew
			or slotItem.MERGradient.lastStructuralSignature ~= structuralSignature
			or not slotItem.MERGradient:IsShown()

		-- Create Gradient if it doesen't exist
		if isNew then
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

		if needsReveal then
			-- Setup Animations
			self:SetupGrowAnimation(slotItem.MERGradient)

			-- Update Size
			slotItem.MERGradient:SetSize(gradientWidth, gradientHeight)
			slotItem.MERGradient.GrowIn.Grow:SetChange(E:Scale(gradientWidth))
		end

		-- Update Colors (always, independent of the reveal animation)
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

		if gradientEnabled then
			slotItem.MERGradient:Show()
			if needsReveal then
				self:PlayAnimation(slotItem.MERGradient.GrowIn)
			end
		else
			slotItem.MERGradient:Hide()
		end

		slotItem.MERGradient.lastStructuralSignature = structuralSignature
	end

	-- Upgrade Bar and Track
	local pageInfo = self.db.pageInfo
	local current, maximum, trackID, trackName
	if pageInfo.upgradeBarEnabled or pageInfo.upgradeTrackText then
		current, maximum, trackID, trackName = self:GetSlotUpgradeLevel(slotId)
	end

	local isLeft = slotOptions.direction == module.enumDirection.LEFT
	if pageInfo.upgradeBarEnabled then
		self:SetUpgradeBar(slotItem, isLeft, current, maximum, trackID)
	else
		self:SetUpgradeBar(slotItem)
	end

	if pageInfo.upgradeTrackText then
		self:SetUpgradeTrackText(slotItem, isLeft, trackID, trackName)
	else
		self:SetUpgradeTrackText(slotItem)
	end

	-- iLvL Text Handling
	if not self.db.pageInfo.itemLevelTextEnabled then
		slotItem.iLvlText:SetText("")
	end

	-- Icons Handling (early-exit when slot textures no longer exist)
	if not self.db.pageInfo.itemLevelTextEnabled or not self.db.pageInfo.iconsEnabled then
		for x = 1, 10 do
			local textureSlot = slotItem["textureSlot" .. x]
			if not textureSlot then
				break
			end
			local essenceType = slotItem["textureSlotEssenceType" .. x]
			if essenceType then
				essenceType:Hide()
			end
			textureSlot:SetTexture()
			local backdrop = slotItem["textureSlotBackdrop" .. x]
			if backdrop then
				backdrop:Hide()
			end
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
					local left, right, top, bottom = E:CropRatio(socketWidth, socketHeight)
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
				WF.SetFontWithDB(slotFrame.iLvlText, module.db.pageInfo.iLvLFont)
			end

			-- Enchant Slot Text
			if slotFrame.enchantText then
				WF.SetFontWithDB(slotFrame.enchantText, module.db.pageInfo.enchantFont)
			end
		end
	end

	module:UpdateItemLevel()
end

---Font, text color and divider gradients of a stats category header, used by the
---options preview on its own regions as well
---@param title FontString
---@param leftDivider Texture
---@param rightDivider Texture
function module:StyleCategoryHeader(title, leftDivider, rightDivider)
	local currentClass = E.myclass
	local classColorNormal = E.db.mui.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.NORMAL][currentClass]
	local classColorShift = E.db.mui.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.SHIFT][currentClass]

	-- Set custom font
	WF.SetFontWithDB(title, module.db.stats.headerFont)

	local categoryHeader = F.String.StripColor(title:GetText())

	-- Set color gradient
	if module.db.stats.headerFont.headerFontColor == "GRADIENT" then
		title:SetText(F.String.FastGradient(categoryHeader, 0, 0.9, 1, 0, 0.6, 1))
	elseif module.db.stats.headerFont.headerFontColor == "CLASS" then
		title:SetText(F.String.GradientClass(categoryHeader))
	else
		title:SetText(categoryHeader)
		WF.SetFontColorWithDB(title, module.db.stats.headerFont.color)
	end

	-- Left divider
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
		local fontColor = module.db.stats.headerFont.color
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

	-- Right divider
	rightDivider:SetHeight(2)
	rightDivider:SetTexture(E.media.blankTex)
	rightDivider:SetVertexColor(1, 1, 1, 1)

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
		local fontColor = module.db.stats.headerFont.color
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

	local leftDivider = frame.Title.MERLeftDivider or frame:CreateTexture(nil, "ARTWORK")
	local rightDivider = frame.Title.MERRightDivider or frame:CreateTexture(nil, "ARTWORK")
	module:StyleCategoryHeader(frame.Title, leftDivider, rightDivider)

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
	local rightDividerWidth = rightDivider:GetWidth()

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

-- leftGrad/rightGrad are the names of older ElvUI versions
local elvuiStatGradients = { "leftGrad", "rightGrad", "leftGradient", "rightGradient" }

function module:CleanupCharacterStat(frame)
	-- Kill Blizzard and ElvUI Stuff
	if frame.Background then
		frame.Background:Kill()
	end
	-- ElvUI re-shows its gradients via SetShown on every stats update and SetAlpha has no
	-- effect on a gradient texture, so park them on the hidden frame instead
	for _, key in ipairs(elvuiStatGradients) do
		local gradient = frame[key]
		if gradient and gradient:GetParent() ~= E.HiddenFrame then
			gradient:SetParent(E.HiddenFrame)
		end
	end
end

function module:UpdateCharacterStat(frame, showGradient)
	module:CleanupCharacterStat(frame)

	-- Set custom font gradient for label
	if frame.Label then
		WF.SetFontWithDB(frame.Label, module.db.stats.labelFont)

		local labelString = F.String.StripColor(frame.Label:GetText()) or ""

		if module.db.stats.labelFont.abbreviateLabels and labelString ~= "" then
			labelString = E:ShortenString(F.String.Abbreviate(labelString), 12)
		end

		if module.db.stats.labelFont.labelFontColor == "GRADIENT" then
			frame.Label:SetText(F.String.FastGradient(labelString, 0, 0.6, 1, 0, 0.9, 1))
		elseif module.db.stats.labelFont.labelFontColor == "CLASS" then
			frame.Label:SetText(F.String.GradientClass(labelString, nil, true))
		else
			frame.Label:SetText(labelString)
			WF.SetFontColorWithDB(frame.Label, module.db.stats.labelFont.color)
		end
	end

	local currentClass = E.myclass
	local classColorNormal = E.db.mui.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.NORMAL][currentClass]
	local classColorShift = E.db.mui.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.SHIFT][currentClass]

	-- Set custom for value
	if frame.Value then
		WF.SetFontWithDB(frame.Value, module.db.stats.valueFont)
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
			local fontColor = module.db.stats.labelFont.color
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

local function ListContains(list, value)
	for _, entry in ipairs(list) do
		if entry == value then
			return true
		end
	end
	return false
end

---Smart mode (1) rules of a stat: primary stat, role, class and its own show function.
---The value check against hideAt follows once the stat is updated.
local function PassesSmartRules(stat, role, primaryStat)
	if primaryStat then
		if stat.primary and stat.primary ~= primaryStat then
			return false
		end
		if stat.primaries and not ListContains(stat.primaries, primaryStat) then
			return false
		end
	end
	if stat.roles and not ListContains(stat.roles, role) then
		return false
	end
	if stat.classes and not ListContains(stat.classes, E.myclass) then
		return false
	end
	if stat.showFunc then
		return stat.showFunc()
	end
	return true
end

function module:UpdateCharacterStats()
	if not module.frame:IsShown() then
		return
	end
	if InCombatLockdown() then
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

	local spec = C_SpecializationInfo_GetSpecialization()
	local level = UnitLevel("player")
	local categoryYOffset = 0
	local statYOffset = 0
	local lastAnchor, role, primaryStat

	module:ClearAnimations(true)

	-- Cache role + primaryStat once for the entire stats rebuild
	if spec then
		role = GetSpecializationRole(spec)
		primaryStat = select(6, C_SpecializationInfo_GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")))
	end

	-- The stat picker adds the hidden stats that fit the spec, dimmed. Stats of other roles
	-- would push the list past the bottom of the frame, those stay in the options, and the
	-- item level makes room while editing.
	local editMode = module.statEditMode

	if level >= (MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY or 0) and not editMode then
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
	local categories = module.StatCategories
	local modes = module.db.stats.mode

	module:ClearStatPickerRows()

	for catIndex = 1, #categories do
		local catFrame = characterStatsPane[categories[catIndex].categoryFrame]
		local animationSlot = module:GetAnimationSlot(true)
		local numStatInCat = 0
		local stats = module:GetOrderedStats(catIndex)
		for statIndex = 1, #stats do
			local stat = stats[statIndex]
			-- 0 (Hide), 1 (Smart), 2 (Always Show if not empty), 3 (Always Show), nil for unknown stats
			local statMode = modes[stat.stat] and modes[stat.stat].mode
			local passesRules = PassesSmartRules(stat, role, primaryStat)
			local showStat = (statMode == 3) or (statMode == 2) or (statMode == 1 and passesRules)

			if showStat or (editMode and statMode ~= nil and passesRules) then
				-- Append ID string to stat frame
				statFrame.stringId = stat.stat
				statFrame.onEnterFunc = nil
				statFrame.UpdateTooltip = nil

				local updateFunc = module.StatUpdateOverrides[stat.stat] or _G.PAPERDOLL_STATINFO[stat.stat].updateFunc
				local ok = pcall(updateFunc, statFrame, "player")
				if not ok then
					if statFrame.Value then
						statFrame.Value:SetText(F.String.Muted("N/A"))
					end
					statFrame.numericValue = nil
					statFrame:Show()
				end

				-- Mode 1 hides at the stat's hideAt value, mode 2 at its hideAt or 0. A secret
				-- value can't be compared, so the stat stays visible then.
				local hideAt = stat.hideAt
				local numericValue = statFrame.numericValue
				local valueKnown = E:NotSecretValue(numericValue)
				local notEmpty = not (valueKnown and hideAt ~= nil and hideAt == numericValue)
				if statMode == 1 then
					showStat = showStat and notEmpty
				elseif statMode == 2 then
					showStat = not (valueKnown and (hideAt or 0) == numericValue)
				end

				-- Blizzard's update functions hide the row for stats the character can't have
				if statFrame:IsShown() and (showStat or editMode) then
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
					module:SetStatRowDimmed(statFrame, editMode and not showStat)
					module:SetupFadeAnimation(statFrame)
					module:HookStatHighlight(statFrame)
					if editMode then
						module:AddStatPickerRow(statFrame, stat, catIndex, showStat, passesRules and notEmpty)
					end

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
	module:UpdateStatPickerOverlay()
end

function module:UpdateAttackSpeed(statFrame, unit)
	local meleeHaste = GetMeleeHaste()
	local speed, offhandSpeed = UnitAttackSpeed(unit)

	local displaySpeed = format("%.2f", speed)
	if offhandSpeed then
		displaySpeed = BreakUpLargeNumbers(displaySpeed) .. " / " .. format("%.2f", offhandSpeed)
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

-- Per-stat replacements for Blizzard's own PAPERDOLL_STATINFO update
-- functions, applied only while rendering our own pane. Overriding the
-- dispatch here rather than replacing Blizzard's global function keeps that
-- global untainted for Blizzard's own code paths.
module.StatUpdateOverrides = {
	-- Blizzard's version doesn't run the speed through BreakUpLargeNumbers,
	-- so it shows the wrong decimal separator in some locales.
	ATTACK_ATTACKSPEED = function(statFrame, unit)
		module:UpdateAttackSpeed(statFrame, unit)
	end,
}

-- Runs after Blizzard's own pass (secure hook, so the global stays untainted).
-- Blizzard's output is discarded by UpdateCharacterStats, which also carries
-- its own combat guard.
function module:OnPaperDollUpdateStats()
	self:UpdateCharacterStats()
end

-- Deliberately our own module table rather than an override of Blizzard's
-- PAPERDOLL_STATCATEGORIES global: UpdateCharacterStats releases everything
-- Blizzard's own pass rendered and draws the pane from this list itself, so
-- Blizzard never needs to see it - and writing that global would taint it for
-- the session, which then taints PaperDollFrame_OnShow (it reads the global,
-- then resizes the panel-managed CharacterFrame).
function module:BuildStatCategories()
	module.StatCategories = {
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
					showFunc = OffhandHasShield,
				}, -- 10
			},
		},
	}
end

local function ControlFrame_OnShow(frame)
	local db = module.db
	if db and db.enable and db.background.enable and db.background.hideControls then
		frame:Hide()
	end
end

---Background image and alpha of the settings, the options preview passes its own texture
---@param texture Texture
function module:SetBackgroundTexture(texture)
	local db = module.db.background
	if db.enable then
		if db.class then
			texture:SetTexture(I.Media.Armory["MERATHILISUI-" .. E.myclass])
		else
			texture:SetTexture(I.Media.Armory["BG" .. db.style])
		end
		texture:SetVertexColor(1, 1, 1, db.alpha)
	else
		texture:SetTexture(nil)
		texture:SetVertexColor(0, 0, 0, 0)
	end
end

local controlsHooked = false
function module:UpdateBackground()
	-- Hooked once and checked on every show, so the toggle works without a reload
	if not controlsHooked then
		local controlFrame = _G.CharacterModelScene and _G.CharacterModelScene.ControlFrame
		if controlFrame then
			controlFrame:HookScript("OnShow", ControlFrame_OnShow)
			controlsHooked = true
		end
	end

	module:SetBackgroundTexture(self.frame.MERBackground.Texture)
end

local SHADOW_ATLAS = "scoreboard-charactermodels-shadow"
local SHADOW_OFFSET_Y = 9
local DOUBLE_CLICK_TIME = 0.35
-- Cursor travel between press and release that still counts as a click, not a turn
local CLICK_TOLERANCE = 4

-- First shown actor of the scene, the player or their shapeshift form
local function GetSceneActor(scene)
	for index = 1, scene:GetNumActors() do
		local actor = scene:GetActorAtIndex(index)
		if actor and actor:IsShown() then
			return actor
		end
	end
end

-- Keeps the shadow under the feet while the camera turns, zooms or pans. Same
-- projection as Blizzard's ModelSceneMixin:AddOrUpdateDropShadow, but with our own
-- texture so the scene's actors and pools stay untouched
local function Stage_OnUpdate(stage)
	local scene = module.frameModel
	local shadow = stage.Shadow
	local actor = GetSceneActor(scene)

	local x, y, depth
	if actor then
		local posX, posY, posZ = actor:GetPosition()
		local scale = actor:GetScale()
		x, y, depth = scene:Project3DPointTo2D(posX * scale, posY * scale, posZ * scale)
	end

	if not (x and y and depth) then
		shadow:Hide()
		return
	end

	depth = Lerp(0.05, 1, ClampedPercentageBetween(depth, 0.8, 1))
	local inverseScale = scene:GetEffectiveScale() * depth

	-- The actor's origin lies a bit behind the feet in the character sheet's camera angle,
	-- the offset is in the shadow's own scale, so it shrinks and grows with the zoom
	local offsetX, offsetY = (x / inverseScale) + 2, (y / inverseScale) - SHADOW_OFFSET_Y

	-- The model is cut off at the edges of the scene, the shadow on the background is not.
	-- It fades out while it moves past an edge (zoomed in, panned) and is gone once its
	-- center leaves the scene
	local sceneWidth, sceneHeight = scene:GetSize()
	local centerX, centerY = offsetX * depth, offsetY * depth
	local halfWidth, halfHeight = shadow:GetWidth() * depth * 0.5, shadow:GetHeight() * depth * 0.5
	local visible =
		min(min(centerX, sceneWidth - centerX) / halfWidth, min(centerY, sceneHeight - centerY) / halfHeight, 1)

	if visible <= 0 then
		shadow:Hide()
		return
	end

	shadow:SetScale(depth)
	shadow:ClearAllPoints()
	shadow:SetPoint("CENTER", scene, "BOTTOMLEFT", offsetX, offsetY)
	shadow:SetAlpha(module.db.model.shadowAlpha * visible)
	shadow:Show()
end

---Spotlight in class color behind the character and a shadow under its feet. Both
---live on the background frame, so they are drawn above the image and below the model
function module:UpdateStage()
	local db = self.db.model
	local background = self.frame.MERBackground
	local scene = self.frameModel
	local stage = self.stage

	if db.spotlight then
		local spotlight = background.MERSpotlight
		if not spotlight then
			spotlight = background:CreateTexture(nil, "ARTWORK", nil, 1)
			spotlight:SetTexture(I.Media.Textures.ArmorySpotlight)
			background.MERSpotlight = spotlight
		end

		local width, height = scene:GetSize()
		spotlight:ClearAllPoints()
		spotlight:SetPoint("CENTER", scene, "CENTER", 0, -height * 0.05)
		spotlight:SetSize(width * 1.4, height * 1.1)

		local classColor = E:ClassColor(E.myclass, true)
		spotlight:SetVertexColor(classColor.r, classColor.g, classColor.b, db.spotlightAlpha)
		spotlight:Show()
	elseif background.MERSpotlight then
		background.MERSpotlight:Hide()
	end

	if db.shadow then
		if not stage.Shadow then
			stage.Shadow = background:CreateTexture(nil, "ARTWORK", nil, 2)
			stage.Shadow:SetAtlas(SHADOW_ATLAS, true)
		end
		stage:SetScript("OnUpdate", Stage_OnUpdate)
	else
		stage:SetScript("OnUpdate", nil)
		if stage.Shadow then
			stage.Shadow:Hide()
		end
	end
end

function module:HideStage()
	self.stage:SetScript("OnUpdate", nil)
	if self.stage.Shadow then
		self.stage.Shadow:Hide()
	end
	if self.frame.MERBackground.MERSpotlight then
		self.frame.MERBackground.MERSpotlight:Hide()
	end
end

local clickDownX, clickDownY, lastClickTime

function module:OnModelMouseDown(_, button)
	if button == "LeftButton" then
		clickDownX, clickDownY = GetCursorPosition()
	end
end

---Double-click on the model resets turn, zoom and pan like the reset button of the
---camera controls. Blizzard sets the scene up again on every open of the frame
function module:OnModelMouseUp(scene, button)
	if button ~= "LeftButton" or not self.db.model.doubleClickReset then
		return
	end

	-- A turn of the model is no click
	local x, y = GetCursorPosition()
	if not clickDownX or abs(x - clickDownX) > CLICK_TOLERANCE or abs(y - clickDownY) > CLICK_TOLERANCE then
		lastClickTime = nil
		return
	end

	local now = GetTime()
	if lastClickTime and (now - lastClickTime) <= DOUBLE_CLICK_TIME then
		lastClickTime = nil
		scene:Reset()
		PlaySound(SOUNDKIT.IG_INVENTORY_ROTATE_CHARACTER)
	else
		lastClickTime = now
	end
end

local WHITE = CreateColor(1, 1, 1, 1)

---Color of a decorative line, the options preview passes its own texture
---@param texture Texture
function module:SetLineColor(texture)
	-- Reset gradient
	texture:SetGradient("HORIZONTAL", WHITE, WHITE)

	if module.db.lines.enable then
		local classColor = E:ClassColor(E.myclass, true)
		texture:SetColorTexture(classColor.r, classColor.g, classColor.b, module.db.lines.alpha)
	else
		texture:SetColorTexture(0, 0, 0, 0)
	end
end

function module:UpdateLineColors()
	module:SetLineColor(module.frame.topLine.Texture)
	module:SetLineColor(module.frame.bottomLine.Texture)
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

	-- Font settings may have changed via options
	self._titleFontDirty = true

	module:KillBlizzard()
	module:UpdateBackground()
	module:UpdateStage()
	module:UpdateLines()
	module:UpdateTitle()
	module:UpdatePageInfo()
	module:UpdateStatPickerButton()
	module:UpdateCharacterStats()
	module:CreateTitleSearchBox()
	module:EnableEquipmentManagerSkin()
	if module.equipmentPanel then
		module:RefreshEquipmentManagerPanel()
	end
	module:UpdateSocketPanel()

	if module.frame and module.frame:IsShown() then
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
	-- Only runs the shadow's OnUpdate, hides together with the model
	module.stage = CreateFrame("Frame", nil, module.frameModel)

	module.animationObjects = {}
	module.statsObjects = {}
	module.styledFlyouts = {}
	module.statsCount = 1
	module._titleFontDirty = true

	local holder = module.frameHolder
	local background = CreateFrame("Frame", nil, holder)
	local nameText = holder:CreateFontString(nil, "OVERLAY")
	local classSymbol = holder:CreateTexture()
	local titleText = holder:CreateFontString(nil, "OVERLAY")
	local levelTitleText = holder:CreateFontString(nil, "OVERLAY")
	local levelText = holder:CreateFontString(nil, "OVERLAY")
	local specIcon = holder:CreateFontString(nil, "OVERLAY")
	local classText = holder:CreateFontString(nil, "OVERLAY")
	local waterMark = holder:CreateTexture(nil, "BACKGROUND")

	local frameHeight, frameWidth = module.frame:GetSize()
	local cutOffPercentage = 1 - (frameHeight / frameWidth)

	background:SetInside(module.frame)
	background:OffsetFrameLevel(-1, module.frameModel)
	background.Texture = background:CreateTexture(nil, "BACKGROUND")
	background.Texture:SetInside()
	background.Texture:SetTexCoord(0, 1, cutOffPercentage, 1)

	module.frame.MERBackground = background

	waterMark:SetPoint("BOTTOMRIGHT", module.frame, "BOTTOMRIGHT", -10, 15)
	waterMark:Size(72)
	waterMark:SetTexture(I.Media.Logos.Logo)
	waterMark:SetAlpha(0.35)

	module.waterMark = waterMark

	local lineHeight = 1
	local topLine = CreateFrame("Frame", nil, holder)
	local bottomLine = CreateFrame("Frame", nil, holder)

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

local function FilterTitlesScrollBox(searchText)
	local pane = _G.PaperDollFrame and _G.PaperDollFrame.TitleManagerPane
	if not pane or not pane.titles or not pane.ScrollBox then
		return
	end

	searchText = (searchText or ""):lower()

	local dataProvider = CreateDataProvider()
	local count = 0
	for index, playerTitle in ipairs(pane.titles) do
		local visible = (searchText == "")
			or (playerTitle.id == -1)
			or playerTitle.name:lower():find(searchText, 1, true)

		if visible then
			dataProvider:Insert({ index = index, playerTitle = playerTitle })
			-- "No Title" is a UI-only entry, not a real known title; excluded from the count
			if playerTitle.id ~= -1 then
				count = count + 1
			end
		end
	end

	pane.ScrollBox:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition)

	if module.titleCountText then
		module.titleCountText:SetFormattedText(L["Total: %d"] or "Total: %d", count)
	end
end

local function BuildTitleList(showEarned, showUnearned)
	local list = {}

	if showEarned then
		list[#list + 1] = { name = PLAYER_TITLE_NONE, id = -1, earned = true }
	end

	for i = 1, GetNumTitles() do
		local earned = IsTitleKnown(i)
		if (earned and showEarned) or ((not earned) and showUnearned) then
			local name = GetTitleName(i)
			if name and name ~= "" then
				list[#list + 1] = { name = name, id = i, earned = earned }
			end
		end
	end

	tsort(list, function(a, b)
		if a.id == -1 or b.id == -1 then
			return a.id == -1
		end
		return a.name < b.name
	end)

	return list
end

local function UpdateTitlesPane()
	local pane = _G.PaperDollFrame and _G.PaperDollFrame.TitleManagerPane
	if not pane or not module.titleFilter then
		return
	end

	local currentTitle = GetCurrentTitle()
	pane.selected = (currentTitle > 0 and IsTitleKnown(currentTitle)) and currentTitle or -1

	pane.titles = BuildTitleList(module.titleFilter.showEarned, module.titleFilter.showUnearned)

	FilterTitlesScrollBox(module.titleSearchBox and module.titleSearchBox:GetText())
end

local function UpdateFilterButtonVisual()
	local btn = module.titleFilterButton
	if not btn then
		return
	end

	if module.titleFilter.showEarned and not module.titleFilter.showUnearned then
		btn.Icon:SetTexCoord(0.5, 0.75, 0, 0.25)
	else
		btn.Icon:SetTexCoord(0, 0.25, 0, 0.25)
	end
end

local function ToggleTitleFilter(key)
	module.titleFilter[key] = not module.titleFilter[key]

	-- Never allow both filters to end up off; fall back to showing earned titles
	if not module.titleFilter.showEarned and not module.titleFilter.showUnearned then
		module.titleFilter.showEarned = true
	end

	UpdateFilterButtonVisual()
	UpdateTitlesPane()
end

local function IsPlumberTitleSearchActive()
	return IsAddOnLoaded("Plumber") and _G.PlumberDB and _G.PlumberDB.PlayerTitleUI == true
end

function module:CreateTitleSearchBox()
	if module.titleSearchBox then
		return
	end

	if IsPlumberTitleSearchActive() then
		return
	end

	local pane = _G.PaperDollFrame and _G.PaperDollFrame.TitleManagerPane
	if not pane or not pane.ScrollBox then
		return
	end

	module.titleFilter = { showEarned = true, showUnearned = false }

	local scrollBox = pane.ScrollBox
	local originalWidth, originalHeight = scrollBox:GetSize()

	-- Match the scrollbox's real horizontal span so the header row (search box + filter
	-- button) and the count text line up exactly with the title list beneath them
	local headerLeftOffset = (scrollBox:GetLeft() or (pane:GetLeft() + 4)) - pane:GetLeft()
	local headerRightOffset = (scrollBox:GetRight() or (pane:GetRight() - 4)) - pane:GetRight()

	-- Filter button (Earned/Unearned), placed to the right of the search box
	local filterBtn = CreateFrame("Button", nil, pane)
	filterBtn:SetSize(20, 20)
	filterBtn:SetPoint("TOPRIGHT", pane, "TOPRIGHT", headerRightOffset, -4)
	-- filterBtn:CreateBackdrop("Transparent")
	module.titleFilterButton = filterBtn

	local filterIcon = filterBtn:CreateTexture(nil, "OVERLAY")
	filterIcon:SetSize(16, 16)
	filterIcon:SetPoint("CENTER")
	filterIcon:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\Icons\\FilterButton")
	filterIcon:SetTexCoord(0.5, 0.75, 0, 0.25)
	filterIcon:SetVertexColor(0.8, 0.8, 0.8, 1)
	filterBtn.Icon = filterIcon

	filterBtn:SetScript("OnEnter", function(self)
		self.Icon:SetVertexColor(1, 1, 1, 1)
		_G.GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		_G.GameTooltip:SetText(_G.FILTER, 1, 1, 1)
		_G.GameTooltip:Show()
	end)

	filterBtn:SetScript("OnLeave", function(self)
		self.Icon:SetVertexColor(0.8, 0.8, 0.8, 1)
		_G.GameTooltip:Hide()
	end)

	filterBtn:SetScript("OnClick", function(self)
		_G.MenuUtil.CreateContextMenu(self, function(_, rootDescription)
			rootDescription:CreateTitle(_G.FILTER)
			rootDescription:CreateCheckbox(L["Earned"] or "Earned", function()
				return module.titleFilter.showEarned
			end, function()
				ToggleTitleFilter("showEarned")
			end)
			rootDescription:CreateCheckbox(L["Unearned"] or "Unearned", function()
				return module.titleFilter.showUnearned
			end, function()
				ToggleTitleFilter("showUnearned")
			end)
		end)
	end)

	local searchBox = CreateFrame("EditBox", "MER_ArmoryTitleSearchBox", pane, "SearchBoxTemplate")
	S:HandleEditBox(searchBox)
	searchBox:SetHeight(20)
	searchBox:SetPoint("TOPLEFT", pane, "TOPLEFT", headerLeftOffset, -4)
	searchBox:SetPoint("RIGHT", filterBtn, "LEFT", -4, 0)
	searchBox:SetAutoFocus(false)
	searchBox:SetMaxLetters(30)
	searchBox:SetFontObject(GameFontHighlightSmall)
	searchBox:SetTextColor(1, 1, 1, 1)
	searchBox.Instructions:SetText(L["Search titles..."] or "Search titles...")
	module.titleSearchBox = searchBox

	local countText = pane:CreateFontString(nil, "OVERLAY")
	countText:FontTemplate(E.media.normFont, 10, "NONE")
	countText:SetPoint("TOPRIGHT", filterBtn, "BOTTOMRIGHT", 0, -4)
	countText:SetJustifyH("RIGHT")
	countText:SetTextColor(0.6, 0.6, 0.6, 0.8)
	module.titleCountText = countText

	UpdateFilterButtonVisual()

	searchBox:SetScript("OnTextChanged", function(self)
		SearchBoxTemplate_OnTextChanged(self)
		FilterTitlesScrollBox(self:GetText())
	end)

	searchBox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)

	local reserved = searchBox:GetHeight() + 20
	scrollBox:ClearAllPoints()
	scrollBox:SetPoint("TOPLEFT", searchBox, "BOTTOMLEFT", 0, -20)
	scrollBox:SetSize(originalWidth, originalHeight - reserved)

	if pane.ScrollBar then
		pane.ScrollBar:ClearAllPoints()
		pane.ScrollBar:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 8, -5)
		pane.ScrollBar:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 8, 4)
	end

	-- Grey out and disable buttons for titles that haven't been earned yet. The scroll box
	-- pools/reuses these buttons, so both branches must be handled explicitly - otherwise a
	-- button that was greyed out for an unearned title stays greyed out once it's recycled
	-- for an earned one.
	hooksecurefunc("PaperDollTitlesPane_InitButton", function(button, elementData)
		local info = elementData and elementData.playerTitle
		local earned = not info or info.earned ~= false

		button:SetEnabled(earned)

		if button.text then
			button.text:SetFontObject(earned and GameFontNormalSmallLeft or GameFontDisableSmallLeft)
		end
	end)

	if PaperDollTitlesPane_Update then
		hooksecurefunc("PaperDollTitlesPane_Update", UpdateTitlesPane)
	else
		UpdateTitlesPane()
	end

	pane:HookScript("OnShow", function()
		searchBox:SetText("")
		UpdateTitlesPane()
	end)
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
	elseif event == "UNIT_LEVEL" or event == "PLAYER_PVP_RANK_CHANGED" or event == "PLAYER_TALENT_UPDATE" then
		self:UpdateTitle()
	elseif event == "PLAYER_AVG_ITEM_LEVEL_UPDATE" then
		self:UpdateItemLevel()
	elseif event == "PLAYER_REGEN_ENABLED" then
		self:UpdateCharacterStats()
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
	self:DisableSocketPanel()
	self:DisableEquipmentManagerSkin()
	self:ClearStatSlotHighlight()
	self:SetStatEditMode(false)
	self:UpdateStatPickerButton()
	self:ResetFlyouts()
	self:HideStage()

	self:SetShownEventsRegistered(false)
end

function module:Enable()
	if not self.Initialized then
		return
	end
	if self:IsHooked(_G, "PaperDollFrame_UpdateStats") then
		return
	end

	self:CreateElements()
	self:EnableSocketPanel()

	-- Our own stat list (see StatUpdateOverrides for the per-stat display
	-- fixes) - must exist before the stats hook below can fire.
	self:BuildStatCategories()

	-- Hook ElvUI Overrides (reuse module-level M reference)
	self:SecureHook(M, "UpdateCharacterInfo", F.Event.GenerateClosure(self.UpdateItemLevel, self))
	self:SecureHook(M, "UpdateAverageString", F.Event.GenerateClosure(self.UpdateItemLevel, self))
	self:SecureHook(M, "UpdatePageStrings", F.Event.GenerateClosure(self.UpdatePageStrings, self))
	self:SecureHook(M, "CreateSlotStrings", F.Event.GenerateClosure(self.UpdatePageInfo, self))
	self:SecureHook(M, "ToggleItemLevelInfo", F.Event.GenerateClosure(self.ElvOptionsCheck, self))
	self:SecureHook(_G, "PaperDollFrame_UpdateStats", "OnPaperDollUpdateStats")

	-- Hook Blizzard OnShow, the events are registered while the frame is open
	self:SecureHookScript(self.frame, "OnShow", "OnArmoryShow")
	-- Closes the gem flyout and drops the socket panel's and our own events while closed
	self:SecureHookScript(self.frame, "OnHide", "OnArmoryHide")
	-- Double-click on the model resets the camera
	self:SecureHookScript(self.frameModel, "OnMouseDown", "OnModelMouseDown")
	self:SecureHookScript(self.frameModel, "OnMouseUp", "OnModelMouseUp")
	-- Shared flyout look for Blizzard's item swap flyout
	if _G.EquipmentFlyoutFrame then
		self:SecureHook("EquipmentFlyout_UpdateItems", "StyleEquipmentFlyout")
		self:SecureHookScript(_G.EquipmentFlyoutFrame, "OnShow", "OnEquipmentFlyoutShow")
	end

	-- Check ElvUI Options
	self:ElvOptionsCheck()

	-- Update instantly if frame is currently open
	if self.frame:IsShown() then
		self:SetShownEventsRegistered(true)
		self:UpdateCharacterArmory()
	end
end

-- Only needed while the character frame is open: UNIT_NAME_UPDATE alone fires for every nameplate
local SHOWN_EVENTS = {
	"UNIT_NAME_UPDATE",
	"UNIT_LEVEL",
	"PLAYER_PVP_RANK_CHANGED",
	"PLAYER_AVG_ITEM_LEVEL_UPDATE",
	"PLAYER_TALENT_UPDATE",
	"PLAYER_REGEN_ENABLED",
}

function module:SetShownEventsRegistered(registered)
	for _, event in ipairs(SHOWN_EVENTS) do
		if registered then
			F.Event.RegisterFrameEventAndCallback(event, self.HandleEvent, self, event)
		else
			F.Event.UnregisterFrameEventAndCallback(event, self)
		end
	end
end

function module:OnArmoryShow()
	self:SetShownEventsRegistered(true)
	self:OpenCharacterArmory()
end

function module:OnArmoryHide()
	self:SetShownEventsRegistered(false)
	self:SocketPanelOnHide()
	self:ClearStatSlotHighlight()
	self:SetStatEditMode(false)
end

function module:DatabaseUpdate()
	-- Set db
	self.db = F.GetDBFromPath("mui.armory") or E.db.mui.armory
	self._titleFontDirty = true
	self:ClearOrderedStats()

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
	F.Event.RegisterCallback("Armory.SettingsUpdate", self.UpdateCharacterArmory, self)

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
