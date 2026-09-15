local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories
local B = E:GetModule("Bags")
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")

local _G = _G
local ipairs, pairs = ipairs, pairs
local tinsert, wipe = tinsert, wipe
local tsort = table.sort
local floor, ceil = math.floor, math.ceil
local format = format
local IsShiftKeyDown = IsShiftKeyDown
local IsModifiedClick = IsModifiedClick
local HandleModifiedItemClick = HandleModifiedItemClick
local CursorHasItem = CursorHasItem

local CreateFrame = CreateFrame
local GetMoney = GetMoney

local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_Container_GetContainerItemCooldown = C_Container.GetContainerItemCooldown
local C_Container_GetContainerItemQuestInfo = C_Container.GetContainerItemQuestInfo
local C_Container_SetItemSearch = C_Container.SetItemSearch
local C_Container_PickupContainerItem = C_Container.PickupContainerItem
local C_NewItems_IsNewItem = C_NewItems.IsNewItem
local C_NewItems_RemoveNewItem = C_NewItems.RemoveNewItem
local C_Item_GetItemInfoInstant = C_Item.GetItemInfoInstant
local C_Item_GetDetailedItemLevelInfo = C_Item.GetDetailedItemLevelInfo
local C_Item_GetItemInfo = C_Item.GetItemInfo
local C_CurrencyInfo_GetBackpackCurrencyInfo = C_CurrencyInfo.GetBackpackCurrencyInfo
local MAX_WATCHED_TOKENS = MAX_WATCHED_TOKENS or 3
local C_MerchantFrame_SellAllJunkItems = C_MerchantFrame.SellAllJunkItems
local ITEMQUALITY_POOR = Enum.ItemQuality.Poor

local BAG_IDS = { 0, 1, 2, 3, 4 }
if module.ReagentContainer and module.ReagentContainer < math.huge then
	tinsert(BAG_IDS, module.ReagentContainer)
end

local FRAME_NAME = "MER_BagCategoriesFrame"
local SLOT_NAME_PREFIX = "MER_BagCategoriesSlot"
local HEADER_PADDING = 6
local COLLAPSED_SIDEBAR_WIDTH = 40
local VIEW_MODE_ROW_HEIGHT = 24

-- Same restriction ElvUI's own item level display uses: only equippable gear
-- (Armor covers trinkets/rings/necks too) above Common quality.
local ITEMCLASS_ARMOR = Enum.ItemClass.Armor
local ITEMCLASS_WEAPON = Enum.ItemClass.Weapon
local ITEMQUALITY_COMMON = Enum.ItemQuality.Common

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

local slotPool = {}
local headerPool = {}
local subHeaderPool = {}
local sidebarPool = {}

-- ElvUI's own Container_OnHide -> BagFrameHidden clears every item's "new"
-- flag (NewItemGlowSlotSwitch -> C_NewItems.RemoveNewItem) whenever
-- B.BagFrame hides - which we do on every single open of our own frame, so
-- Recent Items would always come up empty. Snapshot which items are new
-- right before that happens and fall back to it in CollectItems.
local newItemSnapshot = {}

local function SnapshotNewItems()
	wipe(newItemSnapshot)

	for _, bagID in ipairs(BAG_IDS) do
		local numSlots = C_Container_GetContainerNumSlots(bagID)
		for slotID = 1, numSlots do
			if C_NewItems_IsNewItem(bagID, slotID) then
				newItemSnapshot[bagID * 1000 + slotID] = true
			end
		end
	end
end

local function HideElvUIBagFrame()
	if B.BagFrame and B.BagFrame:IsShown() then
		SnapshotNewItems()
		B.BagFrame:Hide()
	end
end

-- Reskins a scrollbar to a thin, track-less thumb: HandleScrollBar's own
-- thumbX narrows the thumb via an inset (same technique as the options-page
-- scrollbar, Options/Widgets/ScrollBar.lua), and the separate track backdrop
-- it creates behind the thumb gets hidden outright instead of just inset.
local function SkinScrollBar(scrollbar)
	local ok = pcall(S.HandleScrollBar, S, scrollbar, nil, 4)
	if ok and scrollbar.backdrop then
		scrollbar.backdrop:Hide()
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
local function Slot_OnClick(self, mouseButton)
	-- Excludes MiddleButton: that's already our own Pin/Assign-to-Category
	-- click, and IsModifiedClick("SPLITSTACK") only checks the held modifier
	-- key, not which mouse button - without this exclusion, a Shift+Middle
	-- click would get hijacked by split-stack instead of opening the assign
	-- menu whenever Split Stack happens to be bound to Shift too.
	if mouseButton ~= "MiddleButton" and IsModifiedClick("SPLITSTACK") and not CursorHasItem() then
		if not InCombatLockdown() then
			self:SetAttribute("type", nil)
			self:SetAttribute("item", nil)

			-- Restored via a deferred call instead of a PostClick script -
			-- merely having a PostClick handler on this button appears to
			-- disturb the native secure type/item dispatch's own timing for
			-- a *plain* right-click (equips instead of selling at a
			-- merchant), even when that handler is a no-op for that click.
			local itemLink = self.itemLink
			C_Timer.After(0, function()
				if not InCombatLockdown() then
					self:SetAttribute("type", "item")
					self:SetAttribute("item", itemLink)
				end
			end)
		end

		if self.BagID and self.SlotID then
			local info = C_Container_GetContainerItemInfo(self.BagID, self.SlotID)
			if info and not info.isLocked and info.stackCount and info.stackCount > 1 then
				self.SplitStack = Slot_SplitStack
				_G.StackSplitFrame:OpenStackSplitFrame(info.stackCount, self, "BOTTOMRIGHT", "TOPRIGHT")
			end
		end

		return
	end

	if mouseButton == "LeftButton" then
		if IsModifiedClick() then
			HandleModifiedItemClick(self.itemLink)
		elseif self.BagID and self.SlotID then
			C_Container_PickupContainerItem(self.BagID, self.SlotID)
		end
	elseif mouseButton == "MiddleButton" then
		if IsShiftKeyDown() then
			module:OpenAssignMenu(self)
		else
			module:TogglePinned(self.itemID)
			module:RefreshCategoryFrame()
		end
	elseif mouseButton == "RightButton" then
		-- The native type/item dispatch (fires on RightButtonDown, see
		-- CreateSlotButton) is equivalent to "/use [item link]", which is
		-- just a plain use/equip with no vendor-sell awareness at all (that
		-- vendor-aware branching lives only inside Blizzard's own
		-- UseContainerItem) - and it fires synchronously, BEFORE our deferred
		-- UseContainerItem call below runs on the next frame. Left alone, it
		-- equips the item first (swapping the previously worn item into this
		-- same bag slot), and our deferred sell then acts on that swapped-in
		-- item instead of the one the user actually clicked. Suppressing the
		-- attributes here (same technique as the Split Stack click above)
		-- stops that dispatch from firing for this click at all, so only our
		-- own vendor-aware call decides what happens.
		if not InCombatLockdown() and _G.MerchantFrame and _G.MerchantFrame:IsShown() and self.BagID and self.SlotID then
			local bagID, slotID = self.BagID, self.SlotID
			local itemLink = self.itemLink

			self:SetAttribute("type", nil)
			self:SetAttribute("item", nil)

			C_Timer.After(0, function()
				C_Container.UseContainerItem(bagID, slotID)

				if not InCombatLockdown() then
					self:SetAttribute("type", "item")
					self:SetAttribute("item", itemLink)
				end
			end)
		end
	end
end

local function Slot_OnDrag(self)
	if self.BagID and self.SlotID then
		C_Container_PickupContainerItem(self.BagID, self.SlotID)
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
	if module.frame then
		module.frame:SetFrameLevel(module.frame:GetFrameLevel())
	end

	if self.BagID and self.SlotID and not GameTooltip:IsForbidden() then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetBagItem(self.BagID, self.SlotID)
		GameTooltip:Show()
	end

	Slot_UpdateCursor(self)
end

local function Slot_OnLeave()
	if not GameTooltip:IsForbidden() then
		GameTooltip:Hide()
	end

	if not (SpellIsTargeting and SpellIsTargeting()) then
		ResetCursor()
	end
end

local function CreateSlotButton(index)
	local btn = CreateFrame(
		"ItemButton",
		SLOT_NAME_PREFIX .. index,
		module.contentChild,
		"ContainerFrameItemButtonTemplate,SecureActionButtonTemplate"
	)

	local ok = pcall(btn.SetTemplate, btn, nil, true)
	if not ok then
		pcall(btn.SetTemplate, btn)
	end

	-- Blizzard's native button chrome (the slot-frame art behind the icon);
	-- we draw our own flat border via SetTemplate instead, same as ElvUI.
	btn:SetNormalTexture(E.ClearTexture)

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

	-- Defaults to shown until something hides it; we filter non-matching
	-- items out of the list entirely instead of dimming them in place.
	if btn.searchOverlay then
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
	-- phase registered, not just Up.
	btn:RegisterForClicks("AnyUp", "RightButtonDown")
	btn:SetScript("PreClick", Slot_OnClick)

	btn:RegisterForDrag("LeftButton")
	btn:SetScript("OnDragStart", Slot_OnDrag)
	btn:SetScript("OnReceiveDrag", Slot_OnDrag)

	btn:SetScript("OnEnter", Slot_OnEnter)
	btn:SetScript("OnLeave", Slot_OnLeave)
	btn.UpdateTooltip = Slot_OnEnter

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

	local _, _, _, equipLoc = C_Item_GetItemInfoInstant(itemLink)
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
	btn:SetID(entry.slotID)
	btn.itemID = entry.itemID
	btn.itemLink = entry.itemLink

	SetItemButtonTexture(btn, entry.icon)
	SetItemButtonCount(btn, entry.count)
	SetItemButtonDesaturated(btn, entry.isLocked)

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
	if not InCombatLockdown() then
		btn:SetAttribute("type", "item")
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

	UpdateUpgradeIcon(btn)

	-- Blizzard's own highlighting for Scrap, Rune Carving, Upgrade Items, etc.
	-- (ContainerFrameItemButtonMixin); never gets called on its own since this
	-- button isn't part of Blizzard's tracked container frames.
	if btn.UpdateItemContextMatching then
		btn:UpdateItemContextMatching()
	end

	UpdateSlotCooldown(btn, entry.bagID, entry.slotID)
end

-------------------------------------------------------------------------------
--  Category headers
-------------------------------------------------------------------------------
local function CreateHeader(index)
	local header = CreateFrame("Frame", nil, module.contentChild)
	header:SetHeight(22)

	header.icon = header:CreateTexture(nil, "ARTWORK")
	header.icon:SetSize(16, 16)
	header.icon:Point("LEFT", 2, 0)

	header.text = header:CreateFontString(nil, "OVERLAY")
	header.text:FontTemplate()
	header.text:Point("LEFT", header.icon, "RIGHT", 6, 0)

	header.clearButton = CreateFrame("Button", nil, header)
	header.clearButton:Size(14)
	header.clearButton:Point("RIGHT", -2, 0)
	pcall(header.clearButton.SetTemplate, header.clearButton)
	header.clearButton.tex = header.clearButton:CreateTexture(nil, "OVERLAY")
	header.clearButton.tex:SetAllPoints()
	header.clearButton.tex:SetTexture(E.Media.Textures.Close)
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

-------------------------------------------------------------------------------
--  Category sub-headers (expansion / equipment-set nesting within a category)
-------------------------------------------------------------------------------
local function CreateSubHeader(index)
	local header = CreateFrame("Frame", nil, module.contentChild)
	header:SetHeight(14)

	header.text = header:CreateFontString(nil, "OVERLAY")
	header.text:FontTemplate(nil, 10)
	header.text:SetTextColor(0.7, 0.7, 0.7)
	header.text:Point("LEFT", 0, 0)

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

-------------------------------------------------------------------------------
--  Sidebar rows
-------------------------------------------------------------------------------
local function Sidebar_OnClick(self, mouseButton)
	if self.wasDragged then
		self.wasDragged = nil
		return
	end

	if mouseButton == "LeftButton" then
		module:ScrollToCategory(self.catKey)
	elseif mouseButton == "RightButton" and (self.isUser or self.isGroup or self.isGroupMember) then
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
end

local function CreateSidebarRow(index)
	local row = CreateFrame("Button", nil, module.sidebarChild)
	row:SetHeight(24)
	row:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	row:SetScript("OnClick", Sidebar_OnClick)
	row:RegisterForDrag("LeftButton")
	row:SetScript("OnDragStart", Sidebar_OnDragStart)
	row:SetScript("OnDragStop", Sidebar_OnDragStop)
	row:SetScript("OnEnter", Sidebar_OnEnter)
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
	row.count:Point("RIGHT", -4, 0)

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
-- group-child row (see BuildCategorySections' isGroup handling) - `indent`
-- shifts the row's own left edge, so a child row's whole clickable area
-- (icon/text/highlight/gradient) visually nests under its group parent.
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
	memberKey
)
	local db = module.db
	local row = AcquireSidebarRow(index)
	row:SetHeight(db.sidebarRowHeight)
	row:ClearAllPoints()
	row:Point("TOPLEFT", module.sidebarChild, "TOPLEFT", indent, -(index - 1) * db.sidebarRowHeight)
	row:Point("TOPRIGHT", module.sidebarChild, "TOPRIGHT", 0, -(index - 1) * db.sidebarRowHeight)
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

	-- Blizzard's SortBags() already merges partial stacks as part of sorting;
	-- we don't have ElvUI's own separate animated Stack/Compress algorithm,
	-- so both buttons call the same native sort for now.
	f.sortButton = CreateTitleButton("SortButton", E.Media.Textures.PetBroom, L["Sort Bags"], function()
		C_Container.SortBags()
	end)
	f.sortButton:Point("TOPRIGHT", f, "TOPRIGHT", -40, -8)

	f.stackButton = CreateTitleButton("StackButton", E.Media.Textures.Planks, L["Stack Items In Bags"], function()
		C_Container.SortBags()
	end)
	f.stackButton:Point("TOPRIGHT", f.sortButton, "TOPLEFT", -2, 0)

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
	f.helpButton = CreateTitleButton("HelpButton", E.Media.Textures.Help, function()
		GameTooltip:AddDoubleLine(L["Left Click:"], L["Pick up / move item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Right Click:"], L["Use / equip item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Middle Click:"], L["Pin / unpin item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Shift + Middle Click:"], L["Assign to Category"], 1, 1, 1)
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
		row.text:SetJustifyH("LEFT")
		row.text:SetText(def.label)

		row.viewModeKey = def.key
		row:SetScript("OnClick", function()
			module.db.viewMode = def.key
			module:RefreshCategoryFrame()
		end)

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
	f.pinnedRow.count:Point("RIGHT", -4, 0)

	f.pinnedRow:SetScript("OnClick", function()
		module:ScrollToCategory(module.PinnedCategory.key)
	end)

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

	-- Footer
	f.footer = CreateFrame("Frame", nil, f)
	f.footer:Point("BOTTOMLEFT", 8, 8)
	f.footer:Point("BOTTOMRIGHT", -8, 8)
	f.footer:Height(20)

	f.footer.goldText = f.footer:CreateFontString(nil, "OVERLAY")
	f.footer.goldText:FontTemplate()
	f.footer.goldText:Point("LEFT", 4, 0)

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

function module:UpdateFooter()
	local f = module.frame
	if not f then
		return
	end

	f.footer.goldText:SetText(E:FormatMoney(GetMoney(), "SMART"))

	-- Chained right-to-left off the footer's own right edge (independent of
	-- goldText's width), so the whole currency cluster stays flush to the
	-- right instead of trailing right after the gold amount.
	local rightAnchor, rightAnchorPoint, rightPadding = f.footer, "RIGHT", -6
	for i = 1, MAX_WATCHED_TOKENS do
		local btn = f.footer.currencyButtons[i]
		local info = C_CurrencyInfo_GetBackpackCurrencyInfo(i)

		if info and info.name then
			local icon = btn.icon or btn.Icon
			icon:SetTexture(info.iconFileID)
			btn.text:SetText(info.quantity)

			btn:ClearAllPoints()
			btn.text:ClearAllPoints()
			btn.text:Point("RIGHT", rightAnchor, rightAnchorPoint, rightPadding, 0)
			btn:Point("RIGHT", btn.text, "LEFT", -2, 0)
			btn:Show()

			rightAnchor, rightAnchorPoint, rightPadding = btn, "LEFT", -14
		else
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
				local sellPrice = select(11, C_Item_GetItemInfo(info.hyperlink))
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

	local _, _, _, _, _, classID = C_Item_GetItemInfoInstant(itemLink)
	if classID ~= ITEMCLASS_ARMOR and classID ~= ITEMCLASS_WEAPON then
		return nil
	end

	local iLvl = C_Item_GetDetailedItemLevelInfo(itemLink)
	return iLvl and iLvl > 0 and iLvl or nil
end

-- Only informative for items that aren't bound yet (BoP items are already
-- bound the instant they're looted, so there's nothing left to show).
local function GetBindText(itemLink, isBound)
	if not itemLink or isBound then
		return nil
	end

	local _, _, _, _, _, _, _, _, _, _, _, _, _, bindType = C_Item_GetItemInfo(itemLink)
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
local equipmentSetItemMap = {}
local function RebuildEquipmentSetItemMap()
	wipe(equipmentSetItemMap)

	if not C_EquipmentSet or not C_EquipmentSet.GetEquipmentSetIDs or not C_EquipmentSet.GetItemIDs then
		return
	end

	-- Defensive: guards against any signature mismatch on this API across
	-- client versions - worst case, equipment-set nesting silently no-ops.
	pcall(function()
		local setIDs = C_EquipmentSet.GetEquipmentSetIDs()
		for _, setID in ipairs(setIDs or {}) do
			local name = C_EquipmentSet.GetEquipmentSetInfo(setID)
			local itemIDs = C_EquipmentSet.GetItemIDs(setID)
			if name and itemIDs then
				for _, itemID in pairs(itemIDs) do
					if itemID and itemID ~= 0 then
						equipmentSetItemMap[itemID] = name
					end
				end
			end
		end
	end)
end

-- expacID (15th return of GetItemInfo) maps to Blizzard's own localized
-- EXPANSION_NAME0.."11" globals, the same constants used by e.g. the class
-- trainer/PvP talent expansion filters.
local function GetItemExpansionInfo(itemID)
	if not itemID then
		return nil
	end

	local expacID = select(15, C_Item_GetItemInfo(itemID))
	if not expacID then
		return nil
	end

	return _G["EXPANSION_NAME" .. expacID], expacID
end

-- Groups items sharing the same subgroupName (expansion name, or equipment
-- set name) into contiguous runs, items without one first/unsorted. Returns
-- the reordered items plus a list of { name, index } marking where a small
-- sub-header should be inserted before rendering that item.
local function GroupBySubgroup(items, nestByExpansion)
	local seen, nameOrder, orderedNames = {}, {}, {}

	for _, entry in ipairs(items) do
		local name = entry.subgroupName
		if name and not seen[name] then
			seen[name] = true
			nameOrder[name] = entry.subgroupOrder or 0
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
			tinsert(subHeaders, { name = name, index = #result + 1, count = #bucket })
			for _, entry in ipairs(bucket) do
				tinsert(result, entry)
			end
		end
	end

	return result, subHeaders
end

local function CollectItems()
	for k in pairs(categoryItemsScratch) do
		wipe(categoryItemsScratch[k])
	end

	local searching = module.searchText and module.searchText ~= ""
	C_Container_SetItemSearch(searching and module.searchText or "")

	local catByKey = {}
	for _, cat in ipairs(module:GetCategories()) do
		catByKey[cat.key] = cat
	end
	RebuildEquipmentSetItemMap()

	for _, bagID in ipairs(BAG_IDS) do
		local numSlots = C_Container_GetContainerNumSlots(bagID)

		for slotID = 1, numSlots do
			local info = C_Container_GetContainerItemInfo(bagID, slotID)

			if info and info.iconFileID and not (searching and info.isFiltered) then
				local key =
					module:ClassifyItem(bagID, slotID, info.itemID, info.hyperlink, info.quality, info.hasNoValue)
				if key then
					categoryItemsScratch[key] = categoryItemsScratch[key] or {}

					local cat = catByKey[key]
					local subgroupName, subgroupOrder
					if cat and cat.nestByExpansion then
						subgroupName, subgroupOrder = GetItemExpansionInfo(info.itemID)
					elseif cat and cat.nestByEquipmentSet then
						subgroupName = equipmentSetItemMap[info.itemID]
					end

					local questID, isActiveQuest, isJunk =
						GetQuestAndJunkInfo(bagID, slotID, info.quality, info.hasNoValue)

					tinsert(categoryItemsScratch[key], {
						bagID = bagID,
						slotID = slotID,
						itemID = info.itemID,
						itemLink = info.hyperlink,
						icon = info.iconFileID,
						count = info.stackCount,
						quality = info.quality,
						isLocked = info.isLocked,
						isNew = C_NewItems_IsNewItem(bagID, slotID) or newItemSnapshot[bagID * 1000 + slotID] or false,
						itemLevel = module.db.itemLevel.enable and GetDisplayItemLevel(info.hyperlink, info.quality)
							or nil,
						bindText = module.db.itemInfo.enable and GetBindText(info.hyperlink, info.isBound) or nil,
						subgroupName = subgroupName,
						subgroupOrder = subgroupOrder,
						questID = questID,
						isActiveQuest = isActiveQuest,
						isJunk = isJunk,
					})
				end
			end
		end
	end

	return categoryItemsScratch
end

local function BuildCategorySections()
	local db = module.db
	local itemsByCategory = CollectItems()
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
				if entry.isNew then
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

	-- Category groups (e.g. "The Armory") merge several categories' items
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
						if memberCat.nestByEquipmentSet then
							hasNesting = true
						end
						if memberCat.nestByExpansion then
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
				if cat.nestByExpansion or cat.nestByEquipmentSet then
					items, subHeaders = GroupBySubgroup(items, cat.nestByExpansion)
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

-------------------------------------------------------------------------------
--  Bag view (group by physical bag instead of category)
-------------------------------------------------------------------------------
local bagItemsScratch = {}

local function CollectItemsByBag()
	for k in pairs(bagItemsScratch) do
		wipe(bagItemsScratch[k])
	end

	local searching = module.searchText and module.searchText ~= ""
	C_Container_SetItemSearch(searching and module.searchText or "")

	for _, bagID in ipairs(BAG_IDS) do
		local numSlots = C_Container_GetContainerNumSlots(bagID)

		for slotID = 1, numSlots do
			local info = C_Container_GetContainerItemInfo(bagID, slotID)

			if info and info.iconFileID and not (searching and info.isFiltered) then
				bagItemsScratch[bagID] = bagItemsScratch[bagID] or {}

				local questID, isActiveQuest, isJunk =
					GetQuestAndJunkInfo(bagID, slotID, info.quality, info.hasNoValue)

				tinsert(bagItemsScratch[bagID], {
					bagID = bagID,
					slotID = slotID,
					itemID = info.itemID,
					itemLink = info.hyperlink,
					icon = info.iconFileID,
					count = info.stackCount,
					quality = info.quality,
					isLocked = info.isLocked,
					isNew = C_NewItems_IsNewItem(bagID, slotID) or newItemSnapshot[bagID * 1000 + slotID] or false,
					itemLevel = module.db.itemLevel.enable and GetDisplayItemLevel(info.hyperlink, info.quality)
						or nil,
					bindText = module.db.itemInfo.enable and GetBindText(info.hyperlink, info.isBound) or nil,
					questID = questID,
					isActiveQuest = isActiveQuest,
					isJunk = isJunk,
					-- Only used to check the "Hide in All Items" flag below,
					-- not shown/used anywhere in the bag-grouped view itself.
					categoryKey = module:ClassifyItem(
						bagID,
						slotID,
						info.itemID,
						info.hyperlink,
						info.quality,
						info.hasNoValue
					),
				})
			end
		end
	end

	return bagItemsScratch
end

-- Reagent bag keeps its own dedicated icon (matches the Reagent Bag category);
-- the backpack gets ElvUI's flat backpack icon; every other bag shows the
-- actual equipped bag's own icon, same as looking at your character panel.
local function GetBagIcon(bagID)
	if bagID == 0 then
		return E.Media.Textures.Backpack
	end

	if bagID == module.ReagentContainer then
		return 132854
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

	return C_Container.GetBagName(bagID) or format(L["Bag %d"], bagID)
end

-------------------------------------------------------------------------------
--  Bag Bar popout (quick glance at equipped bags, toggled from the title bar)
-------------------------------------------------------------------------------
function module:ConstructBagBarPopout()
	if module.bagBarPopout then
		return module.bagBarPopout
	end

	local buttonSize, spacing = 30, 4
	local count = #BAG_IDS

	local f = CreateFrame("Frame", "MER_BagCategoriesBagBar", E.UIParent)
	f:Size(count * (buttonSize + spacing) + spacing, buttonSize + spacing * 2)
	f:SetFrameStrata("DIALOG")
	pcall(f.SetTemplate, f, "Transparent")
	WS:CreateShadow(f)
	f:Hide()

	f.buttons = {}
	for i, bagID in ipairs(BAG_IDS) do
		local btn = CreateFrame("Button", nil, f)
		btn:Size(buttonSize, buttonSize)
		btn:Point("LEFT", spacing + (i - 1) * (buttonSize + spacing), 0)
		pcall(btn.SetTemplate, btn)

		btn.tex = btn:CreateTexture(nil, "ARTWORK")
		btn.tex:SetInside()
		btn.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)

		btn.count = btn:CreateFontString(nil, "OVERLAY")
		btn.count:FontTemplate(nil, 10, "OUTLINE")
		btn.count:Point("BOTTOMRIGHT", -1, 1)

		btn:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], "ADD")

		btn.bagID = bagID
		btn:SetScript("OnClick", function(self)
			module.db.viewMode = "BAG"
			module:RefreshCategoryFrame()
			module:ScrollToCategory("BAG_" .. self.bagID)
		end)

		btn:SetScript("OnEnter", function(self)
			if GameTooltip:IsForbidden() then
				return
			end

			local numSlots = C_Container_GetContainerNumSlots(self.bagID)
			local freeSlots = C_Container.GetContainerNumFreeSlots and C_Container.GetContainerNumFreeSlots(self.bagID)
				or numSlots

			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:AddLine(format("%s (%d/%d)", GetBagDisplayName(self.bagID), numSlots - freeSlots, numSlots), 1, 1, 1)
			GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", GameTooltip_Hide)

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

	for _, btn in ipairs(f.buttons) do
		btn.tex:SetTexture(GetBagIcon(btn.bagID))
		local freeSlots = C_Container.GetContainerNumFreeSlots and C_Container.GetContainerNumFreeSlots(btn.bagID)
		btn.count:SetText(freeSlots or "")
	end
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

local function BuildBagSections()
	local db = module.db
	local itemsByBag = CollectItemsByBag()
	local sections = {}

	-- Pinned/Recent stay useful (and stay at the top) regardless of grouping.
	if db.showPinned then
		local pinned = {}
		for _, bagID in ipairs(BAG_IDS) do
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
		for _, bagID in ipairs(BAG_IDS) do
			for _, entry in ipairs(itemsByBag[bagID] or {}) do
				if entry.isNew then
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

	for _, bagID in ipairs(BAG_IDS) do
		local items = itemsByBag[bagID] or {}
		if #items > 0 or not db.hideEmptyCategories then
			tinsert(sections, {
				key = "BAG_" .. bagID,
				name = GetBagDisplayName(bagID),
				icon = GetBagIcon(bagID),
				isBagSection = true,
				items = items,
			})
		end
	end

	return sections
end

-------------------------------------------------------------------------------
--  All Items view (flat, ungrouped list)
-------------------------------------------------------------------------------
module.AllItemsCategory = { key = "ALL_ITEMS", name = L["All Items"], icon = E.Media.Textures.Backpack }

-- A category (or the group it belongs to, e.g. "The Armory") can be flagged
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

local function BuildFlatSections()
	local db = module.db
	local itemsByBag = CollectItemsByBag()
	local sections = {}

	if db.showPinned then
		local pinned = {}
		for _, bagID in ipairs(BAG_IDS) do
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
		for _, bagID in ipairs(BAG_IDS) do
			for _, entry in ipairs(itemsByBag[bagID] or {}) do
				if entry.isNew then
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
	for _, bagID in ipairs(BAG_IDS) do
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

local function BuildSections()
	local viewMode = module.db.viewMode

	if viewMode == "BAG" then
		return BuildBagSections()
	elseif viewMode == "ALL" then
		return BuildFlatSections()
	end

	return BuildCategorySections()
end

function module:SetSidebarCollapsed(collapsed)
	module.db.sidebarCollapsed = collapsed
	module:RefreshCategoryFrame()
end

function module:ScrollToCategory(key)
	local offset = module.categoryOffsets and module.categoryOffsets[key]
	if offset and module.frame then
		module.frame.mainScroll:SetVerticalScroll(offset)
	end
end

function module:RefreshCategoryFrame()
	if not module.frame or not module.frame:IsShown() then
		return
	end

	local db = module.db
	local sections = BuildSections()

	module.categoryOffsets = {}

	local f = module.frame
	local sidebarWidth = db.sidebarCollapsed and COLLAPSED_SIDEBAR_WIDTH or db.sidebarWidth
	f.sidebar:Width(sidebarWidth)
	f.addCategoryButton:SetShown(not db.sidebarCollapsed)

	-- The scrollbar reserve (sidebarScroll's right inset) is sized for the
	-- full-width sidebar; a fixed -30 on top of a collapsed ~40px sidebar
	-- left almost nothing for the icon column and clipped it. Both the
	-- scroll frame's own inset and the child width it scrolls need a
	-- collapsed-appropriate reserve instead.
	local scrollbarReserve = db.sidebarCollapsed and 16 or 30
	f.sidebarScroll:ClearAllPoints()
	f.sidebarScroll:Point("TOPLEFT", 4, -18 - (#f.viewModeRows + 1) * VIEW_MODE_ROW_HEIGHT - 10)
	f.sidebarScroll:Point("BOTTOMRIGHT", -(scrollbarReserve - 6), 4)
	f.sidebarChild:Width(sidebarWidth - scrollbarReserve)

	f.pinnedRow.text:SetShown(not db.sidebarCollapsed)
	f.pinnedRow.count:SetShown(not db.sidebarCollapsed)
	SetCategoryIcon(f.pinnedRow.icon, module.PinnedCategory)

	local collapseArrowRotation = S.ArrowRotation and S.ArrowRotation[db.sidebarCollapsed and "right" or "left"]
	if collapseArrowRotation then
		for _, tex in ipairs({ f.collapseButton:GetNormalTexture(), f.collapseButton:GetPushedTexture() }) do
			if tex then
				tex:SetRotation(collapseArrowRotation)
			end
		end
	end

	f.sidebarHeaderText:SetShown(not db.sidebarCollapsed)

	for _, row in ipairs(f.viewModeRows) do
		row.text:SetShown(not db.sidebarCollapsed)
		local isSelected = row.viewModeKey == db.viewMode
		row.selectedTex:SetShown(isSelected)
		row.selectedBar:SetShown(isSelected)
	end

	local contentWidth = db.width - sidebarWidth - 44
	local columns = floor((contentWidth + db.itemSpacingH) / (db.itemSize + db.itemSpacingH))
	if columns < 1 then
		columns = 1
	end

	module.contentChild:Width(contentWidth)

	local slotIndex, headerIndex, subHeaderIndex, sidebarIndex = 0, 0, 0, 0
	local y = 0

	for _, section in ipairs(sections) do
		module.categoryOffsets[section.key] = y

		headerIndex = headerIndex + 1
		local header = AcquireHeader(headerIndex)
		header:SetHeight(db.headerHeight)
		header:ClearAllPoints()
		header:Point("TOPLEFT", module.contentChild, "TOPLEFT", 0, -y)
		header:Point("TOPRIGHT", module.contentChild, "TOPRIGHT", 0, -y)
		header.text:SetText(format("%s (%d)", section.name, #section.items))
		SetCategoryIcon(header.icon, section)

		if section.showClear then
			header.clearButton:Show()
			header.clearButton:SetScript("OnClick", function()
				for _, entry in ipairs(section.items) do
					C_NewItems_RemoveNewItem(entry.bagID, entry.slotID)
				end
				module:RefreshCategoryFrame()
			end)
		else
			header.clearButton:Hide()
		end

		y = y + header:GetHeight() + HEADER_PADDING

		-- Pinned Items has its own fixed shortcut row above the scrollable
		-- list now (see ConstructFrame), so it's excluded from the scrollable
		-- sidebar rows here - only its content header/items still render.
		if section.key == module.PinnedCategory.key then
			f.pinnedRow.count:SetText(#section.items)
		else
			sidebarIndex = sidebarIndex + 1
			-- Bag sections aren't reorderable either (no persisted "bag order"
			-- concept, and physical bags aren't user-defined categories).
			SetupSidebarCategoryRow(
				sidebarIndex,
				0,
				section.key,
				section.name,
				section.icon,
				section.isAtlas,
				#section.items,
				section.key:find("^USER_") and true or false,
				section.key == module.RecentCategory.key
					or section.key == module.AllItemsCategory.key
					or section.isBagSection == true
					or section.isGroup == true,
				section.isGroup
			)

			-- A category group ("The Armory") shows its member categories as
			-- indented rows right underneath, always expanded - clicking one
			-- jumps to the same merged content section as the parent, just
			-- with that member's own item count/icon for orientation.
			if section.isGroup and section.groupMembers then
				for _, member in ipairs(section.groupMembers) do
					sidebarIndex = sidebarIndex + 1
					SetupSidebarCategoryRow(
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
						member.key
					)
				end
			end
		end

		if #section.items > 0 then
			local col = 0
			local rowStartY = y
			local subHeaders = section.subHeaders
			local nextSubHeader = subHeaders and subHeaders[1]
			local nextSubHeaderPos = 2

			for itemIndex, entry in ipairs(section.items) do
				-- A subgroup (expansion/equipment-set name) always starts its
				-- own row, with a small indented header above its items.
				if nextSubHeader and nextSubHeader.index == itemIndex then
					if col > 0 then
						col = 0
						rowStartY = rowStartY + db.itemSize + db.itemSpacingV
					end

					subHeaderIndex = subHeaderIndex + 1
					local subHeader = AcquireSubHeader(subHeaderIndex)
					subHeader:ClearAllPoints()
					subHeader:Point("TOPLEFT", module.contentChild, "TOPLEFT", 10, -rowStartY)
					subHeader.text:SetText(format("%s (%d)", nextSubHeader.name, nextSubHeader.count))
					rowStartY = rowStartY + subHeader:GetHeight() + 2

					nextSubHeader = subHeaders[nextSubHeaderPos]
					nextSubHeaderPos = nextSubHeaderPos + 1
				end

				slotIndex = slotIndex + 1
				local btn = AcquireSlot(slotIndex)
				UpdateSlotVisual(btn, entry)

				btn:ClearAllPoints()
				btn:Size(db.itemSize)
				btn:Point("TOPLEFT", module.contentChild, "TOPLEFT", col * (db.itemSize + db.itemSpacingH), -rowStartY)

				col = col + 1
				if col >= columns then
					col = 0
					rowStartY = rowStartY + db.itemSize + db.itemSpacingV
				end
			end

			if col > 0 then
				rowStartY = rowStartY + db.itemSize + db.itemSpacingV
			end
			y = rowStartY
		end

		y = y + db.sectionSpacing
	end

	ReleaseSlotsFrom(slotIndex + 1)
	ReleaseHeadersFrom(headerIndex + 1)
	ReleaseSubHeadersFrom(subHeaderIndex + 1)
	ReleaseSidebarRowsFrom(sidebarIndex + 1)

	module.sidebarChild:Height(math.max(1, sidebarIndex * db.sidebarRowHeight))
	module.contentChild:Height(math.max(1, y))

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
	f.titleText:SetText(L["Inventory"])
	f.titleCountText:SetText(format("%d / %d %s", usedSlots, totalSlots, L["Items"]))

	module:UpdateFooter()
end

-------------------------------------------------------------------------------
--  Add / rename / delete categories
-------------------------------------------------------------------------------
_G.StaticPopupDialogs = _G.StaticPopupDialogs or {}

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
				module:RefreshCategoryFrame()
			end)

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
	_G.MenuUtil.CreateContextMenu(slot, function(_, rootDescription)
		rootDescription:CreateTitle(L["Assign to Category"])

		for _, cat in ipairs(module:GetCategories()) do
			if not cat.isReagentBag then
				rootDescription:CreateButton(cat.name, function()
					module:AssignItemToCategory(itemID, cat.key)
					module:RefreshCategoryFrame()
				end)
			end
		end

		local db = module.db
		if db.itemAssignments and db.itemAssignments[itemID] then
			rootDescription:CreateButton(L["Clear Assignment"], function()
				module:ClearItemAssignment(itemID)
				module:RefreshCategoryFrame()
			end)
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
function module:ShowCategoryFrame()
	if InCombatLockdown() then
		return
	end

	module:ConstructFrame()
	HideElvUIBagFrame()

	module.frame:Show()
	module:RegisterBagEvents()
	module:RefreshCategoryFrame()
	PlaySound(SOUNDKIT.IG_BACKPACK_OPEN or 862)
end

function module:HideCategoryFrame()
	if InCombatLockdown() then
		return
	end

	if module.frame and module.frame:IsShown() then
		module.frame:Hide()
	end
end

function module:OnFrameHidden()
	module:UnregisterBagEvents()
	C_Container_SetItemSearch("")

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

	PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE or 863)
end

function module:ToggleCategoryFrame()
	if module.frame and module.frame:IsShown() then
		module:HideCategoryFrame()
	else
		module:ShowCategoryFrame()
	end
end

-- Combat-guarded here too (see ShowCategoryFrame): without it we'd still
-- hide B.BagFrame below and then no-op on our own frame, leaving no bag
-- frame visible at all until combat ends.
function module:ToggleAllBags()
	if InCombatLockdown() then
		return
	end

	HideElvUIBagFrame()
	module:ToggleCategoryFrame()
end

function module:ToggleBackpack()
	module:ToggleAllBags()
end

function module:OpenAllBags(frame)
	-- Only take over if ElvUI's own auto-toggle logic actually decided to open
	-- (it already ran by the time this hook fires); this keeps its per-context
	-- (mail/vendor) auto-open settings authoritative instead of duplicating them.
	if InCombatLockdown() or not frame or not (B.BagFrame and B.BagFrame:IsShown()) then
		return
	end

	HideElvUIBagFrame()
	module:ShowCategoryFrame()
end

function module:CloseAllBags()
	if InCombatLockdown() then
		return
	end

	module:HideCategoryFrame()
end

local eventFrame = CreateFrame("Frame")
local BAG_REFRESH_EVENTS = { "BAG_UPDATE", "BAG_UPDATE_DELAYED", "ITEM_LOCK_CHANGED" }

eventFrame:SetScript("OnEvent", function()
	module:RefreshCategoryFrame()
end)

function module:RegisterBagEvents()
	for _, event in ipairs(BAG_REFRESH_EVENTS) do
		eventFrame:RegisterEvent(event)
	end
end

function module:UnregisterBagEvents()
	eventFrame:UnregisterAllEvents()
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

	module.searchText = ""

	module:SecureHook("ToggleAllBags")
	module:SecureHook("ToggleBackpack")
	module:SecureHook("OpenAllBags")
	module:SecureHook("CloseAllBags")
end

function module:ProfileUpdate()
	local db = F.GetDBFromPath("mui.bags.categorizedBags") or E.db.mui.bags.categorizedBags
	module.db = db
	module:InvalidateCategoryCache()

	if module.frame and module.frame:IsShown() then
		module:RefreshCategoryFrame()
	end
end

MER:RegisterModule(module:GetName())
