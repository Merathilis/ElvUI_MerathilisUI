local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Armory")
local options = MER.options.modules.args
local M = E.Misc
local LSM = E.LSM

local _G = _G

options.armory = {
	type = "group",
	name = L["Armory"],
	childGroups = "tab",
	get = function(info)
		return E.db.mui.armory[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.armory[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	disabled = function()
		return not E.db.general.itemLevel.displayCharacterInfo
	end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Armory"], "orange"),
		},
		credits = {
			order = 2,
			type = "group",
			name = F.cOption(L["Credits"], "orange"),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "description",
					name = "|cff1784d1ElvUI|r |cffffffffToxi|r|cff18a8ffUI|r",
				},
			},
		},
		enable = {
			order = 3,
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."],
		},
		itemLevelGroup = {
			order = 10,
			type = "group",
			name = L["Item Level"],
			get = function(info)
				return E.db.mui.armory.stats[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.armory.stats[info[#info]] = value
				M:UpdatePageInfo(_G.CharacterFrame, "Character")

				if not E.db.general.itemLevel.displayCharacterInfo then
					M:ClearPageInfo(_G.CharacterFrame, "Character")
				end
			end,
			disabled = function()
				return not E.db.mui.armory.enable
			end,
			hidden = function()
				return not E.db.general.itemLevel.displayCharacterInfo
			end,
			args = {
				showAvgItemLevel = {
					order = 1,
					type = "toggle",
					name = L["Bags Item Level"],
					desc = L["Enabling this will show the maximum possible item level you can achieve with items currently in your bags."],
				},
				itemLevelFormat = {
					order = 2,
					type = "select",
					name = L["Format"],
					desc = L["Decimal format"],
					values = {
						["%.0f"] = "69",
						["%.1f"] = "69.0",
						["%.2f"] = "69.01",
						["%.3f"] = "69.012",
					},
				},
				spacer = {
					order = 3,
					type = "description",
					name = " ",
				},
				itemLevelFont = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Font"],
					get = function(info)
						return E.db.mui.armory.stats.itemLevelFont[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.armory.stats.itemLevelFont[info[#info]] = value
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
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
							step = 1,
						},
						itemLevelFontColor = {
							order = 4,
							type = "select",
							name = L["Font Color"],
							values = {
								["GRADIENT"] = F.String.FastGradient(L["Gradient"], 0, 0.6, 1, 0, 0.9, 1),
								["VALUE"] = F.String.ElvUIValue(L["Value Color"]),
								["CUSTOM"] = L["Custom"],
								["DEFAULT"] = F.String.Epic(L["Default"]),
							},
						},
						color = {
							order = 6,
							type = "color",
							name = L["Custom Color"],
							hasAlpha = false,
							hidden = function()
								return E.db.mui.armory.stats.itemLevelFont.itemLevelFontColor ~= "CUSTOM"
							end,
							get = function(info)
								local db = E.db.mui.armory.stats.itemLevelFont[info[#info]]
								local default = P.armory.stats.itemLevelFont[info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.mui.armory.stats.itemLevelFont[info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
					},
				},
			},
		},
		headerGroup = {
			order = 11,
			type = "group",
			name = L["Header"],
			disabled = function()
				return not E.db.mui.armory.enable
			end,
			hidden = function()
				return not E.db.general.itemLevel.displayCharacterInfo
			end,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Settings for different font strings"],
				},
				nameText = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Name Text"],
					get = function(info)
						return E.db.mui.armory.nameText[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.armory.nameText[info[#info]] = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
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
							step = 1,
						},
						fontColor = {
							order = 4,
							type = "select",
							name = L["Font Color"],
							values = {
								["GRADIENT"] = F.String.FastGradient(L["Gradient"], 0, 0.6, 1, 0, 0.9, 1),
								["CLASS"] = F.String.Class(L["Class Gradient"]),
								["CUSTOM"] = L["Custom"],
							},
						},
						color = {
							order = 5,
							type = "color",
							name = L["Custom Color"],
							hasAlpha = false,
							hidden = function()
								return E.db.mui.armory.nameText.fontColor ~= "CUSTOM"
							end,
							get = function(info)
								local db = E.db.mui.armory.nameText[info[#info]]
								local default = P.armory.nameText[info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.mui.armory.nameText[info[#info]]
								db.r, db.g, db.b = r, g, b
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer = {
							order = 6,
							type = "description",
							name = " ",
						},
						offsetX = {
							order = 7,
							type = "range",
							name = L["X-Offset"],
							min = -100,
							max = 100,
							step = 1,
						},
						offsetY = {
							order = 8,
							type = "range",
							name = L["Y-Offset"],
							min = -100,
							max = 100,
							step = 1,
						},
					},
				},
				titleText = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Title Text"],
					get = function(info)
						return E.db.mui.armory.titleText[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.armory.titleText[info[#info]] = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
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
							step = 1,
						},
						fontColor = {
							order = 4,
							type = "select",
							name = L["Font Color"],
							values = {
								["GRADIENT"] = F.String.FastGradient(L["Gradient"], 0, 0.6, 1, 0, 0.9, 1),
								["CLASS"] = F.String.Class(L["Class Gradient"]),
								["CUSTOM"] = L["Custom"],
							},
						},
						color = {
							order = 5,
							type = "color",
							name = L["Custom Color"],
							hasAlpha = false,
							hidden = function()
								return E.db.mui.armory.titleText.fontColor ~= "CUSTOM"
							end,
							get = function(info)
								local db = E.db.mui.armory.titleText[info[#info]]
								local default = P.armory.titleText[info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.mui.armory.titleText[info[#info]]
								db.r, db.g, db.b = r, g, b
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer = {
							order = 6,
							type = "description",
							name = " ",
						},
						offsetX = {
							order = 7,
							type = "range",
							name = L["X-Offset"],
							min = -100,
							max = 100,
							step = 1,
						},
						offsetY = {
							order = 8,
							type = "range",
							name = L["Y-Offset"],
							min = -100,
							max = 100,
							step = 1,
						},
					},
				},
				levelTitleText = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Level Title Text"],
					get = function(info)
						return E.db.mui.armory.levelTitleText[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.armory.levelTitleText[info[#info]] = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
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
							step = 1,
						},
						spacer = {
							order = 6,
							type = "description",
							name = " ",
						},
						offsetX = {
							order = 7,
							type = "range",
							name = L["X-Offset"],
							min = -100,
							max = 100,
							step = 1,
						},
						offsetY = {
							order = 8,
							type = "range",
							name = L["Y-Offset"],
							min = -100,
							max = 100,
							step = 1,
						},
						short = {
							order = 9,
							type = "toggle",
							name = L["Short Display"],
						},
					},
				},
				levelText = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Level Text"],
					get = function(info)
						return E.db.mui.armory.levelText[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.armory.levelText[info[#info]] = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
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
							step = 1,
						},
						spacer = {
							order = 6,
							type = "description",
							name = " ",
						},
						offsetX = {
							order = 7,
							type = "range",
							name = L["X-Offset"],
							min = -100,
							max = 100,
							step = 1,
						},
						offsetY = {
							order = 8,
							type = "range",
							name = L["Y-Offset"],
							min = -100,
							max = 100,
							step = 1,
						},
					},
				},
				specIcon = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Spec Icon"],
					get = function(info)
						return E.db.mui.armory.specIcon[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.armory.specIcon[info[#info]] = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
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
							step = 1,
						},
						fontColor = {
							order = 4,
							type = "select",
							name = L["Font Color"],
							values = {
								["GRADIENT"] = F.String.FastGradient(L["Gradient"], 0, 0.6, 1, 0, 0.9, 1),
								["CLASS"] = F.String.Class(L["Class Gradient"]),
								["CUSTOM"] = L["Custom"],
							},
						},
						color = {
							order = 5,
							type = "color",
							name = L["Custom Color"],
							hasAlpha = false,
							hidden = function()
								return E.db.mui.armory.specIcon.fontColor ~= "CUSTOM"
							end,
							get = function(info)
								local db = E.db.mui.armory.specIcon[info[#info]]
								local default = P.armory.specIcon[info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.mui.armory.specIcon[info[#info]]
								db.r, db.g, db.b = r, g, b
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
					},
				},
				classText = {
					order = 6,
					type = "group",
					inline = true,
					name = L["Class Text Font"],
					get = function(info)
						return E.db.mui.armory.classText[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.armory.classText[info[#info]] = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
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
							step = 1,
						},
						fontColor = {
							order = 4,
							type = "select",
							name = L["Font Color"],
							values = {
								["CLASS"] = F.String.Class(L["Class Gradient"]),
								["CUSTOM"] = L["Custom"],
							},
						},
						color = {
							order = 5,
							type = "color",
							name = L["Custom Color"],
							hasAlpha = false,
							hidden = function()
								return E.db.mui.armory.classText.fontColor ~= "CUSTOM"
							end,
							get = function(info)
								local db = E.db.mui.armory.classText[info[#info]]
								local default = P.armory.classText[info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.mui.armory.classText[info[#info]]
								db.r, db.g, db.b = r, g, b
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						spacer = {
							order = 6,
							type = "description",
							name = " ",
						},
						offsetX = {
							order = 7,
							type = "range",
							name = L["X-Offset"],
							min = -100,
							max = 100,
							step = 1,
						},
						offsetY = {
							order = 8,
							type = "range",
							name = L["Y-Offset"],
							min = -100,
							max = 100,
							step = 1,
						},
					},
				},
			},
		},
		enchantGroup = {
			order = 12,
			type = "group",
			name = L["Enchant & Socket Strings"],
			get = function(info)
				return E.db.mui.armory.pageInfo[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.armory.pageInfo[info[#info]] = value
				M:UpdatePageInfo(_G.CharacterFrame, "Character")

				if not E.db.general.itemLevel.displayCharacterInfo then
					M:ClearPageInfo(_G.CharacterFrame, "Character")
				end
			end,
			disabled = function()
				return not E.db.mui.armory.enable
			end,
			hidden = function()
				return not E.db.general.itemLevel.displayCharacterInfo
			end,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Settings for strings displaying enchant and socket info from the items"],
				},
				enchantTextEnabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable/Disable the Enchant text display"],
				},
				missingEnchantText = {
					order = 2,
					type = "toggle",
					name = L["Missing Enchants"],
					desc = L["Shows a warning when you're missing an enchant."],
				},
				missingSocketText = {
					order = 3,
					type = "toggle",
					name = L["Missing Sockets"],
					desc = L["Shows a warning when you're missing sockets on your necklace."],
				},
				abbreviateEnchantText = {
					order = 4,
					type = "toggle",
					name = L["Short Enchant Text"],
					desc = L["Abbreviates the enchant strings."],
				},
				useEnchantClassColor = {
					order = 5,
					type = "toggle",
					name = L["Class Color"],
					desc = L["Use class color for the enchant strings."],
				},
				moveSockets = {
					order = 6,
					type = "toggle",
					name = E.NewSign .. L["Move Sockets"],
					desc = L["Crops and moves sockets above enchant text."],
					set = function(_, value)
						E.db.mui.armory.pageInfo.moveSockets = value
						if value == false then
							E:StaticPopup_Show("CONFIG_RL")
						end
					end,
				},
				spacer = {
					order = 7,
					type = "description",
					name = "",
				},
				enchantFont = {
					order = 8,
					type = "group",
					inline = true,
					name = L["Enchant Font"],
					get = function(info)
						return E.db.mui.armory.pageInfo.enchantFont[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.armory.pageInfo.enchantFont[info[#info]] = value
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
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
							step = 1,
						},
					},
				},
			},
		},
		slotItemLevelGroup = {
			order = 13,
			type = "group",
			name = L["Slot Item Level"],
			get = function(info)
				return E.db.mui.armory.pageInfo[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.armory.pageInfo[info[#info]] = value
				M:UpdatePageInfo(_G.CharacterFrame, "Character")

				if not E.db.general.itemLevel.displayCharacterInfo then
					M:ClearPageInfo(_G.CharacterFrame, "Character")
				end
			end,
			disabled = function()
				return not E.db.mui.armory.enable
			end,
			hidden = function()
				return not E.db.general.itemLevel.displayCharacterInfo
			end,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Settings for the Item Level next tor your item slot"],
				},
				itemLevelTextEnabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable/Disable the Item Level text display"],
				},
				iconsEnabled = {
					order = 2,
					type = "toggle",
					name = L["Sockets"],
					desc = L["Toggle sockets & azerite traits"],
				},
				spacer = {
					order = 3,
					type = "description",
					name = "",
				},
				iLvLFont = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Item Level Font"],
					get = function(info)
						return E.db.mui.armory.pageInfo.iLvLFont[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.armory.pageInfo.iLvLFont[info[#info]] = value
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
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
							step = 1,
						},
					},
				},
			},
		},
		gradientGroup = {
			order = 14,
			type = "group",
			name = L["Item Quality Gradient"],
			get = function(info)
				return E.db.mui.armory.pageInfo[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.armory.pageInfo[info[#info]] = value
				M:UpdatePageInfo(_G.CharacterFrame, "Character")

				if not E.db.general.itemLevel.displayCharacterInfo then
					M:ClearPageInfo(_G.CharacterFrame, "Character")
				end
			end,
			disabled = function()
				return not E.db.mui.armory.enable
			end,
			hidden = function()
				return not E.db.general.itemLevel.displayCharacterInfo
			end,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Settings for the color coming out of your item slot."],
				},
				itemQualityGradientEnabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Toggling this on enables the Item Quality bars."],
				},
				itemQualityGradientWidth = {
					order = 2,
					type = "range",
					name = L["Width"],
					min = 10,
					max = 120,
					step = 1,
				},
				itemQualityGradientHeight = {
					order = 3,
					type = "range",
					name = L["Height"],
					min = 1,
					max = 40,
					step = 1,
				},
				itemQualityGradientStartAlpha = {
					order = 4,
					type = "range",
					name = L["Start Alpha"],
					min = 0,
					max = 1,
					step = 0.01,
					isPercent = true,
				},
				itemQualityGradientEndAlpha = {
					order = 5,
					type = "range",
					name = L["End Alpha"],
					min = 0,
					max = 1,
					step = 0.01,
					isPercent = true,
				},
			},
		},
		lineGroup = {
			order = 15,
			type = "group",
			name = L["Decorative Lines"],
			get = function(info)
				return E.db.mui.armory.lines[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.armory.lines[info[#info]] = value
				module:UpdateLines()
			end,
			disabled = function()
				return not E.db.mui.armory.enable
			end,
			hidden = function()
				return not E.db.general.itemLevel.displayCharacterInfo
			end,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Settings for the custom " .. MER.Title .. " Armory decorative lines.\n\n"],
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				alpha = {
					order = 3,
					type = "range",
					name = L["Alpha"],
					min = 0,
					max = 1,
					step = 0.01,
					isPercent = true,
				},
				height = {
					order = 4,
					type = "range",
					name = L["Height"],
					min = 1,
					max = 5,
					step = 1,
				},
				color = {
					order = 5,
					type = "select",
					name = L["Color"],
					values = {
						CLASS = F.String.Class("Class"),
						GRADIENT = F.String.GradientClass("Gradient Class"),
					},
				},
			},
		},
	},
}
