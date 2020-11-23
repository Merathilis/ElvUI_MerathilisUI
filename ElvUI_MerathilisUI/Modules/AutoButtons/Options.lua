local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_AutoButtons')
local LSM = E.LSM

local tinsert = table.insert
local tremove = table.remove
local format = string.format
local pairs, select = pairs, select
local tonumber = tonumber

local GetItemInfo = GetItemInfo

local customListSelected1
local customListSelected2

local function ImportantColorString(string)
	return MER:CreateColorString(string, {r = 0.204, g = 0.596, b = 0.859})
end

local function FormatDesc(code, helpText)
	return ImportantColorString(code) .. " = " .. helpText
end

local function AutoButtonTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.autoButtons = {
		type = "group",
		name = L["AutoButtons"],
		get = function(info) return E.db.mui.autoButtons[ info[#info] ] end,
		set = function(info, value) E.db.mui.autoButtons[ info[#info] ] = value; end,
		args = {
			name = ACH:Header(MER:cOption(L["AutoButtons"], 'orange'), 1),
			enable = {
				order = 2,
				type = "toggle",
				name = L["Enable"],
				get = function(info) return E.db.mui.autoButtons[ info[#info] ] end,
				set = function(info, value) E.db.mui.autoButtons[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			},
			custom = {
				order = 6,
				type = "group",
				name = L["Custom Items"],
				disabled = function()
					return not E.db.mui.autoButtons.enable
				end,
				args = {
					addToList = {
						order = 1,
						type = "input",
						name = L["New Item ID"],
						get = function()
							return ""
						end,
						set = function(_, value)
							local itemID = tonumber(value)
							local itemName = select(1, GetItemInfo(itemID))
							if itemName then
								tinsert(E.db.mui.autoButtons.customList, itemID)
								module:UpdateBars()
							else
								MER:Print(L["The item ID is invalid."])
							end
						end
					},
					list = {
						order = 2,
						type = "select",
						name = L["List"],
						get = function()
							return customListSelected1
						end,
						set = function(_, value)
							customListSelected1 = value
						end,
						values = function()
							local list = E.db.mui.autoButtons.customList
							local result = {}
							for key, value in pairs(list) do
								result[key] = select(1, GetItemInfo(value))
							end
							return result
						end
					},
					deleteButton = {
						order = 3,
						type = "execute",
						name = L["Delete"],
						desc = L["Delete the selected item."],
						func = function()
							if customListSelected1 then
								local list = E.db.mui.autoButtons.customList
								tremove(list, customListSelected1)
								module:UpdateBars()
							end
						end
					}
				}
			},
			blackList = {
				order = 7,
				type = "group",
				name = L["Blacklist"],
				disabled = function()
					return not E.db.mui.autoButtons.enable
				end,
				args = {
					addToList = {
						order = 1,
						type = "input",
						name = L["New Item ID"],
						get = function()
							return ""
						end,
						set = function(_, value)
							local itemID = tonumber(value)
							local itemName = select(1, GetItemInfo(itemID))
							if itemName then
								E.db.mui.autoButtons.blackList[itemID] = itemName
								module:UpdateBars()
							else
								MER:Print(L["The item ID is invalid."])
							end
						end
					},
					list = {
						order = 2,
						type = "select",
						name = L["List"],
						get = function()
							return customListSelected2
						end,
						set = function(_, value)
							customListSelected2 = value
						end,
						values = function()
							local result = {}
							for key, value in pairs(E.db.mui.autoButtons.blackList) do
								result[key] = value
							end
							return result
						end
					},
					deleteButton = {
						order = 3,
						type = "execute",
						name = L["Delete"],
						desc = L["Delete the selected item."],
						func = function()
							if customListSelected2 then
								E.db.mui.autoButtons.blackList[customListSelected2] = nil
								module:UpdateBars()
							end
						end
					}
				}
			}
		},
	}

	for i = 1, 3 do
		E.Options.args.mui.args.modules.args.autoButtons.args["bar" .. i] = {
			order = i + 2,
			type = "group",
			name = L["Bar"] .. " " .. i,
			get = function(info)
				return E.db.mui.autoButtons["bar" .. i][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.autoButtons["bar" .. i][info[#info]] = value
				module:UpdateBar(i)
			end,
			disabled = function()
				return not E.db.mui.autoButtons.enable
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"]
				},
				visibility = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Visibility"],
					args = {
						globalFade = {
							order = 1,
							type = "toggle",
							name = L["Inherit Global Fade"]
						},
						mouseOver = {
							order = 2,
							type = "toggle",
							name = L["Mouse Over"],
							desc = L["Only show the bar when you mouse over it."],
							disabled = function()
								return not E.db.mui.autoButtons.enable or
									E.db.mui.autoButtons["bar" .. i].globalFade
							end
						},
						fadeTime = {
							order = 3,
							type = "range",
							name = L["Fade Time"],
							min = 0, max = 2, step = 0.01
						},
						alphaMin = {
							order = 4,
							type = "range",
							name = L["Alpha Min"],
							min = 0, max = 1, step = 0.01
						},
						alphaMax = {
							order = 5,
							type = "range",
							name = L["Alpha Max"],
							min = 0, max = 1, step = 0.01
						},
					},
				},
				backdrop = {
					order = 3,
					type = "toggle",
					name = L["Bar Backdrop"],
					desc = L["Show a backdrop of the bar."]
				},
				anchor = {
					order = 4,
					type = "select",
					name = L["Anchor Point"],
					desc = L["The first button anchors itself to this point on the bar."],
					values = {
						TOPLEFT = L["TOPLEFT"],
						TOPRIGHT = L["TOPRIGHT"],
						BOTTOMLEFT = L["BOTTOMLEFT"],
						BOTTOMRIGHT = L["BOTTOMRIGHT"]
					}
				},
				backdropSpacing = {
					order = 5,
					type = "range",
					name = L["Backdrop Spacing"],
					desc = L["The spacing between the backdrop and the buttons."],
					min = 1,
					max = 30,
					step = 1
				},
				spacing = {
					order = 6,
					type = "range",
					name = L["Button Spacing"],
					desc = L["The spacing between buttons."],
					min = 1,
					max = 30,
					step = 1
				},
				betterOption2 = {
					order = 7,
					type = "description",
					name = " ",
					width = "full"
				},
				numButtons = {
					order = 8,
					type = "range",
					name = L["Buttons"],
					min = 1,
					max = 12,
					step = 1
				},
				buttonWidth = {
					order = 9,
					type = "range",
					name = L["Button Width"],
					desc = L["The width of the buttons."],
					min = 2,
					max = 80,
					step = 1
				},
				buttonHeight = {
					order = 10,
					type = "range",
					name = L["Button Height"],
					desc = L["The height of the buttons."],
					min = 2,
					max = 60,
					step = 1
				},
				buttonsPerRow = {
					order = 11,
					type = "range",
					name = L["Buttons Per Row"],
					min = 1,
					max = 12,
					step = 1
				},
				countFont = {
					order = 12,
					type = "group",
					inline = true,
					name = L["Counter"],
					get = function(info)
						return E.db.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]] = value
						module:UpdateBar(i)
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
						color = {
							order = 6,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]]
								local default = P.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
								module:UpdateBar(i)
							end
						}
					}
				},
				bindFont = {
					order = 13,
					type = "group",
					inline = true,
					name = L["Key Binding"],
					get = function(info)
						return E.db.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]] = value
						module:UpdateBar(i)
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
						color = {
							order = 6,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]]
								local default = P.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
								module:UpdateBar(i)
							end
						}
					}
				},
				include = {
					order = 14,
					type = "input",
					name = L["Button Groups"],
					desc = format(
						"%s %s\n\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",
						L["Set the type and order of button groups."],
						L["You can separate the groups with a comma."],
						FormatDesc("QUEST", L["Quest Items"]),
						FormatDesc("EQUIP", L["Equipments"]),
						FormatDesc("POTION", L["Potions"]),
						FormatDesc("POTIONSL", format("%s (%s)", L["Potions"], L["Shadowlands"])),
						FormatDesc("FLASK", L["Flasks"]),
						FormatDesc("FLASKSL", format("%s (%s)", L["Flasks"], L["Shadowlands"])),
						FormatDesc("FOOD", L["Food"]),
						FormatDesc("FOODSL", format("%s (%s)", L["Food"], L["Shadowlands"])),
						FormatDesc("BANNER", L["Banners"]),
						FormatDesc("UTILITY", L["Utilities"]),
						FormatDesc("CUSTOM", L["Custom Items"])
					),
					width = "full"
				}
			}
		}
	end
end
tinsert(MER.Config, AutoButtonTable)
