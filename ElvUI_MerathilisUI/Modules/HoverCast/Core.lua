local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_HoverCast")
local UF = E:GetModule("UnitFrames")

-------------------------------------------------------------------------------
--  Click-casting: per-spec bindings + global target/menu/macro defaults.
--  Two paths: (1) Frame-based -- WrapScript OnEnter/OnLeave sets keyboard
--  bindings via SetBindingClick; clicks use direct attribute setting.
--  (2) Hovercast -- persistent bindings on a dedicated secure button
--  targeting @mouseover, friend/harm filtered via macro conditionals.
--
--  Frames arrive through the global ClickCastFrames table (oUF registers every
--  ElvUI unit frame there). ElvUI's party/raid frames are always handled, every
--  other unit frame (ElvUI single units, Blizzard frames) only with
--  "All Unit Frames".
-------------------------------------------------------------------------------

local _G = _G
local pairs, ipairs, type, pcall = pairs, ipairs, type, pcall
local tinsert, tremove, tconcat, wipe = table.insert, table.remove, table.concat, wipe
local format, tostring, tonumber = string.format, tostring, tonumber
local setmetatable = setmetatable

local CreateFrame = CreateFrame
local UIParent = UIParent
local GetInventoryItemID = GetInventoryItemID
local GetInventoryItemTexture = GetInventoryItemTexture
local GetMacroBody = GetMacroBody
local GetMacroIndexByName = GetMacroIndexByName
local GetMacroInfo = GetMacroInfo
local GetNumMacros = GetNumMacros
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsInGroup = IsInGroup
local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local IsShiftKeyDown = IsShiftKeyDown
local RegisterAttributeDriver = RegisterAttributeDriver
local RegisterStateDriver = RegisterStateDriver
local UnitClass = UnitClass
local UnitGUID = UnitGUID
local UnregisterAttributeDriver = UnregisterAttributeDriver
local UnregisterStateDriver = UnregisterStateDriver
local hooksecurefunc = hooksecurefunc
local issecretvalue = issecretvalue

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_Container = C_Container
local C_Item = C_Item
local C_Spell = C_Spell
local C_SpellBook = C_SpellBook
local C_Timer_NewTicker = C_Timer.NewTicker

local MAX_ACCOUNT_MACROS = _G.MAX_ACCOUNT_MACROS or 120

-------------------------------------------------------------------------------
--  Constants
-------------------------------------------------------------------------------
local MODIFIER_KEYS = {
	LSHIFT = true,
	RSHIFT = true,
	LCTRL = true,
	RCTRL = true,
	LALT = true,
	RALT = true,
	LMETA = true,
	RMETA = true,
}
module.MODIFIER_KEYS = MODIFIER_KEYS

local MOUSE_BUTTON_MAP = {
	LeftButton = "BUTTON1",
	RightButton = "BUTTON2",
	MiddleButton = "BUTTON3",
	Button4 = "BUTTON4",
	Button5 = "BUTTON5",
}
module.MOUSE_BUTTON_MAP = MOUSE_BUTTON_MAP

local ACTION_ICONS = {
	target = 132212,
	menu = 5341597,
	macro = 134400,
	dispel = 135894, -- Dispel Magic icon
	external = 135966, -- Blessing of Sacrifice icon
}

-- Dispel spells by class (friendly dispels only). One entry per spec that has a
-- distinct spell; ClassPresetSpells drops the ones this character has not got
-- before they reach the macro.
local DISPEL_SPELLS = {
	{ id = 527, name = "Purify", class = "PRIEST" }, -- Disc & Holy
	{ id = 213634, name = "Purify Disease", class = "PRIEST" }, -- Shadow
	{ id = 115450, name = "Detox", class = "MONK" }, -- Mistweaver
	{ id = 218164, name = "Detox", class = "MONK" }, -- Brewmaster & Windwalker
	{ id = 4987, name = "Cleanse", class = "PALADIN" }, -- Holy
	{ id = 213644, name = "Cleanse Toxins", class = "PALADIN" }, -- Prot & Ret (Cleanse is Holy-only)
	{ id = 88423, name = "Nature's Cure", class = "DRUID" }, -- Resto
	{ id = 2782, name = "Remove Corruption", class = "DRUID" }, -- Guardian, Feral & Balance
	{ id = 77130, name = "Purify Spirit", class = "SHAMAN" }, -- Resto
	{ id = 51886, name = "Cleanse Spirit", class = "SHAMAN" }, -- Ele & Enh
	{ id = 360823, name = "Naturalize", class = "EVOKER" }, -- Pres
	{ id = 365585, name = "Expunge", class = "EVOKER" }, -- Aug & Dev
	{ id = 89808, name = "Singe Magic", class = "WARLOCK", pet = true }, -- Imp
	{ id = 475, name = "Remove Curse", class = "MAGE" }, -- All specs (Curse only)
}

-- External defensive spells by class
local EXTERNAL_SPELLS = {
	{ id = 33206, name = "Pain Suppression", class = "PRIEST" }, -- Disc
	{ id = 47788, name = "Guardian Spirit", class = "PRIEST" }, -- Holy
	{ id = 102342, name = "Ironbark", class = "DRUID" }, -- Resto
	{ id = 6940, name = "Blessing of Sacrifice", class = "PALADIN" },
	{ id = 357170, name = "Time Dilation", class = "EVOKER" }, -- Pres
	{ id = 116849, name = "Life Cocoon", class = "MONK" }, -- Mistweaver
}

-- Resurrection spells by class: single (ooc), group (ooc), battle (combat)
local REZ_BY_CLASS = {
	PRIEST = { single = 2006, group = 212036 },
	PALADIN = { single = 7328, group = 212056, battle = 391054 },
	SHAMAN = { single = 2008, group = 212048 },
	DRUID = { single = 50769, group = 212040, battle = 20484 },
	MONK = { single = 115178, group = 212051 },
	EVOKER = { single = 361227, group = 361178 },
	DEATHKNIGHT = { battle = 61999 },
	WARLOCK = { battle = 20707 },
}

-- WoW Forever: the vanilla spells. An entry's alts are its higher ranks and a
-- rez slot lists every rank ID, rank 1 first; /cast by name casts the highest
-- rank the character knows. Each class's dispels run in priority order (the
-- first known line fires), Paladin is the only class with an external, and
-- there is no group rez and no Warlock entry.
if E.Forever then
	DISPEL_SPELLS = {
		{ id = 527, name = "Dispel Magic", class = "PRIEST", alts = { 988 } },
		{ id = 552, name = "Abolish Disease", class = "PRIEST" },
		{ id = 528, name = "Cure Disease", class = "PRIEST" },
		{ id = 4987, name = "Cleanse", class = "PALADIN" },
		{ id = 1152, name = "Purify", class = "PALADIN" }, -- before Cleanse is learned
		{ id = 2782, name = "Remove Curse", class = "DRUID" },
		{ id = 2893, name = "Abolish Poison", class = "DRUID" },
		{ id = 8946, name = "Cure Poison", class = "DRUID" },
		{ id = 526, name = "Cure Poison", class = "SHAMAN" },
		{ id = 2870, name = "Cure Disease", class = "SHAMAN" },
		{ id = 475, name = "Remove Lesser Curse", class = "MAGE" },
		{ id = 19505, name = "Devour Magic", class = "WARLOCK", pet = true, alts = { 19731, 19734, 19736 } }, -- Felhunter
	}
	EXTERNAL_SPELLS = {
		{ id = 6940, name = "Blessing of Sacrifice", class = "PALADIN", alts = { 20729 } },
		{ id = 1022, name = "Blessing of Protection", class = "PALADIN", alts = { 5599, 10278 } },
	}
	REZ_BY_CLASS = {
		PRIEST = { single = { 2006, 2010, 10880, 10881, 20770 } },
		PALADIN = { single = { 7328, 10322, 10324, 20772, 20773 } },
		SHAMAN = { single = { 2008, 20609, 20610, 20776, 20777 } },
		DRUID = { battle = { 20484, 20739, 20742, 20747, 20748 } },
	}
end

-- This class's preset entries, narrowed to what the character can cast. A /cast
-- line naming a spell they have not got matches its condition and then casts
-- nothing, eating the fallback the next line was there to be, so an unavailable
-- entry has to be dropped rather than ordered last. Empty falls back to the
-- unfiltered list: the book can lag the first apply at login, so "nothing
-- available" is as likely stale as true, and an all-unknown list shadows
-- nothing anyway. Pet spells are exempt -- the pet book holds only the
-- summoned demon's spells.
local function ClassPresetSpells(spellList, class)
	local bank = Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player
	local canCheck = C_SpellBook.IsSpellInSpellBook and bank
	local usable, all = {}, {}
	for _, sp in ipairs(spellList) do
		if sp.class == class then
			all[#all + 1] = sp
			if sp.pet or not canCheck or C_SpellBook.IsSpellInSpellBook(sp.id, bank, true) then
				usable[#usable + 1] = sp
			end
		end
	end
	return #usable > 0 and usable or all
end

-- Every rez spell ID across all classes; exempt from the exists/nodead corpse
-- filter in macro building (corpses are a rez's only valid target). A kit slot
-- holds one spell ID or a list of rank IDs.
local REZ_SPELL_IDS = {}
for _, kit in pairs(REZ_BY_CLASS) do
	for _, slot in pairs(kit) do
		if type(slot) == "table" then
			for _, sid in ipairs(slot) do
				REZ_SPELL_IDS[sid] = true
			end
		else
			REZ_SPELL_IDS[slot] = true
		end
	end
end

-- The names of this class's preset spells (dispels, externals or every rez
-- slot), used by the options page to dim spells a preset already casts
function module:GetPresetSpellNames(kind)
	local _, class = UnitClass("player")
	local names = {}
	if kind == "dispel" or kind == "external" then
		local list = kind == "dispel" and DISPEL_SPELLS or EXTERNAL_SPELLS
		for _, sp in ipairs(ClassPresetSpells(list, class)) do
			-- The localized name, as stored by the spell picker
			names[#names + 1] = (C_Spell.GetSpellName and C_Spell.GetSpellName(sp.id)) or sp.name
		end
	elseif kind == "dynamicrez" then
		local kit = REZ_BY_CLASS[class]
		if kit then
			for _, slot in pairs(kit) do
				-- Every rank of a slot shares one name
				local sid = type(slot) == "table" and slot[1] or slot
				local name = C_Spell.GetSpellName and C_Spell.GetSpellName(sid)
				if name then
					names[#names + 1] = name
				end
			end
		end
	end
	return names
end

-- True when a binding is a rez spell (by stored ID, with a name fallback for
-- bindings without a stored ID). The fallback name set is cached once: per
-- binding/per frame GetSpellName calls during a registration burst add up.
local rezNames
local function RezNameSet()
	if rezNames then
		return rezNames
	end
	if not (C_Spell and C_Spell.GetSpellName) then
		return nil
	end
	local set, resolved = {}, false
	for sid in pairs(REZ_SPELL_IDS) do
		local n = C_Spell.GetSpellName(sid)
		if n then
			set[n] = true
			resolved = true
		end
	end
	-- Only latch the cache once something resolved: spell data can be cold this
	-- early in login, and freezing an empty set would break the fallback for good
	if resolved then
		rezNames = set
	end
	return set
end

local function IsRezSpellBinding(binding)
	if type(binding.spellID) == "number" and REZ_SPELL_IDS[binding.spellID] then
		return true
	end
	local bn = binding.spell
	if type(bn) == "string" then
		local names = RezNameSet()
		return names ~= nil and names[bn] == true
	end
	return false
end

local KEY_DISPLAY = {
	BUTTON1 = L["Left Click"],
	BUTTON2 = L["Right Click"],
	BUTTON3 = L["Middle Click"],
	BUTTON4 = L["Mouse 4"],
	BUTTON5 = L["Mouse 5"],
	MOUSEWHEELUP = L["Wheel Up"],
	MOUSEWHEELDOWN = L["Wheel Down"],
}

-------------------------------------------------------------------------------
--  State
-------------------------------------------------------------------------------
local header = nil -- SecureHandlerStateTemplate (frame bindings + mer_cc driver)
local bindProxy = nil -- SecureActionButtonTemplate (unnamed frame fallback)
local globalBtn = nil -- SecureActionButtonTemplate (hovercast bindings)
local registeredFrames = {}
local ownedFrames = {}
-- Captures each frame's native click attributes on first register, so
-- DoUnregisterFrame restores them exactly. Weak-keyed so dead frames drop out.
local originalAttrs = setmetatable({}, { __mode = "k" })
local regQueue = {}
local unregQueue = {}
local pendingApply = false
local lastRosterCtx = nil -- content gate: last context a roster update saw
local ccInitialized = false
local lastBindingCount = 0
local lastHoverCount = 0
local pendingSetEnabled = nil -- deferred SetEnabled value when toggled in combat

-------------------------------------------------------------------------------
--  Data access
-------------------------------------------------------------------------------
-- Account-wide like the Blizzard keybindings, and created lazily instead of
-- living in the G defaults: the global binding list is an array, and AceDB
-- would copy a deleted default entry right back in on the next login.
local function GetClickCastDB()
	local db = E.global and E.global.mui
	if not db then
		return nil
	end
	if not db.hoverCast then
		db.hoverCast = {
			enabled = false,
			allFrames = true,
			downClick = true,
			specs = {},
			globals = {
				{ key = "BUTTON1", type = "target", enabled = true },
				{ key = "BUTTON2", type = "menu", enabled = true },
				{ type = "dispel", enabled = true },
				{ type = "dynamicrez", enabled = true },
				{ type = "external", enabled = true },
				{ type = "trinket1", enabled = true },
				{ type = "trinket2", enabled = true },
			},
		}
	end
	return db.hoverCast
end

-- Clique binds clicks on the same frames, so the two can never run together
local function IsCliqueLoaded()
	return C_AddOns_IsAddOnLoaded("Clique") and true or false
end

local function GetCurrentSpecID()
	local _, specID = F.GetPlayerSpec()
	return specID
end

local function GetSpecBindings(specID)
	local cc = GetClickCastDB()
	if not cc then
		return {}
	end
	specID = specID or GetCurrentSpecID()
	if specID and cc.specs[specID] then
		return cc.specs[specID]
	end
	return {}
end

local function GetGlobalBindings()
	local cc = GetClickCastDB()
	return cc and cc.globals or {}
end

-- Content gate. binding.groupCtx is the set of contexts a binding is active in.
-- In a context that is switched off the binding is never applied so the key falls
-- through to whatever the player normally has bound.
local CC_CTX_ORDER = { "solo", "party", "raid", "pvp" }
module.CTX_ORDER = CC_CTX_ORDER

local function CtxEnabled(binding, ctx)
	local set = binding.groupCtx
	if not set then
		return true
	end
	return set[ctx] == true
end

-- The context the player is in right now
local function CurrentCtx()
	local _, instType = IsInInstance()
	if instType == "pvp" or instType == "arena" then
		return "pvp"
	end
	if IsInRaid() then
		return "raid"
	end
	if IsInGroup() then
		return "party"
	end
	return "solo"
end

-- True when a binding's content gate matches the context the player is in now
local function MatchesGroupCtx(binding)
	return CtxEnabled(binding, CurrentCtx())
end

-- Hovercast mode. binding.hovercast is:
--   false / nil -> frame clicks only (attributes live on the unit frames)
--   true        -> the global @mouseover override button only
--   "both"      -> applied through BOTH paths
local function IsHoverBinding(binding)
	return binding.hovercast and true or false
end

local function IsFrameBinding(binding)
	return not binding.hovercast or binding.hovercast == "both"
end

local function GetBindingUnitType(binding)
	local friendly, enemy = binding.hoverFriendly, binding.hoverEnemy
	if friendly == false and enemy == false then
		return "none"
	end
	-- The Friendly toggle is default-on in the UI, so an omitted value is
	-- friendly unless Enemy is explicitly enabled as well. Enemy is opt-in.
	friendly = friendly ~= false
	enemy = enemy == true
	if friendly and not enemy then
		return "friendly"
	end
	if enemy and not friendly then
		return "harmful"
	end
	return "both"
end

-- Two spell bindings may share a key when their Friendly/Enemy toggles select
-- opposite reactions. Combine those branches into one macro.
local function IsReactionBinding(binding)
	return binding
		and (binding.type == "spell" or binding.type == "item" or (binding.type == "macro" and binding.hovercast))
end

local function IsBindingActive(binding)
	return binding.enabled ~= false and (not IsReactionBinding(binding) or GetBindingUnitType(binding) ~= "none")
end

-- A spell binding the character cannot cast right now (the other options of a
-- choice node, a talent swapped out, a loadout without it) stays saved -- the
-- next loadout may bring it back -- but it cannot own a key against a spell
-- they do have, raises no conflict warning, and its tile dims. Pet-book spells
-- read as unknown from the player book, so the preset pet spells are exempt,
-- and a binding with no stored id cannot be judged, so it counts as known.
local PET_SPELL_IDS = {}
for _, sp in ipairs(DISPEL_SPELLS) do
	if sp.pet then
		PET_SPELL_IDS[sp.id] = true
		if sp.alts then
			for _, alt in ipairs(sp.alts) do
				PET_SPELL_IDS[alt] = true
			end
		end
	end
end

local function IsSpellIDKnown(id)
	if type(id) ~= "number" or id <= 0 or PET_SPELL_IDS[id] then
		return true
	end
	local bank = Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player
	if not (C_SpellBook.IsSpellInSpellBook and bank) then
		return true
	end
	if C_SpellBook.IsSpellInSpellBook(id, bank, true) then
		return true
	end
	-- The saved id may be an override of a base spell the book lists instead
	local baseId = C_Spell.GetBaseSpell and C_Spell.GetBaseSpell(id)
	if type(baseId) == "number" and baseId > 0 and baseId ~= id then
		return C_SpellBook.IsSpellInSpellBook(baseId, bank, true) and true or false
	end
	return false
end

local function IsBindingKnown(binding)
	if not binding then
		return false
	end
	if binding.type == "spell" then
		if IsSpellIDKnown(binding.spellID) then
			return true
		end
		return binding.harmfulSpellID ~= nil and IsSpellIDKnown(binding.harmfulSpellID)
	elseif binding.type == "reaction" then
		return IsBindingKnown(binding.friendlyAction) or IsBindingKnown(binding.harmfulAction)
	end
	return true
end

local function AreComplementaryReactionBindings(a, b)
	if not IsReactionBinding(a) or not IsReactionBinding(b) or a.key ~= b.key or a.harmfulSpell or b.harmfulSpell then
		return false
	end
	if
		not (
			(a.type == "spell" and (b.type == "spell" or b.type == "item")) or (a.type == "item" and b.type == "spell")
		)
	then
		return false
	end
	if
		not ((IsFrameBinding(a) and IsFrameBinding(b)) or (IsHoverBinding(a) and IsHoverBinding(b)))
		or (a.oocOnly or false) ~= (b.oocOnly or false)
	then
		return false
	end
	local aReaction, bReaction = GetBindingUnitType(a), GetBindingUnitType(b)
	return (aReaction == "friendly" and bReaction == "harmful") or (aReaction == "harmful" and bReaction == "friendly")
end

local function AreComplementarySpellBindings(a, b)
	if not a or not b or a.type ~= "spell" or b.type ~= "spell" then
		return false
	end
	return AreComplementaryReactionBindings(a, b)
end

local function MergeComplementarySpellBindings(bindings)
	local result = {}
	for _, binding in ipairs(bindings) do
		local merged = false
		for i, previous in ipairs(result) do
			if AreComplementarySpellBindings(previous, binding) then
				local friendly = GetBindingUnitType(previous) == "friendly" and previous or binding
				local harmful = friendly == previous and binding or previous
				local combined = {}
				for key, value in pairs(friendly) do
					combined[key] = value
				end
				combined.harmfulSpell = harmful.spell
				combined.harmfulSpellID = harmful.spellID
				combined.harmfulIcon = harmful.icon
				combined.harmfulRankPinned = harmful.rankPinned
				combined.hoverFriendly = true
				combined.hoverEnemy = true
				combined.smartRez = friendly.smartRez or harmful.smartRez
				result[i] = combined
				merged = true
				break
			end
		end
		if not merged then
			result[#result + 1] = binding
		end
	end
	return result
end

-- A spell and an equipped item can safely share a complementary reaction key by
-- becoming one macro. Custom macro bodies remain separate because their actions
-- cannot be safely nested behind a reaction conditional.
local function MergeComplementaryItemSpellBindings(bindings)
	local result = {}
	for _, binding in ipairs(bindings) do
		local merged = false
		for i, previous in ipairs(result) do
			if AreComplementaryReactionBindings(previous, binding) and previous.type ~= binding.type then
				local friendly = GetBindingUnitType(previous) == "friendly" and previous or binding
				local harmful = friendly == previous and binding or previous
				local spell = friendly.type == "spell" and friendly or harmful
				result[i] = {
					type = "reaction",
					key = friendly.key,
					hovercast = friendly.hovercast,
					oocOnly = friendly.oocOnly,
					friendlyAction = friendly,
					harmfulAction = harmful,
					smartRez = friendly.smartRez or harmful.smartRez,
					spell = spell.spell,
					spellID = spell.spellID,
				}
				merged = true
				break
			end
		end
		if not merged then
			result[#result + 1] = binding
		end
	end
	return result
end

-- A binding configured for both dispatch paths must participate in each path's
-- merge/conflict resolution separately. This is only a runtime projection: the
-- saved binding remains a single entry in the editor.
local function ExpandBothPathBindings(bindings)
	local result = {}
	for _, binding in ipairs(bindings) do
		if binding.hovercast == "both" then
			local frameBinding, hoverBinding = {}, {}
			for key, value in pairs(binding) do
				frameBinding[key] = value
				hoverBinding[key] = value
			end
			frameBinding.hovercast = false
			hoverBinding.hovercast = true
			result[#result + 1] = frameBinding
			result[#result + 1] = hoverBinding
		else
			result[#result + 1] = binding
		end
	end
	return result
end

-- A warning may remain for two same-reaction bindings, but only one secure
-- action can own a key. Mergeable opposite-reaction spell/item pairs have
-- already become one macro; any remaining same-key action would overwrite the
-- secure attribute, so keep the first resolved action so a later conflict
-- cannot overwrite a valid complementary spell pair. The one exception: a
-- spell the character has not got casts nothing, so a same-key action they do
-- have takes the key off it.
local function FilterConflictingBindings(bindings)
	local result = {}
	for _, binding in ipairs(bindings) do
		local conflicts = false
		for i, previous in ipairs(result) do
			if
				binding.key == previous.key
				and (
					(IsFrameBinding(binding) and IsFrameBinding(previous))
					or (IsHoverBinding(binding) and IsHoverBinding(previous))
				)
			then
				conflicts = true
				if not IsBindingKnown(previous) and IsBindingKnown(binding) then
					result[i] = binding
				end
				break
			end
		end
		if not conflicts then
			result[#result + 1] = binding
		end
	end
	return result
end

-- Merges globals + current spec (spec wins key conflicts, unless the spec
-- spell is one the character has not got: the global then competes for the key
-- and the conflict filter hands it over); only enabled bindings; gated on the
-- master enable toggle.
local function GetActiveBindings()
	local cc = GetClickCastDB()
	if not cc or not cc.enabled or IsCliqueLoaded() then
		return {}
	end
	local result, usedKeys, specBindings = {}, {}, {}
	for _, b in ipairs(GetSpecBindings()) do
		if IsBindingActive(b) and b.key and MatchesGroupCtx(b) then
			result[#result + 1] = b
			specBindings[#specBindings + 1] = b
			if IsBindingKnown(b) then
				usedKeys[b.key] = true
			end
		end
	end
	for _, b in ipairs(cc.globals) do
		local keepGlobal = not usedKeys[b.key]
		if not keepGlobal then
			for _, specBinding in ipairs(specBindings) do
				if AreComplementaryReactionBindings(specBinding, b) then
					keepGlobal = true
					break
				end
			end
		end
		if IsBindingActive(b) and b.key and keepGlobal and MatchesGroupCtx(b) then
			result[#result + 1] = b
		end
	end
	result = ExpandBothPathBindings(result)
	result = MergeComplementarySpellBindings(result)
	result = MergeComplementaryItemSpellBindings(result)
	return FilterConflictingBindings(result)
end

-- Talent and loadout swaps change which saved spells the character has got,
-- and SPELLS_CHANGED is their edge (it also fires on every zone-in and spell
-- learn). Only the known/unknown pattern of the enabled spell bindings decides
-- a key, so an event that leaves the pattern as applied re-applies nothing,
-- and the event is listened for only while an enabled spell binding exists.
local knownSig = ""
local sigParts = {}
local function ComputeKnownSignature()
	local cc = GetClickCastDB()
	if not cc or not cc.enabled then
		return ""
	end
	wipe(sigParts)
	for _, b in ipairs(GetSpecBindings()) do
		if b.type == "spell" and b.key and IsBindingActive(b) then
			sigParts[#sigParts + 1] = IsBindingKnown(b) and "1" or "0"
		end
	end
	for _, b in ipairs(cc.globals) do
		if b.type == "spell" and b.key and IsBindingActive(b) then
			sigParts[#sigParts + 1] = IsBindingKnown(b) and "1" or "0"
		end
	end
	return tconcat(sigParts)
end

-------------------------------------------------------------------------------
--  Key utilities
-------------------------------------------------------------------------------
-- WoW matches bindings/clicks in ALT-CTRL-SHIFT order. A non-canonical order
-- silently fails to match on double-modifier binds.
local function GetModifierPrefix()
	local p = ""
	if IsAltKeyDown() then
		p = p .. "ALT-"
	end
	if IsControlKeyDown() then
		p = p .. "CTRL-"
	end
	if IsShiftKeyDown() then
		p = p .. "SHIFT-"
	end
	return p
end

-- Parses "ALT-CTRL-SHIFT-KEY": modifiers are peeled from the FRONT as known
-- prefixes (never split on "-") because the key itself can BE "-" (minus key).
local function ParseKeyString(keyStr)
	if not keyStr or keyStr == "" then
		return { modifiers = "", key = "", isMouseButton = false, buttonNum = nil, full = keyStr or "" }
	end
	local rest, mods = keyStr, ""
	while true do
		local pre = (rest:sub(1, 4) == "ALT-" and "ALT-")
			or (rest:sub(1, 5) == "CTRL-" and "CTRL-")
			or (rest:sub(1, 6) == "SHIFT-" and "SHIFT-")
			or (rest:sub(1, 5) == "META-" and "META-")
		if pre and #rest > #pre then
			mods = mods .. pre
			rest = rest:sub(#pre + 1)
		else
			break
		end
	end
	local key = rest
	local isMouse = key:match("^BUTTON%d+$") or key == "MOUSEWHEELUP" or key == "MOUSEWHEELDOWN"
	local btnNum = key:match("^BUTTON(%d+)$")
	return {
		modifiers = mods,
		key = key,
		isMouseButton = isMouse ~= nil,
		buttonNum = btnNum and tonumber(btnNum),
		full = keyStr,
	}
end

function module:GetModifierPrefix()
	return GetModifierPrefix()
end

function module:CaptureKey(rawKey)
	if MODIFIER_KEYS[rawKey] or rawKey == "ESCAPE" or rawKey == "UNKNOWN" then
		return nil
	end
	local key = MOUSE_BUTTON_MAP[rawKey] or rawKey:upper()
	return GetModifierPrefix() .. key
end

function module:FormatKey(keyStr)
	if not keyStr or keyStr == "" then
		return ""
	end
	local parsed = ParseKeyString(keyStr)
	local display = {}
	for m in parsed.modifiers:gmatch("([^-]+)") do
		display[#display + 1] = m == "SHIFT" and "Shift" or m == "CTRL" and "Ctrl" or m == "ALT" and "Alt" or m
	end
	display[#display + 1] = KEY_DISPLAY[parsed.key] or parsed.key
	return tconcat(display, " + ")
end

-- Heals saved keys with non-canonical modifier order. Rewrites DB tables in
-- place; no-op once canonical.
local function NormalizeSavedBindingKeys()
	local cc = GetClickCastDB()
	if not cc then
		return
	end
	local function canon(b)
		if not b.key or b.key == "" then
			return
		end
		local parsed = ParseKeyString(b.key)
		if parsed.modifiers == "" then
			return
		end
		local p = ""
		if parsed.modifiers:find("ALT-", 1, true) then
			p = p .. "ALT-"
		end
		if parsed.modifiers:find("CTRL-", 1, true) then
			p = p .. "CTRL-"
		end
		if parsed.modifiers:find("SHIFT-", 1, true) then
			p = p .. "SHIFT-"
		end
		if parsed.modifiers:find("META-", 1, true) then
			p = p .. "META-"
		end
		local canonical = p .. parsed.key
		if canonical ~= b.key then
			b.key = canonical
		end
	end
	if cc.specs then
		for _, list in pairs(cc.specs) do
			if type(list) == "table" then
				for _, b in ipairs(list) do
					canon(b)
				end
			end
		end
	end
	if cc.globals then
		for _, b in ipairs(cc.globals) do
			canon(b)
		end
	end
end

-------------------------------------------------------------------------------
--  Macro / spell helpers
-------------------------------------------------------------------------------
-- Macrotext: spells wrap @mouseover+friend/harm+nocombat; macros read the saved
-- body (+ optional /stopmacro [combat]). MOUNT_GUARD appends to hovercast
-- conditionals so overrides don't eat keypresses while dragonriding/in vehicles.
local MOUNT_GUARD = ",nomounted,noflying"

-- Resolves a spell binding to its BASE spell NAME (via stored spellID): casting the
-- base name auto-resolves to whatever talent/hero-talent/proc override is active, while
-- casting the override name directly fails without it.
local function ResolveCastSpellName(binding)
	local id = binding.spellID
	if type(id) == "number" and id > 0 and C_Spell and C_Spell.GetBaseSpell then
		local baseId = C_Spell.GetBaseSpell(id)
		if type(baseId) == "number" and baseId > 0 and baseId ~= id then
			local n = C_Spell.GetSpellName and C_Spell.GetSpellName(baseId)
			if n then
				return n
			end
		end
	end
	return binding.spell
end

local function ResolveHarmfulSpellName(binding)
	local id = binding.harmfulSpellID
	if type(id) == "number" and id > 0 and C_Spell and C_Spell.GetBaseSpell then
		local baseId = C_Spell.GetBaseSpell(id)
		if type(baseId) == "number" and baseId > 0 and baseId ~= id then
			local name = C_Spell.GetSpellName and C_Spell.GetSpellName(baseId)
			if name then
				return name
			end
		end
	end
	return binding.harmfulSpell
end

-- WoW Forever spell ranks: /cast by name always casts the highest rank the
-- character knows, so a binding picked from a LOWER rank (binding.rankPinned,
-- its spellID is that rank; harmfulRankPinned for a merged harmful half) casts
-- through a hidden per-rank proxy button instead: CastSpellByID on the exact
-- rank, reached by a "/click [conditions] <proxy>" line so every macro
-- condition still applies. A binding picked from the top rank stays unpinned
-- and follows the highest rank as the character learns more. Retail never sets
-- or reads it.
local RANKS = E.Forever == true
module.RANKS = RANKS
local rankProxies = {}

local function PinnedRankID(binding, harmful)
	if not RANKS then
		return nil
	end
	local id
	if harmful then
		id = binding.harmfulRankPinned and binding.harmfulSpellID
	else
		id = binding.rankPinned and binding.spellID
	end
	if type(id) == "number" and id > 0 then
		return id
	end
	return nil
end

-- The proxy's global name is deterministic, so a macro can name it before the
-- button exists. Built out of combat only; every caller writes secure
-- attributes, which are out-of-combat writes themselves.
local function RankProxyName(id)
	local name = "MER_HoverCastRank" .. id
	if not rankProxies[id] and not InCombatLockdown() then
		local p = CreateFrame("Button", name, UIParent, "SecureActionButtonTemplate")
		p:SetSize(1, 1)
		p:SetAlpha(0)
		p:EnableMouse(false)
		p:RegisterForClicks("AnyUp")
		p:SetAttribute("type", "spell")
		for i = 1, 5 do
			p:SetAttribute("type" .. i, "spell")
		end
		p:SetAttribute("spell", id)
		p:SetAttribute("unit", "mouseover")
		-- Act on the up-click the /click delivers, whatever the cast-on-key-down setting
		p:SetAttribute("useOnKeyDown", false)
		rankProxies[id] = p
	end
	return name
end

-- One cast line for a spell binding (harmful = its merged harmful half) under
-- the bracketed condition string condStr: /cast by name, or /click to the
-- rank proxy while that half is pinned to a rank. Nil when there is no spell.
local function SpellCastLine(binding, condStr, harmful)
	local id = PinnedRankID(binding, harmful)
	if id then
		return "/click " .. condStr .. " " .. RankProxyName(id)
	end
	local name
	if harmful then
		name = ResolveHarmfulSpellName(binding)
	else
		name = ResolveCastSpellName(binding)
	end
	if not name then
		return nil
	end
	return "/cast " .. condStr .. " " .. name
end

-- The rank a pinned WoW Forever binding casts ("Rank 2"), for display; nil for
-- every other binding and while the spell's text is not loaded
function module:GetBindingRankText(b)
	local id = b and b.type == "spell" and PinnedRankID(b)
	if not id then
		return nil
	end
	local sub = C_Spell.GetSpellSubtext and C_Spell.GetSpellSubtext(id)
	if sub and sub ~= "" then
		return sub
	end
	return nil
end

-- The "already bound" key of a spell picker entry or binding: a pinned WoW
-- Forever rank dims only its own rank, anything else its name
function module:SpellBoundKey(id, name, pinned)
	if RANKS and pinned and id then
		return "#" .. id
	end
	return name
end

-- True when a picker entry is already bound: by its own key, or (WoW Forever)
-- by a binding pinned to exactly this rank -- bindings are account-wide, so
-- another character's lower rank can be this one's top rank
function module:IsSpellBound(set, id, name, lowRank)
	return set[self:SpellBoundKey(id, name, lowRank)] or (RANKS and id and set["#" .. id]) or false
end

local function BuildReactionMacroText(binding, guard)
	local lines = {}
	local function AddAction(part, reaction)
		if part.type == "spell" then
			local conds = { "@mouseover", reaction }
			if not IsRezSpellBinding(part) then
				conds[#conds + 1] = "exists"
				conds[#conds + 1] = "nodead"
			end
			if binding.oocOnly then
				conds[#conds + 1] = "nocombat"
			end
			local line = SpellCastLine(part, "[" .. tconcat(conds, ",") .. guard .. "]")
			if not line then
				return
			end
			lines[#lines + 1] = line
		elseif part.type == "item" then
			local target = part.itemSlot or part.itemName
			if not target then
				return
			end
			local conds = { "@mouseover", reaction, "exists", "nodead" }
			if binding.oocOnly then
				conds[#conds + 1] = "nocombat"
			end
			lines[#lines + 1] = "/use [" .. tconcat(conds, ",") .. guard .. "] " .. target
		end
	end
	AddAction(binding.friendlyAction, "help")
	AddAction(binding.harmfulAction, "harm")
	if #lines == 0 then
		return nil
	end
	return tconcat(lines, "\n")
end

-- Builds dynamic-rez /cast lines (used by the dynamicrez binding type + Smart
-- Rez). Returns a list of macro lines (possibly empty) or nil if the class has
-- no rez kit. Never includes /stopmacro -- caller adds that for oocOnly.
-- standalone marks the dedicated rez binding, where these lines are the whole
-- macro rather than a [dead] prefix in front of somebody else's action.
local function BuildRezLines(binding, guard, standalone)
	local _, pClass = UnitClass("player")
	local kit = REZ_BY_CLASS[pClass]
	if not kit then
		return nil
	end
	local bank = Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player
	-- A slot is one spell ID or a list of rank IDs. The first rank found in the
	-- book answers: every rank shares the name, and /cast by name casts the
	-- highest rank known.
	local function Known(sid)
		if not sid then
			return nil
		end
		if type(sid) == "table" then
			for i = 1, #sid do
				local name = Known(sid[i])
				if name then
					return name
				end
			end
			return nil
		end
		if C_SpellBook.IsSpellInSpellBook and bank then
			if not C_SpellBook.IsSpellInSpellBook(sid, bank, true) then
				return nil
			end
		end
		return C_Spell.GetSpellName and C_Spell.GetSpellName(sid)
	end
	local battleName = Known(kit.battle)
	local groupName = Known(kit.group)
	local singleName = Known(kit.single)
	local lines = {}
	-- [combat] only when there is an out-of-combat rez after it to be the answer
	-- instead. A death knight or a warlock, whose only rez IS the battle one,
	-- would otherwise cast nothing out of combat -- where that spell works
	-- perfectly well, so theirs takes oocOnly's [nocombat] rather than dropping.
	-- That conditional has to live on the line: Smart Rez prepends these ahead of
	-- the base macro, and so ahead of its /stopmacro [combat].
	local hasOOCRez = groupName or singleName
	if battleName and not (hasOOCRez and binding.oocOnly) then
		local combatCond = ""
		if hasOOCRez then
			combatCond = ",combat"
		elseif binding.oocOnly then
			combatCond = ",nocombat"
		end
		lines[#lines + 1] = "/cast [@mouseover,help,dead" .. combatCond .. guard .. "] " .. battleName
	end
	if groupName then
		lines[#lines + 1] = "/cast [@mouseover,help,dead,nocombat" .. guard .. "] " .. groupName
	elseif singleName then
		lines[#lines + 1] = "/cast [@mouseover,help,dead,nocombat" .. guard .. "] " .. singleName
	end
	-- Soulstone also pre-buffs a LIVING ally, which the [dead] lines above can
	-- never reach. Standalone only: Smart Rez prepends these lines to another
	-- action and depends on all of them failing on a living unit.
	if standalone and pClass == "WARLOCK" and battleName then
		local oocCond = binding.oocOnly and ",nocombat" or ""
		lines[#lines + 1] = "/cast [@mouseover,help,exists,nodead" .. oocCond .. guard .. "] " .. battleName
	end
	return lines
end

-- Builds base macrotext (no Smart Rez). Returns nil when no macro wrapping is
-- needed (applied as a direct spell instead).
local function BuildBaseMacroText(binding)
	local isHC = binding.hovercast
	local guard = isHC and MOUNT_GUARD or ""

	if binding.type == "reaction" then
		return BuildReactionMacroText(binding, guard)
	elseif binding.type == "spell" then
		local name = ResolveCastSpellName(binding)
		if not name then
			return nil
		end
		local isRez = IsRezSpellBinding(binding)
		local unitType = GetBindingUnitType(binding)
		local conds = { "@mouseover" }
		if binding.harmfulSpell then
			local harmfulName = ResolveHarmfulSpellName(binding)
			if harmfulName then
				local lines = {}
				local function AddReactionLine(reaction, harmful)
					local reactionEnabled = (reaction == "help" and unitType ~= "harmful")
						or (reaction == "harm" and unitType ~= "friendly")
					if not reactionEnabled then
						return
					end
					local reactionConds = { "@mouseover", reaction }
					if not isRez then
						reactionConds[#reactionConds + 1] = "exists"
						reactionConds[#reactionConds + 1] = "nodead"
					end
					if binding.oocOnly then
						reactionConds[#reactionConds + 1] = "nocombat"
					end
					lines[#lines + 1] =
						SpellCastLine(binding, "[" .. tconcat(reactionConds, ",") .. guard .. "]", harmful)
				end
				AddReactionLine("help", false)
				AddReactionLine("harm", true)
				if #lines == 0 then
					return nil
				end
				return tconcat(lines, "\n")
			end
		end
		if unitType == "friendly" then
			conds[#conds + 1] = "help"
		elseif unitType == "harmful" then
			conds[#conds + 1] = "harm"
		end
		-- exists,nodead: without it, a gone/dead hovered unit lets the cast fall
		-- through to Blizzard default targeting -- with auto self-cast on, it
		-- lands on the player instead of being dropped. Rez spells are exempt
		-- (corpses are their only valid target).
		if not isRez then
			conds[#conds + 1] = "exists"
			conds[#conds + 1] = "nodead"
		end
		if binding.oocOnly then
			conds[#conds + 1] = "nocombat"
		end
		-- A frame-click rez binding with no other conditions needs no macro
		-- wrapping; it is applied as a direct spell attribute instead.
		if isRez and not isHC and #conds == 1 then
			return nil
		end
		return SpellCastLine(binding, "[" .. tconcat(conds, ",") .. guard .. "]")
	elseif binding.type == "macro" then
		local macroName = binding.macroName
		if not macroName then
			return nil
		end
		local idx = GetMacroIndexByName(macroName)
		if not idx or idx == 0 then
			return nil
		end
		local body = GetMacroBody(idx)
		if not body then
			return nil
		end
		if binding.oocOnly then
			body = "/stopmacro [combat]\n" .. body
		end
		if isHC then
			body = "/stopmacro [mounted][flying]\n" .. body
			-- User macro bodies cannot fold friend/harm conditions into their
			-- own commands, so Hovercast gates the whole macro instead.
			local unitType = GetBindingUnitType(binding)
			if unitType == "none" then
				return "/stopmacro"
			end
			if unitType == "friendly" then
				body = "/stopmacro [@mouseover,nohelp]\n" .. body
			elseif unitType == "harmful" then
				body = "/stopmacro [@mouseover,noharm]\n" .. body
			end
		end
		return body
	elseif binding.type == "item" then
		local target = binding.itemSlot or binding.itemName
		if not target then
			return nil
		end
		local unitType = GetBindingUnitType(binding)
		local reaction = unitType == "friendly" and ",help" or unitType == "harmful" and ",harm" or ""
		local cmd = "/use [@mouseover" .. reaction .. ",exists,nodead" .. guard .. "] " .. target
		if binding.oocOnly then
			cmd = "/stopmacro [combat]\n" .. cmd
		end
		return cmd
	elseif binding.type == "trinket1" or binding.type == "trinket2" then
		local slot = binding.type == "trinket1" and 13 or 14
		local cmd = "/use [@mouseover,exists,nodead" .. guard .. "] " .. slot
		if binding.oocOnly then
			cmd = "/stopmacro [combat]\n" .. cmd
		end
		return cmd
	elseif binding.type == "dynamicrez" then
		local lines = BuildRezLines(binding, guard, true)
		if not lines or #lines == 0 then
			return nil
		end
		if binding.oocOnly then
			tinsert(lines, 1, "/stopmacro [combat]")
		end
		return tconcat(lines, "\n")
	elseif binding.type == "dispel" or binding.type == "external" then
		local spellList = binding.type == "dispel" and DISPEL_SPELLS or EXTERNAL_SPELLS
		local _, pClass = UnitClass("player")
		local lines = {}
		if binding.oocOnly then
			lines[#lines + 1] = "/stopmacro [combat]"
		end
		for _, sp in ipairs(ClassPresetSpells(spellList, pClass)) do
			-- /cast resolves by localized name; the English sp.name would
			-- silently fail on non-English clients
			local castName = (C_Spell.GetSpellName and C_Spell.GetSpellName(sp.id)) or sp.name
			lines[#lines + 1] = "/cast [@mouseover,exists,nodead" .. guard .. "] " .. castName
		end
		if #lines == 0 then
			return nil
		end
		return tconcat(lines, "\n")
	end
	return nil
end

-- Wraps base macrotext with Smart Rez: when binding.smartRez is set, dynamic-rez
-- /cast lines are prepended (they fail their [dead] condition on a living unit,
-- so the macro falls through to the normal action).
local function BuildMacroText(binding)
	local base = BuildBaseMacroText(binding)
	if not binding.smartRez then
		return base
	end
	-- A pinned WoW Forever rez rank is the rez itself: the by-name rez lines
	-- would cast the top rank ahead of it on every dead target.
	if PinnedRankID(binding) and IsRezSpellBinding(binding) then
		return base
	end
	-- Smart Rez never applies to non-cast bindings or the rez binding itself
	if binding.type == "target" or binding.type == "menu" or binding.type == "dynamicrez" then
		return base
	end
	local guard = binding.hovercast and MOUNT_GUARD or ""
	local rez = BuildRezLines(binding, guard)
	if not rez or #rez == 0 then
		return base
	end
	local rezText = tconcat(rez, "\n")

	if base then
		return rezText .. "\n" .. base
	end
	-- A plain spell binding produces no base macro (applied as a direct spell);
	-- convert it to a macro so the rez lines can lead, then cast on the same unit.
	if binding.type == "spell" then
		local line = SpellCastLine(binding, "[@mouseover,exists,nodead" .. guard .. "]")
		if not line then
			return rezText
		end
		return rezText .. "\n" .. line
	end
	return rezText
end

function module:GetBindingIcon(b)
	if b.type == "dispel" then
		local _, pc = UnitClass("player")
		for _, sp in ipairs(ClassPresetSpells(DISPEL_SPELLS, pc)) do
			local tex = C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(sp.id)
			if tex then
				return tex
			end
		end
		return ACTION_ICONS.dispel
	elseif b.type == "external" then
		local _, pc = UnitClass("player")
		for _, sp in ipairs(ClassPresetSpells(EXTERNAL_SPELLS, pc)) do
			local tex = C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(sp.id)
			if tex then
				return tex
			end
		end
		return ACTION_ICONS.external
	elseif b.type == "trinket1" then
		return GetInventoryItemTexture("player", 13) or 134400
	elseif b.type == "trinket2" then
		return GetInventoryItemTexture("player", 14) or 134400
	elseif b.type == "dynamicrez" then
		local _, pc = UnitClass("player")
		local kit = REZ_BY_CLASS[pc]
		if kit then
			local sid = kit.battle or kit.group or kit.single
			if type(sid) == "table" then
				sid = sid[1]
			end
			if sid then
				local tex = C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(sid)
				if tex then
					return tex
				end
			end
		end
		return 136080
	end
	if b.icon then
		return b.icon
	end
	if b.spellID then
		local info = C_Spell.GetSpellInfo(b.spellID)
		if info and info.iconID then
			return info.iconID
		end
	end
	if b.spell then
		local info = C_Spell.GetSpellInfo(b.spell)
		if info and info.iconID then
			return info.iconID
		end
	end
	if b.macroName then
		local idx = GetMacroIndexByName(b.macroName)
		if idx and idx > 0 then
			local _, iconTex = GetMacroInfo(idx)
			if iconTex then
				return iconTex
			end
		end
	end
	if b.itemSlot then
		local tex = GetInventoryItemTexture("player", b.itemSlot)
		if tex then
			return tex
		end
	end
	return ACTION_ICONS[b.type] or 134400
end

function module:GetBindingName(b)
	if b.type == "target" then
		return L["Target Unit"]
	end
	if b.type == "menu" then
		return L["Context Menu"]
	end
	if b.type == "trinket1" then
		return L["Trinket 1"]
	end
	if b.type == "trinket2" then
		return L["Trinket 2"]
	end
	if b.type == "dynamicrez" then
		return L["Dynamic Rez"]
	end
	if b.type == "spell" then
		return b.spell or L["Unknown Spell"]
	end
	if b.type == "macro" then
		return b.macroName or L["Unknown Macro"]
	end
	if b.type == "item" then
		if b.itemSlot then
			local itemID = GetInventoryItemID("player", b.itemSlot)
			if itemID then
				local name = C_Item.GetItemInfo(itemID)
				if name then
					return name
				end
			end
		end
		return b.itemName or L["Unknown Item"]
	end
	if b.type == "dispel" then
		return L["Dispels"]
	end
	if b.type == "external" then
		return L["Externals"]
	end
	return L["Unknown"]
end

-- Spell enumeration (class/spec spells, non-passive, non-general). WoW Forever
-- lists every rank of a spell as its own spellbook item and each keeps its entry
-- (a lower rank can own a key of its own): a lower rank carries lowRank and its
-- rank text, the top rank of a ranked spell carries ranked, and the ranks of one
-- spell sort together, top rank first. topOnly drops the lower ranks.
function module:GetClassSpells(topOnly)
	local spells = {}
	if not C_SpellBook then
		return spells
	end
	local bank = Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player
	if not bank then
		return spells
	end

	local numTabs = C_SpellBook.GetNumSpellBookSkillLines and C_SpellBook.GetNumSpellBookSkillLines() or 0
	local seen = {}
	local lowNames = {} -- WoW Forever: names that have lower ranks

	for tab = 1, numTabs do
		local lineInfo = C_SpellBook.GetSpellBookSkillLineInfo(tab)
		if lineInfo then
			local tabName = lineInfo.name or ""
			local isGeneral = (tabName == "General" or tabName == _G.GENERAL or tabName == "")
			local isOffSpec = lineInfo.offSpecID and lineInfo.offSpecID ~= 0

			if not isGeneral and not isOffSpec and not lineInfo.shouldHide then
				local offset = lineInfo.itemIndexOffset or 0
				local count = lineInfo.numSpellBookItems or 0
				for si = offset + 1, offset + count do
					local spellType, actionId, spellId = C_SpellBook.GetSpellBookItemType(si, bank)
					if spellType == Enum.SpellBookItemType.Spell then
						local sid = spellId or actionId
						if sid and not seen[sid] then
							local isPassive = C_Spell.IsSpellPassive and C_Spell.IsSpellPassive(sid)
							if not isPassive then
								seen[sid] = true
								local name = C_Spell.GetSpellName and C_Spell.GetSpellName(sid)
								local icon = C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(sid)
								if name then
									local sp = { id = sid, name = name, icon = icon }
									if RANKS then
										if
											C_SpellBook.IsSpellBookItemLowRank
											and C_SpellBook.IsSpellBookItemLowRank(si, bank)
										then
											sp.lowRank = true
										end
										local info = C_SpellBook.GetSpellBookItemInfo
											and C_SpellBook.GetSpellBookItemInfo(si, bank)
										local sub = info and info.subName
										if (not sub or sub == "") and C_Spell.GetSpellSubtext then
											sub = C_Spell.GetSpellSubtext(sid)
										end
										if sub and sub ~= "" then
											sp.rankText = sub
											sp.rankNum = tonumber(sub:match("(%d+)"))
										end
									end
									if not (topOnly and sp.lowRank) then
										spells[#spells + 1] = sp
									end
									if sp.lowRank then
										lowNames[name] = true
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if not RANKS then
		table.sort(spells, function(a, b)
			return a.name < b.name
		end)
		return spells
	end
	for i = 1, #spells do
		local sp = spells[i]
		if not sp.lowRank and lowNames[sp.name] then
			sp.ranked = true
		end
	end
	table.sort(spells, function(a, b)
		if a.name ~= b.name then
			return a.name < b.name
		end
		if (a.lowRank or false) ~= (b.lowRank or false) then
			return not a.lowRank
		end
		local ra, rb = a.rankNum or 0, b.rankNum or 0
		if ra ~= rb then
			return ra > rb
		end
		return a.id > b.id
	end)
	return spells
end

-- Macro enumeration
function module:GetGlobalMacros()
	local macros = {}
	local numGlobal = GetNumMacros() or 0
	for i = 1, numGlobal do
		local name, iconTex = GetMacroInfo(i)
		if name then
			macros[#macros + 1] = { index = i, name = name, icon = iconTex, isGlobal = true }
		end
	end
	return macros
end

function module:GetAllMacros()
	local macros = self:GetGlobalMacros()
	local _, numChar = GetNumMacros()
	numChar = numChar or 0
	for i = MAX_ACCOUNT_MACROS + 1, MAX_ACCOUNT_MACROS + numChar do
		local name, iconTex = GetMacroInfo(i)
		if name then
			macros[#macros + 1] = { index = i, name = name, icon = iconTex, isGlobal = false }
		end
	end
	return macros
end

-- Item enumeration: equipped/bag items that have an on-use effect (trinkets etc)
local EQUIP_SLOTS = { 13, 14, 1, 2, 15, 10, 6, 16, 17 }

function module:GetEquippedItems()
	local items = {}
	local seen = {}
	for _, slot in ipairs(EQUIP_SLOTS) do
		local itemID = GetInventoryItemID("player", slot)
		if itemID then
			local itemName, _, _, _, _, _, _, _, _, itemIcon = C_Item.GetItemInfo(itemID)
			if itemName then
				local spellName = C_Item.GetItemSpell(itemID)
				if spellName then
					seen[itemID] = true
					items[#items + 1] = {
						name = itemName,
						icon = itemIcon or GetInventoryItemTexture("player", slot),
						itemSlot = slot,
						itemID = itemID,
					}
				end
			end
		end
	end
	-- Bag on-use items (potions, healthstones, consumables, etc.)
	if C_Container then
		for bag = 0, 4 do
			local numSlots = C_Container.GetContainerNumSlots(bag)
			for slot = 1, numSlots do
				local containerInfo = C_Container.GetContainerItemInfo(bag, slot)
				if containerInfo and containerInfo.itemID and not seen[containerInfo.itemID] then
					local itemID = containerInfo.itemID
					local spellName = C_Item.GetItemSpell(itemID)
					if spellName then
						seen[itemID] = true
						local itemName, _, _, _, _, _, _, _, _, itemIcon = C_Item.GetItemInfo(itemID)
						if itemName then
							items[#items + 1] = {
								name = itemName,
								icon = itemIcon or containerInfo.iconFileID,
								itemName = itemName,
								itemID = itemID,
							}
						end
					end
				end
			end
		end
	end
	return items
end

-------------------------------------------------------------------------------
--  Secure menu / target proxies
--  12.0.7 gates SecureUnitButton_OnClick: a "togglemenu" or "target" action is
--  dropped unless C_ClickBindings has a binding for that button (only plain
--  left/right click have one). Re-opening the menu from insecure Lua taints it,
--  so its protected items (Set Focus, Follow) throw ADDON_ACTION_FORBIDDEN.
--  These bindings route through a hidden child SecureActionButton instead,
--  whose own OnClick is not gated. "useparent-unit" resolves the unit from the
--  unit button, so header-managed frames whose unit changes work too. The
--  "click" secure action crashes on a Blizzard typo since 12.1, so the proxies
--  are globally named and reached through a "/click <name>" macro.
-------------------------------------------------------------------------------
-- The proxy's "togglemenu" classifier misfires for a raid member whose unit data
-- has not streamed in and opens a pet menu. A PET-family menu for a raid/party
-- token whose GUID is a player is that misfire: re-open the player menu. The
-- re-open runs from this hook, so its protected items fail for that one menu;
-- the trade for not showing a pet menu on a player. Installed with the first
-- menu proxy.
local menuFixHooked = false
local function InstallMenuClassifierFix()
	if menuFixHooked or type(_G.UnitPopup_OpenMenu) ~= "function" then
		return
	end
	menuFixHooked = true
	local reopening = false
	hooksecurefunc("UnitPopup_OpenMenu", function(which, contextData)
		if reopening then
			return
		end
		if which ~= "PET" and which ~= "OTHERPET" and which ~= "OTHERBATTLEPET" then
			return
		end
		local unit = contextData and contextData.unit
		if type(unit) ~= "string" then
			return
		end
		local lu = unit:lower()
		local isRaidToken = lu:match("^raid[0-9]+$") ~= nil
		if not isRaidToken and not lu:match("^party[0-9]+$") then
			return
		end
		local guid = UnitGUID(unit)
		if issecretvalue and issecretvalue(guid) then
			return
		end
		if type(guid) ~= "string" or not guid:find("^Player%-") then
			return
		end
		reopening = true
		-- A fresh context table, never the inbound one: OpenMenu enriches its
		-- contextData in place and asserts those fields are nil on entry
		_G.UnitPopup_OpenMenu(isRaidToken and "RAID_PLAYER" or "PARTY", { unit = unit })
		reopening = false
	end)
end

local menuProxies = setmetatable({}, { __mode = "k" })
local menuMacros = setmetatable({}, { __mode = "k" }) -- proxy -> its macrotext
local targetProxies = setmetatable({}, { __mode = "k" })
local proxyCounter = 0

local function CreateUnitProxy(frame, prefix, action)
	proxyCounter = proxyCounter + 1
	local proxyName = prefix .. proxyCounter
	local proxy = CreateFrame("Button", proxyName, frame, "SecureActionButtonTemplate")
	proxy:SetSize(1, 1)
	proxy:SetAlpha(0)
	proxy:EnableMouse(false) -- never catches real mouse; only the /click reaches it
	proxy:RegisterForClicks("AnyUp")
	proxy:SetAttribute("type", action)
	-- The secure resolver looks up type by button suffix, set every button
	for i = 1, 5 do
		proxy:SetAttribute("type" .. i, action)
	end
	proxy:SetAttribute("useparent-unit", true)
	-- Act on the up-click regardless of the "cast on key down" CVar
	proxy:SetAttribute("useOnKeyDown", false)
	return proxy, proxyName
end

local function GetSecureMenuMacro(frame)
	if not frame then
		return
	end
	InstallMenuClassifierFix()
	local proxy = menuProxies[frame]
	if not proxy then
		local name
		proxy, name = CreateUnitProxy(frame, "MER_HoverCastMenuProxy", "togglemenu")
		menuMacros[proxy] = "/click " .. name
		menuProxies[frame] = proxy
	end
	return menuMacros[proxy]
end

local function GetSecureTargetProxy(frame)
	if not frame then
		return
	end
	local proxy = targetProxies[frame]
	if not proxy then
		proxy = CreateUnitProxy(frame, "MER_HoverCastTargetProxy", "target")
		targetProxies[frame] = proxy
	end
	return proxy
end

-------------------------------------------------------------------------------
--  Attribute generation helpers
-------------------------------------------------------------------------------
local function ModPrefixForAttr(modsStr)
	if not modsStr or modsStr == "" then
		return ""
	end
	return modsStr:lower()
end

-- Sets a secure "type" attribute, gated OOC via a combat driver when oocOnly:
-- menu/target have no macro conditional (unlike spell/macro), so the attribute
-- itself must switch -- real action OOC, inert "none" in combat. "none" (never
-- nil) matters: the secure resolver falls back to a *typeN wildcard whenever
-- typeN is nil, so "none" (not nil) suppresses it. Out of combat only;
-- unregisters the driver first so a stale one can't survive a type change.
local function SetGatedType(frame, attrName, value, oocOnly)
	UnregisterAttributeDriver(frame, attrName)
	if oocOnly then
		RegisterAttributeDriver(frame, attrName, "[combat] none; " .. value)
	else
		frame:SetAttribute(attrName, value)
	end
end

-- Apply click (mouse button 1-5) attributes on a frame for one binding
local function SetClickAttr(frame, parsed, actionType, spellOrMacro, macrotext, oocOnly)
	local prefix = ModPrefixForAttr(parsed.modifiers)
	local suffix = tostring(parsed.buttonNum)
	local typeAttr = prefix .. "type" .. suffix
	-- A raw "togglemenu" is gated on unit buttons, route it through the proxy
	if actionType == "togglemenu" then
		SetGatedType(frame, typeAttr, "macro", oocOnly)
		frame:SetAttribute(prefix .. "macrotext" .. suffix, GetSecureMenuMacro(frame))
		return
	end
	-- A raw "target" is gated too, except plain unmodified left-click, which
	-- still targets via Blizzard's own Interaction click-binding
	if actionType == "target" and (suffix ~= "1" or prefix ~= "") then
		local proxy = GetSecureTargetProxy(frame)
		SetGatedType(frame, typeAttr, "macro", oocOnly)
		frame:SetAttribute(prefix .. "macrotext" .. suffix, "/click " .. proxy:GetName())
		return
	end
	-- Raw action type. Only menu/target honor oocOnly via the combat driver;
	-- spell/macro carry their own conditional in the macro text.
	local gate = oocOnly and (actionType == "togglemenu" or actionType == "target")
	SetGatedType(frame, typeAttr, actionType, gate)
	if actionType == "spell" then
		frame:SetAttribute(prefix .. "spell" .. suffix, spellOrMacro or "")
	elseif actionType == "macro" then
		frame:SetAttribute(prefix .. "macrotext" .. suffix, macrotext or "")
	end
end

local function ClearClickAttr(frame, parsed)
	local prefix = ModPrefixForAttr(parsed.modifiers)
	local suffix = tostring(parsed.buttonNum)
	UnregisterAttributeDriver(frame, prefix .. "type" .. suffix)
	frame:SetAttribute(prefix .. "type" .. suffix, nil)
	frame:SetAttribute(prefix .. "spell" .. suffix, nil)
	frame:SetAttribute(prefix .. "macrotext" .. suffix, nil)
	frame:SetAttribute(prefix .. "clickbutton" .. suffix, nil)
end

-- Apply keyboard binding attributes on a frame (virtual button suffix)
local function SetKeyAttr(frame, idx, actionType, spellOrMacro, macrotext, oocOnly)
	local suffix = "mer_" .. idx
	local typeAttr = "type-" .. suffix
	if actionType == "togglemenu" then
		SetGatedType(frame, typeAttr, "macro", oocOnly)
		frame:SetAttribute("macrotext-" .. suffix, GetSecureMenuMacro(frame))
		return
	end
	-- A "target" keybind is never plain left-click, so it always hits the gate
	if actionType == "target" then
		local proxy = GetSecureTargetProxy(frame)
		SetGatedType(frame, typeAttr, "macro", oocOnly)
		frame:SetAttribute("macrotext-" .. suffix, "/click " .. proxy:GetName())
		return
	end
	local gate = oocOnly and (actionType == "togglemenu" or actionType == "target")
	SetGatedType(frame, typeAttr, actionType, gate)
	if actionType == "spell" then
		frame:SetAttribute("spell-" .. suffix, spellOrMacro or "")
	elseif actionType == "macro" then
		frame:SetAttribute("macrotext-" .. suffix, macrotext or "")
	end
end

local function ClearKeyAttrs(frame, count)
	for i = 1, count do
		local suffix = "mer_" .. i
		UnregisterAttributeDriver(frame, "type-" .. suffix)
		frame:SetAttribute("type-" .. suffix, nil)
		frame:SetAttribute("spell-" .. suffix, nil)
		frame:SetAttribute("macrotext-" .. suffix, nil)
		frame:SetAttribute("clickbutton-" .. suffix, nil)
	end
end

-- Same for the hovercast global button
local function ClearHoverAttrs(btn, count)
	for i = 1, count do
		local suffix = "mer_hc_" .. i
		UnregisterAttributeDriver(btn, "type-" .. suffix)
		btn:SetAttribute("type-" .. suffix, nil)
		btn:SetAttribute("spell-" .. suffix, nil)
		btn:SetAttribute("macrotext-" .. suffix, nil)
		btn:SetAttribute("unit-" .. suffix, nil)
	end
end

-- Resolves a binding to actionType, spellOrMacroName, macrotext for attribute setting
local function ResolveBinding(b)
	if b.type == "target" then
		return "target", nil, nil
	end
	if b.type == "menu" then
		return "togglemenu", nil, nil
	end

	local mt = BuildMacroText(b)
	if mt then
		return "macro", nil, mt
	end

	if b.type == "spell" then
		-- A pinned WoW Forever rank goes by id: the secure spell action casts a
		-- numeric attribute with CastSpellByID, so exactly that rank
		local rankID = PinnedRankID(b)
		return "spell", rankID and tostring(rankID) or ResolveCastSpellName(b), nil
	elseif b.type == "macro" then
		local macroName = b.macroName
		if macroName then
			local idx = GetMacroIndexByName(macroName)
			if idx and idx > 0 then
				return "macro", nil, GetMacroBody(idx)
			end
		end
		return nil, nil, nil
	end
	return nil, nil, nil
end

-- OnEnter/OnLeave secure script generation (frame-based keyboard bindings).
-- Returns enterScript, leaveScript, kbClearLines. kbClearLines uses
-- self:ClearBinding (state-driver context, self=header); leaveScript uses
-- control:ClearBinding (WrapScript context, control=header).
local function GenerateKeyBindSnippets(bindings)
	local enter, leave, selfClear = {}, {}, {}
	local kbBindings = {}
	for i, b in ipairs(bindings) do
		if IsFrameBinding(b) then
			local parsed = ParseKeyString(b.key)
			if not parsed.isMouseButton or not parsed.buttonNum or parsed.buttonNum > 5 then
				kbBindings[#kbBindings + 1] = { binding = b, index = i, parsed = parsed }
			end
		end
	end
	if #kbBindings == 0 then
		return "", "", selfClear
	end

	enter[#enter + 1] = [[local name = self:GetName()]]
	enter[#enter + 1] = [[local target = name]]
	enter[#enter + 1] = [[if not name then]]
	enter[#enter + 1] = [[    local sc = control:GetFrameRef("bindProxy")]]
	enter[#enter + 1] = [[    sc:SetAttribute("unit", self:GetAttribute("unit"))]]
	enter[#enter + 1] = [[    target = "MER_HoverCastBindProxy"]]
	enter[#enter + 1] = [[end]]

	-- Set/clear bindings on CONTROL (header) so both OnLeave and the
	-- state driver failsafe can clear them (same owner)
	for _, kb in ipairs(kbBindings) do
		local suffix = "mer_" .. kb.index
		enter[#enter + 1] = format([[control:SetBindingClick(true, %q, target, %q)]], kb.binding.key, suffix)
	end
	for _, kb in ipairs(kbBindings) do
		leave[#leave + 1] = format([[control:ClearBinding(%q)]], kb.binding.key)
		selfClear[#selfClear + 1] = format([[self:ClearBinding(%q)]], kb.binding.key)
	end
	return tconcat(enter, "\n"), tconcat(leave, "\n"), selfClear
end

-------------------------------------------------------------------------------
--  Frame registration
-------------------------------------------------------------------------------
local wrappedFrames = {}
local externalFrames = {}
local ccHookInstalled = false

-- ElvUI's party/raid/tank/assist frames (and their pet/target children) are
-- always handled, like the raid frames of a dedicated raid frame addon. Their
-- names are ElvUF_<Group>...UnitButton<N>[Pet|Target].
local function IsGroupFrame(frame)
	local ok, name = pcall(frame.GetName, frame)
	return ok and type(name) == "string" and name:find("^ElvUF_") ~= nil and name:find("UnitButton%d") ~= nil
end

-- ElvUI decides the click direction of its own frames itself (UF.db.targetOnMouseDown)
local function IsElvUIFrame(frame)
	return frame.unitframeType ~= nil
end

local function GetClickDirection()
	local cc = GetClickCastDB()
	-- Down-click only applies while enabled; disabled must stay "AnyUp" so
	-- right-click fires on the up-stroke like Blizzard's default (a down-stroke
	-- togglemenu would open then instantly dismiss on the trailing up event).
	return (cc and cc.enabled and cc.downClick) and "AnyDown" or "AnyUp"
end

-- Neutralizes unbound-click defaults so a click with no binding does nothing.
-- A unit button carries *type1="target" + *type2="togglemenu"; clearing the
-- wildcards alone isn't enough (nil type1 falls through to Blizzard's native
-- left-click-targets), so an unbound button gets inert type1/type2="none"
-- instead. Bound buttons keep their own typeN from SetClickAttr.
local function NeutralizeDefaultClicks(frame, bindings)
	local b1, b2 = false, false
	for _, b in ipairs(bindings) do
		if IsFrameBinding(b) and b.key then
			local parsed = ParseKeyString(b.key)
			if parsed.isMouseButton and parsed.modifiers == "" then
				if parsed.buttonNum == 1 then
					b1 = true
				elseif parsed.buttonNum == 2 then
					b2 = true
				end
			end
		end
	end
	frame:SetAttribute("*type1", nil)
	frame:SetAttribute("*type2", nil)
	frame:SetAttribute("*clickbutton2", nil)
	if not b1 then
		frame:SetAttribute("type1", "none")
	end
	if not b2 then
		frame:SetAttribute("type2", "none")
	end
end

-- Active-binding list shared across one synchronous registration burst (a
-- roster rebuild registering every frame, the regen queue drain, the all-frames
-- sweep). GetActiveBindings walks and merges the whole binding set, so
-- recomputing it per frame dominated those bursts. A burst never spans a render
-- frame (GetTime stamp), and ApplyBindings refreshes it in place.
local burst = {}
burst.Get = function()
	local now = GetTime()
	if burst.at ~= now then
		burst.at = now
		burst.list = GetActiveBindings()
	end
	return burst.list
end

local function DoRegisterFrame(frame)
	if not frame or not frame.RegisterForClicks then
		return
	end
	if not header then
		return
	end
	-- While disabled, zero frames are touched
	local cc = GetClickCastDB()
	if not (cc and cc.enabled) or IsCliqueLoaded() then
		return
	end
	-- No early-out on registeredFrames[frame]: re-registration must re-apply
	-- the click attributes. Every step below is idempotent.
	registeredFrames[frame] = true
	-- Captures the native click attributes once, so DoUnregisterFrame restores them
	if originalAttrs[frame] == nil then
		originalAttrs[frame] = {
			type1 = frame:GetAttribute("type1"),
			starType1 = frame:GetAttribute("*type1"),
			type2 = frame:GetAttribute("type2"),
			starType2 = frame:GetAttribute("*type2"),
			starClickButton2 = frame:GetAttribute("*clickbutton2"),
			wheel = frame.IsMouseWheelEnabled and frame:IsMouseWheelEnabled() or false,
		}
	end
	frame:RegisterForClicks(GetClickDirection())
	if frame.EnableMouseWheel then
		frame:EnableMouseWheel(true)
	end
	if not wrappedFrames[frame] then
		wrappedFrames[frame] = true
		header:WrapScript(
			frame,
			"OnEnter",
			[[
			-- Record the hovered frame (the state-driver clear guard reads it),
			-- run the per-frame keyboard setup, then SET the hover override binding
			-- right now if it isn't already active -- so a keypress on arrival can
			-- never lose the race against the binding being set.
			mer_hoverframe = self
			control:RunFor(self, control:GetAttribute("mer_setup_onenter"))
			if not mer_hoveractive then
				control:RunAttribute("mer_hover_set")
				mer_hoveractive = true
			end
		]]
		)
		header:WrapScript(
			frame,
			"OnLeave",
			[[
			-- Forget the hovered frame (so the guard stops protecting it) and run
			-- the per-frame keyboard teardown. The hover binding itself is left to
			-- the guarded state driver so moving onto another frame keeps it.
			if mer_hoverframe == self then mer_hoverframe = nil end
			control:RunFor(self, control:GetAttribute("mer_setup_onleave"))
		]]
		)
	end

	local bindings = burst.Get()
	for i, b in ipairs(bindings) do
		if IsFrameBinding(b) and b.key then
			local parsed = ParseKeyString(b.key)
			local aType, spellName, macrotext = ResolveBinding(b)
			if aType then
				if parsed.isMouseButton and parsed.buttonNum and parsed.buttonNum <= 5 then
					SetClickAttr(frame, parsed, aType, spellName, macrotext, b.oocOnly)
				else
					SetKeyAttr(frame, i, aType, spellName, macrotext, b.oocOnly)
				end
			end
		end
	end

	-- Neutralize unbound left-click target / right-click menu defaults;
	-- restored in DoUnregisterFrame on disable
	NeutralizeDefaultClicks(frame, bindings)
end

local function DoUnregisterFrame(frame)
	if not registeredFrames[frame] then
		return
	end
	registeredFrames[frame] = nil

	local bindings = burst.Get()
	for _, b in ipairs(bindings) do
		if IsFrameBinding(b) and b.key then
			local parsed = ParseKeyString(b.key)
			if parsed.isMouseButton and parsed.buttonNum and parsed.buttonNum <= 5 then
				ClearClickAttr(frame, parsed)
			end
		end
	end
	ClearKeyAttrs(frame, lastBindingCount)

	-- Restores the frame's native click attributes captured at register time
	local o = originalAttrs[frame]
	if o then
		frame:SetAttribute("type1", o.type1)
		frame:SetAttribute("*type1", o.starType1)
		frame:SetAttribute("type2", o.type2)
		frame:SetAttribute("*type2", o.starType2)
		frame:SetAttribute("*clickbutton2", o.starClickButton2)
	else
		frame:SetAttribute("type1", nil)
		frame:SetAttribute("*type1", "target")
		frame:SetAttribute("type2", nil)
		frame:SetAttribute("*type2", "togglemenu")
	end

	-- Fully reverts click registration and removes our OnEnter/OnLeave wraps, so
	-- the frame behaves exactly as before click-casting touched it
	if IsElvUIFrame(frame) then
		-- Also puts back ElvUI's middle-click focus a BUTTON3 binding replaced
		UF:RegisterForClicks(frame, frame.db)
	elseif frame.RegisterForClicks then
		frame:RegisterForClicks("AnyUp")
	end
	if frame.EnableMouseWheel then
		frame:EnableMouseWheel(o and o.wheel or false)
	end
	if wrappedFrames[frame] then
		wrappedFrames[frame] = nil
		if header and header.UnwrapScript then
			pcall(header.UnwrapScript, header, frame, "OnEnter")
			pcall(header.UnwrapScript, header, frame, "OnLeave")
		end
	end
end

local function RegisterOwnedFrame(frame)
	ownedFrames[frame] = true
	local cc = GetClickCastDB()
	if not (cc and cc.enabled) then
		return
	end
	if not ccInitialized or InCombatLockdown() then
		tinsert(regQueue, frame)
		return
	end
	DoRegisterFrame(frame)
end

local function UnregisterFrame(frame)
	if InCombatLockdown() then
		tinsert(unregQueue, frame)
		return
	end
	DoUnregisterFrame(frame)
end

local function RegisterExternalFrame(frame)
	if not ccInitialized then
		tinsert(regQueue, frame)
		return
	end
	local cc = GetClickCastDB()
	-- Only touches external frames when BOTH enabled and allFrames
	-- (externalFrames already recorded the frame, so enabling later picks it up)
	if not cc or not cc.enabled or not cc.allFrames then
		return
	end
	if InCombatLockdown() then
		tinsert(regQueue, frame)
		return
	end
	DoRegisterFrame(frame)
end

local function AddClickCastFrame(frame)
	if IsGroupFrame(frame) then
		RegisterOwnedFrame(frame)
	else
		externalFrames[frame] = true
		RegisterExternalFrame(frame)
	end
end

-- Forward-declared (defined below) so SetAllFrames can register the static
-- Blizzard list at runtime
local RegisterBlizzardFrames

function module:SetAllFrames(enabled)
	local cc = GetClickCastDB()
	if not cc then
		return
	end
	cc.allFrames = enabled
	if InCombatLockdown() then
		pendingApply = true
		return
	end
	if enabled then
		-- Grabs the static Blizzard list + installs the CompactUnitFrame hook
		RegisterBlizzardFrames()
		for frame in pairs(externalFrames) do
			if not registeredFrames[frame] and not ownedFrames[frame] then
				DoRegisterFrame(frame)
			end
		end
		self:ApplyBindings()
	else
		for frame in pairs(registeredFrames) do
			if not ownedFrames[frame] then
				DoUnregisterFrame(frame)
			end
		end
	end
end

function module:SetDownClick(enabled)
	local cc = GetClickCastDB()
	if not cc then
		return
	end
	cc.downClick = enabled
	if InCombatLockdown() then
		pendingApply = true
		return
	end
	local dir = enabled and "AnyDown" or "AnyUp"
	for frame in pairs(registeredFrames) do
		if frame.RegisterForClicks then
			frame:RegisterForClicks(dir)
		end
	end
end

-- ClickCastFrames hook: oUF adds every ElvUI unit frame to this global table.
-- Installs exactly once, only after the user enables, so a disabled install
-- never replaces the global table or perturbs other consumers.
local function SetupClickCastFramesHook()
	if ccHookInstalled then
		return
	end
	ccHookInstalled = true
	local oldCCF = _G.ClickCastFrames
	_G.ClickCastFrames = setmetatable({}, {
		__newindex = function(_, frame, value)
			if value == nil or value == false then
				externalFrames[frame] = nil
				ownedFrames[frame] = nil
				UnregisterFrame(frame)
			else
				AddClickCastFrame(frame)
			end
		end,
		__index = function(_, frame)
			return registeredFrames[frame] or nil
		end,
	})
	if oldCCF then
		for frame, val in pairs(oldCCF) do
			if val then
				AddClickCastFrame(frame)
			end
		end
	end
end

-- ElvUI re-registers the clicks of its frames on every frame update (and may
-- put its middle-click focus back on type3), so re-apply on top of it
local function HookElvUIClickRegistration()
	hooksecurefunc(UF, "RegisterForClicks", function(_, frame)
		if not registeredFrames[frame] then
			return
		end
		if InCombatLockdown() then
			tinsert(regQueue, frame)
		else
			DoRegisterFrame(frame)
		end
	end)
end

-------------------------------------------------------------------------------
--  Apply bindings to all registered frames + global button
-------------------------------------------------------------------------------
local prevBindings = {}

function module:ApplyBindings()
	if not ccInitialized then
		pendingApply = true
		return
	end
	if InCombatLockdown() then
		pendingApply = true
		return
	end

	-- Self-heals non-canonical modifier-order keys before reading the active set
	NormalizeSavedBindingKeys()

	local bindings = GetActiveBindings()
	-- Fresh list becomes the burst list: any registration later this frame
	-- reads the post-write set
	burst.at, burst.list = GetTime(), bindings

	knownSig = ComputeKnownSignature()
	if knownSig ~= "" then
		self:RegisterEvent("SPELLS_CHANGED", "OnEvent")
	else
		self:UnregisterEvent("SPELLS_CHANGED")
	end

	local frameBindings = {}
	local hoverBindings = {}
	-- A "both" binding lands in BOTH lists: frame attributes for clicks on the
	-- frames, plus the hover override for nameplates / world units
	for i, b in ipairs(bindings) do
		if IsHoverBinding(b) then
			hoverBindings[#hoverBindings + 1] = { b = b, idx = i }
		end
		if IsFrameBinding(b) then
			frameBindings[#frameBindings + 1] = { b = b, idx = i }
		end
	end

	---------------------------------------------------------------
	-- Frame-based bindings
	---------------------------------------------------------------
	for frame in pairs(registeredFrames) do
		for _, pb in ipairs(prevBindings) do
			if IsFrameBinding(pb.b) then
				local parsed = ParseKeyString(pb.b.key)
				if parsed.isMouseButton and parsed.buttonNum and parsed.buttonNum <= 5 then
					ClearClickAttr(frame, parsed)
				end
			end
		end
		ClearKeyAttrs(frame, lastBindingCount)
	end
	ClearKeyAttrs(bindProxy, lastBindingCount)

	for frame in pairs(registeredFrames) do
		for _, fb in ipairs(frameBindings) do
			local parsed = ParseKeyString(fb.b.key)
			local aType, spellName, macrotext = ResolveBinding(fb.b)
			if aType then
				if parsed.isMouseButton and parsed.buttonNum and parsed.buttonNum <= 5 then
					SetClickAttr(frame, parsed, aType, spellName, macrotext, fb.b.oocOnly)
				else
					SetKeyAttr(frame, fb.idx, aType, spellName, macrotext, fb.b.oocOnly)
				end
			end
		end
		-- Re-neutralize unbound left/right defaults (the clear pass above may
		-- have stripped a previous binding's typeN)
		NeutralizeDefaultClicks(frame, bindings)
	end
	-- Bind proxy gets keyboard attrs too (unnamed frame fallback)
	for _, fb in ipairs(frameBindings) do
		local parsed = ParseKeyString(fb.b.key)
		local aType, spellName, macrotext = ResolveBinding(fb.b)
		if aType and (not parsed.isMouseButton or not parsed.buttonNum or parsed.buttonNum > 5) then
			SetKeyAttr(bindProxy, fb.idx, aType, spellName, macrotext, fb.b.oocOnly)
		end
	end

	local enterScript, leaveScript, kbClearLines = GenerateKeyBindSnippets(bindings)
	header:SetAttribute("mer_setup_onenter", enterScript)
	header:SetAttribute("mer_setup_onleave", leaveScript)

	---------------------------------------------------------------
	-- Hovercast + frame keyboard failsafe, unified on ONE header state driver
	-- (mer_cc, [@mouseover,exists]). The override is SET instantly on the frame's
	-- OnEnter (mer_hover_set) so a keypress on arrival never loses the race; the
	-- driver ALSO sets on "on" (covers targets like nameplates with no OnEnter
	-- wrap) and on "off" clears + runs the keyboard failsafe, GUARDED so a
	-- transient exists==0 flicker while the last-hovered frame is still under
	-- the cursor can't strand it cleared. mer_hoveractive gates SetBindingClick
	-- to the become-active edge only. globalBtn's macro re-evaluates at cast
	-- time, so a press fires on whatever is hovered.
	---------------------------------------------------------------
	-- Retires the previous driver and wipes prior override bindings (teardown
	-- also resets mer_hoveractive), then rebuilds
	UnregisterStateDriver(header, "mer_cc")
	if header.ccClearScript then
		pcall(header.Execute, header, header.ccClearScript)
	end
	ClearHoverAttrs(globalBtn, lastHoverCount)

	local hoverSetLines = {}
	local hoverClearLines = {}
	local gbName = globalBtn:GetName()

	for hi, hb in ipairs(hoverBindings) do
		local suffix = "mer_hc_" .. hi
		local aType, _, macrotext = ResolveBinding(hb.b)
		if aType then
			local mt
			if aType == "spell" then
				mt = BuildMacroText(hb.b)
				if not mt then
					mt = SpellCastLine(hb.b, "[@mouseover" .. MOUNT_GUARD .. "]")
						or ("/cast [@mouseover" .. MOUNT_GUARD .. "] ")
				end
			elseif aType == "macro" then
				mt = macrotext or ""
			end

			if mt then
				globalBtn:SetAttribute("type-" .. suffix, "macro")
				globalBtn:SetAttribute("macrotext-" .. suffix, mt)
			else
				-- menu/target carry no macro conditional, so honor oocOnly via
				-- the combat driver (present out of combat, cleared in combat)
				SetGatedType(
					globalBtn,
					"type-" .. suffix,
					aType,
					hb.b.oocOnly and (aType == "togglemenu" or aType == "target")
				)
			end
			globalBtn:SetAttribute("unit-" .. suffix, "mouseover")
			-- Routes the key/button to the global button for EVERY action type:
			-- the global button is a SecureActionButton, which the unit button
			-- menu/target gate does not touch
			hoverSetLines[#hoverSetLines + 1] =
				format([[self:SetBindingClick(true, %q, %q, %q)]], hb.b.key, gbName, suffix)
			hoverClearLines[#hoverClearLines + 1] = format([[self:ClearBinding(%q)]], hb.b.key)
		end
	end

	-- Hover set/clear bodies: stored as header attributes, invoked via
	-- RunAttribute from both the OnEnter wrap and the state driver, so they
	-- always run with self=header (owner of the override bindings)
	header:SetAttribute("mer_hover_set", tconcat(hoverSetLines, "\n"))
	header:SetAttribute("mer_hover_clear", tconcat(hoverClearLines, "\n"))

	-- Teardown (next rebuild): self:ClearBindings() wipes every override this
	-- header owns in one shot (they re-establish on next hover). A per-key list
	-- is fragile: when the LAST binding is unbound the state driver isn't
	-- re-registered, so it could miss an override still active from a hover.
	header.ccClearScript = "self:ClearBindings()\nmer_hoveractive = false"

	if #hoverSetLines > 0 or #kbClearLines > 0 then
		local fbFailsafe = tconcat(kbClearLines, "\n")
		header:SetAttribute("_onstate-mer_cc", [[
			if newstate == "on" then
				if not mer_hoveractive then
					self:RunAttribute("mer_hover_set")
					mer_hoveractive = true
				end
			elseif not (mer_hoverframe and mer_hoverframe:IsUnderMouse()) then
				self:RunAttribute("mer_hover_clear")
				mer_hoveractive = false
				]] .. fbFailsafe .. [[

			end
		]])
		-- State values are deliberately non-numeric: the driver coerces with
		-- tonumber(newValue) or newValue, so a "1; 0" driver would arrive as
		-- NUMBER 1 and never match a quoted "1"
		RegisterStateDriver(header, "mer_cc", "[@mouseover,exists] on; off")
	end

	lastBindingCount = #bindings
	lastHoverCount = #hoverBindings
	prevBindings = {}
	for i, b in ipairs(bindings) do
		prevBindings[i] = { b = b, idx = i }
	end
end

-------------------------------------------------------------------------------
--  Binding CRUD
-------------------------------------------------------------------------------
function module:AddSpecBinding(binding)
	local cc = GetClickCastDB()
	if not cc then
		return
	end
	local specID = GetCurrentSpecID()
	if not specID then
		return
	end
	if not cc.specs[specID] then
		cc.specs[specID] = {}
	end
	if binding.enabled == nil then
		binding.enabled = true
	end
	tinsert(cc.specs[specID], binding)
	self:ApplyBindings()
end

function module:RemoveSpecBinding(index)
	local cc = GetClickCastDB()
	if not cc then
		return
	end
	local specID = GetCurrentSpecID()
	if not specID or not cc.specs[specID] then
		return
	end
	tremove(cc.specs[specID], index)
	self:ApplyBindings()
end

function module:AddGlobalBinding(binding)
	local cc = GetClickCastDB()
	if not cc then
		return
	end
	if binding.enabled == nil then
		binding.enabled = true
	end
	tinsert(cc.globals, binding)
	self:ApplyBindings()
end

function module:RemoveGlobalBinding(index)
	local cc = GetClickCastDB()
	if not cc then
		return
	end
	tremove(cc.globals, index)
	self:ApplyBindings()
end

-- Bindings only compete when their key is dispatched through at least one of
-- the same paths. Frame-only and hover-only bindings may therefore share a key;
-- a "both" binding overlaps either path.
local function BindingsShareCastPath(a, b)
	return (IsFrameBinding(a) and IsFrameBinding(b)) or (IsHoverBinding(a) and IsHoverBinding(b))
end

-- Calls fn for every OTHER active binding sharing the key and cast path, over
-- the globals and the active spec only (other specs are never active at the
-- same time). fn returning true stops the walk; returns whether it stopped.
local function ForEachKeySharer(excludeBinding, fn)
	local keyStr = excludeBinding.key
	local cc = keyStr and GetClickCastDB()
	if not cc then
		return false
	end
	for _, b in ipairs(cc.globals) do
		if
			b ~= excludeBinding
			and IsBindingActive(b)
			and b.key == keyStr
			and BindingsShareCastPath(excludeBinding, b)
			and fn(b)
		then
			return true
		end
	end
	local specID = GetCurrentSpecID()
	local activeList = specID and cc.specs[specID]
	if activeList then
		for _, b in ipairs(activeList) do
			if
				b ~= excludeBinding
				and IsBindingActive(b)
				and b.key == keyStr
				and BindingsShareCastPath(excludeBinding, b)
				and fn(b)
			then
				return true
			end
		end
	end
	return false
end

-- Finds all bindings (excluding the given one) sharing a key and a cast path;
-- returns a list of names or an empty table. A spell the character has not got
-- never owns the key, so it neither raises nor receives a conflict.
function module:FindKeyConflicts(keyStr, excludeBinding)
	if not keyStr or not IsBindingKnown(excludeBinding) then
		return {}
	end
	local conflicts = {}
	ForEachKeySharer(excludeBinding, function(b)
		if not AreComplementaryReactionBindings(excludeBinding, b) and IsBindingKnown(b) then
			-- A pinned WoW Forever rank is listed with its rank
			local rank = self:GetBindingRankText(b)
			conflicts[#conflicts + 1] = rank and (self:GetBindingName(b) .. " (" .. rank .. ")")
				or self:GetBindingName(b)
		end
	end)
	return conflicts
end

-- An untalented spell only dims when another binding shares its key: that is
-- the one that lost its key. Alone on a key it looks like any other binding.
local function AnyTrue()
	return true
end

function module:IsShadowedBinding(binding)
	return not IsBindingKnown(binding) and ForEachKeySharer(binding, AnyTrue)
end

function module:IsReactionBinding(binding)
	return IsReactionBinding(binding)
end

function module:IsBindingActive(binding)
	return IsBindingActive(binding)
end

---@return string "friendly", "harmful", "both" or "none"
function module:GetBindingUnitType(binding)
	return GetBindingUnitType(binding)
end

function module:CtxEnabled(binding, ctx)
	return CtxEnabled(binding, ctx)
end

function module:GetDB()
	return GetClickCastDB()
end

function module:GetSpecBindings()
	return GetSpecBindings()
end

function module:GetGlobalBindings()
	return GetGlobalBindings()
end

function module:HasSpec()
	return GetCurrentSpecID() ~= nil
end

function module:IsCliqueLoaded()
	return IsCliqueLoaded()
end

-------------------------------------------------------------------------------
--  Enable / disable sweep
-------------------------------------------------------------------------------
-- Registers the Blizzard default unit frames + party pool + dynamic raid frames.
-- Self-gated on enabled+allFrames (via RegisterExternalFrame); the
-- CompactUnitFrame hook installs at most once.
local blizzHookInstalled = false

-- oUF parks the Blizzard frames ElvUI replaces under an unnamed hidden frame;
-- they can never be clicked, yet Blizzard re-runs SetUpFrame on every one of
-- them for every roster change
local function IsParked(frame)
	local p, depth = frame:GetParent(), 0
	while p and depth < 6 do
		if p ~= UIParent and p:GetParent() == UIParent and not p:GetName() and not p:IsShown() then
			return true
		end
		p = p:GetParent()
		depth = depth + 1
	end
	return false
end

function RegisterBlizzardFrames()
	local cc = GetClickCastDB()
	if not (cc and cc.enabled and cc.allFrames) then
		return
	end
	local blizzNames = {
		"PlayerFrame",
		"TargetFrame",
		"TargetFrameToT",
		"FocusFrame",
		"FocusFrameToT",
		"PetFrame",
	}
	for i = 1, 5 do
		blizzNames[#blizzNames + 1] = "Boss" .. i .. "TargetFrame"
	end
	for _, name in ipairs(blizzNames) do
		local f = _G[name]
		if f then
			externalFrames[f] = true
			RegisterExternalFrame(f)
		end
	end
	local partyFrame = _G.PartyFrame
	if partyFrame and partyFrame.PartyMemberFramePool then
		for mf in partyFrame.PartyMemberFramePool:EnumerateActive() do
			externalFrames[mf] = true
			RegisterExternalFrame(mf)
			if mf.PetFrame then
				externalFrames[mf.PetFrame] = true
				RegisterExternalFrame(mf.PetFrame)
			end
		end
	end
	-- CompactUnitFrames (Blizzard raid frames) are created dynamically; the hook
	-- installs once and self-gates via RegisterExternalFrame (enabled+allFrames)
	if not blizzHookInstalled and _G.CompactUnitFrame_SetUpFrame then
		blizzHookInstalled = true
		hooksecurefunc("CompactUnitFrame_SetUpFrame", function(frame)
			if not frame then
				return
			end
			if frame.IsForbidden and frame:IsForbidden() then
				return
			end
			if IsParked(frame) then
				return
			end
			local ok, name = pcall(frame.GetName, frame)
			if ok and name and not name:match("^NamePlate") then
				externalFrames[frame] = true
				RegisterExternalFrame(frame)
			end
		end)
	end
end

-- Toggles click-casting with a full register/restore sweep: enabling installs
-- the global hook + registers owned/external frames; disabling returns EVERY
-- touched frame to native click behavior. Defers to PLAYER_REGEN_ENABLED in combat.
function module:SetEnabled(enabled)
	local cc = GetClickCastDB()
	if not cc then
		return
	end
	cc.enabled = enabled
	if not ccInitialized then
		return
	end
	if InCombatLockdown() then
		pendingSetEnabled = enabled
		pendingApply = true
		return
	end
	if enabled then
		if IsCliqueLoaded() then
			return
		end
		SetupClickCastFramesHook()
		for frame in pairs(ownedFrames) do
			if not registeredFrames[frame] then
				DoRegisterFrame(frame)
			end
		end
		if cc.allFrames then
			RegisterBlizzardFrames()
			for frame in pairs(externalFrames) do
				if not registeredFrames[frame] and not ownedFrames[frame] then
					DoRegisterFrame(frame)
				end
			end
		end
		self:ApplyBindings()
	else
		-- Clears applied attributes first (ApplyBindings uses the last-applied
		-- set), then reverts every frame to native (type1/type2, clicks, wheel, wraps)
		self:ApplyBindings()
		local list = {}
		for frame in pairs(registeredFrames) do
			list[#list + 1] = frame
		end
		for _, frame in ipairs(list) do
			DoUnregisterFrame(frame)
		end
	end
end

-------------------------------------------------------------------------------
--  Events
-------------------------------------------------------------------------------
-- Spec data can lag PLAYER_ENTERING_WORLD by a few frames at login; applying
-- bindings too early drops SPEC-scoped bindings with nothing to re-apply them
-- (PLAYER_SPECIALIZATION_CHANGED doesn't fire on plain login). Polls until the
-- spec resolves, then reapplies; safe with no spec (the cap stops the poll).
local specReadyTicker
local function ReapplyWhenSpecReady()
	if InCombatLockdown() then
		pendingApply = true
		return
	end
	if GetCurrentSpecID() then
		module:ApplyBindings()
		return
	end
	-- Spec not ready: only poll when enabled, a disabled install has nothing to re-apply
	local cc = GetClickCastDB()
	if not (cc and cc.enabled) then
		return
	end
	if specReadyTicker then
		return
	end
	local tries = 0
	specReadyTicker = C_Timer_NewTicker(0.25, function(t)
		tries = tries + 1
		if GetCurrentSpecID() or tries >= 20 then -- ~5s safety cap: the character has no spec
			t:Cancel()
			specReadyTicker = nil
			-- Still apply without a spec: the global bindings do not need one
			if not InCombatLockdown() then
				module:ApplyBindings()
			else
				pendingApply = true
			end
		end
	end)
end

local function ApplyOrDefer()
	if not InCombatLockdown() then
		module:ApplyBindings()
	else
		pendingApply = true
	end
end

function module:OnEvent(event, unit)
	if event == "PLAYER_REGEN_ENABLED" then
		local cc = GetClickCastDB()
		-- Apply a deferred enable/disable sweep that was requested during combat
		if pendingSetEnabled ~= nil then
			local v = pendingSetEnabled
			pendingSetEnabled = nil
			self:SetEnabled(v)
		end
		local enabled = cc and cc.enabled
		local allF = cc and cc.allFrames
		for _, frame in ipairs(regQueue) do
			-- Never register while disabled (DoRegisterFrame also self-gates)
			if enabled and (ownedFrames[frame] or allF) then
				DoRegisterFrame(frame)
			end
		end
		wipe(regQueue)
		for _, frame in ipairs(unregQueue) do
			DoUnregisterFrame(frame)
		end
		wipe(unregQueue)
		if pendingApply then
			pendingApply = false
			self:ApplyBindings()
		end
	elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
		-- Also fires for group members
		if not unit or unit == "player" then
			ApplyOrDefer()
		end
	elseif event == "SPELLS_CHANGED" then
		-- A talent or loadout swap that moved a bound spell in or out of the
		-- book; the apply re-resolves which binding owns each key
		if ComputeKnownSignature() ~= knownSig then
			ApplyOrDefer()
		end
	elseif event == "GROUP_ROSTER_UPDATE" then
		-- Solo <-> party <-> raid transitions change which bindings are active.
		-- The event fires on every join, leave, promote and zone-in, so only
		-- act when the context changed.
		local ctx = CurrentCtx()
		if ctx ~= lastRosterCtx then
			lastRosterCtx = ctx
			ApplyOrDefer()
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		-- Reapplies after zone/loading (OnLeave may not fire during transitions,
		-- so stuck frame-bindings need clearing); waits for the spec so login
		-- doesn't drop spec-scoped bindings
		ReapplyWhenSpecReady()
	end
end

-------------------------------------------------------------------------------
--  Init
-------------------------------------------------------------------------------
function module:Initialize()
	if ccInitialized then
		return
	end

	local cc = GetClickCastDB()
	if not cc then
		return
	end

	if cc.enabled and IsCliqueLoaded() then
		F.Print(
			format(
				L["%s is disabled while %s is loaded, both bind clicks on the same unit frames."],
				L["HoverCast"],
				"Clique"
			)
		)
		return
	end

	-- StateTemplate (not BaseTemplate): only it carries the OnAttributeChanged
	-- script that dispatches "_onstate-<id>"; under BaseTemplate the driver would
	-- write the state but nothing listens, so hovercast would only work via the
	-- OnEnter wrap (everywhere except nameplates)
	header = CreateFrame("Frame", "MER_HoverCastHeader", UIParent, "SecureHandlerStateTemplate")

	bindProxy = CreateFrame(
		"Button",
		"MER_HoverCastBindProxy",
		UIParent,
		"SecureActionButtonTemplate,SecureHandlerBaseTemplate"
	)
	bindProxy:RegisterForClicks("AnyDown", "AnyUp")
	bindProxy:SetSize(1, 1)
	bindProxy:SetAlpha(0)
	bindProxy:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -100, 100)
	bindProxy:Show()
	header:SetFrameRef("bindProxy", bindProxy)

	globalBtn = CreateFrame(
		"Button",
		"MER_HoverCastGlobalButton",
		UIParent,
		"SecureActionButtonTemplate,SecureHandlerBaseTemplate"
	)
	globalBtn:RegisterForClicks("AnyDown", "AnyUp")
	globalBtn:EnableMouse(false)
	globalBtn:SetSize(1, 1)
	globalBtn:SetAlpha(0)
	globalBtn:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -200, 100)
	globalBtn:Show()

	header:SetAttribute("mer_setup_onenter", "")
	header:SetAttribute("mer_setup_onleave", "")
	header:SetAttribute("mer_hover_set", "")
	header:SetAttribute("mer_hover_clear", "")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "OnEvent")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "OnEvent")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")

	HookElvUIClickRegistration()

	ccInitialized = true

	-- Only touches frames when enabled: a disabled install registers nothing,
	-- so clicks stay as they are. Enabling later runs the same sweep via SetEnabled.
	if cc.enabled then
		SetupClickCastFramesHook()
		for _, frame in ipairs(regQueue) do
			DoRegisterFrame(frame)
		end
		wipe(regQueue)
		self:ApplyBindings()
		RegisterBlizzardFrames()
	else
		wipe(regQueue)
	end
end

MER:RegisterModule(module:GetName())
