local E, L, V, P, G = unpack(ElvUI);

----------------------------------------------------------------------------------------
-- Skins options
----------------------------------------------------------------------------------------
V['muiSkins'] = {
	['blizzard'] = {
		['character'] = true,
		['encounterjournal'] = true,
		['gossip'] = true,
		["objectivetracker"] = {
			["enable"] = true,
			["underlines"] = true,
			["backdrop"] = true,
			["headerTitle"] = {
				["font"] = "Merathilis Roboto-Black",
				["size"] = 14,
				["outline"] = "OUTLINE",
			},
			["header"] = {
				["font"] = "Merathilis Roboto-Black",
				["size"] = 14,
				["outline"] = "OUTLINE",
			},
			["objectiveHeader"] = {
				["font"] = "Merathilis Roboto-Black",
				["size"] = 12,
				["outline"] = "NONE",
			},
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
