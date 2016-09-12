local E, L, V, P, G = unpack(ElvUI);

----------------------------------------------------------------------------------------
-- Skins options
----------------------------------------------------------------------------------------
V['muiSkins'] = {
	['blizzard'] = {
		['character'] = true,
		['encounterjournal'] = true,
		['gossip'] = true,
		['objectivetracker'] = {
			['enable'] = true,
			['autoHide'] = false,
			['underlines'] = true,
			['backdrop'] = true,
		},

		['quest'] = true,
		['spellbook'] = true,
		-- ['worldmap'] = true,
		['orderhall'] = {
			['enable'] = true,
			['zoneText'] = true,
		},
	},
	['addonSkins'] = {
		['mp'] = true,
	},
	['elvuiAddons'] = {
		['sle'] = true,
	},
}
