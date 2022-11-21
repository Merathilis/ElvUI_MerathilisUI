local _, ns = ...
local MER, F, E, L, V, P, G = unpack(ns)
local module = MER:GetModule('MER_Bags')

local C_ToyBox_GetToyInfo = C_ToyBox.GetToyInfo
local C_Item_IsAnimaItemByID = C_Item.IsAnimaItemByID
local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID

-- Custom filter
local CustomFilterList = {
	[37863] = false,
	[187532] = false,
	[141333] = true,
	[141446] = true,
	[153646] = true,
	[153647] = true,
	[161053] = true,
}

local function isCustomFilter(item)
	if not E.db.mui.bags.ItemFilter then return end
	return CustomFilterList[item.id]
end

-- Default filter
local function isItemInBag(item)
	return item.bagId >= 0 and item.bagId <= 4
end

local function isItemInBagReagent(item)
	return item.bagId == 5
end

local function isItemInBank(item)
	return item.bagId == -1 or item.bagId >= 5 and item.bagId <= 11
end

local function isItemJunk(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterJunk then return end
	return (item.quality == Enum.ItemQuality.Poor or E.global.mui.bags.CustomJunkList[item.id]) and item.hasPrice and not module:IsPetTrashCurrency(item.id)
end

local function isItemEquipSet(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterEquipSet then return end
	return item.isInSet
end

local function isAzeriteArmor(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterAzerite then return end
	if not item.link then return end
	return C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID(item.link)
end


local iLvlClassIDs = {
	[Enum.ItemClass.Gem] = Enum.ItemGemSubclass.Artifactrelic,
	[Enum.ItemClass.Armor] = 0,
	[Enum.ItemClass.Weapon] = 0,
}
function module:IsItemHasLevel(item)
	local index = iLvlClassIDs[item.classID]
	return index and (index == 0 or index == item.subClassID)
end

local function isItemEquipment(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterEquipment then return end
	return item.link and item.quality and item.quality > Enum.ItemQuality.Common and module:IsItemHasLevel(item)
end

local consumableIDs = {
	[Enum.ItemClass.Consumable] = true,
	[Enum.ItemClass.ItemEnhancement] = true,
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
	return item.quality == Enum.ItemQuality.Legendary
end

local isPetToy = {
	[174925] = true,
}

local collectionIDs = {
	[Enum.ItemMiscellaneousSubclass.Mount] = Enum.ItemClass.Miscellaneous,
	[Enum.ItemMiscellaneousSubclass.CompanionPet] = Enum.ItemClass.Miscellaneous,
}
local function isMountOrPet(item)
	return not isPetToy[item.id] and item.subClassID and collectionIDs[item.subClassID] == item.classID
end

local petTrashCurrenies = {
	[3300] = true,
	[3670] = true,
	[6150] = true,
	[11406] = true,
	[11944] = true,
	[25402] = true,
	[36812] = true,
	[62072] = true,
	[67410] = true,
}
function module:IsPetTrashCurrency(itemID)
	return E.db.mui.bags.PetTrash and petTrashCurrenies[itemID]
end

local function isItemCollection(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterCollection then return end
	return item.id and C_ToyBox_GetToyInfo(item.id) or isMountOrPet(item) or module:IsPetTrashCurrency(item.id)
end

local function isItemCustom(item, index)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterFavourite then return end
	local customIndex = item.id and E.db.mui.bags.CustomItems[item.id]
	return customIndex and customIndex == index
end

local emptyBags = { [0] = true, [11] = true }
local function isEmptySlot(item)
	if not E.db.mui.bags.GatherEmpty then return end
	return module.initComplete and not item.texture and emptyBags[module.BagsType[item.bagId]]
end

local function isTradeGoods(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterGood then return end
	if isCustomFilter(item) == false then return end
	return item.classID == Enum.ItemClass.Tradegoods
end

local function isQuestItem(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterQuest then return end
	return item.questID or item.isQuestItem
end

local function isAnimaItem(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterAnima then return end
	return item.id and C_Item_IsAnimaItemByID(item.id)
end

local relicSpellIDs = {
	[356931] = true,
	[356933] = true,
	[356934] = true,
	[356935] = true,
	[356936] = true,
	[356937] = true,
	[356938] = true,
	[356939] = true,
	[356940] = true,
}
local function isKorthiaRelicByID(itemID)
	local _, spellID = GetItemSpell(itemID)
	return spellID and relicSpellIDs[spellID]
end

local function isKorthiaRelic(item)
	if not E.db.mui.bags.ItemFilter then return end
	if not E.db.mui.bags.FilterRelic then return end
	return item.id and isKorthiaRelicByID(item.id)
end

function module:GetFilters()
	local filters = {}

	filters.onlyBags = function(item) return isItemInBag(item) and not isEmptySlot(item) end
	filters.bagAzeriteItem = function(item) return isItemInBag(item) and isAzeriteArmor(item) end
	filters.bagEquipment = function(item) return isItemInBag(item) and isItemEquipment(item) end
	filters.bagEquipSet = function(item) return isItemInBag(item) and isItemEquipSet(item) end
	filters.bagConsumable = function(item) return isItemInBag(item) and isItemConsumable(item) end
	filters.bagsJunk = function(item) return isItemInBag(item) and isItemJunk(item) end
	filters.onlyBank = function(item) return isItemInBank(item) and not isEmptySlot(item) end
	filters.bankAzeriteItem = function(item) return isItemInBank(item) and isAzeriteArmor(item) end
	filters.bankLegendary = function(item) return isItemInBank(item) and isItemLegendary(item) end
	filters.bankEquipment = function(item) return isItemInBank(item) and isItemEquipment(item) end
	filters.bankEquipSet = function(item) return isItemInBank(item) and isItemEquipSet(item) end
	filters.bankConsumable = function(item) return isItemInBank(item) and isItemConsumable(item) end
	filters.onlyReagent = function(item) return item.bagId == -3 and not isEmptySlot(item) end
	filters.bagCollection = function(item) return isItemInBag(item) and isItemCollection(item) end
	filters.bankCollection = function(item) return isItemInBank(item) and isItemCollection(item) end
	filters.bagGoods = function(item) return isItemInBag(item) and isTradeGoods(item) end
	filters.bankGoods = function(item) return isItemInBank(item) and isTradeGoods(item) end
	filters.bagQuest = function(item) return isItemInBag(item) and isQuestItem(item) end
	filters.bankQuest = function(item) return isItemInBank(item) and isQuestItem(item) end
	filters.bagAnima = function(item) return isItemInBag(item) and isAnimaItem(item) end
	filters.bankAnima = function(item) return isItemInBank(item) and isAnimaItem(item) end
	filters.bagRelic = function(item) return isItemInBag(item) and isKorthiaRelic(item) end
	filters.onlyBagReagent = function(item) return isItemInBagReagent(item) and not isEmptySlot(item) end

	for i = 1, 5 do
		filters["bagCustom" .. i] = function(item) return isItemInBag(item) and isItemCustom(item, i) end
		filters["bankCustom" .. i] = function(item) return isItemInBank(item) and isItemCustom(item, i) end
	end

	return filters
end
