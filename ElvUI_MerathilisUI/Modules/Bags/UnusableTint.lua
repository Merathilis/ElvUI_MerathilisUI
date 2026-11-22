local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

local next = next
local pairs = pairs
local ipairs = ipairs
local wipe = wipe
local strsub = strsub

local CreateFrame = CreateFrame
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local UnitLevel = UnitLevel
local C_Timer_After = C_Timer.After
local C_EventUtils_IsEventValid = C_EventUtils and C_EventUtils.IsEventValid
local SetItemButtonTextureVertexColor = SetItemButtonTextureVertexColor
local C_Container_GetContainerItemLink = C_Container.GetContainerItemLink
local C_Item_GetItemInfo = C_Item.GetItemInfo
local C_Item_GetItemInfoInstant = C_Item.GetItemInfoInstant
local C_Item_GetItemSpell = C_Item.GetItemSpell
local C_Item_IsEquippableItem = C_Item.IsEquippableItem
local C_TooltipInfo_GetBagItem = C_TooltipInfo.GetBagItem
local C_TooltipInfo_GetHyperlink = C_TooltipInfo.GetHyperlink

local ITEM_CLASS_RECIPE = Enum.ItemClass.Recipe
local ITEM_CLASS_CONSUMABLE = Enum.ItemClass.Consumable

-------------------------------------------------------------------------------
--  Unusable Items tint
-------------------------------------------------------------------------------
-- Paints the icon of an item the character cannot use red: gear and
-- consumables with an unmet requirement, items above the character's level and
-- recipes that can't be learned (or are already known). The tooltip is the
-- only source that knows all of these (skill ranks, class, level from the
-- item's bonus IDs), so a red line in it decides. Answers are cached per item
-- link and dropped when the level, a skill rank or the known recipes change.

local TINT_R, TINT_G, TINT_B = 1, 0.25, 0.25

-- Red tooltip lines that don't mean "you can't use this"
local IGNORED_RED_LINES = {}
for _, name in ipairs({ "ITEM_SCRAPABLE_NOT", "CANNOT_UNEQUIP_COMBAT", "ITEM_DISENCHANT_NOT_DISENCHANTABLE" }) do
	if _G[name] then
		IGNORED_RED_LINES[_G[name]] = true
	end
end

local ITEM_SPELL_KNOWN = _G.ITEM_SPELL_KNOWN
local USE_PREFIX = _G.ITEM_SPELL_TRIGGER_ONUSE
local USE_PREFIX_LEN = USE_PREFIX and #USE_PREFIX or 0

-- link (or itemID) -> true/false
local cache = {}
-- Set by the wipe events, the cache is dropped on the next lookup: nothing
-- runs while the option is off or no bag window is open.
local cacheDirty = false

-- Game red with tolerance: rounding can put it just under r = 1
local function IsRed(c)
	return c and c.r > 0.9 and c.g < 0.2 and c.b < 0.2
end

-------------------------------------------------------------------------------
--  Still-loading tooltips
-------------------------------------------------------------------------------
-- A freshly scanned tooltip can be incomplete; the client fills it in later
-- and announces it with TOOLTIP_DATA_UPDATE. Every scan is watched for a short
-- window only, and only the watched items are read again.
local WATCH_SECONDS = 2

local watched = {} -- dataInstanceID -> { key, bagID, slotID, link, itemID }
local recheckIDs = {}
local recheckAll = false
local watchEnd = 0
local watchTimer = false
local rescanning = false

local watchFrame = CreateFrame("Frame")
watchFrame:Hide()

local function StopWatch()
	wipe(watched)
	wipe(recheckIDs)
	recheckAll = false
	watchFrame:Hide()
	watchFrame:UnregisterEvent("TOOLTIP_DATA_UPDATE")
end

local function WatchExpire()
	local left = watchEnd - GetTime()
	if left > 0 then
		C_Timer_After(left, WatchExpire)
		return
	end
	watchTimer = false
	StopWatch()
end

local function WatchTooltip(tip, key, bagID, slotID, link, itemID)
	local id = tip.dataInstanceID
	if not id then
		return
	end

	-- A re-read keeps watching its new instance without extending the window
	if not rescanning then
		watchEnd = GetTime() + WATCH_SECONDS
	end
	if GetTime() > watchEnd then
		return
	end

	if not next(watched) then
		watchFrame:RegisterEvent("TOOLTIP_DATA_UPDATE")
	end
	watched[id] = { key = key, bagID = bagID, slotID = slotID, link = link, itemID = itemID }

	if not watchTimer then
		watchTimer = true
		C_Timer_After(WATCH_SECONDS, WatchExpire)
	end
end

-------------------------------------------------------------------------------
--  Lookup
-------------------------------------------------------------------------------
local function GetTooltip(bagID, slotID, link)
	-- The real bag slot or the real link: both carry the bonus IDs that set
	-- the item's true required level, a bare itemID does not
	if bagID and slotID then
		return C_TooltipInfo_GetBagItem(bagID, slotID)
	elseif link then
		return C_TooltipInfo_GetHyperlink(link)
	end
end

-- Recipes: the crafted item's preview comes first and can be red on its own,
-- so only red after the last "Use:" line counts (anywhere if there is none).
-- "Already known" always counts.
local function ScanRecipe(lines)
	local red = false
	for _, line in ipairs(lines) do
		local text = line.leftText
		if text == ITEM_SPELL_KNOWN then
			return true
		elseif text and USE_PREFIX_LEN > 0 and strsub(text, 1, USE_PREFIX_LEN) == USE_PREFIX then
			red = false
		elseif IsRed(line.leftColor) then
			red = true
		end
	end
	return red
end

local function ScanItem(lines)
	for _, line in ipairs(lines) do
		if IsRed(line.leftColor) and not IGNORED_RED_LINES[line.leftText] then
			return true
		end
		if IsRed(line.rightColor) then
			return true
		end
	end
	return false
end

function module.IsItemUnusable(bagID, slotID, link, itemID)
	local key = link or itemID
	if not key then
		return false
	end

	if cacheDirty then
		cacheDirty = false
		wipe(cache)
		StopWatch()
	end

	local cached = cache[key]
	if cached ~= nil then
		return cached
	end

	local _, _, _, _, _, classID = C_Item_GetItemInfoInstant(key)
	local isRecipe = classID == ITEM_CLASS_RECIPE

	-- Plain reagents and trade goods have nothing to check: only gear, items
	-- with a use effect, consumables (a scroll can need a skill) and items
	-- above the character's level are scanned
	if not isRecipe then
		local _, _, _, _, minLevel = C_Item_GetItemInfo(key)
		if
			not (
				C_Item_IsEquippableItem(key)
				or C_Item_GetItemSpell(key)
				or classID == ITEM_CLASS_CONSUMABLE
				or (minLevel and minLevel > UnitLevel("player"))
			)
		then
			cache[key] = false
			return false
		end
	end

	local tip = GetTooltip(bagID, slotID, link)
	if not (tip and tip.lines) then
		-- Not cached: the item data isn't there yet, the next paint asks again
		return false
	end

	WatchTooltip(tip, key, bagID, slotID, link, itemID)

	local unusable
	if isRecipe then
		unusable = ScanRecipe(tip.lines)
	else
		unusable = ScanItem(tip.lines)
	end

	cache[key] = unusable
	return unusable
end

-------------------------------------------------------------------------------
--  Painting
-------------------------------------------------------------------------------
-- Called from UpdateSlotVisual for every bag and bank slot (grid, list and
-- compact display). Always written, never skipped as unchanged: pooled buttons
-- that showed a red item before must turn white again, and Blizzard's button
-- code may write the icon color itself.
function module.PaintUnusableTint(btn, entry)
	local unusable = false
	local effects = module.db and module.db.effects
	if effects and effects.unusableTint and entry and entry.itemID then
		unusable = module.IsItemUnusable(entry.bagID, entry.slotID, entry.itemLink, entry.itemID)
	end

	if unusable then
		SetItemButtonTextureVertexColor(btn, TINT_R, TINT_G, TINT_B)
	else
		SetItemButtonTextureVertexColor(btn, 1, 1, 1)
	end
end

-- Only the tint, never a rebuild: works in combat too
local repaintQueued = false
local function RepaintShownTints()
	repaintQueued = false
	module.ForEachShownSlot(function(btn)
		if btn.BagID and btn.SlotID then
			module.PaintUnusableTint(btn, {
				bagID = btn.BagID,
				slotID = btn.SlotID,
				itemID = btn.itemID,
				itemLink = btn.itemLink,
			})
		end
	end)
end

local function QueueRepaint()
	if repaintQueued then
		return
	end
	if not (module.frame and module.frame:IsShown()) and not (module.bankFrame and module.bankFrame:IsShown()) then
		return
	end
	repaintQueued = true
	C_Timer_After(0.1, RepaintShownTints)
end

-- Re-reads the watched items marked by the updates, once per frame at most
local recheckList = {}
watchFrame:SetScript("OnUpdate", function(self)
	self:Hide()
	if GetTime() > watchEnd then
		StopWatch()
		return
	end

	if recheckAll then
		for id in pairs(watched) do
			recheckList[#recheckList + 1] = id
		end
	else
		for id in pairs(recheckIDs) do
			recheckList[#recheckList + 1] = id
		end
	end
	recheckAll = false
	wipe(recheckIDs)

	local changed = false
	for i = 1, #recheckList do
		local id = recheckList[i]
		local w = watched[id]
		if w then
			watched[id] = nil
			-- The slot holds something else by now: nothing to correct
			local moved = w.bagID and w.link and C_Container_GetContainerItemLink(w.bagID, w.slotID) ~= w.link
			if not moved then
				local old = cache[w.key]
				cache[w.key] = nil
				rescanning = true
				local new = module.IsItemUnusable(w.bagID, w.slotID, w.link, w.itemID)
				rescanning = false
				if new ~= old then
					changed = true
				end
			end
		end
	end
	wipe(recheckList)

	if not next(watched) then
		StopWatch()
	end
	if changed then
		QueueRepaint()
	end
end)

watchFrame:SetScript("OnEvent", function(self, _, id)
	if id then
		if not watched[id] then
			return
		end
		recheckIDs[id] = true
	else
		recheckAll = true
	end
	self:Show()
end)

-------------------------------------------------------------------------------
--  Cache invalidation
-------------------------------------------------------------------------------
-- A level gates gear and items above it, a skill rank recipes and some items,
-- a learned recipe turns its other copies into "Already known". On WoW Forever
-- SKILL_LINES_CHANGED fires by the dozen in a fight (weapon and defense
-- skills), so it only flags the cache, the repaint waits for the next open
-- or the end of combat.
local INVALIDATE_EVENTS = { "PLAYER_LEVEL_CHANGED", "SKILL_LINES_CHANGED", "NEW_RECIPE_LEARNED" }

local invalidateFrame = CreateFrame("Frame")
invalidateFrame:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		QueueRepaint()
		return
	end

	cacheDirty = true
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		QueueRepaint()
	end
end)

function module:UpdateUnusableTint()
	local effects = module.db and module.db.effects
	local enabled = effects and effects.unusableTint and module:IsCategorizedBagsActive()

	if enabled then
		for _, event in ipairs(INVALIDATE_EVENTS) do
			-- Not every client knows every event, registering an unknown one errors
			if not C_EventUtils_IsEventValid or C_EventUtils_IsEventValid(event) then
				invalidateFrame:RegisterEvent(event)
			end
		end
	else
		invalidateFrame:UnregisterAllEvents()
		cacheDirty = false
		wipe(cache)
		StopWatch()
	end

	-- Clears or paints the tint on what is on screen right now
	QueueRepaint()
end
