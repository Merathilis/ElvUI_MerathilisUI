local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local options = MER.options.general.args

options.name = {
	order = 1,
	type = "group",
	name = L["General"],
	get = function(info) return E.db.mui.general[ info[#info] ] end,
	set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["General"], 'orange'),
		},
		splashScreen = {
			order = 2,
			type = "toggle",
			name = L["SplashScreen"],
			desc = L["Enable/Disable the Splash Screen on Login."],
		},
		AFK = {
			order = 3,
			type = "toggle",
			name = L["AFK"],
			desc = L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"],
		},
		GameMenu = {
			order = 4,
			type = "toggle",
			name = L["GameMenu"],
			desc = L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu. (e.g. Pepe, Logo, Bars)"],
		},
		FlightPoint = {
			order = 5,
			type = "toggle",
			name = L["Flight Point"],
			desc = L["Enable/Disable the MerathilisUI Flight Points on the FlightMap."],
			hidden = function() return IsAddOnLoaded("WorldFlightMap") end,
		},
	},
}
