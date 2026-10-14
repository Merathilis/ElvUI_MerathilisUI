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

-- Only UnitName can be secret (identity restricted units), F.GradientName handles that.
-- The other results are guarded anyway so a future API change can't break the tag.
E:AddTag("name:MER:gradient", "UNIT_NAME_UPDATE UNIT_FACTION INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
	local name = UnitName(unit)
	if not name then
		return
	end

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
end)
E:AddTagInfo("name:MER:gradient", MER.Title, "Displays the name in a class or reaction color gradient")
