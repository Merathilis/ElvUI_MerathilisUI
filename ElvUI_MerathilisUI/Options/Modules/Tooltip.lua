local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local TT = MER:GetModule("MER_Tooltip")

	local options = module.options.modules.args

	F.MarkTabAsNew("tooltip")

	local function BuffsDB()
		return E.db.mui.tooltip.buffs
	end

	local function BuffsDisabled()
		return not BuffsDB().enable
	end

	options.tooltip = {
		type = "group",
		name = module:AddCategorieIcon(L["Tooltip"], "tooltip"),
		args = {
			header = {
				order = 0,
				type = "header",
				name = L["Tooltip"],
			},
			achievement = module.ToggleCard({
				order = 1,
				name = L["Achievement"],
				desc = L["Shows on achievement links who earned the achievement and whether you have completed it too."],
				get = function()
					return E.db.mui.tooltip.achievement
				end,
				set = function(_, value)
					E.db.mui.tooltip.achievement = value
					MER:GetModule("MER_Tooltip"):InitializeAchievement()
				end,
			}),
			buffs = {
				order = 2,
				type = "group",
				inline = true,
				name = L["Buffs"],
				get = function(info)
					return BuffsDB()[info[#info]]
				end,
				set = function(info, value)
					BuffsDB()[info[#info]] = value
					TT:UpdateBuffs()
				end,
				args = {
					enable = module.ToggleCard({
						order = 1,
						name = F.NewFeatureText(L["Enable"]),
						desc = L["Shows the buffs of the hovered unit as icons on the tooltip."],
					}),
					preview = module.PreviewOption(1.5, "MERTooltipBuffsPreview", "tooltip"),
					playersOnly = {
						order = 2,
						type = "toggle",
						name = L["Players Only"],
						desc = L["Only show buffs on the tooltip of players."],
						disabled = BuffsDisabled,
					},
					position = {
						order = 3,
						type = "select",
						name = L["Position"],
						disabled = BuffsDisabled,
						values = {
							BOTTOM = L["Bottom"],
							TOP = L["Top"],
							LEFT = L["Left"],
							RIGHT = L["Right"],
						},
					},
					spacer = {
						order = 4,
						type = "description",
						name = "",
						width = "full",
					},
					size = {
						order = 5,
						type = "range",
						name = L["Icon Size"],
						disabled = BuffsDisabled,
						min = 12,
						max = 40,
						step = 1,
					},
					spacing = {
						order = 6,
						type = "range",
						name = L["Spacing"],
						disabled = BuffsDisabled,
						min = 0,
						max = 10,
						step = 1,
					},
					perRow = {
						order = 7,
						type = "range",
						name = L["Icons Per Row"],
						disabled = BuffsDisabled,
						min = 1,
						max = 16,
						step = 1,
					},
					maxIcons = {
						order = 8,
						type = "range",
						name = L["Max Icons"],
						disabled = BuffsDisabled,
						min = 1,
						max = 40,
						step = 1,
					},
					countFontSize = {
						order = 9,
						type = "range",
						name = L["Stack Font Size"],
						disabled = BuffsDisabled,
						min = 6,
						max = 20,
						step = 1,
					},
					xOffset = {
						order = 10,
						type = "range",
						name = L["X-Offset"],
						disabled = BuffsDisabled,
						min = -100,
						max = 100,
						step = 1,
					},
					yOffset = {
						order = 11,
						type = "range",
						name = L["Y-Offset"],
						disabled = BuffsDisabled,
						min = -100,
						max = 100,
						step = 1,
					},
				},
			},
		},
	}
end)
