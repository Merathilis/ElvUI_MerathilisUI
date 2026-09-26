local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local BR = MER:GetModule("MER_BattleRes")
local LSM = E.Libs.LSM

local options = module.options.modules.args

F.MarkTabAsNew("battleRes")

local function DB()
	return E.db.mui.battleRes
end

local function Update()
	BR:SettingsUpdate()
end

local function Disabled()
	return not DB().enable
end

local function ColorOption(order, key)
	return {
		order = order,
		type = "color",
		name = L["Color"],
		hasAlpha = false,
		get = function()
			local db = DB()[key]
			local default = P.battleRes[key]
			return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
		end,
		set = function(_, r, g, b)
			local db = DB()[key]
			db.r, db.g, db.b = r, g, b
			Update()
		end,
	}
end

local function FontGroup(order, name, fontKey, colorKey)
	return {
		order = order,
		type = "group",
		name = name,
		guiInline = true,
		disabled = Disabled,
		get = function(info)
			return DB()[fontKey][info[#info]]
		end,
		set = function(info, value)
			DB()[fontKey][info[#info]] = value
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
			color = ColorOption(4, colorKey),
		},
	}
end

options.battleRes = {
	type = "group",
	name = module:AddCategorieIcon(L["Battle Res"], "Tool"),
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
			name = L["Battle Res"],
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
					name = L["Shows the shared battle res charges of your group and the time until the next charge during Mythic+ keys and raid boss encounters."],
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
				return BR.testMode and L["Stop Test"] or L["Test"]
			end,
			desc = L["Shows sample charges for 20 seconds so you can check the look and position."],
			disabled = Disabled,
			func = function()
				BR:ToggleTestMode()
			end,
		},
		debug = {
			order = 4,
			type = "toggle",
			name = L["Debug Mode"],
			desc = L["Shows the tracker everywhere with the real battle res data instead of only in Mythic+ keys and raid encounters, and prints every change of the charges and of the visibility state to the chat."],
			disabled = Disabled,
		},
		general = {
			order = 10,
			type = "group",
			name = L["General"],
			guiInline = true,
			disabled = Disabled,
			args = {
				visibility = {
					order = 1,
					type = "select",
					name = L["Visibility"],
					values = {
						MPLUS_AND_RAID = L["Mythic+ and Raid"],
						MPLUS = L["Mythic+"],
						RAID = L["Raid"],
					},
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
						return DB().displayMode ~= "ICON"
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
						return DB().displayMode ~= "ICON"
					end,
				},
			},
		},
		countFont = FontGroup(20, L["Charges"], "countFont", "countColor"),
		timeFont = FontGroup(30, L["Recharge Time"], "timeFont", "timeColor"),
	},
}
