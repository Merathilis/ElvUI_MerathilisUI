local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc

-- Account-wide auction house favorites.
-- Blizzard keeps favorites per character on the server and has no API that lists them. We record every
-- change made through C_AuctionHouse.SetFavoriteItem into E.global, pick up existing favorites from browse
-- results, and apply the shared list to the current character when the auction house opens.
-- Removals are kept as tombstones, so unfavoriting an item on one character removes it on the others.

local _G = _G
local format = format
local next = next
local pairs = pairs
local select = select
local strsplit = strsplit
local time = time
local tinsert = tinsert
local tonumber = tonumber
local tremove = tremove
local wipe = wipe

local CreateFrame = CreateFrame
local GetServerExpansionLevel = GetServerExpansionLevel
local hooksecurefunc = hooksecurefunc
local C_AuctionHouse = C_AuctionHouse
local C_Item_GetItemInfo = C_Item.GetItemInfo
local C_Item_GetItemInfoInstant = C_Item.GetItemInfoInstant
local C_Item_RequestLoadItemDataByID = C_Item.RequestLoadItemDataByID
local C_Timer_NewTicker = C_Timer.NewTicker
local C_Timer_After = C_Timer.After

local DEBUG_CHANNEL = "AuctionFavorites"
local TOMBSTONE_LIFETIME = 180 * 24 * 60 * 60 -- forget removals after half a year
local APPLY_INTERVAL = 0.1
local APPLY_PER_TICK = 5

-- Crafted consumables of the current season, kept as favorites while the option is on.
-- Update the IDs with each season: keys that drop out of this table are unfavorited again.
-- Midnight Season 1/2, from method.gg and nexttier.pro consumable guides (2026-11-28)
module.AuctionFavoritesPresets = {
	flasks = {
		241321, -- Flask of Thalassian Resistance (Versatility)
		241324, -- Flask of the Blood Knights (Haste)
		241322, -- Flask of the Magisters (Mastery)
		241326, -- Flask of the Shattered Sun (Critical Strike)
	},
	potions = {
		241288, -- Potion of Recklessness
		241308, -- Light's Potential
		241292, -- Draught of Rampant Abandon
		241304, -- Silvermoon Health Potion
		271884, -- Concentrated Silvermoon Health Potion
		241300, -- Lightfused Mana Potion
	},
	gems = {
		240983, -- Indecipherable Eversong Diamond
		240967, -- Powerful Eversong Diamond
		240971, -- Stoic Eversong Diamond
		240969, -- Telluric Eversong Diamond
		240912, -- Flawless Versatile Lapis
		240916, -- Flawless Quick Lapis
		240914, -- Flawless Deadly Lapis
		240918, -- Flawless Masterful Lapis
		240888, -- Flawless Quick Peridot
		240894, -- Flawless Versatile Peridot
		240890, -- Flawless Deadly Peridot
		240892, -- Flawless Masterful Peridot
		240904, -- Flawless Deadly Garnet
		240910, -- Flawless Versatile Garnet
		240906, -- Flawless Quick Garnet
		240908, -- Flawless Masterful Garnet
		240896, -- Flawless Masterful Amethyst
		240902, -- Flawless Versatile Amethyst
		240900, -- Flawless Quick Amethyst
		240898, -- Flawless Deadly Amethyst
	},
	weaponOils = {
		243734, -- Thalassian Phoenix Oil
		243738, -- Smuggler's Enchanted Edge
		243736, -- Oil of Dawn
		237371, -- Refulgent Whetstone
		237369, -- Refulgent Weightstone
	},
}

local queue = {} -- { key, setFavorite }
local applying = false -- our own SetFavoriteItem calls, the hook ignores them
local ticker
local added, removed = 0, 0

local function Debug(...)
	F.Developer.Debug(DEBUG_CHANNEL, ...)
end

local function GetDB()
	return E.global.mui.auctionFavorites
end

local function IsEnabled()
	local db = GetDB()
	return db and db.enable
end

local function ToKey(itemKey)
	return format(
		"%d:%d:%d:%d",
		itemKey.itemID or 0,
		itemKey.itemLevel or 0,
		itemKey.itemSuffix or 0,
		itemKey.battlePetSpeciesID or 0
	)
end

local function FromKey(key)
	local itemID, itemLevel, itemSuffix, speciesID = strsplit(":", key)
	return {
		itemID = tonumber(itemID) or 0,
		itemLevel = tonumber(itemLevel) or 0,
		itemSuffix = tonumber(itemSuffix) or 0,
		battlePetSpeciesID = tonumber(speciesID) or 0,
	}
end

local function Remember(key, isFavorite)
	local db = GetDB()
	if isFavorite then
		db.list[key] = true
		db.removed[key] = nil
	else
		db.list[key] = nil
		db.removed[key] = time()
	end
end

-- The AH lists commodities with the item's level in the key (gems 295, Inky Black Potion 1). A key with another
-- level is still a valid favorite but matches no auctions ("None available"): hand-made keys with level 0, and
-- favorites from before the 12.0 item level squish. MakeItemKey fills the level only once the item's data is
-- loaded and can return 0 even then, the item's own level is the same number.
---@param itemID number
---@return number? itemLevel nil while the item's data isn't loaded
local function GetCommodityLevel(itemID)
	local itemKey = C_AuctionHouse.MakeItemKey(itemID)
	local itemLevel = itemKey and itemKey.itemLevel
	if not itemLevel or itemLevel <= 0 then
		itemLevel = select(4, C_Item_GetItemInfo(itemID))
	end

	if itemLevel and itemLevel > 0 then
		return itemLevel
	end

	C_Item_RequestLoadItemDataByID(itemID)
end

---A favorite whose key can never match an auction. Equipment keys carry the level of the auction itself and
---battle pets their species, both are left alone.
---@param key string
---@return boolean? stale nil while the item's data isn't loaded
local function IsStale(key)
	local itemID, itemLevel, itemSuffix, speciesID = strsplit(":", key)
	itemID, itemLevel = tonumber(itemID), tonumber(itemLevel)
	if not itemID or tonumber(speciesID) ~= 0 or tonumber(itemSuffix) ~= 0 then
		return false
	end

	local equipLoc = select(4, C_Item_GetItemInfoInstant(itemID))
	if equipLoc and equipLoc ~= "" and equipLoc ~= "INVTYPE_NON_EQUIP_IGNORE" then
		return false
	end

	local currentLevel = GetCommodityLevel(itemID)
	if not currentLevel then
		return nil
	end

	return currentLevel ~= itemLevel
end

---Takes stale favorites off the shared list, the sync then unfavorites them on every character
---@return boolean unresolved some items had no data yet
local function RemoveStale()
	local db = GetDB()
	local unresolved = false
	for key in pairs(db.list) do
		local stale = IsStale(key)
		if stale then
			Remember(key, false)
			Debug("stale key removed", key)
		elseif stale == nil then
			unresolved = true
		end
	end

	return unresolved
end

-- Adds the current season's consumables to the shared list and takes off the ones of past seasons.
-- A preset item the player unfavorited stays off (tombstone).
---@return boolean unresolved some items had no data yet, a later sync picks them up
---@return table wanted [key] = true, the preset keys of this season
local function MergePresets()
	local db = GetDB()
	local presets = db.presets
	local wanted = {}
	local unresolved = {} -- [itemID] = true, keys of these items are kept as they are

	if presets.enable then
		for category, itemIDs in pairs(module.AuctionFavoritesPresets) do
			if presets.categories[category] then
				for i = 1, #itemIDs do
					local itemID = itemIDs[i]
					local itemLevel = GetCommodityLevel(itemID)
					if itemLevel then
						wanted[format("%d:%d:0:0", itemID, itemLevel)] = true
					else
						unresolved[itemID] = true
						Debug("preset not loaded yet", itemID)
					end
				end
			end
		end
	end

	for key in pairs(wanted) do
		if not db.list[key] and not db.removed[key] and not presets.added[key] then
			db.list[key] = true
			presets.added[key] = true
		end
	end

	-- Past seasons, or a category turned off
	for key in pairs(presets.added) do
		if not wanted[key] and not unresolved[tonumber((strsplit(":", key)))] then
			presets.added[key] = nil
			if db.list[key] then
				Remember(key, false)
			end
		end
	end

	return next(unresolved) ~= nil, wanted
end

local function PruneTombstones()
	local db = GetDB()
	local now = time()
	for key, removedAt in pairs(db.removed) do
		if now - removedAt > TOMBSTONE_LIFETIME then
			db.removed[key] = nil
		end
	end
end

local function StopApplying()
	if ticker then
		ticker:Cancel()
		ticker = nil
	end
	wipe(queue)
end

local function FinishApplying()
	StopApplying()
	Debug(format("sync done, added %d, removed %d", added, removed))
	if added > 0 or removed > 0 then
		F.Print(format(L["Auction favorites synced: %d added, %d removed."], added, removed))
	end
	added, removed = 0, 0
end

local function ApplyTick()
	if not _G.AuctionHouseFrame or not _G.AuctionHouseFrame:IsShown() then
		StopApplying()
		return
	end

	for _ = 1, APPLY_PER_TICK do
		local entry = tremove(queue, 1)
		if not entry then
			FinishApplying()
			return
		end

		local key, setFavorite = entry[1], entry[2]
		local itemKey = FromKey(key)
		local isFavorite = C_AuctionHouse.IsFavoriteItem(itemKey)

		if setFavorite and not isFavorite then
			if C_AuctionHouse.HasMaxFavorites() then
				-- Removals ran first, everything left in the queue is an addition
				local skipped = #queue + 1
				Debug("favorites are full, skipped", skipped)
				F.Print(format(L["Auction favorites are full, %d could not be added."], skipped))
				FinishApplying()
				return
			end

			applying = true
			C_AuctionHouse.SetFavoriteItem(itemKey, true)
			applying = false
			added = added + 1
		elseif not setFavorite and isFavorite then
			applying = true
			C_AuctionHouse.SetFavoriteItem(itemKey, false)
			applying = false
			removed = removed + 1
		end
	end
end

---@param retries number? waits for FavoritesAreAvailable
---@param itemRetry boolean? second pass for preset items that had no data yet
function module:AuctionFavorites_Sync(retries, itemRetry)
	if not IsEnabled() then
		return
	end

	if not C_AuctionHouse.FavoritesAreAvailable() then
		-- The favorites arrive shortly after the window opens
		retries = (retries or 0) + 1
		Debug("favorites not available yet, try", retries)
		if retries <= 5 then
			C_Timer_After(1, function()
				module:AuctionFavorites_Sync(retries, itemRetry)
			end)
		end
		return
	end

	Debug(itemRetry and "sync (second pass for unloaded items)" or "sync")
	StopApplying()
	PruneTombstones()
	local staleUnresolved = RemoveStale()
	local unresolved, presetKeys = MergePresets()
	if (unresolved or staleUnresolved) and not itemRetry then
		C_Timer_After(2, function()
			if _G.AuctionHouseFrame and _G.AuctionHouseFrame:IsShown() then
				module:AuctionFavorites_Sync(nil, true)
			end
		end)
	end

	-- Removals first, they make room under Blizzard's favorites limit. Then the season's consumables,
	-- then the rest of the shared list.
	local db = GetDB()
	for key in pairs(db.removed) do
		if C_AuctionHouse.IsFavoriteItem(FromKey(key)) then
			tinsert(queue, { key, false })
		end
	end

	for key in pairs(presetKeys) do
		if db.list[key] and not C_AuctionHouse.IsFavoriteItem(FromKey(key)) then
			tinsert(queue, { key, true })
		end
	end

	for key in pairs(db.list) do
		if not presetKeys[key] and not C_AuctionHouse.IsFavoriteItem(FromKey(key)) then
			tinsert(queue, { key, true })
		end
	end

	Debug(format("sync queued %d changes", #queue))
	if next(queue) then
		ticker = C_Timer_NewTicker(APPLY_INTERVAL, ApplyTick)
	end
end

-- Favorites the character already had before the feature (or from before it was turned on) only show up
-- in search results, so they are collected from there.
function module:AuctionFavorites_CollectBrowse()
	if not IsEnabled() then
		return
	end

	local db = GetDB()
	local results = C_AuctionHouse.GetBrowseResults()
	for i = 1, #results do
		local itemKey = results[i].itemKey
		if itemKey and C_AuctionHouse.IsFavoriteItem(itemKey) then
			local key = ToKey(itemKey)
			-- A removal on another character wins, the next sync takes it off here as well
			if not db.list[key] and not db.removed[key] then
				if IsStale(key) then
					Remember(key, false)
					Debug("stale favorite found", key)
				else
					db.list[key] = true
					Debug("collected", key)
				end
			end
		end
	end
end

function module:AuctionFavorites_OnShow()
	-- Let Blizzard's own favorites query go first
	C_Timer_After(0.5, function()
		module:AuctionFavorites_Sync()
	end)
end

function module:AuctionFavorites_OnClose()
	StopApplying()
	added, removed = 0, 0
end

function module:AuctionFavorites()
	if not IsEnabled() or not C_AuctionHouse or not C_AuctionHouse.SetFavoriteItem or not _G.AuctionHouseFrame then
		return
	end

	hooksecurefunc(C_AuctionHouse, "SetFavoriteItem", function(itemKey, setFavorite)
		if applying or not IsEnabled() or not itemKey then
			return
		end

		local key = ToKey(itemKey)
		Remember(key, setFavorite)
		Debug(setFavorite and "favorited" or "unfavorited", key)
	end)

	-- Own frame: AceEvent keeps one handler per event and module, AuctionEnhanced uses AUCTION_HOUSE_CLOSED too
	local eventFrame = CreateFrame("Frame")
	eventFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")
	eventFrame:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED")
	eventFrame:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_ADDED")
	eventFrame:SetScript("OnEvent", function(_, event)
		if event == "AUCTION_HOUSE_CLOSED" then
			module:AuctionFavorites_OnClose()
		else
			module:AuctionFavorites_CollectBrowse()
		end
	end)

	-- Preset keys and the stale check need the item data (see GetCommodityLevel), ask for it before the first sync
	for key in pairs(GetDB().list) do
		local itemID = tonumber((strsplit(":", key)))
		if itemID then
			C_Item_RequestLoadItemDataByID(itemID)
		end
	end

	if GetDB().presets.enable then
		for _, itemIDs in pairs(module.AuctionFavoritesPresets) do
			for i = 1, #itemIDs do
				C_Item_RequestLoadItemDataByID(itemIDs[i])
			end
		end
	end

	-- Not AUCTION_HOUSE_SHOW: Blizzard_AuctionHouseUI loads on the first one, so an event registered
	-- here misses the first opening after every reload. The frame's OnShow follows the load.
	_G.AuctionHouseFrame:HookScript("OnShow", function()
		module:AuctionFavorites_OnShow()
	end)
	if _G.AuctionHouseFrame:IsShown() then
		module:AuctionFavorites_OnShow()
	end
	Debug("hooked")
end

---Number of favorites in the account-wide list
---@return number
function module:AuctionFavorites_Count()
	local db = GetDB()
	local count = 0
	for _ in pairs(db and db.list or {}) do
		count = count + 1
	end

	return count
end

-- Item classes the older expansion cleanup may remove: things that get replaced every expansion.
-- Equipment, recipes, pets, mounts and housing decor are kept.
local EXPANSION_CLEANUP_CLASSES = {
	[Enum.ItemClass.Consumable] = true,
	[Enum.ItemClass.Gem] = true,
	[Enum.ItemClass.Tradegoods] = true,
	[Enum.ItemClass.ItemEnhancement] = true,
}

---Unfavorites consumables, gems, trade goods and item enhancements of older expansions on every character
---@return number removedCount
---@return number unresolvedCount items without data yet, a second click picks them up
function module:AuctionFavorites_RemoveOldExpansions()
	local db = GetDB()
	local currentExpansion = GetServerExpansionLevel and GetServerExpansionLevel() or LE_EXPANSION_LEVEL_CURRENT
	local removedCount, unresolvedCount = 0, 0

	for key in pairs(db.list) do
		local itemID = tonumber((strsplit(":", key)))
		local classID = itemID and select(6, C_Item_GetItemInfoInstant(itemID))
		if classID and EXPANSION_CLEANUP_CLASSES[classID] then
			local itemName, _, _, _, _, _, _, _, _, _, _, _, _, _, expansionID = C_Item_GetItemInfo(itemID)
			if not itemName then
				unresolvedCount = unresolvedCount + 1
				C_Item_RequestLoadItemDataByID(itemID)
			elseif expansionID and expansionID < currentExpansion then
				Remember(key, false)
				removedCount = removedCount + 1
				Debug("older expansion removed", key, itemName, expansionID)
			end
		end
	end

	-- Applied on the characters with the next sync, right away when the auction house is open
	if removedCount > 0 and _G.AuctionHouseFrame and _G.AuctionHouseFrame:IsShown() then
		module:AuctionFavorites_Sync()
	end

	return removedCount, unresolvedCount
end

function module:AuctionFavorites_Reset()
	local db = GetDB()
	wipe(db.list)
	wipe(db.removed)
	wipe(db.presets.added)
end

module:AddCallbackForAddon("Blizzard_AuctionHouseUI", module.AuctionFavorites)
