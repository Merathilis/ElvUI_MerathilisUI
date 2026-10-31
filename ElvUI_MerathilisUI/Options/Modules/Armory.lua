local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local Armory = MER:GetModule("MER_Armory")
	local LSM = E.LSM

	local options = module.options.modules.args

	local format = string.format

	local GetItemIconByID = C_Item.GetItemIconByID
	local GetItemInfo = C_Item.GetItemInfo

	local SOCKET_ITEM_ID = 263897

	-- Redraws the whole armory: fonts, colors, lines, background, page info and stats
	local function Refresh()
		F.Event.TriggerEvent("Armory.SettingsUpdate")
	end

	options.armory = {
		type = "group",
		name = module:AddCategorieIcon(L["Armory"], "armory"),
		childGroups = "tab",
		get = function(info)
			return E.db.mui.armory[info[#info]]
		end,
		set = function(info, value)
			E.db.mui.armory[info[#info]] = value
			E:StaticPopup_Show("CONFIG_RL")
		end,
		disabled = function()
			return not E.db.general.itemLevel.displayCharacterInfo
		end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Armory"],
			},
			enable = module.ToggleCard({
				order = 2,
				name = L["Enable"],
				desc = L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."],
				image = I.Media.Icons.Categories.armory,
			}),
			credits = module.CreditsCard(3, "|cff1784d1ElvUI|r |cffffffffToxi|r|cff18a8ffUI|r"),
			general = {
				order = 4,
				type = "group",
				name = L["General"],
				args = {
					preview = module.PreviewOption(0, "MERArmoryPreview", "frame"),
					backgroundGroup = {
						order = 1,
						type = "group",
						name = L["Background"],
						get = function(info)
							return E.db.mui.armory.background[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.armory.background[info[#info]] = value
							Refresh()
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
								disabled = function()
									return not E.db.mui.armory.background.enable
								end,
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
									return not E.db.mui.armory.background.enable or E.db.mui.armory.background.class
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
								order = 5,
								type = "toggle",
								name = L["Hide Controls"],
								desc = L["Hides the camera controls when hovering the character model."],
								disabled = function()
									return not E.db.mui.armory.background.enable
								end,
							},
						},
					},
					animationGroup = {
						order = 2,
						type = "group",
						name = L["Animation"],
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
					modelGroup = {
						order = 3,
						type = "group",
						name = L["Model"],
						get = function(info)
							return E.db.mui.armory.model[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.armory.model[info[#info]] = value
							Refresh()
						end,
						args = {
							spotlight = {
								order = 1,
								type = "toggle",
								name = L["Spotlight"],
								desc = L["A soft glow in your class color behind the character."],
							},
							spotlightAlpha = {
								order = 2,
								type = "range",
								name = L["Alpha"],
								min = 0.05,
								max = 1,
								step = 0.01,
								isPercent = true,
								disabled = function()
									return not E.db.mui.armory.model.spotlight
								end,
							},
							spacer = {
								order = 3,
								type = "description",
								name = "",
							},
							shadow = {
								order = 4,
								type = "toggle",
								name = L["Ground Shadow"],
								desc = L["A shadow under the feet of the character that follows the camera."],
							},
							shadowAlpha = {
								order = 5,
								type = "range",
								name = L["Alpha"],
								min = 0.1,
								max = 1,
								step = 0.01,
								isPercent = true,
								disabled = function()
									return not E.db.mui.armory.model.shadow
								end,
							},
							spacer2 = {
								order = 6,
								type = "description",
								name = "",
							},
							doubleClickReset = {
								order = 7,
								type = "toggle",
								name = L["Double-Click Reset"],
								desc = L["Double-click the character to reset its rotation, zoom and position."],
								width = 1.2,
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
					Refresh()
				end,
				disabled = function()
					return not E.db.mui.armory.enable
				end,
				hidden = function()
					return not E.db.general.itemLevel.displayCharacterInfo
				end,
				args = {
					preview = module.PreviewOption(0, "MERArmoryPreview", "frame"),
					showAvgItemLevel = {
						order = 1,
						type = "toggle",
						name = L["Bags Item Level"],
						desc = L["Enabling this will show the maximum possible item level you can achieve with items currently in your bags."],
					},
					itemLevelFormat = module.Segmented({
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
					}, { "%.0f", "%.1f", "%.2f", "%.3f" }),
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
							Refresh()
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
									Refresh()
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
					preview = module.PreviewOption(0.5, "MERArmoryPreview", "header"),
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
							Refresh()
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
									Refresh()
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
							Refresh()
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
									Refresh()
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
							Refresh()
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
								order = 5,
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
							Refresh()
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
							Refresh()
						end,
						args = {
							style = {
								order = 1,
								type = "select",
								name = L["Outline"],
								values = MER.Values.FontFlags,
								sortByValue = true,
							},
							size = {
								order = 2,
								name = L["Size"],
								type = "range",
								min = 5,
								max = 60,
								step = 1,
							},
							fontColor = {
								order = 3,
								type = "select",
								name = L["Font Color"],
								values = {
									["GRADIENT"] = F.String.FastGradient(L["Gradient"], 0, 0.6, 1, 0, 0.9, 1),
									["CLASS"] = F.String.Class(L["Class Gradient"]),
									["CUSTOM"] = L["Custom"],
								},
							},
							color = {
								order = 4,
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
									Refresh()
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
							Refresh()
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
									Refresh()
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
					Refresh()
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
					preview = module.PreviewOption(0.5, "MERArmoryPreview", "slots"),
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
							local text = L["Shows a warning when you're missing sockets on your necklace."]
							local itemName = GetItemInfo(SOCKET_ITEM_ID)
							if not itemName then
								return text
							end

							local icon = F.GetIconString(GetItemIconByID(SOCKET_ITEM_ID), 14, 14, true)
							return text
								.. "\n\n"
								.. L["Sockets can be added with "]
								.. icon
								.. " "
								.. F.String.Epic(itemName)
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
							-- Moved sockets only go back with a reload
							if value then
								Refresh()
							else
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
							Refresh()
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
					Refresh()
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
						name = L["Settings for the Item Level next to your item slot"],
					},
					preview = module.PreviewOption(0.5, "MERArmoryPreview", "slots"),
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
					upgradeBarEnabled = {
						order = 2.5,
						type = "toggle",
						name = L["Upgrade Level"],
						desc = L["A bar next to the item icon shows the upgrade level of the item, e.g. 4 of 6 segments filled."],
					},
					upgradeTrackColor = {
						order = 2.6,
						type = "toggle",
						name = F.NewFeatureText(L["Upgrade Track Color"]),
						desc = L["Colors the upgrade bar by the upgrade track of the item: Explorer gray, Adventurer white, Veteran green, Champion blue, Hero purple and Myth orange. Without it the bar goes from red to green with the upgrade level."],
						disabled = function()
							return not (E.db.mui.armory.enable and E.db.mui.armory.pageInfo.upgradeBarEnabled)
						end,
					},
					upgradeTrackText = {
						order = 2.7,
						type = "toggle",
						name = F.NewFeatureText(L["Upgrade Track"]),
						desc = L["Shows the first letter of the upgrade track in the corner of the item icon, e.g. H for Hero, in the color of the track."],
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
							Refresh()
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
					Refresh()
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
					preview = module.PreviewOption(0.5, "MERArmoryPreview", "slots"),
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
					Armory:UpdateLines()
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
						name = format(L["Settings for the custom %s Armory decorative lines."], MER.Title),
					},
					preview = module.PreviewOption(0.5, "MERArmoryPreview", "frame"),
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
				},
			},
			attributesGroup = {
				order = 16,
				type = "group",
				name = L["Attributes"],
				get = function(info)
					return E.db.mui.armory.stats[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.armory.stats[info[#info]] = value
					Refresh()
				end,
				disabled = function()
					return not E.db.mui.armory.enable
				end,
				hidden = function()
					return not E.db.general.itemLevel.displayCharacterInfo
				end,
				args = {
					preview = module.PreviewOption(0, "MERArmoryPreview", "stats"),
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
					highlightSlots = {
						order = 2.5,
						type = "toggle",
						name = L["Highlight Slots"],
						desc = L["Hovering a secondary or tertiary stat dims the item slots that do not have it, gems included."],
					},
					pickerButton = {
						order = 2.6,
						type = "toggle",
						name = F.NewFeatureText(L["Stat Picker"]),
						desc = L["Shows a cog button on the stats of the character frame. It switches to an edit mode where a click shows or hides a stat and dragging changes the order."],
					},
					resetPicker = {
						order = 2.7,
						type = "execute",
						name = L["Reset Stats"],
						desc = L["Restores the default order and visibility of all stats."],
						func = function()
							Armory:ResetStatPicker()
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
									Refresh()
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
											Refresh()
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
									Refresh()
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
											Refresh()
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
									Refresh()
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
			socketPanel = {
				order = 17,
				type = "group",
				name = L["Socket Panel"],
				get = function(info)
					return E.db.mui.armory.socketPanel[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.armory.socketPanel[info[#info]] = value
					Refresh()
				end,
				disabled = function()
					return not E.db.mui.armory.enable
				end,
				hidden = function()
					return not E.db.general.itemLevel.displayCharacterInfo
				end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Show the socket panel at the bottom of the character sheet."],
					},
					preview = module.PreviewOption(1.5, "MERArmoryPanesPreview", "sockets"),
					appearance = {
						order = 2,
						type = "group",
						name = L["Appearance"],
						inline = true,
						get = function(info)
							return E.db.mui.armory.socketPanel[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.armory.socketPanel[info[#info]] = value
							Refresh()
						end,
						args = {
							iconSize = {
								order = 1,
								type = "range",
								name = L["Icon Size"],
								min = 16,
								max = 40,
								step = 1,
							},
							spacing = {
								order = 2,
								type = "range",
								name = L["Spacing"],
								min = 0,
								max = 12,
								step = 1,
							},
							anchorX = {
								order = 3,
								type = "range",
								name = L["Horizontal Offset"],
								min = -100,
								max = 100,
								step = 1,
							},
							anchorY = {
								order = 4,
								type = "range",
								name = L["Vertical Offset"],
								min = -100,
								max = 100,
								step = 1,
							},
							openOnHover = {
								order = 5,
								type = "toggle",
								name = L["Open on Empty Socket Hover"],
							},
							showSlotGlow = {
								order = 6,
								type = "toggle",
								name = L["Highlight Equipment Slot"],
							},
						},
					},
					flyout = {
						order = 3,
						type = "group",
						name = L["Gem Flyout"],
						inline = true,
						get = function(info)
							return E.db.mui.armory.socketPanel[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.armory.socketPanel[info[#info]] = value
							Refresh()
						end,
						args = {
							flyoutWidth = {
								order = 1,
								type = "range",
								name = L["Width"],
								min = 160,
								max = 360,
								step = 1,
							},
							rowHeight = {
								order = 2,
								type = "range",
								name = L["Row Height"],
								min = 16,
								max = 28,
								step = 1,
							},
							maxRows = {
								order = 3,
								type = "range",
								name = L["Maximum Visible Rows"],
								min = 4,
								max = 20,
								step = 1,
							},
						},
					},
					font = {
						order = 4,
						type = "group",
						name = L["Font"],
						inline = true,
						get = function(info)
							return E.db.mui.armory.socketPanel.font[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.armory.socketPanel.font[info[#info]] = value
							Refresh()
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
								type = "range",
								name = L["Size"],
								min = 7,
								max = 24,
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
			equipmentManager = {
				order = 18,
				type = "group",
				name = L["Equipment Manager"],
				get = function(info)
					return E.db.mui.armory.equipmentManager[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.armory.equipmentManager[info[#info]] = value
					Refresh()
				end,
				disabled = function()
					return not E.db.mui.armory.enable
				end,
				hidden = function()
					return not E.db.general.itemLevel.displayCharacterInfo
				end,
				args = {
					preview = module.PreviewOption(0, "MERArmoryPanesPreview", "gearsets"),
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Replace Blizzard's native Equipment Manager pane with a custom MerathilisUI gear-set panel."],
					},
					useClassColor = {
						order = 2,
						type = "toggle",
						name = L["Class Color"],
						desc = L["Use your class color for the selected/equipped set accents instead of the accent color below."],
					},
					accentColor = {
						order = 3,
						type = "color",
						name = L["Accent Color"],
						desc = L["Accent color used for the selected/equipped set highlight, unless Class Color is enabled."],
						hasAlpha = false,
						hidden = function()
							return E.db.mui.armory.equipmentManager.useClassColor
						end,
						get = function(info)
							local db = E.db.mui.armory.equipmentManager[info[#info]]
							local default = P.armory.equipmentManager[info[#info]]
							return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
						end,
						set = function(info, r, g, b)
							local db = E.db.mui.armory.equipmentManager[info[#info]]
							db.r, db.g, db.b = r, g, b
							Refresh()
						end,
					},
					showBackdrop = {
						order = 4,
						type = "toggle",
						name = L["Show Backdrop"],
						desc = L["Show an opaque dark backdrop behind the gear-set panel."],
					},
					font = {
						order = 5,
						type = "group",
						name = L["Font"],
						inline = true,
						get = function(info)
							return E.db.mui.armory.equipmentManager.font[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.armory.equipmentManager.font[info[#info]] = value
							Refresh()
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
								type = "range",
								name = L["Size"],
								min = 7,
								max = 24,
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
				Refresh()
			end,
		}
	end

	-- Font settings in a popup behind a button with a summary
	local armoryArgs = options.armory.args
	for _, entry in ipairs({
		{ armoryArgs.itemLevelGroup.args, "itemLevelFont", "stats", "itemLevelFont" },
		{ armoryArgs.enchantGroup.args, "enchantFont", "pageInfo", "enchantFont" },
		{ armoryArgs.slotItemLevelGroup.args, "iLvLFont", "pageInfo", "iLvLFont" },
		{ armoryArgs.socketPanel.args, "font", "socketPanel", "font" },
		{ armoryArgs.equipmentManager.args, "font", "equipmentManager", "font" },
	}) do
		local section, field = entry[3], entry[4]
		module.CogGroup(
			entry[1],
			entry[2],
			module.FontSummary(function()
				return E.db.mui.armory[section][field]
			end)
		)
	end

	-- Font colors as one bar each, the custom color opens the picker from it
	local GRADIENT_CHIP = { 0, 0.75, 1 }
	local fontColors = {
		{
			options.armory.args.itemLevelGroup.args.itemLevelFont.args,
			"itemLevelFontColor",
			{ "DEFAULT", "VALUE", "GRADIENT", "CUSTOM" },
		},
		{ options.armory.args.headerGroup.args.nameText.args, "fontColor", { "CLASS", "GRADIENT", "CUSTOM" } },
		{ options.armory.args.headerGroup.args.titleText.args, "fontColor", { "CLASS", "GRADIENT", "CUSTOM" } },
		{ options.armory.args.headerGroup.args.specIcon.args, "fontColor", { "CLASS", "GRADIENT", "CUSTOM" } },
		{ options.armory.args.headerGroup.args.classText.args, "fontColor", { "CLASS", "CUSTOM" } },
		{
			options.armory.args.attributesGroup.args.fontGroup.args.headerFont.args,
			"headerFontColor",
			{ "CLASS", "GRADIENT", "CUSTOM" },
		},
		{
			options.armory.args.attributesGroup.args.fontGroup.args.labelFont.args,
			"labelFontColor",
			{ "CLASS", "GRADIENT", "CUSTOM" },
		},
	}
	for _, entry in ipairs(fontColors) do
		module.ColorModeSelect(entry[1], entry[2], "color", entry[3], {
			chips = { GRADIENT = GRADIENT_CHIP, DEFAULT = { 0.64, 0.21, 0.93 } },
		})
	end

	-- The font strings of the header as cards, their offsets behind "Show More Options",
	-- the font itself in a popup (module.ApplyCogFonts)
	local headerArgs = options.armory.args.headerGroup.args
	for key in pairs({
		nameText = true,
		titleText = true,
		levelTitleText = true,
		levelText = true,
		specIcon = true,
		classText = true,
	}) do
		local group = headerArgs[key]
		local fontKeys = {}
		for _, fontKey in ipairs({ "name", "style", "size" }) do
			if group.args[fontKey] then
				fontKeys[#fontKeys + 1] = fontKey
			end
		end
		module.GroupOptions(group.args, "font", L["Font"], fontKeys)
		if group.args.offsetX then
			module.LessCommon(group.args, "armory" .. key .. "More", { "spacer", "offsetX", "offsetY" })
		end
		module.ModuleCard("armory" .. key, group)
	end

	F.MarkTabAsNew("armory")
end)
