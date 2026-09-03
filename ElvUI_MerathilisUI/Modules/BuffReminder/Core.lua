local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BuffReminder")
local S = MER:GetModule("MER_Skins")

local pairs, ipairs = pairs, ipairs
local wipe = wipe
local floor, max = math.floor, math.max

local CreateFrame = CreateFrame
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsPlayerSpell = IsPlayerSpell
local IsSpellKnown = IsSpellKnown
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitInRange = UnitInRange
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local GetNumGroupMembers = GetNumGroupMembers
local GetNumSubgroupMembers = GetNumSubgroupMembers
local IsMounted = IsMounted
local IsFlying = IsFlying
local IsResting = IsResting
local UnitInVehicle = UnitInVehicle
local IsInInstance = IsInInstance
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local PlaySound = PlaySound

local C_Spell_GetSpellTexture = C_Spell.GetSpellTexture
local C_Spell_GetSpellName = C_Spell.GetSpellName
local C_UnitAuras_GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
local C_UnitAuras_GetAuraDataByIndex = C_UnitAuras.GetAuraDataByIndex
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_Item_GetItemIconByID = C_Item.GetItemIconByID
local GetItemIcon = C_Item_GetItemIconByID or GetItemIcon

-------------------------------------------------------------------------------
--  Basic helpers
-------------------------------------------------------------------------------
local function Known(id)
	return id and (IsPlayerSpell(id) or IsSpellKnown(id))
end

local function InCombat()
	return InCombatLockdown()
end

local texCache = {}
local function Tex(id)
	local c = texCache[id]
	if c then return c end
	local t = C_Spell_GetSpellTexture and C_Spell_GetSpellTexture(id)
	if t then texCache[id] = t end
	return t
end

local nameCache = {}
local function SpellName(id, fallback)
	local c = nameCache[id]
	if c then return c end
	local n = C_Spell_GetSpellName and C_Spell_GetSpellName(id)
	if n then nameCache[id] = n end
	return n or fallback
end

local function ShortLabel(name)
	return name and (name:match("^(%S+)") or name)
end

local _cachedClass
local function GetPlayerClass()
	if not _cachedClass then
		local _, cls = UnitClass("player")
		_cachedClass = cls
	end
	return _cachedClass
end

local function GetSpecID()
	local s = GetSpecialization and GetSpecialization()
	if not s then return nil end
	return GetSpecializationInfo(s)
end

local function InRealInstancedContent()
	local _, iType = IsInInstance()
	return iType == "party" or iType == "raid" or iType == "scenario"
end

local function InPvPInstance()
	local _, iType = IsInInstance()
	return iType == "pvp" or iType == "arena"
end

local function IsUnderDuration(duration, expirationTime, showUnder)
	if not duration or duration == 0 or not expirationTime then return false end
	local remaining = expirationTime - GetTime()
	return remaining <= ((showUnder or 5) * 60)
end

-------------------------------------------------------------------------------
--  SPELL DATA -- Raid Buffs
-------------------------------------------------------------------------------
local BUFF_BENEFICIARIES = {
	intellect = {
		MAGE = true, WARLOCK = true, PRIEST = true, DRUID = true,
		SHAMAN = true, MONK = true, EVOKER = true, PALADIN = true, DEMONHUNTER = true,
	},
	attackPower = {
		WARRIOR = true, ROGUE = true, HUNTER = true, DEATHKNIGHT = true,
		PALADIN = true, MONK = true, DRUID = true, DEMONHUNTER = true, SHAMAN = true,
	},
}

local RAID_BUFFS = {
	{ key = "motw", class = "DRUID", name = "Mark of the Wild", castSpell = 1126, buffIDs = { 1126, 432661 } },
	{ key = "bshout", class = "WARRIOR", name = "Battle Shout", castSpell = 6673, buffIDs = { 6673 }, benefit = "attackPower" },
	{ key = "fort", class = "PRIEST", name = "Power Word: Fortitude", castSpell = 21562, buffIDs = { 21562 } },
	{ key = "ai", class = "MAGE", name = "Arcane Intellect", castSpell = 1459, buffIDs = { 1459, 432778 }, benefit = "intellect" },
	{ key = "bronze", class = "EVOKER", name = "Blessing of the Bronze", castSpell = 364342,
		buffIDs = { 381732, 381741, 381746, 381748, 381749, 381750, 381751, 381752, 381753, 381754, 381756, 381757, 381758 } },
	{ key = "sky", class = "SHAMAN", name = "Skyfury", castSpell = 462854, buffIDs = { 462854 } },
}

-------------------------------------------------------------------------------
--  SPELL DATA -- Self Auras (stances / forms / self-buffs)
-------------------------------------------------------------------------------
local AURAS = {
	{ key = "symbiotic", class = "DRUID", name = "Symbiotic Relationship", castSpell = 474750, buffIDs = { 474754 }, requireGroup = true },
	{ key = "battle_stance", class = "WARRIOR", name = "Battle Stance", castSpell = 386164, buffIDs = { 386164 }, specs = { 71 } },
	{ key = "berserk_stance", class = "WARRIOR", name = "Berserker Stance", castSpell = 386196, buffIDs = { 386196 }, specs = { 72 } },
	{ key = "def_stance", class = "WARRIOR", name = "Defensive Stance", castSpell = 386208, buffIDs = { 386208 }, specs = { 73 } },
	{ key = "shadowform", class = "PRIEST", name = "Shadowform", castSpell = 232698, buffIDs = { 232698, 194249 }, specs = { 258 } },
	{ key = "devo_aura", class = "PALADIN", name = "Devotion Aura", castSpell = 465, buffIDs = { 465, 32223, 317920 }, noPvP = true },
}

-------------------------------------------------------------------------------
--  SPELL DATA -- Class Specials (poisons / rites / imbues / shields)
-------------------------------------------------------------------------------
local ROGUE_POISONS = {
	{ key = "deadly", name = "Deadly Poison", castSpell = 2823, cat = "lethal" },
	{ key = "amplifying", name = "Amplifying Poison", castSpell = 381664, cat = "lethal" },
	{ key = "instant", name = "Instant Poison", castSpell = 315584, cat = "lethal" },
	{ key = "wound", name = "Wound Poison", castSpell = 8679, cat = "lethal" },
	{ key = "numbing", name = "Numbing Poison", castSpell = 5761, cat = "nonlethal" },
	{ key = "atrophic", name = "Atrophic Poison", castSpell = 381637, cat = "nonlethal" },
	{ key = "crippling", name = "Crippling Poison", castSpell = 3408, cat = "nonlethal" },
}

local PALADIN_RITES = {
	{ key = "rite_adj", name = "Rite of Adjuration", castSpell = 433583, buffIDs = { 433583 } },
	{ key = "rite_sanc", name = "Rite of Sanctification", castSpell = 433568, buffIDs = { 433568 } },
}

local SHAMAN_IMBUES = {
	{ key = "flametongue", name = "Flametongue Weapon", castSpell = 318038, buffIDs = { 319778 } },
	{ key = "windfury", name = "Windfury Weapon", castSpell = 33757, buffIDs = { 319773 } },
	{ key = "earthliving", name = "Earthliving Weapon", castSpell = 382021, buffIDs = { 382021, 382022 } },
	{ key = "tidecaller", name = "Tidecaller's Guard", castSpell = 457481, buffIDs = { 457496, 457481 }, requireShield = true },
	{ key = "tstrike", name = "Thunderstrike Ward", castSpell = 462757, buffIDs = { 462757, 462742 }, requireShield = true },
}

local function ShamanShieldCastSpell()
	local specID = GetSpecID()
	return (specID == 264) and 52127 or 192106
end

local SHAMAN_SHIELDS = {
	{ key = "shield_basic", name = "Shield", castSpellFn = ShamanShieldCastSpell, buffIDs = { 974, 192106, 52127, 383648 } },
}

-------------------------------------------------------------------------------
--  SPELL DATA -- Bag/Equip Consumables (Midnight)
-------------------------------------------------------------------------------
local WEAPON_ENCHANT_ITEMS = {
	{ itemID = 237367, name = "Refulgent Weightstone", weaponType = "MELEE" },
	{ itemID = 237369, name = "Refulgent Weightstone", weaponType = "MELEE" },
	{ itemID = 237370, name = "Refulgent Whetstone", weaponType = "MELEE" },
	{ itemID = 237371, name = "Refulgent Whetstone", weaponType = "MELEE" },
	{ itemID = 257749, name = "Laced Zoomshots", weaponType = "RANGED" },
	{ itemID = 257750, name = "Laced Zoomshots", weaponType = "RANGED" },
	{ itemID = 257751, name = "Weighted Boomshots", weaponType = "RANGED" },
	{ itemID = 257752, name = "Weighted Boomshots", weaponType = "RANGED" },
	{ itemID = 243733, name = "Thalassian Phoenix Oil", weaponType = "NEUTRAL" },
	{ itemID = 243734, name = "Thalassian Phoenix Oil", weaponType = "NEUTRAL" },
	{ itemID = 243735, name = "Oil of Dawn", weaponType = "NEUTRAL" },
	{ itemID = 243736, name = "Oil of Dawn", weaponType = "NEUTRAL" },
	{ itemID = 243737, name = "Smuggler's Enchanted Edge", weaponType = "NEUTRAL" },
	{ itemID = 243738, name = "Smuggler's Enchanted Edge", weaponType = "NEUTRAL" },
}

local FLASK_ITEMS = {
	{ key = "blood_knights", buffID = 1235110, name = "Flask of the Blood Knights", items = { 241324, 241325, 245931, 245930 } },
	{ key = "magisters", buffID = 1235108, name = "Flask of the Magisters", items = { 241322, 241323, 245933, 245932 } },
	{ key = "shattered_sun", buffID = 1235111, name = "Flask of the Shattered Sun", items = { 241326, 241327, 245929, 245928 } },
	{ key = "thalassian_resistance", buffID = 1235057, name = "Flask of Thalassian Resistance", items = { 241320, 241321, 245926, 245927 } },
	{ key = "thalassian_horror", buffID = 1239355, name = "Vicious Thalassian Flask of Honor", items = { 241334 } },
}
local FLASK_BUFF_ID_SET = {}
for _, f in ipairs(FLASK_ITEMS) do
	FLASK_BUFF_ID_SET[f.buffID] = true
end

local FOOD_ITEMS = {
	{ key = "royal_roast", itemID = 242275, name = "Royal Roast" },
	{ key = "impossibly_royal_roast", itemID = 255847, name = "Impossibly Royal Roast" },
	{ key = "flora_frenzy", itemID = 255848, name = "Flora Frenzy" },
	{ key = "champions_bento", itemID = 242274, name = "Champion's Bento" },
	{ key = "warped_wise_wings", itemID = 242285, name = "Warped Wise Wings" },
	{ key = "void_kissed_fish_rolls", itemID = 242284, name = "Void-Kissed Fish Rolls" },
	{ key = "sun_seared_lumifin", itemID = 242283, name = "Sun-Seared Lumifin" },
	{ key = "null_and_void_plate", itemID = 242282, name = "Null and Void Plate" },
	{ key = "glitter_skewers", itemID = 242281, name = "Glitter Skewers" },
	{ key = "fel_kissed_filet", itemID = 242286, name = "Fel-Kissed Filet" },
	{ key = "buttered_root_crab", itemID = 242280, name = "Buttered Root Crab" },
	{ key = "arcano_cutlets", itemID = 242287, name = "Arcano Cutlets" },
	{ key = "tasty_smoked_tetra", itemID = 242278, name = "Tasty Smoked Tetra" },
	{ key = "crimson_calamari", itemID = 242277, name = "Crimson Calamari" },
	{ key = "braised_blood_hunter", itemID = 242276, name = "Braised Blood Hunter" },
	{ key = "queldorei_medley", itemID = 242272, name = "Quel'dorei Medley" },
	{ key = "blooming_feast", itemID = 242273, name = "Blooming Feast" },
	{ key = "sunwell_delight", itemID = 242293, name = "Sunwell Delight" },
	{ key = "hearthflame_supper", itemID = 242295, name = "Hearthflame Supper" },
	{ key = "fried_bloomtail", itemID = 242291, name = "Fried Bloomtail" },
	{ key = "felberry_figs", itemID = 242294, name = "Felberry Figs" },
	{ key = "eversong_pudding", itemID = 242292, name = "Eversong Pudding" },
	{ key = "wise_tails", itemID = 242290, name = "Wise Tails" },
	{ key = "twilight_anglers_medley", itemID = 242288, name = "Twilight Angler's Medley" },
	{ key = "spellfire_filet", itemID = 242289, name = "Spellfire Filet" },
	{ key = "spiced_biscuits", itemID = 242304, name = "Spiced Biscuits" },
	{ key = "silvermoon_standard", itemID = 242305, name = "Silvermoon Standard" },
	{ key = "quick_sandwich", itemID = 242307, name = "Quick Sandwich" },
	{ key = "portable_snack", itemID = 242308, name = "Portable Snack" },
	{ key = "mana_infused_stew", itemID = 242303, name = "Mana-Infused Stew" },
	{ key = "foragers_medley", itemID = 242306, name = "Forager's Medley" },
	{ key = "farstrider_rations", itemID = 242309, name = "Farstrider Rations" },
	{ key = "bloom_skewers", itemID = 242302, name = "Bloom Skewers" },
}

local WEAPON_ENCHANT_CHOICES = {
	{ key = "thalassian_phoenix_oil", name = "Thalassian Phoenix Oil" },
	{ key = "smugglers_enchanted_edge", name = "Smuggler's Enchanted Edge" },
	{ key = "oil_of_dawn", name = "Oil of Dawn" },
	{ key = "refulgent_weightstone", name = "Refulgent Weightstone" },
	{ key = "refulgent_whetstone", name = "Refulgent Whetstone" },
	{ key = "laced_zoomshots", name = "Laced Zoomshots" },
	{ key = "weighted_boomshots", name = "Weighted Boomshots" },
}

local RUNE_BUFF_IDS = { 1264426, 453250, 1234969, 1242347, 393438, 347901 }
local RUNE_ITEMS = { 259085, 243191 }

local WEAPON_ENCHANT_SLOTS = {
	{ slot = 16, key = "mh", label = L["Main Hand"] },
	{ slot = 17, key = "oh", label = L["Off Hand"] },
}

-------------------------------------------------------------------------------
--  Aura reading helpers
-------------------------------------------------------------------------------
local function PlayerHasAuraByID(ids)
	for _, id in ipairs(ids) do
		local ok, result = pcall(C_UnitAuras_GetPlayerAuraBySpellID, id)
		if ok and result ~= nil then return true end
	end
	return false
end

local function PlayerHasAuraByIDWithDuration(ids, showUnder)
	for _, id in ipairs(ids) do
		local ok, result = pcall(C_UnitAuras_GetPlayerAuraBySpellID, id)
		if ok and result ~= nil then
			local dur, exp = result.duration, result.expirationTime
			if dur and exp and not E:IsSecretValue(dur) and not E:IsSecretValue(exp)
				and IsUnderDuration(dur, exp, showUnder) then
				return false
			end
			return true
		end
	end
	return false
end

local function UnitHasAuraByID(unit, ids)
	for i = 1, 40 do
		local ok, aura = pcall(C_UnitAuras_GetAuraDataByIndex, unit, i, "HELPFUL")
		if not ok or not aura then break end
		local spellId = aura.spellId
		if spellId and not E:IsSecretValue(spellId) then
			for _, id in ipairs(ids) do
				if spellId == id then return true end
			end
		end
	end
	return false
end

local function PlayerHasBuffByIcon(iconID, showUnder)
	for i = 1, 40 do
		local ok, aura = pcall(C_UnitAuras_GetAuraDataByIndex, "player", i, "HELPFUL")
		if not ok then return true end
		if not aura then break end
		local ic = aura.icon
		if ic and not E:IsSecretValue(ic) and ic == iconID then
			local dur, exp = aura.duration, aura.expirationTime
			if dur and exp and not E:IsSecretValue(dur) and not E:IsSecretValue(exp)
				and IsUnderDuration(dur, exp, showUnder) then
				return false
			end
			return true
		end
	end
	return false
end

local function UnitBenefits(unit, benefit)
	if not benefit then return true end
	local classSet = BUFF_BENEFICIARIES[benefit]
	if not classSet then return true end
	local _, class = UnitClass(unit)
	if not class or E:IsSecretValue(class) then return false end
	return classSet[class] == true
end

local function CountGroupBuffCoverage(buffIDs, benefit)
	local have, total = 0, 0
	if IsInRaid() then
		for i = 1, GetNumGroupMembers() do
			local unit = "raid" .. i
			if UnitExists(unit) and not UnitIsDeadOrGhost(unit) and UnitInRange(unit) and UnitBenefits(unit, benefit) then
				total = total + 1
				if UnitHasAuraByID(unit, buffIDs) then have = have + 1 end
			end
		end
	elseif IsInGroup() then
		for i = 1, GetNumSubgroupMembers() do
			local unit = "party" .. i
			if UnitExists(unit) and not UnitIsDeadOrGhost(unit) and UnitInRange(unit) and UnitBenefits(unit, benefit) then
				total = total + 1
				if UnitHasAuraByID(unit, buffIDs) then have = have + 1 end
			end
		end
		if UnitBenefits("player", benefit) then
			total = total + 1
			if PlayerHasAuraByID(buffIDs) then have = have + 1 end
		end
	else
		total = 1
		if PlayerHasAuraByID(buffIDs) then have = 1 end
	end
	return have, total
end

-------------------------------------------------------------------------------
--  Weapon enchant / bag helpers
-------------------------------------------------------------------------------
-- Only RANGED vs MELEE is needed: Oils fit any weapon (NEUTRAL), Weightstones/
-- Whetstones are melee-only, Zoomshots/Boomshots are ranged-only. Shields,
-- held-in-off-hand items (tomes, relics) and empty slots return nil -- none
-- of those can take a temporary weapon enchant.
local ENCHANTABLE_EQUIP_LOCS = {
	INVTYPE_WEAPON = "MELEE",
	INVTYPE_2HWEAPON = "MELEE",
	INVTYPE_WEAPONMAINHAND = "MELEE",
	INVTYPE_WEAPONOFFHAND = "MELEE",
	INVTYPE_RANGED = "RANGED",
	INVTYPE_RANGEDRIGHT = "RANGED",
}

local function GetWeaponCategory(slotID)
	local link = GetInventoryItemLink("player", slotID)
	if not link then return nil end
	local equipLoc = select(4, GetItemInfoInstant(link))
	return ENCHANTABLE_EQUIP_LOCS[equipLoc]
end

local function HasShieldEquipped()
	local link = GetInventoryItemLink("player", 17)
	if not link then return false end
	return select(4, GetItemInfoInstant(link)) == "INVTYPE_SHIELD"
end

local _bagCounts = {}
local _bagCountsDirty = true
local function InvalidateBagCounts()
	_bagCountsDirty = true
end
local function RebuildBagCounts()
	wipe(_bagCounts)
	_bagCountsDirty = false
	for bag = 0, 4 do
		local numSlots = C_Container_GetContainerNumSlots(bag) or 0
		for slot = 1, numSlots do
			local info = C_Container_GetContainerItemInfo(bag, slot)
			if info and info.itemID then
				_bagCounts[info.itemID] = (_bagCounts[info.itemID] or 0) + (info.stackCount or 1)
			end
		end
	end
end
local function BagCount(itemID)
	if _bagCountsDirty then RebuildBagCounts() end
	return _bagCounts[itemID] or 0
end

local function FindFlaskItem(preferredKey, lastUsedItemID)
	if preferredKey == "last_used" then
		if lastUsedItemID and BagCount(lastUsedItemID) > 0 then return lastUsedItemID end
		for _, f in ipairs(FLASK_ITEMS) do
			for _, id in ipairs(f.items) do
				if BagCount(id) > 0 then return id end
			end
		end
		return nil
	end
	for _, f in ipairs(FLASK_ITEMS) do
		if f.key == preferredKey then
			for _, id in ipairs(f.items) do
				if BagCount(id) > 0 then return id end
			end
		end
	end
	return nil
end

local function FindFoodItem(preferredKey, lastUsedItemID)
	if preferredKey ~= "last_used" then
		for _, f in ipairs(FOOD_ITEMS) do
			if f.key == preferredKey and BagCount(f.itemID) > 0 then return f.itemID end
		end
	elseif lastUsedItemID and BagCount(lastUsedItemID) > 0 then
		return lastUsedItemID
	end
	for _, f in ipairs(FOOD_ITEMS) do
		if BagCount(f.itemID) > 0 then return f.itemID end
	end
	return nil
end

local function FindWeaponEnchantItem(preferredKey, lastUsedItemID, targetCat)
	if preferredKey == "last_used" then
		if lastUsedItemID and BagCount(lastUsedItemID) > 0 then return lastUsedItemID end
		for _, we in ipairs(WEAPON_ENCHANT_ITEMS) do
			if (we.weaponType == "NEUTRAL" or we.weaponType == targetCat) and BagCount(we.itemID) > 0 then
				return we.itemID
			end
		end
		return nil
	end
	for _, choice in ipairs(WEAPON_ENCHANT_CHOICES) do
		if choice.key == preferredKey then
			for _, we in ipairs(WEAPON_ENCHANT_ITEMS) do
				if we.name == choice.name and BagCount(we.itemID) > 0 then return we.itemID end
			end
			break
		end
	end
	return nil
end

-------------------------------------------------------------------------------
--  Glow -- pulsing border, ported from Armory/SocketPanel.lua's slot glow
-------------------------------------------------------------------------------
local function CreateIconGlow(btn)
	local glow = CreateFrame("Frame", nil, btn)
	glow:SetAllPoints(btn)
	glow:SetFrameLevel(btn:GetFrameLevel() + 5)

	local top = glow:CreateTexture(nil, "OVERLAY")
	top:SetTexture(E.media.blankTex)
	top:SetHeight(2)
	top:SetPoint("TOPLEFT")
	top:SetPoint("TOPRIGHT")

	local bottom = glow:CreateTexture(nil, "OVERLAY")
	bottom:SetTexture(E.media.blankTex)
	bottom:SetHeight(2)
	bottom:SetPoint("BOTTOMLEFT")
	bottom:SetPoint("BOTTOMRIGHT")

	local left = glow:CreateTexture(nil, "OVERLAY")
	left:SetTexture(E.media.blankTex)
	left:SetWidth(2)
	left:SetPoint("TOPLEFT")
	left:SetPoint("BOTTOMLEFT")

	local right = glow:CreateTexture(nil, "OVERLAY")
	right:SetTexture(E.media.blankTex)
	right:SetWidth(2)
	right:SetPoint("TOPRIGHT")
	right:SetPoint("BOTTOMRIGHT")

	glow.textures = { top, bottom, left, right }

	local anim = glow:CreateAnimationGroup()
	anim:SetLooping("BOUNCE")
	local alpha = anim:CreateAnimation("Alpha")
	alpha:SetFromAlpha(0.2)
	alpha:SetToAlpha(1)
	alpha:SetDuration(0.6)
	alpha:SetSmoothing("IN_OUT")
	glow.anim = anim

	btn.glow = glow
	return glow
end

local function ApplyGlow(btn)
	local db = module.db
	if not db.glowEnable then
		if btn.glow then btn.glow:Hide() end
		return
	end

	local glow = btn.glow or CreateIconGlow(btn)
	local c = db.glowColor or { r = 1, g = 0.82, b = 0 }
	for _, tex in ipairs(glow.textures) do
		tex:SetVertexColor(c.r, c.g, c.b, 1)
	end
	glow:Show()
	if not glow.anim:IsPlaying() then glow.anim:Play() end
end

local function RemoveGlow(btn)
	if btn.glow then
		btn.glow.anim:Stop()
		btn.glow:Hide()
	end
end

-------------------------------------------------------------------------------
--  Icon pool -- SecureActionButton based, click-to-cast
-------------------------------------------------------------------------------
local ICON_SIZE = 36
local iconAnchor
local iconPool = {}
local activeIcons = {}

local function GetOrCreateIcon(index)
	if iconPool[index] then return iconPool[index] end

	local btn = CreateFrame("Button", "MER_BuffReminderIcon" .. index, iconAnchor, "SecureActionButtonTemplate")
	btn:SetSize(ICON_SIZE, ICON_SIZE)
	btn:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "MiddleButtonUp")
	btn:SetFrameStrata(module.db.frameStrata or "MEDIUM")
	btn:Hide()

	local icon = btn:CreateTexture(nil, "ARTWORK")
	icon:SetAllPoints()
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	btn._icon = icon
	S:CreateBG(icon)

	local text = btn:CreateFontString(nil, "OVERLAY")
	text:SetPoint("TOP", btn, "BOTTOM", 0, -2)
	text:FontTemplate(nil, module.db.textSize or 11, module.db.textOutline)
	btn._text = text

	local count = btn:CreateFontString(nil, "OVERLAY")
	count:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -1, 1)
	count:FontTemplate(nil, 10, "OUTLINE")
	btn._count = count

	btn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		if self._tooltipSpell then
			GameTooltip:SetSpellByID(self._tooltipSpell)
		elseif self._tooltipItem then
			GameTooltip:SetItemByID(self._tooltipItem)
		elseif self._label then
			GameTooltip:SetText(self._label)
		end
		GameTooltip:Show()
	end)
	btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

	btn:HookScript("PostClick", function(self, button)
		if button == "MiddleButton" and self._dismissKey then
			module._dismissedUntilLoad[self._dismissKey] = true
			module:RequestRefresh()
		end
	end)

	iconPool[index] = btn
	return btn
end

local function SetIconSpell(btn, spellID, texture)
	if not InCombat() then
		btn:SetAttribute("type", "spell")
		btn:SetAttribute("spell", spellID)
		btn:SetAttribute("item", nil)
		btn:SetAttribute("macrotext", nil)
	end
	btn._icon:SetTexture(texture or Tex(spellID) or 134400)
	btn._tooltipSpell = spellID
	btn._tooltipItem = nil
end

local function SetIconItem(btn, itemID, texture)
	if not InCombat() then
		btn:SetAttribute("type", "item")
		btn:SetAttribute("item", "item:" .. itemID)
		btn:SetAttribute("spell", nil)
		btn:SetAttribute("macrotext", nil)
	end
	btn._icon:SetTexture(texture or GetItemIcon(itemID) or 134400)
	btn._tooltipSpell = nil
	btn._tooltipItem = itemID
end

local function SetIconMacro(btn, macrotext, texture)
	if not InCombat() then
		btn:SetAttribute("type", "macro")
		btn:SetAttribute("macrotext", macrotext)
		btn:SetAttribute("spell", nil)
		btn:SetAttribute("item", nil)
	end
	btn._icon:SetTexture(texture or 134400)
	btn._tooltipSpell = nil
	btn._tooltipItem = nil
end

-------------------------------------------------------------------------------
--  Missing-entry collection
-------------------------------------------------------------------------------
local entryPool = {}
local entriesInUse = 0
local function AcquireEntry()
	entriesInUse = entriesInUse + 1
	local e = entryPool[entriesInUse]
	if not e then
		e = {}
		entryPool[entriesInUse] = e
	end
	e.mode, e.spellID, e.itemID, e.macro, e.texture, e.label = nil, nil, nil, nil, nil, nil
	e.dismissKey, e.bagCount, e.desaturated = nil, nil, false
	return e
end

local function CollectRaidBuffs(missing, playerClass, db)
	local rb = db.raidBuffs
	if not rb.enable then return end
	local inPvP = InPvPInstance()
	for _, buff in ipairs(RAID_BUFFS) do
		if rb.enabled[buff.key] and buff.class == playerClass and Known(buff.castSpell) and not inPvP then
			local groupHave, groupTotal = CountGroupBuffCoverage(buff.buffIDs, buff.benefit)
			if groupTotal > 0 and groupHave < groupTotal then
				local e = AcquireEntry()
				e.mode = "spell"
				e.spellID = buff.castSpell
				e.label = ShortLabel(SpellName(buff.castSpell, buff.name))
				e.dismissKey = "raidbuff:" .. buff.key
				missing[#missing + 1] = e
			end
		end
	end
end

local function CollectAuras(missing, playerClass, specID, db)
	local au = db.auras
	if not au.enable then return end
	for _, aura in ipairs(AURAS) do
		if au.enabled[aura.key] and aura.class == playerClass and Known(aura.castSpell)
			and not (aura.noPvP and InPvPInstance()) then
			local specOk = true
			if aura.specs then
				specOk = false
				for _, s in ipairs(aura.specs) do
					if s == specID then specOk = true; break end
				end
			end
			if specOk and aura.requireGroup and not (IsInGroup() or IsInRaid()) then
				specOk = false
			end
			if specOk and not PlayerHasAuraByID(aura.buffIDs) then
				local e = AcquireEntry()
				e.mode = "spell"
				e.spellID = aura.castSpell
				e.label = ShortLabel(SpellName(aura.castSpell, aura.name))
				e.dismissKey = "aura:" .. aura.key
				missing[#missing + 1] = e
			end
		end
	end
end

local function CollectClassSpecials(missing, playerClass, co)
	if playerClass == "ROGUE" then
		local haveLethal, haveNonLethal = false, false
		for _, p in ipairs(ROGUE_POISONS) do
			if PlayerHasAuraByID({ p.castSpell }) then
				if p.cat == "lethal" then haveLethal = true else haveNonLethal = true end
			end
		end
		for _, p in ipairs(ROGUE_POISONS) do
			local already = (p.cat == "lethal" and haveLethal) or (p.cat == "nonlethal" and haveNonLethal)
			if co.enabled[p.key] and Known(p.castSpell) and not already and not PlayerHasAuraByID({ p.castSpell }) then
				local e = AcquireEntry()
				e.mode = "spell"; e.spellID = p.castSpell
				e.label = ShortLabel(SpellName(p.castSpell, p.name))
				e.dismissKey = "consumable:" .. p.key
				missing[#missing + 1] = e
			end
		end
	elseif playerClass == "PALADIN" then
		for _, r in ipairs(PALADIN_RITES) do
			if co.enabled[r.key] and Known(r.castSpell) and not PlayerHasAuraByID(r.buffIDs) then
				local e = AcquireEntry()
				e.mode = "spell"; e.spellID = r.castSpell
				e.label = ShortLabel(SpellName(r.castSpell, r.name))
				e.dismissKey = "consumable:" .. r.key
				missing[#missing + 1] = e
			end
		end
	elseif playerClass == "SHAMAN" then
		for _, im in ipairs(SHAMAN_IMBUES) do
			if co.enabled[im.key] and Known(im.castSpell) and (not im.requireShield or HasShieldEquipped())
				and not PlayerHasAuraByID(im.buffIDs) then
				local e = AcquireEntry()
				e.mode = "spell"; e.spellID = im.castSpell
				e.label = ShortLabel(SpellName(im.castSpell, im.name))
				e.dismissKey = "consumable:" .. im.key
				missing[#missing + 1] = e
			end
		end
		for _, sh in ipairs(SHAMAN_SHIELDS) do
			if co.enabled[sh.key] and not PlayerHasAuraByID(sh.buffIDs) then
				local spellID = sh.castSpellFn and sh.castSpellFn() or sh.castSpell
				if spellID and Known(spellID) then
					local e = AcquireEntry()
					e.mode = "spell"; e.spellID = spellID
					e.label = ShortLabel(SpellName(spellID, sh.name))
					e.dismissKey = "consumable:" .. sh.key
					missing[#missing + 1] = e
					break
				end
			end
		end
	end
end

local function CollectConsumables(missing, playerClass, co)
	if not co.enable then return end

	if co.enabled.flask then
		local missingFlask = true
		for id in pairs(FLASK_BUFF_ID_SET) do
			if PlayerHasAuraByIDWithDuration({ id }, module.db.showUnder) then missingFlask = false; break end
		end
		if missingFlask then
			local itemID = FindFlaskItem(co.preferredFlask, module.db.lastUsedFlask)
			if itemID and (co.showWithoutItem ~= false or BagCount(itemID) > 0) then
				local e = AcquireEntry()
				e.mode = "item"; e.itemID = itemID
				e.label = L["Flask"]
				e.bagCount = BagCount(itemID)
				e.desaturated = BagCount(itemID) == 0
				e.dismissKey = "consumable:flask"
				missing[#missing + 1] = e
			end
		end
	end

	if co.enabled.food and not PlayerHasBuffByIcon(136000, module.db.showUnder) then
		local itemID = FindFoodItem(co.preferredFood, module.db.lastUsedFood)
		if itemID and (co.showWithoutItem ~= false or BagCount(itemID) > 0) then
			local e = AcquireEntry()
			e.mode = "item"; e.itemID = itemID
			e.label = L["Food"]
			e.bagCount = BagCount(itemID)
			e.desaturated = BagCount(itemID) == 0
			e.dismissKey = "consumable:food"
			missing[#missing + 1] = e
		end
	end

	if co.enabled.augment_rune and not PlayerHasAuraByIDWithDuration(RUNE_BUFF_IDS, module.db.showUnder) then
		local itemID
		for _, id in ipairs(RUNE_ITEMS) do
			if BagCount(id) > 0 then itemID = id; break end
		end
		itemID = itemID or RUNE_ITEMS[1]
		if co.showWithoutItem ~= false or BagCount(itemID) > 0 then
			local e = AcquireEntry()
			e.mode = "item"; e.itemID = itemID
			e.label = L["Rune"]
			e.bagCount = BagCount(itemID)
			e.desaturated = BagCount(itemID) == 0
			e.dismissKey = "consumable:augment_rune"
			missing[#missing + 1] = e
		end
	end

	if co.enabled.weapon_enchant then
		local hasMH, hasOH
		if C_PaperDollInfo and C_PaperDollInfo.GetTemporaryEnchantmentInfo then
			hasMH = C_PaperDollInfo.GetTemporaryEnchantmentInfo(INVSLOT_MAINHAND) ~= nil
			hasOH = C_PaperDollInfo.GetTemporaryEnchantmentInfo(INVSLOT_OFFHAND) ~= nil
		else
			hasMH, _, _, _, hasOH = GetWeaponEnchantInfo()
		end
		for _, slotInfo in ipairs(WEAPON_ENCHANT_SLOTS) do
			local cat = GetWeaponCategory(slotInfo.slot)
			if cat then
				local has = (slotInfo.slot == 16) and hasMH or hasOH
				if not has then
					local itemID = FindWeaponEnchantItem(co.preferredWeaponEnchant, module.db.lastUsedWeaponEnchant, cat)
					if itemID and (co.showWithoutItem ~= false or BagCount(itemID) > 0) then
						local e = AcquireEntry()
						e.mode = "macro"
						e.macro = "/use item:" .. itemID .. "\n/use " .. slotInfo.slot
						e.texture = GetItemIcon(itemID)
						e.label = slotInfo.label
						e.bagCount = BagCount(itemID)
						e.desaturated = BagCount(itemID) == 0
						e.dismissKey = "consumable:weapon_enchant_" .. slotInfo.key
						missing[#missing + 1] = e
					end
				end
			end
		end
	end

	CollectClassSpecials(missing, playerClass, co)
end

-------------------------------------------------------------------------------
--  Sounds
-------------------------------------------------------------------------------
local _soundPrev, _soundCur, _soundPrimed = {}, {}, false
local function HandleAppearSounds(missing)
	local db = module.db
	wipe(_soundCur)
	for i = 1, #missing do
		local dk = missing[i].dismissKey
		if dk then
			_soundCur[dk] = true
			if _soundPrimed and not _soundPrev[dk] and db.sound.enable then
				local prefix = dk:match("^(%a+):")
				local key = prefix == "raidbuff" and "raidBuffs" or prefix == "aura" and "auras" or "consumables"
				if db.sound[key] then
					PlaySound(db.sound.soundKitID or 8960, "Master")
				end
				break
			end
		end
	end
	_soundPrev, _soundCur = _soundCur, _soundPrev
	_soundPrimed = true
end

-------------------------------------------------------------------------------
--  Layout & Refresh
-------------------------------------------------------------------------------
local function HideAllIcons()
	for _, btn in pairs(iconPool) do
		RemoveGlow(btn)
		btn._count:SetText("")
		btn:Hide()
	end
	wipe(activeIcons)
end

local function LayoutIcons()
	local count = #activeIcons
	if count == 0 then return end
	local db = module.db
	local spacing = db.iconSpacing or 6
	local sz = floor(ICON_SIZE * (db.scale or 1) + 0.5)
	local totalW = (count * sz) + ((count - 1) * spacing)
	local textH = db.showText and ((db.textSize or 11) + 4) or 0
	local startX = -(totalW / 2) + (sz / 2)

	for i, btn in ipairs(activeIcons) do
		btn:SetSize(sz, sz)
		btn:ClearAllPoints()
		btn:SetPoint("CENTER", iconAnchor, "CENTER", startX + (i - 1) * (sz + spacing), textH / 2)
	end
	iconAnchor:SetSize(max(totalW, sz), sz + textH)
end

local function ApplyEntry(btn, e)
	if e.mode == "spell" then
		SetIconSpell(btn, e.spellID, e.texture)
	elseif e.mode == "item" then
		SetIconItem(btn, e.itemID, e.texture)
	elseif e.mode == "macro" then
		SetIconMacro(btn, e.macro, e.texture)
	end

	btn._label = e.label
	btn._dismissKey = e.dismissKey
	btn._icon:SetDesaturated(e.desaturated or false)

	local db = module.db
	if db.showText then
		btn._text:SetText(e.label or "")
		btn._text:Show()
	else
		btn._text:SetText("")
		btn._text:Hide()
	end

	if db.showBagCount and e.bagCount ~= nil then
		btn._count:SetText(e.bagCount > 0 and e.bagCount or "|cffff3333" .. e.bagCount .. "|r")
	else
		btn._count:SetText("")
	end

	ApplyGlow(btn)
	btn:Show()
end

local _refreshMissing = {}
function module:Refresh()
	local db = self.db
	if not db or not db.enable or not iconAnchor then return end
	if InCombatLockdown() then return end

	if UnitInVehicle("player") or (IsMounted() and IsFlying() and db.hideWhileMounted)
		or UnitIsDeadOrGhost("player") or IsResting() then
		HideAllIcons()
		return
	end

	local playerClass = GetPlayerClass()
	local specID = GetSpecID()
	local inInstance = InRealInstancedContent()

	if db.hideInOpenWorld and not inInstance then
		HideAllIcons()
		return
	end

	entriesInUse = 0
	local missing = _refreshMissing
	wipe(missing)

	CollectRaidBuffs(missing, playerClass, db)
	CollectAuras(missing, playerClass, specID, db)
	if not InPvPInstance() then
		CollectConsumables(missing, playerClass, db.consumables)
	end

	HandleAppearSounds(missing)

	HideAllIcons()
	for i, e in ipairs(missing) do
		if not (e.dismissKey and self._dismissedUntilLoad[e.dismissKey]) then
			local btn = GetOrCreateIcon(i)
			ApplyEntry(btn, e)
			activeIcons[#activeIcons + 1] = btn
		end
	end

	if #activeIcons > 0 then
		LayoutIcons()
		iconAnchor:Show()
	else
		iconAnchor:Hide()
	end
end

-- Text size/outline and frame strata are only applied when a pooled icon is
-- first created; re-apply them to the whole pool when those options change.
function module:RestyleIcons()
	for _, btn in pairs(iconPool) do
		btn:SetFrameStrata(module.db.frameStrata or "MEDIUM")
		btn._text:FontTemplate(nil, module.db.textSize or 11, module.db.textOutline)
	end
end

local _refreshQueued = false
function module:RequestRefresh()
	if _refreshQueued or InCombatLockdown() then return end
	_refreshQueued = true
	E:Delay(0.2, function()
		_refreshQueued = false
		module:Refresh()
	end)
end

-------------------------------------------------------------------------------
--  Lifecycle
-------------------------------------------------------------------------------
module._dismissedUntilLoad = {}

local EVENTS = {
	"UNIT_AURA", "PLAYER_EQUIPMENT_CHANGED", "BAG_UPDATE", "PLAYER_REGEN_ENABLED",
	"PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA", "GROUP_ROSTER_UPDATE",
	"PLAYER_TALENT_UPDATE", "SPELLS_CHANGED",
}

function module:UNIT_AURA(_, unit)
	if unit == "player" then InvalidateBagCounts() end
	self:RequestRefresh()
end

function module:BAG_UPDATE()
	InvalidateBagCounts()
	self:RequestRefresh()
end

function module:PLAYER_EQUIPMENT_CHANGED()
	InvalidateBagCounts()
	self:RequestRefresh()
end

function module:PLAYER_REGEN_ENABLED()
	self:RequestRefresh()
end

function module:GROUP_ROSTER_UPDATE()
	self:RequestRefresh()
end

function module:PLAYER_ENTERING_WORLD()
	wipe(self._dismissedUntilLoad)
	InvalidateBagCounts()
	self:RequestRefresh()
end

module.ZONE_CHANGED_NEW_AREA = module.RequestRefresh
module.PLAYER_TALENT_UPDATE = module.RequestRefresh
module.SPELLS_CHANGED = module.RequestRefresh

function module:Initialize()
	local db = F.GetDBFromPath("mui.buffReminder") or E.db.mui.buffReminder
	module.db = db

	if not db.enable then return end

	iconAnchor = CreateFrame("Frame", "MER_BuffReminderAnchor", E.UIParent)
	iconAnchor:SetSize(ICON_SIZE, ICON_SIZE)
	iconAnchor:Point("CENTER", E.UIParent, "CENTER", 0, 200)
	iconAnchor:Hide()

	E:CreateMover(
		iconAnchor,
		"MER_BuffReminderMover",
		MER.Title .. L["Buff Reminder"],
		nil, nil, nil,
		"ALL,SOLO,MERATHILISUI",
		nil,
		"mui,modules,buffReminder"
	)

	for _, event in ipairs(EVENTS) do
		self:RegisterEvent(event)
	end

	self:RequestRefresh()
end

function module:ProfileUpdate()
	local db = F.GetDBFromPath("mui.buffReminder") or E.db.mui.buffReminder
	module.db = db
	if iconAnchor then
		self:RequestRefresh()
	end
end

MER:RegisterModule(module:GetName())
