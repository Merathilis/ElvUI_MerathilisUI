local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

local MNP = MER:GetModule("MER_Nameplates")

local options = module.options.modules.args

options.nameplates = {
	type = "group",
	name = module:AddCategorieIcon(L["NamePlates"], "nameplates"),
	get = function(info)
		return E.db.mui.nameplates[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.nameplates[info[#info]] = value
		E:StaticPopup_Show("GLOBAL_RL")
	end,
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
					disabled = function()
						return not E.private.nameplates.enable
					end,
					args = {
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
							values = {
								crest = L["Crest"],
								round = L["Round"],
							},
						},
						size = {
							order = 4,
							type = "range",
							name = L["Size"],
							min = 8,
							max = 60,
							step = 1,
						},
						position = {
							order = 5,
							type = "select",
							name = L["Anchor Point"],
							values = {
								TOPLEFT = "TOPLEFT",
								LEFT = "LEFT",
								BOTTOMLEFT = "BOTTOMLEFT",
								RIGHT = "RIGHT",
								TOPRIGHT = "TOPRIGHT",
								BOTTOMRIGHT = "BOTTOMRIGHT",
								CENTER = "CENTER",
								TOP = "TOP",
								BOTTOM = "BOTTOM",
							},
						},
						xOffset = {
							order = 6,
							type = "range",
							name = L["X-Offset"],
							min = -100,
							max = 100,
							step = 1,
						},
						yOffset = {
							order = 7,
							type = "range",
							name = L["Y-Offset"],
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
