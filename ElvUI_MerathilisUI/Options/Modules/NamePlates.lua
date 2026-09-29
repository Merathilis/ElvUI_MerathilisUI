local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

local MNP = MER:GetModule("MER_Nameplates")

local options = module.options.modules.args

-- Own disabled replaces the group's, so the children repeat the requirement
local function FactionIndicatorDisabled()
	return not MER:HasRequirements(I.Requirements.NamePlates) or not E.db.mui.nameplates.factionIndicator.enable
end

options.nameplates = {
	type = "group",
	name = module:AddCategorieIcon(L["NamePlates"], "nameplates"),
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["NamePlates"],
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			args = {
				factionIndicator = {
					order = 1,
					type = "group",
					name = L["Faction Indicator"],
					guiInline = true,
					get = function(info)
						return E.db.mui.nameplates.factionIndicator[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.nameplates.factionIndicator[info[#info]] = value
						MNP:UpdateFactionIndicators()
					end,
					disabled = module.RequirementsDisabled(I.Requirements.NamePlates),
					args = {
						requirements = module.RequirementsNotice(I.Requirements.NamePlates),
						desc = {
							order = 1,
							type = "description",
							name = L["Shows the faction icon of players from the opposing faction."],
						},
						enable = {
							order = 2,
							type = "toggle",
							name = L["Enable"],
						},
						style = {
							order = 3,
							type = "select",
							name = L["Style"],
							disabled = FactionIndicatorDisabled,
							values = {
								crest = L["Crest"],
								round = L["Round"],
							},
						},
						size = {
							order = 4,
							type = "range",
							name = L["Size"],
							disabled = FactionIndicatorDisabled,
							min = 8,
							max = 60,
							step = 1,
						},
						position = {
							order = 5,
							type = "select",
							name = L["Anchor Point"],
							disabled = FactionIndicatorDisabled,
							values = I.Values.positionValues,
						},
						xOffset = {
							order = 6,
							type = "range",
							name = L["X-Offset"],
							disabled = FactionIndicatorDisabled,
							min = -100,
							max = 100,
							step = 1,
						},
						yOffset = {
							order = 7,
							type = "range",
							name = L["Y-Offset"],
							disabled = FactionIndicatorDisabled,
							min = -100,
							max = 100,
							step = 1,
						},
					},
				},
			},
		},
	},
}
