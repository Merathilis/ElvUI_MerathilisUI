local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local EM = MER:GetModule("MER_EquipManager") ---@class EquipmentManager
local BC = MER:GetModule("MER_BagCategories") ---@class BagCategories
local B = E:GetModule("Bags")

local options = module.options.modules.args

F.MarkTabAsNew("bags")

options.bags = {
	type = "group",
	name = module:AddCategorieIcon(L["Bags"], "bags"),
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.NewFeatureText(F.cOption(L["Bags"], "orange")),
		},
		equipmentManager = {
			order = 1,
			type = "group",
			name = L["Equipment Manager"],
			guiInline = true,
			get = function(info)
				return E.db.mui.bags.equipmentManager[info[#info]]
			end,
			-- set = function(info, value) E.db.mui.bags.equipmentManager[info[#info]] = value; EM:UpdateBagSettings() end,
			set = function(info, value)
				E.db.mui.bags.equipmentManager[info[#info]] = value
				-- B:UpdateLayouts()
				-- B:UpdateAllBagSlots()
				EM:UpdateItemDisplay()
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enables an indicator on equipment icons located in your bags to show if they are part of an equipment set."],
					set = function(info, value)
						E.db.mui.bags.equipmentManager[info[#info]] = value
						-- EM:ToggleSettings()
						B:UpdateLayouts()
						B:UpdateAllBagSlots(true)
					end,
				},
				size = {
					order = 2,
					type = "range",
					name = L["Size"],
					min = 8,
					max = 64,
					step = 1,
				},
				point = {
					order = 3,
					type = "select",
					name = L["Anchor Point"],
					values = I.Values.positionValues,
				},
				xOffset = {
					order = 4,
					type = "range",
					name = L["X-Offset"],
					min = -64,
					max = 64,
					step = 1,
				},
				yOffset = {
					order = 5,
					type = "range",
					name = L["Y-Offset"],
					min = -64,
					max = 64,
					step = 1,
				},
				icon = {
					order = 6,
					type = "select",
					name = L["Icon"],
					values = function()
						return EM.equipmentmanager.icons
					end,
				},
				customTexture = {
					order = 7,
					type = "input",
					name = L["Custom Texture"],
					desc = L["You can use a file id or path.\nFile id as an example.\niconFileID: 3547163\n\nAlready an option but showing as a path example.\nPath: Interface\\AddOns\\ElvUI_SLE\\media\\textures\\lock"],
					width = "double",
					hidden = function()
						return E.db.mui.bags.equipmentManager.icon ~= "CUSTOM"
					end,
				},
				color = {
					order = 8,
					type = "color",
					name = COLOR,
					hasAlpha = true,
					get = function(info)
						local t = E.db.mui.bags.equipmentManager[info[#info]]
						local d = P.bags.equipmentManager[info[#info]]
						return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mui.bags.equipmentManager[info[#info]]
						t.r, t.g, t.b, t.a = r, g, b, a
						-- B:UpdateLayouts()
						-- B:UpdateAllBagSlots()
						EM:UpdateItemDisplay()
					end,
				},
			},
		},
		categorizedBags = {
			order = 2,
			type = "group",
			name = L["Categorized Bags"],
			childGroups = "tab",
			get = function(info)
				return E.db.mui.bags.categorizedBags[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.bags.categorizedBags[info[#info]] = value

				if BC.frame then
					BC.frame:Size(E.db.mui.bags.categorizedBags.width, E.db.mui.bags.categorizedBags.height)
					BC:RefreshCategoryFrame()
				end
			end,
			args = {
				general = {
					order = 1,
					type = "group",
					name = L["General"],
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Replaces ElvUI's bag frame with a category-sidebar view (Pinned/Recent items, custom categories). Requires a UI reload to take effect."],
							set = function(info, value)
								E.db.mui.bags.categorizedBags[info[#info]] = value
								E:StaticPopup_Show("PRIVATE_RL")
							end,
						},
						hideEmptyCategories = {
							order = 2,
							type = "toggle",
							name = L["Hide Empty Categories"],
						},
						showPinned = {
							order = 3,
							type = "toggle",
							name = L["Show Pinned Items"],
						},
						showRecent = {
							order = 4,
							type = "toggle",
							name = L["Show Recent Items"],
						},
						alternatingRowBackground = {
							order = 5,
							type = "toggle",
							name = L["Alternating Row Background"],
							desc = L["Shades every second sidebar category row, same as the Armory panel's alternating stat rows."],
						},
						resetCategoryGroups = {
							order = 6,
							type = "execute",
							name = L["Reset Category Groups"],
							desc = L["Restores any category group (e.g. \"Equipment\") you disbanded or removed a category from, and clears any group renames."],
							func = function()
								local db = BC.db
								db.ungroupedCategories = nil
								db.disbandedGroups = nil
								db.groupNameOverrides = nil

								BC:InvalidateCategoryCache()
								if BC.frame then
									BC:RefreshCategoryFrame()
								end
							end,
						},
						spinnerGroup = {
							order = 7,
							type = "group",
							inline = true,
							name = L["Sort Spinner"],
							desc = L["Same spinner ElvUI's own bag frame shows while sorting."],
							get = function(info)
								return E.db.mui.bags.categorizedBags.spinner[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.bags.categorizedBags.spinner[info[#info]] = value
							end,
							args = {
								enable = {
									order = 1,
									type = "toggle",
									name = L["Enable"],
								},
								size = {
									order = 2,
									type = "range",
									name = L["Size"],
									min = 20,
									max = 80,
									step = 1,
								},
								color = {
									order = 3,
									type = "color",
									name = COLOR,
									get = function(info)
										local t = E.db.mui.bags.categorizedBags.spinner[info[#info]]
										local d = P.bags.categorizedBags.spinner[info[#info]]
										return t.r, t.g, t.b, t.a, d.r, d.g, d.b
									end,
									set = function(info, r, g, b)
										local t = E.db.mui.bags.categorizedBags.spinner[info[#info]]
										t.r, t.g, t.b = r, g, b
									end,
								},
							},
						},
					},
				},
				sizes = {
					order = 2,
					type = "group",
					name = L["Sizes"],
					args = {
						bagWindow = {
							order = 1,
							type = "group",
							inline = true,
							name = L["Bag Window"],
							args = {
								itemSize = {
									order = 1,
									type = "range",
									name = L["Item Size"],
									min = 24,
									max = 48,
									step = 1,
								},
								itemSpacingH = {
									order = 2,
									type = "range",
									name = L["Item Spacing (Horizontal)"],
									min = 0,
									max = 10,
									step = 1,
								},
								itemSpacingV = {
									order = 3,
									type = "range",
									name = L["Item Spacing (Vertical)"],
									min = 0,
									max = 10,
									step = 1,
								},
								sidebarWidth = {
									order = 4,
									type = "range",
									name = L["Sidebar Width"],
									min = 100,
									max = 220,
									step = 1,
								},
								sidebarRowHeight = {
									order = 5,
									type = "range",
									name = L["Sidebar Row Height"],
									min = 18,
									max = 36,
									step = 1,
								},
								headerHeight = {
									order = 6,
									type = "range",
									name = L["Category Header Height"],
									min = 16,
									max = 32,
									step = 1,
								},
								sectionSpacing = {
									order = 7,
									type = "range",
									name = L["Spacing Between Categories"],
									min = 0,
									max = 32,
									step = 1,
								},
								width = {
									order = 8,
									type = "range",
									name = L["Width"],
									min = 380,
									max = 900,
									step = 1,
								},
								height = {
									order = 9,
									type = "range",
									name = L["Height"],
									min = 300,
									max = 800,
									step = 1,
								},
							},
						},
						bankWindow = {
							order = 2,
							type = "group",
							inline = true,
							name = L["Bank Window"],
							get = function(info)
								return E.db.mui.bags.categorizedBags[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.bags.categorizedBags[info[#info]] = value

								if BC.bankFrame then
									BC.bankFrame:Size(
										E.db.mui.bags.categorizedBags.bankWidth,
										E.db.mui.bags.categorizedBags.bankHeight
									)
									BC:RefreshBankCategoryFrame()
								end
							end,
							args = {
								bankSidebarWidth = {
									order = 1,
									type = "range",
									name = L["Sidebar Width"],
									min = 100,
									max = 220,
									step = 1,
								},
								bankWidth = {
									order = 2,
									type = "range",
									name = L["Width"],
									min = 380,
									max = 900,
									step = 1,
								},
								bankHeight = {
									order = 3,
									type = "range",
									name = L["Height"],
									min = 300,
									max = 800,
									step = 1,
								},
							},
						},
					},
				},
				fonts = {
					order = 3,
					type = "group",
					name = L["Fonts"],
					args = {
						itemCountFont = {
							order = 1,
							type = "group",
							inline = true,
							name = L["Item Count"],
							get = function(info)
								return E.db.mui.bags.categorizedBags.itemCountFont[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.bags.categorizedBags.itemCountFont[info[#info]] = value
								if BC.frame then
									BC:RefreshCategoryFrame()
								end
							end,
							args = {
								name = {
									order = 1,
									type = "select",
									dialogControl = "LSM30_Font",
									name = L["Font"],
									values = E.LSM:HashTable("font"),
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
									type = "range",
									name = L["Size"],
									min = 6,
									max = 24,
									step = 1,
								},
								position = {
									order = 4,
									type = "select",
									name = L["Position"],
									values = I.Values.positionValues,
								},
							},
						},
						itemLevel = {
							order = 2,
							type = "group",
							inline = true,
							name = L["Item Level"],
							get = function(info)
								return E.db.mui.bags.categorizedBags.itemLevel[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.bags.categorizedBags.itemLevel[info[#info]] = value
								if BC.frame then
									BC:RefreshCategoryFrame()
								end
							end,
							args = {
								enable = {
									order = 1,
									type = "toggle",
									name = L["Enable"],
									width = "full",
								},
								font = {
									order = 2,
									type = "group",
									inline = true,
									name = L["Font"],
									disabled = function()
										return not E.db.mui.bags.categorizedBags.itemLevel.enable
									end,
									get = function(info)
										return E.db.mui.bags.categorizedBags.itemLevel.font[info[#info]]
									end,
									set = function(info, value)
										E.db.mui.bags.categorizedBags.itemLevel.font[info[#info]] = value
										if BC.frame then
											BC:RefreshCategoryFrame()
										end
									end,
									args = {
										name = {
											order = 1,
											type = "select",
											dialogControl = "LSM30_Font",
											name = L["Font"],
											values = E.LSM:HashTable("font"),
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
											type = "range",
											name = L["Size"],
											min = 6,
											max = 24,
											step = 1,
										},
										position = {
											order = 4,
											type = "select",
											name = L["Position"],
											values = I.Values.positionValues,
										},
									},
								},
							},
						},
						itemInfo = {
							order = 3,
							type = "group",
							inline = true,
							name = L["Item Info"],
							get = function(info)
								return E.db.mui.bags.categorizedBags.itemInfo[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.bags.categorizedBags.itemInfo[info[#info]] = value
								if BC.frame then
									BC:RefreshCategoryFrame()
								end
							end,
							args = {
								enable = {
									order = 1,
									type = "toggle",
									name = L["Enable"],
									desc = L["Shows a bind-type indicator (BoE, BoU, ...) on items that aren't bound yet."],
									width = "full",
								},
								font = {
									order = 2,
									type = "group",
									inline = true,
									name = L["Font"],
									disabled = function()
										return not E.db.mui.bags.categorizedBags.itemInfo.enable
									end,
									get = function(info)
										return E.db.mui.bags.categorizedBags.itemInfo.font[info[#info]]
									end,
									set = function(info, value)
										E.db.mui.bags.categorizedBags.itemInfo.font[info[#info]] = value
										if BC.frame then
											BC:RefreshCategoryFrame()
										end
									end,
									args = {
										name = {
											order = 1,
											type = "select",
											dialogControl = "LSM30_Font",
											name = L["Font"],
											values = E.LSM:HashTable("font"),
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
											type = "range",
											name = L["Size"],
											min = 6,
											max = 24,
											step = 1,
										},
										position = {
											order = 4,
											type = "select",
											name = L["Position"],
											values = I.Values.positionValues,
										},
									},
								},
							},
						},
					},
				},
				effects = {
					order = 4,
					type = "group",
					name = L["Effects"],
					get = function(info)
						return E.db.mui.bags.categorizedBags.effects[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.bags.categorizedBags.effects[info[#info]] = value

						if BC.frame then
							BC:RefreshCategoryFrame()
						end
						if BC.bankFrame and BC.RefreshBankCategoryFrame then
							BC:RefreshBankCategoryFrame()
						end
					end,
					args = {
						fade = {
							order = 1,
							type = "toggle",
							name = L["Fade Windows"],
							desc = L["Fades the bag and bank windows in when opened and out when closed."],
						},
						fadeDuration = {
							order = 2,
							type = "range",
							name = L["Fade Duration"],
							min = 0.05,
							max = 0.5,
							step = 0.01,
							disabled = function()
								return not E.db.mui.bags.categorizedBags.effects.fade
							end,
						},
						newItemGlow = {
							order = 3,
							type = "toggle",
							name = L["New Item Glow"],
							desc = L["Pulsing glow on newly picked-up items."],
						},
						placeholderAlpha = {
							order = 4,
							type = "range",
							name = L["Empty Slot Opacity"],
							desc = L["Opacity of the empty drop-target slots at the end of each category (the first \"+\" slot always stays fully visible)."],
							min = 0,
							max = 1,
							step = 0.05,
							isPercent = true,
						},
						warboundMarker = {
							order = 7,
							type = "toggle",
							name = L["Warbound Marker"],
							desc = L["Shows a small Warband icon on items that are Warbound or Warbound until equipped."],
						},
						hoverClassColor = {
							order = 5,
							type = "toggle",
							name = L["Use Class Color"],
							desc = L["Tints the item slot hover highlight in your class color."],
						},
						hoverColor = {
							order = 6,
							type = "color",
							name = L["Hover Color"],
							disabled = function()
								return E.db.mui.bags.categorizedBags.effects.hoverClassColor
							end,
							get = function(info)
								local t = E.db.mui.bags.categorizedBags.effects[info[#info]]
								local d = P.bags.categorizedBags.effects[info[#info]]
								return t.r, t.g, t.b, 1, d.r, d.g, d.b
							end,
							set = function(info, r, g, b)
								local t = E.db.mui.bags.categorizedBags.effects[info[#info]]
								t.r, t.g, t.b = r, g, b

								if BC.frame then
									BC:RefreshCategoryFrame()
								end
								if BC.bankFrame and BC.RefreshBankCategoryFrame then
									BC:RefreshBankCategoryFrame()
								end
							end,
						},
					},
				},
			},
		},
	},
}
