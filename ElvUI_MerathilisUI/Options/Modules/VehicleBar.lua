local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")
local options = MER.options.modules.args
local LSM = E.Libs.LSM

options.vehicleBar = {
	type = "group",
	name = E.NewSign .. L["VehicleBar"],
	childGroups = "tab",
	get = function(info)
		return E.db.mui.vehicleBar[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.vehicleBar[info[#info]] = value
		F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
	end,
	disabled = function()
		return not E.private.actionbar.enable
	end,
	args = {
		name = {
			order = 1,
			type = "header",
			name = F.cOption(L["VehicleBar"], "orange"),
		},
		credits = {
			order = 2,
			type = "group",
			name = F.cOption(L["Credits"], "orange"),
			guiInline = true,
			args = {
				toxiui = {
					order = 1,
					type = "description",
					name = "|cff1784d1ElvUI|r |cffffffffToxi|r|cff18a8ffUI|r",
				},
			},
		},
		general = {
			order = 3,
			type = "group",
			name = L["General"],
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Toggling this on enables the " .. MER.Title .. " Vehicle Bar."],
				},
				buttonWidth = {
					order = 2,
					type = "range",
					name = L["Button Width"],
					desc = L["Change the Vehicle Bar's Button width. The height will scale accordingly in a 4:3 aspect ratio."],
					get = function()
						return E.db.mui.vehicleBar.buttonWidth
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.buttonWidth = value
						F.Event.TriggerEvent("VehicleBar.DatabaseUpdate")
					end,
				},
			},
		},
		animationsGroup = {
			order = 4,
			type = "group",
			name = L["Animations"],
			disabled = function()
				return not E.private.actionbar.enable or not E.db.mui.vehicleBar.enable
			end,
			args = {
				animations = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Toggling this on enables the " .. MER.Title .. " Vehicle Bar Animations."],
					get = function()
						return E.db.mui.vehicleBar.animations
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.animations = value
						F.Event.TriggerEvent("VehicleBar.DatabaseUpdate")
					end,
				},
				animationsMult = {
					order = 2,
					type = "range",
					name = L["Animation Speed"],
					min = 0.5,
					max = 2,
					step = 0.1,
					isPercent = true,
					get = function()
						return 1 / E.db.mui.vehicleBar.animationsMult
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.animationsMult = 1 / value
					end,
				},
			},
		},
		vigorGroupGroup = {
			order = 5,
			type = "group",
			name = L["Skyriding Bar"],
			disabled = function()
				return not E.private.actionbar.enable or not E.db.mui.vehicleBar.enable
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Toggling this on enables the " .. MER.Title .. " Skyriding Bar."],
					get = function(_)
						return E.db.mui.vehicleBar.vigorBar.enable
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.vigorBar.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				thrillColor = {
					order = 2,
					type = "color",
					name = L["Thrill Color"],
					desc = L["The color for vigor bar's speed text when you are regaining vigor."],
					hasAlpha = false,
					get = function(info)
						local colordb = E.db.mui.vehicleBar.vigorBar.thrillColor
						local default = P.vehicleBar.vigorBar.thrillColor
						return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						E.db.mui.vehicleBar.vigorBar.thrillColor = {
							r = r,
							g = g,
							b = b,
							a = a,
						}
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				texture = {
					order = 3,
					type = "select",
					name = L["Texture"],
					dialogControl = "LSM30_Statusbar",
					values = LSM:HashTable("statusbar"),
					get = function(_)
						return E.db.mui.vehicleBar.vigorBar.texture
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.vigorBar.texture = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
	},
}
