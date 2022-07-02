local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Armory')
local options = MER.options.modules.args
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
	disabled = function() return not E.db.general.itemLevel.displayCharacterInfo end,
	get = function(info) return E.db.mui.armory[ info[#info] ] end,
	set = function(info, value) E.db.mui.armory[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Armory"], 'orange'),
		},
		enable = {
			type = "toggle",
			order = 2,
			name = L["Enable"],
			desc = L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."],
		},
		undressButton = {
			type = "toggle",
			order = 3,
			name = L["Undress Button"],
		},
		spacer = {
			type = "description",
			order = 8,
			name = ""
		},
		information = {
			type = "description",
			order = 9,
			name = L["ARMORY_DESC"],
		},
		durability = {
			order = 20,
			type = "group",
			name = L["Durability"],
			disabled = function() return not E.db.mui.armory.enable or not E.db.general.itemLevel.displayCharacterInfo end,
			get = function(info) return E.db.mui.armory.durability[ info[#info] ] end,
			set = function(info, value) E.db.mui.armory.durability[ info[#info] ] = value; module:UpdatePaperDoll() end,
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
					disabled = function() return not E.db.mui.armory.enable or not E.db.mui.armory.durability.enable end,
				},
				font = {
					order = 3,
					type = "select", dialogControl = "LSM30_Font",
					name = L["Font"],
					values = LSM:HashTable("font"),
					disabled = function() return not E.db.mui.armory.enable or not E.db.mui.armory.durability.enable end,
					set = function(info, value) E.db.mui.armory.durability[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				},
				textSize = {
					order = 4,
					name = FONT_SIZE,
					type = "range",
					min = 6, max = 22, step = 1,
					disabled = function() return not E.db.mui.armory.enable or not E.db.mui.armory.durability.enable end,
					set = function(info, value) E.db.mui.armory.durability[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				},
				fontOutline = {
					order = 5,
					type = "select",
					name = L["Font Outline"],
					values = fontStyleList,
					disabled = function() return not E.db.mui.armory.enable or not E.db.mui.armory.durability.enable end,
					set = function(info, value) E.db.mui.armory.durability[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				},
			},
		},
		stats = {
			type = 'group',
			name = STAT_CATEGORY_ATTRIBUTES,
			order = 22,
			disabled = function() return not E.db.mui.armory.enable or not E.db.general.itemLevel.displayCharacterInfo end,
			get = function(info) return E.db.mui.armory.stats[ info[#info] ] end,
			set = function(info, value) E.db.mui.armory.stats[ info[#info] ] = value; PaperDollFrame_UpdateStats() end,
			args = {
				OnlyPrimary = {
					order = 1,
					type = "toggle",
					name = L["Only Relevant Stats"],
					desc = L["Show only those primary stats relevant to your spec."],
				},
				Stats = {
					type = 'group',
					name = STAT_CATEGORY_ATTRIBUTES,
					order = 2,
					guiInline = true,
					get = function(info) return E.db.mui.armory.stats.List[ info[#info] ] end,
					set = function(info, value) E.db.mui.armory.stats.List[ info[#info] ] = value; module:ToggleStats() end,
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
		gradient = {
			order = 24,
			type = 'group',
			name = L["Gradient"],
			disabled = function() return not E.db.mui.armory.enable or not E.db.general.itemLevel.displayCharacterInfo end,
			get = function(info) return E.db.mui.armory.gradient[ info[#info] ] end,
			set = function(info, value) E.db.mui.armory.gradient[ info[#info] ] = value; module:UpdatePaperDoll() end,
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
					disabled = function() return E.db.mui.armory.gradient.colorStyle == "RARITY" or E.db.mui.armory.gradient.colorStyle == "VALUE" or not E.db.mui.armory.enable or not E.db.mui.armory.gradient.enable end,
					get = function(info)
						local t = E.db.mui.armory.gradient[ info[#info] ]
						local d = P.armory.gradient[info[#info]]
						return t.r, t.g, t.b, d.r, d.g, d.b
					end,
					set = function(info, r, g, b)
						E.db.mui.armory.gradient[ info[#info] ] = {}
						local t = E.db.mui.armory.gradient[ info[#info] ]
						t.r, t.g, t.b = r, g, b
						module:UpdatePaperDoll()
					end,
				},
			},
		},
		indicators = {
			order = 25,
			type = "group",
			name = L["Indicators"],
			disabled = function() return not E.db.mui.armory.enable or not E.db.general.itemLevel.displayCharacterInfo end,
			args = {
				transmog = {
					order = 1,
					type = "group",
					name = L["Transmog"],
					get = function(info) return E.db.mui.armory.transmog[ info[#info] ] end,
					set = function(info, value) E.db.mui.armory.transmog[ info[#info] ] = value; module:UpdatePaperDoll() end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = L["Enable"],
							desc = L["Shows an arrow indictor for currently transmogrified items."],
						},
					},
				},
				-- illusion = {
					-- order = 2,
					-- type = "group",
					-- name = L["Illusion"],
					-- get = function(info) return E.db.mui.armory.illusion[ info[#info] ] end,
					-- set = function(info, value) E.db.mui.armory.illusion[ info[#info] ] = value; module:UpdatePaperDoll() end,
					-- args = {
						-- enable = {
							-- type = "toggle",
							-- order = 1,
							-- name = L["Enable"],
							-- desc = L["Shows an indictor for weapon illusions."],
						-- },
					-- },
				-- },
				warning = {
					order = 3,
					type = "group",
					name = L["Warnings"],
					desc = L["Shows an indicator for missing sockets and enchants."],
					get = function(info) return E.db.mui.armory.warning[ info[#info] ] end,
					set = function(info, value) E.db.mui.armory.warning[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
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
}
