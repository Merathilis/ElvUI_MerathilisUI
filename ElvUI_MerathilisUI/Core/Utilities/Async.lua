local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

MER.Utilities.Async = {}
local U = MER.Utilities.Async

local ipairs = ipairs
local pairs = pairs
local type = type

local Item = Item
local Spell = Spell

local cache = {
	item = {},
	spell = {},
}

function U.WithItemID(itemID, callback)
	if type(itemID) ~= "number" then
		return
	end

	if not callback then
		callback = function(...) end
	end

	if type(callback) ~= "function" then
		return
	end

	if cache.item[itemID] then
		callback(cache.item[itemID])
		return cache.item[itemID]
	end

	local itemInstance = Item:CreateFromItemID(itemID)
	if itemInstance:IsItemEmpty() then
		F.Developer.LogDebug("Failed to create item instance for itemID: " .. itemID)
		return
	end

	itemInstance:ContinueOnItemLoad(function()
		callback(itemInstance)
	end)

	cache.item[itemID] = itemInstance

	return itemInstance
end

function U.WithSpellID(spellID, callback)
	if type(spellID) ~= "number" then
		return
	end

	if not callback then
		callback = function(...) end
	end

	if type(callback) ~= "function" then
		return
	end

	if cache.spell[spellID] then
		callback(cache.spell[spellID])
		return cache.spell[spellID]
	end

	local spellInstance = Spell:CreateFromSpellID(spellID)

	if spellInstance:IsSpellEmpty() then
		F.Developer.LogDebug("Failed to create spell instance for spellID: " .. spellID)
		return
	end

	spellInstance:ContinueOnSpellLoad(function()
		callback(spellInstance)
	end)

	cache.spell[spellID] = spellInstance

	return spellInstance
end

function U.WithItemIDTable(itemIDTable, tType, callback, tableCallback)
	if type(itemIDTable) ~= "table" then
		return
	end

	if not callback then
		callback = function(...) end
	end

	if type(callback) ~= "function" then
		return
	end

	if not tableCallback then
		tableCallback = function(...) end
	end

	if type(tableCallback) ~= "function" then
		return
	end

	if type(tType) ~= "string" then
		tType = "value"
	end

	local totalItems = 0
	local completedItems = 0
	local results = {}

	-- Count total items first
	if tType == "list" then
		totalItems = #itemIDTable
	elseif tType == "value" then
		for _ in pairs(itemIDTable) do
			totalItems = totalItems + 1
		end
	elseif tType == "key" then
		for _, value in pairs(itemIDTable) do
			if value then
				totalItems = totalItems + 1
			end
		end
	end

	local function onItemComplete(itemID, itemInstance)
		completedItems = completedItems + 1
		results[itemID] = itemInstance

		-- Call individual callback
		callback(itemInstance)

		-- Check if all items are complete
		if completedItems >= totalItems then
			tableCallback(results, itemIDTable)
		end
	end

	if tType == "list" then
		for _, itemID in ipairs(itemIDTable) do
			U.WithItemID(itemID, function(itemInstance)
				onItemComplete(itemID, itemInstance)
			end)
		end
	elseif tType == "value" then
		for _, itemID in pairs(itemIDTable) do
			U.WithItemID(itemID, function(itemInstance)
				onItemComplete(itemID, itemInstance)
			end)
		end
	elseif tType == "key" then
		for itemID, value in pairs(itemIDTable) do
			if value then
				U.WithItemID(itemID, function(itemInstance)
					onItemComplete(itemID, itemInstance)
				end)
			end
		end
	end

	-- Handle empty table case
	if totalItems == 0 then
		tableCallback({}, itemIDTable)
	end
end

function U.WithSpellIDTable(spellIDTable, tType, callback)
	if type(spellIDTable) ~= "table" then
		return
	end

	if not callback then
		callback = function(...) end
	end

	if type(callback) ~= "function" then
		return
	end

	if type(tType) ~= "string" then
		tType = "value"
	end

	if tType == "list" then
		for _, spellID in ipairs(spellIDTable) do
			U.WithSpellID(spellID, callback)
		end
	end

	if tType == "value" then
		for _, spellID in pairs(spellIDTable) do
			U.WithSpellID(spellID, callback)
		end
	end

	if tType == "key" then
		for spellID, _ in pairs(spellIDTable) do
			U.WithSpellID(spellID, callback)
		end
	end
end

function U.WithItemSlotID(itemSlotID, callback)
	if type(itemSlotID) ~= "number" then
		return
	end

	if not callback then
		callback = function(...) end
	end

	if type(callback) ~= "function" then
		return
	end

	local itemInstance = Item:CreateFromEquipmentSlot(itemSlotID)
	if itemInstance:IsItemEmpty() then
		F.Developer.LogDebug("Failed to create item instance for itemSlotID: " .. itemSlotID)
		return
	end

	itemInstance:ContinueOnItemLoad(function()
		callback(itemInstance)
	end)

	return itemInstance
end
