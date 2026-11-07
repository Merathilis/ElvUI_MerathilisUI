local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local UnitClass = UnitClass
local UnitName = UnitName
local UnitInPartyIsAI = UnitInPartyIsAI
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction

-- UnitReaction -> gradient key of F.GradientName
local REACTION_GRADIENTS = {
	[1] = "NPCHOSTILE",
	[2] = "NPCHOSTILE",
	[3] = "NPCUNFRIENDLY",
	[4] = "NPCNEUTRAL",
	[5] = "NPCFRIENDLY",
	[6] = "NPCFRIENDLY",
	[7] = "NPCFRIENDLY",
	[8] = "NPCFRIENDLY",
}

local NAME_EVENTS = "UNIT_NAME_UPDATE UNIT_FACTION INSTANCE_ENCOUNTER_ENGAGE_UNIT"

-- Only UnitName can be secret (identity restricted units), F.GradientName handles that.
-- The other results are guarded anyway so a future API change can't break the tag.
local function GradientName(unit, name)
	local isPlayer = UnitIsPlayer(unit)
	local isAI = UnitInPartyIsAI and UnitInPartyIsAI(unit)
	if E:NotSecretValue(isPlayer) and isPlayer or E:NotSecretValue(isAI) and isAI then
		local _, unitClass = UnitClass(unit)
		if not unitClass or E:IsSecretValue(unitClass) then
			return name
		end

		return F.GradientName(name, unitClass, false, true)
	end

	local reaction = UnitReaction(unit, "player")
	local gradient = E:NotSecretValue(reaction) and REACTION_GRADIENTS[reaction]
	if gradient then
		return F.GradientName(name, gradient, false, true)
	end

	-- Reaction unknown or secret: plain (possibly secret) name
	return name
end

E:AddTag("name:MER:gradient", NAME_EVENTS, function(unit)
	local name = UnitName(unit)
	if not name then
		return
	end

	return GradientName(unit, name)
end)
E:AddTagInfo("name:MER:gradient", MER.Title, "Displays the name in a class or reaction color gradient")

-- On WoW Forever the second UnitName return is the surname (Retail: the realm), joined the
-- way Blizzard's Camelot NameUtil.FormatUnitNameForDisplay does. Secret parts can't be
-- concatenated, so those units fall back to the first name only. Retail shows the first name.
E:AddTag("name:MER:gradient:full", NAME_EVENTS, function(unit)
	local name, surname = UnitName(unit)
	if not name then
		return
	end

	if E.Forever and surname and E:NotSecretValue(name) and E:NotSecretValue(surname) and surname ~= "" then
		local consts = _G.Constants and _G.Constants.CharacterNameSeparatorConsts
		name = name .. (consts and consts.CHARACTERNAME_SURNAME_SEPARATOR or " ") .. surname
	end

	return GradientName(unit, name)
end)
E:AddTagInfo(
	"name:MER:gradient:full",
	MER.Title,
	"Displays the full name with surname (WoW Forever) in a class or reaction color gradient"
)
