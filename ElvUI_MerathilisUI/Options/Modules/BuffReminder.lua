local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local BR = MER:GetModule("MER_BuffReminder")

local options = module.options.modules.args

local RESTYLE_KEYS = {
	textSize = true,
	textOutline = true,
	frameStrata = true,
}

local function Get(info)
	return E.db.mui.buffReminder[info[#info]]
end

local function Set(info, value)
	local key = info[#info]
	E.db.mui.buffReminder[key] = value

	if key == "enable" then
		E:StaticPopup_Show("GLOBAL_RL")
		return
	end

	if RESTYLE_KEYS[key] then
		BR:RestyleIcons()
	end
	BR:RequestRefresh()
end

local function BuildToggleArgs(list, sectionPath)
	local args = {}
	for i, item in ipairs(list) do
		args[item.key] = {
			order = i,
			type = "toggle",
			name = item.name,
			get = function()
				return F.GetDBFromPath(sectionPath)[item.key]
			end,
			set = function(_, value)
				F.GetDBFromPath(sectionPath)[item.key] = value
				BR:RequestRefresh()
			end,
		}
	end
	return args
end

local RAID_BUFF_TOGGLES = {
	{ key = "motw", name = L["Mark of the Wild"] },
	{ key = "bshout", name = L["Battle Shout"] },
	{ key = "fort", name = L["Power Word: Fortitude"] },
	{ key = "ai", name = L["Arcane Intellect"] },
	{ key = "bronze", name = L["Blessing of the Bronze"] },
	{ key = "sky", name = L["Skyfury"] },
}

local AURA_TOGGLES = {
	{ key = "symbiotic", name = L["Symbiotic Relationship"] },
	{ key = "battle_stance", name = L["Battle Stance"] },
	{ key = "berserk_stance", name = L["Berserker Stance"] },
	{ key = "def_stance", name = L["Defensive Stance"] },
	{ key = "shadowform", name = L["Shadowform"] },
	{ key = "devo_aura", name = L["Devotion Aura"] },
}

local CONSUMABLE_TOGGLES = {
	{ key = "flask", name = L["Flask"] },
	{ key = "food", name = L["Food"] },
	{ key = "augment_rune", name = L["Augment Rune"] },
	{ key = "weapon_enchant", name = L["Weapon Enchant"] },
	{ key = "deadly", name = L["Deadly Poison"] },
	{ key = "instant", name = L["Instant Poison"] },
	{ key = "wound", name = L["Wound Poison"] },
	{ key = "amplifying", name = L["Amplifying Poison"] },
	{ key = "crippling", name = L["Crippling Poison"] },
	{ key = "numbing", name = L["Numbing Poison"] },
	{ key = "atrophic", name = L["Atrophic Poison"] },
	{ key = "rite_adj", name = L["Rite of Adjuration"] },
	{ key = "rite_sanc", name = L["Rite of Sanctification"] },
	{ key = "flametongue", name = L["Flametongue Weapon"] },
	{ key = "windfury", name = L["Windfury Weapon"] },
	{ key = "earthliving", name = L["Earthliving Weapon"] },
	{ key = "tidecaller", name = L["Tidecaller's Guard"] },
	{ key = "tstrike", name = L["Thunderstrike Ward"] },
	{ key = "shield_basic", name = L["Shield"] },
}

options.buffReminder = {
	type = "group",
	name = module:AddCategorieIcon(L["Buff Reminder"], "buff_reminder"),
	get = Get,
	set = Set,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Buff Reminder"], "orange"),
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			width = "full",
		},
		general = {
			order = 3,
			type = "group",
			name = L["General"],
			guiInline = true,
			args = {
				hideInOpenWorld = {
					order = 1,
					type = "toggle",
					name = L["Hide in Open World"],
					desc = L["Only show reminders inside dungeons, raids and scenarios."],
				},
				hideWhileMounted = {
					order = 2,
					type = "toggle",
					name = L["Hide while Mounted/Flying"],
				},
				showUnder = {
					order = 3,
					type = "range",
					name = L["Remind Under (minutes)"],
					desc = L["Also remind when a tracked consumable buff is about to expire within this many minutes."],
					min = 1,
					max = 30,
					step = 1,
				},
				scale = {
					order = 4,
					type = "range",
					name = L["Scale"],
					min = 0.5,
					max = 3,
					step = 0.05,
				},
				iconSpacing = {
					order = 5,
					type = "range",
					name = L["Icon Spacing"],
					min = 0,
					max = 30,
					step = 1,
				},
				frameStrata = {
					order = 6,
					type = "select",
					name = L["Frame Strata"],
					values = {
						BACKGROUND = "BACKGROUND",
						LOW = "LOW",
						MEDIUM = "MEDIUM",
						HIGH = "HIGH",
						DIALOG = "DIALOG",
					},
				},
				showText = {
					order = 7,
					type = "toggle",
					name = L["Show Text"],
				},
				textSize = {
					order = 8,
					type = "range",
					name = L["Text Size"],
					min = 6,
					max = 30,
					step = 1,
				},
				textOutline = {
					order = 9,
					type = "select",
					name = L["Text Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
				},
				showBagCount = {
					order = 10,
					type = "toggle",
					name = L["Show Bag Count"],
				},
				glowEnable = {
					order = 11,
					type = "toggle",
					name = L["Enable Glow"],
				},
				glowColor = {
					order = 12,
					type = "color",
					name = L["Glow Color"],
					hasAlpha = false,
					get = function()
						local t = E.db.mui.buffReminder.glowColor
						local d = P.buffReminder.glowColor
						return t.r, t.g, t.b, nil, d.r, d.g, d.b, nil
					end,
					set = function(_, r, g, b)
						local t = E.db.mui.buffReminder.glowColor
						t.r, t.g, t.b = r, g, b
						BR:RequestRefresh()
					end,
				},
			},
		},
		sound = {
			order = 4,
			type = "group",
			name = L["Sounds"],
			guiInline = true,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function() return E.db.mui.buffReminder.sound.enable end,
					set = function(_, value) E.db.mui.buffReminder.sound.enable = value end,
				},
				raidBuffs = {
					order = 2,
					type = "toggle",
					name = L["Raid Buffs"],
					get = function() return E.db.mui.buffReminder.sound.raidBuffs end,
					set = function(_, value) E.db.mui.buffReminder.sound.raidBuffs = value end,
				},
				auras = {
					order = 3,
					type = "toggle",
					name = L["Auras"],
					get = function() return E.db.mui.buffReminder.sound.auras end,
					set = function(_, value) E.db.mui.buffReminder.sound.auras = value end,
				},
				consumables = {
					order = 4,
					type = "toggle",
					name = L["Consumables"],
					get = function() return E.db.mui.buffReminder.sound.consumables end,
					set = function(_, value) E.db.mui.buffReminder.sound.consumables = value end,
				},
			},
		},
		raidBuffs = {
			order = 5,
			type = "group",
			name = L["Raid Buffs"],
			guiInline = true,
			args = (function()
				local args = BuildToggleArgs(RAID_BUFF_TOGGLES, "mui.buffReminder.raidBuffs.enabled")
				args.enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					width = "full",
					get = function() return E.db.mui.buffReminder.raidBuffs.enable end,
					set = function(_, value)
						E.db.mui.buffReminder.raidBuffs.enable = value
						BR:RequestRefresh()
					end,
				}
				return args
			end)(),
		},
		auras = {
			order = 6,
			type = "group",
			name = L["Auras"],
			guiInline = true,
			args = (function()
				local args = BuildToggleArgs(AURA_TOGGLES, "mui.buffReminder.auras.enabled")
				args.enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					width = "full",
					get = function() return E.db.mui.buffReminder.auras.enable end,
					set = function(_, value)
						E.db.mui.buffReminder.auras.enable = value
						BR:RequestRefresh()
					end,
				}
				return args
			end)(),
		},
		consumables = {
			order = 7,
			type = "group",
			name = L["Consumables"],
			guiInline = true,
			args = (function()
				local args = BuildToggleArgs(CONSUMABLE_TOGGLES, "mui.buffReminder.consumables.enabled")
				args.enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					width = "full",
					get = function() return E.db.mui.buffReminder.consumables.enable end,
					set = function(_, value)
						E.db.mui.buffReminder.consumables.enable = value
						BR:RequestRefresh()
					end,
				}
				args.showWithoutItem = {
					order = 0.5,
					type = "toggle",
					name = L["Show Without Item"],
					desc = L["Keep showing a desaturated reminder icon even when you have none of the item left in your bags."],
					width = "full",
					get = function() return E.db.mui.buffReminder.consumables.showWithoutItem end,
					set = function(_, value)
						E.db.mui.buffReminder.consumables.showWithoutItem = value
						BR:RequestRefresh()
					end,
				}
				return args
			end)(),
		},
	},
}
