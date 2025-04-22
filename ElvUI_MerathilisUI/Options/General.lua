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
		GameMenu = {
			order = 5,
			type = "group",
			name = L["GameMenu"],
			guiInline = true,
			get = function(info)
				return E.db.mui.gameMenu[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.gameMenu[info[#info]] = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu. (e.g. Pepe, Logo, Bars)"],
				},
				bgColor = {
					order = 2,
					type = "color",
					name = L["Background Color"],
					hasAlpha = true,
					get = function(info)
						local t = E.db.mui.gameMenu[info[#info]]
						local d = P.gameMenu[info[#info]]
						return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mui.gameMenu[info[#info]]
						t.r, t.g, t.b, t.a = r, g, b, a
					end,
					disabled = function()
						return not E.db.mui.gameMenu.enable
					end,
				},
				info = {
					order = 2,
					type = "group",
					name = L["Info"],
					guiInline = true,
					hidden = function()
						return not E.db.mui.gameMenu.enable
					end,
					args = {
						showCollections = {
							order = 1,
							type = "toggle",
							name = L["Show Collections"],
						},
						showWeeklyDevles = {
							order = 2,
							type = "toggle",
							name = L["Show Weekly Delves Keys"],
						},
						mythic = {
							order = 3,
							type = "group",
							name = L["Mythic+"],
							args = {
								showMythicKey = {
									order = 1,
									type = "toggle",
									name = L["Show Mythic+ Infos"],
								},
								showMythicScore = {
									order = 2,
									type = "toggle",
									name = L["Show Mythic+ Score"],
									disabled = function()
										return not E.db.mui.gameMenu.enable or not E.db.mui.gameMenu.showMythicKey
									end,
								},
								mythicHistoryLimit = {
									order = 3,
									type = "range",
									name = L["History Limit"],
									desc = L["Number of Mythic+ dungeons shown in the latest runs."],
									min = 1,
									max = 10,
									step = 1,
									get = function()
										return E.db.mui.gameMenu.mythicHistoryLimit
									end,
									set = function(_, value)
										E.db.mui.gameMenu.mythicHistoryLimit = value
									end,
									disabled = function()
										return not E.db.mui.gameMenu.enable or not E.db.mui.gameMenu.showMythicKey
									end,
								},
							},
						},
					},
				},
			},
		},
	},
}
