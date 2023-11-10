local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_AutoButtons')
local options = MER.options.modules.args
local async = MER.Utilities.Async
local LSM = E.LSM

local tinsert = table.insert
local tremove = table.remove
local format = string.format
local pairs = pairs
local tonumber = tonumber

local C_Item_GetItemIconByID = C_Item.GetItemIconByID
local C_Item_GetItemNameByID = C_Item.GetItemNameByID

local customListSelected1
local customListSelected2

local function ImportantColorString(string)
	return F.CreateColorString(string, {r = 0.204, g = 0.596, b = 0.859})
end

local function desc(code, helpText)
	return ImportantColorString(code) .. " = " .. helpText
end

options.autoButtons = {
	type = "group",
	name = L["AutoButtons"],
	get = function(info) return E.db.mui.autoButtons[ info[#info] ] end,
	set = function(info, value) E.db.mui.autoButtons[ info[#info] ] = value; end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["AutoButtons"], 'orange'),
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			get = function(info) return E.db.mui.autoButtons[ info[#info] ] end,
			set = function(info, value) E.db.mui.autoButtons[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		},
		custom = {
			order = 10,
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
						if async.WithItemID(itemID) then
							tinsert(E.db.mui.autoButtons.customList, itemID)
							module:UpdateBars()
						else
							F.Print(L["The item ID is invalid."])
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
							async.WithItemID(value, function(item)
								local name = item:GetItemName() or L["Unknown"]
								local tex = item:GetItemIcon()
								result[key] = F.GetIconString(tex, 14, 18, true) .. " " .. name
							end)
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
			order = 11,
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
						if async.WithItemID(itemID) then
							E.db.mui.autoButtons.blackList[itemID] = true
							module:UpdateBars()
						else
							F.Print(L["The item ID is invalid."])
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
						for key in pairs(E.db.mui.autoButtons.blackList) do
							async.WithItemID(key, function(item)
								local name = item:GetItemName() or L["Unknown"]
								local tex = item:GetItemIcon()
								result[key] = F.GetIconString(tex, 14, 18, true) .. " " .. name
							end)
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
for i = 1, 5 do
	options.autoButtons.args["bar" .. i] = {
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
						min = 0, max = 0.9, step = 0.01
					},
					alphaMax = {
						order = 5,
						type = "range",
						name = L["Alpha Max"],
						min = 0, max = 1, step = 0.01
					},
					tooltip = {
						order = 6,
						type = "toggle",
						name = L["Tooltip"],
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
				min = 1, max = 30, step = 1
			},
			spacing = {
				order = 6,
				type = "range",
				name = L["Button Spacing"],
				desc = L["The spacing between buttons."],
				min = 1, max = 30, step = 1
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
				min = 1, max = 12, step = 1
			},
			buttonWidth = {
				order = 9,
				type = "range",
				name = L["Button Width"],
				desc = L["The width of the buttons."],
				min = 2, max = 80, step = 1
			},
			buttonHeight = {
				order = 10,
				type = "range",
				name = L["Button Height"],
				desc = L["The height of the buttons."],
				min = 2, max = 60, step = 1
			},
			buttonsPerRow = {
				order = 11,
				type = "range",
				name = L["Buttons Per Row"],
				min = 1, max = 12, step = 1
			},
			qualityTier = {
				order = 12,
				type = "group",
				inline = true,
				name = L["Crafting Quality Tier"],
				get = function(info)
					return E.db.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]]
				end,
				set = function(info, value)
					E.db.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]] = value
					E:StaticPopup_Show("PRIVATE_RL")
				end,
				args = {
					size = {
						order = 3,
						name = L["Size"],
						type = "range",
						min = 5, max = 60, step = 1
					},
					xOffset = {
						order = 4,
						name = L["X-Offset"],
						type = "range",
						min = -100, max = 100, step = 1
					},
					yOffset = {
						order = 5,
						name = L["Y-Offset"],
						type = "range",
						min = -100, max = 100, step = 1
					},
				},
			},
			countFont = {
				order = 13,
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
						values = MER.Values.FontFlags,
						sortByValue = true,
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
						min = -100,
						max = 100,
						step = 1
					},
					yOffset = {
						order = 5,
						name = L["Y-Offset"],
						type = "range",
						min = -100,
						max = 100,
						step = 1
					},
					color = {
						order = 6,
						type = "color",
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local db = E.db.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]]
							local default = P.autoButtons["bar" .. i][info[#info - 1]][info[#info]]
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
				order = 14,
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
						values = MER.Values.FontFlags,
						sortByValue = true,
					},
					size = {
						order = 3,
						name = L["Size"],
						type = "range",
						min = 5, max = 60, step = 1
					},
					xOffset = {
						order = 4,
						name = L["X-Offset"],
						type = "range",
						min = -100, max = 100, step = 1
					},
					yOffset = {
						order = 5,
						name = L["Y-Offset"],
						type = "range",
						min = -100, max = 100, step = 1
					},
					color = {
						order = 6,
						type = "color",
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local db = E.db.mui.autoButtons["bar" .. i][info[#info - 1]][info[#info]]
							local default = P.autoButtons["bar" .. i][info[#info - 1]][info[#info]]
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
				order = 15,
				type = "input",
				name = L["Button Groups"],
				desc = format("%s %s\n" .. strrep("\n%s", 20),
					L["Set the type and order of button groups."],
					L["You can separate the groups with a comma."],
					desc("QUEST", L["Quest Items"]),
					desc("EQUIP", L["Equipments"]),
					desc("POTION", L["Potions"]),
					desc("POTIONSL", format("%s |cffffdd57[%s]|r", L["Potions"], L["Shadowlands"])),
					desc("POTIONDF", format("%s |cffffdd57[%s]|r", L["Potions"], L["Dragonflight"])),
					desc("FLASK", L["Flasks"]),
					desc("FLASKSL", format("%s |cffffdd57[%s]|r", L["Flasks"], L["Shadowlands"])),
					desc("FLASKDF", format("%s |cffffdd57[%s]|r", L["Flasks"], L["Dragonflight"])),
					desc("RUNE", L["Runes"]),
					desc("RUNEDF", format("%s |cffffdd57[%s]|r", L["Runes"], L["Dragonflight"])),
					desc("FOOD", L["Crafted Food"]),
					desc("FOODSL", format("%s |cffffdd57[%s]|r", L["Crafted Food"], L["Shadowlands"])),
					desc("FOODDF", format("%s |cffffdd57[%s]|r", L["Crafted Food"], L["Dragonflight"])),
					desc("FOODVENDOR", format("%s (%s) |cffffdd57[%s]|r", L["Food"], L["Sold by vendor"], L["Dragonflight"])),
					desc("MAGEFOOD", format("%s (%s)|r", L["Food"], L["Crafted by mage"])),
					desc("BANNER", L["Banners"]),
					desc("UTILITY", L["Utilities"]),
					desc("OPENABLE", L["Openable Items"]),
					desc("PROF", L["Profession Items"]),
					desc("SEEDS", L["Dream Seeds"]),
					desc("CUSTOM", L["Custom Items"])

				),
				width = "full"
			}
		}
	}
end
