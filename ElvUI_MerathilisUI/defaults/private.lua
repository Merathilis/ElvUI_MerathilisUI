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
		['encounterjournal'] = true,
		['spellbook'] = true, -- Remove the Background of the Spellbook
		['objectivetracker'] = true,
		['glyph'] = true, -- Remove the Background of the GlyphFrame
	},
	['addonSkins'] = {
		['mp'] = true, -- Skins the additional MasterPlan Tabs
	},
	['elvuiAddons'] = {
		['sle'] = true -- Skin some unskinned SLE_Legion Elements
	},
}
