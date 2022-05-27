local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local options = MER.options.modules.args
local LSM = E.Libs.LSM

options.unitframes = {
	type = "group",
	name = F.cOption(L["UnitFrames"], 'orange'),
	disabled = function() return not E.private.unitframe.enable end,
	args = {
		name = {
			order = 1,
			type = "header",
			name = F.cOption(L["UnitFrames"], 'orange'),
		},
		general = {
			order = 2,
			type = "group",
			name = F.cOption(L["General"], 'orange'),
			guiInline = true,
			get = function(info) return E.db.mui.unitframes[ info[#info] ] end,
			set = function(info, value) E.db.mui.unitframes[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,
			args = {
				style = {
					order = 1,
					type = "toggle",
					name = L["UnitFrame Style"],
					desc = L["Adds my styling to the Unitframes if you use transparent health."],
				},
				raidIcons = {
					order = 2,
					type = "toggle",
					name = L["Raid Icon"],
					desc = L["Change the default raid icons."],
				},
				roleIcons = {
					order = 3,
					type = "toggle",
					name = L["Role Icon"],
					desc = L["Change the default role icons."],
				},
				highlight = {
					order = 4,
					type = "toggle",
					name = L["Highlight"],
					desc = L["Adds an own highlight to the Unitframes"],
				},
				auras = {
					order = 5,
					type = "toggle",
					name = L["Auras"],
					desc = L["Adds an shadow around the auras"],
				},
			},
		},
		gcd = {
			order = 3,
			type = "group",
			name = F.cOption(L["GCD Bar"], 'orange'),
			guiInline = true,
			--hidden = not E.Retail,
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
						local d = P.unitframes.gcd[ info[#info] ]
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
			name = F.cOption(L["Swing Bar"], 'orange'),
			guiInline = true,
			--hidden = not E.Retail,
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
						local d = P.unitframes.swing[ info[#info] ]
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
						local d = P.unitframes.swing[ info[#info] ]
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
						local d = P.unitframes.swing[ info[#info] ]
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
		healPrediction = {
			order = 5,
			type = "group",
			name = F.cOption(L["Heal Prediction"], 'orange'),
			desc = L["Changes the Heal Prediction texture to the default Blizzard ones."],
			guiInline = true,
			get = function(info)
				return E.db.mui.unitframes.healPrediction[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.unitframes.healPrediction[info[#info]] = value
				module:ProfileUpdate()
			end,
			args = {
				desc = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						feature = {
							order = 1,
							type = "description",
							name = L["Modify the texture of the absorb bar."] ..
								"\n" .. L["Add the Blizzard over absorb glow and overlay to ElvUI unit frames."],
							fontSize = "medium"
						}
					}
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					width = "full"
				},
				texture = {
					order = 3,
					type = "group",
					name = L["Texture"],
					disabled = function()
						return not E.db.mui.unitframes.healPrediction.enable
					end,
					inline = true,
					get = function(info)
						return E.db.mui.unitframes.healPrediction.texture[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.unitframes.healPrediction.texture[info[#info]] = value
						module:ProfileUpdate()
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Enable the replacing of ElvUI absorb bar textures."]
						},
						blizzardStyle = {
							order = 2,
							type = "toggle",
							name = L["Blizzard Style"],
							desc = L["Use the texture from Blizzard Raid Frames."],
							disabled = function()
								return not E.db.mui.unitframes.healPrediction.enable or not E.db.mui.unitframes.healPrediction.texture.enable
							end
						},
						custom = {
							order = 3,
							type = "select",
							name = L["Custom Texture"],
							desc = L["The selected texture will override the ElvUI default absorb bar texture."],
							disabled = function()
								return not E.db.mui.unitframes.healPrediction.enable or not E.db.mui.unitframes.healPrediction.texture.enable or
									E.db.mui.unitframes.healPrediction.texture.blizzardStyle
							end,
							dialogControl = "LSM30_Statusbar",
							values = LSM:HashTable("statusbar")
						},
					},
				},
				misc = {
					order = 4,
					type = "group",
					name = L["Misc"],
					inline = true,
					disabled = function()
						return not E.db.mui.unitframes.healPrediction.enable
					end,
					args = {
						blizzardOverAbsorbGlow = {
							order = 1,
							type = "toggle",
							name = L["Blizzard Over Absorb Glow"],
							desc = L["Add a glow in the end of health bars to indicate the over absorb."],
							width = 1.5
						},
						blizzardAbsorbOverlay = {
							order = 2,
							type = "toggle",
							name = L["Blizzard Absorb Overlay"],
							desc = L["Add an additional overlay to the absorb bar."],
							width = 1.5
						}
					}
				},
				elvui = {
					order = 5,
					type = "group",
					name = L["ElvUI"],
					inline = true,
					disabled = function()
						return not E.db.mui.unitframes.healPrediction.enable
					end,
					args = {
						feature = {
							order = 1,
							type = "description",
							name = format(
								"%s\n%s",
								format(
									L["The absorb style %s and %s is highly recommended with %s tweaks."],
									F.CreateColorString(L["Overflow"], E.db.general.valuecolor),
									F.CreateColorString(L["Auto Height"], E.db.general.valuecolor),
									L["MerathilisUI"]
								),
								L["Here are some buttons for helping you change the setting of all absorb bars by one-click."]
							)
						},
						setAllAbsorbStyleToOverflow = {
							order = 2,
							type = "execute",
							name = format(
								L["Set All Absorb Style to %s"],
								F.CreateColorString(L["Overflow"], E.db.general.valuecolor)
							),
							func = function(info)
								module:ChangeDB(
									function(db)
										db.absorbStyle = "OVERFLOW"
									end
								)
							end,
							width = 2
						},
						setAllAbsorbStyleToAutoHeight = {
							order = 3,
							type = "execute",
							name = format(
								L["Set All Absorb Style to %s"],
								F.CreateColorString(L["Auto Height"], E.db.general.valuecolor)
							),
							func = function(info)
								module:ChangeDB(function(db)
									db.height = -1
								end)
							end,
							width = 2
						},
						changeColor = {
							order = 4,
							type = "execute",
							name = format(L["%s style absorb color"], L["MerathilisUI"]),
							desc = L["Change the color of the absorb bar."],
							func = function(info)
								E.db.unitframe.colors.healPrediction.absorbs = {r = 0.06, g = 0.83, b = 1, a = 1}
								E.db.unitframe.colors.healPrediction.overabsorbs = {r = 0.06, g = 0.83, b = 1, a = 1}
							end,
							width = 2
						},
						changeMaxOverflow = {
							order = 5,
							type = "execute",
							name = format(
								L["Set %s to %s"],
								F.CreateColorString(L["Max Overflow"], E.db.general.valuecolor),
								F.CreateColorString("0", E.db.general.valuecolor)
							),
							func = function(info)
								E.db.unitframe.colors.healPrediction.maxOverflow = 0
							end,
							width = 2
						},
					},
				},
			},
		},
	},
}
