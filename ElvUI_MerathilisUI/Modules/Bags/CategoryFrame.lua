local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories
local B = E:GetModule("Bags")
local TT = E:GetModule("Tooltip")
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")
local EM = MER:GetModule("MER_EquipManager") ---@class EquipmentManager

local _G = _G
local ipairs, pairs = ipairs, pairs
local tinsert, tremove, wipe = tinsert, tremove, wipe
local tsort = table.sort
local floor, ceil = math.floor, math.ceil
local format = format
local strmatch, strlower = strmatch, strlower
local IsShiftKeyDown = IsShiftKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsAltKeyDown = IsAltKeyDown
local IsModifiedClick = IsModifiedClick
local HandleModifiedItemClick = HandleModifiedItemClick
local CursorHasItem = CursorHasItem
local GetCursorInfo = GetCursorInfo
local ClearCursor = ClearCursor

local CreateFrame = CreateFrame
local CreateAnimationGroup = CreateAnimationGroup
local CreateAtlasMarkup = CreateAtlasMarkup
local GetExpansionDisplayInfo = GetExpansionDisplayInfo
local GetMoney = GetMoney
-- Bundled instead of one upvalue each: this file's main chunk is close to
-- Lua's hard limit of 200 locals per function, and going over it makes the
-- whole file fail to compile.
local BankAPI = {
	Close = (C_Bank and C_Bank.CloseBankFrame) or CloseBankFrame,
	FetchPurchasedTabData = C_Bank and C_Bank.FetchPurchasedBankTabData,
	AutoDeposit = C_Bank and C_Bank.AutoDepositItemsIntoBank,
	CanView = C_Bank and C_Bank.CanViewBank,
	FetchNumPurchasedTabs = C_Bank and C_Bank.FetchNumPurchasedBankTabs,
	FetchNextPurchasableTabData = C_Bank and C_Bank.FetchNextPurchasableBankTabData,
	PurchaseTab = C_Bank and C_Bank.PurchaseBankTab,
	CanPurchaseTab = C_Bank and C_Bank.CanPurchaseBankTab,
}
local CHARACTER_BANK_TYPE = (Enum.BankType and Enum.BankType.Character) or 0
local WARBAND_BANK_TYPE = (Enum.BankType and Enum.BankType.Account) or 2

local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_Container_GetContainerItemCooldown = C_Container.GetContainerItemCooldown
local C_Container_GetContainerItemQuestInfo = C_Container.GetContainerItemQuestInfo
local C_Container_SetItemSearch = C_Container.SetItemSearch
local C_Container_PickupContainerItem = C_Container.PickupContainerItem
-- Same reason as BankAPI above: bundled to stay clear of the 200-local
-- limit. The per-item C_Container calls below stay plain upvalues.
local API = {
	IsNewItem = C_NewItems.IsNewItem,
	RemoveNewItem = C_NewItems.RemoveNewItem,
	GetItemInfoInstant = C_Item.GetItemInfoInstant,
	GetDetailedItemLevelInfo = C_Item.GetDetailedItemLevelInfo,
	GetItemInfo = C_Item.GetItemInfo,
	IsEquippableItem = C_Item.IsEquippableItem,
	IsBoundToAccountUntilEquip = C_Item.IsBoundToAccountUntilEquip,
	GetBackpackCurrencyInfo = C_CurrencyInfo.GetBackpackCurrencyInfo,
	GetBagItemTooltip = C_TooltipInfo.GetBagItem,
}
local MAX_WATCHED_TOKENS = MAX_WATCHED_TOKENS or 3
local C_MerchantFrame_SellAllJunkItems = C_MerchantFrame.SellAllJunkItems
local ITEMQUALITY_POOR = Enum.ItemQuality.Poor

local BAG_IDS = { 0, 1, 2, 3, 4 }
if module.ReagentContainer and module.ReagentContainer < math.huge then
	tinsert(BAG_IDS, module.ReagentContainer)
end

local FRAME_NAME = "MER_BagCategoriesFrame"
local SLOT_NAME_PREFIX = "MER_BagCategoriesSlot"
local BANK_FRAME_NAME = "MER_BankCategoriesFrame"
local BANK_SLOT_NAME_PREFIX = "MER_BankCategoriesSlot"
local HEADER_PADDING = 6
local COLLAPSED_SIDEBAR_WIDTH = 50
local VIEW_MODE_ROW_HEIGHT = 24

-- The sidebar scrollbar sits in the same spot collapsed or expanded, inside
-- the sidebar's right border. The collapsed width is sized so the icon
-- column (4 + 4 + 16px) still fits left of it; a smaller inset while
-- collapsed pushed the bar half across the sidebar edge.
local SIDEBAR_SCROLLBAR_INSET = 24
local function GetSidebarChildWidth(sidebarWidth)
	return sidebarWidth - SIDEBAR_SCROLLBAR_INSET - 6
end
module.SIDEBAR_SCROLLBAR_INSET = SIDEBAR_SCROLLBAR_INSET
module.GetSidebarChildWidth = GetSidebarChildWidth

-- Exposed so BankFrame.lua can build its own frame/slot names consistently.
module.BANK_FRAME_NAME = BANK_FRAME_NAME

-- Same restriction ElvUI's own item level display uses: only equippable gear
-- (Armor covers trinkets/rings/necks too) above Common quality.
local ITEMCLASS_ARMOR = Enum.ItemClass.Armor
local ITEMCLASS_WEAPON = Enum.ItemClass.Weapon
local ITEMQUALITY_COMMON = Enum.ItemQuality.Common

local ITEMBIND_ON_EQUIP = Enum.ItemBind.OnEquip or 2
local ITEMBIND_TO_BNET_ACCOUNT = Enum.ItemBind.ToBnetAccount or 8
local ITEMBIND_TO_BNET_ACCOUNT_UNTIL_EQUIPPED = Enum.ItemBind.ToBnetAccountUntilEquipped or 9

local BIND_TEXT = {
	[Enum.ItemBind.OnAcquire or 1] = L["BoP"],
	[Enum.ItemBind.OnEquip or 2] = L["BoE"],
	[Enum.ItemBind.OnUse or 3] = L["BoU"],
	[Enum.ItemBind.ToBnetAccount or 8] = L["BoA"],
}

-- Same equip-location whitelist ElvUI's own bags use (B.IsEquipmentSlot) to
-- gate the Pawn upgrade-arrow check to actual gear slots.
local IS_EQUIPMENT_SLOT = {
	INVTYPE_HEAD = true,
	INVTYPE_NECK = true,
	INVTYPE_SHOULDER = true,
	INVTYPE_BODY = true,
	INVTYPE_CHEST = true,
	INVTYPE_WAIST = true,
	INVTYPE_LEGS = true,
	INVTYPE_FEET = true,
	INVTYPE_WRIST = true,
	INVTYPE_HAND = true,
	INVTYPE_FINGER = true,
	INVTYPE_TRINKET = true,
	INVTYPE_WEAPON = true,
	INVTYPE_SHIELD = true,
	INVTYPE_RANGED = true,
	INVTYPE_CLOAK = true,
	INVTYPE_2HWEAPON = true,
	INVTYPE_TABARD = true,
	INVTYPE_ROBE = true,
	INVTYPE_WEAPONMAINHAND = true,
	INVTYPE_WEAPONOFFHAND = true,
	INVTYPE_HOLDABLE = true,
	INVTYPE_THROWN = true,
	INVTYPE_RANGEDRIGHT = true,
}

-- Same tooltip-scan approach EquipManager.lua uses for ElvUI's own bags
-- (GetContainerItemEquipmentSetInfo is still unreliable) - matches a
-- localized "Equipment Set: <name>" tooltip line.
local MATCH_EQUIPMENT_SETS = EQUIPMENT_SETS:gsub("%-", "%%-"):gsub("%%s", "(.-)")

-- Small inward nudge so slot-overlay text (Count/ItemLevel/BindType) doesn't
-- sit flush against the icon border, keyed by the anchor point it's set to.
local ANCHOR_OFFSETS = {
	TOPLEFT = { 2, -2 },
	TOP = { 0, -2 },
	TOPRIGHT = { -2, -2 },
	LEFT = { 2, 0 },
	CENTER = { 0, 0 },
	RIGHT = { -2, 0 },
	BOTTOMLEFT = { 2, 2 },
	BOTTOM = { 0, 2 },
	BOTTOMRIGHT = { -2, 2 },
}

local function PositionSlotText(fs, point)
	local offset = ANCHOR_OFFSETS[point] or ANCHOR_OFFSETS.BOTTOMRIGHT
	fs:ClearAllPoints()
	fs:Point(point, offset[1], offset[2])
end

-- ElvUI's own Container_OnHide -> BagFrameHidden clears every item's "new"
-- flag (NewItemGlowSlotSwitch -> C_NewItems.RemoveNewItem) whenever
-- B.BagFrame hides - which we do on every single open of our own frame, so
-- Recent Items would always come up empty. Snapshot which items are new
-- right before that happens and fall back to it in CollectItems.
local newItemSnapshot = {}

-- Clears/resets only the keys for this bagIDList (bagID*1000+slotID keys
-- never collide between the 0-5 bag range and the 6-11 bank range), instead
-- of wiping the whole table - bag and bank snapshots happen independently
-- (leaving the bank, then later closing bags, shouldn't erase each other's
-- Recent Items data).
local function SnapshotNewItemsForBags(bagIDList)
	for _, bagID in ipairs(bagIDList) do
		local numSlots = C_Container_GetContainerNumSlots(bagID)
		for slotID = 1, numSlots do
			local key = bagID * 1000 + slotID
			newItemSnapshot[key] = API.IsNewItem(bagID, slotID) or nil
		end
	end
end

-- Recent Items tracks item IDs, not bag/slot positions: a slot-based list
-- follows the slot, so sorting the bags moved the "recent" marks onto
-- whatever item happened to land there. Newest last, capped at
-- db.recentLimit (oldest drops out first).
local recentItems, recentOrder = {}, {}

local function TrimRecentItems()
	local limit = module.db and module.db.recentLimit or 20
	while #recentOrder > limit do
		local oldest = tremove(recentOrder, 1)
		recentItems[oldest] = nil
	end
end

local function MarkItemRecent(itemID)
	if not itemID or recentItems[itemID] then
		return
	end

	recentItems[itemID] = true
	tinsert(recentOrder, itemID)
	TrimRecentItems()
end

function module:IsRecentItem(itemID)
	return (itemID and recentItems[itemID]) or false
end

module.TrimRecentItems = TrimRecentItems

function module:ClearRecentItems()
	wipe(recentItems)
	wipe(recentOrder)
end

local function SnapshotNewItems()
	SnapshotNewItemsForBags(BAG_IDS)
end

local function SnapshotBankNewItems()
	SnapshotNewItemsForBags(module.BankBagIDs)
	SnapshotNewItemsForBags(module.WarbandBagIDs)
end

-- B.BagFrame:Hide() for real is exactly what we want here - it makes the
-- whole subtree (every child button/slot) unreachable and invisible in one
-- step, and correctly flips IsShown() to false for anything elsewhere that
-- checks "is the bag frame actually open" (see below for why that matters).
-- The one thing we must avoid is its OnHide handler (Container_OnHide)
-- actually running: it calls CloseBackpack()/CloseBag() as a side effect,
-- which resets the native "bags are open" state ElvUI's own toggle handlers
-- read on the next press of the bag keybind - since our frame is what's
-- actually open at that point, that reset made every subsequent press
-- decide to "open" again instead of alternating (the keybind stopped
-- closing anything). Fix: clear the OnHide script right before :Hide(),
-- restore it right after - a real close (B:CloseAllBags(), never routed
-- through this function) still runs Container_OnHide normally.
--
-- Two earlier attempts got this wrong by never actually calling :Hide():
-- SetAlpha(0)/EnableMouse(false) on the frame itself doesn't stop its
-- children from staying clickable (an invisible child button was eating
-- clicks meant for our own sidebar's collapse arrow), and moving the frame
-- off-screen instead fixed clicks but left IsShown() reporting true - which
-- broke anything that anchors itself to B.BagFrame while it's "open":
-- reported as tooltips (and apparently the Plumber addon's own frame)
-- pinning to the screen's left edge, traced to ElvUI's own "anchor tooltip
-- to bags" option (Tooltip.lua's GameTooltip_SetDefaultAnchor) anchoring
-- the global GameTooltip to B.BagFrame's position - which was real, just
-- sitting off-screen - once it saw IsShown() == true.
local function HideElvUIBagFrame()
	if B.BagFrame and B.BagFrame:IsShown() then
		SnapshotNewItems()

		local onHide = B.BagFrame:GetScript("OnHide")
		B.BagFrame:SetScript("OnHide", nil)
		B.BagFrame:Hide()
		B.BagFrame:SetScript("OnHide", onHide)
	end
end

-- Same technique as HideElvUIBagFrame above, doubly important here: ElvUI's
-- shared Container_OnHide handler calls BankAPI.Close() as a side effect
-- for any frame with isBank=true, which would immediately end the real
-- server-side bank interaction if it ran for real - suppressing OnHide
-- around the :Hide() call avoids that while still getting a real, correct
-- IsShown() == false. module:OnFrameHidden() is responsible for actually
-- closing the bank via BankAPI.Close() when appropriate.
local function HideElvUIBankFrame()
	if B.BankFrame and B.BankFrame:IsShown() then
		SnapshotBankNewItems()

		local onHide = B.BankFrame:GetScript("OnHide")
		B.BankFrame:SetScript("OnHide", nil)
		B.BankFrame:Hide()
		B.BankFrame:SetScript("OnHide", onHide)
	end
end

-- ElvUI's "Anchor Tooltip to Bags" option (Options > ElvUI > Tooltip) only
-- knows about B.BagFrame - since that's now always hidden while our frame is
-- up (see HideElvUIBagFrame above), ElvUI's own default-anchor logic falls
-- through to its generic screen-quadrant fallback instead, which is what
-- was reported as tooltips popping up in the middle of the screen instead
-- of tucked above the bag window like ElvUI users are used to. Blizzard's
-- GameTooltip_SetDefaultAnchor is a plain global function called from all
-- over the place (unit frames, action bars, ElvUI's own bag frame, ...)
-- whenever something wants a tooltip positioned "wherever the user's
-- default is" rather than somewhere explicit - ElvUI itself hooks this same
-- global (see its Tooltip.lua) to layer its own anchor-to-bags/quadrant
-- logic on top of Blizzard's plain default. Hooking it here too (after
-- ElvUI's own hook already ran) lets us override its result with our own
-- frame as the anchor target, using the exact same math and the user's own
-- ElvUI tooltip settings, instead of duplicating that whole system.
--
-- Doesn't affect our own item-slot tooltips (Slot_OnEnter) - those call
-- GameTooltip:SetOwner(self, "ANCHOR_RIGHT") directly and never go through
-- this function at all.
function module:OnGameTooltipDefaultAnchor(tt)
	local db = TT.db
	if not tt or tt:IsForbidden() or not E.private.tooltip.enable or not db or db.cursorAnchor then
		return
	end

	-- Anchor wasn't left at the default by ElvUI's own hook (e.g. combat/
	-- action-bar visibility rules hid it, or something set an explicit
	-- anchor of its own) - leave it alone rather than second-guessing that.
	if tt:GetAnchorType() ~= "ANCHOR_NONE" then
		return
	end

	local anchorBags = db.anchorToBags
	if not anchorBags or anchorBags == "DISABLED" then
		return
	end

	local anchorFrame = (module.frame and module.frame:IsShown() and module.frame)
		or (module.bankFrame and module.bankFrame:IsShown() and module.bankFrame)
	if not anchorFrame then
		return
	end

	tt:ClearAllPoints()
	tt:Point(E.InversePoints[anchorBags], anchorFrame, anchorBags, db.xOffset, db.yOffset)
end

-- Class-colored arrow on hover, the same treatment the title bar buttons,
-- the Recent Items "X" and the placeholder slots already get. Hooked, so
-- the tooltip scripts set up by the caller keep running.
function module.AddCollapseButtonHover(btn)
	local function Tint(r, g, b)
		for _, tex in ipairs({ btn:GetNormalTexture(), btn:GetPushedTexture() }) do
			if tex then
				tex:SetVertexColor(r, g, b)
			end
		end
	end

	btn:HookScript("OnEnter", function()
		local cc = E.myClassColor
		Tint(cc.r, cc.g, cc.b)
	end)
	btn:HookScript("OnLeave", function()
		Tint(1, 1, 1)
	end)
end

-- Expanded: top-right corner next to the "Categories" title. Collapsed: the
-- title is gone and the corner would leave the arrow dangling off to the
-- side, so it sits centered over the icon column (row inset 4 + icon inset
-- 4 + half the 16px icon) instead.
function module.PositionCollapseButton(f, collapsed)
	f.collapseButton:ClearAllPoints()
	if collapsed then
		f.collapseButton:Point("TOP", f.sidebar, "TOPLEFT", 16, -4)
	else
		f.collapseButton:Point("TOPRIGHT", f.sidebar, "TOPRIGHT", -2, -4)
	end
end

-- Softens the sidebar's right edge: a class-colored line that fades out
-- towards the top and bottom, plus a short shadow falling into the gap
-- towards the items. Shared by the bag and bank windows.
function module.AddSidebarEdge(sidebar)
	local cc = E.myClassColor

	local function Half(point, relPoint, fromAlpha, toAlpha)
		local tex = sidebar:CreateTexture(nil, "OVERLAY")
		tex:SetTexture(E.media.blankTex)
		tex:Width(1)
		tex:Point(point, sidebar, point, -1, point == "TOPRIGHT" and -1 or 1)
		tex:Point(relPoint, sidebar, "RIGHT", -1, 0)
		tex:SetGradient("VERTICAL", CreateColor(cc.r, cc.g, cc.b, fromAlpha), CreateColor(cc.r, cc.g, cc.b, toAlpha))
		return tex
	end
	-- VERTICAL gradients run bottom (first color) to top (second color).
	sidebar.edgeTop = Half("TOPRIGHT", "BOTTOMRIGHT", 0.6, 0)
	sidebar.edgeBottom = Half("BOTTOMRIGHT", "TOPRIGHT", 0, 0.6)

	sidebar.edgeShadow = sidebar:CreateTexture(nil, "BACKGROUND")
	sidebar.edgeShadow:SetTexture(E.media.blankTex)
	sidebar.edgeShadow:Width(6)
	sidebar.edgeShadow:Point("TOPLEFT", sidebar, "TOPRIGHT", 0, 0)
	sidebar.edgeShadow:Point("BOTTOMLEFT", sidebar, "BOTTOMRIGHT", 0, 0)
	sidebar.edgeShadow:SetGradient("HORIZONTAL", CreateColor(0, 0, 0, 0.35), CreateColor(0, 0, 0, 0))
end

-- Reskins a scrollbar to a thin, track-less thumb: HandleScrollBar's own
-- thumbX narrows the thumb via an inset (same technique as the options-page
-- scrollbar, Options/Widgets/ScrollBar.lua), and the separate track backdrop
-- it creates behind the thumb gets hidden outright instead of just inset.
-- ElvUI's own scrollbar skin re-applies its generic accent color
-- (E.media.rgbvaluecolor) on every SetMinMaxValues call (i.e. on every
-- content refresh) via its own ThumbStatus watcher - hook the same event
-- ourselves, after it runs, to recolor the thumb class-colored instead,
-- matching the rest of our class-colored accents (header divider,
-- placeholder "+", selected/pinned sidebar rows).
local function TintScrollThumb(scrollbar)
	if scrollbar.Thumb and scrollbar.Thumb.backdrop and scrollbar:IsEnabled() and select(2, scrollbar:GetMinMaxValues()) ~= 0 then
		local cc = E.myClassColor
		scrollbar.Thumb.backdrop:SetBackdropColor(cc.r, cc.g, cc.b)
	end
end

local function SkinScrollBar(scrollbar)
	local ok = pcall(S.HandleScrollBar, S, scrollbar, nil, 4)
	if ok and scrollbar.backdrop then
		scrollbar.backdrop:Hide()
	end

	hooksecurefunc(scrollbar, "SetMinMaxValues", TintScrollThumb)
	TintScrollThumb(scrollbar)
end

-- Tints the title's "used / total" counter as the container fills up, so a
-- nearly-full bag is noticeable at a glance instead of only by reading numbers.
local function SetTitleCount(fontString, used, total, searchHits)
	-- While a search is active the counter reports the matches instead.
	if searchHits then
		local cc = E.myClassColor
		fontString:SetText(format(L["%d results"], searchHits))
		fontString:SetTextColor(cc.r, cc.g, cc.b)
		return
	end

	fontString:SetText(format("%d / %d %s", used, total, L["Items"]))

	local ratio = total > 0 and used / total or 0
	if ratio >= 0.95 then
		fontString:SetTextColor(1, 0.25, 0.25)
	elseif ratio >= 0.8 then
		fontString:SetTextColor(1, 0.82, 0.2)
	else
		fontString:SetTextColor(1, 1, 1)
	end
end

-- Thin fill-level bar just above the footer row, same warning thresholds as
-- the counter above (class color while there's room). Its own thin texture
-- can't take mouse input, so a slightly taller invisible frame over it carries
-- the explanatory tooltip.
local function FillBar_OnEnter(self)
	if GameTooltip:IsForbidden() then
		return
	end

	local used, total = self.used or 0, self.total or 0
	local percent = total > 0 and floor(used / total * 100 + 0.5) or 0

	GameTooltip:SetOwner(self, "ANCHOR_TOP")
	GameTooltip:AddLine(L["Fill Level"], 1, 1, 1)
	GameTooltip:AddLine(format(L["%d of %d slots used (%d%%)"], used, total, percent), 0.8, 0.8, 0.8)
	GameTooltip:AddLine(format(L["%d free"], total - used), 0.6, 0.6, 0.6)
	GameTooltip:AddLine(L["Class color; turns yellow at 80% and red at 95%."], 0.6, 0.6, 0.6)
	GameTooltip:Show()
end

local function CreateFillBar(f)
	f.fillBar = f.footer:CreateTexture(nil, "OVERLAY")
	f.fillBar:Height(2)
	f.fillBar:Point("TOPLEFT", f.footer, "TOPLEFT", 0, 3)

	f.fillBarHit = CreateFrame("Frame", nil, f.footer)
	f.fillBarHit:Height(6)
	f.fillBarHit:Point("TOPLEFT", f.footer, "TOPLEFT", 0, 5)
	f.fillBarHit:Point("TOPRIGHT", f.footer, "TOPRIGHT", 0, 5)
	f.fillBarHit:EnableMouse(true)
	f.fillBarHit:SetScript("OnEnter", FillBar_OnEnter)
	f.fillBarHit:SetScript("OnLeave", GameTooltip_Hide)
end

local function SetFillBar(f, used, total)
	f.fillBarHit.used, f.fillBarHit.total = used, total

	local ratio = total > 0 and used / total or 0
	local r, g, b
	if ratio >= 0.95 then
		r, g, b = 1, 0.25, 0.25
	elseif ratio >= 0.8 then
		r, g, b = 1, 0.82, 0.2
	else
		local cc = E.myClassColor
		r, g, b = cc.r, cc.g, cc.b
	end

	f.fillBar:SetColorTexture(r, g, b, 0.9)
	f.fillBar:SetWidth(math.max(1, f.footer:GetWidth() * ratio))
end

-- nil when no search is active. Relies on the native item-search filter
-- having just been applied by this refresh's item collection pass.
local function CountSearchHits(bagIDList)
	if not (module.searchText and module.searchText ~= "") then
		return nil
	end

	local hits = 0
	for _, bagID in ipairs(bagIDList) do
		for slotID = 1, C_Container_GetContainerNumSlots(bagID) do
			local info = C_Container_GetContainerItemInfo(bagID, slotID)
			if info and info.iconFileID and not info.isFiltered then
				hits = hits + 1
			end
		end
	end
	return hits
end

-- Selected fixed sidebar rows (view-mode / bank tab rows) tint their label in
-- class color on top of the existing highlight bar.
function module.SetSelectedRowTextColor(row, isSelected)
	if isSelected then
		local cc = E.myClassColor
		row.text:SetTextColor(cc.r, cc.g, cc.b)
	else
		row.text:SetTextColor(1, 1, 1)
	end
end

local function SetCategoryIcon(tex, cat)
	if not tex or not cat then
		return
	end

	if cat.isAtlas then
		tex:SetAtlas(cat.icon)
		return
	end

	tex:SetTexture(cat.icon)

	-- Raw item icons (numeric fileID, or an "Interface\Icons\..." path) carry
	-- Blizzard's built-in border in their UVs and need cropping; ElvUI's own
	-- pre-cropped media textures already fill the full UV space.
	local icon = cat.icon
	local isRawItemIcon = type(icon) == "number" or (type(icon) == "string" and icon:find([[Icons\]], 1, true))
	if isRawItemIcon then
		tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	else
		tex:SetTexCoord(0, 1, 0, 1)
	end
end

-------------------------------------------------------------------------------
--  Item slot buttons
-------------------------------------------------------------------------------
-- Native Blizzard/Pawn-style stack splitting: SetAttribute is only
-- combat-protected (safe to call from plain insecure code, just not during
-- combat), not restricted to hardware-event contexts, and PreClick runs
-- before the button's own secure type/item dispatch evaluates those
-- attributes for the SAME click - so nil-ing them here (and PostClick
-- restoring them) is the sanctioned way to stop a Shift+Right (or whatever
-- the user's Split Stack binding is) from also using/equipping the item.
local function Slot_SplitStack(self, split)
	if self.BagID and self.SlotID then
		C_Container.SplitContainerItem(self.BagID, self.SlotID, split)

		-- With "Merge Duplicate Stacks" the two halves would be shown as one
		-- slot again right away, as if nothing happened. Keep this item's
		-- stacks apart until the bags close (MergeDuplicateEntries).
		if self.itemLink then
			module.unmergedLinks[self.itemLink] = true
		end

		-- The category views show no empty bag slots, so there is nowhere
		-- to click the split-off part down - put it in a free slot right
		-- away instead of leaving it on the cursor. Retried a frame later
		-- in case the cursor isn't filled yet.
		local bagID = self.BagID
		if CursorHasItem() then
			module:PlaceCursorItemNear(bagID)
		else
			C_Timer.After(0, function()
				module:PlaceCursorItemNear(bagID)
			end)
		end
	end
end

-- Opens Blizzard's split dialog for a stackable slot (Shift+click, same as
-- Blizzard's own bags). Shared by the left- and right-click paths.
function module:OpenSplitStack(btn)
	if not btn.BagID or not btn.SlotID then
		return
	end

	local info = C_Container_GetContainerItemInfo(btn.BagID, btn.SlotID)
	if info and not info.isLocked and info.stackCount and info.stackCount > 1 then
		btn.SplitStack = Slot_SplitStack
		_G.StackSplitFrame:OpenStackSplitFrame(info.stackCount, btn, "BOTTOMRIGHT", "TOPRIGHT")
	end
end

-- Pin/Recent/category-assignment actions on a slot need to refresh whichever
-- top-level frame actually owns that slot (module.frame vs module.bankFrame)
-- - always refreshing the bag frame left the Bank frame's own Pinned count
-- stale until some unrelated BAG_UPDATE happened to catch it up, since a
-- bank item never appears in the bag frame's own Pinned section at all.
local function RefreshOwnerFrame(ownerFrame)
	if ownerFrame == module.bankFrame then
		module:RefreshBankCategoryFrame()
	else
		module:RefreshCategoryFrame()
	end
end

-- Right-click "use" needs real secure type/item attributes on a
-- SecureActionButtonTemplate button to avoid ADDON_ACTION_FORBIDDEN (see
-- UpdateSlotVisual); a plain overlay on top to carry Left/Middle separately
-- didn't work (an unregistered click type doesn't fall through to the frame
-- below, it's just swallowed), so everything lives on one button. PreClick
-- handles our own Left/Middle logic; RightButton falls through untouched to
-- the button's native OnClick, which dispatches the secure type/item
-- attributes (needs the RightButtonDown click phase registered too, see
-- CreateSlotButton).
local function Slot_OnClick(self, mouseButton, down)
	-- LeftButtonDown is registered only for spell targeting (see below):
	-- the secure action may fire on the down phase (ActionButtonUseKeyDown),
	-- so the "/use" macro has to be in place by then. Every other left-click
	-- keeps being handled once, on release.
	if mouseButton == "LeftButton" and down then
		if
			not InCombatLockdown()
			and self.BagID
			and self.SlotID
			and not IsModifiedClick()
			and (SpellCanTargetItem() or SpellCanTargetItemID())
		then
			-- A spell is waiting for an item target (Disenchant, Milling,
			-- Prospecting, enchant scrolls, armor kits...). Blizzard's own
			-- bags answer that with UseContainerItem(bag, slot), which is
			-- protected - so hand this click to the secure button as a
			-- "/use bag slot" macro. The "item" action can't do it: it equips
			-- gear rather than targeting it. Stays set until the release
			-- below, since the secure action fires on down OR up depending
			-- on the player's key-down setting.
			self:SetAttribute("type1", "macro")
			self:SetAttribute("macrotext1", format("/use %d %d", self.BagID, self.SlotID))
			self.pendingTargetClick = true
		elseif self.pendingTargetClick and not InCombatLockdown() then
			-- Left over from a targeting press that was released somewhere
			-- else: drop it now, before this plain click's secure dispatch
			-- could run the stale "/use" and use or equip the item.
			self:SetAttribute("type1", nil)
			self:SetAttribute("macrotext1", nil)
			self.pendingTargetClick = nil
		end
		return
	end

	if mouseButton == "LeftButton" and self.pendingTargetClick then
		self.pendingTargetClick = nil
		C_Timer.After(0, function()
			if not InCombatLockdown() then
				self:SetAttribute("type1", nil)
				self:SetAttribute("macrotext1", nil)
			end
		end)
		return
	end

	-- Right button here; the left button goes through the chat-link check
	-- first (see below). IsModifiedClick("SPLITSTACK") only checks the held
	-- modifier key, not which mouse button - matched unconditionally it
	-- swallowed Shift+Left-click links and Shift+Middle-click assigns.
	if mouseButton == "RightButton" and IsModifiedClick("SPLITSTACK") and not CursorHasItem() then
		if not InCombatLockdown() then
			self:SetAttribute("*type2", nil)
			self:SetAttribute("item", nil)

			-- Restored via a deferred call instead of a PostClick script -
			-- merely having a PostClick handler on this button appears to
			-- disturb the native secure type/item dispatch's own timing for
			-- a *plain* right-click (equips instead of selling at a
			-- merchant), even when that handler is a no-op for that click.
			local itemLink = self.itemLink
			C_Timer.After(0, function()
				if not InCombatLockdown() then
					self:SetAttribute("*type2", "item")
					self:SetAttribute("item", itemLink)
				end
			end)
		end

		module:OpenSplitStack(self)

		return
	end

	if mouseButton == "LeftButton" then
		if IsModifiedClick() then
			-- Same order as Blizzard's own bags: a chat link (only when a
			-- chat edit box is open), dress-up and the like win; otherwise
			-- Shift+click splits the stack.
			local itemLocation = self.BagID and self.SlotID and ItemLocation:CreateFromBagAndSlot(self.BagID, self.SlotID)
			if
				not HandleModifiedItemClick(self.itemLink, itemLocation)
				and IsModifiedClick("SPLITSTACK")
				and not CursorHasItem()
			then
				module:OpenSplitStack(self)
			end
		elseif self.BagID and self.SlotID then
			C_Container_PickupContainerItem(self.BagID, self.SlotID)
		end
	elseif mouseButton == "MiddleButton" then
		if IsShiftKeyDown() then
			module:OpenAssignMenu(self)
		else
			module:TogglePinned(self.itemID)
			RefreshOwnerFrame(self.ownerFrame)
		end
	elseif mouseButton == "RightButton" then
		-- Ctrl+Right-click while the bank is open offers a "move to a specific
		-- tab/bag" picker (plain right-click below also deposits/withdraws,
		-- but always into the first free slot - this is for when the
		-- destination matters). Cursor must be empty (nothing to pick a
		-- destination for otherwise); same attribute suppression as the Split
		-- Stack/vendor-sell cases so the native dispatch doesn't equip/use the
		-- item instead of just opening the menu.
		if
			IsControlKeyDown()
			and not CursorHasItem()
			and module.isBankOpen
			and self.BagID
			and self.SlotID
		then
			if not InCombatLockdown() then
				self:SetAttribute("*type2", nil)
				self:SetAttribute("item", nil)

				local itemLink = self.itemLink
				C_Timer.After(0, function()
					if not InCombatLockdown() then
						self:SetAttribute("*type2", "item")
						self:SetAttribute("item", itemLink)
					end
				end)
			end

			module:OpenMoveMenu(self)
			return
		end

		-- The native type/item dispatch (fires on RightButtonDown, see
		-- CreateSlotButton) is equivalent to "/use [item link]", which is
		-- just a plain use/equip with no context awareness at all - both the
		-- vendor-sell AND the bank-deposit/withdraw special-casing live only
		-- inside Blizzard's own C_Container.UseContainerItem, never in the
		-- generic secure item click. Confirmed live: left as the native
		-- dispatch, right-click at an open bank equips gear instead of
		-- depositing it (and does nothing at all for non-equippable items,
		-- since a plain "/use" has no effect on those). The native dispatch
		-- also fires synchronously, BEFORE our deferred UseContainerItem call
		-- below runs on the next frame - left alone it would equip/use first
		-- and our deferred call would then act on the wrong (swapped-in)
		-- item. Suppressing the attributes here (same technique as the Split
		-- Stack click above) stops that dispatch from firing for this click
		-- at all, so only our own context-aware call decides what happens.
		local atMerchant = _G.MerchantFrame and _G.MerchantFrame:IsShown()
		if not InCombatLockdown() and (atMerchant or module.isBankOpen) and self.BagID and self.SlotID then
			local bagID, slotID = self.BagID, self.SlotID
			local itemLink = self.itemLink

			self:SetAttribute("*type2", nil)
			self:SetAttribute("item", nil)

			C_Timer.After(0, function()
				C_Container.UseContainerItem(bagID, slotID)

				if not InCombatLockdown() then
					self:SetAttribute("*type2", "item")
					self:SetAttribute("item", itemLink)
				end
			end)
		end
	end
end

-- Manual item order, one list of item IDs per section key (category, group
-- or Pinned Items), set by alt-dragging a slot onto another one. Items with
-- no stored position keep their normal order behind the ones that have one,
-- so picking up something new never reshuffles what the user arranged.
function module:GetItemOrder(sectionKey)
	local db = module.db
	return sectionKey and db.itemOrder and db.itemOrder[sectionKey] or nil
end

function module:ClearItemOrder(sectionKey)
	local db = module.db
	if db.itemOrder then
		db.itemOrder[sectionKey] = nil
	end
end

local function ApplyItemOrder(sectionKey, items)
	local order = module:GetItemOrder(sectionKey)
	if not order or #items < 2 then
		return items
	end

	local position = {}
	for index, itemID in ipairs(order) do
		position[itemID] = index
	end

	local decorated = {}
	for index, entry in ipairs(items) do
		tinsert(decorated, {
			entry = entry,
			position = position[entry.itemID] or (#order + index),
			index = index,
		})
	end

	tsort(decorated, function(a, b)
		if a.position == b.position then
			return a.index < b.index
		end
		return a.position < b.position
	end)

	local sorted = {}
	for _, item in ipairs(decorated) do
		tinsert(sorted, item.entry)
	end

	return sorted
end

-- Alt-drag reorder: seeds the stored list from what is on screen, then moves
-- the dragged item in front of the one it was dropped on.
local function MoveItemInOrder(sectionKey, items, draggedID, targetID)
	if not sectionKey or not draggedID or not targetID or draggedID == targetID then
		return
	end

	local db = module.db
	db.itemOrder = db.itemOrder or {}

	local order = db.itemOrder[sectionKey]
	if not order then
		order = {}
		local seen = {}
		for _, entry in ipairs(items) do
			if entry.itemID and not seen[entry.itemID] then
				seen[entry.itemID] = true
				tinsert(order, entry.itemID)
			end
		end
		db.itemOrder[sectionKey] = order
	end

	for index, itemID in ipairs(order) do
		if itemID == draggedID then
			tremove(order, index)
			break
		end
	end

	for index, itemID in ipairs(order) do
		if itemID == targetID then
			tinsert(order, index, draggedID)
			return
		end
	end

	tinsert(order, draggedID)
end

local function Slot_OnDrag(self)
	-- Alt held: rearrange the view instead of physically moving the item.
	-- Deliberately a raw IsAltKeyDown() and not IsModifiedClick(): there is
	-- no Blizzard click binding for "reorder", and a binding check would
	-- also report true for whatever else the player put on Alt. Ours runs
	-- first, so an Alt-drag in our frame always reorders - the tooltip says
	-- so while Alt is held.
	-- Only inside a section that has a stable identity to store an order
	-- under (orderKey is nil for the bag views and All Items).
	if IsAltKeyDown() and self.orderKey and self.itemID then
		module.draggingOrderKey = self.orderKey
		module.draggingOrderItemID = self.itemID
		module.dragHoverOrderItemID = nil
		self:SetAlpha(0.4)
		return
	end

	if self.BagID and self.SlotID then
		C_Container_PickupContainerItem(self.BagID, self.SlotID)
	end
end

local function Slot_OnDragStop(self)
	if not module.draggingOrderKey then
		return
	end

	self:SetAlpha(1)

	local sectionKey = module.draggingOrderKey
	local draggedID = module.draggingOrderItemID
	local targetID = module.dragHoverOrderItemID
	module.draggingOrderKey = nil
	module.draggingOrderItemID = nil
	module.dragHoverOrderItemID = nil

	if draggedID and targetID then
		MoveItemInOrder(sectionKey, module.orderedSectionItems and module.orderedSectionItems[sectionKey], draggedID, targetID)
		RefreshOwnerFrame(self.ownerFrame)
	end
end

-- Replicates the one bit of ContainerFrameItemButtonMixin:OnUpdate() we
-- actually want (the vendor "sell" cursor on hover) without calling the
-- mixin itself - it resolves bag/slot via self:GetBagID()/self:GetID(),
-- which read from a one-frame-per-bag hierarchy our pooled buttons don't
-- have, so it silently uses wrong data if invoked directly (see CreateSlotButton).
local function Slot_UpdateCursor(self)
	if SpellIsTargeting and SpellIsTargeting() then
		return
	end

	if _G.MerchantFrame and _G.MerchantFrame:IsShown() and _G.MerchantFrame.selectedTab == 1 and self.BagID and self.SlotID then
		C_Container.ShowContainerSellCursor(self.BagID, self.SlotID)
	else
		ResetCursor()
	end
end

local function Slot_OnEnter(self)
	if self.ownerFrame then
		self.ownerFrame:SetFrameLevel(self.ownerFrame:GetFrameLevel())
	end

	if self.BagID and self.SlotID and not GameTooltip:IsForbidden() then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetBagItem(self.BagID, self.SlotID)
		if module.isBankOpen then
			GameTooltip:AddLine(L["Ctrl+Right-click to move to a specific tab/bag"], 0.6, 0.6, 0.6)
		end

		-- Shown on every item of a reorderable section, not just while Alt
		-- is held: the feature is invisible otherwise, and the hint is where
		-- people look when they wonder why an item sits where it sits.
		if self.orderKey then
			GameTooltip:AddLine(L["Alt+Drag onto another item to move it there. Items stay in their bag slots."], 0.6, 0.6, 0.6)
		end

		GameTooltip:Show()
	end

	Slot_UpdateCursor(self)

	if module.draggingOrderKey and self.orderKey == module.draggingOrderKey then
		module.dragHoverOrderItemID = self.itemID
	end

	-- Blizzard's own bags drop an item's "new" state as soon as you hover
	-- its slot (ContainerFrameItemButtonMixin:OnUpdate), so do the same -
	-- glow and badge only mark what you haven't looked at yet. The Recent
	-- Items list is tracked separately by item ID and stays put.
	if self.BagID and self.SlotID and self.newItemGlow and self.newItemGlow:IsShown() then
		API.RemoveNewItem(self.BagID, self.SlotID)
		newItemSnapshot[self.BagID * 1000 + self.SlotID] = nil
		self.newItemGlow:Hide()
		if self.newBadge then
			self.newBadge:Hide()
		end
	end
end

local function Slot_OnLeave(self)
	if module.draggingOrderKey and self and module.dragHoverOrderItemID == self.itemID then
		module.dragHoverOrderItemID = nil
	end

	if not GameTooltip:IsForbidden() then
		GameTooltip:Hide()
	end

	if not (SpellIsTargeting and SpellIsTargeting()) then
		ResetCursor()
	end
end

-- Drives the pulsing "new item" glow, same technique as ElvUI's own bags
-- (one shared fade animation per top-level frame, alternating its target
-- alpha between 0 and 1 on every finish instead of a one-shot fade).
local function NewItemGlowOnFinished(self)
	self:SetChange(self:GetChange() == 1 and 0 or 1)
end

-- Bag and Bank/Warband are two independent top-level frames that can both be
-- shown at once (opening the bank auto-shows the bags too, see OnBankOpened),
-- so their pooled slot/header/sub-header/sidebar-row objects can't share one
-- set of tables - two refreshes on the same event tick would otherwise fight
-- over (and visually corrupt) the same recycled buttons. CreateSlotPoolFor
-- (and its Header/SubHeader/Sidebar counterparts below) each produce one
-- independent, closure-owned pool instead, parented/named per the frame that
-- owns them (see CreatePoolSet's bagPools/bankPools instantiation).
-- Darkens item slots with the button's own search overlay (the same dark
-- tint ElvUI's bags use): all of them while a sort settles, and everything
-- outside the hovered bag while hovering the bag bar. SetAlpha isn't an
-- option here - ItemButtonMixin overrides it and would re-show the Blizzard
-- IconBorder we hide. Bag frame only, since both triggers are bag-only.
local slotPools = {}

-- True when Blizzard's item-context system says this slot can't take part
-- in whatever is waiting for an item right now: Disenchant/Milling/
-- Prospecting and other spells with an item condition, enchant scrolls,
-- the scrapper, item upgrades... Blizzard's own bags dim exactly these via
-- ItemButtonUtil, so we ask the same function instead of guessing per spell.
--
-- Disenchant, Milling and Prospecting report no item context at all
-- (confirmed live: GetItemContext() nil, TargetSpellChecksItemCondition()
-- false while the Disenchant cursor is up), so those get their own checks,
-- keyed by the spell that owns the targeting cursor (GetPendingTargetSpellCheck).
local TargetSpellChecks = {
	-- Disenchant: uncommon to epic weapons, armor (minus cosmetics) and
	-- profession gear.
	[13262] = function(bagID, slotID)
		local info = C_Container_GetContainerItemInfo(bagID, slotID)
		if not info or not info.hyperlink or not info.quality then
			return false
		end
		if info.quality < Enum.ItemQuality.Uncommon or info.quality > Enum.ItemQuality.Epic then
			return false
		end

		local _, _, _, _, _, classID, subClassID = API.GetItemInfoInstant(info.hyperlink)
		if classID == Enum.ItemClass.Weapon then
			return true
		elseif classID == Enum.ItemClass.Armor then
			return subClassID ~= Enum.ItemArmorSubclass.Cosmetic
		elseif classID == Enum.ItemClass.Profession then
			return API.IsEquippableItem(info.hyperlink)
		end

		return false
	end,
}

-- Milling and Prospecting: the item's own tooltip says "Millable" /
-- "Prospectable", and both need a stack of at least five.
do
	local function TooltipCheck(globalStringName)
		return function(bagID, slotID)
			local label = _G[globalStringName]
			local info = C_Container_GetContainerItemInfo(bagID, slotID)
			if not label or not info or (info.stackCount or 0) < 5 then
				return false
			end

			local data = API.GetBagItemTooltip(bagID, slotID)
			for _, line in ipairs(data and data.lines or {}) do
				if line.leftText == label then
					return true
				end
			end

			return false
		end
	end
	TargetSpellChecks[51005] = TooltipCheck("ITEM_MILLABLE")
	TargetSpellChecks[31252] = TooltipCheck("ITEM_PROSPECTABLE")
end
module.TargetSpellChecks = TargetSpellChecks

local function IsSlotOutOfItemContext(btn)
	if not module.itemContextActive or not module.db.effects.itemContextDim then
		return false
	end
	if not btn.BagID or not btn.SlotID then
		return false
	end

	local spellCheck = module.targetSpellCheck
	if spellCheck then
		return not spellCheck(btn.BagID, btn.SlotID)
	end

	local itemLocation = ItemLocation:CreateFromBagAndSlot(btn.BagID, btn.SlotID)
	local result = _G.ItemButtonUtil.GetItemContextMatchResultForItem(itemLocation)
	return result == _G.ItemButtonUtil.ItemContextMatchResult.Mismatch
end

local function ApplySlotDim(btn)
	if not btn.searchOverlay then
		return
	end

	local dim = IsSlotOutOfItemContext(btn)
	if not dim and module.sortingBags then
		dim = btn.ownerFrame == (module.sortingFrame or module.frame)
	end
	if not dim and btn.ownerFrame == module.frame then
		dim = module.hoveredBagID ~= nil and btn.BagID ~= module.hoveredBagID
	end
	btn.searchOverlay:SetShown(dim and true or false)
end

local function RefreshSlotDim()
	for _, pool in ipairs(slotPools) do
		for _, btn in ipairs(pool) do
			if btn:IsShown() then
				ApplySlotDim(btn)
			end
		end
	end
end

local function CreateSlotPoolFor(namePrefix, getContentChild, getOwnerFrame)
	local slotPool = {}
	tinsert(slotPools, slotPool)

	local function CreateSlotButton(index)
		local btn = CreateFrame(
			"ItemButton",
			namePrefix .. index,
			getContentChild(),
			"ContainerFrameItemButtonTemplate,SecureActionButtonTemplate"
		)

		local ok = pcall(btn.SetTemplate, btn, nil, true)
	if not ok then
		pcall(btn.SetTemplate, btn)
	end

	-- Blizzard's native button chrome (the slot-frame art behind the icon);
	-- we draw our own flat border via SetTemplate instead, same as ElvUI.
	btn:SetNormalTexture(E.ClearTexture)

	-- Same flat hover/pressed overlay ElvUI's own bag slots get; the hover
	-- tint is applied per refresh in UpdateSlotVisual so option changes take
	-- effect on already-pooled buttons.
	pcall(btn.StyleButton, btn)

	-- Blizzard's own native border square; we draw quality color via
	-- SetTemplate/SetItemButtonQuality ourselves, same as ElvUI's own bags.
	if btn.IconBorder then
		btn.IconBorder:SetAlpha(0)
	end

	-- Inset the icon so it doesn't cover our own border, and crop it the
	-- way ElvUI's own bags do instead of Blizzard's default icon framing.
	if btn.icon then
		btn.icon:SetInside()
		btn.icon:SetTexCoords()
	end

	-- IconOverlay/IconOverlay2 (Azerite/Corrupted/Cosmetic/Conduit/Curio/Decor
	-- item frames, set via SetItemButtonOverlay in UpdateSlotVisual) default
	-- to a fixed 37px size from the template; inset them the same way as the
	-- icon so they scale with our own user-configurable item size instead.
	if btn.IconOverlay then
		btn.IconOverlay:SetInside()
	end
	if btn.IconOverlay2 then
		btn.IconOverlay2:SetInside()
	end

	-- Defaults to shown until something hides it. Search doesn't use it (we
	-- filter non-matching items out of the list entirely); it's the sort and
	-- bag-hover dimming instead (ApplySlotDim), tinted like ElvUI's own bags.
	if btn.searchOverlay then
		btn.searchOverlay:SetColorTexture(0, 0, 0, 0.6)
		btn.searchOverlay:Hide()
	end

	btn.itemLevel = btn:CreateFontString(nil, "OVERLAY")
	btn.bindType = btn:CreateFontString(nil, "OVERLAY")

	if btn.BattlepayItemTexture then
		btn.BattlepayItemTexture:Hide()
	end

	-- Re-texture Blizzard's built-in quest-item overlay with ElvUI's own
	-- flat icon (same as ElvUI's own bags), filling the slot instead of
	-- Blizzard's default small corner glow.
	if btn.IconQuestTexture then
		btn.IconQuestTexture:SetTexture(E.Media.Textures.BagQuestIcon)
		btn.IconQuestTexture:SetTexCoord(0, 1, 0, 1)
		btn.IconQuestTexture:SetInside()
		btn.IconQuestTexture:Hide()
	end

	-- Junk (grey, sellable) marker - same atlas ElvUI's own bags use, sized
	-- relative to the item's own size in UpdateSlotVisual since itemSize is
	-- a user option here (ElvUI's bags use a fixed button size).
	btn.JunkIcon = btn:CreateTexture(nil, "OVERLAY", nil, 2)
	btn.JunkIcon:SetAtlas("bags-junkcoin", true)
	btn.JunkIcon:Point("TOPRIGHT", -1, -1)
	btn.JunkIcon:Hide()

	-- Warband marker for Warbound / Warbound-until-equipped items (same atlas
	-- Blizzard's own currency UI uses for account-wide things).
	btn.warboundIcon = btn:CreateTexture(nil, "OVERLAY", nil, 3)
	btn.warboundIcon:SetAtlas("warbands-icon")
	btn.warboundIcon:Point("TOPRIGHT", -1, -1)
	btn.warboundIcon:Hide()

	-- Pinned marker, so a pinned item is recognizable in its normal category
	-- too (same atlas as the Pinned Items category icon).
	btn.pinIcon = btn:CreateTexture(nil, "OVERLAY", nil, 3)
	btn.pinIcon:SetAtlas(module.PinnedCategory.icon)
	btn.pinIcon:Point("BOTTOMLEFT", 1, 1)
	btn.pinIcon:Hide()

	-- Pawn upgrade-arrow overlay (same as ElvUI's own bags) - Blizzard has no
	-- reliable native API for this, so it's driven entirely by the Pawn
	-- addon's own PawnShouldItemLinkHaveUpgradeArrowUnbudgeted, if installed.
	-- Centered on the icon, clear of the item level text's default TOPLEFT
	-- position. Font strings always draw above textures within the same
	-- layer regardless of sublevel, so real z-order control over the item
	-- level text isn't available here either way - this relies on staying
	-- spatially clear of it instead.
	btn.UpgradeIcon = btn:CreateTexture(nil, "OVERLAY", nil, 7)
	btn.UpgradeIcon:SetTexture(E.Media.Textures.BagUpgradeIcon)
	btn.UpgradeIcon:SetTexCoord(0, 1, 0, 1)
	btn.UpgradeIcon:Point("CENTER")
	btn.UpgradeIcon:Hide()

	-- Equipment Manager set marker (parity with EquipManager.lua's own icon
	-- on ElvUI's native bags) - texture/size/position/color applied fresh in
	-- UpdateEquipSetIcon from the same E.db.mui.bags.equipmentManager options.
	btn.equipIcon = btn:CreateTexture(nil, "OVERLAY")
	btn.equipIcon:Hide()

	-- The mixin resolves bag/slot from a one-frame-per-bag hierarchy we don't
	-- have (all pooled buttons share one parent), so its own OnUpdate and
	-- event handling end up working from wrong data; strip those. OnEnter/
	-- OnLeave get fully replaced (not hooked) since the mixin's own tooltip
	-- logic fights ours the same way. OnClick is left untouched (native) so
	-- its secure type/item dispatch keeps working; PreClick adds our own
	-- Left/Middle handling alongside it without disturbing RightButton.
	btn:SetScript("OnUpdate", nil)
	btn:UnregisterAllEvents()
	btn:SetScript("OnMouseDown", nil)
	btn:SetScript("OnMouseUp", nil)

	-- RightButtonDown too: the secure type/item dispatch needs the down-click
	-- phase registered, not just Up. LeftButtonDown for the same reason, but
	-- only acted on while a spell waits for an item target (Slot_OnClick).
	btn:RegisterForClicks("AnyUp", "RightButtonDown", "LeftButtonDown")
	btn:SetScript("PreClick", Slot_OnClick)

	btn:RegisterForDrag("LeftButton")
	btn:SetScript("OnDragStart", Slot_OnDrag)
	btn:SetScript("OnDragStop", Slot_OnDragStop)
	btn:SetScript("OnReceiveDrag", Slot_OnDrag)

	btn:SetScript("OnEnter", Slot_OnEnter)
	btn:SetScript("OnLeave", Slot_OnLeave)
	btn.UpdateTooltip = Slot_OnEnter

	-- Slot_OnEnter needs to bump the frame level of whichever top-level frame
	-- (bags or bank) this particular button actually belongs to.
	btn.ownerFrame = getOwnerFrame()

	-- Pulsing glow for newly picked-up items (entry.isNew - the same flag
	-- Recent Items uses), shown/colored in UpdateSlotVisual. Reuses ElvUI's
	-- own bag glow texture and its one-shared-animation-per-frame technique
	-- (cheaper than animating every slot individually, and keeps every glow
	-- on the same frame pulsing in sync).
	btn.newItemGlow = btn:CreateTexture(nil, "OVERLAY", nil, 1)
	btn.newItemGlow:SetTexture(E.Media.Textures.BagNewItemGlow)
	btn.newItemGlow:SetInside()
	btn.newItemGlow:Hide()

	local ownerFrame = btn.ownerFrame
	if not ownerFrame.NewItemGlow then
		ownerFrame.NewItemGlow = CreateAnimationGroup(ownerFrame)
		ownerFrame.NewItemGlow:SetLooping(true)

		ownerFrame.NewItemGlow.Fade = ownerFrame.NewItemGlow:CreateAnimation("fade")
		ownerFrame.NewItemGlow.Fade:SetDuration(0.7)
		ownerFrame.NewItemGlow.Fade:SetChange(0)
		ownerFrame.NewItemGlow.Fade:SetEasing("in")
		ownerFrame.NewItemGlow.Fade:SetScript("OnFinished", NewItemGlowOnFinished)
	end
	ownerFrame.NewItemGlow.Fade:AddChild(btn.newItemGlow)

	-- Same numeric cooldown-text/swipe-color treatment ElvUI's own bag slots
	-- get, driven by the user's existing ElvUI > Cooldown > Bags settings.
	-- RegisterCooldown is required, not automatic - ElvUI only applies its
	-- cooldown text to frames it knows about.
	if btn.Cooldown then
		E:RegisterCooldown(btn.Cooldown, "bags")
	end

		return btn
	end

	local function AcquireSlot(index)
		local btn = slotPool[index]
		if not btn then
			btn = CreateSlotButton(index)
			slotPool[index] = btn
		end

		btn:Show()
		return btn
	end

	local function ReleaseSlotsFrom(startIndex)
		for i = startIndex, #slotPool do
			slotPool[i]:Hide()
		end
	end

	return { Acquire = AcquireSlot, Release = ReleaseSlotsFrom }
end

-------------------------------------------------------------------------------
--  Category placeholder slots ("+"/empty slots after a category's real
--  items - drag an item onto one to assign it to that category, or pin it
--  for the Pinned section, without physically moving it in the bag)
-------------------------------------------------------------------------------
-- While an item is on the cursor, every drop-target placeholder lights up at
-- full opacity so it's obvious where it can be dropped to assign it; otherwise
-- they sit at their normal resting alpha. One entry per frame's pool (bag and
-- bank), so a cursor change can update both.
local placeholderPools = {}

local function ApplyDropHighlight(ph)
	local active = module.cursorHasItem and ph.onAssign and module.db.effects.dropTargetHighlight
	ph.dropHighlight:SetShown(active and true or false)
	ph:SetAlpha(active and 1 or ph.restAlpha or 1)
end

local function CreatePlaceholderPoolFor(getContentChild)
	local placeholderPool = {}

	local function OnPlaceholderDrop(self)
		if not (CursorHasItem() and self.onAssign) then
			return
		end

		local kind, itemID = GetCursorInfo()
		if kind == "item" and itemID then
			ClearCursor()
			self.onAssign(itemID)
		end
	end

	-- Every placeholder in a row accepts a drop (not just the visible "+"
	-- one), so all of them get the same hover feedback - a highlight plus a
	-- tooltip explaining what dropping an item here actually does, set fresh
	-- per-render in RenderCategorySections alongside onAssign.
	local function OnPlaceholderEnter(self)
		if GameTooltip:IsForbidden() or not self.tooltipText then
			return
		end

		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(self.tooltipText, 1, 1, 1, true)
		GameTooltip:Show()
	end

	local function OnPlaceholderLeave()
		GameTooltip_Hide()
	end

	local function CreatePlaceholder(index)
		local btn = CreateFrame("Button", nil, getContentChild())
		-- Same look as a real item slot (border/backdrop created once here);
		-- "transparent" for the filler slots is done via plain frame alpha
		-- below instead of ElvUI's "Transparent" template - that template's
		-- fill color comes from the user's own configurable ElvUI backdrop
		-- fade color, which can end up looking just as opaque as normal
		-- depending on their settings. Alpha is ours to control outright.
		local ok = pcall(btn.SetTemplate, btn, nil, true)
		if not ok then
			pcall(btn.SetTemplate, btn)
		end
		btn:EnableMouse(true)
		btn:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], "ADD")

		btn.plusIcon = btn:CreateTexture(nil, "OVERLAY")
		btn.plusIcon:SetPoint("CENTER")
		btn.plusIcon:SetSize(14, 14)
		btn.plusIcon:SetTexture(E.Media.Textures.Plus)
		local cc = E.myClassColor
		btn.plusIcon:SetVertexColor(cc.r, cc.g, cc.b)
		btn.plusIcon:Hide()

		btn.dropHighlight = btn:CreateTexture(nil, "ARTWORK")
		btn.dropHighlight:SetInside()
		btn.dropHighlight:SetColorTexture(cc.r, cc.g, cc.b, 0.25)
		btn.dropHighlight:Hide()

		btn:SetScript("OnReceiveDrag", OnPlaceholderDrop)
		btn:SetScript("OnMouseUp", OnPlaceholderDrop)
		btn:SetScript("OnEnter", OnPlaceholderEnter)
		btn:SetScript("OnLeave", OnPlaceholderLeave)

		placeholderPool[index] = btn
		return btn
	end

	local function AcquirePlaceholder(index)
		local btn = placeholderPool[index]
		if not btn then
			btn = CreatePlaceholder(index)
			placeholderPool[index] = btn
		end

		btn:Show()
		return btn
	end

	local function ReleasePlaceholdersFrom(startIndex)
		for i = startIndex, #placeholderPool do
			placeholderPool[i]:Hide()
		end
	end

	tinsert(placeholderPools, function()
		for _, ph in ipairs(placeholderPool) do
			if ph:IsShown() then
				ApplyDropHighlight(ph)
			end
		end
	end)

	return { Acquire = AcquirePlaceholder, Release = ReleasePlaceholdersFrom }
end

-- Pawn's own upgrade check can return nil ("not enough data yet", e.g. right
-- after login/reload before Pawn has scanned the player's equipped gear) -
-- ElvUI's own bags handle this the same way, by polling every 0.5s via
-- OnUpdate until Pawn has an actual true/false answer.
local UpdateUpgradeIcon

local function UpgradeCheck_OnUpdate(self, elapsed)
	self.upgradeCheckElapsed = (self.upgradeCheckElapsed or 0) + elapsed
	if self.upgradeCheckElapsed >= 0.5 then
		self.upgradeCheckElapsed = 0
		UpdateUpgradeIcon(self)
	end
end

function UpdateUpgradeIcon(btn)
	local iconSize = module.db.itemSize * 0.65
	btn.UpgradeIcon:SetSize(iconSize, iconSize)

	local itemLink = btn.itemLink
	if not _G.PawnShouldItemLinkHaveUpgradeArrowUnbudgeted or not itemLink then
		btn.UpgradeIcon:Hide()
		btn:SetScript("OnUpdate", nil)
		return
	end

	local _, _, _, equipLoc = API.GetItemInfoInstant(itemLink)
	if not equipLoc or not IS_EQUIPMENT_SLOT[equipLoc] then
		btn.UpgradeIcon:Hide()
		btn:SetScript("OnUpdate", nil)
		return
	end

	local isUpgrade = _G.PawnShouldItemLinkHaveUpgradeArrowUnbudgeted(itemLink, true)
	if isUpgrade == nil then
		btn.UpgradeIcon:Hide()
		btn.upgradeCheckElapsed = 0
		btn:SetScript("OnUpdate", UpgradeCheck_OnUpdate)
	else
		btn.UpgradeIcon:SetShown(isUpgrade)
		btn:SetScript("OnUpdate", nil)
	end
end

-- Same tooltip-scan EquipManager.lua uses for ElvUI's native bags
-- (GetContainerItemEquipmentSetInfo is still unreliable).
local function IsItemInEquipmentSet(bagID, slotID)
	local tooltipData = API.GetBagItemTooltip(bagID, slotID)
	if not tooltipData or not tooltipData.lines then
		return false
	end

	local lines = tooltipData.lines
	for i = 1, #lines do
		local text = lines[i] and lines[i].leftText
		if text and strmatch(text, MATCH_EQUIPMENT_SETS) then
			return true
		end
	end

	return false
end

-- Parity with EquipManager.lua's own icon on ElvUI's native bags - reuses
-- that module's icon/size/position/color options (E.db.mui.bags.equipmentManager)
-- instead of duplicating a second set of settings for the same feature.
local function UpdateEquipSetIcon(btn, entry)
	local db = (EM and (EM.db or F.GetDBFromPath("mui.bags.equipmentManager"))) or E.db.mui.bags.equipmentManager
	if not db or not db.enable then
		btn.equipIcon:Hide()
		return
	end

	local _, _, _, equipLoc = API.GetItemInfoInstant(entry.itemLink)
	if not equipLoc or not IS_EQUIPMENT_SLOT[equipLoc] or not IsItemInEquipmentSet(entry.bagID, entry.slotID) then
		btn.equipIcon:Hide()
		return
	end

	btn.equipIcon:Size(db.size)
	btn.equipIcon:ClearAllPoints()
	btn.equipIcon:Point(db.point, db.xOffset, db.yOffset)

	if db.icon == "EQUIPMGR" then
		btn.equipIcon:SetTexture([[Interface\PaperDollInfoFrame\PaperDollSidebarTabs]])
		btn.equipIcon:SetTexCoord(0.01562500, 0.53125000, 0.46875000, 0.60546875)
	elseif db.icon == "CUSTOM" then
		btn.equipIcon:SetTexture(db.customTexture)
		btn.equipIcon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	else
		btn.equipIcon:SetTexture((EM and EM.equipmentmanager.iconLocations[db.icon]) or db.icon)
		btn.equipIcon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	end

	local c = db.color
	btn.equipIcon:SetVertexColor(c.r, c.g, c.b, c.a)
	btn.equipIcon:Show()
end

local function UpdateSlotCooldown(btn, bagID, slotID)
	local cd = btn.Cooldown
	if not cd then
		return
	end

	local start, duration, enabled = C_Container_GetContainerItemCooldown(bagID, slotID)
	if duration and duration > 0 and enabled == 1 then
		cd:SetCooldown(start, duration)
	else
		cd:Hide()
	end
end

local function UpdateSlotVisual(btn, entry)
	btn.BagID = entry.bagID
	btn.SlotID = entry.slotID

	-- A slot faded out by an alt-drag can come back from the pool before its
	-- drag ever finished (a refresh mid-drag), so always reset it here.
	btn:SetAlpha(1)
	btn:SetID(entry.slotID)
	btn.itemID = entry.itemID
	btn.itemLink = entry.itemLink

	SetItemButtonTexture(btn, entry.icon)

	SetItemButtonCount(btn, entry.count)

	-- Locked (being moved/split) as before, plus optionally vendor trash, so
	-- it reads as "sell me" at a glance; the junk coin icon stays either way.
	SetItemButtonDesaturated(
		btn,
		entry.isLocked or (entry.isJunk and module.db.effects.desaturateJunk) or false
	)

	local countFont = module.db.itemCountFont
	if btn.Count then
		btn.Count:FontTemplate(countFont.name, countFont.size, countFont.style)
		PositionSlotText(btn.Count, countFont.position)
	end

	-- Right-click "use/equip" via the secure type/item attributes instead of
	-- calling UseContainerItem from Lua (protected, throws
	-- ADDON_ACTION_FORBIDDEN). SetAttribute itself is combat-protected on
	-- secure frames, so skip refreshing it mid-combat; the previous item's
	-- attributes simply stay in place until the next safe refresh.
	--
	-- "*type2", not "type": an unsuffixed "type" applies to every mouse
	-- button, so a left-click also fired the secure "use item" action right
	-- after our PreClick had handed the item to the cursor. With a
	-- profession spell waiting for a target (Disenchant, Milling, an
	-- enchant scroll...) that second action swallowed the targeting click,
	-- and a middle-click (pin) used the item as well. "*" keeps it working
	-- with any modifier held; "item" stays unsuffixed so every button
	-- still resolves it.
	if not InCombatLockdown() then
		btn:SetAttribute("type", nil)
		btn:SetAttribute("*type2", "item")
		btn:SetAttribute("item", entry.itemLink)
	end

	-- Blizzard's SetItemButtonQuality paints Blizzard's own (hidden) IconBorder;
	-- we draw the quality color on our own ElvUI-templated backdrop instead,
	-- same as ElvUI's own bags (B:UpdateSlotColors).
	local r, g, b = E:GetItemQualityColor(entry.quality)
	btn:SetBackdropBorderColor(r, g, b)
	if E.ForceBorderColor then
		E:ForceBorderColor(btn, r, g, b)
	end

	local levelFont = module.db.itemLevel.font
	btn.itemLevel:FontTemplate(levelFont.name, levelFont.size, levelFont.style)
	PositionSlotText(btn.itemLevel, levelFont.position)
	if entry.itemLevel then
		btn.itemLevel:SetText(entry.itemLevel)
		btn.itemLevel:SetTextColor(r, g, b)
	else
		btn.itemLevel:SetText("")
	end

	local infoFont = module.db.itemInfo.font
	btn.bindType:FontTemplate(infoFont.name, infoFont.size, infoFont.style)
	PositionSlotText(btn.bindType, infoFont.position)
	if entry.bindText then
		btn.bindType:SetText(entry.bindText)
		btn.bindType:SetTextColor(r, g, b)
	else
		btn.bindType:SetText("")
	end

	if btn.IconQuestTexture then
		btn.IconQuestTexture:SetShown(entry.questID and not entry.isActiveQuest and true or false)
	end

	-- Crafted-item quality stars (Enum.ItemCraftingQuality, Dragonflight+),
	-- plus the same Azerite/Corrupted/Cosmetic/Conduit/Curio/Decor item-frame
	-- overlays Blizzard's own bags show - all handled by this one call, which
	-- we otherwise never reach since we skip Blizzard's full item-button
	-- update pipeline. Always-show (not gated to the Professions window being
	-- open) makes sense for a bag view.
	if _G.SetItemButtonOverlay then
		btn.alwaysShowProfessionsQuality = true
		_G.SetItemButtonOverlay(btn, entry.itemLink, entry.quality)
	end

	btn.JunkIcon:SetSize(module.db.itemSize * 0.5, module.db.itemSize * 0.5)
	btn.JunkIcon:SetShown(entry.isJunk and true or false)

	btn.warboundIcon:SetSize(module.db.itemSize * 0.4, module.db.itemSize * 0.4)
	btn.warboundIcon:SetShown(entry.isWarbound and module.db.effects.warboundMarker and true or false)

	btn.pinIcon:SetSize(module.db.itemSize * 0.4, module.db.itemSize * 0.4)
	btn.pinIcon:SetShown(module.db.effects.pinMarker and module:IsItemPinned(entry.itemID) or false)

	-- Straddles the slot's top edge like a tab badge, so it doesn't cover
	-- the icon or the item level. Static: the slot glow already pulses.
	F.SyncNewFeatureBadge(btn, "newBadge", entry.isNew and module.db.effects.newItemBadge, function()
		return F.CreateNewFeatureBadge(btn, "CENTER", btn, "TOP", 0, 0, 0.6, true)
	end)

	local fx = module.db.effects
	local showGlow = entry.isNew and fx.newItemGlow
	btn.newItemGlow:SetShown(showGlow and true or false)
	if showGlow then
		btn.newItemGlow:SetVertexColor(r, g, b)
		if not btn.ownerFrame.NewItemGlow:IsPlaying() then
			btn.ownerFrame.NewItemGlow:Play()
		end
	end

	if btn.hover then
		if fx.hoverClassColor then
			local cc = E.myClassColor
			btn.hover:SetColorTexture(cc.r, cc.g, cc.b, 0.3)
		else
			local hc = fx.hoverColor
			btn.hover:SetColorTexture(hc.r, hc.g, hc.b, 0.3)
		end
	end

	UpdateUpgradeIcon(btn)
	UpdateEquipSetIcon(btn, entry)

	-- Blizzard's own highlighting for Scrap, Rune Carving, Upgrade Items, etc.
	-- (ContainerFrameItemButtonMixin); never gets called on its own since this
	-- button isn't part of Blizzard's tracked container frames.
	if btn.UpdateItemContextMatching then
		btn:UpdateItemContextMatching()
	end

	UpdateSlotCooldown(btn, entry.bagID, entry.slotID)
	ApplySlotDim(btn)
end

-------------------------------------------------------------------------------
--  Category headers
-------------------------------------------------------------------------------
-- Clicking a section header folds/unfolds that section's items (state is
-- per section key, saved in db.collapsedSections, shared by both frames).
-- Ignored while a search is active - matches must always be visible.
local function Header_OnClick(self)
	if self.sectionKey == nil or self.searching then
		return
	end

	local collapsed = module.db.collapsedSections
	collapsed[self.sectionKey] = (not collapsed[self.sectionKey]) or nil

	if self.refresh then
		self.refresh()
	end
end

local function Header_OnEnter(self)
	local cc = E.myClassColor
	self.arrow:SetVertexColor(cc.r, cc.g, cc.b)
end

local function Header_OnLeave(self)
	self.arrow:SetVertexColor(0.6, 0.6, 0.6)
end

local function CreateHeaderPoolFor(getContentChild)
	local headerPool = {}

	local function CreateHeader(index)
		local header = CreateFrame("Button", nil, getContentChild())
		header:SetHeight(22)
		header:RegisterForClicks("LeftButtonUp")
		header:SetScript("OnClick", Header_OnClick)
		header:SetScript("OnEnter", Header_OnEnter)
		header:SetScript("OnLeave", Header_OnLeave)

		header.arrow = header:CreateTexture(nil, "OVERLAY")
		header.arrow:SetSize(12, 12)
		header.arrow:Point("RIGHT", -2, 0)
		header.arrow:SetTexture(E.Media.Textures.ArrowUp)
		header.arrow:SetVertexColor(0.6, 0.6, 0.6)

		header.icon = header:CreateTexture(nil, "ARTWORK")
		header.icon:SetSize(16, 16)
		header.icon:Point("LEFT", 2, 0)

		header.text = header:CreateFontString(nil, "OVERLAY")
		header.text:FontTemplate()
		header.text:Point("LEFT", header.icon, "RIGHT", 6, 0)

		-- Divider filling the rest of the header row after the name/count, so
		-- the header reads as a full-width rule instead of stopping short
		-- wherever the text happens to end. Class-colored to match the other
		-- accent bits (selected sidebar row, view-mode bar) instead of a
		-- flat white line.
		local cc = E.myClassColor
		header.line = header:CreateTexture(nil, "ARTWORK")
		header.line:SetColorTexture(cc.r, cc.g, cc.b, 0.35)
		header.line:Height(1)
		header.line:Point("LEFT", header.text, "RIGHT", 8, 0)
		header.line:Point("RIGHT", header.arrow, "LEFT", -6, 0)

		header.clearButton = CreateFrame("Button", nil, header)
		header.clearButton:Size(14)
		header.clearButton:Point("RIGHT", header.arrow, "LEFT", -6, 0)
		pcall(header.clearButton.SetTemplate, header.clearButton)
		header.clearButton.tex = header.clearButton:CreateTexture(nil, "OVERLAY")
		header.clearButton.tex:SetAllPoints()
		header.clearButton.tex:SetTexture(E.Media.Textures.Close)
		header.clearButton:SetScript("OnEnter", function(self)
			local cc = E.myClassColor
			self.tex:SetVertexColor(cc.r, cc.g, cc.b)
		end)
		header.clearButton:SetScript("OnLeave", function(self)
			self.tex:SetVertexColor(1, 1, 1)
		end)
		header.clearButton:Hide()

		headerPool[index] = header
		return header
	end

	local function AcquireHeader(index)
		local header = headerPool[index]
		if not header then
			header = CreateHeader(index)
		end

		header:Show()
		return header
	end

	local function ReleaseHeadersFrom(startIndex)
		for i = startIndex, #headerPool do
			headerPool[i]:Hide()
		end
	end

	return { Acquire = AcquireHeader, Release = ReleaseHeadersFrom }
end

-------------------------------------------------------------------------------
--  Category sub-headers (expansion / equipment-set nesting within a category)
-------------------------------------------------------------------------------
-- Logos are wide 2:1 artwork, set icons are square item-style icons with
-- the usual trimmed border.
local function SetSubHeaderIcon(header, icon, isLogo)
	local text = header.text
	text:ClearAllPoints()

	if not icon then
		header.icon:Hide()
		text:Point("LEFT", header, "LEFT", 8, 0)
		return
	end

	local height = header:GetHeight()
	header.icon:SetTexture(icon)
	if isLogo then
		header.icon:SetTexCoord(0, 1, 0, 1)
		header.icon:Size(height * 2, height)
	else
		header.icon:SetTexCoord(unpack(E.TexCoords))
		header.icon:Size(height - 2, height - 2)
	end
	header.icon:Show()
	text:Point("LEFT", header.icon, "RIGHT", 4, 0)
end

local function CreateSubHeaderPoolFor(getContentChild)
	local subHeaderPool = {}

	local function CreateSubHeader(index)
		local header = CreateFrame("Frame", nil, getContentChild())
		header:SetHeight(16)

		-- Plain light-grey text on the frame's own semi-transparent background
		-- was functionally showing (confirmed via debug print - correct text,
		-- correct position, shown=true) but visually unreadable against
		-- whatever bled through behind it. A background bar fixes that
		-- regardless of what's behind, same reasoning as the category headers.
		-- The bar spans about half the content width (sized at render time,
		-- never narrower than the label) and fades out
		-- to the right, so it doesn't compete with the full-width category
		-- header above it.
		header.bg = header:CreateTexture(nil, "BACKGROUND")
		header.bg:SetTexture(E.media.blankTex)
		header.bg:Point("TOPLEFT", 0, 0)
		header.bg:Point("BOTTOMLEFT", 0, 0)
		header.bg:SetGradient("HORIZONTAL", CreateColor(0, 0, 0, 0.45), CreateColor(0, 0, 0, 0))

		-- Class-colored accent stripe on the left edge, echoing the selected
		-- sidebar row bar and the category header divider.
		local cc = E.myClassColor
		header.accent = header:CreateTexture(nil, "ARTWORK")
		header.accent:SetColorTexture(cc.r, cc.g, cc.b, 0.8)
		header.accent:Width(2)
		header.accent:Point("TOPLEFT", 0, 0)
		header.accent:Point("BOTTOMLEFT", 0, 0)

		-- Expansion logo or equipment set icon in front of the label, set
		-- per render by SetSubHeaderIcon.
		header.icon = header:CreateTexture(nil, "ARTWORK")
		header.icon:Point("LEFT", 8, 0)
		header.icon:Hide()

		header.text = header:CreateFontString(nil, "OVERLAY")
		header.text:FontTemplate(nil, 11)
		header.text:SetTextColor(0.9, 0.9, 0.9)
		header.text:Point("LEFT", 8, 0)

		subHeaderPool[index] = header
		return header
	end

	local function AcquireSubHeader(index)
		local header = subHeaderPool[index]
		if not header then
			header = CreateSubHeader(index)
		end

		header:Show()
		return header
	end

	local function ReleaseSubHeadersFrom(startIndex)
		for i = startIndex, #subHeaderPool do
			subHeaderPool[i]:Hide()
		end
	end

	return { Acquire = AcquireSubHeader, Release = ReleaseSubHeadersFrom }
end

-------------------------------------------------------------------------------
--  Sidebar rows
-------------------------------------------------------------------------------
local function Sidebar_OnClick(self, mouseButton)
	if self.wasDragged then
		self.wasDragged = nil
		return
	end

	if mouseButton == "LeftButton" then
		module:ScrollToCategory(self.catKey, self.ownerFrame, self.getOffsets and self.getOffsets())
	elseif
		mouseButton == "RightButton"
		and (self.isUser or self.isGroup or self.isGroupMember or not self.isPinnedOrRecent)
	then
		module:OpenCategoryContextMenu(self)
	end
end

-- Pinned/Recent stay fixed at the top always, so they're excluded from both
-- ends of a drag (can't be picked up, and dropping onto one is a no-op).
local function Sidebar_OnDragStart(self)
	if InCombatLockdown() or self.isPinnedOrRecent then
		return
	end

	self.wasDragged = true
	module.draggingCategoryKey = self.catKey
	self:SetAlpha(0.4)
end

local function Sidebar_OnDragStop(self)
	self:SetAlpha(1)

	local draggedKey = module.draggingCategoryKey
	local targetKey = module.dragHoverCategoryKey
	module.draggingCategoryKey = nil
	module.dragHoverCategoryKey = nil

	if draggedKey and targetKey and draggedKey ~= targetKey then
		module:ReorderCategory(draggedKey, targetKey)
		module:RefreshCategoryFrame()
	end
end

local function Sidebar_OnEnter(self)
	if module.draggingCategoryKey and not self.isPinnedOrRecent then
		module.dragHoverCategoryKey = self.catKey
	end

	if GameTooltip:IsForbidden() then
		return
	end

	-- Row text/count stay set even while hidden (collapsed sidebar), so this
	-- doubles as the only way to see a category's name/count when collapsed.
	local name = self.text and self.text:GetText()
	if not name or name == "" then
		return
	end

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(name, 1, 1, 1)
	local count = self.count and self.count:GetText()
	if count and count ~= "" then
		GameTooltip:AddLine(count, 0.6, 0.6, 0.6)
	end
	GameTooltip:Show()
end

local function Sidebar_OnLeave()
	GameTooltip_Hide()
end

local function CreateSidebarPoolFor(getSidebarChild, getOwnerFrame, getOffsets)
	local sidebarPool = {}

	local function CreateSidebarRow(index)
		local row = CreateFrame("Button", nil, getSidebarChild())
		row:SetHeight(24)
		row:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		row:SetScript("OnClick", Sidebar_OnClick)
		row:RegisterForDrag("LeftButton")
		row:SetScript("OnDragStart", Sidebar_OnDragStart)
		row:SetScript("OnDragStop", Sidebar_OnDragStop)
		row:SetScript("OnEnter", Sidebar_OnEnter)
		row:SetScript("OnLeave", Sidebar_OnLeave)
		row:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], "ADD")

		-- Alternating-row background, same technique/look as the Armory panel's
		-- alternating stat rows (Core.lua:UpdateCharacterStat): a class-colored
		-- horizontal gradient fading from transparent to a low alpha.
		row.gradient = row:CreateTexture(nil, "BACKGROUND")
		row.gradient:SetAllPoints()
		row.gradient:SetTexture(E.media.blankTex)
		local cc = E.myClassColor
		F.Color.SetGradientRGB(row.gradient, "HORIZONTAL", cc.r, cc.g, cc.b, 0, cc.r, cc.g, cc.b, 0.32)

		row.icon = row:CreateTexture(nil, "ARTWORK")
		row.icon:SetSize(16, 16)
		row.icon:Point("LEFT", 4, 0)

		row.text = row:CreateFontString(nil, "OVERLAY")
		row.text:FontTemplate()
		row.text:Point("LEFT", row.icon, "RIGHT", 6, 0)
		row.text:Point("RIGHT", -26, 0)
		row.text:SetJustifyH("LEFT")

		row.count = row:CreateFontString(nil, "OVERLAY")
		row.count:FontTemplate()
		row.count:SetTextColor(0.6, 0.6, 0.6)
		row.count:Point("RIGHT", -4, 0)

		-- Sidebar_OnClick needs to know which top-level frame's mainScroll to
		-- scroll and which category-offsets table to look the target up in.
		-- getOffsets is stored (not called once here) because the pooled row
		-- outlives any single refresh - module.categoryOffsets/
		-- bankCategoryOffsets is a brand new table every RefreshCategoryFrame/
		-- RefreshBankCategoryFrame call, so a snapshotted table reference
		-- taken at row-creation time would go stale the moment content
		-- reflows; calling the getter live at click time always resolves to
		-- whichever offsets table the most recent refresh actually built.
		row.ownerFrame = getOwnerFrame()
		row.getOffsets = getOffsets

		sidebarPool[index] = row
		return row
	end

	local function AcquireSidebarRow(index)
		local row = sidebarPool[index]
		if not row then
			row = CreateSidebarRow(index)
		end

		row:SetAlpha(1)
		row:Show()
		return row
	end

	local function ReleaseSidebarRowsFrom(startIndex)
		for i = startIndex, #sidebarPool do
			sidebarPool[i]:Hide()
		end
	end

	-- Shared setup for both a normal/group-parent sidebar row and an indented
	-- group-child row (see BuildCategorySectionsFrom's isGroup handling) -
	-- `indent` shifts the row's own left edge, so a child row's whole
	-- clickable area (icon/text/highlight/gradient) visually nests under its
	-- group parent.
	local function SetupSidebarCategoryRow(
		index,
		indent,
		catKey,
		name,
		icon,
		isAtlas,
		count,
		isUser,
		isPinnedOrRecent,
		isGroup,
		memberKey,
		baseY
	)
		local db = module.db
		local row = AcquireSidebarRow(index)
		local sidebarChild = getSidebarChild()
		local y = (baseY or 0) + (index - 1) * db.sidebarRowHeight
		row:SetHeight(db.sidebarRowHeight)
		row:ClearAllPoints()
		row:Point("TOPLEFT", sidebarChild, "TOPLEFT", indent, -y)
		row:Point("TOPRIGHT", sidebarChild, "TOPRIGHT", 0, -y)
		row.catKey = catKey
		row.isUser = isUser
		row.isPinnedOrRecent = isPinnedOrRecent
		row.isGroup = isGroup or false
		row.isGroupMember = memberKey and true or false
		row.memberKey = memberKey
		row.text:SetText(name)
		row.count:SetText(count)
		row.text:SetShown(not db.sidebarCollapsed)
		row.count:SetShown(not db.sidebarCollapsed)
		SetCategoryIcon(row.icon, { icon = icon, isAtlas = isAtlas })
		row.gradient:SetShown(db.alternatingRowBackground and index % 2 == 0)
		return row
	end

	return { Acquire = AcquireSidebarRow, Release = ReleaseSidebarRowsFrom, SetupSidebarCategoryRow = SetupSidebarCategoryRow }
end

-- Bundles one independent set of the four pools above for a single owning
-- frame (bag or bank) - see the comment on CreateSlotPoolFor for why they
-- can't be shared between the two.
local function CreatePoolSet(namePrefix, getContentChild, getSidebarChild, getOwnerFrame, getOffsets)
	local slot = CreateSlotPoolFor(namePrefix, getContentChild, getOwnerFrame)
	local placeholder = CreatePlaceholderPoolFor(getContentChild)
	local header = CreateHeaderPoolFor(getContentChild)
	local subHeader = CreateSubHeaderPoolFor(getContentChild)
	local sidebar = CreateSidebarPoolFor(getSidebarChild, getOwnerFrame, getOffsets)

	return {
		AcquireSlot = slot.Acquire,
		ReleaseSlotsFrom = slot.Release,
		AcquirePlaceholder = placeholder.Acquire,
		ReleasePlaceholdersFrom = placeholder.Release,
		AcquireHeader = header.Acquire,
		ReleaseHeadersFrom = header.Release,
		AcquireSubHeader = subHeader.Acquire,
		ReleaseSubHeadersFrom = subHeader.Release,
		AcquireSidebarRow = sidebar.Acquire,
		ReleaseSidebarRowsFrom = sidebar.Release,
		SetupSidebarCategoryRow = sidebar.SetupSidebarCategoryRow,
	}
end

local bagPools = CreatePoolSet(
	SLOT_NAME_PREFIX,
	function()
		return module.contentChild
	end,
	function()
		return module.sidebarChild
	end,
	function()
		return module.frame
	end,
	function()
		return module.categoryOffsets
	end
)

-- BankFrame.lua builds its own pool set the same way, once its own frame's
-- contentChild/sidebarChild/frame/offsets exist.
module.CreatePoolSet = CreatePoolSet

-- Footer currency order: a list of currencyTypesIDs kept in db.currencyOrder.
-- Currencies the player starts watching later aren't in it yet and simply
-- follow in Blizzard's own order.
local function GetOrderedCurrencies()
	local order = module.db.currencyOrder or {}
	local position = {}
	for index, currencyID in ipairs(order) do
		position[currencyID] = index
	end

	local watched = {}
	for index = 1, MAX_WATCHED_TOKENS do
		local info = API.GetBackpackCurrencyInfo(index)
		if info and info.name then
			tinsert(watched, {
				index = index,
				info = info,
				position = position[info.currencyTypesID] or (#order + index),
			})
		end
	end

	tsort(watched, function(a, b)
		return a.position < b.position
	end)

	return watched
end

local function MoveCurrency(draggedID, targetID)
	if not draggedID or not targetID or draggedID == targetID then
		return
	end

	local db = module.db

	-- Seed from what is currently displayed, so the first drag reorders the
	-- visible cluster instead of an empty list.
	if not db.currencyOrder or #db.currencyOrder == 0 then
		db.currencyOrder = {}
		for _, entry in ipairs(GetOrderedCurrencies()) do
			tinsert(db.currencyOrder, entry.info.currencyTypesID)
		end
	end

	local order = db.currencyOrder
	for index, currencyID in ipairs(order) do
		if currencyID == draggedID then
			tremove(order, index)
			break
		end
	end

	for index, currencyID in ipairs(order) do
		if currencyID == targetID then
			tinsert(order, index, draggedID)
			return
		end
	end

	tinsert(order, draggedID)
end

local function Currency_OnDragStart(self)
	if InCombatLockdown() or not self.currencyID then
		return
	end

	module.draggingCurrencyID = self.currencyID
	self:SetAlpha(0.4)
end

local function Currency_OnDragStop(self)
	self:SetAlpha(1)

	local draggedID = module.draggingCurrencyID
	local targetID = module.dragHoverCurrencyID
	module.draggingCurrencyID = nil
	module.dragHoverCurrencyID = nil

	if draggedID and targetID then
		MoveCurrency(draggedID, targetID)
		module:UpdateFooter()
	end
end

local function Currency_OnDragEnter(self)
	if module.draggingCurrencyID then
		module.dragHoverCurrencyID = self.currencyID
	end
end

local function Currency_OnDragLeave()
	module.dragHoverCurrencyID = nil
end

-------------------------------------------------------------------------------
--  Frame construction
-------------------------------------------------------------------------------
function module:ConstructFrame()
	if module.frame then
		return module.frame
	end

	local db = module.db

	local f = CreateFrame("Button", FRAME_NAME, E.UIParent)
	f:SetFrameStrata("HIGH")
	f:SetClampedToScreen(true)
	f:Size(db.width, db.height)
	f:Point("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -4, 48)
	pcall(f.SetTemplate, f, "Transparent")
	WS:CreateShadow(f)
	f:Hide()
	f:SetScript("OnShow", function(self)
		module:FadeInFrame(self)
	end)
	f:SetScript("OnHide", function()
		module:OnFrameHidden()
	end)
	module.frame = f

	E:CreateMover(
		f,
		"MER_BagCategoriesMover",
		MER.Title .. L["Categorized Bags"],
		nil,
		nil,
		nil,
		"ALL,SOLO,MERATHILISUI",
		nil,
		"mui,modules,bags,categorizedBags"
	)

	-- Solid title-bar backdrop behind the title text/buttons/search row.
	-- Explicit lower frame level so it stays behind those (plain) sibling
	-- frames instead of drawing over them.
	f.titleBar = CreateFrame("Frame", nil, f)
	f.titleBar:Point("TOPLEFT")
	f.titleBar:Point("TOPRIGHT")
	f.titleBar:Height(30)
	pcall(f.titleBar.SetTemplate, f.titleBar, "Transparent")
	f.titleBar:SetFrameLevel(f:GetFrameLevel())

	f.closeButton = CreateFrame("Button", FRAME_NAME .. "CloseButton", f, "UIPanelCloseButton")
	f.closeButton:Point("TOPRIGHT", 2, 2)
	f.closeButton:SetScript("OnClick", function()
		module:HideCategoryFrame()
	end)
	pcall(S.HandleCloseButton, S, f.closeButton)

	f.titleText = f:CreateFontString(nil, "OVERLAY")
	f.titleText:FontTemplate(nil, 14)
	f.titleText:Point("TOPLEFT", 10, -10)

	f.titleCountText = f:CreateFontString(nil, "OVERLAY")
	f.titleCountText:FontTemplate(nil, 10)
	f.titleCountText:Point("LEFT", f.titleText, "RIGHT", 6, 0)

	-- Small ElvUI-style icon buttons (same textures/skinning as ElvUI's own
	-- bag frame title row). Anchored TOP-to-TOP directly off `f` and each
	-- other (not off the close button, which sits in its own corner at a
	-- different size/height) so this whole row shares one exact y with the
	-- search box below.
	local function CreateTitleButton(name, texture, tooltipText, onClick)
		local btn = CreateFrame("Button", FRAME_NAME .. name, f)
		btn:Size(20)
		pcall(btn.SetTemplate, btn)
		pcall(btn.StyleButton, btn, nil, true)
		if btn.hover then
			local cc = E.myClassColor
			btn.hover:SetColorTexture(cc.r, cc.g, cc.b, 0.3)
		end

		btn.tex = btn:CreateTexture(nil, "OVERLAY")
		btn.tex:SetInside()
		btn.tex:SetTexture(texture)

		if onClick then
			btn:SetScript("OnClick", onClick)
		end

		btn:SetScript("OnEnter", function(self)
			if GameTooltip:IsForbidden() then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			if type(tooltipText) == "function" then
				tooltipText()
			else
				GameTooltip:AddLine(tooltipText, 1, 1, 1)
			end
			GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", GameTooltip_Hide)

		return btn
	end

	-- Sort is Blizzard's native SortBags(); Stack uses ElvUI's own
	-- stacking (see module:StackItems), which only merges partial stacks
	-- and leaves everything else where it is.
	f.sortButton = CreateTitleButton("SortButton", E.Media.Textures.PetBroom, L["Sort Bags"], function()
		module:StartSortSpinner()
		C_Container.SortBags()
	end)
	f.sortButton:Point("TOPRIGHT", f, "TOPRIGHT", -40, -8)

	f.stackButton = CreateTitleButton("StackButton", E.Media.Textures.Planks, function()
		GameTooltip:AddLine(L["Stack Items In Bags"], 1, 1, 1)
		if module.isBankOpen then
			GameTooltip:AddDoubleLine(L["Hold Shift:"], L["Stack Items To Bank"], 1, 1, 1)
		end
	end, function()
		module:StackItems(module.frame, false)
	end)
	f.stackButton:Point("TOPRIGHT", f.sortButton, "TOPLEFT", -2, 0)

	-- Same spinner ElvUI's own bag frame shows while its custom sort
	-- algorithm is moving items - we don't have that algorithm (SortBags()
	-- above is Blizzard's native, near-instant one), but showing this while
	-- waiting for the resulting BAG_UPDATE burst to settle gives the same
	-- "something is happening" feedback instead of items just silently
	-- rearranging. Sized/colored per module.db.spinner in StartSortSpinner.
	f.spinnerIcon = CreateFrame("Frame", nil, f)
	f.spinnerIcon:Size(80, 80)
	f.spinnerIcon:Point("CENTER")
	f.spinnerIcon:Hide()

	f.vendorGraysButton = CreateTitleButton("VendorGraysButton", 133784, function()
		local value = module:GetJunkValue()
		if value > 0 then
			GameTooltip:AddDoubleLine(L["Vendor Grays"], E:FormatMoney(value, "SMART"), 1, 1, 1, 1, 1, 1)
		else
			GameTooltip:AddLine(L["Vendor Grays"], 1, 1, 1)
			GameTooltip:AddLine(L["No gray items to sell."], 0.6, 0.6, 0.6)
		end
	end, function()
		module:VendorGrays()
	end)
	f.vendorGraysButton:Point("TOPRIGHT", f.stackButton, "TOPLEFT", -2, 0)
	-- Raw Blizzard icon (same one ElvUI's own Vendor Grays button uses) has
	-- its border baked into the UV, unlike the flat ElvUI media textures the
	-- sibling buttons use - crop it the same way slot/category icons are.
	f.vendorGraysButton.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	f.bagBarButton = CreateTitleButton("BagBarButton", E.Media.Textures.Backpack, L["Toggle Bag Bar"], function()
		module:ToggleBagBarPopout()
	end)
	f.bagBarButton:Point("TOPRIGHT", f.vendorGraysButton, "TOPLEFT", -2, 0)
	module.bagBarButton = f.bagBarButton

	-- Help always stays the leftmost title-bar icon button (right next to the
	-- search box) - anchor any future button off bagBarButton (or whichever
	-- button ends up rightmost of it) instead of inserting after this one.
	-- Auto Deposit lives on the Bank frame's own footer now (BankFrame.lua) -
	-- this frame never shows a bank view any more, so it has nothing to
	-- deposit into.
	f.helpButton = CreateTitleButton("HelpButton", E.Media.Textures.Help, function()
		GameTooltip:AddLine(L["Bag"], 1, 0.82, 0)
		GameTooltip:AddDoubleLine(L["Left Click:"], L["Pick up / move item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Right Click:"], L["Use / equip item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Shift + Click:"], L["Split Stack"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Middle Click:"], L["Pin / unpin item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Shift + Middle Click:"], L["Assign to Category"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Alt + Drag:"], L["Reorder items inside a category"], 1, 1, 1)
		GameTooltip:AddLine(L["Changes the display order only - nothing moves in your bags."], 0.6, 0.6, 0.6)

		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["Bank / Warband Bank (while open)"], 1, 0.82, 0)
		GameTooltip:AddDoubleLine(L["Right Click:"], L["Deposit / withdraw item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Ctrl + Right Click:"], L["Move to Bank Tab / Bag"], 1, 1, 1)

		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["Vendor (while open)"], 1, 0.82, 0)
		GameTooltip:AddDoubleLine(L["Right Click:"], L["Sell item"], 1, 1, 1)
	end)
	f.helpButton:Point("TOPRIGHT", f.bagBarButton, "TOPLEFT", -2, 0)

	-- Fixed width (not stretched to fill the row) so it sits directly next to
	-- the buttons/close button, matching the reference layout instead of
	-- spanning the whole remaining title-bar width.
	f.searchBox = CreateFrame("EditBox", FRAME_NAME .. "SearchBox", f, "SearchBoxTemplate")
	f.searchBox:Point("TOPRIGHT", f.helpButton, "TOPLEFT", -6, 0)
	f.searchBox:Size(180, 20)
	f.searchBox:HookScript("OnTextChanged", function(self)
		module.searchText = self:GetText() or ""
		module:RefreshCategoryFrame()
	end)
	pcall(S.HandleEditBox, S, f.searchBox)

	-- Sidebar
	f.sidebar = CreateFrame("Frame", nil, f)
	f.sidebar:Point("TOPLEFT", f, "TOPLEFT", 8, -34)
	f.sidebar:Point("BOTTOMLEFT", f, "BOTTOMLEFT", 8, 60)
	f.sidebar:Width(db.sidebarCollapsed and COLLAPSED_SIDEBAR_WIDTH or db.sidebarWidth)
	pcall(f.sidebar.SetTemplate, f.sidebar, "Transparent")
	module.AddSidebarEdge(f.sidebar)

	f.sidebarHeaderText = f.sidebar:CreateFontString(nil, "OVERLAY")
	f.sidebarHeaderText:FontTemplate()
	f.sidebarHeaderText:Point("TOPLEFT", 4, -4)
	f.sidebarHeaderText:SetText(L["Categories"])

	-- Same skinned arrow ElvUI's own prev/next-style buttons use, rather than
	-- a plain unskinned texture.
	f.collapseButton = CreateFrame("Button", FRAME_NAME .. "CollapseButton", f.sidebar)
	f.collapseButton:Point("TOPRIGHT", -2, -4)
	pcall(S.HandleNextPrevButton, S, f.collapseButton, "left", nil, nil, nil, nil, 14)
	f.collapseButton:SetScript("OnClick", function()
		module:SetSidebarCollapsed(not module.db.sidebarCollapsed)
	end)
	f.collapseButton:SetScript("OnEnter", function(self)
		if GameTooltip:IsForbidden() then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(module.db.sidebarCollapsed and L["Expand Sidebar"] or L["Collapse Sidebar"], 1, 1, 1)
		GameTooltip:Show()
	end)
	f.collapseButton:SetScript("OnLeave", GameTooltip_Hide)
	module.AddCollapseButtonHover(f.collapseButton)

	-- Fixed (non-scrolling) view-mode switcher, always pinned above the
	-- scrollable category/bag list - "All Items" is a flat, ungrouped list;
	-- "OneBag"/"MultiBag" are our existing category/bag grouping modes,
	-- renamed here to match the classic bag-addon terminology.
	f.viewModeRows = {}
	local viewModeDefs = {
		{ key = "ALL", label = L["All Items"] },
		{ key = "CATEGORY", label = L["OneBag"] },
		{ key = "BAG", label = L["MultiBag"] },
	}
	for i, def in ipairs(viewModeDefs) do
		local row = CreateFrame("Button", nil, f.sidebar)
		row:SetHeight(VIEW_MODE_ROW_HEIGHT)
		row:Point("TOPLEFT", f.sidebar, "TOPLEFT", 4, -18 - (i - 1) * VIEW_MODE_ROW_HEIGHT)
		row:Point("TOPRIGHT", f.sidebar, "TOPRIGHT", -4, -18 - (i - 1) * VIEW_MODE_ROW_HEIGHT)
		row:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], "ADD")

		row.selectedTex = row:CreateTexture(nil, "BACKGROUND")
		row.selectedTex:SetAllPoints()
		local cc = E.myClassColor
		row.selectedTex:SetColorTexture(cc.r, cc.g, cc.b, 0.25)

		row.selectedBar = row:CreateTexture(nil, "BORDER")
		row.selectedBar:Point("TOPLEFT", 0, 0)
		row.selectedBar:Point("BOTTOMLEFT", 0, 0)
		row.selectedBar:Width(2)
		row.selectedBar:SetColorTexture(cc.r, cc.g, cc.b, 1)

		row.icon = row:CreateTexture(nil, "ARTWORK")
		row.icon:SetSize(16, 16)
		row.icon:Point("LEFT", 4, 0)
		row.icon:SetTexture(E.Media.Textures.Backpack)

		row.text = row:CreateFontString(nil, "OVERLAY")
		row.text:FontTemplate()
		row.text:Point("LEFT", row.icon, "RIGHT", 6, 0)
		row.text:Point("RIGHT", -26, 0)
		row.text:SetJustifyH("LEFT")
		row.text:SetText(def.label)

		row.count = row:CreateFontString(nil, "OVERLAY")
		row.count:FontTemplate()
		row.count:SetTextColor(0.6, 0.6, 0.6)
		row.count:Point("RIGHT", -4, 0)

		row.viewModeKey = def.key
		row:SetScript("OnClick", function()
			module.db.viewMode = def.key
			module:RefreshCategoryFrame()
			module:RefreshBagBarPopout()
		end)
		row:SetScript("OnEnter", Sidebar_OnEnter)
		row:SetScript("OnLeave", Sidebar_OnLeave)

		f.viewModeRows[i] = row
	end

	-- Pinned Items gets its own fixed shortcut row, right below the view-mode
	-- switcher and above a separator - it's always the first section in every
	-- view mode, so this is just a permanent jump-to-top shortcut, not a 4th
	-- view mode. The Pinned *content* (header + items) still renders normally
	-- further down; only its scrollable sidebar row is replaced by this one.
	f.pinnedRow = CreateFrame("Button", nil, f.sidebar)
	f.pinnedRow:SetHeight(VIEW_MODE_ROW_HEIGHT)
	f.pinnedRow:Point("TOPLEFT", f.sidebar, "TOPLEFT", 4, -18 - (#viewModeDefs) * VIEW_MODE_ROW_HEIGHT)
	f.pinnedRow:Point("TOPRIGHT", f.sidebar, "TOPRIGHT", -4, -18 - (#viewModeDefs) * VIEW_MODE_ROW_HEIGHT)
	f.pinnedRow:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], "ADD")

	f.pinnedRow.icon = f.pinnedRow:CreateTexture(nil, "ARTWORK")
	f.pinnedRow.icon:SetSize(16, 16)
	f.pinnedRow.icon:Point("LEFT", 4, 0)

	f.pinnedRow.text = f.pinnedRow:CreateFontString(nil, "OVERLAY")
	f.pinnedRow.text:FontTemplate()
	f.pinnedRow.text:Point("LEFT", f.pinnedRow.icon, "RIGHT", 6, 0)
	f.pinnedRow.text:Point("RIGHT", -26, 0)
	f.pinnedRow.text:SetJustifyH("LEFT")
	f.pinnedRow.text:SetText(module.PinnedCategory.name)

	f.pinnedRow.count = f.pinnedRow:CreateFontString(nil, "OVERLAY")
	f.pinnedRow.count:FontTemplate()
	f.pinnedRow.count:SetTextColor(0.6, 0.6, 0.6)
	f.pinnedRow.count:Point("RIGHT", -4, 0)

	f.pinnedRow:SetScript("OnClick", function()
		module:ScrollToCategory(module.PinnedCategory.key)
	end)
	f.pinnedRow:SetScript("OnEnter", Sidebar_OnEnter)
	f.pinnedRow:SetScript("OnLeave", Sidebar_OnLeave)

	f.sidebarSeparator = f.sidebar:CreateTexture(nil, "ARTWORK")
	f.sidebarSeparator:SetColorTexture(1, 1, 1, 0.15)
	f.sidebarSeparator:Height(1)
	f.sidebarSeparator:Point("TOPLEFT", f.pinnedRow, "BOTTOMLEFT", 2, -3)
	f.sidebarSeparator:Point("TOPRIGHT", f.pinnedRow, "BOTTOMRIGHT", -2, -3)

	f.sidebarScroll = CreateFrame("ScrollFrame", FRAME_NAME .. "SidebarScroll", f.sidebar, "UIPanelScrollFrameTemplate")
	f.sidebarScroll:Point("TOPLEFT", 4, -18 - (#viewModeDefs + 1) * VIEW_MODE_ROW_HEIGHT - 10)
	f.sidebarScroll:Point("BOTTOMRIGHT", -24, 4)
	SkinScrollBar(f.sidebarScroll.ScrollBar)

	f.sidebarChild = CreateFrame("Frame", nil, f.sidebarScroll)
	f.sidebarChild:Point("TOPLEFT")
	f.sidebarChild:Width(db.sidebarWidth - 30)
	f.sidebarChild:Height(1)
	f.sidebarScroll:SetScrollChild(f.sidebarChild)
	module.sidebarChild = f.sidebarChild

	f.addCategoryButton = CreateFrame("Button", FRAME_NAME .. "AddCategory", f.sidebar, "UIPanelButtonTemplate")
	f.addCategoryButton:Point("TOP", f.sidebar, "BOTTOM", 0, -2)
	f.addCategoryButton:Size(db.sidebarWidth, 20)
	f.addCategoryButton:SetText(L["Add Category"])
	f.addCategoryButton:SetScript("OnClick", function()
		module:PromptAddCategory()
	end)
	pcall(S.HandleButton, S, f.addCategoryButton)

	-- Main content
	f.mainScroll = CreateFrame("ScrollFrame", FRAME_NAME .. "MainScroll", f, "UIPanelScrollFrameTemplate")
	f.mainScroll:Point("TOPLEFT", f.sidebar, "TOPRIGHT", 8, 0)
	f.mainScroll:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", -28, 36)
	SkinScrollBar(f.mainScroll.ScrollBar)

	f.contentChild = CreateFrame("Frame", nil, f.mainScroll)
	f.contentChild:Point("TOPLEFT")
	f.contentChild:Width(1)
	f.contentChild:Height(1)
	f.mainScroll:SetScrollChild(f.contentChild)
	module.contentChild = f.contentChild

	-- Shown when a search/category filter leaves nothing to display - parented
	-- to the scroll frame itself (not the content child, which shrinks to a
	-- 1px height when empty) so it stays centered in the visible viewport.
	f.emptyText = f.mainScroll:CreateFontString(nil, "OVERLAY")
	f.emptyText:FontTemplate(nil, 14)
	f.emptyText:SetTextColor(0.6, 0.6, 0.6)
	f.emptyText:Point("CENTER")
	f.emptyText:SetText(L["No items found."])
	f.emptyText:Hide()

	-- Footer
	f.footer = CreateFrame("Frame", nil, f)
	f.footer:Point("BOTTOMLEFT", 8, 8)
	f.footer:Point("BOTTOMRIGHT", -8, 8)
	f.footer:Height(20)

	module.CreateFillBar(f)

	f.footer.goldText = f.footer:CreateFontString(nil, "OVERLAY")
	f.footer.goldText:FontTemplate()
	f.footer.goldText:Point("LEFT", 4, 0)

	-- Invisible hit-box over the gold text for the cross-character/Warband
	-- tooltip - a FontString can't itself take mouse input.
	f.footer.goldButton = CreateFrame("Button", nil, f.footer)
	f.footer.goldButton:SetAllPoints(f.footer.goldText)
	f.footer.goldButton:SetScript("OnEnter", function(self)
		module:ShowGoldTooltip(self)
	end)
	f.footer.goldButton:SetScript("OnLeave", GameTooltip_Hide)

	-- Tracked currencies (same source as ElvUI's own bags: whatever the
	-- player enabled "Show on Backpack" for via the default Currency tab),
	-- shown icon + amount next to gold.
	f.footer.currencyButtons = {}
	for i = 1, MAX_WATCHED_TOKENS do
		local btn = CreateFrame("Button", FRAME_NAME .. "Currency" .. i, f.footer, "BackpackTokenTemplate")
		btn:Size(20)
		pcall(btn.SetTemplate, btn)

		-- The template's own OnEnter reads this index to show the matching
		-- currency's tooltip (GetBackpackCurrencyInfo(id) below uses the same
		-- index), same as ElvUI's own currency buttons.
		btn:SetID(i)

		local icon = btn.icon or btn.Icon
		icon:SetInside()
		icon:SetTexCoords()

		btn.text = btn:CreateFontString(nil, "OVERLAY")
		btn.text:FontTemplate()
		btn:Hide()

		-- Layered on top of (not replacing) whatever OnEnter/OnLeave the
		-- template itself already wires up, so the tooltip works even if
		-- that default behavior isn't hooked up outside its usual parent.
		btn:HookScript("OnEnter", function(self)
			if GameTooltip:IsForbidden() then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetBackpackToken(self:GetID())
			GameTooltip:Show()
		end)
		btn:HookScript("OnLeave", GameTooltip_Hide)

		-- Drag one currency onto another to reorder the footer cluster, the
		-- same interaction the sidebar categories already use. Blizzard's own
		-- watch list stays untouched; only our display order moves.
		btn:RegisterForDrag("LeftButton")
		btn:SetScript("OnDragStart", Currency_OnDragStart)
		btn:SetScript("OnDragStop", Currency_OnDragStop)
		btn:HookScript("OnEnter", Currency_OnDragEnter)
		btn:HookScript("OnLeave", Currency_OnDragLeave)

		f.footer.currencyButtons[i] = btn
	end

	-- Manually apply Style
	F.CreateStyle(f)

	f:RegisterEvent("PLAYER_MONEY")
	-- Fires both for currency amount changes and for toggling a currency's
	-- "Show on Backpack" watch state, so the footer updates immediately
	-- either way instead of only after a reload.
	f:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	f:SetScript("OnEvent", function(_, event)
		if event == "PLAYER_MONEY" or event == "CURRENCY_DISPLAY_UPDATE" then
			module:UpdateFooter()
		end
	end)

	-- CURRENCY_DISPLAY_UPDATE only covers amount changes, not toggling a
	-- currency's "Show on Backpack" watch state (same reason ElvUI's own
	-- bags hook this directly instead of relying on that event alone).
	if _G.TokenFrame then
		hooksecurefunc(_G.TokenFrame, "SetTokenWatched", function()
			if f:IsShown() then
				module:UpdateFooter()
			end
		end)
	end

	return f
end

-- Same raw ElvDB.gold/class table ElvUI's own Gold DataText maintains (and
-- e.g. WindTools' GameBar reads) - one shared source of cross-character
-- data instead of a second, redundant MerathilisUI-only copy. We write to it
-- ourselves too (not just read), so this stays accurate even if the user
-- doesn't have the Gold DataText assigned to any panel.
function module:UpdateGoldTracking()
	local db = _G.ElvDB
	if not db then
		return
	end

	db.gold = db.gold or {}
	db.gold[E.myrealm] = db.gold[E.myrealm] or {}
	db.gold[E.myrealm][E.myname] = GetMoney()

	db.class = db.class or {}
	db.class[E.myrealm] = db.class[E.myrealm] or {}
	db.class[E.myrealm][E.myname] = E.myclass
end

local function SortGoldDescending(a, b)
	return a.amount > b.amount
end

-- Small inline icons so characters, the account total and the warband bank
-- are told apart at a glance instead of by reading every label.
local function TooltipIcon(atlas)
	return CreateAtlasMarkup(atlas, 14, 14) .. " "
end
module.TooltipIcon = TooltipIcon

function module:ShowGoldTooltip(anchor)
	if GameTooltip:IsForbidden() then
		return
	end

	module:UpdateGoldTracking()

	local goldDB = _G.ElvDB and _G.ElvDB.gold or {}
	local classDB = _G.ElvDB and _G.ElvDB.class or {}

	local characters = {}
	local total = 0
	for realm, chars in pairs(goldDB) do
		for name, amount in pairs(chars) do
			tinsert(characters, {
				name = name,
				realm = realm,
				amount = amount,
				class = classDB[realm] and classDB[realm][name],
			})
			total = total + (amount or 0)
		end
	end
	tsort(characters, SortGoldDescending)

	GameTooltip:SetOwner(anchor, "ANCHOR_TOPLEFT")
	GameTooltip:AddLine(_G.GOLD or L["Gold"])
	GameTooltip:AddLine(" ")

	for _, data in ipairs(characters) do
		local color = (data.class and E:ClassColor(data.class)) or _G.HIGHLIGHT_FONT_COLOR
		local nameLine = data.realm ~= E.myrealm and format("%s - %s", data.name, data.realm) or data.name
		if data.class then
			nameLine = TooltipIcon("classicon-" .. strlower(data.class)) .. nameLine
		end
		GameTooltip:AddDoubleLine(nameLine, E:FormatMoney(data.amount, "SMART"), color.r, color.g, color.b, 1, 1, 1)
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(TooltipIcon("coin-gold") .. (_G.TOTAL or L["Total"]), E:FormatMoney(total, "SMART"), 1, 1, 1, 1, 1, 1)

	if _G.C_Bank and _G.C_Bank.FetchDepositedMoney then
		local warbandBankType = (Enum.BankType and Enum.BankType.Account) or 2
		local ok, warbandGold = pcall(_G.C_Bank.FetchDepositedMoney, warbandBankType)
		if ok and warbandGold then
			GameTooltip:AddDoubleLine(TooltipIcon("warbands-icon") .. L["Warband Bank"], E:FormatMoney(warbandGold, "SMART"), 1, 1, 1, 1, 1, 1)
		end
	end

	GameTooltip:Show()
end

function module:UpdateFooter()
	local f = module.frame
	if not f then
		return
	end

	module:UpdateGoldTracking()
	f.footer.goldText:SetText(E:FormatMoney(GetMoney(), "SMART"))

	-- Chained right-to-left off the footer's own right edge (independent of
	-- goldText's width), so the whole currency cluster stays flush to the
	-- right instead of trailing right after the gold amount.
	local ordered = GetOrderedCurrencies()

	local rightAnchor, rightAnchorPoint, rightPadding = f.footer, "RIGHT", -6
	for i = 1, MAX_WATCHED_TOKENS do
		local btn = f.footer.currencyButtons[i]
		local entry = ordered[i]

		if entry then
			local info = entry.info
			local icon = btn.icon or btn.Icon
			icon:SetTexture(info.iconFileID)
			btn.text:SetText(info.quantity)

			-- The button's ID is Blizzard's watch index, not our display
			-- position: the template's own tooltip (SetBackpackToken) reads
			-- it, so it has to follow the currency, not the slot it sits in.
			btn:SetID(entry.index)
			btn.currencyID = info.currencyTypesID

			btn:ClearAllPoints()
			btn.text:ClearAllPoints()
			btn.text:Point("RIGHT", rightAnchor, rightAnchorPoint, rightPadding, 0)
			btn:Point("RIGHT", btn.text, "LEFT", -2, 0)
			btn:Show()

			rightAnchor, rightAnchorPoint, rightPadding = btn, "LEFT", -14
		else
			btn.currencyID = nil
			btn:Hide()
		end
	end
end

-------------------------------------------------------------------------------
--  Vendor Grays
-------------------------------------------------------------------------------
-- Same "sellable grey/Poor quality item" definition used for the Junk
-- category (CategoryClassifier.lua): excludes unsellable poor items (e.g.
-- quest-bound ones with no vendor price).
function module:GetJunkValue()
	local value = 0

	for _, bagID in ipairs(BAG_IDS) do
		local numSlots = C_Container_GetContainerNumSlots(bagID)
		for slotID = 1, numSlots do
			local info = C_Container_GetContainerItemInfo(bagID, slotID)
			if info and info.hyperlink and not info.hasNoValue and info.quality == ITEMQUALITY_POOR then
				local sellPrice = select(11, API.GetItemInfo(info.hyperlink))
				if sellPrice and sellPrice > 0 then
					value = value + sellPrice * (info.stackCount or 1)
				end
			end
		end
	end

	return value
end

-- Blizzard's own bulk-sell action (same one ElvUI's own bags default to,
-- see B.db.useBlizzardJunk) - a single server round-trip instead of
-- iterating/selling items one at a time ourselves.
function module:VendorGrays()
	if not _G.MerchantFrame or not _G.MerchantFrame:IsShown() then
		E:Print(L["You must be at a vendor."])
		return
	end

	if not C_MerchantFrame_SellAllJunkItems then
		return
	end

	if module:GetJunkValue() == 0 then
		E:Print(L["No gray items to sell."])
		return
	end

	local goldBefore = GetMoney()
	C_MerchantFrame_SellAllJunkItems()

	C_Timer.After(0.5, function()
		local gained = GetMoney() - goldBefore
		if gained > 0 then
			E:Print(format(L["Vendored gray items for: %s"], E:FormatMoney(gained, "SMART")))
		end
	end)
end

-- Blizzard's own "Deposit" button action (same one on ElvUI's Bank frame,
-- B:BankTabs_DepositCharacter/DepositWarband) - sorts bag items straight into
-- whichever bank tab the player configured them for via each tab's "Assign to
-- Tab" rules (the same edit panel our Ctrl+Right-click "Move to Bank Tab"
-- opens), in one call instead of moving items one at a time. Targets whichever
-- of the two banks the sidebar is currently showing.
function module:AutoDepositToBank()
	if not module.isBankOpen or not BankAPI.AutoDeposit then
		E:Print(L["You must be at the bank."])
		return
	end

	local isWarbandView = module.bankViewMode == "WARBAND_ALL" or module.bankViewMode == "ONEWARBAND"
	local bankType = isWarbandView and WARBAND_BANK_TYPE or CHARACTER_BANK_TYPE
	BankAPI.AutoDeposit(bankType)
end

-- Confirmation prompt for buying the next bank tab (mirrors Blizzard's own
-- purchase flow, which also confirms before spending gold) - BankAPI.PurchaseTab
-- always targets "the next" tab, there's no per-tab selection, so this is
-- only ever offered for the one tab slot right after your last purchased one.
local function ShowPurchaseBankTabPrompt(bankType)
	if not BankAPI.FetchNextPurchasableTabData or not BankAPI.PurchaseTab then
		return
	end

	local tabData = BankAPI.FetchNextPurchasableTabData(bankType)
	if not tabData then
		return
	end

	local message = format(
		"%s\n\n%s\n\n%s: %s",
		tabData.purchasePromptTitle or "",
		tabData.purchasePromptBody or "",
		L["Cost"],
		E:FormatMoney(tabData.tabCost, "SMART")
	)

	StaticPopup_Show("MER_BAGCATEGORIES_PURCHASE_BANK_TAB", message, nil, { bankType = bankType })
end

-------------------------------------------------------------------------------
--  Data collection + render
-------------------------------------------------------------------------------
local categoryItemsScratch = {}

-- Same restriction ElvUI's own item level display uses: only equippable gear
-- (Armor covers trinkets/rings/necks too) above Common quality, and only
-- items that don't have a level yet resolved (avoids the extra tooltip-scan
-- work GetDetailedItemLevelInfo does for everything else in the bags).
local function GetDisplayItemLevel(itemLink, quality)
	if not itemLink or not quality or quality <= ITEMQUALITY_COMMON then
		return nil
	end

	local _, _, _, _, _, classID = API.GetItemInfoInstant(itemLink)
	if classID ~= ITEMCLASS_ARMOR and classID ~= ITEMCLASS_WEAPON then
		return nil
	end

	local iLvl = API.GetDetailedItemLevelInfo(itemLink)
	return iLvl and iLvl > 0 and iLvl or nil
end

-- Only informative for items that aren't bound yet (BoP items are already
-- bound the instant they're looted, so there's nothing left to show).
-- Returns (isWarbound, isUntilEquipped). Warbound items are Warband-account
-- bound outright, or "Warbound until equipped" - which GetItemInfo reports as
-- a plain BoE, so that variant needs the ItemLocation-based check (same
-- approach ElvUI's own bags use).
local function GetWarboundInfo(itemLink, bagID, slotID)
	if not itemLink then
		return false, false
	end

	local _, _, _, _, _, _, _, _, _, _, _, _, _, bindType = API.GetItemInfo(itemLink)
	if bindType == ITEMBIND_TO_BNET_ACCOUNT then
		return true, false
	elseif bindType == ITEMBIND_TO_BNET_ACCOUNT_UNTIL_EQUIPPED then
		return true, true
	elseif bindType == ITEMBIND_ON_EQUIP and API.IsBoundToAccountUntilEquip then
		if API.IsBoundToAccountUntilEquip(ItemLocation:CreateFromBagAndSlot(bagID, slotID)) then
			return true, true
		end
	end

	return false, false
end

local function GetBindText(itemLink, isBound, isUntilEquipped)
	if not itemLink or isBound then
		return nil
	end

	if isUntilEquipped then
		return L["WuE"]
	end

	local _, _, _, _, _, _, _, _, _, _, _, _, _, bindType = API.GetItemInfo(itemLink)
	return bindType and BIND_TEXT[bindType]
end

-- Same "sellable grey/Poor quality item" definition used for the Junk
-- category and Vendor Grays (CategoryClassifier.lua/module:GetJunkValue).
local function GetQuestAndJunkInfo(bagID, slotID, quality, hasNoValue)
	local questID, isActiveQuest
	local questInfo = C_Container_GetContainerItemQuestInfo(bagID, slotID)
	if questInfo then
		questID = questInfo.questID
		isActiveQuest = questInfo.isActive
	end

	local isJunk = quality == ITEMQUALITY_POOR and not hasNoValue

	return questID, isActiveQuest, isJunk
end

-------------------------------------------------------------------------------
--  Category sub-grouping (expansion / equipment-set nesting within a category)
-------------------------------------------------------------------------------
-- The itemID -> set-name map itself now lives in CategoryClassifier.lua
-- (module.RebuildEquipmentSetItemMap/module:GetEquipmentSetName) since
-- ClassifyItem needs it too (Item Set Gear routing), not just this file's own
-- sub-header labeling.

-- expacID (15th return of GetItemInfo) maps to Blizzard's own localized
-- EXPANSION_NAME0.."11" globals, the same constants used by e.g. the class
-- trainer/PvP talent expansion filters.
local function GetItemExpansionInfo(itemID)
	if not itemID then
		return nil
	end

	local expacID = select(15, API.GetItemInfo(itemID))
	if not expacID then
		return nil
	end

	return _G["EXPANSION_NAME" .. expacID], expacID
end

-- Expansion logos (the wide 2:1 artwork from the login screen) used as the
-- sub-header icon; cached since the lookup runs for every nested item.
local expansionLogoCache = {}
local function GetExpansionLogo(expacID)
	if not expacID or not GetExpansionDisplayInfo then
		return nil
	end

	local logo = expansionLogoCache[expacID]
	if logo == nil then
		local info = GetExpansionDisplayInfo(expacID)
		logo = info and info.logo or false
		expansionLogoCache[expacID] = logo
	end

	return logo or nil
end

-- Both kinds of nesting are optional; a category only nests when its own
-- rule says so AND the matching option is on.
local function NestsByExpansion(cat)
	return (cat and cat.nestByExpansion and module.db.nestByExpansion) or false
end

local function NestsByEquipmentSet(cat)
	return (cat and cat.nestByEquipmentSet and module.db.nestByEquipmentSet) or false
end

-- Groups items sharing the same subgroupName (expansion name, or equipment
-- set name) into contiguous runs, items without one first/unsorted. Returns
-- the reordered items plus a list of { name, index } marking where a small
-- sub-header should be inserted before rendering that item.
local function GroupBySubgroup(items, nestByExpansion)
	local seen, nameOrder, orderedNames = {}, {}, {}
	local nameIcon, nameIsLogo = {}, {}

	for _, entry in ipairs(items) do
		local name = entry.subgroupName
		if name and not seen[name] then
			seen[name] = true
			nameOrder[name] = entry.subgroupOrder or 0
			nameIcon[name] = entry.subgroupIcon
			nameIsLogo[name] = entry.subgroupIconIsLogo
			tinsert(orderedNames, name)
		end
	end

	if #orderedNames == 0 then
		return items, nil
	end

	if nestByExpansion then
		tsort(orderedNames, function(a, b)
			return nameOrder[a] > nameOrder[b]
		end)
	else
		tsort(orderedNames)
	end

	local buckets, result = {}, {}
	for _, entry in ipairs(items) do
		if entry.subgroupName then
			buckets[entry.subgroupName] = buckets[entry.subgroupName] or {}
			tinsert(buckets[entry.subgroupName], entry)
		else
			tinsert(result, entry)
		end
	end

	local subHeaders = {}
	for _, name in ipairs(orderedNames) do
		local bucket = buckets[name]
		if bucket and #bucket > 0 then
			tinsert(subHeaders, {
				name = name,
				index = #result + 1,
				count = #bucket,
				icon = nameIcon[name],
				isLogo = nameIsLogo[name],
			})
			for _, entry in ipairs(bucket) do
				tinsert(result, entry)
			end
		end
	end

	return result, subHeaders
end

local function CollectItemsFromBags(bagIDList, scratch)
	for k in pairs(scratch) do
		wipe(scratch[k])
	end

	local searching = module.searchText and module.searchText ~= ""
	C_Container_SetItemSearch(searching and module.searchText or "")

	local catByKey = {}
	for _, cat in ipairs(module:GetCategories()) do
		catByKey[cat.key] = cat
	end
	module:RebuildEquipmentSetItemMap()

	for _, bagID in ipairs(bagIDList) do
		local numSlots = C_Container_GetContainerNumSlots(bagID)

		for slotID = 1, numSlots do
			local info = C_Container_GetContainerItemInfo(bagID, slotID)

			if info and info.iconFileID and not (searching and info.isFiltered) then
				local key = module:ClassifyItem(bagID, slotID, info.itemID, info.hyperlink)
				if key then
					scratch[key] = scratch[key] or {}

					local cat = catByKey[key]
					local subgroupName, subgroupOrder, subgroupIcon, subgroupIconIsLogo
					if NestsByExpansion(cat) then
						subgroupName, subgroupOrder = GetItemExpansionInfo(info.itemID)
						subgroupIcon = GetExpansionLogo(subgroupOrder)
						subgroupIconIsLogo = true
					elseif NestsByEquipmentSet(cat) then
						subgroupName = module:GetEquipmentSetName(info.itemID)
						subgroupIcon = module:GetEquipmentSetIcon(subgroupName)
					end

					local questID, isActiveQuest, isJunk =
						GetQuestAndJunkInfo(bagID, slotID, info.quality, info.hasNoValue)

					local isWarbound, isUntilEquipped = GetWarboundInfo(info.hyperlink, bagID, slotID)

					local isNew = API.IsNewItem(bagID, slotID) or newItemSnapshot[bagID * 1000 + slotID] or false
					if isNew then
						MarkItemRecent(info.itemID)
					end

					tinsert(scratch[key], {
						bagID = bagID,
						slotID = slotID,
						itemID = info.itemID,
						itemLink = info.hyperlink,
						icon = info.iconFileID,
						count = info.stackCount,
						quality = info.quality,
						isLocked = info.isLocked,
						isNew = isNew,
						isRecent = module:IsRecentItem(info.itemID),
						itemLevel = module.db.itemLevel.enable and GetDisplayItemLevel(info.hyperlink, info.quality)
							or nil,
						bindText = module.db.itemInfo.enable and GetBindText(info.hyperlink, info.isBound, isUntilEquipped) or nil,
						isWarbound = isWarbound,
						subgroupName = subgroupName,
						subgroupOrder = subgroupOrder,
						subgroupIcon = subgroupIcon,
						subgroupIconIsLogo = subgroupIconIsLogo,
						questID = questID,
						isActiveQuest = isActiveQuest,
						isJunk = isJunk,
					})
				end
			end
		end
	end

	return scratch
end

local function CollectItems()
	return CollectItemsFromBags(BAG_IDS, categoryItemsScratch)
end

local function BuildCategorySectionsFrom(itemsByCategory)
	local db = module.db
	local categories = module:GetCategories()
	local sections = {}

	if db.showPinned then
		local pinned = {}
		for _, cat in ipairs(categories) do
			for _, entry in ipairs(itemsByCategory[cat.key] or {}) do
				if module:IsItemPinned(entry.itemID) then
					tinsert(pinned, entry)
				end
			end
		end

		if #pinned > 0 or not db.hideEmptyCategories then
			tinsert(sections, {
				key = module.PinnedCategory.key,
				name = module.PinnedCategory.name,
				icon = module.PinnedCategory.icon,
				isAtlas = true,
				items = pinned,
			})
		end
	end

	if db.showRecent then
		local recent = {}
		for _, cat in ipairs(categories) do
			for _, entry in ipairs(itemsByCategory[cat.key] or {}) do
				if entry.isRecent then
					tinsert(recent, entry)
				end
			end
		end

		if #recent > 0 or not db.hideEmptyCategories then
			tinsert(sections, {
				key = module.RecentCategory.key,
				name = module.RecentCategory.name,
				icon = module.RecentCategory.icon,
				isAtlas = true,
				items = recent,
				showClear = #recent > 0,
			})
		end
	end

	-- Category groups (e.g. "Equipment") merge several categories' items
	-- into one combined content section; the sidebar still lists each member
	-- underneath the group as its own indented, clickable row (see the
	-- isGroup handling in RefreshCategoryFrame).
	local emittedGroups = {}

	for _, cat in ipairs(categories) do
		local group = module:GetCategoryGroupForKey(cat.key)

		if group then
			if not emittedGroups[group.key] then
				emittedGroups[group.key] = true

				local mergedItems, groupMembers = {}, {}
				local hasNesting, nestByExpansion = false, false

				for _, memberKey in ipairs(group.members) do
					local memberCat = module:FindCategory(memberKey)
					local memberItems = itemsByCategory[memberKey] or {}

					for _, entry in ipairs(memberItems) do
						tinsert(mergedItems, entry)
					end

					if memberCat then
						if NestsByEquipmentSet(memberCat) then
							hasNesting = true
						end
						if NestsByExpansion(memberCat) then
							hasNesting, nestByExpansion = true, true
						end
					end

					tinsert(groupMembers, {
						key = memberKey,
						name = memberCat and memberCat.name or memberKey,
						icon = memberCat and memberCat.icon,
						isAtlas = memberCat and memberCat.isAtlas,
						count = #memberItems,
					})
				end

				local subHeaders
				if hasNesting then
					mergedItems, subHeaders = GroupBySubgroup(mergedItems, nestByExpansion)
				end

				if #mergedItems > 0 or not db.hideEmptyCategories then
					tinsert(sections, {
						key = group.key,
						name = module:GetGroupName(group),
						icon = group.icon,
						isAtlas = group.isAtlas,
						items = mergedItems,
						subHeaders = subHeaders,
						isGroup = true,
						groupMembers = groupMembers,
					})
				end
			end
		else
			local items = itemsByCategory[cat.key] or {}
			if #items > 0 or not db.hideEmptyCategories or cat.isUser then
				local subHeaders
				if NestsByExpansion(cat) or NestsByEquipmentSet(cat) then
					items, subHeaders = GroupBySubgroup(items, NestsByExpansion(cat))
				end
				tinsert(sections, {
					key = cat.key,
					name = cat.name,
					icon = cat.icon,
					isAtlas = cat.isAtlas,
					items = items,
					subHeaders = subHeaders,
				})
			end
		end
	end

	return sections
end

local function BuildCategorySections()
	return BuildCategorySectionsFrom(CollectItems())
end

-------------------------------------------------------------------------------
--  Bag view (group by physical bag instead of category)
-------------------------------------------------------------------------------
local bagItemsScratch = {}

local function CollectItemsByBagFrom(bagIDList, scratch)
	for k in pairs(scratch) do
		wipe(scratch[k])
	end

	local searching = module.searchText and module.searchText ~= ""
	C_Container_SetItemSearch(searching and module.searchText or "")

	for _, bagID in ipairs(bagIDList) do
		local numSlots = C_Container_GetContainerNumSlots(bagID)

		for slotID = 1, numSlots do
			local info = C_Container_GetContainerItemInfo(bagID, slotID)

			if info and info.iconFileID and not (searching and info.isFiltered) then
				scratch[bagID] = scratch[bagID] or {}

				local questID, isActiveQuest, isJunk =
					GetQuestAndJunkInfo(bagID, slotID, info.quality, info.hasNoValue)

				local isWarbound, isUntilEquipped = GetWarboundInfo(info.hyperlink, bagID, slotID)

				local isNew = API.IsNewItem(bagID, slotID) or newItemSnapshot[bagID * 1000 + slotID] or false
				if isNew then
					MarkItemRecent(info.itemID)
				end

				tinsert(scratch[bagID], {
					bagID = bagID,
					slotID = slotID,
					itemID = info.itemID,
					itemLink = info.hyperlink,
					icon = info.iconFileID,
					count = info.stackCount,
					quality = info.quality,
					isLocked = info.isLocked,
					isNew = isNew,
					isRecent = module:IsRecentItem(info.itemID),
					itemLevel = module.db.itemLevel.enable and GetDisplayItemLevel(info.hyperlink, info.quality)
						or nil,
					bindText = module.db.itemInfo.enable and GetBindText(info.hyperlink, info.isBound, isUntilEquipped) or nil,
					isWarbound = isWarbound,
					questID = questID,
					isActiveQuest = isActiveQuest,
					isJunk = isJunk,
					-- Only used to check the "Hide in All Items" flag below,
					-- not shown/used anywhere in the bag-grouped view itself.
					categoryKey = module:ClassifyItem(bagID, slotID, info.itemID, info.hyperlink),
				})
			end
		end
	end

	return scratch
end

local function CollectItemsByBag()
	return CollectItemsByBagFrom(BAG_IDS, bagItemsScratch)
end

-- Character/Warband bank tabs can have a custom icon/name set by the player
-- (via right-click "Edit Tab" on the real Blizzard bank frame) -
-- C_Bank.FetchPurchasedBankTabData returns that per-tab data (field .ID is
-- the bagID), same source ElvUI itself reads for its own bank tab buttons
-- (Bags.lua, B:BankTab_PurchasedData).
local bankTabDataScratch = {}
local function GetBankTabInfo(bagID)
	if not BankAPI.FetchPurchasedTabData then
		return nil
	end

	local bankType
	if module.BankBagIDSet[bagID] then
		bankType = CHARACTER_BANK_TYPE
	elseif module.WarbandBagIDSet[bagID] then
		bankType = WARBAND_BANK_TYPE
	else
		return nil
	end

	wipe(bankTabDataScratch)
	local tabs = BankAPI.FetchPurchasedTabData(bankType)
	if tabs then
		for _, data in ipairs(tabs) do
			bankTabDataScratch[data.ID] = data
		end
	end

	return bankTabDataScratch[bagID]
end

-- Reagent bag keeps its own dedicated icon (matches the Reagent Bag category);
-- the backpack gets ElvUI's flat backpack icon; a bank tab uses its own
-- (possibly player-customized) icon; every other bag shows the actual equipped
-- bag's own icon, same as looking at your character panel.
local function GetBagIcon(bagID)
	if bagID == 0 then
		return E.Media.Textures.Backpack
	end

	if bagID == module.ReagentContainer then
		return 132854
	end

	local bankInfo = GetBankTabInfo(bagID)
	if bankInfo and bankInfo.icon then
		return bankInfo.icon
	end

	local invID = C_Container.ContainerIDToInventoryID and C_Container.ContainerIDToInventoryID(bagID)
	local texture = invID and GetInventoryItemTexture("player", invID)
	return texture or E.Media.Textures.Backpack
end

local function GetBagDisplayName(bagID)
	if bagID == 0 then
		return _G.BACKPACK_TOOLTIP or L["Backpack"]
	end

	if bagID == module.ReagentContainer then
		return L["Reagent Bag"]
	end

	local bankInfo = GetBankTabInfo(bagID)
	if bankInfo and bankInfo.name then
		return bankInfo.name
	end

	return C_Container.GetBagName(bagID) or format(L["Bag %d"], bagID)
end

-------------------------------------------------------------------------------
--  Bag Bar popout (quick glance at equipped bags, toggled from the title bar)
-------------------------------------------------------------------------------
local BAG_BAR_BUTTON_SIZE, BAG_BAR_SPACING = 30, 4
module.BAG_BAR_BUTTON_SIZE, module.BAG_BAR_SPACING = BAG_BAR_BUTTON_SIZE, BAG_BAR_SPACING

-- Tri-state helper for a fixed-length bank/warband tab list (purchased / next
-- purchasable / locked) - shared by the Bank frame's own sidebar tab rows
-- (BankFrame.lua). BankAPI.PurchaseTab always buys "the next" tab, there's no
-- per-tab selection, so only the slot right after the last purchased one can
-- ever be "purchasable"; anything further out stays "locked" until that one
-- is bought (same one-step-at-a-time reveal Blizzard's own tab bar uses).
local function GetBankTabSlotState(bagIDList, bankType, index)
	local bagID = bagIDList[index]
	if not bagID then
		return nil
	end

	local purchasedCount = (bankType and BankAPI.FetchNumPurchasedTabs) and BankAPI.FetchNumPurchasedTabs(bankType)
		or #bagIDList

	if index <= purchasedCount then
		return "purchased", bagID
	elseif index == purchasedCount + 1 and bankType and BankAPI.CanPurchaseTab and BankAPI.CanPurchaseTab(bankType) then
		return "purchasable", bankType
	end

	return "locked"
end

module.GetBankTabSlotState = GetBankTabSlotState

-- Bank/Warband tabs now live in the Bank frame's own sidebar (BankFrame.lua),
-- so this popout only ever needs to show the player's regular equipped bags.
function module:ConstructBagBarPopout()
	if module.bagBarPopout then
		return module.bagBarPopout
	end

	local f = CreateFrame("Frame", "MER_BagCategoriesBagBar", E.UIParent)
	f:SetFrameStrata("DIALOG")
	pcall(f.SetTemplate, f, "Transparent")
	WS:CreateShadow(f)
	f:Hide()

	f.buttons = {}
	for i = 1, #BAG_IDS do
		local btn = CreateFrame("Button", nil, f)
		btn:Size(BAG_BAR_BUTTON_SIZE, BAG_BAR_BUTTON_SIZE)
		btn:Point("LEFT", BAG_BAR_SPACING + (i - 1) * (BAG_BAR_BUTTON_SIZE + BAG_BAR_SPACING), 0)
		pcall(btn.SetTemplate, btn)

		btn.tex = btn:CreateTexture(nil, "ARTWORK")
		btn.tex:SetInside()
		btn.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)

		btn.count = btn:CreateFontString(nil, "OVERLAY")
		btn.count:FontTemplate(nil, 10, "OUTLINE")
		btn.count:Point("BOTTOMRIGHT", -1, 1)

		btn:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], "ADD")

		btn:SetScript("OnClick", function(self)
			if not self.bagID then
				return
			end

			module.db.viewMode = "BAG"
			module:RefreshCategoryFrame()
			module:ScrollToCategory("BAG_" .. self.bagID)
		end)

		btn:SetScript("OnEnter", function(self)
			if GameTooltip:IsForbidden() or not self.bagID then
				return
			end

			local numSlots = C_Container_GetContainerNumSlots(self.bagID)
			local freeSlots = C_Container.GetContainerNumFreeSlots and C_Container.GetContainerNumFreeSlots(self.bagID)
				or numSlots

			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:AddLine(format("%s (%d/%d)", GetBagDisplayName(self.bagID), numSlots - freeSlots, numSlots), 1, 1, 1)
			GameTooltip:Show()

			module.hoveredBagID = self.bagID
			RefreshSlotDim()
		end)
		btn:SetScript("OnLeave", function()
			GameTooltip_Hide()
			module.hoveredBagID = nil
			RefreshSlotDim()
		end)

		f.buttons[i] = btn
	end

	module.bagBarPopout = f
	return f
end

function module:RefreshBagBarPopout()
	local f = module.bagBarPopout
	if not f then
		return
	end

	for i, btn in ipairs(f.buttons) do
		local bagID = BAG_IDS[i]
		btn.bagID = bagID

		if bagID then
			btn.tex:SetTexture(GetBagIcon(bagID))
			local freeSlots = C_Container.GetContainerNumFreeSlots and C_Container.GetContainerNumFreeSlots(bagID)
			btn.count:SetText(freeSlots or "")
			btn:Show()
		else
			btn:Hide()
		end
	end

	f:Size(#BAG_IDS * (BAG_BAR_BUTTON_SIZE + BAG_BAR_SPACING) + BAG_BAR_SPACING, BAG_BAR_BUTTON_SIZE + BAG_BAR_SPACING * 2)
end

function module:ToggleBagBarPopout()
	local f = module:ConstructBagBarPopout()
	if f:IsShown() then
		f:Hide()
		return
	end

	module:RefreshBagBarPopout()
	f:ClearAllPoints()
	f:Point("BOTTOM", module.bagBarButton, "TOP", 0, 4)
	f:Show()
end

-- alwaysShow bypasses hideEmptyCategories for the per-bag sections only
-- (Pinned/Recent still respect it) - the bank frame's tab view wants every
-- purchased tab listed even when empty, since a physical tab's identity
-- doesn't depend on its current contents the way a soft category's does.
-- skipSidebarRows marks each bag section so RenderCategorySections doesn't
-- also give it a row in the scrollable sidebar - the bank frame already has
-- its own fixed per-tab rows for that (see BankFrame.lua), so a second,
-- scroll-to-section row per tab would just be a confusing duplicate; the
-- regular bag frame's own MultiBag mode has no such fixed rows and still
-- wants them, so it's an opt-in flag rather than the default.
local function BuildBagSectionsFrom(bagIDList, itemsByBag, alwaysShow, skipSidebarRows)
	local db = module.db
	local sections = {}

	-- Pinned/Recent stay useful (and stay at the top) regardless of grouping.
	if db.showPinned then
		local pinned = {}
		for _, bagID in ipairs(bagIDList) do
			for _, entry in ipairs(itemsByBag[bagID] or {}) do
				if module:IsItemPinned(entry.itemID) then
					tinsert(pinned, entry)
				end
			end
		end

		if #pinned > 0 or not db.hideEmptyCategories then
			tinsert(sections, {
				key = module.PinnedCategory.key,
				name = module.PinnedCategory.name,
				icon = module.PinnedCategory.icon,
				isAtlas = true,
				items = pinned,
			})
		end
	end

	if db.showRecent then
		local recent = {}
		for _, bagID in ipairs(bagIDList) do
			for _, entry in ipairs(itemsByBag[bagID] or {}) do
				if entry.isRecent then
					tinsert(recent, entry)
				end
			end
		end

		if #recent > 0 or not db.hideEmptyCategories then
			tinsert(sections, {
				key = module.RecentCategory.key,
				name = module.RecentCategory.name,
				icon = module.RecentCategory.icon,
				isAtlas = true,
				items = recent,
				showClear = #recent > 0,
			})
		end
	end

	for _, bagID in ipairs(bagIDList) do
		local items = itemsByBag[bagID] or {}
		if alwaysShow or #items > 0 or not db.hideEmptyCategories then
			tinsert(sections, {
				key = "BAG_" .. bagID,
				name = GetBagDisplayName(bagID),
				icon = GetBagIcon(bagID),
				isBagSection = true,
				skipSidebarRow = skipSidebarRows or nil,
				items = items,
			})
		end
	end

	return sections
end

local function BuildBagSections()
	return BuildBagSectionsFrom(BAG_IDS, CollectItemsByBag())
end

-------------------------------------------------------------------------------
--  All Items view (flat, ungrouped list)
-------------------------------------------------------------------------------
module.AllItemsCategory = { key = "ALL_ITEMS", name = L["All Items"], icon = E.Media.Textures.Backpack }

-- A category (or the group it belongs to, e.g. "Equipment") can be flagged
-- via its context menu to not show up in the flat "All Items" view, while
-- still appearing normally in OneBag/MultiBag.
local function IsCategoryHiddenFromAllItems(categoryKey)
	if not categoryKey then
		return false
	end

	if module:IsHiddenFromAllItems(categoryKey) then
		return true
	end

	local group = module:GetCategoryGroupForKey(categoryKey)
	return group and module:IsHiddenFromAllItems(group.key) or false
end

local function BuildFlatSectionsFrom(bagIDList, itemsByBag)
	local db = module.db
	local sections = {}

	if db.showPinned then
		local pinned = {}
		for _, bagID in ipairs(bagIDList) do
			for _, entry in ipairs(itemsByBag[bagID] or {}) do
				if module:IsItemPinned(entry.itemID) then
					tinsert(pinned, entry)
				end
			end
		end

		if #pinned > 0 or not db.hideEmptyCategories then
			tinsert(sections, {
				key = module.PinnedCategory.key,
				name = module.PinnedCategory.name,
				icon = module.PinnedCategory.icon,
				isAtlas = true,
				items = pinned,
			})
		end
	end

	if db.showRecent then
		local recent = {}
		for _, bagID in ipairs(bagIDList) do
			for _, entry in ipairs(itemsByBag[bagID] or {}) do
				if entry.isRecent then
					tinsert(recent, entry)
				end
			end
		end

		if #recent > 0 or not db.hideEmptyCategories then
			tinsert(sections, {
				key = module.RecentCategory.key,
				name = module.RecentCategory.name,
				icon = module.RecentCategory.icon,
				isAtlas = true,
				items = recent,
				showClear = #recent > 0,
			})
		end
	end

	local allItems = {}
	for _, bagID in ipairs(bagIDList) do
		for _, entry in ipairs(itemsByBag[bagID] or {}) do
			-- "Hide in All Items" (category/group context menu) only affects
			-- this flat view - OneBag/MultiBag still show everything.
			if not IsCategoryHiddenFromAllItems(entry.categoryKey) then
				tinsert(allItems, entry)
			end
		end
	end

	tinsert(sections, {
		key = module.AllItemsCategory.key,
		name = module.AllItemsCategory.name,
		icon = module.AllItemsCategory.icon,
		items = allItems,
	})

	return sections
end

local function BuildFlatSections()
	return BuildFlatSectionsFrom(BAG_IDS, CollectItemsByBag())
end

-- Panels that hand over one bag slot at a time (mail, trade, auction house,
-- vendor, bank, guild bank): a merged slot button only passes along the one
-- slot behind it, so three merged stacks would mail/sell exactly one. While
-- any of them is open, duplicates stay split.
module.openItemPanels = {}

local ITEM_PANEL_EVENTS = {
	MAIL_SHOW = { "mail", true },
	MAIL_CLOSED = { "mail", false },
	TRADE_SHOW = { "trade", true },
	TRADE_CLOSED = { "trade", false },
	AUCTION_HOUSE_SHOW = { "auction", true },
	AUCTION_HOUSE_CLOSED = { "auction", false },
	MERCHANT_SHOW = { "merchant", true },
	MERCHANT_CLOSED = { "merchant", false },
	GUILDBANKFRAME_OPENED = { "guildbank", true },
	GUILDBANKFRAME_CLOSED = { "guildbank", false },
}
module.ITEM_PANEL_EVENTS = ITEM_PANEL_EVENTS

function module:SetItemPanelOpen(key, open)
	if (module.openItemPanels[key] or false) == open then
		return
	end

	module.openItemPanels[key] = open or nil

	if module.frame and module.frame:IsShown() then
		module:RefreshCategoryFrame()
	end
	if module.bankFrame and module.bankFrame:IsShown() then
		module:RefreshBankCategoryFrame()
	end
end

function module:OnItemPanelEvent(event)
	local panel = ITEM_PANEL_EVENTS[event]
	if panel then
		module:SetItemPanelOpen(panel[1], panel[2])
	end
end

local function AnyItemPanelOpen()
	if next(module.openItemPanels) ~= nil then
		return true
	end

	-- The bank counts as one of those panels, but it has its own event
	-- handlers already (OnBankOpened/OnBankClosed) - read its state instead
	-- of duplicating them here.
	return module.isBankOpen and true or false
end

-- Collapses identical stacks (same item link) into one button showing the
-- combined count; the button still acts on the first stack's bag/slot, which
-- is why this is off while an item panel is open. Gear is left alone: two
-- copies of the same piece are still two separate things to compare, equip
-- or hand in, and the reference behaves the same way.
-- Items split in this session, keyed by link: shown as separate stacks
-- until the bag window closes, so a split is actually visible.
module.unmergedLinks = {}

local function MergeDuplicateEntries(items)
	if not module.db.mergeDuplicates or AnyItemPanelOpen() then
		return items
	end

	local seen, merged = {}, {}
	for _, entry in ipairs(items) do
		local key = entry.itemLink
		if key and not API.IsEquippableItem(key) and not module.unmergedLinks[key] then
			local existing = seen[key]
			if existing then
				-- Copy on first duplicate: the entry itself is also painted
				-- by the untouched bag views, which must keep the real
				-- per-slot count.
				if not existing.isMerged then
					local proxy = {}
					for field, value in pairs(existing) do
						proxy[field] = value
					end
					proxy.isMerged = true
					merged[existing.mergeIndex] = proxy
					seen[key] = proxy
					proxy.mergeIndex = existing.mergeIndex
					existing = proxy
				end

				existing.count = (existing.count or 1) + (entry.count or 1)
				existing.isNew = existing.isNew or entry.isNew
			else
				tinsert(merged, entry)
				entry.mergeIndex = #merged
				seen[key] = entry
			end
		else
			tinsert(merged, entry)
		end
	end

	return merged
end

-- Sidebar rows and section headers keep counting real stacks, so the numbers
-- don't change just because the view merges them.
-- A section can carry a manual item order when it has a stable identity to
-- store one under: the physical bag views and the flat All Items list don't,
-- Recent Items is ordered by when things arrived, and a section split into
-- expansion/set sub-headers is already arranged by those buckets.
local function GetSectionOrderKey(section)
	if
		section.isBagSection
		or section.isRecent
		or section.subHeaders
		or section.key == module.AllItemsCategory.key
	then
		return nil
	end

	return section.key
end

local function MergeSectionItems(sections)
	module.orderedSectionItems = wipe(module.orderedSectionItems or {})

	for _, section in ipairs(sections) do
		section.itemCount = #section.items

		section.orderKey = GetSectionOrderKey(section)
		if section.orderKey then
			section.items = ApplyItemOrder(section.orderKey, section.items)
			module.orderedSectionItems[section.orderKey] = section.items
		end

		if not section.isBagSection then
			section.items = MergeDuplicateEntries(section.items)
		end
	end

	return sections
end
module.MergeSectionItems = MergeSectionItems

local function BuildSections()
	local viewMode = module.db.viewMode

	if viewMode == "BAG" then
		return MergeSectionItems(BuildBagSections())
	elseif viewMode == "ALL" then
		return MergeSectionItems(BuildFlatSections())
	end

	return MergeSectionItems(BuildCategorySections())
end

function module:SetSidebarCollapsed(collapsed)
	module.db.sidebarCollapsed = collapsed
	module:RefreshCategoryFrame()
end

-- Shared by both the bag and bank frames' sidebar category rows
-- (Sidebar_OnClick passes the clicked row's own ownerFrame/offsets); the two
-- positional defaults keep every other existing call site (the bag frame's
-- own Pinned-row shortcut, the Bag Bar's "jump to this bag" click) working
-- unchanged.
function module:ScrollToCategory(key, frame, offsets)
	frame = frame or module.frame
	offsets = offsets or module.categoryOffsets

	-- Jumping to a folded section unfolds it first (no point scrolling to a
	-- bare header). The refresh replaces the offsets table, so re-resolve it.
	local collapsed = module.db.collapsedSections
	local searching = module.searchText and module.searchText ~= ""
	if collapsed[key] and not searching then
		collapsed[key] = nil
		if frame == module.bankFrame then
			module:RefreshBankCategoryFrame()
			offsets = module.bankCategoryOffsets
		else
			module:RefreshCategoryFrame()
			offsets = module.categoryOffsets
		end
	end

	local offset = offsets and offsets[key]
	if offset and frame then
		frame.mainScroll:SetVerticalScroll(offset)
	end
end

-- Shared layout core for the scrollable "category sections" part of a
-- sidebar+content pair (headers, sub-headers, item slots, sidebar category
-- rows) - used by both the bag frame's RefreshCategoryFrame and the bank
-- frame's own RefreshBankCategoryFrame (BankFrame.lua). Everything about
-- WHICH fixed rows sit above this (bag's ALL/CATEGORY/BAG switcher vs the
-- bank's tab list) stays specific to each frame and lives outside this
-- function; this only ever draws sections already built by BuildSections()/
-- the bank frame's own tab-section builder into ctx.contentChild/ctx.sidebarChild.
--
-- ctx fields: contentChild, sidebarChild, pools (from CreatePoolSet),
-- pinnedRow, offsets (the table to record each section's scroll offset
-- into), width, sidebarWidth, refresh (the frame's own Refresh*Frame to
-- re-invoke from a Recent-items Clear button), sidebarBaseY (optional pixel
-- offset to start category rows below - the bank frame renders its own
-- tab-selector rows into the same scrollable sidebarChild ahead of these,
-- see BankFrame.lua's RefreshBankCategoryFrame).
local function RenderCategorySections(ctx, sections)
	local db = module.db
	local pools = ctx.pools

	local contentWidth = ctx.width - ctx.sidebarWidth - 44
	local columns = floor((contentWidth + db.itemSpacingH) / (db.itemSize + db.itemSpacingH))
	if columns < 1 then
		columns = 1
	end

	ctx.contentChild:Width(contentWidth)

	-- Default to 0 up front: with hideEmptyCategories on, an empty Pinned
	-- section is omitted from `sections` entirely (see the builders), so the
	-- loop below never reaches the `ctx.pinnedRow.count:SetText(...)` branch
	-- for it - unpinning the last item would otherwise leave the sidebar
	-- shortcut's count stuck at its previous, now-stale value.
	ctx.pinnedRow.count:SetText(0)

	local slotIndex, headerIndex, subHeaderIndex, sidebarIndex, placeholderIndex = 0, 0, 0, 0, 0
	local y = 0
	local searching = module.searchText and module.searchText ~= ""

	for _, section in ipairs(sections) do
		ctx.offsets[section.key] = y

		headerIndex = headerIndex + 1
		local header = pools.AcquireHeader(headerIndex)
		local headerFont = db.headerFont
		header.text:FontTemplate(headerFont.name, headerFont.size, headerFont.style)
		header:SetHeight(math.max(db.headerHeight, headerFont.size + 8))
		header:ClearAllPoints()
		header:Point("TOPLEFT", ctx.contentChild, "TOPLEFT", 0, -y)
		header:Point("TOPRIGHT", ctx.contentChild, "TOPRIGHT", 0, -y)
		header.text:SetText(format("%s |cff999999(%d)|r", section.name, section.itemCount or #section.items))
		SetCategoryIcon(header.icon, section)

		local collapsed = not searching and db.collapsedSections[section.key] and true or false
		header.sectionKey = section.key
		header.refresh = ctx.refresh
		header.searching = searching
		header.arrow:SetShown(not searching)
		header.arrow:SetRotation(collapsed and S.ArrowRotation.right or S.ArrowRotation.down)

		if section.showClear then
			header.clearButton:Show()
			header.clearButton:SetScript("OnClick", function()
				-- The list itself is the tracked item IDs; the glow on top of
				-- it is the native flag OR our open-time snapshot (see
				-- SnapshotNewItemsForBags), so all three have to go.
				module:ClearRecentItems()
				for _, entry in ipairs(section.items) do
					API.RemoveNewItem(entry.bagID, entry.slotID)
					newItemSnapshot[entry.bagID * 1000 + entry.slotID] = nil
				end
				ctx.refresh()
			end)
		else
			header.clearButton:Hide()
		end

		y = y + header:GetHeight() + HEADER_PADDING

		-- Pinned Items has its own fixed shortcut row above the scrollable
		-- list (see ConstructFrame/ConstructBankFrame), so it's excluded from
		-- the scrollable sidebar rows here - only its content header/items
		-- still render. skipSidebarRow (bank tab sections) is the same idea:
		-- a fixed row already exists elsewhere for it.
		if section.key == module.PinnedCategory.key then
			ctx.pinnedRow.count:SetText(section.itemCount or #section.items)
		elseif not section.skipSidebarRow then
			sidebarIndex = sidebarIndex + 1
			-- Bag sections aren't reorderable either (no persisted "bag order"
			-- concept, and physical bags aren't user-defined categories).
			pools.SetupSidebarCategoryRow(
				sidebarIndex,
				0,
				section.key,
				section.name,
				section.icon,
				section.isAtlas,
				section.itemCount or #section.items,
				section.key:find("^USER_") and true or false,
				section.key == module.RecentCategory.key
					or section.key == module.AllItemsCategory.key
					or section.isBagSection == true
					or section.isGroup == true,
				section.isGroup,
				nil,
				ctx.sidebarBaseY
			)

			-- A category group ("Equipment") shows its member categories as
			-- indented rows right underneath, always expanded - clicking one
			-- jumps to the same merged content section as the parent, just
			-- with that member's own item count/icon for orientation. Skipped
			-- entirely while collapsed rather than hidden after the fact - a
			-- collapsed member row's icon would sit partly outside the narrow
			-- icon-only column (or overlap its parent's), and merely hiding it
			-- still reserves its row slot, leaving a visible gap in the icon
			-- strip below the parent.
			if section.isGroup and section.groupMembers and not db.sidebarCollapsed then
				for _, member in ipairs(section.groupMembers) do
					sidebarIndex = sidebarIndex + 1
					pools.SetupSidebarCategoryRow(
						sidebarIndex,
						14,
						section.key,
						member.name,
						member.icon,
						member.isAtlas,
						member.count,
						false,
						true,
						false,
						member.key,
						ctx.sidebarBaseY
					)
				end
			end
		end

		local col = 0
		local rowStartY = y

		-- "+"/empty slots after a group of real items - drag an item onto
		-- one to assign it to this category (or pin it, for Pinned), without
		-- physically moving it in the bag. Only sections where "assign" has
		-- an unambiguous target get these: not Recent (auto-computed from
		-- new-item detection, nothing to assign to), not a group (which
		-- member would it even go to?), not a physical-bag/flat-All-Items
		-- view section (those are just alternate arrangements of the same
		-- items, not classification targets). Computed up front so it can
		-- also close out each expansion/equipment-set sub-header's own row
		-- below, not just the section's very last one.
		local assignHandler, placeholderTooltip
		if section.isPinned then
			assignHandler = function(itemID)
				if not module:IsItemPinned(itemID) then
					module:TogglePinned(itemID)
				end
				ctx.refresh()
			end
			placeholderTooltip = L["Drag an item here to pin it."]
		elseif not (section.isRecent or section.isGroup or section.isBagSection or section.key == module.AllItemsCategory.key) then
			local categoryKey = section.key
			assignHandler = function(itemID)
				module:AssignItemToCategory(itemID, categoryKey)
				ctx.refresh()
			end
			placeholderTooltip = format(L["Drag an item here to assign it to %s."], section.name)
		end

		local function PadRowWithPlaceholders()
			if not assignHandler then
				return
			end

			local placeholderCount = (col == 0) and columns or (columns - col)
			for i = 1, placeholderCount do
				placeholderIndex = placeholderIndex + 1
				local ph = pools.AcquirePlaceholder(placeholderIndex)
				ph:ClearAllPoints()
				ph:Size(db.itemSize)
				ph:Point("TOPLEFT", ctx.contentChild, "TOPLEFT", col * (db.itemSize + db.itemSpacingH), -rowStartY)
				ph.onAssign = assignHandler
				ph.tooltipText = placeholderTooltip
				local isAddSlot = i == 1
				ph.plusIcon:SetShown(isAddSlot)
				-- All of these accept a drop, but only the "+" one should
				-- visually read as an actual button - the rest stay
				-- transparent, purely there to fill the row out to full width.
				ph.restAlpha = isAddSlot and 1 or db.effects.placeholderAlpha
				ApplyDropHighlight(ph)

				col = col + 1
				if col >= columns then
					col = 0
					rowStartY = rowStartY + db.itemSize + db.itemSpacingV
				end
			end
		end

		if not collapsed and #section.items > 0 then
			local subHeaders = section.subHeaders
			local nextSubHeader = subHeaders and subHeaders[1]
			local nextSubHeaderPos = 2

			for itemIndex, entry in ipairs(section.items) do
				-- A subgroup (expansion/equipment-set name) always starts its
				-- own row, with a small indented header above its items -
				-- close out the previous group's row with placeholders first
				-- (a no-op the very first time, since col is still 0 then).
				if nextSubHeader and nextSubHeader.index == itemIndex then
					if itemIndex > 1 then
						PadRowWithPlaceholders()
					end

					if col > 0 then
						col = 0
						rowStartY = rowStartY + db.itemSize + db.itemSpacingV
					end

					subHeaderIndex = subHeaderIndex + 1
					local subHeader = pools.AcquireSubHeader(subHeaderIndex)
					local subHeaderFont = db.subHeaderFont
					subHeader.text:FontTemplate(subHeaderFont.name, subHeaderFont.size, subHeaderFont.style)
					subHeader:SetHeight(math.max(16, subHeaderFont.size + 5))
					subHeader:ClearAllPoints()
					subHeader:Point("TOPLEFT", ctx.contentChild, "TOPLEFT", 6, -rowStartY)
					subHeader:Point("TOPRIGHT", ctx.contentChild, "TOPRIGHT", -6, -rowStartY)
					subHeader.text:SetText(format("%s |cff999999(%d)|r", nextSubHeader.name, nextSubHeader.count))
					SetSubHeaderIcon(subHeader, module.db.effects.subHeaderIcons and nextSubHeader.icon, nextSubHeader.isLogo)
					local iconWidth = subHeader.icon:IsShown() and (subHeader.icon:GetWidth() + 4) or 0
					subHeader.bg:Width(math.max(subHeader.text:GetStringWidth() + iconWidth + 48, (ctx.contentChild:GetWidth() - 12) * 0.5))
					rowStartY = rowStartY + subHeader:GetHeight() + 2

					nextSubHeader = subHeaders[nextSubHeaderPos]
					nextSubHeaderPos = nextSubHeaderPos + 1
				end

				slotIndex = slotIndex + 1
				local btn = pools.AcquireSlot(slotIndex)
				UpdateSlotVisual(btn, entry)
				btn.orderKey = section.orderKey

				btn:ClearAllPoints()
				btn:Size(db.itemSize)
				btn:Point("TOPLEFT", ctx.contentChild, "TOPLEFT", col * (db.itemSize + db.itemSpacingH), -rowStartY)

				col = col + 1
				if col >= columns then
					col = 0
					rowStartY = rowStartY + db.itemSize + db.itemSpacingV
				end
			end
		end

		-- Closes out either the section's only group (no sub-headers) or the
		-- last sub-header group (earlier ones were already closed above).
		if not collapsed then
			PadRowWithPlaceholders()
		end

		if col > 0 then
			rowStartY = rowStartY + db.itemSize + db.itemSpacingV
		end
		y = rowStartY

		y = y + db.sectionSpacing
	end

	pools.ReleaseSlotsFrom(slotIndex + 1)
	pools.ReleasePlaceholdersFrom(placeholderIndex + 1)
	pools.ReleaseHeadersFrom(headerIndex + 1)
	pools.ReleaseSubHeadersFrom(subHeaderIndex + 1)
	pools.ReleaseSidebarRowsFrom(sidebarIndex + 1)

	ctx.sidebarChild:Height(math.max(1, (ctx.sidebarBaseY or 0) + sidebarIndex * db.sidebarRowHeight))
	ctx.contentChild:Height(math.max(1, y))

	if ctx.emptyText then
		ctx.emptyText:SetShown(#sections == 0)
	end
end

-- Shrinks a window to whatever its content needs, using the configured
-- height as the upper bound - so the height slider becomes "at most this
-- tall" instead of "always this tall". The chrome (title bar, search row,
-- footer) is measured from the live geometry rather than hardcoded, so it
-- keeps working when those change size.
local AUTO_HEIGHT_MIN = 220

local function ApplyAutoHeight(frame, contentChild, sidebarChild, maxHeight)
	if not module.db.autoSize or InCombatLockdown() then
		return
	end

	local scrollHeight = frame.mainScroll:GetHeight()
	if not scrollHeight or scrollHeight <= 0 then
		return
	end

	local chrome = frame:GetHeight() - scrollHeight
	local wanted = contentChild:GetHeight() + chrome + 4

	-- A long category list must not end up scrolling inside a window that
	-- was shrunk to fit a handful of items, so the sidebar sets its own
	-- floor: whatever it overflows by is added to the current height.
	local sidebarOverflow = sidebarChild:GetHeight() - frame.sidebarScroll:GetHeight()
	if sidebarOverflow > 0 then
		wanted = math.max(wanted, frame:GetHeight() + sidebarOverflow)
	end

	wanted = math.min(maxHeight, math.max(AUTO_HEIGHT_MIN, wanted))

	if math.abs(wanted - frame:GetHeight()) >= 1 then
		frame:Height(wanted)
	end
end
module.ApplyAutoHeight = ApplyAutoHeight

module.RenderCategorySections = RenderCategorySections

function module:RefreshCategoryFrame()
	if not module.frame or not module.frame:IsShown() then
		return
	end

	-- Picks up a lowered Recent Items limit from the options without waiting
	-- for the next item to come in.
	TrimRecentItems()

	local db = module.db
	local sections = BuildSections()

	module.categoryOffsets = {}

	local f = module.frame
	local sidebarWidth = db.sidebarCollapsed and COLLAPSED_SIDEBAR_WIDTH or db.sidebarWidth
	f.sidebar:Width(sidebarWidth)
	f.addCategoryButton:SetShown(not db.sidebarCollapsed)

	local totalSlots, usedSlots = 0, 0
	for _, bagID in ipairs(BAG_IDS) do
		local numSlots = C_Container_GetContainerNumSlots(bagID)
		totalSlots = totalSlots + numSlots
		for slotID = 1, numSlots do
			local info = C_Container_GetContainerItemInfo(bagID, slotID)
			if info and info.iconFileID then
				usedSlots = usedSlots + 1
			end
		end
	end

	-- Fixed 3-row ALL/CATEGORY/BAG switcher - always all visible now that
	-- Bank/Warband moved to their own separate frame, so (unlike before) this
	-- never needs to reposition rows around a variable visible-row count.
	-- All three modes just rearrange the SAME items, so they all show the
	-- same total item count next to them.
	for _, row in ipairs(f.viewModeRows) do
		row.text:SetShown(not db.sidebarCollapsed)
		row.count:SetShown(not db.sidebarCollapsed)
		row.count:SetText(usedSlots)
		local isSelected = row.viewModeKey == db.viewMode
		row.selectedTex:SetShown(isSelected)
		row.selectedBar:SetShown(isSelected)
		module.SetSelectedRowTextColor(row, isSelected)
	end

	f.sidebarScroll:ClearAllPoints()
	f.sidebarScroll:Point("TOPLEFT", 4, -18 - (#f.viewModeRows + 1) * VIEW_MODE_ROW_HEIGHT - 10)
	f.sidebarScroll:Point("BOTTOMRIGHT", -SIDEBAR_SCROLLBAR_INSET, 4)
	f.sidebarChild:Width(GetSidebarChildWidth(sidebarWidth))

	f.pinnedRow.text:SetShown(not db.sidebarCollapsed)
	f.pinnedRow.count:SetShown(not db.sidebarCollapsed)
	SetCategoryIcon(f.pinnedRow.icon, module.PinnedCategory)

	module.PositionCollapseButton(f, db.sidebarCollapsed)

	local collapseArrowRotation = S.ArrowRotation and S.ArrowRotation[db.sidebarCollapsed and "right" or "left"]
	if collapseArrowRotation then
		for _, tex in ipairs({ f.collapseButton:GetNormalTexture(), f.collapseButton:GetPushedTexture() }) do
			if tex then
				tex:SetRotation(collapseArrowRotation)
			end
		end
	end

	f.sidebarHeaderText:SetShown(not db.sidebarCollapsed)

	RenderCategorySections({
		contentChild = module.contentChild,
		sidebarChild = module.sidebarChild,
		pools = bagPools,
		pinnedRow = f.pinnedRow,
		offsets = module.categoryOffsets,
		width = db.width,
		sidebarWidth = sidebarWidth,
		emptyText = f.emptyText,
		refresh = function()
			module:RefreshCategoryFrame()
		end,
	}, sections)

	ApplyAutoHeight(f, module.contentChild, module.sidebarChild, db.height)

	f.titleText:SetText(L["Inventory"])
	SetTitleCount(f.titleCountText, usedSlots, totalSlots, CountSearchHits(BAG_IDS))
	SetFillBar(f, usedSlots, totalSlots)

	module:UpdateFooter()
end

-------------------------------------------------------------------------------
--  Add / rename / delete categories
-------------------------------------------------------------------------------
-- Only ever add our own keys to StaticPopupDialogs below; never assign the
-- global itself (even as `x = x or {}`) - writing the global from insecure code
-- taints it for every Blizzard popup, breaking protected calls in their
-- OnAccept handlers (e.g. UpgradeItem in the item upgrade confirmation).

-- Lets a plain spell/item/currency/achievement ID resolve to that thing's
-- icon (same lookup order as Modules/Misc/IconSearch.lua), so users can set a
-- category icon without knowing a raw texture fileID; anything else is taken
-- as a literal texture path/fileID.
local function ResolveIconInput(input)
	if not input or input == "" then
		return nil
	end

	local id = tonumber(input)
	if not id then
		return input
	end

	local spell = C_Spell.GetSpellTexture(id)
	if spell then
		return spell
	end

	local item = C_Item.GetItemIconByID(id)
	if item then
		return item
	end

	local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(id)
	if currencyInfo and currencyInfo.iconFileID then
		return currencyInfo.iconFileID
	end

	local achievementIcon = select(10, GetAchievementInfo(id))
	if achievementIcon then
		return achievementIcon
	end

	return id
end

_G.StaticPopupDialogs["MER_BAGCATEGORIES_ICON"] = {
	text = L["Enter a spell/item/currency ID, or a texture path/ID, for the category icon:"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = true,
	maxLetters = 256,
	OnShow = function(self, data)
		if data and data.key then
			local cat = module:FindCategory(data.key)
			if cat and self.EditBox then
				self.EditBox:SetText(tostring(cat.icon or ""))
			end
		end
	end,
	OnAccept = function(self, data)
		if data and data.key and self.EditBox then
			local icon = ResolveIconInput(self.EditBox:GetText())
			if icon then
				module:SetUserCategoryIcon(data.key, icon)
				module:RefreshCategoryFrame()
			end
		end
	end,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent()
		if parent.data and parent.data.key then
			local icon = ResolveIconInput(parent.EditBox:GetText())
			if icon then
				module:SetUserCategoryIcon(parent.data.key, icon)
				module:RefreshCategoryFrame()
			end
		end
		parent:Hide()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

_G.StaticPopupDialogs["MER_BAGCATEGORIES_RENAME"] = {
	text = L["Enter a new name:"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = true,
	maxLetters = 30,
	OnShow = function(self, data)
		if data and data.key and self.EditBox then
			local group = module:FindCategoryGroup(data.key)
			if group then
				self.EditBox:SetText(module:GetGroupName(group))
			else
				local cat = module:FindCategory(data.key)
				if cat then
					self.EditBox:SetText(cat.name)
				end
			end
		end
	end,
	OnAccept = function(self, data)
		if data and data.key then
			local newName = self.EditBox and self.EditBox:GetText()
			if module:FindCategoryGroup(data.key) then
				module:RenameGroup(data.key, newName)
			else
				module:RenameCategory(data.key, newName)
			end
			module:RefreshCategoryFrame()
		end
	end,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent()
		if parent.data and parent.data.key then
			local newName = parent.EditBox:GetText()
			if module:FindCategoryGroup(parent.data.key) then
				module:RenameGroup(parent.data.key, newName)
			else
				module:RenameCategory(parent.data.key, newName)
			end
			module:RefreshCategoryFrame()
		end
		parent:Hide()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

_G.StaticPopupDialogs["MER_BAGCATEGORIES_PURCHASE_BANK_TAB"] = {
	text = "%s",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(_, data)
		if data and data.bankType and BankAPI.PurchaseTab then
			BankAPI.PurchaseTab(data.bankType)
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	showAlert = true,
}

-- A modest, curated palette of long-stable, generic item-style icons for the
-- Add Category grid (not a full icon browser); the custom ID input below the
-- grid covers anything not in this set, via the same ResolveIconInput lookup
-- used for "Change Icon".
local ADD_CATEGORY_ICON_GRID = {
	[[Interface\Icons\INV_Sword_04]],
	[[Interface\Icons\INV_Axe_01]],
	[[Interface\Icons\INV_Shield_04]],
	[[Interface\Icons\INV_Chest_Cloth_17]],
	[[Interface\Icons\INV_Potion_54]],
	[[Interface\Icons\INV_Misc_Gem_01]],
	[[Interface\Icons\INV_Misc_Bag_08]],
	[[Interface\Icons\INV_Scroll_03]],
	[[Interface\Icons\INV_Misc_Book_09]],
	[[Interface\Icons\INV_Misc_Coin_02]],
	[[Interface\Icons\INV_Misc_Key_03]],
	[[Interface\Icons\INV_Misc_Food_15]],
}

function module:UpdateAddCategoryIconSelection()
	local f = module.addCategoryFrame
	if not f then
		return
	end

	for _, btn in ipairs(f.iconButtons) do
		if btn.icon == f.selectedIcon then
			btn:SetBackdropBorderColor(1, 0.82, 0)
		else
			pcall(btn.SetBackdropBorderColor, btn, unpack(E.media.bordercolor))
		end
	end
end

function module:SubmitAddCategoryFrame()
	local f = module.addCategoryFrame
	if not f then
		return
	end

	local name = f.nameBox:GetText()
	if not name or name == "" then
		return
	end

	local icon = f.selectedIcon
	local customInput = f.customIconBox:GetText()
	if customInput and customInput ~= "" then
		icon = ResolveIconInput(customInput)
	end

	local key = module:AddUserCategory(name)
	if key and icon then
		module:SetUserCategoryIcon(key, icon)
	end

	module:RefreshCategoryFrame()
	f:Hide()
end

function module:ConstructAddCategoryFrame()
	if module.addCategoryFrame then
		return module.addCategoryFrame
	end

	local buttonSize, spacing, columns = 30, 4, 6
	local gridRows = ceil(#ADD_CATEGORY_ICON_GRID / columns)
	local gridHeight = gridRows * (buttonSize + spacing) - spacing

	local f = CreateFrame("Frame", "MER_BagCategoriesAddFrame", E.UIParent)
	f:Size(260, 254 + gridHeight)
	f:SetFrameStrata("DIALOG")
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f.customBackdropAlpha = 0.85
	pcall(f.SetTemplate, f)
	WS:CreateShadow(f)
	f:Hide()

	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)

	f.title = f:CreateFontString(nil, "OVERLAY")
	f.title:FontTemplate(nil, 14)
	f.title:Point("TOP", 0, -10)
	f.title:SetText(L["New Custom Category"])

	f.closeButton = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	f.closeButton:Point("TOPRIGHT", 2, 2)
	f.closeButton:SetScript("OnClick", function()
		f:Hide()
	end)
	pcall(S.HandleCloseButton, S, f.closeButton)

	f.nameBox = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
	f.nameBox:Size(220, 20)
	f.nameBox:Point("TOP", 0, -36)
	f.nameBox:SetAutoFocus(false)
	f.nameBox:SetMaxLetters(30)
	f.nameBox:SetScript("OnEnterPressed", function()
		module:SubmitAddCategoryFrame()
	end)
	pcall(S.HandleEditBox, S, f.nameBox)

	f.iconLabel = f:CreateFontString(nil, "OVERLAY")
	f.iconLabel:FontTemplate()
	f.iconLabel:Point("TOPLEFT", f.nameBox, "BOTTOMLEFT", 0, -14)
	f.iconLabel:SetText(L["Icon:"])

	f.iconButtons = {}
	for i, icon in ipairs(ADD_CATEGORY_ICON_GRID) do
		local btn = CreateFrame("Button", nil, f)
		btn:Size(buttonSize, buttonSize)
		pcall(btn.SetTemplate, btn)

		btn.tex = btn:CreateTexture(nil, "ARTWORK")
		btn.tex:SetInside()
		btn.tex:SetTexture(icon)
		btn.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		btn.icon = icon

		btn:SetScript("OnClick", function()
			f.selectedIcon = icon
			f.customIconBox:SetText("")
			module:UpdateAddCategoryIconSelection()
		end)

		local col = (i - 1) % columns
		local row = floor((i - 1) / columns)
		btn:Point(
			"TOPLEFT",
			f.iconLabel,
			"BOTTOMLEFT",
			col * (buttonSize + spacing),
			-6 - row * (buttonSize + spacing)
		)

		f.iconButtons[i] = btn
	end

	f.customIconLabel = f:CreateFontString(nil, "OVERLAY")
	f.customIconLabel:FontTemplate()
	f.customIconLabel:Point("TOPLEFT", f.iconLabel, "BOTTOMLEFT", 0, -10 - gridHeight)
	f.customIconLabel:SetText(L["Custom Icon ID:"])

	f.customIconBox = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
	f.customIconBox:Size(150, 20)
	f.customIconBox:Point("TOPLEFT", f.customIconLabel, "BOTTOMLEFT", 4, -4)
	f.customIconBox:SetAutoFocus(false)
	f.customIconBox:SetMaxLetters(256)
	f.customIconBox:SetScript("OnEnterPressed", function()
		module:SubmitAddCategoryFrame()
	end)
	pcall(S.HandleEditBox, S, f.customIconBox)

	f.createButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.createButton:Size(100, 22)
	f.createButton:Point("BOTTOM", 0, 12)
	f.createButton:SetText(L["Create"] or _G.ACCEPT)
	f.createButton:SetScript("OnClick", function()
		module:SubmitAddCategoryFrame()
	end)
	pcall(S.HandleButton, S, f.createButton)

	module.addCategoryFrame = f
	return f
end

function module:PromptAddCategory()
	local f = module:ConstructAddCategoryFrame()
	f:ClearAllPoints()
	if module.frame and module.frame:IsShown() then
		f:Point("CENTER", module.frame, "CENTER", 0, 0)
	else
		f:Point("CENTER")
	end
	f.nameBox:SetText("")
	f.customIconBox:SetText("")
	f.selectedIcon = nil
	module:UpdateAddCategoryIconSelection()
	f:Show()
	f.nameBox:SetFocus()
end

-- "Create Group With" / "Add to Group": offered on every category that is
-- not in a group yet. Creating one needs a partner category that is free
-- too, adding one needs an existing group - each submenu is skipped when
-- there is nothing to put in it.
local function AddGroupingSubmenus(rootDescription, key)
	-- The reagent bag mirrors a physical container rather than a rule-based
	-- category, so it stays out of groups on both ends.
	local ownCat = module:FindCategory(key)
	if ownCat and ownCat.isReagentBag then
		return
	end

	local freeCategories = {}
	for _, cat in ipairs(module:GetCategories()) do
		if cat.key ~= key and not cat.isReagentBag and not module:GetCategoryGroupForKey(cat.key) then
			tinsert(freeCategories, cat)
		end
	end

	if #freeCategories > 0 then
		local createSub = rootDescription:CreateButton(L["Create Group With"])
		for _, cat in ipairs(freeCategories) do
			createSub:CreateButton(cat.name, function()
				module:CreateCategoryGroup(key, cat.key)
				module:InvalidateCategoryCache()
				module:RefreshCategoryFrame()
			end)
		end
	end

	local groups = module:GetCategoryGroups()
	if #groups > 0 then
		local addSub = rootDescription:CreateButton(L["Add to Group"])
		for _, group in ipairs(groups) do
			addSub:CreateButton(module:GetGroupName(group), function()
				module:AddCategoryToGroup(key, group.key)
				module:InvalidateCategoryCache()
				module:RefreshCategoryFrame()
			end)
		end
	end
end

function module:OpenCategoryContextMenu(row)
	if not _G.MenuUtil or not _G.MenuUtil.CreateContextMenu then
		return
	end

	local key = row.catKey

	-- Group-member row: the row's own catKey points at the *group's* merged
	-- content section (for scrolling), but Rename/Ungroup act on the actual
	-- member category, so use memberKey instead wherever this differs.
	if row.isGroupMember then
		local memberKey = row.memberKey
		local memberCat = module:FindCategory(memberKey)

		_G.MenuUtil.CreateContextMenu(row, function(_, rootDescription)
			rootDescription:CreateButton(L["Rename"], function()
				StaticPopup_Show("MER_BAGCATEGORIES_RENAME", nil, nil, { key = memberKey })
			end)

			rootDescription:CreateButton(format(L["Ungroup %s"], memberCat and memberCat.name or memberKey), function()
				module:UngroupCategory(memberKey)
				module:InvalidateCategoryCache()
				module:RefreshCategoryFrame()
			end)
		end)

		return
	end

	if row.isGroup then
		local group = module:FindCategoryGroup(key)
		if not group then
			return
		end

		_G.MenuUtil.CreateContextMenu(row, function(_, rootDescription)
			rootDescription:CreateButton(L["Rename"], function()
				StaticPopup_Show("MER_BAGCATEGORIES_RENAME", nil, nil, { key = key })
			end)

			rootDescription:CreateButton(L["Disband Group"], function()
				module:DisbandGroup(key)
				module:InvalidateCategoryCache()
				module:RefreshCategoryFrame()
			end)

			if module:GetItemOrder(key) then
				rootDescription:CreateButton(L["Reset Item Order"], function()
					module:ClearItemOrder(key)
					module:RefreshCategoryFrame()
				end)
			end

			rootDescription:CreateButton(
				module:IsHiddenFromAllItems(key) and L["Show in All Items"] or L["Hide in All Items"],
				function()
					module:SetHiddenFromAllItems(key, not module:IsHiddenFromAllItems(key))
					module:RefreshCategoryFrame()
				end
			)
		end)

		return
	end

	if row.isUser then
		_G.MenuUtil.CreateContextMenu(row, function(_, rootDescription)
			rootDescription:CreateButton(L["Rename"], function()
				StaticPopup_Show("MER_BAGCATEGORIES_RENAME", nil, nil, { key = key })
			end)

			rootDescription:CreateButton(L["Change Icon"], function()
				StaticPopup_Show("MER_BAGCATEGORIES_ICON", nil, nil, { key = key })
			end)

			rootDescription:CreateButton(L["Delete"], function()
				module:RemoveUserCategory(key)
				module:RefreshCategoryFrame()
			end)

			if module:GetItemOrder(key) then
				rootDescription:CreateButton(L["Reset Item Order"], function()
					module:ClearItemOrder(key)
					module:RefreshCategoryFrame()
				end)
			end

			AddGroupingSubmenus(rootDescription, key)
		end)

		return
	end

	-- A default (built-in) category: no Change Icon/Delete (nothing to
	-- delete, and default categories don't support a custom icon the way
	-- user categories do), but Rename/Hide-in-All-Items are exactly as
	-- meaningful here as they already are for a group - both are stored
	-- generically by category key, not specially for groups.
	local db = module.db
	_G.MenuUtil.CreateContextMenu(row, function(_, rootDescription)
		rootDescription:CreateButton(L["Rename"], function()
			StaticPopup_Show("MER_BAGCATEGORIES_RENAME", nil, nil, { key = key })
		end)

		if db.categoryNameOverrides and db.categoryNameOverrides[key] then
			rootDescription:CreateButton(L["Reset Name"], function()
				module:ResetCategoryName(key)
				module:RefreshCategoryFrame()
			end)
		end

		if module:GetItemOrder(key) then
			rootDescription:CreateButton(L["Reset Item Order"], function()
				module:ClearItemOrder(key)
				module:RefreshCategoryFrame()
			end)
		end

		AddGroupingSubmenus(rootDescription, key)

		rootDescription:CreateButton(
			module:IsHiddenFromAllItems(key) and L["Show in All Items"] or L["Hide in All Items"],
			function()
				module:SetHiddenFromAllItems(key, not module:IsHiddenFromAllItems(key))
				module:RefreshCategoryFrame()
			end
		)
	end)
end

function module:OpenAssignMenu(slot)
	if not _G.MenuUtil or not _G.MenuUtil.CreateContextMenu then
		return
	end
	if not slot.itemID then
		return
	end

	local itemID = slot.itemID
	local ownerFrame = slot.ownerFrame
	_G.MenuUtil.CreateContextMenu(slot, function(_, rootDescription)
		rootDescription:CreateTitle(L["Assign to Category"])
		-- The bank groups by tab, not by category, so an assignment made
		-- here only shows once the item is back in the bags.
		if ownerFrame and ownerFrame == module.bankFrame then
			rootDescription:CreateTitle("|cff999999" .. L["Takes effect once the item is in your bags."] .. "|r")
		end

		for _, cat in ipairs(module:GetCategories()) do
			if not cat.isReagentBag then
				rootDescription:CreateButton(cat.name, function()
					module:AssignItemToCategory(itemID, cat.key)
					RefreshOwnerFrame(ownerFrame)
				end)
			end
		end

		local db = module.db
		if db.itemAssignments and db.itemAssignments[itemID] then
			rootDescription:CreateButton(L["Clear Assignment"], function()
				module:ClearItemAssignment(itemID)
				RefreshOwnerFrame(ownerFrame)
			end)
		end
	end)
end

-------------------------------------------------------------------------------
--  Move to Bank Tab / Move to Bag (Ctrl+Right-click while the bank is open)
-------------------------------------------------------------------------------
local function FindFreeSlot(bagID)
	local numSlots = C_Container_GetContainerNumSlots(bagID)
	for slotID = 1, numSlots do
		if not C_Container_GetContainerItemInfo(bagID, slotID) then
			return slotID
		end
	end
	return nil
end

-- Drops whatever is on the cursor into a free slot of the same container
-- group the item came from: the source bag first, then the other bags (or
-- bank tabs of the same bank). Leaves the cursor alone if everything's full.
function module:PlaceCursorItemNear(bagID)
	if not CursorHasItem() then
		return
	end

	local group = BAG_IDS
	if module.BankBagIDSet and module.BankBagIDSet[bagID] then
		group = module.BankBagIDs
	elseif module.WarbandBagIDSet and module.WarbandBagIDSet[bagID] then
		group = module.WarbandBagIDs
	end

	local order = { bagID }
	for _, id in ipairs(group) do
		if id ~= bagID then
			tinsert(order, id)
		end
	end

	for _, id in ipairs(order) do
		local freeSlot = FindFreeSlot(id)
		if freeSlot then
			C_Container_PickupContainerItem(id, freeSlot)
			return
		end
	end
end

local function MoveItemToBag(sourceBagID, sourceSlotID, destBagID)
	if InCombatLockdown() or CursorHasItem() then
		return
	end

	-- Check for a free slot BEFORE touching the cursor - if the destination
	-- is full we want to bail out cleanly instead of leaving the item stuck
	-- on the cursor with nowhere for it to go back to.
	local freeSlot = FindFreeSlot(destBagID)
	if not freeSlot then
		_G.UIErrorsFrame:AddMessage(L["No free slot available."], 1, 0.1, 0.1)
		return
	end

	C_Container_PickupContainerItem(sourceBagID, sourceSlotID)
	C_Container_PickupContainerItem(destBagID, freeSlot)
end

function module:OpenMoveMenu(slot)
	if not _G.MenuUtil or not _G.MenuUtil.CreateContextMenu then
		return
	end
	if not slot.BagID or not slot.SlotID then
		return
	end

	local sourceBagID, sourceSlotID = slot.BagID, slot.SlotID
	local movingFromBank = module.BankBagIDSet[sourceBagID] or module.WarbandBagIDSet[sourceBagID]

	_G.MenuUtil.CreateContextMenu(slot, function(_, rootDescription)
		local function AddTargets(title, bagIDList)
			local titleAdded = false
			for _, bagID in ipairs(bagIDList) do
				-- Skip the slot's own bag and any tab/bag with zero slots (an
				-- unpurchased bank tab, or an inventory bag slot with no bag
				-- equipped in it).
				if bagID ~= sourceBagID and C_Container_GetContainerNumSlots(bagID) > 0 then
					if not titleAdded then
						rootDescription:CreateTitle(title)
						titleAdded = true
					end

					rootDescription:CreateButton(GetBagDisplayName(bagID), function()
						MoveItemToBag(sourceBagID, sourceSlotID, bagID)
						module:RefreshCategoryFrame()
						module:RefreshBagBarPopout()
					end)
				end
			end
		end

		if movingFromBank then
			AddTargets(L["Move to Bag"], BAG_IDS)
		else
			AddTargets(L["Move to Bank Tab"], module.BankBagIDs)
			AddTargets(L["Move to Warband Tab"], module.WarbandBagIDs)
		end
	end)
end

-------------------------------------------------------------------------------
--  Show / hide / toggle + bag toggle hooks
-------------------------------------------------------------------------------
-- Our slot buttons are SecureActionButtonTemplate (needed for right-click
-- "use" without ADDON_ACTION_FORBIDDEN, see UpdateSlotVisual), which makes
-- Show()/Hide() on any frame containing them combat-protected too - calling
-- either from insecure code throws ADDON_ACTION_BLOCKED. Guarded here so
-- every caller (hooks, the close button, the mover) is covered; whatever
-- shown/hidden state we're in when combat starts just stays frozen.
-- Shared by both top-level frames (bag + bank). Fade-in runs from OnShow; the
-- fade-out has to defer the real Hide() until the fade finishes, so every
-- hide path goes through FadeOutHide instead of calling :Hide() directly.
function module:FadeInFrame(f)
	local fx = module.db.effects
	local startAlpha = f.fadingOut and f:GetAlpha() or 0

	-- A fade-out cut short by a re-open must not fire its stale Hide callback
	-- when the new fade-in finishes.
	f.fadingOut = nil
	if f.FadeObject then
		f.FadeObject.finishedFunc = nil
	end

	if fx.fade then
		E:UIFrameFadeIn(f, fx.fadeDuration, startAlpha, 1)
	else
		E:UIFrameFadeRemoveFrame(f)
		f:SetAlpha(1)
	end
end

function module:FadeOutHide(f)
	local fx = module.db.effects
	if not fx.fade then
		f:Hide()
		return
	end

	if f.fadingOut then
		return
	end

	f.fadingOut = true
	E:UIFrameFadeOut(f, fx.fadeDuration, f:GetAlpha(), 0)
	f.FadeObject.finishedFunc = function()
		f.fadingOut = nil
		-- Hide() on these frames is combat-protected (secure slot buttons), so
		-- if combat started mid-fade just restore the frame instead.
		if InCombatLockdown() then
			f:SetAlpha(1)
			return
		end
		f:Hide()
	end
end

-- Optional override of ElvUI's shared "Transparent" backdrop alpha for the
-- window panels (frame, title bar, sidebar) - customBackdropAlpha is honored
-- by both SetTemplate and ElvUI's media-update sweep, so it sticks.
function module:ApplyBackgroundOpacity()
	local fx = module.db.effects
	local fadeColor = E.media.backdropfadecolor
	local alpha = fx.customBackground and fx.backgroundAlpha or nil

	for _, f in ipairs({ module.frame or false, module.bankFrame or false }) do
		if f then
			for _, panel in ipairs({ f, f.titleBar, f.sidebar }) do
				if panel and panel.SetBackdropColor then
					panel.customBackdropAlpha = alpha
					panel:SetBackdropColor(fadeColor[1], fadeColor[2], fadeColor[3], alpha or fadeColor[4])
				end
			end
		end
	end
end

function module:ShowCategoryFrame()
	if InCombatLockdown() then
		return
	end

	module:ConstructFrame()
	module:ApplyBackgroundOpacity()
	HideElvUIBagFrame()

	module.frame:Show()
	if module.frame.fadingOut then
		module:FadeInFrame(module.frame)
	end
	module:RegisterBagEventsFor("bag")
	module:RefreshCategoryFrame()
	PlaySound(SOUNDKIT.IG_BACKPACK_OPEN or 862)
end

function module:HideCategoryFrame()
	if InCombatLockdown() then
		return
	end

	if module.frame and module.frame:IsShown() then
		module:FadeOutHide(module.frame)
	end
end

function module:OnFrameHidden()
	module:UnregisterBagEventsFor("bag")

	wipe(module.unmergedLinks)

	if module.db.clearRecentOnClose then
		module:ClearRecentItems()

		-- The Bank window lists Recent Items too and can outlive the bag
		-- window (closing the bags doesn't close it).
		if module.bankFrame and module.bankFrame:IsShown() then
			module:RefreshBankCategoryFrame()
		end
	end

	-- The native item-search filter is shared, global Blizzard state (see
	-- module.searchText) - only clear it once neither of our frames still
	-- wants it, so closing the bag frame doesn't wipe a search the still-open
	-- Bank frame is using.
	if not (module.bankFrame and module.bankFrame:IsShown()) then
		C_Container_SetItemSearch("")
	end

	if module.addCategoryFrame and module.addCategoryFrame:IsShown() then
		module.addCategoryFrame:Hide()
	end

	if module.bagBarPopout and module.bagBarPopout:IsShown() then
		module.bagBarPopout:Hide()
	end

	for i = 1, NUM_BAG_FRAMES or 4 do
		CloseBag(i)
	end
	CloseBackpack()

	if module.frame.NewItemGlow then
		module.frame.NewItemGlow:Stop()
	end

	-- Clear any pending "the bank opened this bag frame automatically" state
	-- on every hide path (manual close button, /reload, etc.) so a later,
	-- unrelated bank open/close never misfires an auto-close of a bag frame
	-- the user has since reopened themselves.
	module.frame_openedByBank = nil

	PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE or 863)
end

-- Every ElvUI bag-opening path - the plain keybind (ToggleBackpack/
-- ToggleAllBags/ToggleBag), the mail/vendor auto-open (OpenAllBags(frame)),
-- its "Auto Toggle" option (auction house/trade/professions/soulbind forge,
-- B:AutoToggleFunction) and its guild bank auto-open (B:GuildBankShow) - all
-- funnel through B:OpenBags()/B:CloseAllBags() to actually show/hide
-- B.BagFrame (see ElvUI's Bags.lua). Hooking those two directly, instead of
-- every individual entry point above them, covers all of those contexts from
-- one place with no risk of firing twice for the same user action.
--
-- (Two earlier attempts got this wrong: hooking the native global
-- ToggleAllBags/ToggleBackpack/OpenAllBags/CloseAllBags in addition to
-- B:OpenBags()/B:CloseAllBags() double-fired on a plain keybind press - the
-- native hook and the nested B:OpenBags() call it triggers both ran - and
-- toggled our frame shut again right after opening it. Hooking
-- B:AutoToggleFunction directly instead didn't fire at all: AceEvent
-- captures that function by value when registering its triggering events,
-- before our hook wraps it, so the wrapped version is never what actually
-- gets called.)
function module:OnElvUIBagsOpened()
	if InCombatLockdown() then
		return
	end

	HideElvUIBagFrame()
	module:ShowCategoryFrame()
end

function module:OnElvUIBagsClosed()
	if InCombatLockdown() then
		return
	end

	module:HideCategoryFrame()
end

-- Mirrors ToggleAllBags/OpenAllBags for the bank: BANKFRAME_OPENED/CLOSED are
-- still the correct events for the current retail bank (confirmed against
-- ElvUI's own Bags.lua) even though the bank itself is now tab-based rather
-- than a single container. The Bank/Warband frame is a fully separate window
-- (BankFrame.lua) now, so this only ever shows/hides module.bankFrame - the
-- bag frame is a related but independent concern (see the auto-open note
-- below).
function module:OnBankOpened()
	if InCombatLockdown() or (#module.BankBagIDs == 0 and #module.WarbandBagIDs == 0) then
		return
	end

	module.isBankOpen = true
	HideElvUIBankFrame()

	-- Mirrors ElvUI's own OpenBank landing logic - the Warband Bank Distance
	-- Inhibitor grants remote Warband access without personal bank access at
	-- that spot, so land on whichever bank the player can actually view.
	local canViewCharacter = not BankAPI.CanView or BankAPI.CanView(CHARACTER_BANK_TYPE)
	module.bankViewMode = (not canViewCharacter and #module.WarbandBagIDs > 0) and "WARBAND_ALL" or "BANK_ALL"

	module:ShowBankFrame()

	-- Opening the bank also shows the bag frame, if it isn't already up (so
	-- items can be dragged between the two) - but only auto-close it again
	-- later if it was actually us that opened it (module.frame_openedByBank,
	-- cleared on every bag-frame hide path in OnFrameHidden), so a bag frame
	-- the player already had open manually is left alone either way.
	if not InCombatLockdown() and not (module.frame and module.frame:IsShown() and not module.frame.fadingOut) then
		module.frame_openedByBank = true
		module:ShowCategoryFrame()
	end
end

function module:OnBankClosed()
	module.isBankOpen = false
	module.bankTabFilter = nil

	if B.BankFrame then
		B.BankFrame:SetAlpha(1)
		B.BankFrame:EnableMouse(true)
	end

	if not InCombatLockdown() then
		module:HideBankFrame()

		if module.frame_openedByBank then
			module:HideCategoryFrame()
		end
	end
end

-- Fires when a bank tab's name/icon/deposit rules are changed via the edit
-- panel (B:BankTabs_ShowSettings) - refresh the Bank frame's own sidebar tab
-- rows so the new icon/name show up immediately instead of only after
-- closing and reopening the bank.
function module:OnBankTabsChanged()
	if module.RefreshBankCategoryFrame then
		module:RefreshBankCategoryFrame()
	end
end

-- Sort/Stack call Blizzard's native SortBags() (see ConstructFrame), which
-- has no "finished" signal of its own - just a burst of BAG_UPDATE/
-- BAG_UPDATE_DELAYED events as items settle. Generation counter debounce:
-- every refresh received while sortingBags is set reschedules the stop:
-- StopSortSpinner only actually stops it once 0.4s pass with no further
-- refresh, so the spinner spans the whole burst instead of blinking off
-- after the first event in it.
local sortSpinnerGeneration = 0

local function StopSortSpinner(generation)
	if generation ~= sortSpinnerGeneration then
		return
	end

	module.sortingBags = nil
	RefreshSlotDim()

	local frame = module.sortingFrame or module.frame
	module.sortingFrame = nil
	if frame and frame.spinnerIcon then
		E:StopSpinner(frame.spinnerIcon)
	end
end

function module:PokeSortSpinner()
	sortSpinnerGeneration = sortSpinnerGeneration + 1
	E:Delay(0.4, StopSortSpinner, sortSpinnerGeneration)
end

-- Items are dimmed while sorting even with the spinner itself turned off,
-- same as ElvUI's own bags.
-- Stacking goes through ElvUI's own sorter (Sort.lua) instead of a second
-- copy of it: B.Compress merges partial stacks in place, B.Stack moves
-- partial stacks from one side into matching stacks on the other. Its bag
-- groups only know the backpack + four bags ("bags") and the character bank
-- tabs ("bank") - no reagent bag, no Warband bank - so the Warband view has
-- no stacking of its own.
-- fromBank: stack the character bank (true) or the bags (false). Holding
-- Shift while the bank is open moves partial stacks to the other side.
function module:StackItems(frame, fromBank)
	if not (B.CommandDecorator and B.Stack and B.Compress) then
		return
	end

	local toOtherSide = IsShiftKeyDown() and module.isBankOpen
	local command
	if fromBank then
		command = toOtherSide and B:CommandDecorator(B.Stack, "bank bags") or B:CommandDecorator(B.Compress, "bank")
	else
		command = toOtherSide and B:CommandDecorator(B.Stack, "bags bank") or B:CommandDecorator(B.Compress, "bags")
	end

	module:StartSortSpinner(frame)
	command()
end

-- frame: the window being sorted (the bag frame when omitted; the Bank
-- window passes itself), which gets the spinner and the dimmed slots.
function module:StartSortSpinner(frame)
	frame = frame or module.frame
	if not frame then
		return
	end

	module.sortingBags = true
	module.sortingFrame = frame
	RefreshSlotDim()

	local db = module.db.spinner
	if db and db.enable and frame.spinnerIcon then
		-- Item slots sit several levels below the frame (scroll frame ->
		-- content child -> slot, plus badges on top), so a plain child of the
		-- frame ends up behind them. Set per start, since the frame's own
		-- level moves when it's raised.
		local spinner = frame.spinnerIcon
		spinner:SetFrameLevel(frame:GetFrameLevel() + 30)
		E:StartSpinner(spinner, nil, nil, nil, nil, db.size, db.color.r, db.color.g, db.color.b)
	end

	module:PokeSortSpinner()
end

local eventFrame = CreateFrame("Frame")
local BAG_REFRESH_EVENTS = { "BAG_UPDATE", "BAG_UPDATE_DELAYED", "ITEM_LOCK_CHANGED", "EQUIPMENT_SETS_CHANGED" }

-- RefreshCategoryFrame()/RefreshBankCategoryFrame() are full rebuilds (every
-- item re-classified into its category, every pooled header/sub-header/slot/
-- sidebar-row re-laid-out) - fine at the cost of one of those per discrete
-- pickup/drop, but ITEM_LOCK_CHANGED and BAG_UPDATE both fire once per slot
-- touched, not once per user action. A native SortBags() on a fuller
-- inventory moves dozens of slots, so this handler used to run a full
-- rebuild for each one of those, back to back, in the same burst of events -
-- reported as the whole game freezing for several seconds after clicking
-- Sort. Throttled to at most one rebuild per 0.15s (imperceptible for the
-- single-item case, but collapses a same-frame burst of N events into 1
-- rebuild instead of N) via a pending-flag + E:Delay, the same debounce
-- technique StartSortSpinner/PokeSortSpinner already use above.
local refreshPending = false

-- Bag and Bank/Warband are two independent frames that can both be open at
-- once (see OnBankOpened's auto-open), each refreshed off the same handful
-- of events - route to whichever ones are actually shown right now instead
-- of assuming there's only ever one.
local function DoThrottledRefresh()
	refreshPending = false

	if module.frame and module.frame:IsShown() then
		module:RefreshCategoryFrame()
	end

	if module.bankFrame and module.bankFrame:IsShown() and module.RefreshBankCategoryFrame then
		module:RefreshBankCategoryFrame()
	end
end

eventFrame:SetScript("OnEvent", function()
	if module.sortingBags then
		module:PokeSortSpinner()
	end

	if not refreshPending then
		refreshPending = true
		E:Delay(0.15, DoThrottledRefresh)
	end
end)

-- `owner` is "bag" or "bank" - a plain RegisterEvent/UnregisterAllEvents per
-- frame would have one frame's close kill live refresh for the other, still-
-- open one, since they'd share this single event frame. RegisterEvent itself
-- is idempotent (safe to call again while already registered), so only the
-- unregister side actually needs the reference count.
local bagEventOwners = {}

function module:RegisterBagEventsFor(owner)
	bagEventOwners[owner] = true
	for _, event in ipairs(BAG_REFRESH_EVENTS) do
		eventFrame:RegisterEvent(event)
	end
end

function module:UnregisterBagEventsFor(owner)
	bagEventOwners[owner] = nil
	if not next(bagEventOwners) then
		eventFrame:UnregisterAllEvents()
	end
end

-- CURSOR_CHANGED also fires for plain cursor-icon changes while hovering, so
-- only touch the placeholders when "an item is on the cursor" actually flips.
-- Same two events Blizzard itself drives its bag dimming from (EventRouting:
-- CURRENT_SPELL_CAST_CHANGED / UPDATE_SPELL_TARGET_ITEM_CONTEXT).
-- CURRENT_SPELL_CAST_CHANGED fires on every cast, so bail out early unless
-- the context actually changed or one of our windows is showing it.
-- Which of our known spells owns the targeting cursor: C_Spell.IsCurrentSpell
-- is true while a spell is "being cast or queued to be cast", which includes
-- waiting for its item target - the same check Blizzard's spell flyouts use
-- to highlight a pending spell. (Hooking UseAction doesn't work for this:
-- action bar presses are handled by the client without calling it.)
local function GetPendingTargetSpellCheck()
	for spellID, check in pairs(TargetSpellChecks) do
		if C_Spell.IsCurrentSpell(spellID) then
			return check, spellID
		end
	end
end

function module.EvaluateItemContext()
	local blizzardContext = _G.ItemButtonUtil and _G.ItemButtonUtil.GetItemContext() ~= nil or false

	local spellCheck
	if not blizzardContext and SpellIsTargeting() and SpellCanTargetItem() then
		spellCheck = GetPendingTargetSpellCheck()
	end

	local active = blizzardContext or spellCheck ~= nil

	if active == module.itemContextActive and spellCheck == module.targetSpellCheck and not active then
		return
	end

	module.itemContextActive = active
	module.targetSpellCheck = spellCheck

	local bagsShown = module.frame and module.frame:IsShown()
	local bankShown = module.bankFrame and module.bankFrame:IsShown()
	if bagsShown or bankShown then
		RefreshSlotDim()
	end
end

-- Deferred a frame: SpellIsTargeting() isn't reliably up to date yet while
-- CURRENT_SPELL_CAST_CHANGED is still being dispatched (the live log showed
-- it reporting false around the targeting cursor).
function module:OnItemContextChanged()
	C_Timer.After(0, module.EvaluateItemContext)
end

function module:OnCursorChanged()
	local hasItem = CursorHasItem() and true or false
	if hasItem == module.cursorHasItem then
		return
	end

	module.cursorHasItem = hasItem
	for _, refresh in ipairs(placeholderPools) do
		refresh()
	end
end

-------------------------------------------------------------------------------
--  Lifecycle
-------------------------------------------------------------------------------
function module:Initialize()
	local db = F.GetDBFromPath("mui.bags.categorizedBags") or E.db.mui.bags.categorizedBags
	module.db = db

	if not db.enable then
		return
	end

	-- One-time cleanup for a profile saved before Bank/Warband got their own
	-- frame: db.viewMode ("CATEGORY"/"ALL"/"BAG" now) could still hold a
	-- leftover "BANK"/"WARBAND" from back when this field also drove the bag
	-- frame's own view - neither is a bag-frame view any more, and leaving
	-- one in place would mean no sidebar row ever shows as selected.
	if db.viewMode == "BANK" or db.viewMode == "WARBAND" then
		db.viewMode = "CATEGORY"
	end

	module.searchText = ""
	module.bankViewMode = module.bankViewMode or "BANK_ALL"

	module:SecureHook(B, "OpenBags", "OnElvUIBagsOpened")
	module:SecureHook(B, "CloseAllBags", "OnElvUIBagsClosed")
	module:SecureHook("GameTooltip_SetDefaultAnchor", "OnGameTooltipDefaultAnchor")
	module:RegisterEvent("CURSOR_CHANGED", "OnCursorChanged")
	module:RegisterEvent("CURRENT_SPELL_CAST_CHANGED", "OnItemContextChanged")
	module:RegisterEvent("UPDATE_SPELL_TARGET_ITEM_CONTEXT", "OnItemContextChanged")

	-- Registered even when duplicate merging is off: the option can be
	-- flipped at any time, and a missed open/close would leave the panel
	-- state wrong until the next one. A renamed/removed event must not take
	-- the whole module down with it, hence the pcall.
	for event in pairs(module.ITEM_PANEL_EVENTS) do
		pcall(module.RegisterEvent, module, event, "OnItemPanelEvent")
	end

	if #module.BankBagIDs > 0 or #module.WarbandBagIDs > 0 then
		module:RegisterEvent("BANKFRAME_OPENED", "OnBankOpened")
		module:RegisterEvent("BANKFRAME_CLOSED", "OnBankClosed")
		module:RegisterEvent("BANK_TABS_CHANGED", "OnBankTabsChanged")
		module:RegisterEvent("BANK_TAB_SETTINGS_UPDATED", "OnBankTabsChanged")
	end
end

function module:ProfileUpdate()
	local db = F.GetDBFromPath("mui.bags.categorizedBags") or E.db.mui.bags.categorizedBags
	module.db = db
	module:InvalidateCategoryCache()

	if module.frame and module.frame:IsShown() then
		module:RefreshCategoryFrame()
	end

	if module.bankFrame and module.bankFrame:IsShown() and module.RefreshBankCategoryFrame then
		module:RefreshBankCategoryFrame()
	end
end

-------------------------------------------------------------------------------
--  Exposed to BankFrame.lua
-------------------------------------------------------------------------------
-- Load_Bags.xml loads each Modules/Bags/*.lua file as its own separate Lua
-- chunk, so file-local `local function`s here aren't visible there - anything
-- BankFrame.lua needs to call has to be published onto the shared `module`
-- table instead (already true of CreatePoolSet/RenderCategorySections/
-- GetBankTabSlotState/BANK_FRAME_NAME above; simple upvalues like
-- CHARACTER_BANK_TYPE or the C_Bank.* functions aren't real logic, so
-- BankFrame.lua just redeclares those itself rather than routing them
-- through here too).
module.CollectItemsByBagFrom = CollectItemsByBagFrom
module.BuildFlatSectionsFrom = BuildFlatSectionsFrom
module.BuildBagSectionsFrom = BuildBagSectionsFrom
module.GetBagIcon = GetBagIcon
module.GetBagDisplayName = GetBagDisplayName
module.ShowPurchaseBankTabPrompt = ShowPurchaseBankTabPrompt
module.SetCategoryIcon = SetCategoryIcon
module.VIEW_MODE_ROW_HEIGHT = VIEW_MODE_ROW_HEIGHT
module.COLLAPSED_SIDEBAR_WIDTH = COLLAPSED_SIDEBAR_WIDTH
module.SkinScrollBar = SkinScrollBar
module.SetTitleCount = SetTitleCount
module.SetFillBar = SetFillBar
module.CreateFillBar = CreateFillBar
module.CountSearchHits = CountSearchHits

MER:RegisterModule(module:GetName())
