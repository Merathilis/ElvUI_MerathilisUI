local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_ObjectiveTracker')
local LSM = E.Libs.LSM

local format = string.format
local tinsert = table.insert

local ObjectiveTracker_Update = ObjectiveTracker_Update

local function ObjectiveTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.objectiveTracker = {
		type = "group",
		name = E.NewSign..L["Objective Tracker"],
		childGroups = 'tab',
		get = function(info) return E.db.mui.blizzard.objectiveTracker[info[#info]] end,
		set = function(info, value)
			E.db.mui.blizzard.objectiveTracker[info[#info]] = value; ObjectiveTracker_Update(); end,
		args = {
			name = ACH:Header(F.cOption(L["Objective Tracker"], 'orange'), 1),
			description = {
				order = 2,
				type = "group",
				inline = true,
				name = L["Description"],
				args = {
					feature_1 = {
						order = 1,
						type = "description",
						name = L["1. Customize the font of Objective Tracker."],
						fontSize = "medium"
					},
					feature_2 = {
						order = 2,
						type = "description",
						name = L["2. Add colorful progress text to the quest."],
						fontSize = "medium"
					},
				},
			},
			enable = {
				order = 3,
				type = "toggle",
				name = L["Enable"],
				width = "full",
				set = function(info, value)
					E.db.mui.blizzard.objectiveTracker[info[#info]] = value
					E:StaticPopup_Show("PRIVATE_RL")
				end
			},
			progress = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Progress"],
				disabled = function()
					return not E.db.mui.blizzard.objectiveTracker.enable
				end,
				args = {
					noDash = {
						order = 1,
						type = "toggle",
						disabled = function()
							return not E.db.mui.blizzard.objectiveTracker.enable
						end,
						name = L["No Dash"]
					},
					colorfulProgress = {
						order = 2,
						type = "toggle",
						name = L["Colorful Progress"]
					},
					percentage = {
						order = 3,
						type = "toggle",
						name = L["Percentage"],
						desc = L["Add percentage text after quest text."]
					},
					colorfulPercentage = {
						order = 4,
						type = "toggle",
						name = L["Colorful Percentage"],
						desc = L["Make the additional percentage text be colored."]
					}
				}
			},
			cosmeticBar = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Cosmetic Bar"],
				disabled = function()
					return not E.db.mui.blizzard.objectiveTracker.enable
				end,
				get = function(info)
					return E.db.mui.blizzard.objectiveTracker.cosmeticBar[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.blizzard.objectiveTracker.cosmeticBar[info[#info]] = value
					module:ChangeQuestHeaderStyle()
				end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"]
					},
					style = {
						order = 2,
						type = "group",
						inline = true,
						name = L["Style"],
						disabled = function()
							return not E.db.mui.blizzard.objectiveTracker.enable or not E.db.mui.blizzard.objectiveTracker.cosmeticBar.enable
						end,
						args = {
							texture = {
								order = 1,
								type = "select",
								name = L["Texture"],
								dialogControl = "LSM30_Statusbar",
								values = LSM:HashTable("statusbar")
							},
							border = {
								order = 2,
								type = "select",
								name = L["Border"],
								values = {
									NONE = L["None"],
									ONEPIXEL = L["One Pixel"],
									SHADOW = L["Shadow"]
								}
							},
							borderAlpha = {
								order = 3,
								type = "range",
								name = L["Border Alpha"],
								min = 0,
								max = 1,
								step = 0.01
							}
						}
					},
					position = {
						order = 3,
						type = "group",
						inline = true,
						name = L["Position"],
						disabled = function()
							return not E.db.mui.blizzard.objectiveTracker.enable or not E.db.mui.blizzard.objectiveTracker.cosmeticBar.enable
						end,
						args = {
							widthMode = {
								order = 1,
								type = "select",
								name = L["Width Mode"],
								desc = L["'Absolute' mode means the width of the bar is fixed."] ..
									"\n" .. L["'Dynamic' mode will also add the width of header text."],
								values = {
									ABSOLUTE = L["Absolute"],
									DYNAMIC = L["Dyanamic"]
								}
							},
							width = {
								order = 2,
								type = "range",
								name = L["Width"],
								min = -200,
								max = 300,
								step = 1
							},
							heightMode = {
								order = 3,
								type = "select",
								name = L["Height Mode"],
								desc = L["'Absolute' mode means the height of the bar is fixed."] ..
									"\n" .. L["'Dynamic' mode will also add the height of header text."],
								values = {
									ABSOLUTE = L["Absolute"],
									DYNAMIC = L["Dyanamic"]
								}
							},
							height = {
								order = 4,
								type = "range",
								name = L["Height"],
								min = -200,
								max = 300,
								step = 1
							},
							offsetX = {
								order = 5,
								type = "range",
								name = L["X-Offset"],
								min = -500,
								max = 500,
								step = 1
							},
							offsetY = {
								order = 6,
								type = "range",
								name = L["Y-Offset"],
								min = -500,
								max = 500,
								step = 1
							}
						}
					},
					color = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Color"],
						disabled = function()
							return not E.db.mui.blizzard.objectiveTracker.enable or
								not E.db.mui.blizzard.objectiveTracker.cosmeticBar.enable
						end,
						get = function(info)
							return E.db.mui.blizzard.objectiveTracker.cosmeticBar.color[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.blizzard.objectiveTracker.cosmeticBar.color[info[#info]] = value
							module:ChangeQuestHeaderStyle()
						end,
						args = {
							mode = {
								order = 1,
								type = "select",
								name = L["Color Mode"],
								values = {
									GRADIENT = L["Gradient"],
									NORMAL = L["Normal"],
									CLASS = L["Class Color"]
								}
							},
							normalColor = {
								order = 2,
								type = "color",
								name = L["Normal Color"],
								hasAlpha = true,
								hidden = function()
									if E.db.mui.blizzard.objectiveTracker.cosmeticBar.color.mode ~= "NORMAL" then
										return true
									end
								end,
								get = function(info)
									local db = E.db.mui.blizzard.objectiveTracker.cosmeticBar.color.normalColor
									local default = P.blizzard.objectiveTracker.cosmeticBar.color.normalColor
									return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
								end,
								set = function(info, r, g, b, a)
									local db = E.db.mui.blizzard.objectiveTracker.cosmeticBar.color.normalColor
									db.r, db.g, db.b, db.a = r, g, b, a
									module:ChangeQuestHeaderStyle()
								end
							},
							gradientColor1 = {
								order = 3,
								type = "color",
								name = L["Gradient Color 1"],
								hasAlpha = true,
								hidden = function()
									if E.db.mui.blizzard.objectiveTracker.cosmeticBar.color.mode ~= "GRADIENT" then
										return true
									end
								end,
								get = function(info)
									local db = E.db.mui.blizzard.objectiveTracker.cosmeticBar.color.gradientColor1
									local default = P.blizzard.objectiveTracker.cosmeticBar.color.gradientColor1
									return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
								end,
								set = function(info, r, g, b, a)
									local db = E.db.mui.blizzard.objectiveTracker.cosmeticBar.color.gradientColor1
									db.r, db.g, db.b, db.a = r, g, b, a
									module:ChangeQuestHeaderStyle()
								end
							},
							gradientColor2 = {
								order = 4,
								type = "color",
								name = L["Gradient Color 2"],
								hasAlpha = true,
								hidden = function()
									if E.db.mui.blizzard.objectiveTracker.cosmeticBar.color.mode ~= "GRADIENT" then
										return true
									end
								end,
								get = function(info)
									local db = E.db.mui.blizzard.objectiveTracker.cosmeticBar.color.gradientColor2
									local default = P.blizzard.objectiveTracker.cosmeticBar.color.gradientColor2
									return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
								end,
								set = function(info, r, g, b, a)
									local db = E.db.mui.blizzard.objectiveTracker.cosmeticBar.color.gradientColor2
									db.r, db.g, db.b, db.a = r, g, b, a
									module:ChangeQuestHeaderStyle()
								end
							}
						}
					},
					preset = {
						order = 5,
						type = "group",
						inline = true,
						name = L["Presets"],
						disabled = function()
							return not E.db.mui.blizzard.objectiveTracker.enable or not E.db.mui.blizzard.objectiveTracker.cosmeticBar.enable
						end,
						args = {
							tip = {
								order = 1,
								type = "description",
								name = E.NewSign .. L["Here are some example presets, just try them!"]
							},
							default = {
								order = 2,
								type = "execute",
								name = L["Default"],
								func = function()
									local db = E.db.mui.blizzard.objectiveTracker
									db.header.style = "OUTLINE"
									db.header.color = {r = 1, g = 1, b = 1}
									db.header.size = E.db.general.fontSize + 2
									db.cosmeticBar.texture = "WindTools Glow"
									db.cosmeticBar.widthMode = "ABSOLUTE"
									db.cosmeticBar.heightMode = "ABSOLUTE"
									db.cosmeticBar.width = 212
									db.cosmeticBar.height = 2
									db.cosmeticBar.offsetX = 0
									db.cosmeticBar.offsetY = -13
									db.cosmeticBar.border = "SHADOW"
									db.cosmeticBar.borderAlpha = 1
									db.cosmeticBar.color.mode = "GRADIENT"
									db.cosmeticBar.color.normalColor = {r = 0.000, g = 0.659, b = 1.000, a = 1}
									db.cosmeticBar.color.gradientColor1 = {r = 0.32941, g = 0.52157, b = 0.93333, a = 1}
									db.cosmeticBar.color.gradientColor2 = {r = 0.25882, g = 0.84314, b = 0.86667, a = 1}
									module:ChangeQuestHeaderStyle()
								end
							},
							preset1 = {
								order = 3,
								type = "execute",
								name = format(L["Preset %d"], 1),
								func = function()
									local db = E.db.mui.blizzard.objectiveTracker
									db.header.style = "NONE"
									db.header.color = {r = 1, g = 1, b = 1}
									db.header.size = E.db.general.fontSize
									db.cosmeticBar.texture = "ElvUI Blank"
									db.cosmeticBar.widthMode = "DYNAMIC"
									db.cosmeticBar.heightMode = "DYNAMIC"
									db.cosmeticBar.width = 45
									db.cosmeticBar.height = 16
									db.cosmeticBar.offsetX = -10
									db.cosmeticBar.offsetY = 0
									db.cosmeticBar.border = "NONE"
									db.cosmeticBar.borderAlpha = 1
									db.cosmeticBar.color.mode = "GRADIENT"
									db.cosmeticBar.color.normalColor = {r = 0.000, g = 0.659, b = 1.000, a = 1}
									db.cosmeticBar.color.gradientColor1 = {r = 0.32941, g = 0.52157, b = 0.93333, a = 1}
									db.cosmeticBar.color.gradientColor2 = {r = 0.25882, g = 0.84314, b = 0.86667, a = 0}
									module:ChangeQuestHeaderStyle()
								end
							},
							preset2 = {
								order = 4,
								type = "execute",
								name = format(L["Preset %d"], 2),
								func = function()
									local db = E.db.mui.blizzard.objectiveTracker
									db.header.style = "NONE"
									db.header.size = E.db.general.fontSize - 2
									db.header.color = {r = 1, g = 1, b = 1}
									db.cosmeticBar.texture = "ElvUI Blank"
									db.cosmeticBar.widthMode = "DYNAMIC"
									db.cosmeticBar.heightMode = "DYNAMIC"
									db.cosmeticBar.width = 7
									db.cosmeticBar.height = 12
									db.cosmeticBar.offsetX = -7
									db.cosmeticBar.offsetY = 0
									db.cosmeticBar.border = "ONEPIXEL"
									db.cosmeticBar.borderAlpha = 1
									db.cosmeticBar.color.mode = "GRADIENT"
									db.cosmeticBar.color.normalColor = {r = 0.000, g = 0.659, b = 1.000, a = 1}
									db.cosmeticBar.color.gradientColor1 = {r = 0.32941, g = 0.52157, b = 0.93333, a = 1}
									db.cosmeticBar.color.gradientColor2 = {r = 0.25882, g = 0.84314, b = 0.86667, a = 1}
									module:ChangeQuestHeaderStyle()
								end
							},
							preset3 = {
								order = 5,
								type = "execute",
								name = format(L["Preset %d"], 3),
								func = function()
									local db = E.db.mui.blizzard.objectiveTracker
									db.header.style = "OUTLINE"
									db.header.color = {r = 1, g = 1, b = 1}
									db.header.size = E.db.general.fontSize + 2
									db.cosmeticBar.texture = "Solid"
									db.cosmeticBar.widthMode = "DYNAMIC"
									db.cosmeticBar.heightMode = "ABSOLUTE"
									db.cosmeticBar.width = 30
									db.cosmeticBar.height = 10
									db.cosmeticBar.offsetX = -2
									db.cosmeticBar.offsetY = -7
									db.cosmeticBar.border = "NONE"
									db.cosmeticBar.borderAlpha = 1
									db.cosmeticBar.color.mode = "NORMAL"
									db.cosmeticBar.color.normalColor = {r = 0.681, g = 0.681, b = 0.681, a = 0.681}
									db.cosmeticBar.color.gradientColor1 = {r = 0.32941, g = 0.52157, b = 0.93333, a = 1}
									db.cosmeticBar.color.gradientColor2 = {r = 0.25882, g = 0.84314, b = 0.86667, a = 1}
									module:ChangeQuestHeaderStyle()
								end
							},
							preset4 = {
								order = 6,
								type = "execute",
								name = format(L["Preset %d"], 4),
								func = function()
									local db = E.db.mui.blizzard.objectiveTracker
									db.header.style = "OUTLINE"
									db.header.color = {r = 1, g = 1, b = 1}
									db.header.size = E.db.general.fontSize + 3
									db.cosmeticBar.texture = "Solid"
									db.cosmeticBar.widthMode = "ABSOLUTE"
									db.cosmeticBar.heightMode = "ABSOLUTE"
									db.cosmeticBar.width = 260
									db.cosmeticBar.height = 24
									db.cosmeticBar.offsetX = -7
									db.cosmeticBar.offsetY = 0
									db.cosmeticBar.border = "ONEPIXEL"
									db.cosmeticBar.borderAlpha = 1
									db.cosmeticBar.color.mode = "GRADIENT"
									db.cosmeticBar.color.normalColor = {r = 0.681, g = 0.681, b = 0.681, a = 0.681}
									db.cosmeticBar.color.gradientColor1 = {r = 0.32941, g = 0.52157, b = 0.93333, a = 1}
									db.cosmeticBar.color.gradientColor2 = {r = 0.25882, g = 0.84314, b = 0.86667, a = 1}
									module:ChangeQuestHeaderStyle()
								end
							},
						},
					},
				},
			},
			header = {
				order = 6,
				type = "group",
				inline = true,
				name = L["Header"],
				disabled = function()
					return not E.db.mui.blizzard.objectiveTracker.enable
				end,
				get = function(info)
					return E.db.mui.blizzard.objectiveTracker[info[#info - 1]][info[#info]]
				end,
				set = function(info, value)
					E.db.mui.blizzard.objectiveTracker[info[#info - 1]][info[#info]] = value
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
						}
					},
					size = {
						order = 3,
						name = L["Size"],
						type = "range",
						min = 5,
						max = 60,
						step = 1
					},
					shortHeader = {
						order = 4,
						type = "toggle",
						name = L["Short Header"],
						desc = L["Use short name instead. e.g. Torghast, Tower of the Damned to Torghast."]
					},
					color = {
						order = 5,
						type = "color",
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local db = E.db.mui.blizzard.objectiveTracker.header.color
							local default = P.blizzard.objectiveTracker.header.color
							return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
						end,
						set = function(info, r, g, b)
							local db = E.db.mui.blizzard.objectiveTracker.header.color
							db.r, db.g, db.b = r, g, b
							module:ChangeQuestHeaderStyle()
						end
					},
				},
			},
			titleColor = {
				order = 7,
				type = "group",
				inline = true,
				name = L["Title Color"],
				disabled = function()
					return not E.db.mui.blizzard.objectiveTracker.enable
				end,
				get = function(info)
					return E.db.mui.blizzard.objectiveTracker.titleColor[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.blizzard.objectiveTracker.titleColor[info[#info]] = value
					E:StaticPopup_Show("PRIVATE_RL")
				end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Change the color of quest titles."]
					},
					classColor = {
						order = 2,
						type = "toggle",
						name = L["Use Class Color"]
					},
					customColorNormal = {
						order = 3,
						type = "color",
						name = L["Normal Color"],
						hasAlpha = false,
						get = function(info)
							local db = E.db.mui.blizzard.objectiveTracker.titleColor.customColorNormal
							local default = P.blizzard.objectiveTracker.titleColor.customColorNormal
							return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
						end,
						set = function(info, r, g, b)
							local db = E.db.mui.blizzard.objectiveTracker.titleColor.customColorNormal
							db.r, db.g, db.b = r, g, b
						end
					},
					customColorHighlight = {
						order = 4,
						type = "color",
						name = L["Highlight Color"],
						hasAlpha = false,
						get = function(info)
							local db = E.db.mui.blizzard.objectiveTracker.titleColor.customColorHighlight
							local default = P.blizzard.objectiveTracker.titleColor.customColorHighlight
							return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
						end,
						set = function(info, r, g, b)
							local db = E.db.mui.blizzard.objectiveTracker.titleColor.customColorHighlight
							db.r, db.g, db.b = r, g, b
						end
					},
				},
			},
			title = {
				order = 8,
				type = "group",
				inline = true,
				name = L["Title"],
				disabled = function()
					return not E.db.mui.blizzard.objectiveTracker.enable
				end,
				get = function(info)
					return E.db.mui.blizzard.objectiveTracker[info[#info - 1]][info[#info]]
				end,
				set = function(info, value)
					E.db.mui.blizzard.objectiveTracker[info[#info - 1]][info[#info]] = value
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
						}
					},
					size = {
						order = 3,
						name = L["Size"],
						type = "range",
						min = 5,
						max = 60,
						step = 1
					},
				},
			},
			info = {
				order = 9,
				type = "group",
				inline = true,
				name = L["Information"],
				disabled = function()
					return not E.db.mui.blizzard.objectiveTracker.enable
				end,
				get = function(info)
					return E.db.mui.blizzard.objectiveTracker[info[#info - 1]][info[#info]]
				end,
				set = function(info, value)
					E.db.mui.blizzard.objectiveTracker[info[#info - 1]][info[#info]] = value
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
						}
					},
					size = {
						order = 3,
						name = L["Size"],
						type = "range",
						min = 5,
						max = 60,
						step = 1
					},
				},
			},
		},
	}
end
tinsert(MER.Config, ObjectiveTable)
