local MER, E, L, V, P, G = unpack(select(2, ...))
local MAB = MER:GetModule('MER_Actionbars')
local MB = MER:GetModule('MER_MicroBar')

--Cache global variables
--Lua functions
local pairs, select, tonumber, type = pairs, select, tonumber, type
local format = string.format
local tinsert = table.insert
--WoW API / Variables
local GetItemInfo = GetItemInfo
local COLOR = COLOR
-- GLOBALS:

local buttonTypes = {
	["quest"] = "Quest Buttons",
	["slot"] = "Trinket Buttons",
	["usable"] = "Usable Buttons"
}
local function ActionBarTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.actionbars = {
		type = "group",
		name = L["ActionBars"],
		get = function(info) return E.db.mui.actionbars[ info[#info] ] end,
		set = function(info, value) E.db.mui.actionbars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = ACH:Header(MER:cOption(L["ActionBars"]), 1),
			general = {
				order = 2,
				type = "group",
				name = MER:cOption(L["General"]),
				guiInline = true,
				args = {
					customGlow = {
						order = 1,
						type = "toggle",
						name = L["Custom Glow"],
						desc = L["Replaces the default Actionbar glow for procs with an own pixel glow."],
					},
				},
			},
			specBar = {
				order = 3,
				type = "group",
				name = MER:cOption(L["Specialization Bar"]),
				guiInline = true,
				disabled = function() return not E.private.actionbar.enable end,
				get = function(info) return E.db.mui.actionbars.specBar[ info[#info] ] end,
				set = function(info, value) E.db.mui.actionbars.specBar[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						disabled = function() return not E.private.actionbar.enable end,
					},
					mouseover = {
						order = 2,
						type = "toggle",
						name = L["Mouseover"],
						disabled = function() return not E.private.actionbar.enable end,
					},
					size = {
						order = 3,
						type = "range",
						name = L["Button Size"],
						min = 20, max = 60, step = 1,
						disabled = function() return not E.private.actionbar.enable end,
					},
				},
			},
			equipBar = {
				order = 4,
				type = "group",
				name = MER:cOption(L["EquipSet Bar"]),
				guiInline = true,
				disabled = function() return not E.private.actionbar.enable end,
				get = function(info) return E.db.mui.actionbars.equipBar[ info[#info] ] end,
				set = function(info, value) E.db.mui.actionbars.equipBar[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						disabled = function() return not E.private.actionbar.enable end,
					},
					mouseover = {
						order = 2,
						type = "toggle",
						name = L["Mouseover"],
						disabled = function() return not E.private.actionbar.enable end,
					},
					size = {
						order = 3,
						type = "range",
						name = L["Button Size"],
						min = 20, max = 60, step = 1,
						disabled = function() return not E.private.actionbar.enable end,
					},
				},
			},
			microBar = {
				order = 5,
				type = "group",
				name = MER:cOption(L["Micro Bar"]),
				guiInline = true,
				get = function(info) return E.db.mui.microBar[ info[#info] ] end,
				set = function(info, value) E.db.mui.microBar[ info[#info] ] = value; MB:ProfileUpdate(); end,
				args = {
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
							hideInCombat = {
								order = 7,
								type = "toggle",
								name = L["Hide In Combat"],
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
							normal = {
								order = 3,
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
								order = 4,
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
								order = 5,
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
											E.db.mui.microBar.additionalText[#info - 1][info[#info]] = value
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
							visibility = {
								order = 6,
								type = "input",
								name = L["Visibility"],
								set = function(info, value)
									E.db.mui.microBar.enable[info[#info]] = value
									MB:UpdateBar()
								end,
								width = "full"
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
			},
			autoButtons = {
				order = 6,
				type = "group",
				name = MER:cOption(L["Auto Buttons"]),
				guiInline = true,
				get = function(info) return E.db.mui.actionbars.autoButtons[info[#info]] end,
				set = function(info, value) E.db.mui.actionbars.autoButtons[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					general = {
						order = 2,
						type = "group",
						guiInline = true,
						name = L["General"],
						hidden = function() return not E.db.mui.actionbars.autoButtons.enable end,
						get = function(info) return E.db.mui.actionbars.autoButtons[info[#info]] end,
						set = function(info, value) E.db.mui.actionbars.autoButtons[info[#info]] = value; MER:GetModule("MER_AutoButtons"):UpdateAutoButton() end,
						args = {
							bindFontSize = {
								order = 1,
								type = "range",
								min = 4, max = 40, step = 1,
								name = L["Bind Font Size"],
							},
							countFontSize = {
								order = 2,
								type = "range",
								min = 4, max = 40, step = 1,
								name = L["Count Font Size"],
							},
							whiteItemID = {
								order = 6,
								type = "input",
								name = L["Whitelist Item"],
								get = function() return whiteItemID or "" end,
								set = function(info, value) whiteItemID = value; end,
							},
							AddItemID = {
								order = 7,
								type = "execute",
								name = L["Add Item ID"],
								func = function()
									if not tonumber(whiteItemID) then
										MER:Print(L["Must is itemID!"])
										return
									end
									local id = tonumber(whiteItemID)
									if not GetItemInfo(id) then
										MER:Print(whiteItemID .. L["is error itemID"])
										return
									end
									E.db.mui.actionbars.autoButtons.whiteList[id] = true
									E.Options.args.mui.args.modules.args.actionbars.args.autoButtons.args.general.args.whiteList.values[id] = GetItemInfo(id)
									MER:GetModule("MER_AutoButtons"):UpdateAutoButton()
								end,
							},
							DeleteItemID = {
								order = 8,
								type = "execute",
								name = L["Delete Item ID"],
								func = function()
									if not tonumber(whiteItemID) then
										MER:Print(L["Must is itemID!"])
										return
									end
									local id = tonumber(whiteItemID)
									if not GetItemInfo(id) then
										MER:Print(whiteItemID .. L["is error itemID"])
										return
									end
									if E.db.mui.actionbars.autoButtons.whiteList[id] == true or E.db.mui.actionbars.autoButtons.whiteList[id] == false then
										E.db.mui.actionbars.autoButtons.whiteList[id] = nil
										E.Options.args.mui.args.modules.args.actionbars.args.autoButtons.args.general.args.whiteList.values[id] = nil
									end
									MER:GetModule("MER_AutoButtons"):UpdateAutoButton()
								end,
							},
							whiteList = {
								order = 9,
								type = "multiselect",
								name = L["Whitelist"],
								get = function(info, k) return E.db.mui.actionbars.autoButtons.whiteList[k] end,
								set = function(info, k, v) E.db.mui.actionbars.autoButtons.whiteList[k] = v; MER:GetModule("MER_AutoButtons"):UpdateAutoButton() end,
								values = {}
							},
							blackitemID = {
								order = 10,
								type = "input",
								name = L["Blacklist Item"],
								get = function()
									return blackItemID or ""
								end,
								set = function(info, value)
									blackItemID = value
								end,
							},
							AddblackItemID = {
								order = 11,
								type = "execute",
								name = L["Add Item ID"],
								func = function()
									if not tonumber(blackItemID) then
										MER:Print(L["Must is itemID!"])
										return
									end
									local id = tonumber(blackItemID)
									if not GetItemInfo(id) then
										MER:Print(blackItemID .. L["is error itemID"])
										return
									end
									E.db.mui.actionbars.autoButtons.blackList[id] = true
									E.Options.args.mui.args.modules.args.actionbars.args.autoButtons.args.general.args.blackList.values[id] = GetItemInfo(id)
									MER:GetModule("MER_AutoButtons"):UpdateAutoButton()
								end,
							},
							DeleteblackItemID = {
								order = 12,
								type = "execute",
								name = L["Delete Item ID"],
								func = function()
									if not tonumber(blackItemID) then
										MER:Print(L["Must is itemID!"])
										return
									end
									local id = tonumber(blackItemID)
									if not GetItemInfo(id) then
										MER:Print(blackItemID .. L["is error itemID"])
										return
									end
									if E.db.mui.actionbars.autoButtons.blackList[id] == true or E.db.mui.actionbars.autoButtons.blackList[id] == false then
										E.db.mui.actionbars.autoButtons.blackList[id] = nil
										E.Options.args.mui.args.modules.args.actionbars.args.autoButtons.args.general.args.blackList.values[id] = nil
									end
									MER:GetModule("MER_AutoButtons"):UpdateAutoButton()
								end,
							},
							blackList = {
								order = 13,
								type = "multiselect",
								name = L["Blacklist"],
								get = function(info, k) return E.db.mui.actionbars.autoButtons.blackList[k] end,
								set = function(info, k, v) E.db.lui.modules.actionbars.autoButtons.blackList[k] = v; MER:GetModule("MER_AutoButtons"):UpdateAutoButton() end,
								values = {}
							},
						},
					},
				},
			},
		},
	}

	local index = 3
	for btype, name in pairs(buttonTypes) do
		E.Options.args.mui.args.modules.args.actionbars.args.autoButtons.args.general.args[btype.."AutoButtons"] = {
			order = index,
			type = "group",
			guiInline = true,
			name = L[name],
			get = function(info) return E.db.mui.actionbars.autoButtons[btype.."AutoButtons"][info[#info]] end,
			set = function(info, value) E.db.mui.actionbars.autoButtons[btype.."AutoButtons"][info[#info]] = value; MER:GetModule("MER_AutoButtons"):UpdateAutoButton() end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				[btype.."BBColorByItem"] = {
					order = 2,
					type = "toggle",
					name = L["Color by Quality"],
					hidden = function() return not E.db.mui.actionbars.autoButtons[btype.."AutoButtons"].enable end,
				},
				[btype.."BBColor"] = {
					order = 3,
					type = "color",
					name = COLOR,
					hidden = function() return not E.db.mui.actionbars.autoButtons[btype.."AutoButtons"].enable end,
					disabled = function() return E.db.mui.actionbars.autoButtons[btype.."AutoButtons"][btype.."BBColorByItem"] end,
					get = function(info)
						local t = E.db.mui.actionbars.autoButtons[btype.."AutoButtons"][info[#info]]
						local d = P.mui.actionbars.autoButtons[btype.."AutoButtons"][info[#info]]
						return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
					end,
					set = function(info, r, g, b, a)
						E.db.mui.actionbars.autoButtons[btype.."AutoButtons"][info[#info]] = {}
						local t = E.db.mui.actionbars.autoButtons[btype.."AutoButtons"][info[#info]]
						t.r, t.g, t.b, t.a = r, g, b, a
						MER:GetModule("MER_AutoButtons"):UpdateAutoButton()
					end,
				},
				[btype.."Space"] = {
					order = 4,
					type = "range",
					name = L["Button Spacing"],
					min = -1, max = 10, step = 1,
					hidden = function() return not E.db.mui.actionbars.autoButtons[btype.."AutoButtons"].enable end,
				},
				[btype.."Direction"] = {
					order = 5,
					type = "select",
					name = L["Anchor Point"],
					values = {
						["RIGHT"] = L["Right"],
						["LEFT"] = L["Left"],
					},
					hidden = function() return not E.db.mui.actionbars.autoButtons[btype.."AutoButtons"].enable end,
				},
				[btype.."Num"] = {
					order = 6,
					type = "range",
					name = L["Buttons"],
					min = 0, max = 12, step = 1,
					hidden = function() return not E.db.mui.actionbars.autoButtons[btype.."AutoButtons"].enable end,
				},
				[btype.."PerRow"] = {
					order = 7,
					type = "range",
					name = L["Buttons Per Row"],
					min = 1, max = 12, step = 1,
					hidden = function() return not E.db.mui.actionbars.autoButtons[btype.."AutoButtons"].enable end,
				},
				[btype.."Size"] = {
					order = 8,
					type = "range",
					name = L["Size"],
					min = 10, max = 100, step = 1,
					hidden = function() return not E.db.mui.actionbars.autoButtons[btype.."AutoButtons"].enable end,
				},
				inheritGlobalFade = {
					order = 9,
					type = 'toggle',
					name = L["Inherit Global Fade"],
					desc = L["Inherit the global fade, mousing over, targetting, setting focus, losing health, entering combat will set the remove transparency. Otherwise it will use the transparency level in the general actionbar settings for global fade alpha."],
				},
			}
		}
		index = index + 1
	end

	local texString = '|T%s:18:18:0:0:64:64:4:60:4:60|t %s'

	for k, v in pairs(E.db.mui.actionbars.autoButtons.whiteList) do
		if type(k) == "string" then k = tonumber(k) end
		local name, _, _, _, _, _, _, _, _, tex = GetItemInfo(k)
		if name then
			E.Options.args.mui.args.modules.args.actionbars.args.autoButtons.args.general.args.whiteList.values[k] = format(texString, tex, name)
		end
	end

	for k, v in pairs(E.db.mui.actionbars.autoButtons.blackList) do
		if type(k) == "string" then k = tonumber(k) end
		local name, _, _, _, _, _, _, _, _, tex = GetItemInfo(k)
		if name then
			E.Options.args.mui.args.modules.args.actionbars.args.autoButtons.args.general.args.blackList.values[k] = format(texString, tex, name)
		end
	end


	local availableButtons = MB:GetAvailableButtons()
	for i = 1, 7 do
		E.Options.args.mui.args.modules.args.actionbars.args.microBar.args.leftButtons.args[tostring(i)] = {
			order = i,
			type = "select",
			name = format(L["Button #%d"], i),
			values = availableButtons
		}

		E.Options.args.mui.args.modules.args.actionbars.args.microBar.args.rightButtons.args[tostring(i)] = {
			order = i,
			type = "select",
			name = format(L["Button #%d"], i),
			values = availableButtons
		}
	end

	E.Options.args.mui.args.modules.args.actionbars.args.microBar.args.home.args.left = {
		order = 1,
		type = "select",
		name = L["Left Button"],
		values = function()
			return MB:GetHearthStoneTable()
		end
	}

	E.Options.args.mui.args.modules.args.actionbars.args.microBar.args.home.args.right = {
		order = 2,
		type = "select",
		name = L["Right Button"],
		values = function()
			return MB:GetHearthStoneTable()
		end
	}
end
tinsert(MER.Config, ActionBarTable)
