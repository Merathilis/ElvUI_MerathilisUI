local MER, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.Libs.LSM

local _G = _G
local ipairs, pairs, unpack = ipairs, pairs, unpack
local format = string.format
local tinsert = table.insert

local IsAddOnLoaded = IsAddOnLoaded

local DecorAddons = {
	{"ActionBarProfiles", L["ActonBarProfiles"], "abp"},
	{"BigWigs", L["BigWigs"], "bw"},
	{"ElvUI_BenikUI", L["BenikUI"], "bui"},
	{"BugSack", L["BugSack"], "bs",},
	{"ProjectAzilroka", L["ProjectAzilroka"], "pa"},
	{"ls_Toasts", L["ls_Toasts"], "ls"},
	{"Clique", L["Clique"], "cl"},
	{"cargBags_Nivaya", L["cargBags_Nivaya"], "cbn"},
	{"EventTracker", L["EventTracker"], "et"},
	{"WeakAuras", L["WeakAuras"], "wa"}
}

local SupportedProfiles = {
	{"AddOnSkins", "AddOnSkins"},
	{"BigWigs", "BigWigs"},
	{"Details", "Details"},
	{"ElvUI_BenikUI", "BenikUI"},
	{"ElvUI_FCT", "FCT"},
	{"ProjectAzilroka", "ProjectAzilroka"},
	{"ls_Toasts", "ls_Toasts"},
	{"DBM-Core", "Deadly Boss Mods"},
	{"Touhin", "Touhin"},
	{"OmniCD", "OmniCD"},
}

local profileString = format("|cfffff400%s |r", L["MerathilisUI successfully created and applied profile(s) for:"])

local function SkinsTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.skins = {
		order = 30,
		type = "group",
		name = F.cOption(L["Skins/AddOns"], 'gradient'),
		icon = MER.Media.Icons.skins,
		childGroups = "tab",
		args = {
			name = ACH:Header(F.cOption(L["Skins/AddOns"], 'orange'), 1),
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				args = {
					style = {
						order = 1,
						type = "toggle",
						name = L["MerathilisUI Style"],
						desc = L["Creates decorative stripes and a gradient on some frames"],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; MER:UpdateStyling() end,
					},
					shadowOverlay = {
						order = 2,
						type = "toggle",
						name = L["MerathilisUI Shadows"],
						desc = L["Enables/Disables a shadow overlay to darken the screen."],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
				},
			},
			widgets = {
				order = 3,
				type = "group",
				name = E.NewSign..L["Widgets"],
				args = {
					enableAll = {
						order = 1,
						type = "execute",
						name = L["Enable All"],
						func = function()
							for key in pairs(V.skins.widgets) do
								E.private.mui.skins.widgets[key].enable = true
							end
							E:StaticPopup_Show("PRIVATE_RL")
						end
					},
					disableAll = {
						order = 2,
						type = "execute",
						name = L["Disable All"],
						func = function()
							for key in pairs(V.skins.widgets) do
								E.private.mui.skins.widgets[key].enable = false
							end
							E:StaticPopup_Show("PRIVATE_RL")
						end
					},
					descGroup = {
						order = 3,
						type = "group",
						name = " ",
						inline = true,
						args = {
							desc = {
								order = 1,
								type = "description",
								name = L["These skins will affect all widgets handled by ElvUI Skins."],
								width = "full",
								fontSize = "medium"
							},
						},
					},
					button = {
						order = 10,
						type = "group",
						name = L["Button"],
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								width = "full",
								get = function(info)
									return E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
								end,
								set = function(info, value)
									E.private.mui.skins.widgets[info[#info - 1]][info[#info]] = value
									E:StaticPopup_Show("PRIVATE_RL")
								end
							},
							backdrop = {
								order = 2,
								type = "group",
								name = L["Additional Backdrop"],
								inline = true,
								get = function(info)
									return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								end,
								set = function(info, value)
									E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
									E:StaticPopup_Show("PRIVATE_RL")
								end,
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 2]].enable or
										not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
										width = "full",
										disabled = function(info)
											return not E.private.mui.skins.widgets[info[#info - 2]].enable
										end
									},
									texture = {
										order = 2,
										type = "select",
										name = L["Texture"],
										dialogControl = "LSM30_Statusbar",
										values = LSM:HashTable("statusbar")
									},
									removeBorderEffect = {
										order = 3,
										type = "toggle",
										name = L["Remove Border Effect"],
										width = 1.5
									},
									classColor = {
										order = 4,
										type = "toggle",
										name = L["Class Color"]
									},
									color = {
										order = 5,
										type = "color",
										name = L["Color"],
										hasAlpha = false,
										hidden = function(info)
											return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].classColor
										end,
										get = function(info)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
										end,
										set = function(info, r, g, b)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											db.r, db.g, db.b = r, g, b
										end
									},
									alpha = {
										order = 6,
										type = "range",
										name = L["Alpha"],
										min = 0,
										max = 1,
										step = 0.01
									},
									animationType = {
										order = 7,
										type = "select",
										name = L["Animation Type"],
										desc = L["The type of animation activated when a button is hovered."],
										hidden = true,
										values = {
											FADE = L["Fade"]
										}
									},
									animationDuration = {
										order = 8,
										type = "range",
										name = L["Animation Duration"],
										desc = L["The duration of the animation in seconds."],
										min = 0,
										max = 3,
										step = 0.01
									},
								},
							},
							text = {
								order = 3,
								type = "group",
								name = L["Text"],
								inline = true,
								get = function(info)
									return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								end,
								set = function(info, value)
									E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
									E:StaticPopup_Show("PRIVATE_RL")
								end,
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 2]].enable or
										not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
										width = "full",
										disabled = function(info)
											return not E.private.mui.skins.widgets[info[#info - 2]].enable
										end
									},
									font = {
										order = 6,
										type = "group",
										inline = true,
										name = L["Font Setting"],
										disabled = function(info)
											return not E.private.mui.skins.widgets[info[#info - 3]].enable or
												not E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].enable
										end,
										get = function(info)
											return E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]]
										end,
										set = function(info, value)
											E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]] = value
											E:StaticPopup_Show("PRIVATE_RL")
										end,
										args = {
											name = {
												order = 1,
												type = "select",
												dialogControl = "LSM30_Font",
												name = L["Font"],
												values = LSM:HashTable("font")
											},
											style = {
												order = 2,
												type = "select",
												name = L["Outline"],
												values = {
													NONE = L["None"],
													OUTLINE = L["OUTLINE"],
													MONOCHROME = L["MONOCHROME"],
													MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
													THICKOUTLINE = L["THICKOUTLINE"]
												},
											},
										},
									},
								},
							},
						},
					},
					treeGroupButton = {
						order = 11,
						type = "group",
						name = L["Tree Group Button"],
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								width = "full",
								get = function(info)
									return E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
								end,
								set = function(info, value)
									E.private.mui.skins.widgets[info[#info - 1]][info[#info]] = value
									E:StaticPopup_Show("PRIVATE_RL")
								end
							},
							backdrop = {
								order = 2,
								type = "group",
								name = L["Additional Backdrop"],
								inline = true,
								get = function(info)
									return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								end,
								set = function(info, value)
									E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
									E:StaticPopup_Show("PRIVATE_RL")
								end,
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 2]].enable or
										not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
										width = "full",
										disabled = function(info)
											return not E.private.mui.skins.widgets[info[#info - 2]].enable
										end
									},
									texture = {
										order = 2,
										type = "select",
										name = L["Texture"],
										dialogControl = "LSM30_Statusbar",
										values = LSM:HashTable("statusbar")
									},
									removeBorderEffect = {
										order = 3,
										type = "toggle",
										name = L["Remove Border Effect"],
										width = 1.5
									},
									classColor = {
										order = 4,
										type = "toggle",
										name = L["Class Color"]
									},
									color = {
										order = 5,
										type = "color",
										name = L["Color"],
										hasAlpha = false,
										hidden = function(info)
											return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].classColor
										end,
										get = function(info)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
										end,
										set = function(info, r, g, b)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											db.r, db.g, db.b = r, g, b
										end
									},
									alpha = {
										order = 6,
										type = "range",
										name = L["Alpha"],
										min = 0,
										max = 1,
										step = 0.01
									},
									animationType = {
										order = 7,
										type = "select",
										name = L["Animation Type"],
										desc = L["The type of animation activated when a button is hovered."],
										hidden = true,
										values = {
											FADE = L["Fade"]
										}
									},
									animationDuration = {
										order = 8,
										type = "range",
										name = L["Animation Duration"],
										desc = L["The duration of the animation in seconds."],
										min = 0,
										max = 3,
										step = 0.01
									}
								}
							},
							selected = {
								order = 3,
								type = "group",
								name = L["Selected Backdrop & Border"],
								inline = true,
								get = function(info)
									return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								end,
								set = function(info, value)
									E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
									E:StaticPopup_Show("PRIVATE_RL")
								end,
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 2]].enable or
										not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
										width = "full",
										disabled = function(info)
											return not E.private.mui.skins.widgets[info[#info - 2]].enable
										end
									},
									texture = {
										order = 2,
										type = "select",
										name = L["Texture"],
										dialogControl = "LSM30_Statusbar",
										values = LSM:HashTable("statusbar")
									},
									backdropClassColor = {
										order = 3,
										type = "toggle",
										name = L["Backdrop Class Color"],
										width = 1.5
									},
									backdropColor = {
										order = 4,
										type = "color",
										name = L["Backdrop Color"],
										hasAlpha = false,
										hidden = function(info)
											return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].backdropClassColor
										end,
										get = function(info)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
										end,
										set = function(info, r, g, b)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											db.r, db.g, db.b = r, g, b
										end
									},
									backdropAlpha = {
										order = 5,
										type = "range",
										name = L["Backdrop Alpha"],
										min = 0,
										max = 1,
										step = 0.01
									},
									borderClassColor = {
										order = 6,
										type = "toggle",
										name = L["Border Class Color"],
										width = 1.5
									},
									borderColor = {
										order = 7,
										type = "color",
										name = L["Border Color"],
										hasAlpha = false,
										hidden = function(info)
											return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].borderClassColor
										end,
										get = function(info)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
										end,
										set = function(info, r, g, b)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											db.r, db.g, db.b = r, g, b
										end
									},
									borderAlpha = {
										order = 8,
										type = "range",
										name = L["Border Alpha"],
										min = 0,
										max = 1,
										step = 0.01
									}
								}
							},
							text = {
								order = 4,
								type = "group",
								name = L["Text"],
								inline = true,
								get = function(info)
									return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								end,
								set = function(info, value)
									E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
									E:StaticPopup_Show("PRIVATE_RL")
								end,
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 2]].enable or
										not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
										width = "full",
										disabled = function(info)
											return not E.private.mui.skins.widgets[info[#info - 2]].enable
										end
									},
									normalClassColor = {
										order = 2,
										type = "toggle",
										name = L["Normal Class Color"],
										width = 1.5
									},
									normalColor = {
										order = 3,
										type = "color",
										name = L["Normal Color"],
										hasAlpha = false,
										hidden = function(info)
											return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].normalClassColor
										end,
										get = function(info)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
										end,
										set = function(info, r, g, b)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											db.r, db.g, db.b = r, g, b
										end
									},
									selectedClassColor = {
										order = 4,
										type = "toggle",
										name = L["Selected Class Color"],
										width = 1.5
									},
									selectedColor = {
										order = 5,
										type = "color",
										name = L["Selected Color"],
										hasAlpha = false,
										hidden = function(info)
											return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].selectedClassColor
										end,
										get = function(info)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
										end,
										set = function(info, r, g, b)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											db.r, db.g, db.b = r, g, b
										end
									},
									font = {
										order = 6,
										type = "group",
										inline = true,
										name = L["Font Setting"],
										disabled = function(info)
											return not E.private.mui.skins.widgets[info[#info - 3]].enable or
												not E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].enable
										end,
										get = function(info)
											return E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]]
										end,
										set = function(info, value)
											E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]] = value
											E:StaticPopup_Show("PRIVATE_RL")
										end,
										args = {
											name = {
												order = 1,
												type = "select",
												dialogControl = "LSM30_Font",
												name = L["Font"],
												values = LSM:HashTable("font")
											},
											style = {
												order = 2,
												type = "select",
												name = L["Outline"],
												values = {
													NONE = L["None"],
													OUTLINE = L["OUTLINE"],
													MONOCHROME = L["MONOCHROME"],
													MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
													THICKOUTLINE = L["THICKOUTLINE"]
												},
											},
										},
									},
								},
							},
						},
					},
					tab = {
						order = 12,
						type = "group",
						name = L["Tab"],
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								width = "full",
								get = function(info)
									return E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
								end,
								set = function(info, value)
									E.private.mui.skins.widgets[info[#info - 1]][info[#info]] = value
									E:StaticPopup_Show("PRIVATE_RL")
								end
							},
							backdrop = {
								order = 2,
								type = "group",
								name = L["Additional Backdrop"],
								inline = true,
								get = function(info)
									return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								end,
								set = function(info, value)
									E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
									E:StaticPopup_Show("PRIVATE_RL")
								end,
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 2]].enable or
										not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
										width = "full",
										disabled = function(info)
											return not E.private.mui.skins.widgets[info[#info - 2]].enable
										end
									},
									texture = {
										order = 2,
										type = "select",
										name = L["Texture"],
										dialogControl = "LSM30_Statusbar",
										values = LSM:HashTable("statusbar")
									},
									classColor = {
										order = 3,
										type = "toggle",
										name = L["Class Color"]
									},
									color = {
										order = 4,
										type = "color",
										name = L["Color"],
										hasAlpha = false,
										hidden = function(info)
											return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].classColor
										end,
										get = function(info)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
										end,
										set = function(info, r, g, b)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											db.r, db.g, db.b = r, g, b
										end
									},
									alpha = {
										order = 5,
										type = "range",
										name = L["Alpha"],
										min = 0,
										max = 1,
										step = 0.01
									},
									animationType = {
										order = 6,
										type = "select",
										name = L["Animation Type"],
										desc = L["The type of animation activated when a button is hovered."],
										hidden = true,
										values = {
											FADE = L["Fade"]
										}
									},
									animationDuration = {
										order = 7,
										type = "range",
										name = L["Animation Duration"],
										desc = L["The duration of the animation in seconds."],
										min = 0,
										max = 3,
										step = 0.01
									},
								},
							},
							selected = {
								order = 3,
								type = "group",
								name = L["Selected Backdrop & Border"],
								inline = true,
								get = function(info)
									return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								end,
								set = function(info, value)
									E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
									E:StaticPopup_Show("PRIVATE_RL")
								end,
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 2]].enable or
										not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
										width = "full",
										disabled = function(info)
											return not E.private.mui.skins.widgets[info[#info - 2]].enable
										end
									},
									texture = {
										order = 2,
										type = "select",
										name = L["Texture"],
										dialogControl = "LSM30_Statusbar",
										values = LSM:HashTable("statusbar")
									},
									backdropClassColor = {
										order = 4,
										type = "toggle",
										name = L["Backdrop Class Color"],
										width = 1.5
									},
									backdropColor = {
										order = 5,
										type = "color",
										name = L["Backdrop Color"],
										hasAlpha = true,
										hidden = function(info)
											return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].backdropClassColor
										end,
										get = function(info)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
										end,
										set = function(info, r, g, b, a)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											db.r, db.g, db.b, db.a = r, g, b, a
										end
									},
									borderClassColor = {
										order = 4,
										type = "toggle",
										name = L["Border Class Color"],
										width = 1.5
									},
									borderColor = {
										order = 5,
										type = "color",
										name = L["Border Color"],
										hasAlpha = true,
										hidden = function(info)
											return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].borderClassColor
										end,
										get = function(info)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
										end,
										set = function(info, r, g, b, a)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											db.r, db.g, db.b, db.a = r, g, b, a
										end
									},
								},
							},
							text = {
								order = 4,
								type = "group",
								name = L["Text"],
								inline = true,
								get = function(info)
									return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								end,
								set = function(info, value)
									E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
									E:StaticPopup_Show("PRIVATE_RL")
								end,
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 2]].enable or
										not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
										width = "full",
										disabled = function(info)
											return not E.private.mui.skins.widgets[info[#info - 2]].enable
										end
									},
									normalClassColor = {
										order = 2,
										type = "toggle",
										name = L["Normal Class Color"],
										width = 1.5
									},
									normalColor = {
										order = 3,
										type = "color",
										name = L["Normal Color"],
										hasAlpha = false,
										hidden = function(info)
											return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].normalClassColor
										end,
										get = function(info)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
										end,
										set = function(info, r, g, b)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											db.r, db.g, db.b = r, g, b
										end
									},
									selectedClassColor = {
										order = 4,
										type = "toggle",
										name = L["Selected Class Color"],
										width = 1.5
									},
									selectedColor = {
										order = 5,
										type = "color",
										name = L["Selected Color"],
										hasAlpha = false,
										hidden = function(info)
											return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].selectedClassColor
										end,
										get = function(info)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
										end,
										set = function(info, r, g, b)
											local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
											db.r, db.g, db.b = r, g, b
										end
									},
									font = {
										order = 6,
										type = "group",
										inline = true,
										name = L["Font Setting"],
										disabled = function(info)
											return not E.private.mui.skins.widgets[info[#info - 3]].enable or
												not E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].enable
										end,
										get = function(info)
											return E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]]
										end,
										set = function(info, value)
											E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]] = value
											E:StaticPopup_Show("PRIVATE_RL")
										end,
										args = {
											name = {
												order = 1,
												type = "select",
												dialogControl = "LSM30_Font",
												name = L["Font"],
												values = LSM:HashTable("font")
											},
											style = {
												order = 2,
												type = "select",
												name = L["Outline"],
												values = {
													NONE = L["None"],
													OUTLINE = L["OUTLINE"],
													MONOCHROME = L["MONOCHROME"],
													MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
													THICKOUTLINE = L["THICKOUTLINE"]
												},
											},
										},
									},
								},
							},
						},
					},
					checkBox = {
						order = 13,
						type = "group",
						name = L["Check Box"],
						get = function(info)
							return E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
						end,
						set = function(info, value)
							E.private.mui.skins.widgets[info[#info - 1]][info[#info]] = value
							E:StaticPopup_Show("PRIVATE_RL")
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								width = "full",
							},
							desc = {
								order = 1,
								type = "description",
								name = "|cffff0000" ..
									L["To enable this feature, you need to enable the check box skin in ElvUI Skins first."] ..
										"|r",
								hidden = function(info)
									return E.private.skins.checkBoxSkin
								end
							},
							texture = {
								order = 3,
								type = "select",
								name = L["Texture"],
								dialogControl = "LSM30_Statusbar",
								values = LSM:HashTable("statusbar"),
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 1]].enable
								end
							},
							classColor = {
								order = 4,
								type = "toggle",
								name = L["Class Color"],
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 1]].enable
								end
							},
							color = {
								order = 5,
								type = "color",
								name = L["Color"],
								hasAlpha = true,
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 1]].enable
								end,
								hidden = function(info)
									return E.private.mui.skins.widgets[info[#info - 1]].classColor
								end,
								get = function(info)
									local db = E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
									local default = V.skins.widgets[info[#info - 1]][info[#info]]
									return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
								end,
								set = function(info, r, g, b, a)
									local db = E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
									db.r, db.g, db.b, db.a = r, g, b, a
								end
							},
						},
					},
					slider = {
						order = 14,
						type = "group",
						name = L["Slider"],
						get = function(info)
							return E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
						end,
						set = function(info, value)
							E.private.mui.skins.widgets[info[#info - 1]][info[#info]] = value
							E:StaticPopup_Show("PRIVATE_RL")
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								width = "full"
							},
							texture = {
								order = 2,
								type = "select",
								name = L["Texture"],
								dialogControl = "LSM30_Statusbar",
								values = LSM:HashTable("statusbar"),
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 1]].enable
								end
							},
							classColor = {
								order = 3,
								type = "toggle",
								name = L["Class Color"],
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 1]].enable
								end
							},
							color = {
								order = 4,
								type = "color",
								name = L["Color"],
								hasAlpha = true,
								disabled = function(info)
									return not E.private.mui.skins.widgets[info[#info - 1]].enable
								end,
								hidden = function(info)
									return E.private.mui.skins.widgets[info[#info - 1]].classColor
								end,
								get = function(info)
									local db = E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
									local default = V.skins.widgets[info[#info - 1]][info[#info]]
									return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
								end,
								set = function(info, r, g, b, a)
									local db = E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
									db.r, db.g, db.b, db.a = r, g, b, a
								end
							},
						},
					},
				},
			},
		},
	}

	E.Options.args.mui.args.skins.args.addonskins = {
		order = 6,
		type = "group",
		name =L["AddOnSkins"],
		get = function(info) return E.private.mui.skins.addonSkins[ info[#info] ] end,
		set = function(info, value) E.private.mui.skins.addonSkins[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
		args = {
			info = ACH:Description(L["MER_ADDONSKINS_DESC"], 1),
			space = ACH:Spacer(2),
		},
	}

	local addorder = 3
	for i, v in ipairs(DecorAddons) do
		local addonName, addonString, addonOption, Notes = unpack(v)
		E.Options.args.mui.args.skins.args.addonskins.args[addonOption] = {
			order = addorder + 1,
			type = "toggle",
			name = addonString,
			desc = format('%s '..addonString..' %s', L["Enable/Disable"], L["decor."]),
			disabled = function() return not IsAddOnLoaded(addonName) end,
		}
	end

	local blizzOrder = 4
	E.Options.args.mui.args.skins.args.blizzard = {
		order = blizzOrder + 1,
		type = "group",
		name = L["Blizzard"],
		get = function(info) return E.private.mui.skins.blizzard[ info[#info] ] end,
		set = function(info, value) E.private.mui.skins.blizzard[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
		args = {
			info = ACH:Description(L["MER_SKINS_DESC"], 1),
			space = ACH:Spacer(2),
			gotoskins = {
				order = 3,
				type = "execute",
				name = L["ElvUI Skins"],
				func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "skins") end,
			},
			space2 = ACH:Spacer(4),
			spellbook = {
				type = "toggle",
				name = L["SPELLBOOK"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.spellbook end,
			},
			character = {
				type = "toggle",
				name = L["Character Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character end,
			},
			gossip = {
				type = "toggle",
				name = L["Gossip Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gossip end,
			},
			quest = {
				type = "toggle",
				name = L["Quest Frames"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.quest end,
			},
			talent = {
				type = "toggle",
				name = L["TALENTS"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.talent end,
			},
			auctionhouse = {
				type = "toggle",
				name = L["AUCTIONS"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.auctionhouse end,
			},
			friends = {
				type = "toggle",
				name = L["FRIENDS"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.friends end,
			},
			tradeskill = {
				type = "toggle",
				name = L["TRADESKILLS"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.tradeskill end,
			},
			lfg = {
				type = "toggle",
				name = L["LFG_TITLE"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfg end,
			},
			guild = {
				type = "toggle",
				name = L["GUILD"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.guild end,
			},
			addonManager = {
				type = "toggle",
				name = L["AddOn Manager"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.addonManager end,
			},
			mail = {
				type = "toggle",
				name =  L["Mail Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.mail end,
			},
			timemanager = {
				type = "toggle",
				name = L["TIMEMANAGER_TITLE"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.timemanager end,
			},
			worldmap = {
				type = "toggle",
				name = L["WORLD_MAP"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.worldmap end,
			},
			guildcontrol = {
				type = "toggle",
				name = L["Guild Control Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.guildcontrol end,
			},
			macro = {
				type = "toggle",
				name = L["MACROS"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.macro end,
			},
			binding = {
				type = "toggle",
				name = L["KEY_BINDINGS"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.binding end,
			},
			gbank = {
				type = "toggle",
				name = L["GUILD_BANK"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gbank end,
			},
			taxi = {
				type = "toggle",
				name = L["FLIGHT_MAP"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.taxi end,
			},
			help = {
				type = "toggle",
				name = L["Help Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.help end,
			},
			loot = {
				type = "toggle",
				name = L["Loot Frames"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.loot end,
			},
			channels = {
				type = "toggle",
				name = L["CHANNELS"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.channels end,
			},
			communities = {
				type = "toggle",
				name = L["COMMUNITIES"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.communities end,
			},
			raid = {
				type = "toggle",
				name = L["Raid Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.raid end,
			},
			craft = {
				type = "toggle",
				name = L["Craft"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.craft end,
			},
		},
	}

	if E.Retail then
		E.Options.args.mui.args.skins.args.blizzard.args.achievement = {
			type = "toggle",
			name = _G.ACHIEVEMENTS,
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.achievement end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.encounterjournal = {
			type = "toggle",
			name = ENCOUNTER_JOURNAL,
			disabled = function () return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.encounterjournal end
		}
		E.Options.args.mui.args.skins.args.blizzard.args.questChoice = {
			type = "toggle",
			name = L["Quest Choice"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.questChoice end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.garrison = {
			type = "toggle",
			name = _G.GARRISON_LOCATION_TOOLTIP,
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.garrison end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.orderhall = {
			type = "toggle",
			name = L["Orderhall"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.orderhall end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.contribution = {
			type = "toggle",
			name = L["Contribution"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.contribution end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.artifact = {
			type = "toggle",
			name = _G.ITEM_QUALITY6_DESC,
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.artifact end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.collections = {
			type = "toggle",
			name = _G.COLLECTIONS,
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.collections end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.calendar = {
			type = "toggle",
			name = L["Calendar Frame"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.calendar end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.merchant = {
			type = "toggle",
			name = L["Merchant Frame"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.merchant end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.pvp = {
			type = "toggle",
			name = L["PvP Frames"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.pvp end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.lfguild = {
			type = "toggle",
			name = L["LF Guild Frame"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfguild end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.talkinghead = {
			type = "toggle",
			name = L["TalkingHead"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.talkinghead end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.objectiveTracker = {
			type = "toggle",
			name = _G.OBJECTIVES_TRACKER_LABEL,
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.dressingroom = {
			type = "toggle",
			name = _G.DRESSUP_FRAME,
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.dressingroom end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.blackmarket = {
			type = "toggle",
			name = _G.BLACK_MARKET_AUCTION_HOUSE,
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.bmah end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.deathRecap = {
			type = "toggle",
			name = _G.DEATH_RECAP_TITLE,
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.deathRecap end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.challenges = {
			type = "toggle",
			name = _G.CHALLENGES,
			disabled = function() return not E.private.skins.blizzard.enable end, -- No ElvUI skin yet
		}
		E.Options.args.mui.args.skins.args.blizzard.args.azerite = {
			type = "toggle",
			name = L["AzeriteUI"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.azerite end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.AzeriteRespec = {
			type = "toggle",
			name = _G.AZERITE_RESPEC_TITLE,
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.azeriteRespec end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.IslandQueue = {
			type = "toggle",
			name = _G.ISLANDS_HEADER,
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.islandQueue end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.IslandsPartyPose = {
			type = "toggle",
			name = L["Island Party Pose"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.islandsPartyPose end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.minimap = {
			type = "toggle",
			name = L["Minimap"],
			disabled = function() return not E.private.skins.blizzard.enable end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.Scrapping = {
			type = "toggle",
			name = _G.SCRAP_BUTTON,
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.scrapping end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.trainer = {
			type = "toggle",
			name = L["Trainer Frame"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.trainer end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.debug = {
			type = "toggle",
			name = L["Debug Tools"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.debug end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.inspect = {
			type = "toggle",
			name = _G.INSPECT,
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.inspect end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.socket = {
			type = "toggle",
			name = L["Socket Frame"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.socket end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.itemUpgrade = {
			type = "toggle",
			name = L["Item Upgrade"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.itemUpgrade end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.trade = {
			type = "toggle",
			name = L["Trade"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.trade end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.voidstorage = {
			type = "toggle",
			name = _G.VOID_STORAGE,
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.voidstorage end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.AlliedRaces = {
			type = "toggle",
			name = L["Allied Races"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.alliedRaces end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.GMChat = {
			type = "toggle",
			name = L["GM Chat"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gmChat end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.Archaeology = {
			type = "toggle",
			name = L["Archaeology Frame"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.archaeology end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.AzeriteEssence = {
			type = "toggle",
			name = L["Azerite Essence"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.azeriteEssence end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.ItemInteraction = {
			type = "toggle",
			name = L["Item Interaction"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.itemInteraction end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.animaDiversion = {
			type = "toggle",
			name = L["Anima Diversion"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.animaDiversion end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.soulbinds = {
			type = "toggle",
			name = L["Soulbinds"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.soulbinds end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.covenantSanctum = {
			type = "toggle",
			name = L["Covenant Sanctum"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.covenantSanctum end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.covenantPreview = {
			type = "toggle",
			name = L["Covenant Preview"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.covenantPreview end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.covenantRenown = {
			type = "toggle",
			name = L["Covenant Renown"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.covenantRenown end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.playerChoice = {
			type = "toggle",
			name = L["Player Choice"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.playerChoice end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.chromieTime = {
			type = "toggle",
			name = L["Chromie Time"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.chromieTime end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.levelUp = {
			type = "toggle",
			name = L["LevelUp Display"],
			disabled = function() return not E.private.skins.blizzard.enable end,
		}
		E.Options.args.mui.args.skins.args.blizzard.args.guide = {
			type = "toggle",
			name = L["Guide Frame"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.guide end,
		}
	elseif E.Classic then
		E.Options.args.mui.args.skins.args.blizzard.args.craft = {
			type = "toggle",
			name = L["Craft"],
			disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.craft end,
		}
	elseif E.TBC then

	end

	E.Options.args.mui.args.skins.args.profiles = {
		order = 6,
		type = "group",
		name = L["Profiles"],
		args = {
			info = ACH:Description(L["MER_PROFILE_DESC"], 1),
		},
	}

	for i, v in ipairs(SupportedProfiles) do
		local addon, addonName = unpack(v)
		local optionOrder = 1
		E.Options.args.mui.args.skins.args.profiles.args[addon] = {
			order = optionOrder + 1,
			type = "execute",
			name = addonName,
			desc = L["This will create and apply profile for "]..addonName,
			func = function()
				if addon == 'BigWigs' then
					MER:LoadBigWigsProfile()
					F.Print('BigWigs profile has been set.')
					E:StaticPopup_Show("PRIVATE_RL")
				elseif addon == 'DBM-Core' then
					E:StaticPopup_Show("MUI_INSTALL_DBM_LAYOUT")
				elseif addon == 'ElvUI_BenikUI' then
					E:StaticPopup_Show("MUI_INSTALL_BUI_LAYOUT")
				elseif addon == 'Skada' then
					MER:LoadSkadaProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'Details' then
					E:StaticPopup_Show("MUI_INSTALL_DETAILS_LAYOUT")
				elseif addon == 'AddOnSkins' then
					MER:LoadAddOnSkinsProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'ProjectAzilroka' then
					MER:LoadPAProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'ls_Toasts' then
					MER:LoadLSProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'Touhin' then
					MER:LoadTouhinProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'iFilger' then
					MER:LoadiFilgerProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'ElvUI_FCT' then
					local FCT = E.Libs.AceAddon:GetAddon('ElvUI_FCT')
					MER:LoadFCTProfile()
					FCT:UpdateUnitFrames()
					FCT:UpdateNamePlates()
				elseif addon == 'OmniCD' then
					MER:LoadOmniCDProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				end
				F.Print(profileString..addonName)
			end,
			disabled = function() return not IsAddOnLoaded(addon) end,
		}
	end
end
tinsert(MER.Config, SkinsTable)
