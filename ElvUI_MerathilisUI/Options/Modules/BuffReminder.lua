local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

local ipairs, next, pairs, setmetatable = ipairs, next, pairs, setmetatable
local format, strfind, tremove, wipe = format, strfind, tremove, wipe
local hooksecurefunc = hooksecurefunc

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
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

	local raidBuffArgs, raidBuffsDisabled = BuildSectionArgs("raidBuffs", RAID_BUFF_TOGGLES)
	raidBuffArgs.fromGroup = {
		order = 2,
		type = "toggle",
		name = F.NewFeatureText(L["Missing Buffs From Group"]),
		desc = L["Also shows the raid buffs a groupmate provides while you are missing them. These icons are only a hint, clicks go through them."],
		width = "full",
		disabled = raidBuffsDisabled,
		get = function()
			return E.db.mui.buffReminder.raidBuffs.fromGroup
		end,
		set = function(_, value)
			E.db.mui.buffReminder.raidBuffs.fromGroup = value
			BR:RequestRefresh()
		end,
	}
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

	-- Talent reminders: a form that adds one for the current spec, then one
	-- inline group per saved reminder. Groups go by index into the saved list,
	-- so they are rebuilt when the list or the profile changes.
	local NOT_NEEDED_VALUES = {
		never = L["Never"],
		season = L["Current Season Instances"],
		all = L["All Instances"],
	}
	local NOT_NEEDED_SORTING = { "never", "season", "all" }
	local NOT_NEEDED_DESC = L["Reminds you to remove the talent in the instances you did not pick for it."]

	local function TalentsDB()
		return E.db.mui.buffReminder.talents
	end

	local function TalentsDisabled()
		return ModuleDisabled() or not TalentsDB().enable
	end

	local function ReminderAt(index)
		return TalentsDB().reminders[index]
	end

	local function IsCurrentSpec(reminder)
		local _, specID = F.GetPlayerSpec()
		return reminder.class == E.myclass and reminder.specID == specID
	end

	local function Ordered(values, order)
		return setmetatable(values, { order = order })
	end

	local function TalentLabel(spellID)
		local icon = C_Spell.GetSpellTexture(spellID) or 134400
		return format("|T%s:16:16:0:0:64:64:5:59:5:59|t %s", icon, C_Spell.GetSpellName(spellID) or spellID)
	end

	local newSpell, newNotNeeded = nil, "never"
	local newZones = {}
	local talentArgs

	local function RebuildTalentList()
		for key in pairs(talentArgs) do
			if strfind(key, "^reminder") then
				talentArgs[key] = nil
			end
		end

		for index in ipairs(TalentsDB().reminders) do
			talentArgs["reminder" .. index] = {
				order = 20 + index,
				type = "group",
				inline = true,
				name = function()
					local reminder = ReminderAt(index)
					return reminder and TalentLabel(reminder.spellID) or ""
				end,
				hidden = function()
					local reminder = ReminderAt(index)
					return not (reminder and IsCurrentSpec(reminder))
				end,
				disabled = TalentsDisabled,
				args = {
					zones = {
						order = 1,
						type = "multiselect",
						dialogControl = "MERDropdown",
						name = L["Instances"],
						width = 1.5,
						values = function()
							return Ordered(BR:GetTalentZoneChoices(ReminderAt(index)))
						end,
						get = function(_, key)
							local reminder = ReminderAt(index)
							return reminder and reminder.zones and reminder.zones[key]
						end,
						set = function(_, key, value)
							local reminder = ReminderAt(index)
							reminder.zones = reminder.zones or {}
							reminder.zones[key] = value or nil
							BR:RequestRefresh()
						end,
					},
					notNeeded = {
						order = 2,
						type = "select",
						name = L["Not Needed"],
						desc = NOT_NEEDED_DESC,
						values = NOT_NEEDED_VALUES,
						sorting = NOT_NEEDED_SORTING,
						get = function()
							local reminder = ReminderAt(index)
							return reminder and reminder.notNeeded or "never"
						end,
						set = function(_, value)
							ReminderAt(index).notNeeded = value
							BR:RequestRefresh()
						end,
					},
					delete = {
						order = 3,
						type = "execute",
						name = L["Delete"],
						func = function()
							tremove(TalentsDB().reminders, index)
							RebuildTalentList()
							BR:RequestRefresh()
							E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
						end,
					},
				},
			}
		end
	end

	local function AddTalentReminder()
		local _, specID = F.GetPlayerSpec()
		if not (newSpell and specID and next(newZones)) then
			return
		end

		-- A talent already on the list of this spec takes the new instances
		local reminders = TalentsDB().reminders
		local reminder
		for _, r in ipairs(reminders) do
			if r.spellID == newSpell and IsCurrentSpec(r) then
				reminder = r
				break
			end
		end
		if not reminder then
			reminder = { spellID = newSpell, class = E.myclass, specID = specID, zones = {} }
			reminders[#reminders + 1] = reminder
		end
		reminder.zones = reminder.zones or {}
		for key in pairs(newZones) do
			reminder.zones[key] = true
		end
		reminder.notNeeded = newNotNeeded

		newSpell, newNotNeeded = nil, "never"
		wipe(newZones)
		RebuildTalentList()
		BR:RequestRefresh()
		E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
	end

	talentArgs = {
		enable = {
			order = 1,
			type = "toggle",
			name = F.NewFeatureText(L["Enable"]),
			width = "full",
			get = function()
				return TalentsDB().enable
			end,
			set = function(_, value)
				TalentsDB().enable = value
				BR:RequestRefresh()
			end,
		},
		desc = {
			order = 2,
			type = "description",
			dialogControl = "MERTextCard",
			name = L["Pick a talent of your current specialization and the instances you want it in. Inside them, an icon shows while the talent is not chosen. Reminders are saved per specialization."],
			fontSize = "medium",
		},
		talent = {
			order = 3,
			type = "select",
			name = L["Talent"],
			width = 1.5,
			disabled = TalentsDisabled,
			values = function()
				return Ordered(BR:GetTalentChoices())
			end,
			get = function()
				return newSpell
			end,
			set = function(_, value)
				newSpell = value
			end,
		},
		zones = {
			order = 4,
			type = "multiselect",
			dialogControl = "MERDropdown",
			name = L["Instances"],
			width = 1.5,
			disabled = TalentsDisabled,
			values = function()
				return Ordered(BR:GetTalentZoneChoices())
			end,
			get = function(_, key)
				return newZones[key]
			end,
			set = function(_, key, value)
				newZones[key] = value or nil
			end,
		},
		notNeeded = {
			order = 5,
			type = "select",
			name = L["Not Needed"],
			desc = NOT_NEEDED_DESC,
			disabled = TalentsDisabled,
			values = NOT_NEEDED_VALUES,
			sorting = NOT_NEEDED_SORTING,
			get = function()
				return newNotNeeded
			end,
			set = function(_, value)
				newNotNeeded = value
			end,
		},
		add = {
			order = 6,
			type = "execute",
			name = L["Add"],
			disabled = function()
				return TalentsDisabled() or not newSpell or not next(newZones)
			end,
			func = AddTalentReminder,
		},
	}
	RebuildTalentList()
	hooksecurefunc(BR, "ProfileUpdate", RebuildTalentList)

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
			test = module.ActionCard({
				order = 3,
				type = "execute",
				name = function()
					return BR.testMode and L["Stop Test"] or L["Test"]
				end,
				desc = L["Shows a row of sample icons for 20 seconds so you can check scale, glow, text and position without needing to actually be missing anything in a raid."],
				disabled = ModuleDisabled,
				func = function()
					BR:ToggleTestMode()
				end,
			}, { icon = I.Media.Icons.Categories.buff_reminder, compact = true }),
			preview = module.PreviewOption(3.5, "MERBuffReminderPreview", "buffReminder"),
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
					talents = {
						order = 5,
						type = "toggle",
						name = L["Talents"],
						hidden = E.Forever,
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
			talents = {
				order = 9,
				type = "group",
				name = L["Talent Reminders"],
				guiInline = true,
				hidden = E.Forever,
				disabled = ModuleDisabled,
				args = talentArgs,
			},
			-- Independent of the reminder icons, so not disabled with the module
			raidCheck = {
				order = 10,
				type = "group",
				name = L["Raid Buff Check"],
				guiInline = true,
				hidden = E.Forever,
				get = function(info)
					return E.db.mui.buffReminder.raidCheck[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.buffReminder.raidCheck[info[#info]] = value
					BR:UpdateRaidCheck()
				end,
				args = {
					desc = {
						order = 1,
						type = "description",
						dialogControl = "MERTextCard",
						name = L["A window listing every group member's flask, food, augment rune, vantus rune and missing raid buffs. Opens with /buffcheck or the button below, out of combat only."],
						fontSize = "medium",
					},
					enable = {
						order = 2,
						type = "toggle",
						name = F.NewFeatureText(L["Enable"]),
					},
					onReadyCheck = {
						order = 3,
						type = "toggle",
						name = L["Open on Ready Check"],
						desc = L["Opens the window on every ready check while you are the group leader or a raid assistant."],
						disabled = function()
							return not E.db.mui.buffReminder.raidCheck.enable
						end,
					},
					open = {
						order = 4,
						type = "execute",
						name = L["Toggle"],
						disabled = function()
							return not E.db.mui.buffReminder.raidCheck.enable
						end,
						func = function()
							BR:ToggleRaidCheck()
						end,
					},
				},
			},
		},
	}

	module.ModuleCard("buffReminderSound", options.buffReminder.args.sound, "enable")
	F.MarkTabAsNew("buffReminder")
end)
