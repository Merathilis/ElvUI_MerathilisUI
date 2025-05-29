local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.general.args

options.name = {
	order = 1,
	type = "group",
	name = L["General"],
	get = function(info)
		return E.db.mui.general[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.general[info[#info]] = value
		E:StaticPopup_Show("CONFIG_RL")
	end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["General"], "orange"),
		},
		style = {
			order = 2,
			type = "group",
			name = MER.Title .. L["Style"],
			guiInline = true,
			get = function(info)
				return E.db.mui.style[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.style[info[#info]] = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enables the stripes/gradient look on the frames"],
				},
			},
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
	},
}
