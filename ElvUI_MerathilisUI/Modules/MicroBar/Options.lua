local MER, E, L, V, P, G = unpack(select(2, ...))
local MB = MER:GetModule('MER_MicroBar')

local format = string.format
local tonumber, tostring = tonumber, tostring
local tinsert = table.insert

local function MicroBarTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.microBar = {
		type = "group",
		name = E.NewSign..L["Micro Bar"],
		get = function(info) return E.db.mui.microBar[ info[#info] ] end,
		set = function(info, value) E.db.mui.microBar[ info[#info] ] = value; MB:ProfileUpdate(); end,
		args = {
			name = ACH:Header(MER:cOption(L["Micro Bar"]), 1),
			enable = {
				order = 2,
				type = "toggle",
				name = L["Enable"],
			},
			general = {
				order = 10,
				type = "group",
				name = L["General"],
				disabled = function()
					return not E.db.mui.microBar.enable
				end,
				get = function(info)
					return E.db.mui.microBar[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.microBar[info[#info]] = value
					MB:UpdateButtons()
					MB:UpdateLayout()
				end,
				args = {
					backdrop = {
						order = 1,
						type = "toggle",
						name = L["Backdrop"],
					},
					backdropSpacing = {
						order = 2,
						type = "range",
						name = L["Backdrop Spacing"],
						desc = L["The spacing between the backdrop and the buttons."],
						min = 1,
						max = 30,
						step = 1
					},
					timeAreaWidth = {
						order = 3,
						type = "range",
						name = L["Time Width"],
						min = 1,
						max = 200,
						step = 1
					},
					timeAreaHeight = {
						order = 4,
						type = "range",
						name = L["Time Height"],
						min = 1,
						max = 100,
						step = 1
					},
					spacing = {
						order = 5,
						type = "range",
						name = L["Button Spacing"],
						desc = L["The spacing between buttons."],
						min = 1,
						max = 30,
						step = 1
					},
					buttonSize = {
						order = 6,
						type = "range",
						name = L["Button Size"],
						desc = L["The size of the buttons."],
						min = 2,
						max = 80,
						step = 1
					},
				},
			},
			display = {
				order = 11,
				type = "group",
				name = L["Display"],
				disabled = function()
					return not E.db.mui.microBar.enable
				end,
				get = function(info)
					return E.db.mui.microBar[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.microBar[info[#info]] = value
					MB:UpdateButtons()
					MB:UpdateTimeFormat()
					MB:UpdateTime()
				end,
				args = {
					bar = {
						order = 1,
						type = "group",
						name = L["Bar"],
						inline = true,
						args = {
							mouseOver = {
								order = 1,
								type = "toggle",
								name = L["Mouse Over"],
								set = function(info, value)
									E.db.mui.microBar[info[#info]] = value
									MB:UpdateBar()
								end
							},
							fadeTime = {
								order = 2,
								type = "range",
								name = L["Fade Time"],
								min = 0,
								max = 3,
								step = 0.01
							},
							tooltipPosition = {
								order = 3,
								type = "select",
								name = L["Tooltip Position"],
								values = {
									ANCHOR_TOP = L["TOP"],
									ANCHOR_BOTTOM = L["BOTTOM"]
								},
								set = function(info, value)
									E.db.mui.microBar[info[#info]] = value
									--E:StaticPopup_Show("PRIVATE_RL");
								end
							},
							visibility = {
								order = 4,
								type = "input",
								name = L["Visibility"],
								set = function(info, value)
									E.db.mui.microBar[info[#info]] = value
									MB:UpdateBar()
								end,
								width = "full"
							},
						},
					},
					normal = {
						order = 4,
						type = "group",
						name = L["Color"] .. " - " .. L["Normal"],
						inline = true,
						args = {
							normalColor = {
								order = 1,
								type = "select",
								name = L["Mode"],
								values = {
									NONE = L["None"],
									CLASS = L["Class Color"],
									VALUE = L["Value Color"],
									CUSTOM = L["Custom"]
								}
							},
							customNormalColor = {
								order = 2,
								type = "color",
								name = L["Custom Color"],
								hidden = function()
									return E.db.mui.microBar.normalColor ~= "CUSTOM"
								end,
								get = function(info)
									local db = E.db.mui.microBar[info[#info]]
									local default = P.mui.microBar[info[#info]]
									return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
								end,
								set = function(info, r, g, b, a)
									local db = E.db.mui.microBar[info[#info]]
									db.r, db.g, db.b, db.a = r, g, b, a
									MB:UpdateButtons()
								end
							}
						}
					},
					hover = {
						order = 5,
						type = "group",
						name = L["Color"] .. " - " .. L["Hover"],
						inline = true,
						args = {
							hoverColor = {
								order = 1,
								type = "select",
								name = L["Mode"],
								values = {
									NONE = L["None"],
									CLASS = L["Class Color"],
									VALUE = L["Value Color"],
									CUSTOM = L["Custom"]
								}
							},
							customHoverColor = {
								order = 2,
								type = "color",
								name = L["Custom Color"],
								hidden = function()
									return E.db.mui.microBar.hoverColor ~= "CUSTOM"
								end,
								get = function(info)
									local db = E.db.mui.microBar[info[#info]]
									local default = P.mui.microBar[info[#info]]
									return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
								end,
								set = function(info, r, g, b, a)
									local db = E.db.mui.microBar[info[#info]]
									db.r, db.g, db.b, db.a = r, g, b, a
									MB:UpdateButtons()
								end
							}
						}
					},
					additionalText = {
						order = 6,
						type = "group",
						name = L["Additional Text"],
						inline = true,
						get = function(info)
							return E.db.mui.microBar.additionalText[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.microBar.additionalText[info[#info]] = value
							MB:UpdateButtons()
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"]
							},
							anchor = {
								order = 2,
								type = "select",
								name = L["Anchor Point"],
								values = {
									TOP = L["TOP"],
									BOTTOM = L["BOTTOM"],
									LEFT = L["LEFT"],
									RIGHT = L["RIGHT"],
									CENTER = L["CENTER"],
									TOPLEFT = L["TOPLEFT"],
									TOPRIGHT = L["TOPRIGHT"],
									BOTTOMLEFT = L["BOTTOMLEFT"],
									BOTTOMRIGHT = L["BOTTOMRIGHT"]
								}
							},
							x = {
								order = 3,
								type = "range",
								name = L["X-Offset"],
								min = -100,
								max = 100,
								step = 1
							},
							y = {
								order = 4,
								type = "range",
								name = L["Y-Offset"],
								min = -100,
								max = 100,
								step = 1
							},
							slowMode = {
								order = 5,
								type = "toggle",
								name = L["Slow Mode"],
								desc = L["Update the additional text every 10 seconds rather than every 1 second such that the used memory will be lower."]
							},
							font = {
								order = 6,
								type = "group",
								name = L["Font"],
								inline = true,
								get = function(info)
									return E.db.mui.microBar.additionalText[info[#info - 1]][info[#info]]
								end,
								set = function(info, value)
									E.db.mui.microBar.additionalText[info[#info - 1]][info[#info]] = value
									MB:UpdateButtons()
								end,
								args = {
									name = {
										order = 1,
										type = "select",
										dialogControl = "LSM30_Font",
										name = L["Font"],
										values = E.LSM:HashTable("font"),
									},
									size = {
										order = 3,
										name = L["Size"],
										type = "range",
										min = 5, max = 60, step = 1
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
								},
							},
						},
					},
				},
			},
			time = {
				order = 12,
				type = "group",
				name = L["Time"],
				disabled = function()
					return not E.db.mui.microBar.enable
				end,
				get = function(info)
					return E.db.mui.microBar.time[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.microBar.time[info[#info]] = value
					MB:UpdateTimeArea()
					MB:UpdateLayout()
				end,
				args = {
					localTime = {
						order = 2,
						type = "toggle",
						name = L["Local Time"]
					},
					twentyFour = {
						order = 3,
						type = "toggle",
						name = L["24 Hours"]
					},
					flash = {
						order = 4,
						type = "toggle",
						name = L["Flash"]
					},
					interval = {
						order = 5,
						type = "range",
						name = L["Interval"],
						desc = L["The interval of updating."],
						set = function(info, value)
							E.db.mui.microBar.time[info[#info]] = value
							MB:UpdateTimeTicker()
						end,
						min = 1,
						max = 60,
						step = 1
					},
					font = {
						order = 6,
						type = "group",
						name = L["Font"],
						inline = true,
						get = function(info)
							return E.db.mui.microBar.time[info[#info - 1]][info[#info]]
						end,
						set = function(info, value)
							E.db.mui.microBar.time[info[#info - 1]][info[#info]] = value
							MB:UpdateTimeFormat()
							MB:UpdateTimeArea()
						end,
						args = {
							name = {
								order = 1,
								type = "select",
								dialogControl = "LSM30_Font",
								name = L["Font"],
								values = E.LSM:HashTable("font")
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
			},
			home = {
				order = 13,
				type = "group",
				name = L["Home"],
				disabled = function()
					return not E.db.mui.microBar.enable
				end,
				get = function(info)
					return E.db.mui.microBar.home[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.microBar.home[info[#info]] = value
					MB:UpdateHomeButton()
					MB:UpdateButtons()
				end,
				args = {}
			},
			leftButtons = {
				order = 14,
				type = "group",
				name = L["Left Panel"],
				disabled = function()
					return not E.db.mui.microBar.enable
				end,
				get = function(info)
					return E.db.mui.microBar.left[tonumber(info[#info])]
				end,
				set = function(info, value)
					E.db.mui.microBar.left[tonumber(info[#info])] = value
					MB:UpdateButtons()
					MB:UpdateLayout()
				end,
				args = {}
			},
			rightButtons = {
				order = 16,
				type = "group",
				name = L["Right Panel"],
				disabled = function()
					return not E.db.mui.microBar.enable
				end,
				get = function(info)
					return E.db.mui.microBar.right[tonumber(info[#info])]
				end,
				set = function(info, value)
					E.db.mui.microBar.right[tonumber(info[#info])] = value
					MB:UpdateButtons()
				end,
				args = {}
			},
		},
	}

	local availableButtons = MB:GetAvailableButtons()
	for i = 1, 7 do
		E.Options.args.mui.args.modules.args.microBar.args.leftButtons.args[tostring(i)] = {
			order = i,
			type = "select",
			name = format(L["Button #%d"], i),
			values = availableButtons
		}

		E.Options.args.mui.args.modules.args.microBar.args.rightButtons.args[tostring(i)] = {
			order = i,
			type = "select",
			name = format(L["Button #%d"], i),
			values = availableButtons
		}
	end

	E.Options.args.mui.args.modules.args.microBar.args.home.args.left = {
		order = 1,
		type = "select",
		name = L["Left Button"],
		values = function()
			return MB:GetHearthStoneTable()
		end
	}

	E.Options.args.mui.args.modules.args.microBar.args.home.args.right = {
		order = 2,
		type = "select",
		name = L["Right Button"],
		values = function()
			return MB:GetHearthStoneTable()
		end
	}
end
tinsert(MER.Config, MicroBarTable)
