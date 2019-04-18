local MER, E, L, V, P, G = unpack(select(2, ...))
local MAB = MER:GetModule("mUIActionbars")

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variables
-- GLOBALS:

local function abTable()
	E.Options.args.mui.args.modules.args.actionbars = {
		order = 10,
		type = "group",
		name = E.NewSign..MAB.modName,
		get = function(info) return E.db.mui.actionbars[ info[#info] ] end,
		set = function(info, value) E.db.mui.actionbars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["ActionBars"]),
			},
			cleanButton = {
				order = 2,
				type = "toggle",
				name = L["Clean Boss Button"],
				disabled = function() return not E.private.actionbar.enable end,
			},
			transparent = {
				order = 3,
				type = "toggle",
				name = L["Transparent Backdrops"],
				desc = L["Applies transparency in all actionbar backdrops and actionbar buttons."],
				disabled = function() return not E.private.actionbar.enable end,
				get = function(info) return E.db.mui.actionbars[ info[#info] ] end,
				set = function(info, value) E.db.mui.actionbars[ info[#info] ] = value; MAB:TransparentBackdrops() end,
			},
			specBar = {
				order = 4,
				type = "group",
				name = MER:cOption(L["Specialisation Bar"]),
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
				},
			},
			equipBar = {
				order = 5,
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
				},
			},
			microBar = {
				order = 6,
				type = "group",
				name = MER:cOption(L["Micro Bar"]),
				guiInline = true,
				get = function(info) return E.db.mui.microBar[ info[#info] ] end,
				set = function(info, value) E.db.mui.microBar[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL");end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						disabled = function() return not E.private.actionbar.enable end,
						width = "full",
					},
					scale = {
						order = 2,
						type = "range",
						name = L["Scale"],
						isPercent = true,
						min = 0.5, max = 1.0, step = 0.01,
						disabled = function() return not E.db.mui.microBar.enable end,
					},
					hideInCombat = {
						order = 3,
						type = "toggle",
						name = L["Hide In Combat"],
						disabled = function() return not E.db.mui.microBar.enable end,
					},
					hideInOrderHall = {
						order = 4,
						type = "toggle",
						name = L["Hide In Orderhall"],
						disabled = function() return not E.db.mui.microBar.enable end,
					},
					tooltip = {
						order = 5,
						type = "toggle",
						name = L["Tooltip"],
						disabled = function() return not E.db.mui.microBar.enable end,
					},
					text = {
						order = 6,
						type = "group",
						name = MER:cOption(L["Text"]),
						guiInline = true,
						disabled = function() return not E.db.mui.microBar.enable end,
						args = {
							friends = {
								order = 1,
								type = "toggle",
								name = FRIENDS,
								desc = L["Show/Hide the friend text on MicroBar."],
								get = function(info) return E.db.mui.microBar.text.friends end,
								set = function(info, value) E.db.mui.microBar.text.friends = value; E:StaticPopup_Show("PRIVATE_RL"); end,
							},
							guild = {
								order = 2,
								type = "toggle",
								name = GUILD,
								desc = L["Show/Hide the guild text on MicroBar."],
								get = function(info) return E.db.mui.microBar.text.guild end,
								set = function(info, value) E.db.mui.microBar.text.guild = value; E:StaticPopup_Show("PRIVATE_RL"); end,
							},
							position = {
								order = 3,
								type = "select",
								name = L["Position"],
								values = {
									["TOP"] = L["Top"],
									["BOTTOM"] = L["Bottom"],
								},
								get = function(info) return E.db.mui.microBar.text.position end,
								set = function(info, value) E.db.mui.microBar.text.position = value; E:StaticPopup_Show("PRIVATE_RL"); end,
							},
						},
					},
				},
			},
			autoButtons = {
				order = 7,
				type = "group",
				name = E.NewSign..MER:cOption(L["Auto Buttons"]),
				guiInline = true,
				get = function(info)
					return E.db.mui.actionbars.autoButtons[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.actionbars.autoButtons[info[#info]] = value
					E:StaticPopup_Show("PRIVATE_RL")
				end,
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
						hidden = function()
							return not E.db.mui.actionbars.autoButtons.enable
						end,
						get = function(info)
							return E.db.mui.actionbars.autoButtons[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.actionbars.autoButtons[info[#info]] = value
							MER:GetModule("AutoButtons"):UpdateAutoButton()
						end,
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
							soltAutoButtons = {
								order = 3,
								type = "group",
								guiInline = true,
								name = L["Trinket Buttons"],
								get = function(info)
									return E.db.mui.actionbars.autoButtons.soltAutoButtons[info[#info]]
								end,
								set = function(info, value)
									E.db.mui.actionbars.autoButtons.soltAutoButtons[info[#info]] = value
									MER:GetModule("AutoButtons"):UpdateAutoButton()
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
									},
									slotBBColorByItem = {
										order = 2,
										type = "toggle",
										name = L["Color by Quality"],
										hidden = function()
											return not E.db.mui.actionbars.autoButtons.soltAutoButtons.enable
										end,
									},
									slotBBColor = {
										order = 3,
										type = "color",
										name = COLOR,
										hidden = function()
											return not E.db.mui.actionbars.autoButtons.soltAutoButtons.enable
										end,
										disabled = function()
											return E.db.mui.actionbars.autoButtons.soltAutoButtons.slotBBColorByItem
										end,
										get = function(info)
											local t = E.db.mui.actionbars.autoButtons.soltAutoButtons[info[#info]]
											local d = P.mui.actionbars.autoButtons.soltAutoButtons[info[#info]]
											return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
										end,
										set = function(info, r, g, b, a)
											E.db.mui.actionbars.autoButtons.soltAutoButtons[info[#info]] = {}
											local t = E.db.mui.actionbars.autoButtons.soltAutoButtons[info[#info]]
											t.r, t.g, t.b, t.a = r, g, b, a
											MER:GetModule("AutoButtons"):UpdateAutoButton()
										end,
									},
									spacer1 = {
										order = 4,
										type = "description",
										name = "",
										hidden = function()
											return not E.db.mui.actionbars.autoButtons.soltAutoButtons["enable"]
										end,
									},
									slotNum = {
										order = 5,
										type = "range",
										name = L["Buttons"],
										min = 0, max = 12, step = 1,
										hidden = function()
											return not E.db.mui.actionbars.autoButtons.soltAutoButtons["enable"]
										end,
									},
									slotPerRow = {
										order = 6,
										type = "range",
										name = L["Buttons Per Row"],
										min = 1, max = 12, step = 1,
										hidden = function()
											return not E.db.mui.actionbars.autoButtons.soltAutoButtons["enable"]
										end,
									},
									slotSize = {
										order = 7,
										type = "range",
										name = L["Size"],
										min = 10, max = 100, step = 1,
										hidden = function()
											return not E.db.mui.actionbars.autoButtons.soltAutoButtons["enable"]
										end,
									},
								}
							},
							questAutoButtons = {
								order = 4,
								type = "group",
								guiInline = true,
								name = L["Quest Buttons"],
								get = function(info)
									return E.db.mui.actionbars.autoButtons.questAutoButtons[info[#info]]
								end,
								set = function(info, value)
									E.db.mui.actionbars.autoButtons.questAutoButtons[info[#info]] = value
									MER:GetModule("AutoButtons"):UpdateAutoButton()
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
										set = function(info, value)
											E.db.mui.actionbars.autoButtons.questAutoButtons[info[#info]] = value
										end,
									},
									questBBColorByItem = {
										order = 2,
										type = "toggle",
										name = L["Color by Quality"],
										hidden = function()
											return not E.db.mui.actionbars.autoButtons.questAutoButtons["enable"]
										end,
									},
									questBBColor = {
										order = 3,
										type = "color",
										name = COLOR,
										hidden = function()
											return not E.db.mui.actionbars.autoButtons.questAutoButtons["enable"]
										end,
										disabled = function()
											return E.db.mui.actionbars.autoButtons.questAutoButtons["questBBColorByItem"]
										end,
										get = function(info)
											local t = E.db.mui.actionbars.autoButtons.questAutoButtons[info[#info]]
											local d = P.mui.actionbars.autoButtons.questAutoButtons[info[#info]]
											return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
										end,
										set = function(info, r, g, b, a)
											E.db.mui.actionbars.autoButtons.questAutoButtons[info[#info]] = {}
											local t = E.db.mui.actionbars.autoButtons.questAutoButtons[info[#info]]
											t.r, t.g, t.b, t.a = r, g, b, a
											MER:GetModule("AutoButtons"):UpdateAutoButton()
										end,
									},
									spacer1 = {
										order = 4,
										type = "description",
										name = "",
										hidden = function()
											return not E.db.mui.actionbars.autoButtons.questAutoButtons["enable"]
										end,
									},
									questNum = {
										order = 5,
										type = "range",
										name = L["Buttons"],
										min = 0, max = 12, step = 1,
										hidden = function()
											return not E.db.mui.actionbars.autoButtons.questAutoButtons["enable"]
										end,
									},
									questPerRow = {
										order = 6,
										type = "range",
										name = L["Buttons Per Row"],
										min = 1, max = 12, step = 1,
										hidden = function()
											return not E.db.mui.actionbars.autoButtons.questAutoButtons["enable"]
										end,
									},
									questSize = {
										order = 7,
										type = "range",
										name = L["Size"],
										min = 10, max = 100, step = 1,
										hidden = function()
											return not E.db.mui.actionbars.autoButtons.questAutoButtons["enable"]
										end,
									},
								}
							},
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, abTable)
