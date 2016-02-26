local E, L, V, P, G = unpack(ElvUI);

----------------------------------------------------------------------------------------
--	Reminder options
----------------------------------------------------------------------------------------
V['reminder'] = {
	['enable'] = false,
	['sound'] = "Warning",
}

----------------------------------------------------------------------------------------
--	Skins options
----------------------------------------------------------------------------------------
V['mui'] = {
	['skins'] = {
		['blizzard'] = {
			['encounterjournal'] = true,
			['spellbook'] = true, -- Remove the Background of the Spellbook
			['objectivetracker'] = true,
		},
		['addons'] = {
			['MasterPlan'] = true, -- Skins the additional MasterPlan Tabs
		},
	},
}
