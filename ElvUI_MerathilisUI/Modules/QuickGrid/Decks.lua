local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_QuickGrid")

local _G = _G
local ipairs, tonumber, type = ipairs, tonumber, type
local tremove = table.remove
local strmatch, strlower, strtrim = strmatch, strlower, strtrim

local C_Item = C_Item
local C_MountJournal = C_MountJournal
local C_Spell = C_Spell
local C_SpellBook = C_SpellBook
local C_ToyBox = C_ToyBox
local GetMacroIndexByName = GetMacroIndexByName
local GetMacroInfo = GetMacroInfo
local GetProfessionInfo = GetProfessionInfo
local GetProfessions = GetProfessions
local PlayerHasToy = PlayerHasToy

-------------------------------------------------------------------------------
--  Cells
--
--  Every deck fills the eight cells around the empty center, clockwise from
--  the top: 1 = N, 2 = NE, 3 = E, 4 = SE, 5 = S, 6 = SW, 7 = W, 8 = NW.
--
--  A cell entry is { kind, id, icon, name, label, inactive }:
--    kind      spell, item, toy, macro, mount, marker or panel
--    inactive  shown greyed out and does nothing (unknown spell, missing item)
--  A nil entry leaves the cell empty.
-------------------------------------------------------------------------------
module.NUM_CELLS = 8

local QUESTION_MARK = 134400
local RANDOM_MOUNT_ICON = "Interface\\Icons\\ACHIEVEMENT_GUILDPERK_MOUNTUP"
local PROFESSIONS_BOOK_ICON = "Interface\\Icons\\INV_Misc_Book_11"
local RAID_TARGET_ICON = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d"

-- World marker that matches raid target icon i (same order ElvUI's raid utility uses)
local WORLD_MARKER_FOR_ICON = { 5, 6, 3, 2, 7, 1, 4, 8 }

-- Mounts with a vendor and repair NPC, and the ones with an auction house, in order of preference
local VENDOR_MOUNTS = { 460, 280, 284, 2237, 1039, 2265 }
local AUCTION_MOUNTS = { 2265, 1039 }

-------------------------------------------------------------------------------
--  Entry builders
-------------------------------------------------------------------------------
local function SpellEntry(spellID, requireKnown)
	local info = C_Spell.GetSpellInfo(spellID)
	if not info then
		return
	end

	local known = not requireKnown or C_SpellBook.IsSpellKnown(spellID)
	return {
		kind = "spell",
		id = spellID,
		icon = info.iconID,
		name = info.name,
		inactive = not known,
	}
end

local function IsToy(itemID)
	return C_ToyBox and C_ToyBox.GetToyInfo(itemID) ~= nil
end

local function ToyEntry(itemID)
	local _, name, icon = C_ToyBox.GetToyInfo(itemID)
	return {
		kind = "toy",
		id = itemID,
		icon = icon or C_Item.GetItemIconByID(itemID) or QUESTION_MARK,
		name = name or C_Item.GetItemNameByID(itemID),
		inactive = not (PlayerHasToy and PlayerHasToy(itemID)),
	}
end

local function ItemEntry(itemID)
	return {
		kind = "item",
		id = itemID,
		icon = C_Item.GetItemIconByID(itemID) or QUESTION_MARK,
		name = C_Item.GetItemNameByID(itemID),
		inactive = C_Item.GetItemCount(itemID) == 0,
	}
end

local function MountEntry(mountID)
	local name, _, icon, _, _, _, _, _, _, shouldHide, isCollected = C_MountJournal.GetMountInfoByID(mountID)
	if not name or shouldHide or not isCollected then
		return
	end

	return { kind = "mount", id = mountID, icon = icon, name = name }
end

local function FirstCollectedMount(list, skip)
	for _, mountID in ipairs(list) do
		if not (skip and skip[mountID]) then
			local entry = MountEntry(mountID)
			if entry then
				return entry
			end
		end
	end
end

local function MacroEntry(name)
	local index = GetMacroIndexByName(name)
	if not index or index == 0 then
		return { kind = "macro", id = name, icon = QUESTION_MARK, name = name, inactive = true }
	end

	local macroName, icon = GetMacroInfo(index)
	return { kind = "macro", id = macroName, icon = icon, name = macroName }
end

-- type and id from the portal flyout's resolvers (hearthstone, Dalaran)
local function TravelItemEntry(kind, id, icon)
	if kind == "spell" then
		return SpellEntry(id)
	end

	local entry = IsToy(id) and ToyEntry(id) or ItemEntry(id)
	entry.icon = icon or entry.icon
	return entry
end

-------------------------------------------------------------------------------
--  Decks
-------------------------------------------------------------------------------
local function ResolveTeleports(cells)
	for i, portal in ipairs(F.PortalFlyout.GetSeasonPortals()) do
		if i > module.NUM_CELLS then
			break
		end

		local entry = SpellEntry(portal.spellID, true)
		if entry then
			entry.label = portal.short
			cells[i] = entry
		end
	end
end

local function ResolveTravel(cells)
	local used = {}
	local function Track(entry)
		if entry and entry.kind == "mount" then
			used[entry.id] = true
		end
		return entry
	end

	cells[1] = { kind = "mount", id = 0, icon = RANDOM_MOUNT_ICON, name = L["Random Favorite Mount"] }
	cells[3] = TravelItemEntry(F.PortalFlyout.ResolveHearthstone())
	cells[7] = TravelItemEntry(F.PortalFlyout.ResolveDalaranHearthstone())
	cells[2] = Track(FirstCollectedMount(AUCTION_MOUNTS))
	cells[5] = Track(FirstCollectedMount(VENDOR_MOUNTS, used))

	-- The remaining cells take the first favorite mounts
	local free = { 8, 4, 6 }
	local mountIDs = C_MountJournal.GetMountIDs()
	for _, mountID in ipairs(mountIDs) do
		if #free == 0 then
			break
		end

		local _, _, _, _, _, _, isFavorite = C_MountJournal.GetMountInfoByID(mountID)
		if isFavorite and not used[mountID] then
			local entry = MountEntry(mountID)
			if entry then
				used[mountID] = true
				cells[free[1]] = entry
				tremove(free, 1)
			end
		end
	end
end

local function ResolveMarkers(cells)
	for i = 1, module.NUM_CELLS do
		cells[i] = {
			kind = "marker",
			id = i,
			world = WORLD_MARKER_FOR_ICON[i],
			icon = RAID_TARGET_ICON:format(i),
			name = _G["RAID_TARGET_" .. i],
		}
	end
end

-- n-th ability of a profession, nil when it has none or only a passive one
local function ProfessionEntry(index, n)
	if not index then
		return
	end

	local _, _, _, _, numSpells, spellOffset = GetProfessionInfo(index)
	if not numSpells or numSpells < n then
		return
	end

	local info = C_SpellBook.GetSpellBookItemInfo(spellOffset + n, Enum.SpellBookSpellBank.Player)
	if not info or info.isPassive or not info.spellID then
		return
	end

	return { kind = "spell", id = info.spellID, icon = info.iconID, name = info.name }
end

local function ResolveProfessions(cells)
	-- Fixed places, so every profession keeps its direction
	local prof1, prof2, archaeology, fishing, cooking = GetProfessions()
	cells[1] = ProfessionEntry(prof1, 1)
	cells[2] = ProfessionEntry(prof1, 2)
	cells[3] = ProfessionEntry(prof2, 1)
	cells[4] = ProfessionEntry(prof2, 2)
	cells[5] = ProfessionEntry(cooking, 1)
	cells[6] = ProfessionEntry(fishing, 1)
	cells[7] = ProfessionEntry(archaeology, 1)
	cells[8] = {
		kind = "panel",
		id = "professionsBook",
		icon = PROFESSIONS_BOOK_ICON,
		name = _G.PROFESSIONS_BUTTON,
	}
end

function module:CustomSlotEntry(slot)
	if type(slot) ~= "table" or not slot.kind then
		return
	end

	if slot.kind == "spell" then
		return SpellEntry(slot.id)
	elseif slot.kind == "item" then
		return ItemEntry(slot.id)
	elseif slot.kind == "toy" then
		return ToyEntry(slot.id)
	elseif slot.kind == "macro" then
		return MacroEntry(slot.id)
	elseif slot.kind == "mount" then
		return MountEntry(slot.id)
	end
end

local function ResolveCustom(cells)
	local slots = E.private.mui.quickGrid.custom
	for i = 1, module.NUM_CELLS do
		cells[i] = module:CustomSlotEntry(slots[i])
	end
end

module.DeckOrder = { "teleports", "travel", "markers", "professions", "custom" }

module.Decks = {
	teleports = {
		name = L["Teleports"],
		desc = L["The Mythic+ dungeon teleports of the current season. Teleports you don't know yet are greyed out."],
		icon = "Interface\\Icons\\Spell_Arcane_TeleportDalaran",
		binding = "MER_QUICKGRID_TELEPORTS",
		available = function()
			return not E.Forever
		end,
		resolve = ResolveTeleports,
	},
	travel = {
		name = L["Travel"],
		desc = L["Random favorite mount (top), hearthstone (right), Dalaran Hearthstone (left), a vendor mount (bottom), an auction house mount (top right) and your first favorite mounts in the free corners."],
		icon = RANDOM_MOUNT_ICON,
		binding = "MER_QUICKGRID_TRAVEL",
		resolve = ResolveTravel,
	},
	markers = {
		name = L["Markers"],
		desc = L["Raid target icons on your target. Hold Shift while you release the key to place the matching world marker instead."],
		icon = RAID_TARGET_ICON:format(1),
		binding = "MER_QUICKGRID_MARKERS",
		resolve = ResolveMarkers,
	},
	professions = {
		name = L["Professions"],
		desc = L["Both professions with their second ability, cooking, fishing and archaeology, always in the same place. The top left opens the professions book."],
		icon = "Interface\\Icons\\INV_Misc_Note_01",
		binding = "MER_QUICKGRID_PROFESSIONS",
		available = function()
			return GetProfessions ~= nil
		end,
		resolve = ResolveProfessions,
	},
	custom = {
		name = L["Custom"],
		desc = L["Eight places of your own for spells, items, toys, macros and mounts. Saved per character."],
		icon = "Interface\\Icons\\INV_Misc_Gear_01",
		binding = "MER_QUICKGRID_CUSTOM",
		resolve = ResolveCustom,
	},
}

function module:IsDeckAvailable(key)
	local deck = self.Decks[key]
	return deck and (not deck.available or deck.available())
end

-- Fresh cells of a deck; nil entries are empty cells
function module:ResolveDeck(key)
	local cells = {}
	self.Decks[key].resolve(cells)
	return cells
end

-------------------------------------------------------------------------------
--  Custom slot input
--  Accepts what the options edit box receives by drag and drop (item link,
--  spell name, macro name) as well as typed names of spells, macros, mounts,
--  toys and items. Returns the slot table to save, or nil.
-------------------------------------------------------------------------------
local function ItemSlot(itemID)
	if IsToy(itemID) then
		return { kind = "toy", id = itemID }
	end
	return { kind = "item", id = itemID }
end

local function FindMountByName(text)
	text = strlower(text)
	for _, mountID in ipairs(C_MountJournal.GetMountIDs()) do
		local name = C_MountJournal.GetMountInfoByID(mountID)
		if name and strlower(name) == text then
			return mountID
		end
	end
end

function module:ParseSlotText(text)
	text = strtrim(text or "")
	if text == "" then
		return
	end

	local itemID = tonumber(strmatch(text, "item:(%d+)"))
	if itemID then
		return ItemSlot(itemID)
	end

	local spellID = tonumber(strmatch(text, "spell:(%d+)"))
	if spellID then
		return { kind = "spell", id = spellID }
	end

	local macroIndex = GetMacroIndexByName(text)
	if macroIndex and macroIndex > 0 then
		return { kind = "macro", id = GetMacroInfo(macroIndex) }
	end

	local spellInfo = C_Spell.GetSpellInfo(text)
	if spellInfo and spellInfo.spellID then
		-- Mount spells are found by name too, but only summon through the journal
		local mountID = C_MountJournal.GetMountFromSpell(spellInfo.spellID)
		if mountID then
			return { kind = "mount", id = mountID }
		end
		return { kind = "spell", id = spellInfo.spellID }
	end

	local mountID = FindMountByName(text)
	if mountID then
		return { kind = "mount", id = mountID }
	end

	itemID = C_Item.GetItemInfoInstant(text)
	if itemID then
		return ItemSlot(itemID)
	end
end

-- Text shown in the options for a saved slot
function module:SlotText(slot)
	local entry = self:CustomSlotEntry(slot)
	return entry and entry.name or ""
end
