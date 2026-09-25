local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local MA = MER:GetModule("MER_MovementAlert")
local LSM = E.Libs.LSM

local pairs, ipairs, tonumber, format = pairs, ipairs, tonumber, format
local sort, tinsert, wipe, concat = sort, tinsert, wipe, table.concat

local C_Spell_GetSpellInfo = C_Spell.GetSpellInfo
local GetSpecializationInfoByID = GetSpecializationInfoByID

local options = module.options.modules.args

F.MarkTabAsNew("movementAlert")

local function DB()
	return E.db.mui.movementAlert
end

local function Update()
	MA:SettingsUpdate()
end

local function Disabled()
	return not DB().enable
end

-- get/set for the options of one sub table (nil = the module table itself)
local function Accessors(section)
	local function Get(info)
		local db = section and DB()[section] or DB()
		return db[info[#info]]
	end

	local function Set(info, value)
		local db = section and DB()[section] or DB()
		db[info[#info]] = value
		Update()
	end

	return Get, Set
end

local function ColorArgs(order, section)
	local function Tbl()
		return section and DB()[section] or DB()
	end

	return {
		useClassColor = {
			order = order,
			type = "toggle",
			name = L["Use Class Color"],
			get = function()
				return Tbl().useClassColor
			end,
			set = function(_, value)
				Tbl().useClassColor = value
				Update()
			end,
		},
		color = {
			order = order + 1,
			type = "color",
			name = L["Custom Color"],
			hasAlpha = false,
			disabled = function()
				return Disabled() or Tbl().useClassColor
			end,
			get = function()
				local db = Tbl().color
				local default = (section and P.movementAlert[section] or P.movementAlert).color
				return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
			end,
			set = function(_, r, g, b)
				local db = Tbl().color
				db.r, db.g, db.b = r, g, b
				Update()
			end,
		},
	}
end

local function FontGroup(order, section)
	local function Font()
		return (section and DB()[section] or DB()).font
	end

	return {
		order = order,
		type = "group",
		name = L["Font"],
		guiInline = true,
		get = function(info)
			return Font()[info[#info]]
		end,
		set = function(info, value)
			Font()[info[#info]] = value
			Update()
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
				type = "range",
				name = L["Size"],
				min = 8,
				max = 72,
				step = 1,
			},
		},
	}
end

local function AlertArgs(order, section, ttsText)
	local function Tbl()
		return DB()[section]
	end

	local args = {
		sound = {
			order = order,
			type = "select",
			dialogControl = "LSM30_Sound",
			name = L["Sound"],
			values = LSM:HashTable("sound"),
			disabled = function()
				return Disabled() or Tbl().tts
			end,
			get = function()
				return Tbl().sound
			end,
			set = function(_, value)
				Tbl().sound = value
			end,
		},
		tts = {
			order = order + 1,
			type = "toggle",
			name = L["Text to Speech"],
			desc = L["Reads the alert out loud with the voice from Blizzard's Text to Speech settings instead of playing the sound."],
			get = function()
				return Tbl().tts
			end,
			set = function(_, value)
				Tbl().tts = value
			end,
		},
	}

	if ttsText then
		args.ttsText = {
			order = order + 2,
			type = "input",
			name = L["Spoken Text"],
			disabled = function()
				return Disabled() or not Tbl().tts
			end,
			get = function()
				return Tbl().ttsText
			end,
			set = function(_, value)
				Tbl().ttsText = value
			end,
		}
	end

	return args
end

-------------------------------------------------------------------------------
--  Tracked spells of the player's class
-------------------------------------------------------------------------------
local function SpellLabel(spellID)
	local info = C_Spell_GetSpellInfo(spellID)
	if not info then
		return format("%s (%d)", L["Unknown Spell"], spellID)
	end

	return format("%s %s", F.GetIconString(info.iconID, 16), info.name)
end

local function SpellSpecs(spellID)
	local specs = {}
	for specID, spells in pairs(MA.MOVEMENT_SPELLS[E.myclass] or {}) do
		for _, id in ipairs(spells) do
			if id == spellID then
				local _, name = GetSpecializationInfoByID(specID)
				if name then
					tinsert(specs, name)
				end
			end
		end
	end
	sort(specs)

	return concat(specs, ", ")
end

local spellArgs = {}

local function BuildSpellArgs()
	wipe(spellArgs)

	spellArgs.desc = {
		order = 0,
		type = "description",
		name = L["Movement spells of your class. Only spells your current specialization knows are shown."],
		fontSize = "medium",
	}

	local presets, seen = {}, {}
	for _, spells in pairs(MA.MOVEMENT_SPELLS[E.myclass] or {}) do
		for _, spellID in ipairs(spells) do
			if not seen[spellID] then
				seen[spellID] = true
				tinsert(presets, spellID)
			end
		end
	end
	sort(presets)

	for i, spellID in ipairs(presets) do
		spellArgs["preset" .. spellID] = {
			order = i,
			type = "toggle",
			name = function()
				return SpellLabel(spellID)
			end,
			desc = function()
				return SpellSpecs(spellID)
			end,
			width = 1.5,
			get = function()
				return MA:IsSpellEnabled(spellID)
			end,
			set = function(_, value)
				DB().spells[spellID] = value
				Update()
			end,
		}
	end

	spellArgs.customHeader = {
		order = 100,
		type = "header",
		name = L["Custom Spells"],
	}
	spellArgs.addSpell = {
		order = 101,
		type = "input",
		name = L["Add Spell ID"],
		desc = L["Tracks another spell of your class, for example one that is missing from the list above."],
		get = function()
			return ""
		end,
		validate = function(_, value)
			local spellID = tonumber(value)
			if not spellID or not C_Spell_GetSpellInfo(spellID) then
				return L["Not a valid spell ID."]
			end
			return true
		end,
		set = function(_, value)
			MA:GetCustomSpells()[tonumber(value)] = true
			BuildSpellArgs()
			Update()
		end,
	}

	-- When this file runs, E.db only holds the raw saved profile without the
	-- defaults. MA.db is set once the module is initialized, which calls this
	-- again (and after every profile change).
	local custom = MA.db and MA.db.customSpells[E.myclass]

	local order = 102
	for spellID in pairs(custom or {}) do
		spellArgs["custom" .. spellID] = {
			order = order,
			type = "toggle",
			name = function()
				return SpellLabel(spellID)
			end,
			width = 1.5,
			get = function()
				return MA:GetCustomSpells()[spellID]
			end,
			set = function(_, value)
				MA:GetCustomSpells()[spellID] = value
				Update()
			end,
		}
		spellArgs["remove" .. spellID] = {
			order = order + 0.5,
			type = "execute",
			name = L["Remove"],
			width = 0.6,
			func = function()
				MA:GetCustomSpells()[spellID] = nil
				BuildSpellArgs()
				Update()
			end,
		}
		order = order + 1
	end

	E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
end

BuildSpellArgs()
MA.RebuildSpellOptions = BuildSpellArgs

-------------------------------------------------------------------------------
--  Options
-------------------------------------------------------------------------------
local mainGet, mainSet = Accessors()
local barGet, barSet = Accessors("bar")
local timeSpiralGet, timeSpiralSet = Accessors("timeSpiral")
local gatewayGet, gatewaySet = Accessors("gateway")

options.movementAlert = {
	type = "group",
	name = module:AddCategorieIcon(L["Movement Alert"], "Tool"),
	childGroups = "tab",
	get = mainGet,
	set = mainSet,
	args = {
		header = {
			order = 0,
			type = "header",
			name = L["Movement Alert"],
		},
		desc = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = L["Shows the cooldown of your class's movement spells while they are not available, a banner when Time Spiral lets you use one for free and a reminder when your Gateway Control Shard can be used."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		test = {
			order = 3,
			type = "execute",
			name = function()
				return MA.testMode and L["Stop Test"] or L["Test"]
			end,
			desc = L["Shows sample alerts for 20 seconds so you can check the look and position."],
			disabled = Disabled,
			func = function()
				MA:ToggleTestMode()
			end,
		},
		general = {
			order = 10,
			type = "group",
			name = L["General"],
			disabled = Disabled,
			args = {
				combatOnly = {
					order = 1,
					type = "toggle",
					name = L["Combat Only"],
					desc = L["Only show the cooldowns while you are in combat."],
				},
				displayMode = {
					order = 2,
					type = "select",
					name = L["Display Mode"],
					values = {
						TEXT = L["Text"],
						ICON = L["Icon"],
						BAR = L["Bar"],
					},
				},
				textFormat = {
					order = 3,
					type = "select",
					name = L["Text Format"],
					hidden = function()
						return DB().displayMode ~= "TEXT"
					end,
					values = {
						NAME_TIME = L["Name + Time"],
						TIME_NAME = L["Time + Name"],
						TIME = L["Time only"],
					},
				},
				textWidth = {
					order = 4,
					type = "range",
					name = L["Width"],
					hidden = function()
						return DB().displayMode ~= "TEXT"
					end,
					min = 50,
					max = 600,
					step = 1,
				},
				iconSize = {
					order = 5,
					type = "range",
					name = L["Icon Size"],
					hidden = function()
						return DB().displayMode ~= "ICON"
					end,
					min = 16,
					max = 128,
					step = 1,
				},
				decimals = {
					order = 6,
					type = "toggle",
					name = L["Show Decimals"],
				},
				spacing = {
					order = 7,
					type = "range",
					name = L["Spacing"],
					min = 0,
					max = 30,
					step = 1,
				},
				growDirection = {
					order = 8,
					type = "select",
					name = L["Grow Direction"],
					values = {
						UP = L["Up"],
						DOWN = L["Down"],
					},
				},
				color = {
					order = 9,
					type = "group",
					name = L["Color"],
					guiInline = true,
					args = ColorArgs(1),
				},
				font = FontGroup(10),
				bar = {
					order = 11,
					type = "group",
					name = L["Bar"],
					guiInline = true,
					hidden = function()
						return DB().displayMode ~= "BAR"
					end,
					get = barGet,
					set = barSet,
					args = {
						width = {
							order = 1,
							type = "range",
							name = L["Width"],
							min = 50,
							max = 600,
							step = 1,
						},
						height = {
							order = 2,
							type = "range",
							name = L["Height"],
							min = 4,
							max = 60,
							step = 1,
						},
						texture = {
							order = 3,
							type = "select",
							dialogControl = "LSM30_Statusbar",
							name = L["Texture"],
							values = LSM:HashTable("statusbar"),
						},
						showIcon = {
							order = 4,
							type = "toggle",
							name = L["Show Icon"],
						},
						showTime = {
							order = 5,
							type = "toggle",
							name = L["Show Time"],
						},
					},
				},
				alert = {
					order = 12,
					type = "group",
					name = L["Ready Alert"],
					guiInline = true,
					args = F.Table.Join({
						desc = {
							order = 0,
							type = "description",
							name = L["Plays a sound or reads the spell name out loud when a movement spell is available again."],
						},
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							get = function()
								return DB().alert.enable
							end,
							set = function(_, value)
								DB().alert.enable = value
							end,
						},
					}, AlertArgs(2, "alert")),
				},
			},
		},
		spells = {
			order = 20,
			type = "group",
			name = L["Spells"],
			disabled = Disabled,
			args = spellArgs,
		},
		timeSpiral = {
			order = 30,
			type = "group",
			name = L["Time Spiral"],
			disabled = Disabled,
			get = timeSpiralGet,
			set = timeSpiralSet,
			args = F.Table.Join({
				desc = {
					order = 0,
					type = "description",
					name = L["Shows a banner while one of your movement spells can be used for free after Time Spiral or a similar effect reset it."],
					fontSize = "medium",
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				text = {
					order = 2,
					type = "input",
					name = L["Text"],
				},
				showTimer = {
					order = 3,
					type = "toggle",
					name = L["Show Time"],
				},
				color = {
					order = 4,
					type = "group",
					name = L["Color"],
					guiInline = true,
					args = ColorArgs(1, "timeSpiral"),
				},
				font = FontGroup(5, "timeSpiral"),
				alert = {
					order = 6,
					type = "group",
					name = L["Sounds"],
					guiInline = true,
					args = AlertArgs(1, "timeSpiral", true),
				},
			}),
		},
		gateway = {
			order = 40,
			type = "group",
			name = L["Gateway Control Shard"],
			disabled = Disabled,
			get = gatewayGet,
			set = gatewaySet,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Shows a reminder while the Gateway Control Shard in your bags can be used."],
					fontSize = "medium",
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				combatOnly = {
					order = 2,
					type = "toggle",
					name = L["Combat Only"],
				},
				text = {
					order = 3,
					type = "input",
					name = L["Text"],
				},
				color = {
					order = 4,
					type = "group",
					name = L["Color"],
					guiInline = true,
					args = ColorArgs(1, "gateway"),
				},
				font = FontGroup(5, "gateway"),
				alert = {
					order = 6,
					type = "group",
					name = L["Sounds"],
					guiInline = true,
					args = AlertArgs(1, "gateway"),
				},
			},
		},
	},
}
