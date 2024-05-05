local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Armory")
local M = E:GetModule("Misc")

local _G = _G
local pairs, select = pairs, select

local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo

local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
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
		needsEnchant = true,
		needsSocket = false,
		direction = module.enumDirection.LEFT,
	},
	["NeckSlot"] = {
		id = 2,
		needsEnchant = false,
		needsSocket = true,
		warningCondition = {
			level = 70,
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
			level = 70,
		},
		needsSocket = false,
		direction = module.enumDirection.LEFT,
	},
	["ChestSlot"] = {
		id = 5,
		needsEnchant = true,
		warningCondition = {
			level = 70,
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
			level = 70,
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
			level = 70,
		},
		needsSocket = false,
		direction = module.enumDirection.RIGHT,
	},
	["FeetSlot"] = {
		id = 8,
		needsEnchant = true,
		warningCondition = {
			level = 70,
		},
		needsSocket = false,
		direction = module.enumDirection.RIGHT,
	},
	["Finger0Slot"] = {
		id = 11,
		needsEnchant = true,
		warningCondition = {
			level = 70,
		},
		needsSocket = false,
		direction = module.enumDirection.RIGHT,
	},
	["Finger1Slot"] = {
		id = 12,
		needsEnchant = true,
		warningCondition = {
			level = 70,
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
			level = 70,
		},
		needsSocket = false,
		direction = module.enumDirection.RIGHT,
	},
	["SecondaryHandSlot"] = {
		id = 17,
		needsEnchant = true,
		warningCondition = {
			itemType = ENUM_ITEM_CLASS_WEAPON,
			level = 70,
		},
		needsSocket = false,
		direction = module.enumDirection.LEFT,
	},
}

function module:GetSlotNameByID(slotId)
	for slot, options in pairs(self.characterSlots) do
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

	local short = F.String.Abbreviate(str)
	for stat, abbrev in pairs(abbrevs) do
		short = short:gsub(stat, abbrev)
	end

	return short
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

	if not module.db.enable or not module:CheckOptions() or self.initialized then
		return
	end

	-- Check if ElvUI's Character Info is enabled
	if not E.db.general.itemLevel.displayCharacterInfo then
		return
	end

	hooksecurefunc(M, "UpdatePageInfo", module.UpdatePageInfo)
	hooksecurefunc(M, "CreateSlotStrings", module.UpdatePageInfo)
	hooksecurefunc(M, "UpdatePageStrings", module.UpdatePageStrings) --should be ok to call

	self.initialized = true
end

MER:RegisterModule(module:GetName())
