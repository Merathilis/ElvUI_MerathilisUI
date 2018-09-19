local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables
local ReloadUI = ReloadUI
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: BigWigs3DB, LibStub

function MER:LoadBigWigsProfileDPS()
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
						["posx"] = 90,
						["fontSize"] = 11,
						["fontOutline"] = "",
						["fontName"] = "Expressway",
						["lock"] = true,
						["posy"] = 245,
					},
				},
			},
			["BigWigs_Plugins_BossBlock"] = {},
			["BigWigs_Plugins_Colors"] = {
				["profiles"] = {
					["MerathilisUI"] = {
						["barColor"] = {
							["BigWigs_Plugins_Colors"] = {
								["default"] = {
									0, -- [1]
									0.474509803921569, -- [2]
									0.980392156862745, -- [3]
								},
							},
						},
					},
				},
			},
			["BigWigs_Plugins_Bars"] = {
				["profiles"] = {
					["MerathilisUI"] = {
						["BigWigsEmphasizeAnchor_y"] = 195,
						["BigWigsEmphasizeAnchor_x"] = 296,
						["BigWigsAnchor_y"] = 26,
						["BigWigsAnchor_x"] = 376,
						["BigWigsAnchor_width"] = 200,
						["BigWigsAnchor_height"] = 15,
						["BigWigsEmphasizeAnchor_height"] = 25,
						["BigWigsEmphasizeAnchor_width"] = 200,
						["fontName"] = "Expressway",
						["fontSizeEmph"] = 12,
						["fontSize"] = 11,
						["outline"] = "OUTLINE",
						["emphasizeScale"] = 1.1,
						["barStyle"] = "MerathilisUI",
						["emphasizeGrowup"] = true,
						["texture"] = "MerathilisFlat",
					},
				},
			},
			["BigWigs_Plugins_Super Emphasize"] = {
				["profiles"] = {
					["MerathilisUI"] = {
						["monochrome"] = false,
						["fontName"] = "Expressway",
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
						["fontName"] = "Expressway",
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
						["posx"] = 886,
						["fontName"] = "Expressway",
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

function MER:LoadBigWigsProfileHeal()
	--[[----------------------------------
	--	BigWigs - Settings
	--]]----------------------------------
	BigWigs3DB = {
		["namespaces"] = {
			["BigWigs_Plugins_Victory"] = {},
			["BigWigs_Plugins_Colors"] = {},
			["BigWigs_Plugins_Alt Power"] = {
				["profiles"] = {
					["MerathilisUI - Heal"] = {
						["posx"] = 90,
						["fontSize"] = 11,
						["fontName"] = "Expressway",
						["font"] = "Expressway",
						["lock"] = true,
						["posy"] = 245,
					},
				},
			},
			["BigWigs_Plugins_BossBlock"] = {},
			["BigWigs_Plugins_Colors"] = {
				["profiles"] = {
					["MerathilisUI - Heal"] = {
						["barColor"] = {
							["BigWigs_Plugins_Colors"] = {
								["default"] = {
									0, -- [1]
									0.474509803921569, -- [2]
									0.980392156862745, -- [3]
								},
							},
						},
					},
				},
			},
			["BigWigs_Plugins_Bars"] = {
				["profiles"] = {
					["MerathilisUI - Heal"] = {
						["outline"] = "OUTLINE",
						["BigWigsAnchor_width"] = 200.000045776367,
						["BigWigsAnchor_x"] = 941.244988069448,
						["BigWigsEmphasizeAnchor_height"] = 22.0000019073486,
						["fontName"] = "Expressway",
						["BigWigsAnchor_height"] = 16.0000038146973,
						["fontSize"] = 11,
						["BigWigsAnchor_y"] = 189.710898690955,
						["emphasizeGrowup"] = true,
						["texture"] = "MerathilisFeint",
						["fontSizeEmph"] = 12,
						["BigWigsEmphasizeAnchor_x"] = 298.844473382169,
						["BigWigsEmphasizeAnchor_y"] = 193.15551682992,
						["BigWigsEmphasizeAnchor_width"] = 199.999984741211,
					},
				},
			},
			["BigWigs_Plugins_Super Emphasize"] = {
				["profiles"] = {
					["MerathilisUI - Heal"] = {
						["monochrome"] = false,
						["fontName"] = "Expressway",
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
						["fontName"] = "Expressway",
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
						["posx"] = 931.511307278197,
						["fontName"] = "Expressway",
						["posy"] = 85.3333353996277,
						["lock"] = false,
						["height"] = 99.0000381469727,
					},
				},
			},
			["BigWigs_Plugins_Raid Icons"] = {},
			["LibDualSpec-1.0"] = {},
		},
		["profiles"] = {
			["MerathilisUI - Heal"] = {
				["fakeDBMVersion"] = true,
			},
		},
	}
end

E.PopupDialogs["MUI_INSTALL_BW_LAYOUT"] = {
	text = L["MUI_INSTALL_SETTINGS_LAYOUT_BW"],
	OnAccept = function() MER:LoadBigWigsProfileDPS(); ReloadUI() end,
	OnCancel = function() MER:LoadBigWigsProfileHeal(); ReloadUI() end,
	button1 = 'BigWigs DPS Layout',
	button2 = 'BigWigs Heal Layout'
}
