local _, ns = ...
local MER, F, E, L, V, P, G = unpack(ns)
local module = MER:GetModule('MER_Bags')
local cargBags = ns.cargBags

local LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_LEGENDARY = LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_LEGENDARY
local LE_ITEM_CLASS_CONSUMABLE, LE_ITEM_CLASS_ITEM_ENHANCEMENT = LE_ITEM_CLASS_CONSUMABLE, LE_ITEM_CLASS_ITEM_ENHANCEMENT
local LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR, LE_ITEM_CLASS_TRADEGOODS = LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR, LE_ITEM_CLASS_TRADEGOODS
local AmmoEquipLoc = _G.INVTYPE_AMMO

-- Custom filter for consumable
local CustomFilterList = {
	[12450] = true,
	[12451] = true,
	[12455] = true,
	[12457] = true,
	[12458] = true,
	[12459] = true,
	[12460] = true,
	[10646] = true,
	[23737] = true,
	[23827] = true,

	[4366] = true,
	[12662] = true,
	[20520] = true,
	[16023] = true,
	[22797] = true,
}

local function isCustomFilter(item)
	if not E.db.mui.bags.ItemFilter then return end
	return CustomFilterList[item.id]
end

-- Default filter
local function isItemInBag(item)
	return item.bagID >= 0 and item.bagID <= 4
end

local function isItemInBank(item)
	return item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11
end

local function isItemJunk(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterJunk then return end
	return (item.quality == LE_ITEM_QUALITY_POOR or E.global.mui.bags.CustomJunkList[item.id]) and item.hasPrice
end

local function isItemEquipSet(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterEquipSet then return end
	return item.isInSet
end

local function isItemAmmo(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterAmmo then return end

	if E.db.mui.bags.GatherEmpty and not item.texture then
		return false
	end

	if E.myclass == "HUNTER" then
		return item.equipLoc == AmmoEquipLoc or cargBags.BagGroups[item.bagID] == -1
	elseif E.myclass == "WARLOCK" then
		return item.id == 6265 or cargBags.BagGroups[item.bagID] == 1
	end
end

local iLvlClassIDs = {
	[LE_ITEM_CLASS_ARMOR] = true,
	[LE_ITEM_CLASS_WEAPON] = true,
}
function module:IsItemHasLevel(item)
	return iLvlClassIDs[item.classID]
end

local function isItemEquipment(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterEquipment then return end
	return item.link and item.quality > LE_ITEM_QUALITY_COMMON and module:IsItemHasLevel(item)
end

local consumableIDs = {
	[LE_ITEM_CLASS_CONSUMABLE] = true,
	[LE_ITEM_CLASS_ITEM_ENHANCEMENT] = true,
}
local function isItemConsumable(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterConsumable then return end
	if isCustomFilter(item) == false then return end
	return isCustomFilter(item) or consumableIDs[item.classID]
end

local function isItemLegendary(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterLegendary then return end
	return item.quality == LE_ITEM_QUALITY_LEGENDARY
end

local collectionBlackList = {}
local collectionIDs = {
	[LE_ITEM_MISCELLANEOUS_MOUNT] = LE_ITEM_CLASS_MISCELLANEOUS,
	[LE_ITEM_MISCELLANEOUS_COMPANION_PET] = LE_ITEM_CLASS_MISCELLANEOUS,
}
local function isMountOrPet(item)
	return not collectionBlackList[item.id] and item.subClassID and collectionIDs[item.subClassID] == item.classID
end

local function isItemCollection(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterCollection then return end
	return isMountOrPet(item)
end

local function isItemCustom(item, index)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterFavourite then return end
	local customIndex = item.id and E.db.mui.bags.CustomItems[item.id]
	return customIndex and customIndex == index
end

local function isEmptySlot(item)
	if not E.db.mui.bags.GatherEmpty then return end
	return module.initComplete and not item.texture and module.BagsType[item.bagID] == 0
end

local function isItemKeyRing(item)
	return item.bagID == -2
end

local function isTradeGoods(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterGood then return end
	if isCustomFilter(item) == false then return end
	return item.classID == LE_ITEM_CLASS_TRADEGOODS
end

local function isQuestItem(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterQuest then return end
	return item.questID or item.isQuestItem
end

function module:GetFilters()
	local filters = {}

	filters.onlyBags = function(item) return isItemInBag(item) and not isEmptySlot(item) end
	filters.bagAmmo = function(item) return isItemInBag(item) and isItemAmmo(item) end
	filters.bagEquipment = function(item) return isItemInBag(item) and isItemEquipment(item) end
	filters.bagEquipSet = function(item) return isItemInBag(item) and isItemEquipSet(item) end
	filters.bagConsumable = function(item) return isItemInBag(item) and isItemConsumable(item) end
	filters.bagsJunk = function(item) return isItemInBag(item) and isItemJunk(item) end
	filters.onlyBank = function(item) return isItemInBank(item) and not isEmptySlot(item) end
	filters.bankAmmo = function(item) return isItemInBank(item) and isItemAmmo(item) end
	filters.bankLegendary = function(item) return isItemInBank(item) and isItemLegendary(item) end
	filters.bankEquipment = function(item) return isItemInBank(item) and isItemEquipment(item) end
	filters.bankEquipSet = function(item) return isItemInBank(item) and isItemEquipSet(item) end
	filters.bankConsumable = function(item) return isItemInBank(item) and isItemConsumable(item) end
	filters.onlyReagent = function(item) return item.bagID == -3 end
	filters.onlyKeyring = function(item) return isItemKeyRing(item) end
	filters.bagCollection = function(item) return isItemInBag(item) and isItemCollection(item) end
	filters.bankCollection = function(item) return isItemInBank(item) and isItemCollection(item) end
	filters.bagGoods = function(item) return isItemInBag(item) and isTradeGoods(item) end
	filters.bankGoods = function(item) return isItemInBank(item) and isTradeGoods(item) end
	filters.bagQuest = function(item) return isItemInBag(item) and isQuestItem(item) end
	filters.bankQuest = function(item) return isItemInBank(item) and isQuestItem(item) end

	for i = 1, 5 do
		filters["bagCustom" .. i] = function(item) return isItemInBag(item) and isItemCustom(item, i) end
		filters["bankCustom" .. i] = function(item) return isItemInBank(item) and isItemCustom(item, i) end
	end

	return filters
end
