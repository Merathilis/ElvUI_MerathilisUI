local E, L, V, P, G = unpack(ElvUI);

----------------------------------------------------------------------------------------
--	Reminder options
----------------------------------------------------------------------------------------
V['reminder'] = {
	['enable'] = true,
	['sound'] = "Warning",
}

----------------------------------------------------------------------------------------
--	Skins options
----------------------------------------------------------------------------------------
V['muiSkins'] = {
	['blizzard'] = {
		['encounterjournal'] = false,
		['spellbook'] = false, -- Remove the Background of the Spellbook
		['objectivetracker'] = false,
		['glyph'] = false, -- Remove the Background of the GlyphFrame
	},
	['addonSkins'] = {
		['mp'] = false, -- Skins the additional MasterPlan Tabs
	},
	['elvuiAddons'] = {
		['sle'] = false -- Skin some unskinned SLE_Legion Elements
	},
}
