local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

local ipairs, pairs = ipairs, pairs
local tinsert, tremove = tinsert, tremove
local tsort = table.sort
local format, floor = format, math.floor

local C_Item_GetItemInfoInstant = C_Item.GetItemInfoInstant
local C_Container_GetContainerItemQuestInfo = C_Container.GetContainerItemQuestInfo

local IC = Enum.ItemClass
local CLASS_CONSUMABLE = IC.Consumable
local CLASS_CONTAINER = IC.Container
local CLASS_WEAPON = IC.Weapon
local CLASS_GEM = IC.Gem
local CLASS_ARMOR = IC.Armor
local CLASS_REAGENT = IC.Reagent
local CLASS_TRADEGOODS = IC.Tradegoods
local CLASS_ITEMENHANCEMENT = IC.ItemEnhancement
local CLASS_RECIPE = IC.Recipe
local CLASS_QUEST = IC.Questitem
local CLASS_MISC = IC.Miscellaneous
-- Not yet named Enum.ItemClass members on live retail - numeric IDs reserved
-- for a future expansion's profession/housing item types. Harmless to match
-- against now: no current item has either classID, so both categories just
-- stay empty until Blizzard ships items that use them.
local CLASS_PROFESSION = 19
local CLASS_HOUSING = 20

local BagIndex = Enum.BagIndex
module.ReagentContainer = (E.Retail and BagIndex and BagIndex.ReagentBag) or math.huge

-- Character bank tabs (retail only - the bank is no longer a single flat
-- container, it's 6 tab-bags, same unified Container API as regular bags
-- just with different bagIDs). Empty on non-retail clients; the whole Bank
-- view feature gates off #module.BankBagIDs > 0.
module.BankBagIDs = {}
module.BankBagIDSet = {}
if E.Retail and BagIndex then
	for i = 1, 6 do
		local id = BagIndex["CharacterBankTab_" .. i]
		if id then
			tinsert(module.BankBagIDs, id)
			module.BankBagIDSet[id] = true
		end
	end
end

-- Warband/Account Bank tabs - same unified Container API, separate bagID
-- range (12-16) from the character bank tabs above, reached through the same
-- bank interaction session (there's no separate open/close event for it).
module.WarbandBagIDs = {}
module.WarbandBagIDSet = {}
if E.Retail and BagIndex then
	for i = 1, 5 do
		local id = BagIndex["AccountBankTab_" .. i]
		if id then
			tinsert(module.WarbandBagIDs, id)
			module.WarbandBagIDSet[id] = true
		end
	end
end

-- Category list/order/matching rules kept 1:1 with the reference addon's own
-- hardcoded defaults (types = Enum.ItemClass numeric IDs, same precedence:
-- Reagent Bag > Item Set Gear > Quest > general type walk > catch-all). Icons
-- stay our own ElvUI-media choices where we already had a fitting one; the
-- three categories new to this pass (Item Set Gear/Gear Enhancements/Housing)
-- use plain Blizzard icon texture IDs since there's no existing ElvUI atlas
-- equivalent picked for them yet.
local DEFAULT_CATEGORIES = {
	{
		key = "REAGENTBAG",
		name = L["Reagent Bag"],
		isReagentBag = true,
		icon = 132854,
	},
	{
		key = "SETGEAR",
		name = L["Item Set Gear"],
		types = { CLASS_ARMOR, CLASS_WEAPON },
		isSetGear = true,
		icon = 4871338,
		nestByEquipmentSet = true,
	},
	{
		key = "QUEST",
		name = L["Quest Items"],
		types = { CLASS_QUEST },
		isQuest = true,
		icon = E.Media.Textures.Scroll,
		nestByExpansion = true,
	},
	{
		key = "WEAPONS",
		name = L["Weapons & Trinkets"],
		types = { CLASS_WEAPON },
		equipSlots = { INVTYPE_TRINKET = true },
		icon = E.Media.Textures.Combat,
	},
	{
		key = "ARMOR",
		name = L["Armor"],
		types = { CLASS_ARMOR },
		excludeEquipSlots = { INVTYPE_TRINKET = true },
		icon = E.Media.Textures.ChestPlate,
	},
	{
		key = "CONSUMABLES",
		name = L["Consumables"],
		types = { CLASS_CONSUMABLE },
		icon = E.Media.Textures.GreenPotion,
		nestByExpansion = true,
	},
	{
		key = "TRADEGOODS",
		name = L["Trade Goods"],
		types = { CLASS_TRADEGOODS, CLASS_REAGENT },
		icon = E.Media.Textures.FabricSilk,
		nestByExpansion = true,
	},
	{
		key = "GEARENHANCEMENT",
		name = L["Gear Enhancements"],
		types = { CLASS_GEM, CLASS_ITEMENHANCEMENT },
		icon = 7549094,
	},
	{
		key = "PROFESSIONS",
		name = L["Professions"],
		types = { CLASS_PROFESSION, CLASS_RECIPE },
		icon = E.Media.Textures.Catalog,
	},
	{
		key = "HOUSING",
		name = L["Housing"],
		types = { CLASS_HOUSING },
		icon = 7726459,
	},
	{
		key = "MISC",
		name = L["Miscellaneous"],
		types = { CLASS_MISC, CLASS_CONTAINER },
		isCatchAll = true,
		icon = E.Media.Textures.Backpack,
	},
}

-- Fixed default category groups: several sidebar categories collapse into
-- one combined content section, with their own indented rows underneath the
-- group's row for navigation/counts. No user-defined groups yet, no
-- collapse/expand toggle - always shown expanded, matching the reference.
module.CategoryGroups = {
	{
		key = "GROUP_ARMORY",
		name = L["Equipment"],
		icon = E.Media.Textures.ChestPlate,
		members = { "WEAPONS", "ARMOR", "SETGEAR" },
	},
}

function module:GetCategoryGroupForKey(catKey)
	local db = module.db
	if db and db.ungroupedCategories and db.ungroupedCategories[catKey] then
		return nil
	end

	for _, group in ipairs(module.CategoryGroups) do
		if not (db and db.disbandedGroups and db.disbandedGroups[group.key]) then
			for _, memberKey in ipairs(group.members) do
				if memberKey == catKey then
					return group
				end
			end
		end
	end
end

function module:FindCategoryGroup(groupKey)
	for _, group in ipairs(module.CategoryGroups) do
		if group.key == groupKey then
			return group
		end
	end
end

function module:GetGroupName(group)
	local db = module.db
	return (db and db.groupNameOverrides and db.groupNameOverrides[group.key]) or group.name
end

function module:RenameGroup(groupKey, newName)
	if not groupKey or not newName or newName == "" then
		return
	end

	local db = module.db
	db.groupNameOverrides = db.groupNameOverrides or {}
	db.groupNameOverrides[groupKey] = newName
end

function module:DisbandGroup(groupKey)
	local db = module.db
	db.disbandedGroups = db.disbandedGroups or {}
	db.disbandedGroups[groupKey] = true
end

function module:UngroupCategory(catKey)
	local db = module.db
	db.ungroupedCategories = db.ungroupedCategories or {}
	db.ungroupedCategories[catKey] = true
end

function module:IsHiddenFromAllItems(key)
	local db = module.db
	return (db and db.hiddenFromAllItems and db.hiddenFromAllItems[key]) or false
end

function module:SetHiddenFromAllItems(key, hidden)
	local db = module.db
	db.hiddenFromAllItems = db.hiddenFromAllItems or {}
	db.hiddenFromAllItems[key] = hidden or nil
end

module.PinnedCategory = {
	key = "PINNED",
	name = L["Pinned Items"],
	isPinned = true,
	icon = "friendslist-recentallies-Pin-yellow",
	isAtlas = true,
}
module.RecentCategory =
	{ key = "RECENT", name = L["Recent Items"], isRecent = true, icon = "auctionhouse-icon-clock", isAtlas = true }

function module:GetCatchAllKey()
	for _, cat in ipairs(DEFAULT_CATEGORIES) do
		if cat.isCatchAll then
			return cat.key
		end
	end
end

function module:GetCategories()
	if module._categoriesCache then
		return module._categoriesCache
	end

	local db = module.db
	local disabled = (db and db.disabledCategories) or {}
	local cats = {}

	local nameOverrides = db and db.categoryNameOverrides
	for _, cat in ipairs(DEFAULT_CATEGORIES) do
		if not disabled[cat.key] then
			local override = nameOverrides and nameOverrides[cat.key]
			if override then
				-- Shallow copy so the rename doesn't mutate the shared
				-- DEFAULT_CATEGORIES table itself.
				local copy = {}
				for k, v in pairs(cat) do
					copy[k] = v
				end
				copy.name = override
				tinsert(cats, copy)
			else
				tinsert(cats, cat)
			end
		end
	end

	local userCats = db and db.userCategories
	if userCats then
		local catchAllIndex = #cats
		for i, cat in ipairs(cats) do
			if cat.isCatchAll then
				catchAllIndex = i
				break
			end
		end

		for _, uc in ipairs(userCats) do
			if not disabled[uc.key] then
				tinsert(cats, catchAllIndex, { key = uc.key, name = uc.name, isUser = true, icon = uc.icon or 134400 })
				catchAllIndex = catchAllIndex + 1
			end
		end
	end

	module:ApplyCategoryOrder(cats)

	module._categoriesCache = cats
	return cats
end

-- Sorts by the user's saved sidebar order (from dragging), if any. A key
-- that isn't in the saved order yet (new categories, or before anything's
-- ever been reordered) keeps its existing relative position, appended after
-- every key that IS in the saved order.
function module:ApplyCategoryOrder(cats)
	local order = module.db and module.db.categoryOrder
	if not order or #order == 0 then
		return
	end

	local rank = {}
	for i, key in ipairs(order) do
		rank[key] = i
	end

	local fallbackRank = {}
	local maxRank = #order
	for i, cat in ipairs(cats) do
		fallbackRank[cat] = maxRank + i
	end

	tsort(cats, function(a, b)
		return (rank[a.key] or fallbackRank[a]) < (rank[b.key] or fallbackRank[b])
	end)
end

-- Moves draggedKey to sit right before targetKey in the saved sidebar order,
-- seeding that order from the current (still-default, if untouched) category
-- sequence the first time anything gets dragged.
function module:ReorderCategory(draggedKey, targetKey)
	if not draggedKey or not targetKey or draggedKey == targetKey then
		return
	end

	local db = module.db
	db.categoryOrder = db.categoryOrder or {}
	local order = db.categoryOrder

	if #order == 0 then
		for _, cat in ipairs(module:GetCategories()) do
			tinsert(order, cat.key)
		end
	end

	local fromIndex
	for i, key in ipairs(order) do
		if key == draggedKey then
			fromIndex = i
			break
		end
	end

	if fromIndex then
		tremove(order, fromIndex)
	end

	local toIndex
	for i, key in ipairs(order) do
		if key == targetKey then
			toIndex = i
			break
		end
	end

	tinsert(order, toIndex or (#order + 1), draggedKey)

	module:InvalidateCategoryCache()
end

function module:FindCategory(key)
	if not key then
		return nil
	end

	for _, cat in ipairs(module:GetCategories()) do
		if cat.key == key then
			return cat
		end
	end
end

function module:InvalidateCategoryCache()
	module._categoriesCache = nil
end

-- itemID -> equipment-set name, rebuilt once per collection pass
-- (CollectItemsFromBags in CategoryFrame.lua) and consulted twice: once here
-- to route a set member into the Item Set Gear category ahead of the normal
-- Weapons/Armor type walk, and again by CategoryFrame.lua to label the
-- sub-header an item's row nests under inside that category.
local equipmentSetItemMap = {}
local function RebuildEquipmentSetItemMap()
	wipe(equipmentSetItemMap)

	if not C_EquipmentSet or not C_EquipmentSet.GetEquipmentSetIDs or not C_EquipmentSet.GetItemIDs then
		return
	end

	-- Defensive: guards against any signature mismatch on this API across
	-- client versions - worst case, equipment-set nesting silently no-ops.
	pcall(function()
		local setIDs = C_EquipmentSet.GetEquipmentSetIDs()
		for _, setID in ipairs(setIDs or {}) do
			local name = C_EquipmentSet.GetEquipmentSetInfo(setID)
			local itemIDs = C_EquipmentSet.GetItemIDs(setID)
			if name and itemIDs then
				for _, memberItemID in pairs(itemIDs) do
					if memberItemID and memberItemID ~= 0 then
						equipmentSetItemMap[memberItemID] = name
					end
				end
			end
		end
	end)
end
module.RebuildEquipmentSetItemMap = RebuildEquipmentSetItemMap

function module:GetEquipmentSetName(itemID)
	return itemID and equipmentSetItemMap[itemID]
end

function module:ClassifyItem(bagID, slotID, itemID, itemLink)
	if not itemLink then
		return nil
	end

	if bagID == module.ReagentContainer then
		for _, cat in ipairs(module:GetCategories()) do
			if cat.isReagentBag then
				return cat.key
			end
		end
	end

	local db = module.db
	local assignedKey = itemID and db and db.itemAssignments and db.itemAssignments[itemID]
	if assignedKey and module:FindCategory(assignedKey) then
		return assignedKey
	end

	if bagID and slotID and C_Container_GetContainerItemQuestInfo then
		local questInfo = C_Container_GetContainerItemQuestInfo(bagID, slotID)
		if questInfo and (questInfo.isQuestItem or questInfo.questID) then
			for _, cat in ipairs(module:GetCategories()) do
				if cat.isQuest then
					return cat.key
				end
			end
		end
	end

	local _, _, _, equipLoc, _, classID = C_Item_GetItemInfoInstant(itemLink)
	if not classID then
		return module:GetCatchAllKey()
	end

	-- Equipment-set membership takes priority over the normal Weapons/Armor
	-- type walk below (matches the reference's own precedence) - a trinket,
	-- weapon or armor piece that's part of any saved set lands in Item Set
	-- Gear instead of its usual category.
	if (classID == CLASS_ARMOR or classID == CLASS_WEAPON) and module:GetEquipmentSetName(itemID) then
		for _, cat in ipairs(module:GetCategories()) do
			if cat.isSetGear then
				return cat.key
			end
		end
	end

	for _, cat in ipairs(module:GetCategories()) do
		if cat.types and not cat.isReagentBag and not cat.isSetGear then
			local matched = false

			for _, t in ipairs(cat.types) do
				if t == classID then
					matched = true
					break
				end
			end

			if not matched and cat.equipSlots and equipLoc and cat.equipSlots[equipLoc] then
				matched = true
			end

			if matched and cat.excludeEquipSlots and equipLoc and cat.excludeEquipSlots[equipLoc] then
				matched = false
			end

			if matched then
				return cat.key
			end
		end
	end

	return module:GetCatchAllKey()
end

function module:AssignItemToCategory(itemID, key)
	if not itemID then
		return
	end

	local db = module.db
	db.itemAssignments = db.itemAssignments or {}
	db.itemAssignments[itemID] = key
end

function module:ClearItemAssignment(itemID)
	if not itemID then
		return
	end

	local db = module.db
	if db.itemAssignments then
		db.itemAssignments[itemID] = nil
	end
end

function module:IsCategoryDisabled(key)
	local db = module.db
	return db and db.disabledCategories and db.disabledCategories[key] or false
end

function module:SetCategoryDisabled(key, disabled)
	local db = module.db
	db.disabledCategories = db.disabledCategories or {}
	db.disabledCategories[key] = disabled or nil
	module:InvalidateCategoryCache()
end

local userCategorySeq = 0
function module:AddUserCategory(name)
	if not name or name == "" then
		return
	end

	local db = module.db
	db.userCategories = db.userCategories or {}

	userCategorySeq = userCategorySeq + 1
	local key = format("USER_%d_%d", floor(GetTime()), userCategorySeq)

	tinsert(db.userCategories, { key = key, name = name })
	module:InvalidateCategoryCache()

	return key
end

function module:RenameCategory(key, newName)
	if not key or not newName or newName == "" then
		return
	end

	local db = module.db
	if db.userCategories then
		for _, uc in ipairs(db.userCategories) do
			if uc.key == key then
				uc.name = newName
				module:InvalidateCategoryCache()
				return true
			end
		end
	end

	-- Default (non-user) category: persisted as a name override instead of
	-- mutating the shared DEFAULT_CATEGORIES table.
	db.categoryNameOverrides = db.categoryNameOverrides or {}
	db.categoryNameOverrides[key] = newName
	module:InvalidateCategoryCache()
	return true
end

function module:SetUserCategoryIcon(key, icon)
	if not key or not icon then
		return
	end

	local db = module.db
	if db.userCategories then
		for _, uc in ipairs(db.userCategories) do
			if uc.key == key then
				uc.icon = icon
				module:InvalidateCategoryCache()
				return true
			end
		end
	end
end

function module:RemoveUserCategory(key)
	local db = module.db
	if not db.userCategories then
		return
	end

	for i, uc in ipairs(db.userCategories) do
		if uc.key == key then
			tremove(db.userCategories, i)

			if db.itemAssignments then
				for itemID, assignedKey in pairs(db.itemAssignments) do
					if assignedKey == key then
						db.itemAssignments[itemID] = nil
					end
				end
			end

			module:InvalidateCategoryCache()
			return true
		end
	end
end

local function CharKey()
	return E.myname .. "-" .. E.myrealm
end

function module:GetPinnedItems()
	local db = module.db
	db.pinnedItemsByChar = db.pinnedItemsByChar or {}

	local key = CharKey()
	db.pinnedItemsByChar[key] = db.pinnedItemsByChar[key] or {}

	return db.pinnedItemsByChar[key]
end

function module:IsItemPinned(itemID)
	if not itemID then
		return false
	end
	return module:GetPinnedItems()[itemID] and true or false
end

function module:TogglePinned(itemID)
	if not itemID then
		return false
	end

	local pinned = module:GetPinnedItems()
	if pinned[itemID] then
		pinned[itemID] = nil
	else
		pinned[itemID] = true
	end

	return pinned[itemID] and true or false
end
