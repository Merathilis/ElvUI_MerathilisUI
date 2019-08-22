local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = MER:GetModule("muiUnits")
local MCA = MER:GetModule("mUICastbar")
local UF = E:GetModule("UnitFrames")
local isEnabled = E.private["unitframe"].enable and true or false

-- Cache global variables
-- Lua functions
local tinsert = table.insert
-- WoW API / Variables
-- GLOBALS: LibStub

local function UnitFramesTable()
	E.Options.args.mui.args.modules.args.unitframes = {
		order = 20,
		type = "group",
		name = L["UnitFrames"],
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
					spacing = {
						order = 1,
						type = 'range',
						name = L["Aura Spacing"],
						desc = L["Sets space between individual aura icons."],
						get = function(info) return E.db.mui.unitframes.AuraIconSpacing.spacing end,
						set = function(info, value) E.db.mui.unitframes.AuraIconSpacing.spacing = value; MUF:UpdateAuraSettings(); end,
						disabled = function() return not isEnabled end,
						min = 0, max = 10, step = 1,
					},
					units = {
						order = 2,
						type = "multiselect",
						name = L["Set Aura Spacing On Following Units"],
						get = function(info, key) return E.db.mui.unitframes.AuraIconSpacing.units[key] end,
						set = function(info, key, value) E.db.mui.unitframes.AuraIconSpacing.units[key] = value; MUF:UpdateAuraSettings(); end,
						disabled = function() return not isEnabled end,
						values = {
							['player'] = L["Player"],
							['target'] = L["Target"],
							['targettarget'] = L["TargetTarget"],
							['targettargettarget'] = L["TargetTargetTarget"],
							['focus'] = L["Focus"],
							['focustarget'] = L["FocusTarget"],
							['pet'] = L["Pet"],
							['pettarget'] = L["PetTarget"],
							['arena'] = L["Arena"],
							['boss'] = L["Boss"],
							['party'] = L["Party"],
							['raid'] = L["Raid"],
							['raid40'] = L["Raid40"],
							['raidpet'] = L["RaidPet"],
							["tank"] = L["Tank"],
							["assist"] = L["Assist"],
						},
					},
					spacer = {
						order = 3,
						name = "",
						type = "description",
					},
					tags = {
						order = 4,
						type = "group",
						name = E.NewSign..MER.Title..L["Tags"],
						guiInline = true,
						args = {
							health = {
								order = 1,
								type = "group",
								name = L["Health"],
								args = {
									health1 = {
										order = 1,
										type = "description",
										fontSize = "medium",
										name = "[health:current-mUI] - "..L["Example:"].." Displays current HP (2.04B, 2.04M, 204k, 204)",
									},
								},
							},
							power = {
								order = 2,
								type = "group",
								name = L["Power"],
								args = {
									power1 = {
										order = 1,
										type = "description",
										fontSize = "medium",
										name = "[power:current-mUI] - "..L["Example:"].." Displays current power and 0 when no power instead of hiding when at 0, Also formats it like HP tag",
									},
								},
							},
							name = {
								order = 3,
								type = "group",
								name = L["Name"],
								args = {
									name1 = {
										order = 1,
										type = "description",
										fontSize = "medium",
										name = "[name:abbrev-translit] - "..L["Example:"].." Displays a shorten name and will convert cyrillics. Игорь = !Igor",
									},
								},
							},
							resting = {
								order = 3,
								type = "group",
								name = L["Resting"],
								args = {
									resting1 = {
										order = 1,
										type = "description",
										fontSize = "medium",
										name = "[mUI-resting] - "..L["Example:"].." Displays a text if the player is in a resting area. zZz",
									},
								},
							},
						},
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
					style = {
						order = 1,
						type = "toggle",
						name = L["InfoPanel Style"],
					},
				},
			},
			castbar = {
				type = "group",
				order = 6,
				name = L["Castbar Text"].." ("..PLAYER.."/"..TARGET..")",
				get = function(info) return E.db.mui.unitframes.castbar.text[ info[#info] ] end,
				set = function(info, value) E.db.mui.unitframes.castbar.text[ info[#info] ] = value; MCA:UpdateAllCastbars(); end,
				args = {
					ShowInfoText = {
						type = "toggle",
						order = 1,
						name = L["Show InfoPanel text"],
						desc = L["Force show any text placed on the InfoPanel, while casting."],
					},
					castText = {
						type = "toggle",
						order = 2,
						name = L["Show Castbar text"],
					},
					forceTargetText = {
						type = "toggle",
						order = 3,
						name = L["Show on Target"],
						disabled = function() return E.db.mui.unitframes.castbar.text.castText end,
					},
					player = {
						order = 4,
						type = "group",
						name = PLAYER,
						guiInline = true,
						args = {
							yOffset = {
								order = 1,
								type = "range",
								name = L["Y-Offset"],
								desc = L["Adjust castbar text Y Offset"],
								min = -40, max = 40, step = 1,
								get = function(info) return E.db.mui.unitframes.castbar.text.player[ info[#info] ] end,
								set = function(info, value) E.db.mui.unitframes.castbar.text.player[ info[#info] ] = value; MCA:UpdateAllCastbars(); end,
							},
							textColor = {
								order = 2,
								type = "color",
								name = L["Text Color"],
								hasAlpha = true,
								get = function(info)
									local t = E.db.mui.unitframes.castbar.text.player[ info[#info] ]
									local d = P.mui.unitframes.castbar.text.player[info[#info]]
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.mui.unitframes.castbar.text.player[ info[#info] ] = {}
									local t = E.db.mui.unitframes.castbar.text.player[ info[#info] ]
									t.r, t.g, t.b, t.a = r, g, b, a
									MCA:CastBarHooks();
								end,
							},
						},
					},
					target = {
						order = 5,
						type = "group",
						name = TARGET,
						guiInline = true,
						args = {
							yOffset = {
								order = 1,
								type = "range",
								name = L["Y-Offset"],
								desc = L["Adjust castbar text Y Offset"],
								min = -40, max = 40, step = 1,
								get = function(info) return E.db.mui.unitframes.castbar.text.target[ info[#info] ] end,
								set = function(info, value) E.db.mui.unitframes.castbar.text.target[ info[#info] ] = value; MCA:UpdateAllCastbars(); end,
							},
							textColor = {
								order = 2,
								type = "color",
								name = L["Text Color"],
								hasAlpha = true,
								get = function(info)
									local t = E.db.mui.unitframes.castbar.text.target[ info[#info] ]
									local d = P.mui.unitframes.castbar.text.target[info[#info]]
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.mui.unitframes.castbar.text.target[ info[#info] ] = {}
									local t = E.db.mui.unitframes.castbar.text.target[ info[#info] ]
									t.r, t.g, t.b, t.a = r, g, b, a
									MCA:CastBarHooks();
								end,
							},
						},
					},
				},
			},
			textures = {
				order = 7,
				type = "group",
				name = L['Textures'],
				args = {
					castbar = {
						type = 'select', dialogControl = 'LSM30_Statusbar',
						order = 1,
						name = L['Castbar'],
						desc = L['This applies on all available castbars.'],
						values = AceGUIWidgetLSMlists.statusbar,
						get = function(info) return E.db.mui.unitframes.textures[ info[#info] ] end,
						set = function(info, value) E.db.mui.unitframes.textures[ info[#info] ] = value; MCA:CastBarHooks(); end,
					},
				},
			},
			player = {
				order = 3,
				type = "group",
				name = L["Player Frame"],
				args = {
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
				name = L["Target Frame"],
				args = {
					portrait = {
						order = 1,
						type = "execute",
						name = L["Target Portrait"],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "unitframe", "target", "portrait") end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, UnitFramesTable)
