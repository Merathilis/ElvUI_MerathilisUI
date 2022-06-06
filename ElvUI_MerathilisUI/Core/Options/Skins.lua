local MER, F, E, L, V, P, G = unpack(select(2, ...))
local options = MER.options.skins.args
local LSM = E.Libs.LSM

local _G = _G
local ipairs, pairs, unpack = ipairs, pairs, unpack
local format = string.format

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
	{"WeakAuras", L["WeakAuras"], "wa"},
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

options.general = {
	order = 1,
	type = 'group',
	name = L["General"],
	get = function(info) return E.private.mui.skins[info[#info]] end,
	set = function(info, value) E.private.mui.skins[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
	args = {
		header = {
			order = 0,
			type = 'header',
			name = F.cOption(L["General"], 'orange'),
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			width = "full",
			get = function(info) return E.private.mui.skins[ info[#info] ] end,
			set = function(info, value) E.private.mui.skins[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			disabled = function() return not E.private.mui.skins.enable end,
			args = {
				style = {
					order = 3,
					type = "toggle",
					name = L["MerathilisUI Style"],
					desc = L["Creates decorative stripes and a gradient on some frames"],
					set = function(info, value) E.private.mui.skins[ info[#info] ] = value; MER:UpdateStyling() end,
				},
				shadowOverlay = {
					order = 4,
					type = "toggle",
					name = L["MerathilisUI Shadows"],
					desc = L["Enables/Disables a shadow overlay to darken the screen."],
				},
				shadow = {
					order = 5,
					type = "group",
					name = F.cOption(L["Shadows"], 'orange'),
					guiInline = true,
					get = function(info) return E.private.mui.skins.shadow[ info[#info] ] end,
					set = function(info, value) E.private.mui.skins.shadow[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
						},
						increasedSize = {
							order = 2,
							type = "range",
							name = L["Increase Size"],
							desc = L["Make shadow thicker."],
							min = 0, max = 10, step = 1
						},
						color = {
							order = 3,
							type = "color",
							name = L["Shadow Color"],
							hasAlpha = false,
							get = function(info)
								local db = E.private.mui.skins.shadow.color
								local default = V.skins.shadow.color
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.shadow.color
								db.r, db.g, db.b = r, g, b
								E:StaticPopup_Show("PRIVATE_RL")
							end,
							disabled = function()
								return not E.private.mui.skins.enable
							end
						},
					},
				},
			},
		},
	},
}

options.widgets = {
	order = 2,
	type = "group",
	name = E.NewSign..L["Widgets"],
	disabled = function() return not E.private.mui.skins.enable end,
	args = {
		desc = {
			order = 1,
			type = "description",
			name = MER.InfoColor..L["These skins will affect all widgets handled by ElvUI Skins."],
			width = "full",
			fontSize = "medium"
		},
		header = {
			order = 2,
			type = 'header',
			name = F.cOption(L["Widgets"], 'orange'),
		},
		enableAll = {
			order = 3,
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
			order = 4,
			type = "execute",
			name = L["Disable All"],
			func = function()
				for key in pairs(V.skins.widgets) do
					E.private.mui.skins.widgets[key].enable = false
				end
				E:StaticPopup_Show("PRIVATE_RL")
			end
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
						backdropClassColor = {
							order = 2,
							type = "toggle",
							name = L["Backdrop Class Color"],
							width = 1.5
						},
						backdropColor = {
							order = 3,
							type = "color",
							name = L["Backdrop Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].backdropClassColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end
						},
						backdropAlpha = {
							order = 4,
							type = "range",
							name = L["Backdrop Alpha"],
							min = 0,
							max = 1,
							step = 0.01
						},
						borderClassColor = {
							order = 5,
							type = "toggle",
							name = L["Border Class Color"],
							width = 1.5
						},
						borderColor = {
							order = 6,
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
							set = function(info, r, g, b, a)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end
						},
						borderAlpha = {
							order = 7,
							type = "range",
							name = L["Border Alpha"],
							min = 0,
							max = 1,
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
}

options.blizzard = {
	order = 3,
	type = "group",
	name = L["Blizzard"],
	get = function(info) return E.private.mui.skins.blizzard[ info[#info] ] end,
	set = function(info, value) E.private.mui.skins.blizzard[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
	disabled = function() return not E.private.mui.skins.enable end,
	args = {
		info = {
			order = 1,
			type = "description",
			name = MER.InfoColor..L["MER_SKINS_DESC"],
			fontSize = "medium",
		},
		space = {
			order = 2,
			type = "description",
			name = '',
		},
		header = {
			order = 3,
			type = "header",
			name = F.cOption(L["Blizzard"], 'orange'),
		},
		gotoskins = {
			order = 4,
			type = "execute",
			name = L["ElvUI Skins"],
			func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "skins") end,
		},
		enableAll = {
			order = 5,
			type = "execute",
			name = L["Enable All"],
			func = function()
				for key in pairs(V.skins.blizzard) do
					E.private.mui.skins.blizzard[key] = true
				end
				E:StaticPopup_Show("PRIVATE_RL")
			end
		},
		disableAll = {
			order = 6,
			type = "execute",
			name = L["Disable All"],
			func = function()
				for key in pairs(V.skins.blizzard) do
					if key ~= "enable" then
						E.private.mui.skins.blizzard[key] = false
					end
				end
				E:StaticPopup_Show("PRIVATE_RL")
			end
		},
		space2 = {
			order = 7,
			type = "description",
			name = '',
		},
		spellbook = {
			type = "toggle",
			name = L["Spellbook"],
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
		eventToast = {
			type = "toggle",
			name = L["Event Toast Manager"],
			disabled = function() return not E.private.skins.blizzard.enable end,
		},
	},
}

if E.Retail then
	options.blizzard.args.achievement = {
		type = "toggle",
		name = _G.ACHIEVEMENTS,
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.achievement end,
	}
	options.blizzard.args.encounterjournal = {
		type = "toggle",
		name = ENCOUNTER_JOURNAL,
		disabled = function () return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.encounterjournal end
	}
	options.blizzard.args.questChoice = {
		type = "toggle",
		name = L["Quest Choice"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.questChoice end,
	}
	options.blizzard.args.garrison = {
		type = "toggle",
		name = _G.GARRISON_LOCATION_TOOLTIP,
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.garrison end,
	}
	options.blizzard.args.orderhall = {
		type = "toggle",
		name = L["Orderhall"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.orderhall end,
	}
	options.blizzard.args.contribution = {
		type = "toggle",
		name = L["Contribution"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.contribution end,
	}
	options.blizzard.args.artifact = {
		type = "toggle",
		name = _G.ITEM_QUALITY6_DESC,
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.artifact end,
	}
	options.blizzard.args.collections = {
		type = "toggle",
		name = _G.COLLECTIONS,
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.collections end,
	}
	options.blizzard.args.calendar = {
		type = "toggle",
		name = L["Calendar Frame"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.calendar end,
	}
	options.blizzard.args.merchant = {
		type = "toggle",
		name = L["Merchant Frame"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.merchant end,
	}
	options.blizzard.args.pvp = {
		type = "toggle",
		name = L["PvP Frames"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.pvp end,
	}
	options.blizzard.args.lfguild = {
		type = "toggle",
		name = L["LF Guild Frame"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfguild end,
	}
	options.blizzard.args.talkinghead = {
		type = "toggle",
		name = L["TalkingHead"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.talkinghead end,
	}
	options.blizzard.args.objectiveTracker = {
		type = "toggle",
		name = _G.OBJECTIVES_TRACKER_LABEL,
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
	}
	options.blizzard.args.dressingroom = {
		type = "toggle",
		name = _G.DRESSUP_FRAME,
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.dressingroom end,
	}
	options.blizzard.args.blackmarket = {
		type = "toggle",
		name = _G.BLACK_MARKET_AUCTION_HOUSE,
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.bmah end,
	}
	options.blizzard.args.deathRecap = {
		type = "toggle",
		name = _G.DEATH_RECAP_TITLE,
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.deathRecap end,
	}
	options.blizzard.args.challenges = {
		type = "toggle",
		name = _G.CHALLENGES,
		disabled = function() return not E.private.skins.blizzard.enable end, -- No ElvUI skin yet
	}
	options.blizzard.args.azerite = {
		type = "toggle",
		name = L["AzeriteUI"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.azerite end,
	}
	options.blizzard.args.AzeriteRespec = {
		type = "toggle",
		name = _G.AZERITE_RESPEC_TITLE,
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.azeriteRespec end,
	}
	options.blizzard.args.IslandQueue = {
		type = "toggle",
		name = _G.ISLANDS_HEADER,
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.islandQueue end,
	}
	options.blizzard.args.IslandsPartyPose = {
		type = "toggle",
		name = L["Island Party Pose"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.islandsPartyPose end,
	}
	options.blizzard.args.minimap = {
		type = "toggle",
		name = L["Minimap"],
		disabled = function() return not E.private.skins.blizzard.enable end,
	}
	options.blizzard.args.Scrapping = {
		type = "toggle",
		name = _G.SCRAP_BUTTON,
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.scrapping end,
	}
	options.blizzard.args.trainer = {
		type = "toggle",
		name = L["Trainer Frame"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.trainer end,
	}
	options.blizzard.args.debug = {
		type = "toggle",
		name = L["Debug Tools"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.debug end,
	}
	options.blizzard.args.inspect = {
		type = "toggle",
		name = _G.INSPECT,
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.inspect end,
	}
	options.blizzard.args.socket = {
		type = "toggle",
		name = L["Socket Frame"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.socket end,
	}
	options.blizzard.args.itemUpgrade = {
		type = "toggle",
		name = L["Item Upgrade"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.itemUpgrade end,
	}
	options.blizzard.args.trade = {
		type = "toggle",
		name = L["Trade"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.trade end,
	}
	options.blizzard.args.voidstorage = {
		type = "toggle",
		name = _G.VOID_STORAGE,
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.voidstorage end,
	}
	options.blizzard.args.AlliedRaces = {
		type = "toggle",
		name = L["Allied Races"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.alliedRaces end,
	}
	options.blizzard.args.GMChat = {
		type = "toggle",
		name = L["GM Chat"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gmChat end,
	}
	options.blizzard.args.Archaeology = {
		type = "toggle",
		name = L["Archaeology Frame"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.archaeology end,
	}
	options.blizzard.args.AzeriteEssence = {
		type = "toggle",
		name = L["Azerite Essence"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.azeriteEssence end,
	}
	options.blizzard.args.ItemInteraction = {
		type = "toggle",
		name = L["Item Interaction"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.itemInteraction end,
	}
	options.blizzard.args.animaDiversion = {
		type = "toggle",
		name = L["Anima Diversion"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.animaDiversion end,
	}
	options.blizzard.args.soulbinds = {
		type = "toggle",
		name = L["Soulbinds"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.soulbinds end,
	}
	options.blizzard.args.covenantSanctum = {
		type = "toggle",
		name = L["Covenant Sanctum"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.covenantSanctum end,
	}
	options.blizzard.args.covenantPreview = {
		type = "toggle",
		name = L["Covenant Preview"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.covenantPreview end,
	}
	options.blizzard.args.covenantRenown = {
		type = "toggle",
		name = L["Covenant Renown"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.covenantRenown end,
	}
	options.blizzard.args.playerChoice = {
		type = "toggle",
		name = L["Player Choice"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.playerChoice end,
	}
	options.blizzard.args.chromieTime = {
		type = "toggle",
		name = L["Chromie Time"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.chromieTime end,
	}
	options.blizzard.args.levelUp = {
		type = "toggle",
		name = L["LevelUp Display"],
		disabled = function() return not E.private.skins.blizzard.enable end,
	}
	options.blizzard.args.guide = {
		type = "toggle",
		name = L["Guide Frame"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.guide end,
	}
elseif E.Classic then
	options.blizzard.args.craft = {
		type = "toggle",
		name = L["Craft"],
		disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.craft end,
	}
elseif E.TBC then
end

options.addonskins = {
	order = 4,
	type = "group",
	name = L["AddOnSkins"],
	get = function(info) return E.private.mui.skins.addonSkins[ info[#info] ] end,
	set = function(info, value) E.private.mui.skins.addonSkins[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
	disabled = function() return not E.private.mui.skins.enable end,
	args = {
		info = {
			order = 1,
			type = "description",
			name = MER.InfoColor..L["MER_ADDONSKINS_DESC"],
			fontSize = "medium",
		},
		space = {
			order = 2,
			type = "description",
			name = '',
		},
		header = {
			order = 3,
			type = "header",
			name = F.cOption(L["AddOnSkins"], 'orange'),
		},
	},
}

local addorder = 3
for _, v in ipairs(DecorAddons) do
	local addonName, addonString, addonOption, Notes = unpack(v)
	options.addonskins.args[addonOption] = {
		order = addorder + 1,
		type = "toggle",
		name = addonString,
		desc = format('%s '..addonString..' %s', L["Enable/Disable"], L["decor."]),
		disabled = function() return not IsAddOnLoaded(addonName) end,
	}
end

options.profiles = {
	order = 5,
	type = "group",
	name = L["Profiles"],
	args = {
		info = {
			order = 1,
			type = "description",
			name = MER.InfoColor..L["MER_PROFILE_DESC"],
			fontSize = "medium",
		},
		space = {
			order = 2,
			type = "description",
			name = '',
		},
		header = {
			order = 3,
			type = "header",
			name = F.cOption(L["Profiles"], 'orange'),
		},
	},
}

for _, v in ipairs(SupportedProfiles) do
	local addon, addonName = unpack(v)
	local optionOrder = 4
	options.profiles.args[addon] = {
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
