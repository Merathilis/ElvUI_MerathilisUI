local MER, F, E, L, V, P, G = unpack(select(2, ...))
local options = MER.options.general.args

options.name = {
	order = 1,
	type = "group",
	name = L["General"],
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["General"], 'orange'),
		},
		LoginMsg = {
			order = 2,
			type = "toggle",
			name = L["Login Message"],
			desc = L["Enable/Disable the Login Message in Chat"],
		},
		splashScreen = {
			order = 3,
			type = "toggle",
			name = L["SplashScreen"],
			desc = L["Enable/Disable the Splash Screen on Login."],
		},
		AFK = {
			order = 4,
			type = "toggle",
			name = L["AFK"],
			desc = L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"],
		},
		GameMenu = {
			order = 5,
			type = "toggle",
			name = L["GameMenu"],
			desc = L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu. (e.g. Pepe, Logo, Bars)"],
		},
		FlightPoint = {
			order = 6,
			type = "toggle",
			name = L["Flight Point"],
			desc = L["Enable/Disable the MerathilisUI Flight Points on the FlightMap."],
			hidden = function() return IsAddOnLoaded("WorldFlightMap") end,
		},
		shadow = {
			order = 7,
			type = "group",
			name = F.cOption(L["Shadows"], 'orange'),
			guiInline = true,
			get = function(info) return E.db.mui.general.shadow[ info[#info] ] end,
			set = function(info, value) E.db.mui.general.shadow[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				increasedSize = {
					order = 2,
					type = "range",
					name = L["Increase Size"],
					desc = L["Make shadow thicker."],
					min = 0, max = 10, step = 1
				},
			},
		},
	},
}