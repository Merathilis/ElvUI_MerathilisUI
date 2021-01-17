local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables
local LoadAddOn = LoadAddOn
local ReloadUI = ReloadUI
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: BigWigs3DB, LibStub

function MER:LoadBigWigsProfile()
	--[[----------------------------------
	--	BigWigs - Settings
	--]]----------------------------------
	local main = MER.Title
	local heal = MER.Title.."-".." Heal"

	LoadAddOn("BigWigs_Options")
	LoadAddOn("BigWigs")

	if BigWigs3DB["profiles"] == nil then BigWigs3DB["profiles"] = {} end

	if BigWigs3DB["profiles"][main] == nil then
		BigWigs3DB = {
			["namespaces"] = {
				["BigWigs_Plugins_Alt Power"] = {
					["profiles"] = {
						[main] = {
							["posx"] = 600,
							["fontSize"] = 11,
							["fontOutline"] = "",
							["fontName"] = "Expressway",
							["lock"] = true,
							["posy"] = 132,
						},
						[heal] = {
							["posx"] = 90,
							["fontSize"] = 11,
							["fontName"] = "Expressway",
							["font"] = "Expressway",
							["lock"] = true,
							["posy"] = 245,
						},
					},
				},
				["BigWigs_Plugins_Colors"] = {
					["profiles"] = {
						[main] = {
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
						[heal] = {
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
						[main] = {
							["BigWigsEmphasizeAnchor_y"] = 256,
							["BigWigsEmphasizeAnchor_x"] = 457,
							["BigWigsAnchor_y"] = 24,
							["BigWigsAnchor_x"] = 835,
							["BigWigsAnchor_width"] = 212,
							["BigWigsAnchor_height"] = 18,
							["BigWigsEmphasizeAnchor_height"] = 28,
							["BigWigsEmphasizeAnchor_width"] = 170,
							["fontName"] = "Expressway",
							["fontSizeEmph"] = 12,
							["fontSize"] = 11,
							["outline"] = "OUTLINE",
							["emphasizeScale"] = 1.1,
							["barStyle"] = "MerathilisUI",
							["emphasizeGrowup"] = true,
							["texture"] = "RenAscensionL",
						},
						[heal] = {
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
						[main] = {
							["monochrome"] = false,
							["fontName"] = "Expressway",
						},
						[heal] = {
							["monochrome"] = false,
							["fontName"] = "Expressway",
						},
					},
				},
				["BigWigs_Plugins_Countdown"] = {
					["profiles"] = {
						[main] = {
							["fontName"] = "Expressway",
							["position"] = {
								"CENTER", -- [1]
								"CENTER", -- [2]
								7.999993801116943, -- [3]
								122.0000915527344, -- [4]
							},
						},
					},
				},
				["BigWigs_Plugins_Messages"] = {
					["profiles"] = {
						[main] = {
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
							["emphFontName"] = "Expressway",
							["fontName"] = "Expressway",
						},
						[heal] = {
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
				["BigWigs_Plugins_Proximity"] = {
					["profiles"] = {
						[main] = {
							["posx"] = 346.27,
							["fontName"] = "Expressway",
							["lock"] = true,
							["height"] = 99.0000381469727,
							["posy"] = 81.82,
						},
						[heal] = {
							["posx"] = 931.511307278197,
							["fontName"] = "Expressway",
							["posy"] = 85.3333353996277,
							["lock"] = false,
							["height"] = 99.0000381469727,
						},
					},
				},
			},
			["profiles"] = {
				[main] = {
					["showZoneMessages"] = false,
					["fakeDBMVersion"] = true,
					["flash"] = true,
				},
				[heal] = {
					["showZoneMessages"] = false,
					["fakeDBMVersion"] = true,
					["flash"] = true,
				},
			},
		}
	end
end
