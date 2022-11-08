local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Armory')
local options = MER.options.modules.args
local M = E.Misc
local LSM = E.LSM

local _G = _G
local select = select

local PaperDollFrame_UpdateStats = PaperDollFrame_UpdateStats
local UnitPowerType = UnitPowerType

local fontStyleList = {
	["NONE"] = NONE,
	["OUTLINE"] = 'OUTLINE',
	["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
	["THICKOUTLINE"] = 'THICKOUTLINE'
}

options.armory = {
	type = "group",
	name = L["Armory"],
	-- disabled = function() return not E.db.general.itemLevel.displayCharacterInfo end,
	childGroups = "tab",
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Armory"], 'orange'),
		},
		character = {
			order = 2,
			type = "group",
			name = L["Character Armory"],
			desc = "",
			get = function(info) return E.db.mui.armory.character[ info[#info] ] end,
			set = function(info, value) E.db.mui.armory.character[ info[#info] ] = value;
				E:StaticPopup_Show("PRIVATE_RL")
				M:UpdatePageInfo(_G.CharacterFrame, 'Character')

				if not E.db.general.itemLevel.displayCharacterInfo then
					M:ClearPageInfo(_G.CharacterFrame, 'Character')
				end
			end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = F.cOption(L["Character Armory"], 'orange'),
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."],
				},
				information = {
					order = 2,
					type = "description",
					name = L["ARMORY_DESC"],
					hidden = function() return not E.Retail end,
				},
				undressButton = {
					order = 3,
					type = "toggle",
					name = L["Undress Button"],
					disabled = function() return not E.db.mui.armory.character.enable or not E.db.general.itemLevel.displayCharacterInfo end,
					hidden = function() return not E.Retail end,
				},
				expandSize = {
					order = 4,
					type = "toggle",
					name = L["Expanded Size"],
					desc = L["This will increase the Character Frame size a bit."],
					disabled = function() return not E.db.mui.armory.character.enable or not E.db.general.itemLevel.displayCharacterInfo end,
					hidden = function() return not E.Retail end,
				},
				classIcon = {
					order = 5,
					type = "toggle",
					name = L["Class Icon"],
					desc = L["Adds an class icon next to the name."],
					disabled = function() return not E.db.mui.armory.character.enable or not E.db.general.itemLevel.displayCharacterInfo end,
					hidden = function() return not E.Retail end,
				},
				spacer = {
					order = 7,
					type = "description",
					name = ""
				},
				durability = {
					order = 8,
					type = "group",
					name = L["Durability"],
					disabled = function() return not E.db.mui.armory.character.enable or not E.db.general.itemLevel.displayCharacterInfo end,
					get = function(info) return E.db.mui.armory.character.durability[ info[#info] ] end,
					set = function(info, value) E.db.mui.armory.character.durability[info[#info]] = value; module:UpdatePaperDoll() end,
					hidden = function() return not E.Retail end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = L["Enable"],
							desc = L["Enable/Disable the display of durability information on the character window."],
						},
						onlydamaged = {
							type = "toggle",
							order = 2,
							name = L["Damaged Only"],
							desc = L["Only show durability information for items that are damaged."],
							disabled = function() return not E.db.mui.armory.character.enable or not E.db.mui.armory.character.durability.enable end,
						},
						font = {
							order = 3,
							type = "select", dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
							disabled = function() return not E.db.mui.armory.character.enable or not E.db.mui.armory.character.durability.enable end,
							set = function(info, value) E.db.mui.armory.character.durability[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						},
						textSize = {
							order = 4,
							name = FONT_SIZE,
							type = "range",
							min = 6, max = 22, step = 1,
							disabled = function() return not E.db.mui.armory.character.enable or not E.db.mui.armory.character.durability.enable end,
							set = function(info, value) E.db.mui.armory.character.durability[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						},
						fontOutline = {
							order = 5,
							type = "select",
							name = L["Font Outline"],
							values = fontStyleList,
							disabled = function() return not E.db.mui.armory.character.enable or not E.db.mui.armory.character.durability.enable end,
							set = function(info, value) E.db.mui.armory.character.durability[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						},
					},
				},
				gradient = {
					order = 9,
					type = 'group',
					name = L["Gradient"],
					disabled = function() return not E.db.mui.armory.character.enable or not E.db.general.itemLevel.displayCharacterInfo end,
					hidden = function() return not E.Retail end,
					get = function(info) return E.db.mui.armory.character.gradient[ info[#info] ] end,
					set = function(info, value) E.db.mui.armory.character.gradient[ info[#info] ] = value; module:UpdatePaperDoll() end,
					args = {
						enable = {
							type = 'toggle',
							name = L["Enable"],
							order = 1,
						},
						colorStyle = {
							order = 2,
							type = "select",
							name = COLOR,
							values = {
								["RARITY"] = RARITY,
								["VALUE"] = L["Value"],
								["CUSTOM"] = CUSTOM,
							},
						},
						color = {
							order = 3,
							type = "color",
							name = COLOR_PICKER,
							disabled = function() return E.db.mui.armory.character.gradient.colorStyle == "RARITY" or E.db.mui.armory.character.gradient.colorStyle == "VALUE" or not E.db.mui.armory.character.enable or not E.db.mui.armory.character.gradient.enable end,
							get = function(info)
								local t = E.db.mui.armory.character.gradient[ info[#info] ]
								local d = P.armory.character.gradient[info[#info]]
								return t.r, t.g, t.b, d.r, d.g, d.b
							end,
							set = function(info, r, g, b)
								E.db.mui.armory.character.gradient[ info[#info] ] = {}
								local t = E.db.mui.armory.character.gradient[ info[#info] ]
								t.r, t.g, t.b = r, g, b
								module:UpdatePaperDoll()
							end,
						},
						setArmor = {
							order = 4,
							type = 'toggle',
							name = L["Armor Set"],
							desc = L["Colors Set Items in a different color."],
						},
						setArmorColor = {
							order = 6,
							type = 'color',
							name = L["Armor Set Gradient Texture Color"],
							get = function(info)
								local t = E.db.mui.armory.character.gradient[ info[#info] ]
								local d = P.armory.character.gradient[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b, a)
								E.db.mui.armory.character.gradient[ info[#info] ] = {}
								local t = E.db.mui.armory.character.gradient[ info[#info] ]
								t.r, t.g, t.b, t.a = r, g, b, a
								module:UpdatePaperDoll()
							end,
							disabled = function() return not E.db.mui.armory.character.enable or not E.db.general.itemLevel.displayCharacterInfo or not E.db.mui.armory.character.gradient.setArmor end,
						},
						warningColor = {
							order = 7,
							type = 'color',
							name = L["Warning Gradient Texture Color"],
							get = function(info)
								local t = E.db.mui.armory.character.gradient[ info[#info] ]
								local d = P.armory.character.gradient[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b, a)
								E.db.mui.armory.character.gradient[ info[#info] ] = {}
								local t = E.db.mui.armory.character.gradient[ info[#info] ]
								t.r, t.g, t.b, t.a = r, g, b, a
								module:UpdatePaperDoll()
							end,
							disabled = function() return not E.db.mui.armory.character.enable or not E.db.general.itemLevel.displayCharacterInfo end,
						},
					},
				},
				indicators = {
					order = 10,
					type = "group",
					name = L["Indicators"],
					hidden = function() return not E.Retail end,
					disabled = function() return not E.db.mui.armory.character.enable or not E.db.general.itemLevel.displayCharacterInfo end,
					args = {
						transmog = {
							order = 1,
							type = "group",
							name = L["Transmog"],
							get = function(info) return E.db.mui.armory.character.transmog[ info[#info] ] end,
							set = function(info, value) E.db.mui.armory.character.transmog[ info[#info] ] = value; module:UpdatePaperDoll() end,
							args = {
								enable = {
									type = "toggle",
									order = 1,
									name = L["Enable"],
									desc = L["Shows an arrow indictor for currently transmogrified items."],
								},
							},
						},
						illusion = {
							order = 2,
							type = "group",
							name = L["Illusion"],
							get = function(info) return E.db.mui.armory.character.illusion[ info[#info] ] end,
							set = function(info, value) E.db.mui.armory.character.illusion[ info[#info] ] = value; module:UpdatePaperDoll() end,
							args = {
								enable = {
									type = "toggle",
									order = 1,
									name = L["Enable"],
									desc = L["Shows an indictor for weapon illusions."],
								},
							},
						},
						warning = {
							order = 3,
							type = "group",
							name = L["Warnings"],
							desc = L["Shows an indicator for missing sockets and enchants."],
							get = function(info) return E.db.mui.armory.character.warning[ info[#info] ] end,
							set = function(info, value) E.db.mui.armory.character.warning[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
							args = {
								enable = {
									type = "toggle",
									order = 1,
									name = L["Enable"],
									desc = L["Shows an arrow indictor for currently transmogrified items."],
								},
							},
						},
					},
				},
			},
		},
		Inspect = {
			order = 3,
			type = "group",
			name = L["Inspect Armory"],
			desc = "",
			hidden = function() return not E.Retail end,
			get = function(info) return E.db.mui.armory.inspect[ info[#info] ] end,
			set = function(info, value)
				E.db.mui.armory.inspect.enable = value;
				E:StaticPopup_Show("PRIVATE_RL");
				M:UpdatePageInfo(_G.InspectFrame, 'Inspect')

				if not E.db.general.itemLevel.displayCharacterInfo then
					M:ClearPageInfo(_G.InspectFrame, 'Inspect')
				end
			end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = F.cOption(L["Inspect Armory"], 'orange'),
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."],
				},
				information = {
					order = 2,
					type = "description",
					name = L["ARMORY_DESC"],
				},
				gradient = {
					order = 3,
					type = 'group',
					name = L["Gradient"],
					disabled = function() return not E.db.mui.armory.inspect.enable or not E.db.general.itemLevel.displayCharacterInfo end,
					get = function(info) return E.db.mui.armory.inspect.gradient[ info[#info] ] end,
					set = function(info, value) E.db.mui.armory.inspect.gradient[ info[#info] ] = value; module:UpdateInspect() end,
					args = {
						enable = {
							type = 'toggle',
							name = L["Enable"],
							order = 1,
							disabled = function() return not E.db.mui.armory.inspect.enable or not E.db.general.itemLevel.displayCharacterInfo end,
						},
						colorStyle = {
							order = 2,
							type = "select",
							name = COLOR,
							disabled = function() return not E.db.mui.armory.inspect.enable or not E.db.general.itemLevel.displayCharacterInfo end,
							values = {
								["RARITY"] = RARITY,
								["VALUE"] = L["Value"],
								["CUSTOM"] = CUSTOM,
							},
						},
						color = {
							order = 3,
							type = "color",
							name = COLOR_PICKER,
							disabled = function() return E.db.mui.armory.inspect.gradient.colorStyle == "RARITY" or E.db.mui.armory.inspect.gradient.colorStyle == "VALUE" or not E.db.mui.armory.inspect.enable or not E.db.mui.armory.inspect.gradient.enable end,
							get = function(info)
								local t = E.db.mui.armory.inspect.gradient[ info[#info] ]
								local d = P.armory.inspect.gradient[info[#info]]
								return t.r, t.g, t.b, d.r, d.g, d.b
							end,
							set = function(info, r, g, b)
								E.db.mui.armory.inspect.gradient[ info[#info] ] = {}
								local t = E.db.mui.armory.inspect.gradient[ info[#info] ]
								t.r, t.g, t.b = r, g, b
								module:UpdateInspect()
							end,
						},
						setArmor = {
							order = 4,
							type = 'toggle',
							name = L["Armor Set"],
							desc = L["Colors Set Items in a different color."],
							disabled = function() return not E.db.mui.armory.inspect.enable or not E.db.general.itemLevel.displayCharacterInfo end,
						},
						setArmorColor = {
							order = 6,
							type = 'color',
							name = L["Armor Set Gradient Texture Color"],
							disabled = function() return not E.db.mui.armory.inspect.enable or not E.db.general.itemLevel.displayCharacterInfo end,
							get = function(info)
								local t = E.db.mui.armory.inspect.gradient[ info[#info] ]
								local d = P.armory.inspect.gradient[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b, a)
								E.db.mui.armory.inspect.gradient[ info[#info] ] = {}
								local t = E.db.mui.armory.inspect.gradient[ info[#info] ]
								t.r, t.g, t.b, t.a = r, g, b, a
								module:UpdateInspect()
							end,
							disabled = function() return not E.db.mui.armory.inspect.enable or not E.db.general.itemLevel.displayCharacterInfo or not E.db.mui.armory.inspect.gradient.setArmor end,
						},
						warningColor = {
							order = 7,
							type = 'color',
							name = L["Warning Gradient Texture Color"],
							disabled = function() return not E.db.mui.armory.inspect.enable or not E.db.general.itemLevel.displayCharacterInfo end,
							get = function(info)
								local t = E.db.mui.armory.inspect.gradient[ info[#info] ]
								local d = P.armory.inspect.gradient[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b, a)
								E.db.mui.armory.inspect.gradient[ info[#info] ] = {}
								local t = E.db.mui.armory.inspect.gradient[ info[#info] ]
								t.r, t.g, t.b, t.a = r, g, b, a
								module:UpdatePaperDoll()
							end,
							disabled = function() return not E.db.mui.armory.inspect.enable or not E.db.general.itemLevel.displayCharacterInfo end,
						},
					},
				},
			},
		},
		stats = {
			type = 'group',
			name = STAT_CATEGORY_ATTRIBUTES,
			order = 22,
			disabled = function() return not E.db.mui.armory.character.enable or not E.db.general.itemLevel.displayCharacterInfo end,
			hidden = function() return not E.Retail end,
			get = function(info) return E.db.mui.armory.stats[ info[#info] ] end,
			set = function(info, value) E.db.mui.armory.stats[ info[#info] ] = value; PaperDollFrame_UpdateStats(); M:UpdateCharacterItemLevel() E:StaticPopup_Show("PRIVATE_RL") end,
			args = {
				enable = {
					order = 1,
					type = 'toggle',
					name = L["Enable"],
				},
				OnlyPrimary = {
					order = 2,
					type = "toggle",
					name = L["Only Relevant Stats"],
					desc = L["Show only those primary stats relevant to your spec."],
					disabled = function() return not E.db.mui.armory.stats.enable end,
				},
				classColorGradient = {
					order = 3,
					type = "toggle",
					name = L["Class Color Gradient"],
					get = function(info) return E.db.mui.armory.stats[info[#info]] end,
					set = function(info, value) E.db.mui.armory.stats[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				},
				color = {
					order = 4,
					type = "color",
					name = COLOR_PICKER,
					disabled = function() return E.db.mui.armory.stats.classColorGradient end,
					get = function(info)
						local t = E.db.mui.armory.stats[ info[#info] ]
						local d = P.armory.stats[info[#info]]
						return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
					end,
					set = function(info, r, g, b, a)
						E.db.mui.armory.stats[ info[#info] ] = {}
						local t = E.db.mui.armory.stats[ info[#info] ]
						t.r, t.g, t.b, t.a = r, g, b, a
						E:StaticPopup_Show("PRIVATE_RL")
					end,
				},
				ItemLevel = {
					order = 5,
					type = 'group',
					name = STAT_AVERAGE_ITEM_LEVEL,
					guiInline = true,
					disabled = function() return not E.db.mui.armory.stats.enable end,
					args = {
						IlvlFull = {
							order = 1,
							type = 'toggle',
							name = L["Full Item Level"],
							desc = L["Show both equipped and average item levels."],
						},
						IlvlColor = {
							order = 2,
							type = 'toggle',
							name = L["Item Level Coloring"],
							desc = L["Color code item levels values. Equipped will be gradient, average - selected color."],
							disabled = function() return not E.db.mui.armory.stats.IlvlFull end,
						},
						AverageColor = {
							type = 'color',
							order = 3,
							name = L["Color of Average"],
							desc = L["Sets the color of average item level."],
							hasAlpha = false,
							disabled = function() return not E.db.mui.armory.stats.IlvlFull end,
							get = function(info)
								local t = E.db.mui.armory.stats[info[#info]]
								local d = P.armory.stats[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b, a)
								E.db.mui.armory.stats[info[#info]] = {}
								local t = E.db.mui.armory.stats[info[#info]]
								t.r, t.g, t.b, t.a = r, g, b, a
								M:UpdateCharacterItemLevel()
								module:PaperDollFrame_UpdateStats()
							end,
						},
					},
				},
				Stats = {
					order = 6,
					type = 'group',
					name = STAT_CATEGORY_ATTRIBUTES,
					guiInline = true,
					get = function(info) return E.db.mui.armory.stats.List[ info[#info] ] end,
					set = function(info, value) E.db.mui.armory.stats.List[ info[#info] ] = value; PaperDollFrame_UpdateStats(); M:UpdateCharacterItemLevel() end,
					disabled = function() return not E.db.mui.armory.stats.enable end,
					args = {
						HEALTH = { order = 1, type = "toggle", name = HEALTH,},
						POWER = { order = 2, type = "toggle", name = function() local power = _G[select(2, UnitPowerType('player'))] or L["Power"]; return power end},
						ALTERNATEMANA = { order = 3, type = "toggle", name = ALTERNATE_RESOURCE_TEXT,},
						ATTACK_DAMAGE = { order = 4, type = "toggle", name = DAMAGE,},
						ATTACK_AP = { order = 5, type = "toggle", name = ATTACK_POWER,},
						ATTACK_ATTACKSPEED = { order = 6, type = "toggle", name = ATTACK_SPEED,},
						SPELLPOWER = { order = 7, type = "toggle", name = STAT_SPELLPOWER,},
						ENERGY_REGEN = { order = 8, type = "toggle", name = STAT_ENERGY_REGEN,},
						RUNE_REGEN = { order = 9, type = "toggle", name = STAT_RUNE_REGEN,},
						FOCUS_REGEN = { order = 10, type = "toggle", name = STAT_FOCUS_REGEN,},
						MOVESPEED = { order = 11, type = "toggle", name = STAT_SPEED,},
					},
				},
			},
		},
		Fonts = {
			type = "group",
			name = STAT_CATEGORY_ATTRIBUTES..": "..L["Fonts"],
			order = 23,
			hidden = function() return not E.Retail end,
			args = {
				statFonts = {
					type = 'group',
					name = STAT_CATEGORY_ATTRIBUTES,
					order = 1,
					guiInline = true,
					get = function(info) return E.db.mui.armory.stats.statFonts[ info[#info] ] end,
					set = function(info, value) E.db.mui.armory.stats.statFonts[ info[#info] ] = value; module:PaperDollFrame_UpdateStats() end,
					args = {
						font = {
							type = 'select', dialogControl = 'LSM30_Font',
							name = L["Font"],
							order = 1,
							values = LSM:HashTable("font"),
						},
						size = {
							type = 'range',
							name = L["Font Size"],
							order = 2,
							min = 6, max = 22, step = 1,
						},
						outline = {
							type = 'select',
							name = L["Font Outline"],
							order = 3,
							values = fontStyleList,
						},
					},
				},
				catFonts = {
					type = 'group',
					name = L["Categories"],
					order = 2,
					guiInline = true,
					get = function(info) return E.db.mui.armory.stats.catFonts[ info[#info] ] end,
					set = function(info, value) E.db.mui.armory.stats.catFonts[ info[#info] ] = value; module:PaperDollFrame_UpdateStats() end,
					args = {
						font = {
							type = 'select', dialogControl = 'LSM30_Font',
							name = L["Font"],
							order = 1,
							values = LSM:HashTable("font"),
						},
						size = {
							type = 'range',
							name = L["Font Size"],
							order = 2,
							min = 6, max = 22, step = 1,
						},
						outline = {
							type = 'select',
							name = L["Font Outline"],
							order = 3,
							values = fontStyleList,
						},
					},
				},
			},
		},
	},
}
