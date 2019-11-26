local MER, E, L, V, P, G = unpack(select(2, ...))
local MAB = MER:GetModule("mUIActionbars")

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
	E.Options.args.mui.args.modules.args.actionbars = {
		type = "group",
		name = E.NewSign..L["ActionBars"],
		get = function(info) return E.db.mui.actionbars[ info[#info] ] end,
		set = function(info, value) E.db.mui.actionbars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["ActionBars"]),
			},
			general = {
				order = 2,
				type = "group",
				name = MER:cOption(L["General"]),
				guiInline = true,
				args = {
					customGlow = {
						order = 1,
						type = "toggle",
						name = E.NewSign..L["Custom Glow"],
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
						set = function(info, value) E.db.mui.actionbars.autoButtons[info[#info]] = value; MER:GetModule("AutoButtons"):UpdateAutoButton() end,
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
									MER:GetModule("AutoButtons"):UpdateAutoButton()
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
									MER:GetModule("AutoButtons"):UpdateAutoButton()
								end,
							},
							whiteList = {
								order = 9,
								type = "multiselect",
								name = L["Whitelist"],
								get = function(info, k) return E.db.mui.actionbars.autoButtons.whiteList[k] end,
								set = function(info, k, v) E.db.mui.actionbars.autoButtons.whiteList[k] = v; MER:GetModule("AutoButtons"):UpdateAutoButton() end,
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
									MER:GetModule("AutoButtons"):UpdateAutoButton()
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
									MER:GetModule("AutoButtons"):UpdateAutoButton()
								end,
							},
							blackList = {
								order = 13,
								type = "multiselect",
								name = L["Blacklist"],
								get = function(info, k) return E.db.mui.actionbars.autoButtons.blackList[k] end,
								set = function(info, k, v) E.db.lui.modules.actionbars.autoButtons.blackList[k] = v; MER:GetModule("AutoButtons"):UpdateAutoButton() end,
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
			set = function(info, value) E.db.mui.actionbars.autoButtons[btype.."AutoButtons"][info[#info]] = value; MER:GetModule("AutoButtons"):UpdateAutoButton() end,
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
						MER:GetModule("AutoButtons"):UpdateAutoButton()
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
end
tinsert(MER.Config, ActionBarTable)
