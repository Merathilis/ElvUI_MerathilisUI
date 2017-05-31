local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: BigWigs3DB, LibStub

function MER:LoadBigWigsProfile()
	--[[----------------------------------
	--	BigWigs - Settings
	--]]----------------------------------
	BigWigs3DB = {
		["namespaces"] = {
			["BigWigs_Plugins_Victory"] = {},
			["BigWigs_Plugins_Colors"] = {},
			["BigWigs_Plugins_Alt Power"] = {
				["profiles"] = {
					["MerathilisUI"] = {
						["posx"] = 335.58,
						["fontSize"] = 11,
						["fontOutline"] = "",
						["font"] = "Merathilis Roboto-Bold",
						["lock"] = true,
						["posy"] = 74,
					},
				},
			},
			["BigWigs_Plugins_BossBlock"] = {},
			["BigWigs_Plugins_Bars"] = {
				["profiles"] = {
					["MerathilisUI"] = {
						["BigWigsEmphasizeAnchor_y"] = 274.777784431353,
						["fontSize"] = 11,
						["BigWigsAnchor_width"] = 239.999954223633,
						["BigWigsAnchor_y"] = 265.177697393337,
						["BigWigsEmphasizeAnchor_x"] = 251.977762177876,
						["barStyle"] = "MerathilisUI",
						["emphasizeGrowup"] = true,
						["BigWigsAnchor_x"] = 1018.51096216262,
						["outline"] = "OUTLINE",
						["BigWigsEmphasizeAnchor_width"] = 244.999984741211,
						["font"] = "Merathilis Roboto-Bold",
						["emphasizeScale"] = 1.1,
						["texture"] = "MerathilisBlank",
					},
				},
			},
			["BigWigs_Plugins_Super Emphasize"] = {
				["profiles"] = {
					["MerathilisUI"] = {
						["font"] = "Merathilis Roboto-Bold",
					},
				},
			},
			["BigWigs_Plugins_Sounds"] = {},
			["BigWigs_Plugins_Messages"] = {
				["profiles"] = {
					["MerathilisUI"] = {
						["outline"] = "OUTLINE",
						["fontSize"] = 20,
						["BWEmphasizeCountdownMessageAnchor_x"] = 664,
						["BWMessageAnchor_x"] = 608,
						["growUpwards"] = false,
						["BWEmphasizeCountdownMessageAnchor_y"] = 523,
						["font"] = "Merathilis Roboto-Bold",
						["BWEmphasizeMessageAnchor_y"] = 614,
						["BWMessageAnchor_y"] = 676,
						["BWEmphasizeMessageAnchor_x"] = 610,
					},
				},
			},
			["BigWigs_Plugins_Statistics"] = {},
			["BigWigs_Plugins_Respawn"] = {},
			["BigWigs_Plugins_Proximity"] = {
				["profiles"] = {
					["MerathilisUI"] = {
						["posx"] = 886.58,
						["font"] = "Merathilis Roboto-Bold",
						["lock"] = true,
						["height"] = 99.0000381469727,
						["posy"] = 88.22,
					},
				},
			},
			["BigWigs_Plugins_Raid Icons"] = {},
			["LibDualSpec-1.0"] = {},
		},
		["profiles"] = {
			["MerathilisUI"] = {
				["fakeDBMVersion"] = true,
			},
		},
	}
end