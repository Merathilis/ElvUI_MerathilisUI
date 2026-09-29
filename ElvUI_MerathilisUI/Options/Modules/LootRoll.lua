local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local LR = MER:GetModule("MER_LootRoll")
local LSM = E.Libs.LSM

local options = module.options.modules.args

local function ModuleDisabled()
	return not E.db.mui.lootRoll.enable
end

---Inline group whose options read and write E.db.mui.lootRoll directly and redraw the bars
local function SettingsGroup(order, name, args)
	return {
		order = order,
		type = "group",
		guiInline = true,
		name = name,
		disabled = ModuleDisabled,
		get = function(info)
			return E.db.mui.lootRoll[info[#info]]
		end,
		set = function(info, value)
			E.db.mui.lootRoll[info[#info]] = value
			LR:ApplySettings()
		end,
		args = args,
	}
end

local function Range(order, name, min, max)
	return {
		order = order,
		type = "range",
		name = name,
		min = min,
		max = max,
		step = 1,
	}
end

local function Toggle(order, name, desc)
	return {
		order = order,
		type = "toggle",
		name = name,
		desc = desc,
	}
end

options.lootRoll = {
	type = "group",
	name = module:AddCategorieIcon(L["Loot Roll"], "bags"),
	args = {
		header = {
			order = 0,
			type = "header",
			name = L["Loot Roll"],
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
					name = L["Replaces ElvUI's Need/Greed/Pass loot roll frames with a custom, movable bar."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			get = function()
				return E.db.mui.lootRoll.enable
			end,
			-- Takes over ElvUI's loot roll on load
			set = function(_, value)
				E.db.mui.lootRoll.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		test = {
			order = 3,
			type = "execute",
			name = L["Test"],
			desc = L["Show/hide a fake roll bar to preview your settings."],
			func = function()
				LR:Test()
			end,
			disabled = ModuleDisabled,
		},
		spacer = {
			order = 4,
			type = "description",
			name = "",
		},
		layout = SettingsGroup(5, L["Layout"], {
			growDirection = {
				order = 1,
				type = "select",
				name = L["Grow Direction"],
				values = {
					DOWN = L["Down"],
					UP = L["Up"],
				},
			},
			maxBars = Range(2, L["Max Bars"], 1, 8),
			spacing = Range(3, L["Spacing"], 0, 20),
			width = Range(4, L["Width"], 180, 500),
			height = Range(5, L["Height"], 24, 80),
			buttonSize = Range(6, L["Button Size"], 12, 32),
		}),
		colors = SettingsGroup(6, L["Colors"], {
			qualityBorder = Toggle(1, L["Color Border by Quality"]),
			qualityName = Toggle(2, L["Color Name by Quality"]),
			qualityItemLevel = Toggle(3, L["Show Item Level"]),
			qualityStatusBar = Toggle(4, L["Color Status Bar by Quality"]),
			statusBarColor = {
				order = 5,
				type = "color",
				name = L["Custom Status Bar Color"],
				hasAlpha = false,
				disabled = function()
					return ModuleDisabled() or E.db.mui.lootRoll.qualityStatusBar
				end,
				get = function()
					local db = E.db.mui.lootRoll.statusBarColor
					local default = P.lootRoll.statusBarColor
					return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
				end,
				set = function(_, r, g, b)
					local db = E.db.mui.lootRoll.statusBarColor
					db.r, db.g, db.b = r, g, b
					LR:ApplySettings()
				end,
			},
			statusBarTexture = {
				order = 6,
				type = "select",
				dialogControl = "LSM30_Statusbar",
				name = L["Status Bar Texture"],
				values = LSM:HashTable("statusbar"),
			},
		}),
		font = SettingsGroup(7, L["Font"], {
			font = {
				order = 1,
				type = "select",
				dialogControl = "LSM30_Font",
				name = L["Font"],
				values = LSM:HashTable("font"),
			},
			fontSize = Range(2, L["Font Size"], 8, 24),
			fontOutline = {
				order = 3,
				type = "select",
				name = L["Font Outline"],
				values = MER.Values.FontFlags,
				sortByValue = true,
			},
		}),
		rollers = SettingsGroup(8, L["Rollers"], {
			showRollers = Toggle(
				1,
				L["Show Rollers in Tooltip"],
				L["Show who rolled Need/Greed/Disenchant/Pass in the item's tooltip.\n\nNote: on modern retail WoW this can currently only be populated for boss/encounter loot - it stays empty for regular group loot (e.g. trash mobs, world content)."]
			),
		}),
	},
}
