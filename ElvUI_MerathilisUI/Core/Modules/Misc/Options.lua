local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule('MER_Misc')
local SA = MER:GetModule('MER_SpellAlert')
local LSM = E.LSM

local tinsert = table.insert

local function Misc()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.misc = {
		type = "group",
		name = L["Miscellaneous"],
		get = function(info) return E.db.mui.misc[ info[#info] ] end,
		set = function(info, value) E.db.mui.misc[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = ACH:Header(F.cOption(L["Miscellaneous"], 'orange'), 1),
			gmotd = {
				order = 2,
				type = "toggle",
				name = L.GUILD_MOTD_LABEL2,
				desc = L["Display the Guild Message of the Day in an extra window, if updated."],
			},
			guildNewsItemLevel = {
				order = 3,
				type = "toggle",
				name = L["Guild News Item Level"],
				get = function(info) return E.private.mui.misc[ info[#info] ] end,
				set = function(info, value) E.private.mui.misc[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			},
			cursor = {
				order = 4,
				type = "toggle",
				name = L["Flashing Cursor"],
			},
			funstuff = {
				order = 5,
				type = "toggle",
				name = L["Fun Stuff"],
			},
			wowheadlinks = {
				order = 6,
				type = "toggle",
				name = L["Wowhead Links"],
				desc = L["Adds Wowhead links to the Achievement- and WorldMap Frame"],
			},
			respec = {
				order = 7,
				type = "toggle",
				name = L["Codex Buttons"],
				desc = L["Adds two buttons on your Talent Frame, with Codex or Tome Items"],
			},
			spellAlert = {
				order = 10,
				type = "range",
				name = L["Spell Alert Scale"],
				min = 0.4, max = 1.5, step = 0.01,
				hidden = not E.Retail,
				get = function(info) return E.db.mui.misc.spellAlert end,
				set = function(info, value) E.db.mui.misc.spellAlert = value; SA:Resize() end,
			},
			lfgInfo = {
				order = 15,
				name = F.cOption(L["LFG Info"], 'orange'),
				type = "group",
				guiInline = true,
				get = function(info)
					return E.db.mui.misc.lfgInfo[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.misc.lfgInfo[info[#info]] = value
				end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Add LFG group info to tooltip."]
					},
					title = {
						order = 2,
						type = "toggle",
						name = L["Add Title"],
						desc = L["Display an additional title."]
					},
					mode = {
						order = 3,
						name = L["Mode"],
						type = "select",
						values = {
							NORMAL = L["Normal"],
							COMPACT = L["Compact"]
						},
					},
					icon = {
						order = 4,
						type = "group",
						name = F.cOption(L["Icon"], 'orange'),
						disabled = function()
							return not E.db.mui.misc.lfgInfo.enable
						end,
						get = function(info)
							return E.db.mui.misc.lfgInfo.icon[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.misc.lfgInfo.icon[info[#info]] = value
							E:StaticPopup_Show("PRIVATE_RL")
						end,
						args = {
							reskin = {
								order = 1,
								type = "toggle",
								name = L["Reskin Icon"],
								desc = L["Change role icons."]
							},
							border = {
								order = 3,
								type = "toggle",
								name = L["Border"]
							},
							size = {
								order = 4,
								type = "range",
								name = L["Size"],
								min = 1,
								max = 20,
								step = 1
							},
							alpha = {
								order = 5,
								type = "range",
								name = L["Alpha"],
								min = 0,
								max = 1,
								step = 0.01
							},
						},
					},
					line = {
						order = 5,
						type = "group",
						name = F.cOption(L["Line"], 'orange'),
						disabled = function()
							return not E.db.mui.misc.lfgInfo.enable
						end,
						get = function(info)
							return E.db.mui.misc.lfgInfo.line[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.misc.lfgInfo.line[info[#info]] = value
							E:StaticPopup_Show("PRIVATE_RL")
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Add a line in class color."]
							},
							tex = {
								order = 2,
								type = "select",
								name = L["Texture"],
								dialogControl = "LSM30_Statusbar",
								values = LSM:HashTable("statusbar")
							},
							width = {
								order = 4,
								type = "range",
								name = L["Width"],
								min = 1,
								max = 20,
								step = 1
							},
							height = {
								order = 4,
								type = "range",
								name = L["Height"],
								min = 1,
								max = 20,
								step = 1
							},
							offsetX = {
								order = 5,
								type = "range",
								name = L["X-Offset"],
								min = -20,
								max = 20,
								step = 1
							},
							offsetY = {
								order = 6,
								type = "range",
								name = L["Y-Offset"],
								min = -20,
								max = 20,
								step = 1
							},
							alpha = {
								order = 7,
								type = "range",
								name = L["Alpha"],
								min = 0,
								max = 1,
								step = 0.01
							},
						},
					},
				},
			},
			alerts = {
				order = 20,
				type = "group",
				name = F.cOption(L["Alerts"], 'orange'),
				guiInline = true,
				get = function(info) return E.db.mui.misc.alerts[ info[#info] ] end,
				set = function(info, value) E.db.mui.misc.alerts[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					lfg = {
						order = 1,
						type = "toggle",
						name = L["Call to Arms"],
					},
					announce = {
						order = 2,
						type = "toggle",
						name = L["Announce"],
						desc = L["Skill gains"],
					},
					itemAlert = {
						order = 3,
						type = "toggle",
						name = L["Item Alerts"],
						desc = L["Announce in chat when someone placed an usefull item."],
					},
					feasts = {
						order = 4,
						type = "toggle",
						name = L["Feasts"],
					},
					portals = {
						order = 5,
						type = "toggle",
						name = L["Portals"],
					},
					toys = {
						order = 6,
						type = "toggle",
						name = L["Toys"],
					},
				},
			},
			quest = {
				order = 21,
				type = "group",
				name = F.cOption(L["Quest"], 'orange'),
				guiInline = true,
				get = function(info) return E.db.mui.misc.quest[ info[#info] ] end,
				set = function(info, value) E.db.mui.misc.quest[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					selectQuestReward = {
						order = 1,
						type = "toggle",
						name = L["Highest Quest Reward"],
						desc = L["Automatically select the item with the highest reward."],
					},
				},
			},
			paragon = {
				order = 22,
				type = "group",
				name = F.cOption(L["MISC_PARAGON_REPUTATION"], 'orange'),
				guiInline = true,
				get = function(info) return E.db.mui.misc.paragon[ info[#info] ] end,
				set = function(info, value) E.db.mui.misc.paragon[ info[#info] ] = value; end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					textStyle = {
						order = 2,
						type = "select",
						name = L["Text Style"],
						disabled = function() return not E.db.mui.misc.paragon.enable end,
						values = {
							["PARAGON"] = L["MISC_PARAGON"],
							["CURRENT"] = L["Current"],
							["VALUE"] = L["Value"],
							["DEFICIT"] = L["Deficit"],
						},
					},
					paragonColor = {
						order = 3,
						name = L["COLOR"],
						type = "color",
						disabled = function() return not E.db.mui.misc.paragon.enable end,
						hasAlpha = false,
						get = function(info)
							local t = E.db.mui.misc.paragon[ info[#info] ]
							local d = P.misc.paragon[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							local t = E.db.mui.misc.paragon[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
						end,
					},
				},
			},
			mawThreatBar = {
				order = 24,
				type = "group",
				name = F.cOption(L["Maw ThreatBar"], 'orange'),
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Replace the Maw Threat Display, with a simple StatusBar"],
						get = function(info) return E.db.mui.misc.mawThreatBar[ info[#info] ] end,
						set = function(info, value) E.db.mui.misc.mawThreatBar[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end
					},
					width = {
						order = 2,
						type = "range",
						name = L["Width"],
						min = 100, max = 400, step = 10,
						get = function(info) return E.db.mui.misc.mawThreatBar[ info[#info] ] end,
						set = function(info, value) E.db.mui.misc.mawThreatBar[ info[#info] ] = value; MI:UpdateMawBarLayout() end,
					},
					height = {
						order = 3,
						type = "range",
						name = L["Height"],
						min = 8, max = 20, step = 1,
						get = function(info) return E.db.mui.misc.mawThreatBar[ info[#info] ] end,
						set = function(info, value) E.db.mui.misc.mawThreatBar[ info[#info] ] = value; MI:UpdateMawBarLayout() end,
					},
					fontGroup = {
						order = 4,
						type = "group",
						name = L["Font"],
						get = function(info) return E.db.mui.misc.mawThreatBar.font[ info[#info] ] end,
						set = function(info, value) E.db.mui.misc.mawThreatBar.font[ info[#info] ] = value; MI:UpdateMawBarLayout() end,
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
			},
			macros = {
				order = 24,
				type = "group",
				name = F.cOption(L["Macros"], 'orange'),
				guiInline = true,
				args = {
					randomtoy = {
						order = 1,
						type = "input",
						name = L["Random Toy"],
						desc = L["Creates a random toy macro."],
						get = function() return "/randomtoy" end,
						set = function() return end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, Misc)
