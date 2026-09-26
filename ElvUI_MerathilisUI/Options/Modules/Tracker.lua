local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local TR = MER:GetModule("MER_Tracker")
local LSM = E.Libs.LSM

local options = module.options.modules.args

F.MarkTabAsNew("tracker")
F.MarkTabAsNew("bloodlust")

local function DB()
	return E.db.mui.tracker
end

local function BattleResDB()
	return DB().battleRes
end

local function BloodlustDB()
	return DB().bloodlust
end

local function Update()
	TR:SettingsUpdate()
end

local function BattleResDisabled()
	return not BattleResDB().enable
end

local function BloodlustDisabled()
	return not BloodlustDB().enable
end

local function NothingEnabled()
	return not (BattleResDB().enable or BloodlustDB().enable)
end

-- get/set for the options of one tracker table
local function Accessors(tbl)
	local function Get(info)
		return tbl()[info[#info]]
	end

	local function Set(info, value)
		tbl()[info[#info]] = value
		Update()
	end

	return Get, Set
end

local VISIBILITY = {
	MPLUS_AND_RAID = L["Mythic+ and Raid"],
	MPLUS = L["Mythic+"],
	RAID = L["Raid"],
}

-- tbl: returns the settings table that holds the color, defaults: same table in P
local function ColorOption(order, tbl, defaults, key)
	return {
		order = order,
		type = "color",
		name = L["Color"],
		hasAlpha = false,
		get = function()
			local db = tbl()[key]
			local default = defaults[key]
			return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
		end,
		set = function(_, r, g, b)
			local db = tbl()[key]
			db.r, db.g, db.b = r, g, b
			Update()
		end,
	}
end

local function FontGroup(order, name, tbl, defaults, fontKey, colorKey, disabled)
	return {
		order = order,
		type = "group",
		name = name,
		guiInline = true,
		disabled = disabled,
		get = function(info)
			return tbl()[fontKey][info[#info]]
		end,
		set = function(info, value)
			tbl()[fontKey][info[#info]] = value
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
				max = 40,
				step = 1,
			},
			color = ColorOption(4, tbl, defaults, colorKey),
		},
	}
end

local battleResGet, battleResSet = Accessors(BattleResDB)
local bloodlustGet, bloodlustSet = Accessors(BloodlustDB)

options.tracker = {
	type = "group",
	name = module:AddCategorieIcon(L["Tracker"], "Tool"),
	childGroups = "tab",
	get = function(info)
		return DB()[info[#info]]
	end,
	set = function(info, value)
		DB()[info[#info]] = value
		Update()
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = L["Tracker"],
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
					name = L["Shows the shared battle res charges of your group and the time until the next charge during Mythic+ keys and raid boss encounters."]
						.. "\n"
						.. L["The Bloodlust tracker shows your Sated lockout, the active lust and optionally when a lust is ready again."],
					fontSize = "medium",
				},
			},
		},
		test = {
			order = 2,
			type = "execute",
			name = function()
				return TR.testMode and L["Stop Test"] or L["Test"]
			end,
			desc = L["Shows sample values for 20 seconds so you can check the look and position."],
			disabled = NothingEnabled,
			func = function()
				TR:ToggleTestMode()
			end,
		},
		debug = {
			order = 3,
			type = "toggle",
			name = L["Debug Mode"],
			desc = L["Shows the trackers everywhere with their real data instead of only in Mythic+ keys and raid encounters, and prints every change of the charges, the Sated lockout and the visibility state to the chat."],
			disabled = NothingEnabled,
		},
		battleRes = {
			order = 10,
			type = "group",
			name = L["Battle Res"],
			get = battleResGet,
			set = battleResSet,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				general = {
					order = 10,
					type = "group",
					name = L["General"],
					guiInline = true,
					disabled = BattleResDisabled,
					args = {
						visibility = {
							order = 1,
							type = "select",
							name = L["Visibility"],
							values = VISIBILITY,
						},
						displayMode = {
							order = 2,
							type = "select",
							name = L["Display Mode"],
							values = {
								ICON = L["Icon"],
								TEXT = L["Text"],
							},
						},
						iconSize = {
							order = 3,
							type = "range",
							name = L["Icon Size"],
							hidden = function()
								return BattleResDB().displayMode ~= "ICON"
							end,
							min = 16,
							max = 128,
							step = 1,
						},
						desaturate = {
							order = 4,
							type = "toggle",
							name = L["Desaturate"],
							desc = L["Greys out the icon while no charge is left."],
							hidden = function()
								return BattleResDB().displayMode ~= "ICON"
							end,
						},
					},
				},
				countFont = FontGroup(
					20,
					L["Charges"],
					BattleResDB,
					P.tracker.battleRes,
					"countFont",
					"countColor",
					BattleResDisabled
				),
				timeFont = FontGroup(
					30,
					L["Recharge Time"],
					BattleResDB,
					P.tracker.battleRes,
					"timeFont",
					"timeColor",
					BattleResDisabled
				),
			},
		},
		bloodlust = {
			order = 20,
			type = "group",
			name = L["Bloodlust"],
			get = bloodlustGet,
			set = bloodlustSet,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				general = {
					order = 10,
					type = "group",
					name = L["General"],
					guiInline = true,
					disabled = BloodlustDisabled,
					args = {
						visibility = {
							order = 1,
							type = "select",
							name = L["Visibility"],
							values = VISIBILITY,
						},
						iconSize = {
							order = 2,
							type = "range",
							name = L["Icon Size"],
							min = 16,
							max = 128,
							step = 1,
						},
						showSated = {
							order = 3,
							type = "toggle",
							name = L["Show Sated"],
							desc = L["Shows the remaining time of your Sated lockout. The active lust itself is always shown."],
						},
						showReady = {
							order = 4,
							type = "toggle",
							name = L["Show Ready"],
							desc = L["Keeps the icon up with a Ready text while you can benefit from a lust again."],
						},
						desaturate = {
							order = 5,
							type = "toggle",
							name = L["Desaturate"],
							desc = L["Greys out the icon while you are Sated."],
						},
					},
				},
				font = FontGroup(20, L["Font"], BloodlustDB, P.tracker.bloodlust, "font", "color", BloodlustDisabled),
			},
		},
	},
}
