local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua functions

--WoW API / Variables

G.nameplate.filters.Neutral = {
	triggers = {
		notTarget = true,
		outOfCombatUnit = true,
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
