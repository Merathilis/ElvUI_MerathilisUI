local MER, F, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua functions

--WoW API / Variables

G.nameplates.filters.Neutral = {
	triggers = {
		notTarget = true,
		outOfCombatUnit = true,
		outOfVehicle = true,
		reactionType = {
			enable = true,
			reputation = true,
			neutral = true,
		},
	},
	actions = {
		nameOnly = true,
	},
}
