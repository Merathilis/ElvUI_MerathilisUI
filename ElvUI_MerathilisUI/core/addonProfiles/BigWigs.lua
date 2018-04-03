local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables
local ReloadUI = ReloadUI
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
						["posx"] = 90,
						["fontSize"] = 11,
						["fontOutline"] = "",
						["font"] = "Expressway",
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
						["BigWigsEmphasizeAnchor_y"] = 196,
						["BigWigsEmphasizeAnchor_x"] = 296,
						["fontSize"] = 11,
						["BigWigsAnchor_width"] = 208,
						["BigWigsAnchor_y"] = 29,
						["barStyle"] = "MerathilisUI",
						["emphasizeGrowup"] = true,
						["BigWigsAnchor_x"] = 388,
						["outline"] = "OUTLINE",
						["BigWigsEmphasizeAnchor_width"] = 187,
						["font"] = "Expressway",
						["emphasizeScale"] = 1.1,
						["texture"] = "MerathilisFlat",
						["BigWigsEmphasizeAnchor_height"] = 25,
						["BigWigsEmphasizeAnchor_width"] = 200,
						["fontSizeEmph"] = 12,
					},
				},
			},
			["BigWigs_Plugins_Super Emphasize"] = {
				["profiles"] = {
					["MerathilisUI"] = {
						["font"] = "Expressway",
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
						["font"] = "Expressway",
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
						["font"] = "Expressway",
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

E.PopupDialogs["MUI_INSTALL_BW_LAYOUT"] = {
	text = L["MUI_INSTALL_SETTINGS_LAYOUT_BW"],
	OnAccept = function() MER:LoadBigWigsProfile(); ReloadUI() end,
	button1 = 'BigWigs Layout',
}