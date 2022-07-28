local MER, F, E, L, V, P, G = unpack(select(2, ...))

local _G = _G
local twipe = table.wipe

local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn

local BigWigs3DB = _G.BigWigs3DB


function MER:LoadBigWigsProfile()
	--[[----------------------------------
	--	BigWigs - Settings
	--]]----------------------------------
	local main = MER.Title
	local heal = MER.Title.."-".." Heal"

	-- Required to add profiles to BigWigs3DB
	if not IsAddOnLoaded("BigWigs_Core") then LoadAddOn("BigWigs_Core") end

	-- Required to add profiles to Plugins DB
	if not IsAddOnLoaded("BigWigs_Plugins") then LoadAddOn("BigWigs_Plugins") end

	BigWigs3DB["profiles"] = BigWigs3DB["profiles"] or {}

	BigWigs3DB["profiles"][main] = BigWigs3DB["profiles"][main] or {}
	BigWigs3DB["profiles"][main]["showZoneMessages"] = true
	BigWigs3DB["profiles"][main]["fakeDBMVersion"] = true
	BigWigs3DB["profiles"][main]["flash"] = true

	BigWigs3DB["profiles"][heal] = BigWigs3DB["profiles"][heal] or {}
	BigWigs3DB["profiles"][heal]["showZoneMessages"] = true
	BigWigs3DB["profiles"][heal]["fakeDBMVersion"] = true
	BigWigs3DB["profiles"][heal]["flash"] = true

	BigWigs3DB["namespaces"]["BigWigs_Plugins_Victory"]["profiles"] = BigWigs3DB["namespaces"]["BigWigs_Plugins_Victory"]["profiles"] or {}
	BigWigs3DB["namespaces"]["BigWigs_Plugins_Victory"]["profiles"][main] = {
		["bigwigsMsg"] = true,
		["blizzMsg"] = false,
	}
	BigWigs3DB["namespaces"]["BigWigs_Plugins_Victory"]["profiles"][heal] = {
		["bigwigsMsg"] = true,
		["blizzMsg"] = false,
	}
	BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"] = BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"] or {}
	BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][main] = {
		["outline"] = "OUTLINE",
		["fontName"] = "Expressway",
		["position"] = {
			"CENTER", -- [1]
			"CENTER", -- [2]
			7.999993801116943, -- [3]
			122.0000915527344, -- [4]
		},
	}
	BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][heal] = {
		["outline"] = "OUTLINE",
		["fontName"] = "Expressway",
		["position"] = {
			"CENTER", -- [1]
			"CENTER", -- [2]
			7.999993801116943, -- [3]
			122.0000915527344, -- [4]
		},
	}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_AltPower"]["profiles"] = BigWigs3DB["namespaces"]["BigWigs_Plugins_AltPower"]["profiles"] or {}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_AltPower"]["profiles"][main] = {
			["posx"] = 600,
			["fontSize"] = 11,
			["fontOutline"] = "",
			["fontName"] = "Expressway",
			["lock"] = true,
			["posy"] = 132,
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_AltPower"]["profiles"][heal] = {
			["posx"] = 90,
			["fontSize"] = 11,
			["fontName"] = "Expressway",
			["font"] = "Expressway",
			["lock"] = true,
			["posy"] = 245,
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"] = BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"] or {}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"][main] = {
			["exitCombatOther"] = 3,
			["disabled"] = false,
			["modeOther"] = 2,
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"][heal] = {
			["exitCombatOther"] = 3,
			["disabled"] = false,
			["modeOther"] = 2,
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"] = BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"] or {}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][main] = {
			["barBackground"] = {
				["BigWigs_Plugins_Colors"] = {
					["default"] = {
						0, -- [1]
						0.474509803921569, -- [2]
						0.980392156862745, -- [3]
					},
				},
			},
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][heal] = {
			["barBackground"] = {
				["BigWigs_Plugins_Colors"] = {
					["default"] = {
						0, -- [1]
						0.474509803921569, -- [2]
						0.980392156862745, -- [3]
					},
				},
			},
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Raid Icons"]["profiles"] = BigWigs3DB["namespaces"]["BigWigs_Plugins_Raid Icons"]["profiles"] or {}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Raid Icons"]["profiles"][main] = {
			["disabled"] = true,
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Raid Icons"]["profiles"][heal] = {
			["disabled"] = true,
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"] = BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"] or {}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"][main] = {
			["posx"] = 962.8442941480171,
			["posy"] = 71.71141124165615,
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"][heal] = {
			["posx"] = 962.8442941480171,
			["posy"] = 71.71141124165615,
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"] = BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"] or {}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][main] = {
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
			["texture"] = "MER_NormTex",
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][heal] = {
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
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"] = BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"] or {}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][main] = {
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
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][heal] = {
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
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"] = BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"] or {}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][main] = {
			["posx"] = 346.27,
			["fontName"] = "Expressway",
			["lock"] = true,
			["height"] = 99.0000381469727,
			["posy"] = 81.82,
		}
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][heal] = {
			["posx"] = 931.511307278197,
			["fontName"] = "Expressway",
			["posy"] = 85.3333353996277,
			["lock"] = false,
			["height"] = 99.0000381469727,
		}

		-- Set the profile
		_G.BigWigs.db:SetProfile(main)
end
