local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

local _G = _G
local ipairs = ipairs
local format = format
local tconcat = table.concat
local wipe = wipe

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_Container_GetContainerItemEquipmentSetInfo = C_Container.GetContainerItemEquipmentSetInfo
local C_Item_GetItemInfoInstant = C_Item.GetItemInfoInstant
local C_Spell_GetSpellName = C_Spell.GetSpellName
local C_Spell_GetSpellTexture = C_Spell.GetSpellTexture
local C_SpellBook_IsSpellKnown = C_SpellBook.IsSpellKnown
local C_TooltipInfo_GetBagItem = C_TooltipInfo.GetBagItem

-------------------------------------------------------------------------------
--  Quick Actions
-------------------------------------------------------------------------------
-- Off by default. While on, a title bar button toggles a mode that dims every
-- bag item but the ones a known spell works on (Disenchant, Pick Lock and WoW
-- Forever's Comprehension scrolls), each marked with that spell's icon. A
-- plain left-click on a marked item casts the spell on it: the slot is a
-- secure button already, so the click runs "/cast spell" + "/use bag slot"
-- through the same path the bags use for a spell waiting on an item target
-- (Slot_OnClick in CategoryFrame.lua). Out of combat only, and the mode ends
-- when combat starts or the bags close.

-- Milling and Prospecting are profession salvage recipes, not item-targeted spells
local DISENCHANT, PICK_LOCK, COMPREHEND = 13262, 1804, 1296017
local IC_WEAPON, IC_ARMOR, IC_MISC = Enum.ItemClass.Weapon, Enum.ItemClass.Armor, Enum.ItemClass.Miscellaneous
local ARMOR_COSMETIC = Enum.ItemArmorSubclass.Cosmetic
local QUALITY_UNCOMMON, QUALITY_EPIC = Enum.ItemQuality.Uncommon, Enum.ItemQuality.Epic

-- WoW Forever's Comprehension scrolls (the items requiring that Mage skill)
local SCROLLS = {
	[211780] = true,
	[211784] = true,
	[211785] = true,
	[211786] = true,
	[211787] = true,
	[211853] = true,
	[211854] = true,
	[211855] = true,
	[213543] = true,
	[213544] = true,
	[213545] = true,
	[213546] = true,
	[213547] = true,
	[281015] = true,
	[281016] = true,
	[281017] = true,
	[281018] = true,
}

-- Item link -> "not disenchantable" tooltip verdict, kept while the mode is on
local tipCache = {}
local combatWatcher

function module:IsQuickActionsEnabled()
	local db = module.db
	return (db and db.quickActions) or false
end

-- Whether the bag item's tooltip has a line reading exactly text
local function TooltipHas(bagID, slotID, text)
	local tip = C_TooltipInfo_GetBagItem(bagID, slotID)
	if not (tip and tip.lines and text) then
		return false
	end
	for _, line in ipairs(tip.lines) do
		if line.leftText == text then
			return true
		end
	end
	return false
end

local function NotDisenchantable(bagID, slotID, link)
	if not link then
		return TooltipHas(bagID, slotID, _G.ITEM_DISENCHANT_NOT_DISENCHANTABLE)
	end
	local v = tipCache[link]
	if v == nil then
		v = TooltipHas(bagID, slotID, _G.ITEM_DISENCHANT_NOT_DISENCHANTABLE)
		tipCache[link] = v
	end
	return v
end

-- The spell the player can cast on this bag item, or nil. Equipment set gear
-- is never offered to Disenchant.
local function SpellFor(bagID, slotID)
	local info = C_Container_GetContainerItemInfo(bagID, slotID)
	local itemID = info and info.itemID
	if not itemID then
		return nil
	end

	if E.Forever and SCROLLS[itemID] then
		return C_SpellBook_IsSpellKnown(COMPREHEND) and COMPREHEND or nil
	end

	local _, _, _, _, _, classID, subClassID = C_Item_GetItemInfoInstant(itemID)
	if classID == IC_WEAPON or classID == IC_ARMOR then
		local quality = info.quality or 0
		if
			quality >= QUALITY_UNCOMMON
			and quality <= QUALITY_EPIC
			and not (classID == IC_ARMOR and subClassID == ARMOR_COSMETIC)
			and C_SpellBook_IsSpellKnown(DISENCHANT)
			and not C_Container_GetContainerItemEquipmentSetInfo(bagID, slotID)
			and not NotDisenchantable(bagID, slotID, info.hyperlink)
		then
			return DISENCHANT
		end
	elseif (classID == IC_MISC or info.hasLoot) and C_SpellBook_IsSpellKnown(PICK_LOCK) then
		-- Read each time: unlocking changes it
		if TooltipHas(bagID, slotID, _G.LOCKED) then
			return PICK_LOCK
		end
	end

	return nil
end

-- Bag frame slots only: the bank keeps its look and its clicks
local function InMode(btn)
	return module.quickActionsMode and btn.ownerFrame == module.frame and btn.BagID and btn.SlotID
end

-- Slot_OnClick: the spell a plain left-click casts on this slot, or nil
function module.QuickActionSpellFor(btn)
	if not InMode(btn) then
		return nil
	end
	return SpellFor(btn.BagID, btn.SlotID)
end

function module.QuickActionSpellName(btn)
	local spellID = module.QuickActionSpellFor(btn)
	return spellID and C_Spell_GetSpellName(spellID)
end

-- ApplySlotDim: shows the spell icon on a slot it works on and returns true
-- for every other slot, which then gets dimmed. Outside the mode it only
-- clears a leftover icon.
function module.UpdateQuickActionMark(btn)
	local spellID = InMode(btn) and SpellFor(btn.BagID, btn.SlotID)

	local icon = btn.quickSpellIcon
	if spellID and not icon then
		icon = btn:CreateTexture(nil, "OVERLAY", nil, 7)
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		btn.quickSpellIcon = icon
	end

	if icon then
		if spellID then
			-- The item's top-right quarter, so it scales with the slot and a
			-- list row's icon alike
			local anchor = btn.iconFrame or btn
			icon:ClearAllPoints()
			icon:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", -1, -1)
			icon:SetPoint("BOTTOMLEFT", anchor, "CENTER")
			icon:SetTexture(C_Spell_GetSpellTexture(spellID))
		end
		icon:SetShown(spellID and true or false)
	end

	return InMode(btn) and not spellID
end

-------------------------------------------------------------------------------
--  The mode and its title bar button
-------------------------------------------------------------------------------
local function OnCombat()
	module:SetQuickActionsMode(false)
end

function module:SetQuickActionsMode(enabled)
	enabled = (enabled and module:IsQuickActionsEnabled() and not InCombatLockdown()) or nil
	if module.quickActionsMode == enabled then
		return
	end

	module.quickActionsMode = enabled
	if not enabled then
		wipe(tipCache)
	end

	-- PLAYER_REGEN_DISABLED fires before the lockdown, so the mode (and its
	-- slot attributes) can still be cleaned up. Watched only while it is on.
	if enabled and not combatWatcher then
		combatWatcher = CreateFrame("Frame")
		combatWatcher:SetScript("OnEvent", OnCombat)
	end
	if combatWatcher then
		if enabled then
			combatWatcher:RegisterEvent("PLAYER_REGEN_DISABLED")
		else
			combatWatcher:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	end

	if module.frame and module.frame:IsShown() then
		module:RefreshCategoryFrame()
	end
end

function module:QuickActionsTooltip()
	local names = {}
	local spells = E.Forever and { DISENCHANT, PICK_LOCK, COMPREHEND } or { DISENCHANT, PICK_LOCK }
	for _, spellID in ipairs(spells) do
		names[#names + 1] = C_Spell_GetSpellName(spellID)
	end

	_G.GameTooltip:AddLine(L["Quick Actions"], 1, 1, 1)
	if module.quickActionsMode then
		_G.GameTooltip:AddLine(L["Click to leave Quick Actions."], 0.6, 0.6, 0.6, true)
	else
		_G.GameTooltip:AddLine(
			format(
				L["Highlights the items your spells can work on (%s). Click a highlighted item to cast the spell on it. Out of combat only."],
				tconcat(names, ", ")
			),
			0.6,
			0.6,
			0.6,
			true
		)
	end
end

-- Called at the end of every bag window refresh, after UpdateJunkMarkButton:
-- shows the button only while the option is on and chains the Bag Bar button
-- off whichever button is leftmost now
function module:UpdateQuickActionsButton()
	local f = module.frame
	if not f or not f.quickActionsButton then
		return
	end

	local enabled = module:IsQuickActionsEnabled()
	if not enabled and module.quickActionsMode then
		module.quickActionsMode = nil
		wipe(tipCache)
	end

	local btn = f.quickActionsButton
	btn:SetShown(enabled)
	btn.activeTex:SetShown(module.quickActionsMode and true or false)

	local prev = module:IsJunkMarkerEnabled() and f.junkMarkButton or f.vendorGraysButton
	btn:ClearAllPoints()
	btn:Point("TOPRIGHT", prev, "TOPLEFT", -2, 0)

	f.bagBarButton:ClearAllPoints()
	f.bagBarButton:Point("TOPRIGHT", enabled and btn or prev, "TOPLEFT", -2, 0)

	if module.quickActionsMode then
		f.titleText:SetText(F.String.Class(L["Quick Actions"]))
		f.titleCountText:SetText("")
	end
end
