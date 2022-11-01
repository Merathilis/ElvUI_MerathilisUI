local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule('MER_Misc')
local SA = MER:GetModule('MER_SpellAlert')
local IL = MER:GetModule('MER_ItemLevel')
local CU = MER:GetModule('MER_Cursor')
local options = MER.options.modules.args
local LSM = E.LSM

local C_CVar_GetCVar = C_CVar.GetCVar
local C_CVar_GetCVarBool = C_CVar.GetCVarBool
local C_CVar_SetCVar = C_CVar.SetCVar

options.misc = {
	type = "group",
	name = L["Miscellaneous"],
	get = function(info) return E.db.mui.misc[info[#info]] end,
	set = function(info, value) E.db.mui.misc[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Miscellaneous"], 'orange'),
		},
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
			desc = L["Add Item level Infos in Guild News"],
			get = function(info) return E.private.mui.misc[info[#info]] end,
			set = function(info, value) E.private.mui.misc[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		},
		funstuff = {
			order = 4,
			type = "toggle",
			name = L["Fun Stuff"],
			desc = L["Change the NPC Talk Frame."],
		},
		wowheadlinks = {
			order = 5,
			type = "toggle",
			name = L["Wowhead Links"],
			desc = L["Adds Wowhead links to the Achievement- and WorldMap Frame"],
		},
		hideBossBanner = {
			order = 6,
			type = "toggle",
			name = L["Hide Boss Banner"],
			desc = L["This will hide the popup, that shows loot, after you kill a boss"],
		},
		quickDelete = {
			order = 7,
			type = "toggle",
			name = L["Quick Delete"],
			desc = L["This will add the 'DELETE' text to the Item Delete Dialog."],
		},
		quickMenu = {
			order = 8,
			type = "toggle",
			name = L["Quick Menu"],
			desc = L["Shows additional Buttons on your Dropdown for quick actions."],
		},

		spellAlert = {
			order = 10,
			type = "group",
			name = F.cOption(L["Spell Alert Scale"], 'orange'),
			guiInline = true,
			hidden = not E.Retail,
			get = function(info) return E.db.mui.misc.spellAlert[info[#info]] end,
			set = function(info, value) E.db.mui.misc.spellAlert[info[#info]] = value; SA:Update() end,
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
							name = L["Spell activation alert frame customizations."],
							fontSize = "medium"
						}
					}
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"]
				},
				visability = {
					order = 3,
					type = "toggle",
					name = L["Visablity"],
					desc = L["Enable/Disable the spell activation alert frame."],
					get = function(info)
						return C_CVar_GetCVarBool("displaySpellActivationOverlays")
					end,
					set = function(info, value)
						C_CVar_SetCVar("displaySpellActivationOverlays", value and "1" or "0")
					end,
					disabled = function()
						return not E.db.mui.misc.spellAlert.enable
					end,
				},
				opacity = {
					order = 4,
					type = "range",
					name = L["Opacity"],
					desc = L["Set the opacity of the spell activation alert frame. (Blizzard CVar)"],
					get = function(info)
						return tonumber(C_CVar_GetCVar("spellActivationOverlayOpacity"))
					end,
					set = function(info, value)
						C_CVar_SetCVar("spellActivationOverlayOpacity", value)
						SA:Update()
						SA:Preview()
					end,
					min = 0, max = 1, step = 0.01,
					disabled = function()
						return not E.db.mui.misc.spellAlert.enable
					end,
				},
				scale = {
					order = 5,
					type = "range",
					name = L["Scale"],
					desc = L["Set the scale of the spell activation alert frame."],
					min = 0.1, max = 5, step = 0.01,
					disabled = function()
						return not E.db.mui.misc.spellAlert.enable
					end,
					set = function(info, value)
						E.db.mui.misc.spellAlert[info[#info]] = value
						SA:Update()
						SA:Preview()
					end,
					disabled = function()
						return not E.db.mui.misc.spellAlert.enable
					end,
				},
			},
		},
		cursor = {
			order = 11,
			type = "group",
			name = F.cOption(L["Flashing Cursor"], 'orange'),
			guiInline = true,
			get = function(info) return E.db.mui.misc.cursor[info[#info]] end,
			set = function(info, value) E.db.mui.misc.cursor[info[#info]] = value; CU:UpdateColor(); end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				colorType = {
					order = 2,
					name = L["Color Type"],
					type = "select",
					disabled = function() return not E.db.mui.misc.cursor.enable end,
					set = function(info, value) E.db.mui.misc.cursor[info[#info]] = value; end,
					values = {
						["DEFAULT"] = L["Default"],
						["CLASS"] = L["Class"],
						["CUSTOM"] = L["Custom"],
					},
				},
				customColor = {
					type = "color",
					order = 3,
					name = L["Custom Color"],
					disabled = function() return not E.db.mui.misc.cursor.enable or E.db.mui.misc.cursor.colorType ~= "CUSTOM" end,
					get = function(info)
						local t = E.db.mui.misc.cursor[info[#info]]
						local d = P.misc.cursor[info[#info]]
						return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
					end,
					set = function(info, r, g, b)
						E.db.mui.misc.cursor[info[#info]] = {}
						local t = E.db.mui.misc.cursor[info[#info]]
						t.r, t.g, t.b = r, g, b
					end,
				},
			},
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
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			hidden = not E.Retail,
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
			get = function(info) return E.db.mui.misc.alerts[info[#info]] end,
			set = function(info, value) E.db.mui.misc.alerts[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
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
			get = function(info) return E.db.mui.misc.quest[info[#info]] end,
			set = function(info, value) E.db.mui.misc.quest[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			args = {
				selectQuestReward = {
					order = 1,
					type = "toggle",
					name = L["Highest Quest Reward"],
					desc = L["Automatically select the item with the highest reward."],
				},
			},
		},
		mawThreatBar = {
			order = 24,
			type = "group",
			name = F.cOption(L["Maw ThreatBar"], 'orange'),
			guiInline = true,
			hidden = not E.Retail,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Replace the Maw Threat Display, with a simple StatusBar"],
					get = function(info) return E.db.mui.misc.mawThreatBar[info[#info]] end,
					set = function(info, value) E.db.mui.misc.mawThreatBar[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end
				},
				width = {
					order = 2,
					type = "range",
					name = L["Width"],
					min = 100, max = 400, step = 10,
					get = function(info) return E.db.mui.misc.mawThreatBar[info[#info]] end,
					set = function(info, value) E.db.mui.misc.mawThreatBar[info[#info]] = value; MI:UpdateMawBarLayout() end,
				},
				height = {
					order = 3,
					type = "range",
					name = L["Height"],
					min = 8, max = 20, step = 1,
					get = function(info) return E.db.mui.misc.mawThreatBar[info[#info]] end,
					set = function(info, value) E.db.mui.misc.mawThreatBar[info[#info]] = value; MI:UpdateMawBarLayout() end,
				},
				fontGroup = {
					order = 4,
					type = "group",
					name = L["Font"],
					get = function(info) return E.db.mui.misc.mawThreatBar.font[info[#info]] end,
					set = function(info, value) E.db.mui.misc.mawThreatBar.font[info[#info]] = value; MI:UpdateMawBarLayout() end,
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
			order = 25,
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

options.itemLevel = {
	type = "group",
	name = L["Item Level"],
	get = function(info)
		return E.db.mui.itemLevel[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.itemLevel[info[#info]] = value
		IL:ProfileUpdate()
	end,
	hidden = not E.Retail,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Item Level"], 'orange'),
		},
		desc = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = L["Add an extra item level text to some equipment buttons."],
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
		flyout = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Flyout Button"],
			disabled = function()
				return not E.db.mui.itemLevel.enable
			end,
			get = function(info)
				return E.db.mui.itemLevel.flyout[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.itemLevel.flyout[info[#info]] = value
			end,
			args = {
				enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					width = "full"
				},
				font = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Font"],
					get = function(info)
						return E.db.mui.itemLevel.flyout.font[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.itemLevel.flyout.font[info[#info]] = value
					end,
					disabled = function()
						return E.db.mui.itemLevel.flyout.useBagsFontSetting or not E.db.mui.itemLevel.enable
					end,
					args = {
						useBagsFontSetting = {
							order = 0,
							get = function(info)
								return E.db.mui.itemLevel.flyout[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.itemLevel.flyout[info[#info]] = value
							end,
							disabled = function()
								return not E.db.mui.itemLevel.enable
							end,
							type = "toggle",
							name = L["Use Bags Setting"],
							desc = L["Render the item level text with the setting in ElvUI bags."]
						},
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
						xOffset = {
							order = 4,
							name = L["X-Offset"],
							type = "range",
							min = -50,
							max = 50,
							step = 1
						},
						yOffset = {
							order = 5,
							name = L["Y-Offset"],
							type = "range",
							min = -50,
							max = 50,
							step = 1
						}
					}
				},
				color = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Color"],
					disabled = function()
						return E.db.mui.itemLevel.flyout.qualityColor or not E.db.mui.itemLevel.enable
					end,
					args = {
						qualityColor = {
							order = 0,
							get = function(info)
								return E.db.mui.itemLevel.flyout[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.itemLevel.flyout[info[#info]] = value
							end,
							disabled = function()
								return not E.db.mui.itemLevel.enable
							end,
							type = "toggle",
							name = L["Quality Color"]
						},
						color = {
							order = 6,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.mui.itemLevel.flyout.font.color
								local default = P.itemLevel.flyout.font.color
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.mui.itemLevel.flyout.font.color
								db.r, db.g, db.b = r, g, b
							end
						},
					},
				},
			},
		},
		scrappingMachine = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Scrapping Machine"],
			disabled = function()
				return not E.db.mui.itemLevel.enable
			end,
			get = function(info)
				return E.db.mui.itemLevel.scrappingMachine[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.itemLevel.scrappingMachine[info[#info]] = value
			end,
			args = {
				enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					width = "full"
				},
				font = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Font"],
					get = function(info)
						return E.db.mui.itemLevel.scrappingMachine.font[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.itemLevel.scrappingMachine.font[info[#info]] = value
					end,
					disabled = function()
						return E.db.mui.itemLevel.scrappingMachine.useBagsFontSetting or
							not E.db.mui.itemLevel.enable
					end,
					args = {
						useBagsFontSetting = {
							order = 0,
							get = function(info)
								return E.db.mui.itemLevel.scrappingMachine[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.itemLevel.scrappingMachine[info[#info]] = value
							end,
							disabled = function()
								return not E.db.mui.itemLevel.enable
							end,
							type = "toggle",
							name = L["Use Bags Setting"],
							desc = L["Render the item level text with the setting in ElvUI bags."]
						},
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
						xOffset = {
							order = 4,
							name = L["X-Offset"],
							type = "range",
							min = -50,
							max = 50,
							step = 1
						},
						yOffset = {
							order = 5,
							name = L["Y-Offset"],
							type = "range",
							min = -50,
							max = 50,
							step = 1
						},
					},
				},
				color = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Color"],
					disabled = function()
						return E.db.mui.itemLevel.scrappingMachine.qualityColor or not E.db.mui.itemLevel.enable
					end,
					args = {
						qualityColor = {
							order = 0,
							get = function(info)
								return E.db.mui.itemLevel.scrappingMachine[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.itemLevel.scrappingMachine[info[#info]] = value
							end,
							disabled = function()
								return not E.db.mui.itemLevel.enable
							end,
							type = "toggle",
							name = L["Quality Color"]
						},
						color = {
							order = 6,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.mui.itemLevel.scrappingMachine.font.color
								local default = P.itemLevel.scrappingMachine.font.color
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.mui.itemLevel.scrappingMachine.font.color
								db.r, db.g, db.b = r, g, b
							end
						},
					},
				},
			},
		},
	},
}
