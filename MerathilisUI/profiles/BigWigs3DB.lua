local E, L, V, P, G, _ = unpack(ElvUI);

local addon, db, ace3 = "BigWigs", "BigWigs3DB", false
local profile = {
	["namespaces"] = {
		["BigWigs_Bosses_The Iron Maidens"] = {
			["profiles"] = {
				["Default"] = {
					["custom_off_heartseeker_marker"] = true,
				},
			},
		},
		["BigWigs_Bosses_Mannoroth"] = {
			["profiles"] = {
				["Default"] = {
					[181597] = 547,
					["custom_off_gaze_marker"] = true,
					[181799] = 515,
				},
			},
		},
		["BigWigs_Plugins_Alt Power"] = {
			["profiles"] = {
				["Default"] = {
					["posx"] = 810.718497504029,
					["fontSize"] = 10.9999990463257,
					["font"] = "Merathilis Prototype",
					["fontOutline"] = "",
					["lock"] = true,
					["posy"] = 202.206108761591,
				},
			},
		},
		["LibDualSpec-1.0"] = {
		},
		["BigWigs_Bosses_Archimonde"] = {
			["profiles"] = {
				["Default"] = {
					[187180] = 579,
					[183817] = 0,
				},
			},
		},
		["BigWigs_Plugins_Victory"] = {
		},
		["BigWigs_Plugins_Statistics"] = {
		},
		["BigWigs_Plugins_Sounds"] = {
		},
		["BigWigs_Plugins_Messages"] = {
			["profiles"] = {
				["Default"] = {
					["BWEmphasizeMessageAnchor_x"] = 548.018613931999,
					["BWEmphasizeCountdownMessageAnchor_x"] = 594.167263362324,
					["BWMessageAnchor_x"] = 547.937125897879,
					["chat"] = false,
					["BWEmphasizeCountdownMessageAnchor_y"] = 542.227131600485,
					["font"] = "Merathilis Prototype",
					["BWEmphasizeMessageAnchor_y"] = 634.599967567738,
					["BWMessageAnchor_y"] = 482.660092769766,
					["growUpwards"] = true,
					["fontSize"] = 20,
				},
			},
		},
		["BigWigs_Bosses_Kilrogg Deadeye"] = {
			["profiles"] = {
				["Default"] = {
					[182428] = 66051,
				},
			},
		},
		["BigWigs_Plugins_Proximity"] = {
			["profiles"] = {
				["Default"] = {
					["fontSize"] = 20,
					["width"] = 140.000030517578,
					["posy"] = 139.937301559658,
					["lock"] = false,
					["posx"] = 316.168293714338,
					["sound"] = true,
					["font"] = "Merathilis Prototype",
				},
			},
		},
		["BigWigs_Plugins_BossBlock"] = {
		},
		["BigWigs_Plugins_HeroesVoices"] = {
		},
		["BigWigs_Plugins_Raid Icons"] = {
		},
		["BigWigs_Plugins_Bars"] = {
			["profiles"] = {
				["Default"] = {
					["outline"] = "OUTLINE",
					["fontSize"] = 20,
					["scale"] = 0.9,
					["BigWigsAnchor_y"] = 143.539996791631,
					["emphasizeGrowup"] = true,
					["BigWigsAnchor_x"] = 951.685603728169,
					["texture"] = "MerathilisFlat",
					["emphasizeTime"] = 14,
					["barStyle"] = "AddOnSkins Half-Bar",
					["monochrome"] = false,
					["BigWigsEmphasizeAnchor_x"] = 445.301161921743,
					["font"] = "Merathilis Roadway",
					["BigWigsEmphasizeAnchor_y"] = 188.360327821069,
					["fill"] = false,
					["BigWigsAnchor_width"] = 363.885375976563,
					["BigWigsEmphasizeAnchor_width"] = 532.931091308594,
					["emphasizeScale"] = 1.1,
				},
			},
		},
		["BigWigs_Bosses_Fel Lord Zakuun"] = {
			["profiles"] = {
				["Default"] = {
					[179583] = 66051,
				},
			},
		},
		["BigWigs_Plugins_Super Emphasize"] = {
			["profiles"] = {
				["Default"] = {
					["font"] = "Merathilis Prototype",
				},
			},
		},
		["BigWigs_Bosses_Gorefiend"] = {
			["profiles"] = {
				["Default"] = {
					[181295] = 66307,
				},
			},
		},
		["BigWigs_Bosses_Hans'gar and Franzok"] = {
			["profiles"] = {
				["Default"] = {
					["stages"] = 66051,
					[162124] = 66051,
				},
			},
		},
		["BigWigs_Plugins_Colors"] = {
		},
		["BigWigs_Plugins_Respawn"] = {
		},
		["BigWigs_Bosses_Xhul'horac"] = {
			["profiles"] = {
				["Default"] = {
					[190224] = 1539,
					[190223] = 1539,
					[186453] = 4611,
				},
			},
		},
		["profiles"] = {
			["Default"] = {
				["fakeDBMVersion"] = true,
			},
		},
	},
}

E:RegisterProfile(addon, db, profile, ace3)
