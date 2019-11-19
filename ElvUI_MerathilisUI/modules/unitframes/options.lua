local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local tinsert = table.insert
-- WoW API / Variables
-- GLOBALS:

local function UnitFramesTable()
	E.Options.args.mui.args.modules.args.unitframes = {
		type = "group",
		name = E.NewSign..L["UnitFrames"],
		childGroups = "tab",
		disabled = function() return not E.private.unitframe.enable end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["UnitFrames"]),
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				args = {
					header = {
						order = 1,
						type = "header",
						name = MER:cOption(L["General"]),
					},
					spacer = {
						order = 2,
						name = "",
						type = "description",
					},
					healPrediction = {
						order = 3,
						type = "toggle",
						name = L["Heal Prediction"],
						desc = L["Changes the Heal Prediction texture to the default Blizzard ones."],
						get = function(info) return E.db.mui.unitframes[ info[#info] ] end,
						set = function(info, value) E.db.mui.unitframes[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,
					},
					auras = {
						order = 4,
						type = "toggle",
						name = E.NewSign..L["Auras"],
						desc = L["Adds a shadow to the debuffs that the debuff color is more visible."],
						get = function(info) return E.db.mui.unitframes[ info[#info] ] end,
						set = function(info, value) E.db.mui.unitframes[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,
					},
				},
			},
			player = {
				order = 3,
				type = "group",
				name = L["Player"],
				args = {
					header = {
						order = 0,
						type = "header",
						name = MER:cOption(L["Player"]),
					},
					portrait = {
						order = 1,
						type = "execute",
						name = L["Player Portrait"],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "unitframe", "player", "portrait") end,
					},
					spacer = {
						order = 2,
						type = "description",
						name = "",
					},
					gcd = {
						order = 3,
						type = "toggle",
						name = L["GCD Bar"],
						get = function(info) return E.db.mui.unitframes.units.player.gcd.enable end,
						set = function(info, value) E.db.mui.unitframes.units.player.gcd.enable = value; E:StaticPopup_Show("CONFIG_RL"); end,
					},
				},
			},
			target = {
				order = 4,
				type = "group",
				name = L["Target"],
				args = {
					header = {
						order = 0,
						type = "header",
						name = MER:cOption(L["Target"]),
					},
					portrait = {
						order = 1,
						type = "execute",
						name = L["Target Portrait"],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "unitframe", "target", "portrait") end,
					},
				},
			},
			infoPanel = {
				type = "group",
				order = 5,
				name = L["InfoPanel"],
				get = function(info) return E.db.mui.unitframes.infoPanel[ info[#info] ] end,
				set = function(info, value) E.db.mui.unitframes.infoPanel[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,
				args = {
					header = {
						order = 0,
						type = "header",
						name = MER:cOption(L["InfoPanel"]),
					},
					style = {
						order = 1,
						type = "toggle",
						name = L["InfoPanel Style"],
					},
				},
			},
		},
	}
end
tinsert(MER.Config, UnitFramesTable)
