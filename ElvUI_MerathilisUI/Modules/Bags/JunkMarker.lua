local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

local _G = _G
local ipairs = ipairs
local format = format
local tinsert, tremove = tinsert, tremove
local tsort = table.sort

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_Container_GetContainerItemPurchaseInfo = C_Container.GetContainerItemPurchaseInfo
local C_Container_UseContainerItem = C_Container.UseContainerItem
local C_Item_GetItemInfo = C_Item.GetItemInfo
local C_Item_GetItemQualityByID = C_Item.GetItemQualityByID

local ITEMQUALITY_POOR = Enum.ItemQuality.Poor

-------------------------------------------------------------------------------
--  Junk Marker
-------------------------------------------------------------------------------
-- Off by default. While on, a Junk category collects grey items plus whatever
-- the player marks, the title bar gets a mark mode button, and Vendor Grays
-- sells all of it. A mark is a plain category assignment to JUNK (so the
-- assign menu, drag to "+" and Remove from Category all work on it); a grey
-- item the player unmarks goes into db.junkExcluded instead.
module.JUNK_KEY = "JUNK"

local CORNER_OFFSETS = {
	TOPLEFT = { 1, -1 },
	TOPRIGHT = { -1, -1 },
	BOTTOMLEFT = { 1, 1 },
	BOTTOMRIGHT = { -1, 1 },
}

function module:IsJunkMarkerEnabled()
	local db = module.db
	return (db and db.junkMarker and db.junkMarker.enable) or false
end

-- Grey items, and while the Junk Marker is on also marked items (and not the
-- grey ones the player unmarked or filed into another category). quality is
-- optional, callers that already have it skip the lookup.
function module:IsJunkItem(itemID, quality)
	if not itemID then
		return false
	end

	if module:IsJunkMarkerEnabled() then
		local db = module.db
		local assigned = db.itemAssignments and db.itemAssignments[itemID]
		if assigned == module.JUNK_KEY then
			return true
		elseif assigned or (db.junkExcluded and db.junkExcluded[itemID]) then
			return false
		end
	end

	if quality == nil then
		quality = C_Item_GetItemQualityByID(itemID)
	end

	return quality == ITEMQUALITY_POOR
end

-- Flips what IsJunkItem reports for this item.
function module:ToggleJunkMark(itemID, quality)
	if not itemID or not module:IsJunkMarkerEnabled() then
		return
	end

	local db = module.db
	db.junkExcluded = db.junkExcluded or {}

	if module:IsJunkItem(itemID, quality) then
		if db.itemAssignments and db.itemAssignments[itemID] == module.JUNK_KEY then
			module:ClearItemAssignment(itemID)
		end

		-- A grey item is junk on its own, without a mark
		if module:IsJunkItem(itemID, quality) then
			db.junkExcluded[itemID] = true
		end
	else
		db.junkExcluded[itemID] = nil
		module:AssignItemToCategory(itemID, module.JUNK_KEY)
	end
end

function module:ToggleJunkMarkForSlot(bagID, slotID)
	local info = bagID and slotID and C_Container_GetContainerItemInfo(bagID, slotID)
	if info and info.itemID then
		module:ToggleJunkMark(info.itemID, info.quality)
	end
end

function module.GetJunkCoinCorner()
	local db = module.db
	local corner = db and db.junkMarker and db.junkMarker.coinCorner
	return CORNER_OFFSETS[corner] and corner or "TOPRIGHT"
end

-- Places the coin icon of a slot (grid slot, or the icon of a list row)
function module.PlaceJunkCoin(btn, anchor)
	local corner = module.GetJunkCoinCorner()
	if btn.junkCoinCorner == corner and btn.junkCoinAnchor == anchor then
		return
	end

	btn.junkCoinCorner, btn.junkCoinAnchor = corner, anchor
	local offsets = CORNER_OFFSETS[corner]
	btn.JunkIcon:ClearAllPoints()
	btn.JunkIcon:Point(corner, anchor, corner, offsets[1], offsets[2])
end

-------------------------------------------------------------------------------
--  Mark mode (title bar button: left-click items to mark or unmark them)
-------------------------------------------------------------------------------
function module:SetJunkMarkMode(enabled)
	enabled = (enabled and module:IsJunkMarkerEnabled()) or nil
	if module.junkMarkMode == enabled then
		return
	end

	module.junkMarkMode = enabled
	module:RefreshCategoryFrame()
end

-- Called at the end of every bag window refresh: shows the button only while
-- the feature is on (the Bag Bar button moves over to close the gap), and
-- swaps the window title for "Mark Junk" while marking - a longer hint would
-- run under the search box, the button's tooltip explains the rest.
function module:UpdateJunkMarkButton()
	local f = module.frame
	if not f or not f.junkMarkButton then
		return
	end

	local enabled = module:IsJunkMarkerEnabled()
	if not enabled then
		module.junkMarkMode = nil
	end

	local btn = f.junkMarkButton
	btn:SetShown(enabled)
	btn.activeTex:SetShown(module.junkMarkMode and true or false)

	f.bagBarButton:ClearAllPoints()
	f.bagBarButton:Point("TOPRIGHT", enabled and btn or f.vendorGraysButton, "TOPLEFT", -2, 0)

	if module.junkMarkMode then
		f.titleText:SetText(F.String.Class(L["Mark Junk"]))
		f.titleCountText:SetText("")
	end
end

-------------------------------------------------------------------------------
--  Selling
-------------------------------------------------------------------------------
-- Blizzard's own right-click never sells an item that can still be refunded
-- (it asks first), and marks are per item ID - a freshly bought copy of a
-- marked item must not be sold without asking.
local function IsRefundable(bagID, slotID)
	if not C_Container_GetContainerItemPurchaseInfo then
		return false
	end

	local info = C_Container_GetContainerItemPurchaseInfo(bagID, slotID, false)
	return (info and info.refundSeconds and info.refundSeconds > 0) or false
end

local function NextJunkSlot()
	for _, bagID in ipairs(module.BAG_IDS) do
		for slotID = 1, C_Container_GetContainerNumSlots(bagID) do
			local info = C_Container_GetContainerItemInfo(bagID, slotID)
			if
				info
				and info.itemID
				and not info.isLocked
				and not info.hasNoValue
				and module:IsJunkItem(info.itemID, info.quality)
				and not IsRefundable(bagID, slotID)
			then
				return bagID, slotID, info
			end
		end
	end
end

local function GetSellValue(info)
	local sellPrice = info.hyperlink and select(11, C_Item_GetItemInfo(info.hyperlink))
	return (sellPrice or 0) * (info.stackCount or 1)
end

-- Every junk item that can be sold at all, plus what it brings in. Without
-- the Junk Marker that is just the grey items.
function module:GetJunkValue()
	local value = 0

	for _, bagID in ipairs(module.BAG_IDS) do
		for slotID = 1, C_Container_GetContainerNumSlots(bagID) do
			local info = C_Container_GetContainerItemInfo(bagID, slotID)
			if info and info.hyperlink and not info.hasNoValue and module:IsJunkItem(info.itemID, info.quality) then
				value = value + GetSellValue(info)
			end
		end
	end

	return value
end

-- Sells grey and marked items one per short tick instead of a burst of
-- UseContainerItem calls, and stops when the vendor closes or combat starts.
-- UseContainerItem may be called from addon code while a vendor is open.
-- Blizzard's buyback only keeps the last 12 sold items.
function module:SellJunk()
	if module.junkSelling or InCombatLockdown() then
		return
	end

	local sold, earned = 0, 0

	local function Finish()
		module.junkSelling = nil
		if sold > 0 and module.db.junkMarker.sellSummary then
			E:Print(format(L["Sold %d junk items for %s."], sold, E:FormatMoney(earned, "SMART")))
		end
	end

	local function Step()
		if not (_G.MerchantFrame and _G.MerchantFrame:IsShown()) or InCombatLockdown() then
			Finish()
			return
		end

		local bagID, slotID, info = NextJunkSlot()
		if not bagID then
			Finish()
			return
		end

		C_Container_UseContainerItem(bagID, slotID)
		sold = sold + 1
		earned = earned + GetSellValue(info)
		C_Timer.After(0.1, Step)
	end

	module.junkSelling = true
	Step()
end

-- Only listens while auto-sell is actually on. MerchantFrame isn't always
-- shown yet while MERCHANT_SHOW is dispatched, hence the one-frame delay.
function module:UpdateJunkAutoSell()
	local db = module.db
	local wanted = db and db.enable and module:IsJunkMarkerEnabled() and db.junkMarker.autoSell

	if wanted then
		if not module.junkMerchantWatcher then
			module.junkMerchantWatcher = CreateFrame("Frame")
			module.junkMerchantWatcher:SetScript("OnEvent", function()
				C_Timer.After(0, function()
					module:SellJunk()
				end)
			end)
		end
		module.junkMerchantWatcher:RegisterEvent("MERCHANT_SHOW")
	elseif module.junkMerchantWatcher then
		module.junkMerchantWatcher:UnregisterAllEvents()
	end
end

-------------------------------------------------------------------------------
--  Sections
-------------------------------------------------------------------------------
local function SellValueOf(entry)
	if entry.junkValue == nil then
		local sellPrice = entry.itemLink and select(11, C_Item_GetItemInfo(entry.itemLink))
		entry.junkValue = (sellPrice or 0) * (entry.count or 1)
	end
	return entry.junkValue
end

local function CompareJunkValue(a, b)
	local va, vb = SellValueOf(a), SellValueOf(b)
	if va ~= vb then
		return va > vb
	end
	if a.bagID ~= b.bagID then
		return a.bagID < b.bagID
	end
	return a.slotID < b.slotID
end

function module.IsJunkSortedByValue()
	return module:IsJunkMarkerEnabled() and module.db.junkMarker.sortByValue or false
end

-- Most valuable first. A new table: the list may be shared with other views.
function module.SortJunkByValue(items)
	local sorted = {}
	for i, entry in ipairs(items) do
		sorted[i] = entry
	end
	tsort(sorted, CompareJunkValue)
	return sorted
end

local function IsTopSection(section)
	return section.key == module.PinnedCategory.key or section.key == module.RecentCategory.key
end

local function InsertJunkSection(sections, junkSection)
	if module.db.junkMarker.atTop then
		local index = 1
		while sections[index] and IsTopSection(sections[index]) do
			index = index + 1
		end
		tinsert(sections, index, junkSection)
	else
		tinsert(sections, junkSection)
	end
end

-- The bag window's sections before they are drawn. OneBag already has a Junk
-- category, which only moves to the top when asked to; All Items and MultiBag
-- can pull the junk out of their lists into a section of its own.
function module.ApplyJunkSection(sections, viewMode)
	if not module:IsJunkMarkerEnabled() then
		return sections
	end

	local db = module.db
	local junkDB = db.junkMarker

	if viewMode == "CATEGORY" then
		if junkDB.atTop then
			for index, section in ipairs(sections) do
				if section.key == module.JUNK_KEY then
					InsertJunkSection(sections, tremove(sections, index))
					break
				end
			end
		end
		return sections
	end

	if not junkDB.separateSection then
		return sections
	end

	local junk = {}
	for _, section in ipairs(sections) do
		if not IsTopSection(section) then
			local kept
			for index, entry in ipairs(section.items) do
				if entry.isJunk then
					if not kept then
						kept = {}
						for i = 1, index - 1 do
							kept[i] = section.items[i]
						end
					end
					tinsert(junk, entry)
				elseif kept then
					tinsert(kept, entry)
				end
			end
			if kept then
				section.items = kept
			end
		end
	end

	if #junk > 0 or not db.hideEmptyCategories then
		local cat = module:FindCategory(module.JUNK_KEY)
		InsertJunkSection(sections, {
			key = module.JUNK_KEY,
			name = cat and cat.name or L["Junk"],
			icon = cat and cat.icon or 133784,
			items = junk,
		})
	end

	return sections
end

-- "Show Junk in Recent" off keeps junk out of Recent Items
function module.HideJunkFromRecent()
	return module:IsJunkMarkerEnabled() and not module.db.junkMarker.showInRecent
end
