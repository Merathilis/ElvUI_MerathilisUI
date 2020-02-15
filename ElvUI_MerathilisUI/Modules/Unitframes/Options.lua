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
				name = MER:cOption(L["General"]),
				guiInline = true,
				args = {
					healPrediction = {
						order = 1,
						type = "toggle",
						name = L["Heal Prediction"],
						desc = L["Changes the Heal Prediction texture to the default Blizzard ones."],
						get = function(info) return E.db.mui.unitframes[ info[#info] ] end,
						set = function(info, value) E.db.mui.unitframes[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,
					},
					auras = {
						order = 2,
						type = "toggle",
						name = L["Auras"],
						desc = L["Adds a shadow to the debuffs that the debuff color is more visible."],
						get = function(info) return E.db.mui.unitframes[ info[#info] ] end,
						set = function(info, value) E.db.mui.unitframes[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,
					},
					style = {
						order = 3,
						type = "toggle",
						name = L["UnitFrame Style"],
						desc = L["Adds my styling to the Unitframes if you use transparent health."],
						get = function(info) return E.db.mui.unitframes.style end,
						set = function(info, value) E.db.mui.unitframes.style = value; E:StaticPopup_Show("CONFIG_RL"); end,
					},
					roleIcons = {
						order = 4,
						type = "toggle",
						name = E.NewSign..L["Role Icon"],
						desc = L["Change the default role icons."],
						get = function(info) return E.db.mui.unitframes.roleIcons end,
						set = function(info, value) E.db.mui.unitframes.roleIcons = value; E:StaticPopup_Show("CONFIG_RL"); end,
					},
				},
			},
			gcd = {
				order = 3,
				type = "group",
				name = MER:cOption(L["GCD Bar"]),
				guiInline = true,
				get = function(info) return E.db.mui.unitframes.gcd[ info[#info] ] end,
				set = function(info, value) E.db.mui.unitframes.gcd[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Creates a Global Cooldown Bar"],
					},
					color = {
						order = 2,
						type = "color",
						name = L["COLOR"],
						hasAlpha = false,
						disabled = function() return not E.db.mui.unitframes.gcd.enable end,
						get = function(info)
							local t = E.db.mui.unitframes.gcd[ info[#info] ]
							local d = P.mui.unitframes.gcd[ info[#info] ]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							local t = E.db.mui.unitframes.gcd[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							E:StaticPopup_Show("CONFIG_RL")
						end,
					},
				},
			},
			swing = {
				order = 4,
				type = "group",
				name = MER:cOption(L["Swing Bar"]),
				guiInline = true,
				get = function(info) return E.db.mui.unitframes.swing[ info[#info] ] end,
				set = function(info, value) E.db.mui.unitframes.swing[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Creates a weapon Swing Bar"],
					},
					mcolor = {
						order = 2,
						type = "color",
						name = L["Main-Hand Color"],
						hasAlpha = false,
						disabled = function() return not E.db.mui.unitframes.swing.enable end,
						get = function(info)
							local t = E.db.mui.unitframes.swing[ info[#info] ]
							local d = P.mui.unitframes.swing[ info[#info] ]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							local t = E.db.mui.unitframes.swing[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							E:StaticPopup_Show("CONFIG_RL")
						end,
					},
					ocolor = {
						order = 3,
						type = "color",
						name = L["Off-Hand Color"],
						hasAlpha = false,
						disabled = function() return not E.db.mui.unitframes.swing.enable end,
						get = function(info)
							local t = E.db.mui.unitframes.swing[ info[#info] ]
							local d = P.mui.unitframes.swing[ info[#info] ]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							local t = E.db.mui.unitframes.swing[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							E:StaticPopup_Show("CONFIG_RL")
						end,
					},
					tcolor = {
						order = 3,
						type = "color",
						name = L["Two-Hand Color"],
						hasAlpha = false,
						disabled = function() return not E.db.mui.unitframes.swing.enable end,
						get = function(info)
							local t = E.db.mui.unitframes.swing[ info[#info] ]
							local d = P.mui.unitframes.swing[ info[#info] ]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							local t = E.db.mui.unitframes.swing[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							E:StaticPopup_Show("CONFIG_RL")
						end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, UnitFramesTable)
