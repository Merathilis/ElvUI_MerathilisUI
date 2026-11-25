local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

local ipairs = ipairs
local pairs = pairs
local wipe = wipe
local format = format
local floor = math.floor
local tinsert = table.insert
local unpack = unpack

local InCombatLockdown = InCombatLockdown
local SetItemButtonCount = SetItemButtonCount
local SetItemButtonDesaturated = SetItemButtonDesaturated
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots
local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo

-------------------------------------------------------------------------------
--  Keep Layout While Taking Items Out
-------------------------------------------------------------------------------
-- While items only leave the bags (sold, used up, deleted, deposited), a
-- refresh caused by a bag event doesn't rebuild the window: every slot stays
-- where it is, a slot that emptied stays as a gap, merged slots count down.
-- Anything else lets go of the held layout and rebuilds as usual: an item that
-- shows up in a slot or a stack that grows, a bag swap, a sort, the merge
-- state changing with a vendor/mail/bank window, and every refresh that does
-- not come from a bag event (options, search, sidebar, reopening the window).
-- Header and sidebar counts stay as they were until the next rebuild, the
-- title's free slot count follows. List display never holds.
--
-- A slot is keyed bagID * 1000 + slotID, like the rest of the bags code.
-- Kept in its own file: CategoryFrame.lua is at the 200 locals limit.

-- win ("bag"/"bank") -> what the window showed at its last rebuild
local states = {}
-- The slots of the current pass: key -> stack count / locked
local current, currentLocked = {}, {}
local bankContainers = {}

local function SlotKey(bagID, slotID)
	return bagID * 1000 + slotID
end

local function IsBankWarbandView()
	return module.bankViewMode == "WARBAND_ALL" or module.bankViewMode == "ONEWARBAND"
end

local function GetWindow(win)
	if win == "bag" then
		return module.frame, module.db.displayMode
	end
	return module.bankFrame, module.db.bankDisplayMode
end

-- Every container whose items the window can list
local function GetContainers(win)
	if win == "bag" then
		return module:GetShownBagIDs()
	end

	wipe(bankContainers)
	for _, bagID in ipairs(module.BankBagIDs) do
		tinsert(bankContainers, bagID)
	end
	for _, bagID in ipairs(module.WarbandBagIDs) do
		tinsert(bankContainers, bagID)
	end
	return bankContainers
end

-- Whether the bag's slots count toward the title's used slots, mirrors
-- RefreshCategoryFrame / RefreshBankCategoryFrame
local function IsCountedBag(win, bagID)
	if win == "bank" then
		for _, id in ipairs(IsBankWarbandView() and module.WarbandBagIDs or module.BankBagIDs) do
			if id == bagID then
				return true
			end
		end
		return false
	end

	if bagID == module.KeyringContainer then
		return false
	end

	if E.Forever then
		local _, family = C_Container_GetContainerNumFreeSlots(bagID)
		if family and family ~= 0 then
			if bagID == module.ReagentContainer then
				return not (family == 1 or family == 2 or family == 4)
			end
			return false
		end
	end

	return true
end

---Remembers what a window shows after a full rebuild, the base of the next held passes
---@param win string "bag" or "bank"
---@param used number used slots shown in the title
---@param total number total slots shown in the title
function module.ArmLayoutHold(win, used, total)
	local state = states[win]
	if not module.db.keepLayout then
		if state then
			state.armed = false
		end
		return
	end

	if not state then
		state = { ids = {}, counts = {}, numSlots = {}, counted = {} }
		states[win] = state
	end

	local ids, counts, numSlotsByBag, counted = state.ids, state.counts, state.numSlots, state.counted
	wipe(ids)
	wipe(counts)
	wipe(numSlotsByBag)
	wipe(counted)

	for _, bagID in ipairs(GetContainers(win)) do
		local numSlots = C_Container_GetContainerNumSlots(bagID)
		local isCounted = IsCountedBag(win, bagID)
		numSlotsByBag[bagID] = numSlots
		for slotID = 1, numSlots do
			local info = C_Container_GetContainerItemInfo(bagID, slotID)
			local id = info and (info.hyperlink or info.itemID)
			if id then
				local key = SlotKey(bagID, slotID)
				ids[key] = id
				counts[key] = info.stackCount or 1
				counted[key] = isCounted
			end
		end
	end

	state.used, state.total = used, total
	state.merging = module.AnyItemPanelOpen()
	state.armed = true
end

local function ClearHeldSlot(btn)
	btn.holdCleared = true
	btn.itemID = nil
	btn.itemLink = nil

	-- Same look as an emptied slot in combat (UpdateShownSlotsInPlace):
	-- ItemButtonMixin's SetAlpha only covers icon and count
	btn:SetAlpha(0)
	btn.itemLevel:SetText("")
	btn.bindType:SetText("")
	local borderFrame = btn.iconFrame or btn
	borderFrame:SetBackdropBorderColor(unpack(E.media.bordercolor))

	for _, region in ipairs({
		btn.JunkIcon or false,
		btn.warboundIcon or false,
		btn.pinIcon or false,
		btn.equipIcon or false,
		btn.newItemGlow or false,
		btn.reagentBadge or false,
		btn.UpgradeIcon or false,
		btn.IconQuestTexture or false,
		btn.newBadge or false,
		btn.Cooldown or false,
	}) do
		if region then
			region:Hide()
		end
	end

	-- A pending upgrade arrow check (UpdateUpgradeIcon)
	btn:SetScript("OnUpdate", nil)

	if _G.ClearItemButtonOverlay then
		_G.ClearItemButtonOverlay(btn)
	end
end

-- A merged slot whose own stack is gone points at one of its other stacks,
-- so clicks, tooltip and the secure "use" macro still reach an item
local function MoveHeldSlot(btn, key)
	local bagID = floor(key / 1000)
	local slotID = key - bagID * 1000

	btn.BagID = bagID
	btn.SlotID = slotID
	btn:SetID(slotID)
	btn:SetAttribute("*macrotext2", format("/use %d %d", bagID, slotID))
end

local heldFrame
local function RepaintHeldSlot(btn)
	if btn.ownerFrame ~= heldFrame or btn.holdCleared or btn.isListRow or not (btn.BagID and btn.SlotID) then
		return
	end

	local ownKey = SlotKey(btn.BagID, btn.SlotID)
	local keys = btn.isMerged and btn.holdSlots
	local total, locked, alive = 0, false, nil
	if keys then
		for _, key in ipairs(keys) do
			local count = current[key]
			if count then
				total = total + count
				alive = alive or key
				locked = locked or currentLocked[key] or false
			end
		end
	else
		total = current[ownKey] or 0
		locked = currentLocked[ownKey] or false
	end

	if total == 0 then
		ClearHeldSlot(btn)
		return
	end

	if keys and not current[ownKey] then
		MoveHeldSlot(btn, alive)
	end

	SetItemButtonCount(btn, total)
	SetItemButtonDesaturated(
		btn,
		locked or (btn.JunkIcon and btn.JunkIcon:IsShown() and module.db.effects.desaturateJunk) or false
	)
end

---Called by the refreshes of both windows: true when the pass kept the layout
---and nothing has to be rebuilt
---@param win string "bag" or "bank"
---@return boolean
function module.HoldLayoutPass(win)
	local state = states[win]
	if not (state and state.armed and module.holdEventPass and module.db.keepLayout) then
		return false
	end

	local frame, displayMode = GetWindow(win)
	if
		not frame
		or displayMode == "LIST"
		or module.sortingBags
		or InCombatLockdown()
		or module.AnyItemPanelOpen() ~= state.merging
	then
		return false
	end

	wipe(current)
	wipe(currentLocked)

	local ids, counts = state.ids, state.counts
	for _, bagID in ipairs(GetContainers(win)) do
		local numSlots = C_Container_GetContainerNumSlots(bagID)
		if numSlots ~= state.numSlots[bagID] then
			return false
		end

		for slotID = 1, numSlots do
			local info = C_Container_GetContainerItemInfo(bagID, slotID)
			local id = info and (info.hyperlink or info.itemID)
			if id then
				local key = SlotKey(bagID, slotID)
				local count = info.stackCount or 1
				-- Something came in or moved: rebuild
				if ids[key] ~= id or count > counts[key] then
					return false
				end
				current[key] = count
				if info.isLocked then
					currentLocked[key] = true
				end
			end
		end
	end

	-- Slots that emptied since the last pass leave the snapshot, so an item
	-- that lands there later counts as new and rebuilds
	for key in pairs(ids) do
		if not current[key] then
			ids[key] = nil
			counts[key] = nil
			if state.counted[key] then
				state.used = state.used - 1
			end
			state.counted[key] = nil
		end
	end

	heldFrame = frame
	module.ForEachShownSlot(RepaintHeldSlot)
	heldFrame = nil
	module.RepaintShownCooldowns()

	if frame.titleCountText then
		local searchBagIDs
		if win == "bag" then
			searchBagIDs = module:GetShownBagIDs()
		elseif module.bankTabFilter then
			searchBagIDs = { module.bankTabFilter }
		else
			searchBagIDs = IsBankWarbandView() and module.WarbandBagIDs or module.BankBagIDs
		end
		module.SetTitleCount(frame.titleCountText, state.used, state.total, module.CountSearchHits(searchBagIDs))
		module.SetFillBar(frame, state.used, state.total)
	end

	return true
end
