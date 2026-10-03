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

	-- Turning it off clears the icons right away, turning it on needs the frames
	-- that are only built on load
	if key == "enable" and value then
		E:StaticPopup_Show("CONFIG_RL")
	end

	if RESTYLE_KEYS[key] then
		BR:RestyleIcons()
	end
	BR:RequestRefresh()
end

local function ModuleDisabled()
	return not E.db.mui.buffReminder.enable
end

---Enable toggle of one section (raidBuffs, auras, consumables) plus a toggle per tracked buff
local function BuildSectionArgs(section, list)
	local db = function()
		return E.db.mui.buffReminder[section]
	end
	-- Own disabled replaces the group's, so the module state is repeated here
	local sectionDisabled = function()
		return ModuleDisabled() or not db().enable
	end

	local args = {
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			width = "full",
			get = function()
				return db().enable
			end,
			set = function(_, value)
				db().enable = value
				BR:RequestRefresh()
			end,
		},
	}

	for i, item in ipairs(list) do
		args[item.key] = {
			order = 10 + i,
			type = "toggle",
			name = item.name,
			disabled = sectionDisabled,
			get = function()
				return db().enabled[item.key]
			end,
			set = function(_, value)
				db().enabled[item.key] = value
				BR:RequestRefresh()
			end,
		}
	end

	return args, sectionDisabled
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

local raidBuffArgs = BuildSectionArgs("raidBuffs", RAID_BUFF_TOGGLES)
local auraArgs = BuildSectionArgs("auras", AURA_TOGGLES)
local consumableArgs, consumablesDisabled = BuildSectionArgs("consumables", CONSUMABLE_TOGGLES)
consumableArgs.showWithoutItem = {
	order = 2,
	type = "toggle",
	name = L["Show Without Item"],
	desc = L["Keep showing a desaturated reminder icon even when you have none of the item left in your bags."],
	width = "full",
	disabled = consumablesDisabled,
	get = function()
		return E.db.mui.buffReminder.consumables.showWithoutItem
	end,
	set = function(_, value)
		E.db.mui.buffReminder.consumables.showWithoutItem = value
		BR:RequestRefresh()
	end,
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
			name = L["Buff Reminder"],
		},
		enable = module.ToggleCard({
			order = 2,
			name = L["Enable"],
			desc = L["Buff Reminder shows icons for the raid buffs you are missing."],
			image = I.Media.Icons.Categories.buff_reminder,
		}),
		test = {
			order = 3,
			type = "execute",
			name = function()
				return BR.testMode and L["Stop Test"] or L["Test"]
			end,
			desc = L["Shows a row of sample icons for 20 seconds so you can check scale, glow, text and position without needing to actually be missing anything in a raid."],
			width = "full",
			disabled = ModuleDisabled,
			func = function()
				BR:ToggleTestMode()
			end,
		},
		general = {
			order = 4,
			type = "group",
			name = L["General"],
			guiInline = true,
			disabled = ModuleDisabled,
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
				hideInCombat = {
					order = 3,
					type = "toggle",
					name = L["Hide in Combat"],
					desc = L["When disabled, reminders freeze in place during combat instead of disappearing."],
				},
				showUnder = {
					order = 4,
					type = "range",
					name = L["Remind Under (minutes)"],
					desc = L["Also remind when a tracked consumable buff is about to expire within this many minutes."],
					min = 1,
					max = 30,
					step = 1,
				},
				scale = {
					order = 5,
					type = "range",
					name = L["Scale"],
					min = 0.5,
					max = 3,
					step = 0.05,
				},
				iconSpacing = {
					order = 6,
					type = "range",
					name = L["Icon Spacing"],
					min = 0,
					max = 30,
					step = 1,
				},
				frameStrata = {
					order = 7,
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
					order = 8,
					type = "toggle",
					name = L["Show Text"],
				},
				textSize = {
					order = 9,
					type = "range",
					name = L["Text Size"],
					min = 6,
					max = 30,
					step = 1,
					disabled = function()
						return ModuleDisabled() or not E.db.mui.buffReminder.showText
					end,
				},
				textOutline = {
					order = 10,
					type = "select",
					name = L["Text Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
					disabled = function()
						return ModuleDisabled() or not E.db.mui.buffReminder.showText
					end,
				},
				showBagCount = {
					order = 11,
					type = "toggle",
					name = L["Show Bag Count"],
				},
				glowEnable = {
					order = 12,
					type = "toggle",
					name = L["Enable Glow"],
				},
				glowColor = {
					order = 13,
					type = "color",
					name = L["Glow Color"],
					hasAlpha = false,
					disabled = function()
						return ModuleDisabled() or not E.db.mui.buffReminder.glowEnable
					end,
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
			order = 5,
			type = "group",
			name = L["Sounds"],
			guiInline = true,
			disabled = ModuleDisabled,
			get = function(info)
				return E.db.mui.buffReminder.sound[info[#info]]
			end,
			-- Read when a reminder appears, nothing to refresh
			set = function(info, value)
				E.db.mui.buffReminder.sound[info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				raidBuffs = {
					order = 2,
					type = "toggle",
					name = L["Raid Buffs"],
					disabled = function()
						return ModuleDisabled() or not E.db.mui.buffReminder.sound.enable
					end,
				},
				auras = {
					order = 3,
					type = "toggle",
					name = L["Auras"],
					disabled = function()
						return ModuleDisabled() or not E.db.mui.buffReminder.sound.enable
					end,
				},
				consumables = {
					order = 4,
					type = "toggle",
					name = L["Consumables"],
					disabled = function()
						return ModuleDisabled() or not E.db.mui.buffReminder.sound.enable
					end,
				},
			},
		},
		raidBuffs = {
			order = 6,
			type = "group",
			name = L["Raid Buffs"],
			guiInline = true,
			disabled = ModuleDisabled,
			args = raidBuffArgs,
		},
		auras = {
			order = 7,
			type = "group",
			name = L["Auras"],
			guiInline = true,
			disabled = ModuleDisabled,
			args = auraArgs,
		},
		consumables = {
			order = 8,
			type = "group",
			name = L["Consumables"],
			guiInline = true,
			disabled = ModuleDisabled,
			args = consumableArgs,
		},
	},
}
