local MER, F, E, L, V, P, G = unpack(select(2, ...))
local options = MER.options.modules.args

local format = string.format

options.flightMode = {
	type = "group",
	name = L["FlightMode"],
	get = function(info) return E.db.mui.flightMode[ info[#info] ] end,
	set = function(info, value) E.db.mui.flightMode[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["FlightMode"], 'orange'),
		},
		credits = {
			order = 2,
			type = "group",
			name = F.cOption(L["Credits"], 'orange'),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "description",
					name = format("|cff00c0faBenikUI|r"),
				},
			},
		},
		enable = {
			order = 3,
			type = "toggle",
			name = L["Enable"],
		},
		BenikFlightMode = {
			order = 4,
			type = "toggle",
			name = L["|cff00c0faBenikUI|r FlightMode"],
			desc = L["Enhance the |cff00c0faBenikUI|r FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options."],
			hidden = function() return not IsAddOnLoaded("ElvUI_BenikUI") end,
		},
	},
}
