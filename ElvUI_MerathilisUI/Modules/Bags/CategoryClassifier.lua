local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

local ipairs, pairs = ipairs, pairs
local tinsert, tremove = tinsert, tremove
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

local ITEMQUALITY_POOR = Enum.ItemQuality.Poor

local BagIndex = Enum.BagIndex
module.ReagentContainer = (E.Retail and BagIndex and BagIndex.ReagentBag) or math.huge

local DEFAULT_CATEGORIES = {
	{
		key = "WEAPONS",
		name = L["Weapons & Trinkets"],
		types = { CLASS_WEAPON },
		equipSlots = { INVTYPE_TRINKET = true },
		icon = [[Interface\Icons\INV_Sword_04]],
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
	},
	{
		key = "TRADEGOODS",
		name = L["Trade Goods"],
		types = { CLASS_TRADEGOODS, CLASS_REAGENT, CLASS_GEM, CLASS_ITEMENHANCEMENT },
		icon = E.Media.Textures.FabricSilk,
	},
	{
		key = "RECIPES",
		name = L["Recipes"],
		types = { CLASS_RECIPE },
		icon = [[Interface\Icons\INV_Misc_Book_09]],
	},
	{
		key = "REAGENTBAG",
		name = L["Reagent Bag"],
		isReagentBag = true,
		icon = 132854,
	},
	{
		key = "QUEST",
		name = L["Quest Items"],
		types = { CLASS_QUEST },
		isQuest = true,
		icon = E.Media.Textures.Scroll,
	},
	{
		key = "JUNK",
		name = L["Junk"],
		isJunk = true,
		icon = E.Media.Textures.GoldCoins,
	},
	{
		key = "MISC",
		name = L["Miscellaneous"],
		types = { CLASS_MISC, CLASS_CONTAINER },
		isCatchAll = true,
		icon = E.Media.Textures.Backpack,
	},
}

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

	for _, cat in ipairs(DEFAULT_CATEGORIES) do
		if not disabled[cat.key] then
			tinsert(cats, cat)
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

	module._categoriesCache = cats
	return cats
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

function module:ClassifyItem(bagID, slotID, itemID, itemLink, quality, hasNoValue)
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

	-- Same definition ElvUI's own bags use: grey/Poor quality with an actual
	-- sell value (excludes quest-bound poor items and other unsellable junk).
	if quality == ITEMQUALITY_POOR and not hasNoValue then
		for _, cat in ipairs(module:GetCategories()) do
			if cat.isJunk then
				return cat.key
			end
		end
	end

	local _, _, _, equipLoc, _, classID = C_Item_GetItemInfoInstant(itemLink)
	if not classID then
		return module:GetCatchAllKey()
	end

	for _, cat in ipairs(module:GetCategories()) do
		if cat.types and not cat.isReagentBag then
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
