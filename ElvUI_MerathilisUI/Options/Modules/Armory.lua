local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Armory")
local options = MER.options.modules.args
local M = E.Misc
local LSM = E.LSM

local _G = _G

local GetItemInfo = C_Item.GetItemInfo

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
		general = {
			order = 3,
			type = "group",
			name = E.NewSign .. L["General"],
			args = {
				backgroundGroup = {
					order = 1,
					type = "group",
					name = E.NewSign .. L["Background"],
					get = function(info)
						return E.db.mui.armory.background[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.armory.background[info[#info]] = value
						M:UpdatePageInfo(_G.CharacterFrame, "Character")

						if not E.db.general.itemLevel.displayCharacterInfo then
							M:ClearPageInfo(_G.CharacterFrame, "Character")
						end
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."],
						},
						alpha = {
							order = 2,
							type = "range",
							name = L["Alpha"],
							min = 0,
							max = 1,
							step = 0.01,
							isPercent = true,
						},
						style = {
							order = 3,
							type = "select",
							name = L["Style"],
							desc = L["Change the Background image."],
							values = {
								[1] = "1. Priory of the Sacred Flame",
								[2] = "2. Azj-Kahet",
								[3] = "3. Draenor",
							},
							disabled = function()
								return E.db.mui.armory.background.class
							end,
						},
						class = {
							order = 4,
							type = "toggle",
							name = L["Class Background"],
							desc = L["Use class specific backgrounds."],
							disabled = function()
								return not E.db.mui.armory.background.enable
							end,
							width = 1.2,
						},
						hideControls = {
							order = 1,
							type = "toggle",
							name = L["Hide Controls"],
							desc = L["Hides the camera controls when hovering the character model."],
							set = function(_, value)
								E.db.mui.armory.background.hideControls = value
								if value == false then
									E:StaticPopup_Show("CONFIG_RL")
								end
							end,
							disabled = function()
								return not E.db.mui.armory.background.enable
							end,
						},
					},
				},
				animationGroup = {
					order = 2,
					type = "group",
					name = E.NewSign .. L["Animation"],
					args = {
						animations = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							set = function(_, value)
								E.db.mui.armory.animations = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
						},
						animationsMult = {
							order = 2,
							type = "range",
							name = L["Animation Multiplier"],
							min = 0.1,
							max = 2,
							step = 0.1,
							isPercent = true,
							get = function()
								return 1 / E.db.mui.armory.animationsMult
							end,
							set = function(_, value)
								E.db.mui.armory.animationsMult = 1 / value
							end,
							disabled = function()
								return not E.db.mui.armory.animations
							end,
						},
					},
				},
			},
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
					desc = function()
						local socketItem, socketTexture = nil, nil
						if GetItemInfo then
							local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(213777)
							if itemName and itemTexture then
								socketItem = itemName
								socketTexture = itemTexture
							end
						end
						return L["Shows a warning when you're missing sockets on your necklace."]
							.. "\n\n"
							.. (
								socketItem
									and (L["Sockets can be added with "] .. F.GetIconString(socketTexture, 14, 14, true) .. " " .. F.String.Epic(
										socketItem
									))
								or ""
							)
					end,
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
					name = L["Move Sockets"],
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
		attributesGroup = {
			order = 16,
			type = "group",
			name = E.NewSign .. L["Attributes"],
			get = function(info)
				return E.db.mui.armory.stats[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.armory.stats[info[#info]] = value
				F.Event.TriggerEvent("Armory.SettingsUpdate")
			end,
			disabled = function()
				return not E.db.mui.armory.enable
			end,
			hidden = function()
				return not E.db.general.itemLevel.displayCharacterInfo
			end,
			args = {
				alternatingBackgroundEnabled = {
					order = 1,
					type = "toggle",
					name = L["Background Bars"],
					desc = L["Toggles the blue bars behind every second number."],
				},
				alternatingBackgroundAlpha = {
					order = 2,
					type = "range",
					name = L["Background Alpha"],
					min = 0,
					max = 1,
					step = 0.01,
					isPercent = true,
					disabled = function()
						return not E.db.mui.armory.stats.alternatingBackgroundEnabled
					end,
				},
				fontGroup = {
					order = 3,
					type = "group",
					name = L["Fonts"],
					inline = true,
					args = {
						headerFont = {
							order = 1,
							type = "group",
							name = L["Header Font"],
							get = function(info)
								return E.db.mui.armory.stats.headerFont[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.armory.stats.headerFont[info[#info]] = value
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
								headerFontColor = {
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
									order = 6,
									type = "color",
									name = L["Custom Color"],
									hasAlpha = false,
									disabled = function()
										return E.db.mui.armory.stats.headerFont.headerFontColor ~= "CUSTOM"
									end,
									get = function(info)
										local db = E.db.mui.armory.stats.headerFont[info[#info]]
										local default = P.armory.stats.headerFont[info[#info]]
										return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
									end,
									set = function(info, r, g, b)
										local db = E.db.mui.armory.stats.headerFont[info[#info]]
										db.r, db.g, db.b = r, g, b
										F.Event.TriggerEvent("Armory.SettingsUpdate")
									end,
								},
							},
						},
						labelFont = {
							order = 2,
							type = "group",
							name = L["Label Font"],
							get = function(info)
								return E.db.mui.armory.stats.labelFont[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.armory.stats.labelFont[info[#info]] = value
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
								labelFontColor = {
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
									order = 6,
									type = "color",
									name = L["Custom Color"],
									hasAlpha = false,
									disabled = function()
										return E.db.mui.armory.stats.labelFont.labelFontColor ~= "CUSTOM"
									end,
									get = function(info)
										local db = E.db.mui.armory.stats.labelFont[info[#info]]
										local default = P.armory.stats.labelFont[info[#info]]
										return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
									end,
									set = function(info, r, g, b)
										local db = E.db.mui.armory.stats.labelFont[info[#info]]
										db.r, db.g, db.b = r, g, b
										F.Event.TriggerEvent("Armory.SettingsUpdate")
									end,
								},
								abbreviateLabels = {
									order = 7,
									type = "toggle",
									name = L["Short Labels"],
									desc = L["Shorten and abbreviate attribute labels."],
								},
							},
						},
						valueFont = {
							order = 3,
							type = "group",
							name = L["Value Font"],
							get = function(info)
								return E.db.mui.armory.stats.valueFont[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.armory.stats.valueFont[info[#info]] = value
							end,
							args = {
								name = {
									order = 1,
									type = "select",
									dialogControl = "LSM30_Font",
									name = L["Font"],
									values = LSM:HashTable("font"),
								},
								size = {
									order = 2,
									name = L["Size"],
									type = "range",
									min = 5,
									max = 60,
									step = 1,
								},
								style = {
									order = 3,
									type = "select",
									name = L["Outline"],
									values = MER.Values.FontFlags,
									sortByValue = true,
								},
							},
						},
					},
				},
				statsGroup = {
					order = 4,
					type = "group",
					name = L["Attribute Visibility"],
					inline = true,
					args = {},
				},
			},
		},
	},
}

for stat, _ in pairs(P.armory.stats.mode) do
	options.armory.args.attributesGroup.args.statsGroup.args[stat] = {
		type = "select",
		name = F.String.LowercaseEnum(stat),
		values = {
			[0] = "Hide",
			[1] = "Show Only Relevant",
			[2] = "Show Above 0",
			[3] = "Always Show",
		},
		get = function(info)
			return E.db.mui.armory.stats.mode[info[#info]].mode
		end,
		set = function(info, value)
			E.db.mui.armory.stats.mode[info[#info]].mode = value
			F.Event.TriggerEvent("Armory.SettingsUpdate")
		end,
	}
end
