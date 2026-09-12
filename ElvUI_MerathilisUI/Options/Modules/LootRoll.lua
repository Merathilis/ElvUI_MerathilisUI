local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local LR = MER:GetModule("MER_LootRoll")
local LSM = E.Libs.LSM

local options = module.options.modules.args

local function RequestRefresh()
	if LR and LR.Layout then
		LR:Layout()
		LR:UpdateAnchors()
	end
end

F.MarkTabAsNew("lootRoll")

options.lootRoll = {
	type = "group",
	name = module:AddCategorieIcon(L["Loot Roll"], "bags"),
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.NewFeatureText(F.cOption(L["Loot Roll"], "orange")),
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
			set = function(_, value)
				E.db.mui.lootRoll.enable = value
				E:StaticPopup_Show("PRIVATE_RL")
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
			disabled = function()
				return not E.db.mui.lootRoll.enable
			end,
		},
		spacer = {
			order = 4,
			type = "description",
			name = "",
		},
		layout = {
			order = 5,
			type = "group",
			guiInline = true,
			name = L["Layout"],
			disabled = function()
				return not E.db.mui.lootRoll.enable
			end,
			args = {
				growDirection = {
					order = 1,
					type = "select",
					name = L["Grow Direction"],
					values = {
						DOWN = L["Down"],
						UP = L["Up"],
					},
					get = function()
						return E.db.mui.lootRoll.growDirection
					end,
					set = function(_, value)
						E.db.mui.lootRoll.growDirection = value
						RequestRefresh()
					end,
				},
				maxBars = {
					order = 2,
					type = "range",
					name = L["Max Bars"],
					min = 1,
					max = 8,
					step = 1,
					get = function()
						return E.db.mui.lootRoll.maxBars
					end,
					set = function(_, value)
						E.db.mui.lootRoll.maxBars = value
						RequestRefresh()
					end,
				},
				spacing = {
					order = 3,
					type = "range",
					name = L["Spacing"],
					min = 0,
					max = 20,
					step = 1,
					get = function()
						return E.db.mui.lootRoll.spacing
					end,
					set = function(_, value)
						E.db.mui.lootRoll.spacing = value
						RequestRefresh()
					end,
				},
				width = {
					order = 4,
					type = "range",
					name = L["Width"],
					min = 180,
					max = 500,
					step = 1,
					get = function()
						return E.db.mui.lootRoll.width
					end,
					set = function(_, value)
						E.db.mui.lootRoll.width = value
						RequestRefresh()
					end,
				},
				height = {
					order = 5,
					type = "range",
					name = L["Height"],
					min = 24,
					max = 80,
					step = 1,
					get = function()
						return E.db.mui.lootRoll.height
					end,
					set = function(_, value)
						E.db.mui.lootRoll.height = value
						RequestRefresh()
					end,
				},
				buttonSize = {
					order = 6,
					type = "range",
					name = L["Button Size"],
					min = 12,
					max = 32,
					step = 1,
					get = function()
						return E.db.mui.lootRoll.buttonSize
					end,
					set = function(_, value)
						E.db.mui.lootRoll.buttonSize = value
						RequestRefresh()
					end,
				},
			},
		},
		colors = {
			order = 6,
			type = "group",
			guiInline = true,
			name = L["Colors"],
			disabled = function()
				return not E.db.mui.lootRoll.enable
			end,
			args = {
				qualityBorder = {
					order = 1,
					type = "toggle",
					name = L["Color Border by Quality"],
					get = function()
						return E.db.mui.lootRoll.qualityBorder
					end,
					set = function(_, value)
						E.db.mui.lootRoll.qualityBorder = value
						RequestRefresh()
					end,
				},
				qualityName = {
					order = 2,
					type = "toggle",
					name = L["Color Name by Quality"],
					get = function()
						return E.db.mui.lootRoll.qualityName
					end,
					set = function(_, value)
						E.db.mui.lootRoll.qualityName = value
						RequestRefresh()
					end,
				},
				qualityItemLevel = {
					order = 3,
					type = "toggle",
					name = L["Show Item Level"],
					get = function()
						return E.db.mui.lootRoll.qualityItemLevel
					end,
					set = function(_, value)
						E.db.mui.lootRoll.qualityItemLevel = value
						RequestRefresh()
					end,
				},
				qualityStatusBar = {
					order = 4,
					type = "toggle",
					name = L["Color Status Bar by Quality"],
					get = function()
						return E.db.mui.lootRoll.qualityStatusBar
					end,
					set = function(_, value)
						E.db.mui.lootRoll.qualityStatusBar = value
						RequestRefresh()
					end,
				},
				statusBarColor = {
					order = 5,
					type = "color",
					name = L["Custom Status Bar Color"],
					hasAlpha = false,
					disabled = function()
						return E.db.mui.lootRoll.qualityStatusBar or not E.db.mui.lootRoll.enable
					end,
					get = function()
						local db = E.db.mui.lootRoll.statusBarColor
						return db.r, db.g, db.b
					end,
					set = function(_, r, g, b)
						local db = E.db.mui.lootRoll.statusBarColor
						db.r, db.g, db.b = r, g, b
						RequestRefresh()
					end,
				},
				statusBarTexture = {
					order = 6,
					type = "select",
					dialogControl = "LSM30_Statusbar",
					name = L["Status Bar Texture"],
					values = LSM:HashTable("statusbar"),
					get = function()
						return E.db.mui.lootRoll.statusBarTexture
					end,
					set = function(_, value)
						E.db.mui.lootRoll.statusBarTexture = value
						RequestRefresh()
					end,
				},
			},
		},
		font = {
			order = 7,
			type = "group",
			guiInline = true,
			name = L["Font"],
			disabled = function()
				return not E.db.mui.lootRoll.enable
			end,
			args = {
				fontSize = {
					order = 1,
					type = "range",
					name = L["Font Size"],
					min = 8,
					max = 24,
					step = 1,
					get = function()
						return E.db.mui.lootRoll.fontSize
					end,
					set = function(_, value)
						E.db.mui.lootRoll.fontSize = value
						RequestRefresh()
					end,
				},
				fontOutline = {
					order = 2,
					type = "select",
					name = L["Font Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
					get = function()
						return E.db.mui.lootRoll.fontOutline
					end,
					set = function(_, value)
						E.db.mui.lootRoll.fontOutline = value
						RequestRefresh()
					end,
				},
			},
		},
		rollers = {
			order = 8,
			type = "group",
			guiInline = true,
			name = L["Rollers"],
			disabled = function()
				return not E.db.mui.lootRoll.enable
			end,
			args = {
				showRollers = {
					order = 1,
					type = "toggle",
					name = L["Show Rollers in Tooltip"],
					desc = L["Show who rolled Need/Greed/Disenchant/Pass in the item's tooltip.\n\nNote: on modern retail WoW this can currently only be populated for boss/encounter loot - it stays empty for regular group loot (e.g. trash mobs, world content)."],
					get = function()
						return E.db.mui.lootRoll.showRollers
					end,
					set = function(_, value)
						E.db.mui.lootRoll.showRollers = value
						RequestRefresh()
					end,
				},
			},
		},
	},
}
