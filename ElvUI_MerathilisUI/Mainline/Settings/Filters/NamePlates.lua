local MER, F, E, L, V, P, G = unpack(select(2, ...))

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
