local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories
local B = E:GetModule("Bags")
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")
local EM = MER:GetModule("MER_EquipManager") ---@class EquipmentManager

local _G = _G
local ipairs, pairs = ipairs, pairs
local tinsert, wipe = tinsert, wipe
local tsort = table.sort
local floor, ceil = math.floor, math.ceil
local format = format
local strmatch = strmatch
local IsShiftKeyDown = IsShiftKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsModifiedClick = IsModifiedClick
local HandleModifiedItemClick = HandleModifiedItemClick
local CursorHasItem = CursorHasItem

local CreateFrame = CreateFrame
local GetMoney = GetMoney
local CloseBankFrame = (C_Bank and C_Bank.CloseBankFrame) or CloseBankFrame
local FetchPurchasedBankTabData = C_Bank and C_Bank.FetchPurchasedBankTabData
local AutoDepositItemsIntoBank = C_Bank and C_Bank.AutoDepositItemsIntoBank
local CanViewBank = C_Bank and C_Bank.CanViewBank
local FetchNumPurchasedBankTabs = C_Bank and C_Bank.FetchNumPurchasedBankTabs
local FetchNextPurchasableBankTabData = C_Bank and C_Bank.FetchNextPurchasableBankTabData
local PurchaseBankTab = C_Bank and C_Bank.PurchaseBankTab
local CanPurchaseBankTab = C_Bank and C_Bank.CanPurchaseBankTab
local CHARACTER_BANK_TYPE = (Enum.BankType and Enum.BankType.Character) or 0
local WARBAND_BANK_TYPE = (Enum.BankType and Enum.BankType.Account) or 2

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
local C_TooltipInfo_GetBagItem = C_TooltipInfo.GetBagItem
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
local COLLAPSED_SIDEBAR_WIDTH = 40
local VIEW_MODE_ROW_HEIGHT = 24

-- Exposed so BankFrame.lua can build its own frame/slot names consistently.
module.BANK_FRAME_NAME = BANK_FRAME_NAME

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
			newItemSnapshot[key] = C_NewItems_IsNewItem(bagID, slotID) or nil
		end
	end
end

local function SnapshotNewItems()
	SnapshotNewItemsForBags(BAG_IDS)
end

local function SnapshotBankNewItems()
	SnapshotNewItemsForBags(module.BankBagIDs)
	SnapshotNewItemsForBags(module.WarbandBagIDs)
end

-- Must NOT call B.BagFrame:Hide() - its OnHide handler (Container_OnHide)
-- calls CloseBackpack()/CloseBag() as a side effect, which resets the
-- native "bags are open" state ElvUI's own toggle handlers read on the next
-- press of the bag keybind. Since our frame is what's actually open at that
-- point, that reset made every subsequent press decide to "open" again
-- instead of alternating - the keybind stopped closing anything.
--
-- SetAlpha(0)/EnableMouse(false) on the frame itself (an earlier attempt)
-- isn't enough either: neither is inherited by children, so every child
-- button - item slots, sort/stack/close buttons, the bags/key buttons, ...
-- stayed fully clickable, invisible but sitting right on top of our own
-- frame's controls at the same screen position (reported as the sidebar's
-- collapse arrow not reacting at all - an invisible ElvUI bag-frame child
-- was eating the click before it ever reached our button). Moving the whole
-- frame off-screen instead makes its entire subtree unreachable to the
-- mouse, regardless of how many children ElvUI's bag frame has. Safe to
-- never restore the position afterwards: B:OpenBags() never re-anchors the
-- frame itself (only Shows it), so we just push it off-screen again every
-- time we take over - and this feature requires a /reload to toggle off,
-- which rebuilds the frame with its default anchor anyway.
local function HideElvUIBagFrame()
	if B.BagFrame and B.BagFrame:IsShown() then
		SnapshotNewItems()
		B.BagFrame:EnableMouse(false)
		B.BagFrame:ClearAllPoints()
		B.BagFrame:SetPoint("CENTER", E.UIParent, "CENTER", -10000, -10000)
	end
end

-- Unlike HideElvUIBagFrame, this must NOT call B.BankFrame:Hide() - ElvUI's
-- shared Container_OnHide handler calls CloseBankFrame() as a side effect
-- for any frame with isBank=true, which would immediately end the real
-- server-side bank interaction. Moved off-screen for the same reason as
-- HideElvUIBagFrame above (EnableMouse(false)/SetAlpha(0) on the frame
-- alone doesn't stop its children from still being clickable);
-- module:OnFrameHidden() is responsible for actually closing the bank via
-- CloseBankFrame() when appropriate.
local function HideElvUIBankFrame()
	if B.BankFrame and B.BankFrame:IsShown() then
		SnapshotBankNewItems()
		B.BankFrame:EnableMouse(false)
		B.BankFrame:ClearAllPoints()
		B.BankFrame:SetPoint("CENTER", E.UIParent, "CENTER", -10000, -10000)
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
				self:SetAttribute("type", nil)
				self:SetAttribute("item", nil)

				local itemLink = self.itemLink
				C_Timer.After(0, function()
					if not InCombatLockdown() then
						self:SetAttribute("type", "item")
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
	if self.ownerFrame then
		self.ownerFrame:SetFrameLevel(self.ownerFrame:GetFrameLevel())
	end

	if self.BagID and self.SlotID and not GameTooltip:IsForbidden() then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetBagItem(self.BagID, self.SlotID)
		if module.isBankOpen then
			GameTooltip:AddLine(L["Ctrl+Right-click to move to a specific tab/bag"], 0.6, 0.6, 0.6)
		end
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

-- Bag and Bank/Warband are two independent top-level frames that can both be
-- shown at once (opening the bank auto-shows the bags too, see OnBankOpened),
-- so their pooled slot/header/sub-header/sidebar-row objects can't share one
-- set of tables - two refreshes on the same event tick would otherwise fight
-- over (and visually corrupt) the same recycled buttons. CreateSlotPoolFor
-- (and its Header/SubHeader/Sidebar counterparts below) each produce one
-- independent, closure-owned pool instead, parented/named per the frame that
-- owns them (see CreatePoolSet's bagPools/bankPools instantiation).
local function CreateSlotPoolFor(namePrefix, getContentChild, getOwnerFrame)
	local slotPool = {}

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
	-- phase registered, not just Up.
	btn:RegisterForClicks("AnyUp", "RightButtonDown")
	btn:SetScript("PreClick", Slot_OnClick)

	btn:RegisterForDrag("LeftButton")
	btn:SetScript("OnDragStart", Slot_OnDrag)
	btn:SetScript("OnReceiveDrag", Slot_OnDrag)

	btn:SetScript("OnEnter", Slot_OnEnter)
	btn:SetScript("OnLeave", Slot_OnLeave)
	btn.UpdateTooltip = Slot_OnEnter

	-- Slot_OnEnter needs to bump the frame level of whichever top-level frame
	-- (bags or bank) this particular button actually belongs to.
	btn.ownerFrame = getOwnerFrame()

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

-- Same tooltip-scan EquipManager.lua uses for ElvUI's native bags
-- (GetContainerItemEquipmentSetInfo is still unreliable).
local function IsItemInEquipmentSet(bagID, slotID)
	local tooltipData = C_TooltipInfo_GetBagItem(bagID, slotID)
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

	local _, _, _, equipLoc = C_Item_GetItemInfoInstant(entry.itemLink)
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
	UpdateEquipSetIcon(btn, entry)

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
local function CreateHeaderPoolFor(getContentChild)
	local headerPool = {}

	local function CreateHeader(index)
		local header = CreateFrame("Frame", nil, getContentChild())
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

	return { Acquire = AcquireHeader, Release = ReleaseHeadersFrom }
end

-------------------------------------------------------------------------------
--  Category sub-headers (expansion / equipment-set nesting within a category)
-------------------------------------------------------------------------------
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
		header.bg = header:CreateTexture(nil, "BACKGROUND")
		header.bg:SetAllPoints()
		header.bg:SetColorTexture(0, 0, 0, 0.35)

		header.text = header:CreateFontString(nil, "OVERLAY")
		header.text:FontTemplate(nil, 11)
		header.text:SetTextColor(0.9, 0.9, 0.9)
		header.text:Point("LEFT", 4, 0)

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
	local header = CreateHeaderPoolFor(getContentChild)
	local subHeader = CreateSubHeaderPoolFor(getContentChild)
	local sidebar = CreateSidebarPoolFor(getSidebarChild, getOwnerFrame, getOffsets)

	return {
		AcquireSlot = slot.Acquire,
		ReleaseSlotsFrom = slot.Release,
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
		module:StartSortSpinner()
		C_Container.SortBags()
	end)
	f.sortButton:Point("TOPRIGHT", f, "TOPRIGHT", -40, -8)

	f.stackButton = CreateTitleButton("StackButton", E.Media.Textures.Planks, L["Stack Items In Bags"], function()
		module:StartSortSpinner()
		C_Container.SortBags()
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
		GameTooltip:AddDoubleLine(L["Shift + Right Click:"], L["Split Stack"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Middle Click:"], L["Pin / unpin item"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Shift + Middle Click:"], L["Assign to Category"], 1, 1, 1)

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
		row.text:Point("RIGHT", -26, 0)
		row.text:SetJustifyH("LEFT")
		row.text:SetText(def.label)

		row.count = row:CreateFontString(nil, "OVERLAY")
		row.count:FontTemplate()
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

	-- Footer
	f.footer = CreateFrame("Frame", nil, f)
	f.footer:Point("BOTTOMLEFT", 8, 8)
	f.footer:Point("BOTTOMRIGHT", -8, 8)
	f.footer:Height(20)

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
		GameTooltip:AddDoubleLine(nameLine, E:FormatMoney(data.amount, "SMART"), color.r, color.g, color.b, 1, 1, 1)
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(_G.TOTAL or L["Total"], E:FormatMoney(total, "SMART"), 1, 1, 1, 1, 1, 1)

	if E.Retail and _G.C_Bank and _G.C_Bank.FetchDepositedMoney then
		local warbandBankType = (Enum.BankType and Enum.BankType.Account) or 2
		local ok, warbandGold = pcall(_G.C_Bank.FetchDepositedMoney, warbandBankType)
		if ok and warbandGold then
			GameTooltip:AddDoubleLine(L["Warband Bank"], E:FormatMoney(warbandGold, "SMART"), 1, 1, 1, 1, 1, 1)
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

-- Blizzard's own "Deposit" button action (same one on ElvUI's Bank frame,
-- B:BankTabs_DepositCharacter/DepositWarband) - sorts bag items straight into
-- whichever bank tab the player configured them for via each tab's "Assign to
-- Tab" rules (the same edit panel our Ctrl+Right-click "Move to Bank Tab"
-- opens), in one call instead of moving items one at a time. Targets whichever
-- of the two banks the sidebar is currently showing.
function module:AutoDepositToBank()
	if not module.isBankOpen or not AutoDepositItemsIntoBank then
		E:Print(L["You must be at the bank."])
		return
	end

	local isWarbandView = module.bankViewMode == "WARBAND_ALL" or module.bankViewMode == "ONEWARBAND"
	local bankType = isWarbandView and WARBAND_BANK_TYPE or CHARACTER_BANK_TYPE
	AutoDepositItemsIntoBank(bankType)
end

-- Confirmation prompt for buying the next bank tab (mirrors Blizzard's own
-- purchase flow, which also confirms before spending gold) - PurchaseBankTab
-- always targets "the next" tab, there's no per-tab selection, so this is
-- only ever offered for the one tab slot right after your last purchased one.
local function ShowPurchaseBankTabPrompt(bankType)
	if not FetchNextPurchasableBankTabData or not PurchaseBankTab then
		return
	end

	local tabData = FetchNextPurchasableBankTabData(bankType)
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
					local subgroupName, subgroupOrder
					if cat and cat.nestByExpansion then
						subgroupName, subgroupOrder = GetItemExpansionInfo(info.itemID)
					elseif cat and cat.nestByEquipmentSet then
						subgroupName = module:GetEquipmentSetName(info.itemID)
					end

					local questID, isActiveQuest, isJunk =
						GetQuestAndJunkInfo(bagID, slotID, info.quality, info.hasNoValue)

					tinsert(scratch[key], {
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

				tinsert(scratch[bagID], {
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
	if not FetchPurchasedBankTabData then
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
	local tabs = FetchPurchasedBankTabData(bankType)
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
-- (BankFrame.lua). PurchaseBankTab always buys "the next" tab, there's no
-- per-tab selection, so only the slot right after the last purchased one can
-- ever be "purchasable"; anything further out stays "locked" until that one
-- is bought (same one-step-at-a-time reveal Blizzard's own tab bar uses).
local function GetBankTabSlotState(bagIDList, bankType, index)
	local bagID = bagIDList[index]
	if not bagID then
		return nil
	end

	local purchasedCount = (bankType and FetchNumPurchasedBankTabs) and FetchNumPurchasedBankTabs(bankType)
		or #bagIDList

	if index <= purchasedCount then
		return "purchased", bagID
	elseif index == purchasedCount + 1 and bankType and CanPurchaseBankTab and CanPurchaseBankTab(bankType) then
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

-- Shared by both the bag and bank frames' sidebar category rows
-- (Sidebar_OnClick passes the clicked row's own ownerFrame/offsets); the two
-- positional defaults keep every other existing call site (the bag frame's
-- own Pinned-row shortcut, the Bag Bar's "jump to this bag" click) working
-- unchanged.
function module:ScrollToCategory(key, frame, offsets)
	frame = frame or module.frame
	offsets = offsets or module.categoryOffsets
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

	local slotIndex, headerIndex, subHeaderIndex, sidebarIndex = 0, 0, 0, 0
	local y = 0

	for _, section in ipairs(sections) do
		ctx.offsets[section.key] = y

		headerIndex = headerIndex + 1
		local header = pools.AcquireHeader(headerIndex)
		header:SetHeight(db.headerHeight)
		header:ClearAllPoints()
		header:Point("TOPLEFT", ctx.contentChild, "TOPLEFT", 0, -y)
		header:Point("TOPRIGHT", ctx.contentChild, "TOPRIGHT", 0, -y)
		header.text:SetText(format("%s (%d)", section.name, #section.items))
		SetCategoryIcon(header.icon, section)

		if section.showClear then
			header.clearButton:Show()
			header.clearButton:SetScript("OnClick", function()
				for _, entry in ipairs(section.items) do
					C_NewItems_RemoveNewItem(entry.bagID, entry.slotID)
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
			ctx.pinnedRow.count:SetText(#section.items)
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
				#section.items,
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
					local subHeader = pools.AcquireSubHeader(subHeaderIndex)
					subHeader:ClearAllPoints()
					subHeader:Point("TOPLEFT", ctx.contentChild, "TOPLEFT", 6, -rowStartY)
					subHeader:Point("TOPRIGHT", ctx.contentChild, "TOPRIGHT", -6, -rowStartY)
					subHeader.text:SetText(format("%s (%d)", nextSubHeader.name, nextSubHeader.count))
					rowStartY = rowStartY + subHeader:GetHeight() + 2

					nextSubHeader = subHeaders[nextSubHeaderPos]
					nextSubHeaderPos = nextSubHeaderPos + 1
				end

				slotIndex = slotIndex + 1
				local btn = pools.AcquireSlot(slotIndex)
				UpdateSlotVisual(btn, entry)

				btn:ClearAllPoints()
				btn:Size(db.itemSize)
				btn:Point("TOPLEFT", ctx.contentChild, "TOPLEFT", col * (db.itemSize + db.itemSpacingH), -rowStartY)

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

	pools.ReleaseSlotsFrom(slotIndex + 1)
	pools.ReleaseHeadersFrom(headerIndex + 1)
	pools.ReleaseSubHeadersFrom(subHeaderIndex + 1)
	pools.ReleaseSidebarRowsFrom(sidebarIndex + 1)

	ctx.sidebarChild:Height(math.max(1, (ctx.sidebarBaseY or 0) + sidebarIndex * db.sidebarRowHeight))
	ctx.contentChild:Height(math.max(1, y))
end

module.RenderCategorySections = RenderCategorySections

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
	end

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

	RenderCategorySections({
		contentChild = module.contentChild,
		sidebarChild = module.sidebarChild,
		pools = bagPools,
		pinnedRow = f.pinnedRow,
		offsets = module.categoryOffsets,
		width = db.width,
		sidebarWidth = sidebarWidth,
		refresh = function()
			module:RefreshCategoryFrame()
		end,
	}, sections)

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

_G.StaticPopupDialogs["MER_BAGCATEGORIES_PURCHASE_BANK_TAB"] = {
	text = "%s",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(_, data)
		if data and data.bankType and PurchaseBankTab then
			PurchaseBankTab(data.bankType)
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
	local ownerFrame = slot.ownerFrame
	_G.MenuUtil.CreateContextMenu(slot, function(_, rootDescription)
		rootDescription:CreateTitle(L["Assign to Category"])

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
function module:ShowCategoryFrame()
	if InCombatLockdown() then
		return
	end

	module:ConstructFrame()
	HideElvUIBagFrame()

	module.frame:Show()
	module:RegisterBagEventsFor("bag")
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
	module:UnregisterBagEventsFor("bag")

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
	local canViewCharacter = not CanViewBank or CanViewBank(CHARACTER_BANK_TYPE)
	module.bankViewMode = (not canViewCharacter and #module.WarbandBagIDs > 0) and "WARBAND_ALL" or "BANK_ALL"

	module:ShowBankFrame()

	-- Opening the bank also shows the bag frame, if it isn't already up (so
	-- items can be dragged between the two) - but only auto-close it again
	-- later if it was actually us that opened it (module.frame_openedByBank,
	-- cleared on every bag-frame hide path in OnFrameHidden), so a bag frame
	-- the player already had open manually is left alone either way.
	if not InCombatLockdown() and not (module.frame and module.frame:IsShown()) then
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
	if module.frame and module.frame.spinnerIcon then
		E:StopSpinner(module.frame.spinnerIcon)
	end
end

function module:PokeSortSpinner()
	sortSpinnerGeneration = sortSpinnerGeneration + 1
	E:Delay(0.4, StopSortSpinner, sortSpinnerGeneration)
end

function module:StartSortSpinner()
	local db = module.db.spinner
	if not (db and db.enable and module.frame and module.frame.spinnerIcon) then
		return
	end

	module.sortingBags = true
	E:StartSpinner(module.frame.spinnerIcon, nil, nil, nil, nil, db.size, db.color.r, db.color.g, db.color.b)
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

MER:RegisterModule(module:GetName())
