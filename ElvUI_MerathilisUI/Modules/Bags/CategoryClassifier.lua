local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

local ipairs, pairs = ipairs, pairs
local tinsert, tremove = tinsert, tremove
local tsort, tconcat = table.sort, table.concat
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
module.ReagentContainer = BagIndex.ReagentBag or math.huge

-- Character bank tabs - the bank is no longer a single flat container, it's
-- 6 tab-bags, same unified Container API as regular bags just with different
-- bagIDs.
module.BankBagIDs = {}
module.BankBagIDSet = {}
for i = 1, 6 do
	local id = BagIndex["CharacterBankTab_" .. i]
	if id then
		tinsert(module.BankBagIDs, id)
		module.BankBagIDSet[id] = true
	end
end

-- Warband/Account Bank tabs - same unified Container API, separate bagID
-- range (12-16) from the character bank tabs above, reached through the same
-- bank interaction session (there's no separate open/close event for it).
module.WarbandBagIDs = {}
module.WarbandBagIDSet = {}
for i = 1, 5 do
	local id = BagIndex["AccountBankTab_" .. i]
	if id then
		tinsert(module.WarbandBagIDs, id)
		module.WarbandBagIDSet[id] = true
	end
end

-- Category list/order/matching rules kept 1:1 with the reference addon's own
-- hardcoded defaults (types = Enum.ItemClass numeric IDs, same precedence:
-- Reagent Bag > Item Set Gear > Quest > general type walk > catch-all). Icons
-- stay our own ElvUI-media choices where we already had a fitting one;
-- ElvUI's texture set has nothing for Item Set Gear/Gear Enhancements/Housing
-- (checked E.Media.Textures - it's UI chrome, not thematic icons), so those
-- use Blizzard icons instead. Item Set Gear uses the flat "bags-icon-
-- equipment" atlas - the same icon family already used for JunkIcon below,
-- and Blizzard's own default bag frame uses it for exactly this "equippable
-- gear" grouping. Gear Enhancements/Housing use raw item-icon fileIDs
-- instead (a jewelcrafting cut gem, and Blizzard's own "spell_housing" icon
-- for the upcoming Housing feature) - both already fit their category well
-- and no equivalent flat atlas icon exists for either concept.
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
		icon = "bags-icon-equipment",
		isAtlas = true,
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

-- Built-in category groups: several sidebar categories collapse into one
-- combined content section, with their own indented rows underneath the
-- group's row for navigation/counts. Users can build their own groups on
-- top of these (db.customGroups) and add categories to any group
-- (db.groupExtraMembers); no collapse/expand toggle, always shown expanded.
module.DefaultCategoryGroups = {
	{
		key = "GROUP_ARMORY",
		name = L["Equipment"],
		icon = E.Media.Textures.ChestPlate,
		members = { "WEAPONS", "ARMOR", "SETGEAR" },
	},
}

-- Auto-generated names follow the member list ("Armor & Consumables") and
-- are regenerated whenever membership changes, unless the user renamed the
-- group (db.groupNameOverrides) - then their name wins for good.
local function BuildAutoGroupName(memberKeys)
	local names = {}
	for _, memberKey in ipairs(memberKeys) do
		local cat = module:FindCategory(memberKey)
		tinsert(names, cat and cat.name or memberKey)
	end

	if #names == 0 then
		return L["Group"]
	elseif #names == 1 then
		return names[1]
	end

	local last = tremove(names)
	return format("%s & %s", tconcat(names, ", "), last)
end

-- Resolves a group's stored member list into the keys that actually count
-- right now: categories the user pulled out are dropped, categories added
-- to a built-in group are appended.
local function ResolveGroupMembers(group, claimed)
	local db = module.db
	local ungrouped = (db and db.ungroupedCategories) or {}
	local members = {}

	local function AddMember(memberKey)
		if ungrouped[memberKey] or (claimed and claimed[memberKey]) then
			return
		end
		if module:FindCategory(memberKey) then
			tinsert(members, memberKey)
		end
	end

	for _, memberKey in ipairs(group.members) do
		AddMember(memberKey)
	end

	local extra = db and db.groupExtraMembers and db.groupExtraMembers[group.key]
	if extra then
		for _, memberKey in ipairs(extra) do
			AddMember(memberKey)
		end
	end

	return members
end

-- A group needs at least two members to exist as a group; with one left it
-- renders as that plain category again (same as the reference behavior).
function module:GetCategoryGroups()
	local db = module.db
	local groups = {}

	local function Add(group, claimed)
		local members = ResolveGroupMembers(group, claimed)
		if #members < 2 then
			return
		end

		-- A custom group has no icon of its own: it borrows its first
		-- member's, which has to carry that member's isAtlas flag with it.
		local icon, isAtlas = group.icon, group.isAtlas
		if not icon then
			local firstMember = module:FindCategory(members[1])
			icon = firstMember and firstMember.icon
			isAtlas = firstMember and firstMember.isAtlas
		end

		tinsert(groups, {
			key = group.key,
			name = (db and db.groupNameOverrides and db.groupNameOverrides[group.key])
				or group.name
				or BuildAutoGroupName(members),
			icon = icon,
			isAtlas = isAtlas,
			isUserGroup = group.isUserGroup,
			members = members,
		})
	end

	-- Custom groups are resolved first and claim their members, so a
	-- category the user moved out of a built-in group into one of their own
	-- doesn't end up listed in both.
	local claimed = {}
	if db and db.customGroups then
		for _, group in ipairs(db.customGroups) do
			for _, memberKey in ipairs(group.members) do
				claimed[memberKey] = true
			end
		end

		for _, group in ipairs(db.customGroups) do
			Add({ key = group.key, members = group.members, isUserGroup = true })
		end
	end

	for _, group in ipairs(module.DefaultCategoryGroups) do
		if not (db and db.disbandedGroups and db.disbandedGroups[group.key]) then
			Add(group, claimed)
		end
	end

	return groups
end

function module:GetCategoryGroupForKey(catKey)
	for _, group in ipairs(module:GetCategoryGroups()) do
		for _, memberKey in ipairs(group.members) do
			if memberKey == catKey then
				return group
			end
		end
	end
end

function module:FindCategoryGroup(groupKey)
	for _, group in ipairs(module:GetCategoryGroups()) do
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

local function FindCustomGroup(groupKey)
	local db = module.db
	if not db or not db.customGroups then
		return nil
	end

	for index, group in ipairs(db.customGroups) do
		if group.key == groupKey then
			return group, index
		end
	end
end

-- Creates a group out of two categories that are not in one yet. Keys are
-- generated (not derived from the name) so a later rename never orphans the
-- stored overrides/hidden-in-All-Items flags.
function module:CreateCategoryGroup(catKeyA, catKeyB)
	local db = module.db
	if not catKeyA or not catKeyB or catKeyA == catKeyB then
		return nil
	end

	db.customGroups = db.customGroups or {}
	db.nextGroupID = (db.nextGroupID or 0) + 1

	local group = { key = "USERGROUP_" .. db.nextGroupID, members = { catKeyA, catKeyB } }
	tinsert(db.customGroups, group)

	if db.ungroupedCategories then
		db.ungroupedCategories[catKeyA] = nil
		db.ungroupedCategories[catKeyB] = nil
	end

	return group.key
end

function module:AddCategoryToGroup(catKey, groupKey)
	local db = module.db
	if not catKey or not groupKey then
		return
	end

	if db.ungroupedCategories then
		db.ungroupedCategories[catKey] = nil
	end

	local customGroup = FindCustomGroup(groupKey)
	if customGroup then
		for _, memberKey in ipairs(customGroup.members) do
			if memberKey == catKey then
				return
			end
		end
		tinsert(customGroup.members, catKey)
		return
	end

	db.groupExtraMembers = db.groupExtraMembers or {}
	db.groupExtraMembers[groupKey] = db.groupExtraMembers[groupKey] or {}
	for _, memberKey in ipairs(db.groupExtraMembers[groupKey]) do
		if memberKey == catKey then
			return
		end
	end
	tinsert(db.groupExtraMembers[groupKey], catKey)
end

function module:DisbandGroup(groupKey)
	local db = module.db

	local _, index = FindCustomGroup(groupKey)
	if index then
		tremove(db.customGroups, index)
	else
		db.disbandedGroups = db.disbandedGroups or {}
		db.disbandedGroups[groupKey] = true
	end

	if db.groupExtraMembers then
		db.groupExtraMembers[groupKey] = nil
	end
	if db.groupNameOverrides then
		db.groupNameOverrides[groupKey] = nil
	end
end

function module:UngroupCategory(catKey)
	local db = module.db
	local group = module:GetCategoryGroupForKey(catKey)

	-- Removing a member from a custom group drops it from that group's own
	-- list; the ungrouped flag alone would keep resurrecting it whenever the
	-- same category is added to another group later.
	local customGroup = group and FindCustomGroup(group.key)
	if customGroup then
		for index, memberKey in ipairs(customGroup.members) do
			if memberKey == catKey then
				tremove(customGroup.members, index)
				break
			end
		end
	end

	if group and db.groupExtraMembers and db.groupExtraMembers[group.key] then
		for index, memberKey in ipairs(db.groupExtraMembers[group.key]) do
			if memberKey == catKey then
				tremove(db.groupExtraMembers[group.key], index)
				break
			end
		end
	end

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
local equipmentSetIconMap = {}
local function RebuildEquipmentSetItemMap()
	wipe(equipmentSetItemMap)
	wipe(equipmentSetIconMap)

	if not C_EquipmentSet or not C_EquipmentSet.GetEquipmentSetIDs or not C_EquipmentSet.GetItemIDs then
		return
	end

	-- Defensive: guards against any signature mismatch on this API across
	-- client versions - worst case, equipment-set nesting silently no-ops.
	pcall(function()
		local setIDs = C_EquipmentSet.GetEquipmentSetIDs()
		for _, setID in ipairs(setIDs or {}) do
			local name, iconFileID = C_EquipmentSet.GetEquipmentSetInfo(setID)
			local itemIDs = C_EquipmentSet.GetItemIDs(setID)
			if name and iconFileID then
				equipmentSetIconMap[name] = iconFileID
			end
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

function module:GetEquipmentSetIcon(name)
	return name and equipmentSetIconMap[name]
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

-- Only meaningful for a default (non-user) category - a user category's own
-- name isn't an "override" of anything, it's just deleted along with the
-- category via RemoveUserCategory.
function module:ResetCategoryName(key)
	local db = module.db
	if db.categoryNameOverrides and db.categoryNameOverrides[key] then
		db.categoryNameOverrides[key] = nil
		module:InvalidateCategoryCache()
		return true
	end
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
