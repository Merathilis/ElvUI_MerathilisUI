local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local HP = MER:GetModule('MER_HealPrediction')
local options = MER.options.modules.args
local LSM = E.Libs.LSM

local format = string.format

local OfflineIndicatorImages = {
	MATERIAL = [[|TInterface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\materialDC:14|t]],
	ALERT = [[|TInterface\DialogFrame\UI-Dialog-Icon-AlertNew:14|t]],
	ARTHAS = [[|TInterface\LFGFRAME\UI-LFR-PORTRAIT:14|t]],
	SKULL = [[|TInterface\LootFrame\LootPanel-Icon:14|t]],
	PASS = [[|TInterface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent:14|t]],
	NOTREADY = [[|TInterface\RAIDFRAME\ReadyCheck-NotReady:14|t]],
	CUSTOM = L["CUSTOM"],
}

options.unitframes = {
	type = "group",
	name = E.NewSign..L["UnitFrames"],
	childGroups = "tab",
	get = function(info) return E.db.mui.unitframes[ info[#info] ] end,
	set = function(info, value) E.db.mui.unitframes[ info[#info] ] = value; end,
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
			name = L["General"],
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
				spacer = {
					order = 10,
					type = "description",
					name = ""
				},
				power = {
					order = 11,
					type = "group",
					name = F.cOption(L["Power"], 'orange'),
					guiInline = true,
					get = function(info) return E.db.mui.unitframes.power[info[#info]] end,
					set = function(info, value)
						E.db.mui.unitframes.power[info[#info]] = value;
						E:StaticPopup_Show("CONFIG_RL");
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Enable the animated Power Bar"],
						},
						type = {
							order = 2,
							type = "select",
							name = L["Select Model"],
							style = 'radio',
							disabled = function() return not E.db.mui.unitframes.power.enable end,
							values = {
								["DEFAULT"] = L["Default"],
								["CUSTOM"] = CUSTOM,
							},
							sorting = {
								"DEFAULT",
								"CUSTOM",
							},
						},
						customModel = {
							order = 3,
							type = "input",
							name = L["Type the Model ID"],
							width = "full",
							disabled = function() return E.db.mui.unitframes.power.type == "DEFAULT" or
									not E.db.mui.unitframes.power.enable end,
							validate = function(_, value)
								if tonumber(value) ~= nil then
									return true
								else
									return E:StaticPopup_Show("VERSION_MISMATCH") and false
								end
							end,
							get = function()
								return tostring(E.db.mui.unitframes.power.model)
							end,
							set = function(_, value)
								E.db.mui.unitframes.power.model = tonumber(value)
							end,
							E:StaticPopup_Show("CONFIG_RL"),
						},
						texture = {
							order = 4,
							type = "select",
							name = L['Power'],
							desc = L['Power statusbar texture.'],
							dialogControl = 'LSM30_Statusbar',
							values = LSM:HashTable("statusbar"),
							-- function() return not E.db.mui.unitframes.power.enable end,
							get = function(info) return E.db.mui.unitframes.power[info[#info]] end,
							set = function(info, value)
								E.db.mui.unitframes.power[info[#info]] = value;
								module:ChangePowerBarTexture()
							end,
						},
					},
				},
				castbar = {
					order = 12,
					type = "group",
					name = F.cOption(L["Castbar"], 'orange'),
					guiInline = true,
					get = function(info) return E.db.mui.unitframes.castbar[info[#info]] end,
					set = function(info, value)
						E.db.mui.unitframes.castbar[info[#info]] = value;
						E:StaticPopup_Show("CONFIG_RL");
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
						},
						texture = {
							order = 2,
							type = "select",
							name = L["Texture"],
							dialogControl = "LSM30_Statusbar",
							values = LSM:HashTable("statusbar"),
							disabled = function()
								return not E.db.mui.unitframes.castbar.enable
							end,
						},
						spacer = {
							order = 3,
							type = "description",
							name = " ",
						},
						spark = {
							order = 10,
							type = "group",
							name = F.cOption(L["Spark"], 'orange'),
							guiInline = true,
							get = function(info) return E.db.mui.unitframes.castbar.spark[info[#info]] end,
							set = function(info, value)
								E.db.mui.unitframes.castbar.spark[info[#info]] = value;
								E:StaticPopup_Show("CONFIG_RL");
							end,
							disabled = function()
								return not E.db.mui.unitframes.castbar.enable
							end,
							args = {
								enable = {
									order = 1,
									type = "toggle",
									name = L["Enable"],
								},
								texture = {
									order = 2,
									type = "select",
									name = L["Spark Texture"],
									dialogControl = "LSM30_Statusbar",
									values = LSM:HashTable("statusbar")
								},
								color = {
									order = 3,
									type = "color",
									name = _G.COLOR,
									hasAlpha = false,
									disabled = function() return not E.db.mui.unitframes.castbar.enable or
											not E.db.mui.unitframes.castbar.spark.enable end,
									get = function(info)
										local t = E.db.mui.unitframes.castbar.spark[info[#info]]
										local d = P.unitframes.castbar.spark[info[#info]]
										return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mui.unitframes.castbar.spark[info[#info]]
										t.r, t.g, t.b, t.a = r, g, b, a
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								width = {
									order = 4,
									type = "range",
									name = L["Size"],
									min = 2, max = 10, step = 1,
									disabled = function()
										return not E.db.mui.unitframes.castbar.enable or
											not E.db.mui.unitframes.castbar.spark.enable
									end,
								},
							},
						},
					},
				},
				gcd = {
					order = 13,
					type = "group",
					name = F.cOption(L["GCD Bar"], 'orange'),
					guiInline = true,
					hidden = not E.Retail,
					get = function(info) return E.db.mui.unitframes.gcd[info[#info]] end,
					set = function(info, value)
						E.db.mui.unitframes.gcd[info[#info]] = value;
						E:StaticPopup_Show("CONFIG_RL");
					end,
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
							name = _G.COLOR,
							hasAlpha = false,
							disabled = function() return not E.db.mui.unitframes.gcd.enable end,
							get = function(info)
								local t = E.db.mui.unitframes.gcd[info[#info]]
								local d = P.unitframes.gcd[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mui.unitframes.gcd[info[#info]]
								t.r, t.g, t.b, t.a = r, g, b, a
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				swing = {
					order = 14,
					type = "group",
					name = F.cOption(L["Swing Bar"], 'orange'),
					guiInline = true,
					get = function(info) return E.db.mui.unitframes.swing[info[#info]] end,
					set = function(info, value)
						E.db.mui.unitframes.swing[info[#info]] = value;
						E:StaticPopup_Show("CONFIG_RL");
					end,
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
								local t = E.db.mui.unitframes.swing[info[#info]]
								local d = P.unitframes.swing[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mui.unitframes.swing[info[#info]]
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
								local t = E.db.mui.unitframes.swing[info[#info]]
								local d = P.unitframes.swing[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mui.unitframes.swing[info[#info]]
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
								local t = E.db.mui.unitframes.swing[info[#info]]
								local d = P.unitframes.swing[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.mui.unitframes.swing[info[#info]]
								t.r, t.g, t.b, t.a = r, g, b, a
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				healPrediction = {
					order = 15,
					type = "group",
					name = F.cOption(L["Heal Prediction"], 'orange'),
					desc = L["Changes the Heal Prediction texture to the default Blizzard ones."],
					guiInline = true,
					get = function(info)
						return E.db.mui.unitframes.healPrediction[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.unitframes.healPrediction[info[#info]] = value
						HP:ProfileUpdate()
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
								HP:ProfileUpdate()
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
										return not E.db.mui.unitframes.healPrediction.enable or
											not E.db.mui.unitframes.healPrediction.texture.enable
									end
								},
								custom = {
									order = 3,
									type = "select",
									name = L["Custom Texture"],
									desc = L["The selected texture will override the ElvUI default absorb bar texture."],
									disabled = function()
										return not E.db.mui.unitframes.healPrediction.enable or
											not E.db.mui.unitframes.healPrediction.texture.enable or
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
										E.db.unitframe.colors.healPrediction.absorbs = { r = 0.06, g = 0.83, b = 1, a = 1 }
										E.db.unitframe.colors.healPrediction.overabsorbs = { r = 0.06, g = 0.83, b = 1,
											a = 1 }
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
		},
		--[[individualUnits = {
			order = 3,
			type = "group",
			name = L["Individual Units"],
			args = {
			},
		},]]
		groupUnits = {
			order = 4,
			type = "group",
			name = E.NewSign..L["Group Units"],
			args = {
				party = {
					order = 1,
					type = "group",
					name = L["Party"],
					args = {
						offlineIndicator = {
							order = 1,
							type = "group",
							name = F.cOption(L["Offline Indicator"], 'orange'),
							guiInline = true,
							get = function(info)
								return E.db.mui.unitframes.offlineIndicator[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.unitframes.offlineIndicator[info[#info]] = value
								E:StaticPopup_Show("PRIVATE_RL")
							end,
							args = {
								enable = {
									order = 1,
									type = "toggle",
									name = L["Enable"]
								},
								anchorPoint = {
									order = 2,
									type = "select",
									name = L["Anchor Point"],
									disabled = function() return not E.db.mui.unitframes.offlineIndicator.enable end,
									values = {
										TOPLEFT = 'TOPLEFT',
										LEFT = 'LEFT',
										BOTTOMLEFT = 'BOTTOMLEFT',
										RIGHT = 'RIGHT',
										TOPRIGHT = 'TOPRIGHT',
										BOTTOMRIGHT = 'BOTTOMRIGHT',
										TOP = 'TOP',
										BOTTOM = 'BOTTOM',
										CENTER = 'CENTER',
									},
								},
								xOffset = {
									order = 3,
									type = "range",
									name = L["X-Offset"],
									disabled = function() return not E.db.mui.unitframes.offlineIndicator.enable end,
									min = -300, max = 300, step = 1
								},
								yOffset = {
									order = 4,
									type = "range",
									name = L["Y-Offset"],
									disabled = function() return not E.db.mui.unitframes.offlineIndicator.enable end,
									min = -300, max = 300, step = 1
								},
								size = {
									order = 5,
									type = "range",
									name = L["Size"],
									softMin = 14, softMax = 64, min = 12, max = 128, step = 1,
									disabled = function() return not E.db.mui.unitframes.offlineIndicator.enable end,
								},
								texture = {
									order = 6,
									type = "select",
									name = L["Texture"],
									disabled = function() return not E.db.mui.unitframes.offlineIndicator.enable end,
									values = OfflineIndicatorImages,
								},
								spacer = {
									order = 7,
									type = "description",
									name = ""
								},
								custom = {
									order = 8,
									type = "input",
									name = L["Custom Texture"],
									width = "full",
									hidden = function() return E.db.mui.unitframes.offlineIndicator.texture ~= 'CUSTOM' end,
									disabled = function() return not E.db.mui.unitframes.offlineIndicator.enable end,
								}
							},
						},
					},
				},
			},
		},
	},
}

local SampleStrings = {}
do
	local icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.sunTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.sunHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.sunDPS, ":16:16")
	SampleStrings.sunui = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.lynTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.lynHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.lynDPS, ":16:16")
	SampleStrings.lynui = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.svuiTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.svuiHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.svuiDPS, ":16:16")
	SampleStrings.svui = icons

	icons = ""
	icons = icons .. E:TextureString(E.Media.Textures.Tank, ":16:16") .. " "
	icons = icons .. E:TextureString(E.Media.Textures.Healer, ":16:16") .. " "
	icons = icons .. E:TextureString(E.Media.Textures.DPS, ":16:16")
	SampleStrings.elvui = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.customTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.customHeal, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.customDPS, ":16:16")
	SampleStrings.custom = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.glowTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.glowHeal, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.glowDPS, ":16:16")
	SampleStrings.glow = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.gravedTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.gravedHeal, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.gravedDPS, ":16:16")
	SampleStrings.graved = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.mainTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.mainHeal, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.mainDPS, ":16:16")
	SampleStrings.main = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.whiteTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.whiteHeal, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.whiteDPS, ":16:16")
	SampleStrings.white = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.materialTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.materialHeal, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.materialDPS, ":16:16")
	SampleStrings.material = icons
end

options.unitframes.args.general.args.roleIcons = {
	order = 6,
	type = "group",
	name = F.cOption(L["Role Icons"], "orange"),
	guiInline = true,
	get = function(info)
		return E.db.mui.unitframes.roleIcons[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.unitframes.roleIcons[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			width = "full"
		},
		roleIconStyle = {
			order = 2,
			type = "select",
			name = L["Style"],
			values = {
				DEFAULT = SampleStrings.elvui,
				SUNUI = SampleStrings.sunui,
				LYNUI = SampleStrings.lynui,
				SVUI = SampleStrings.svui,
				CUSTOM = SampleStrings.custom,
				GLOW = SampleStrings.glow,
				GRAVED = SampleStrings.graved,
				MAIN = SampleStrings.main,
				WHITE = SampleStrings.white,
				MATERIAL = SampleStrings.material,
			},
		},
	},
}
