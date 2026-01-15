local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")
local options = MER.options.modules.args
local LSM = E.Libs.LSM

options.vehicleBar = {
	type = "group",
	name = L["VehicleBar"],
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
					get = function()
						return E.db.mui.vehicleBar.enable
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.enable = value
						F.Event.TriggerEvent("VehicleBar.DatabaseUpdate")
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				elvuiBars = {
					order = 2,
					type = "toggle",
					name = L["Hide ElvUI Bars"],
					get = function()
						return E.db.mui.vehicleBar.hideElvUIBars
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.hideElvUIBars = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		buttonGroup = {
			order = 4,
			type = "group",
			name = L["Buttons"],
			desc = L["Settings for the Action Bar Buttons of the Vehicle Bar.\n\n"],
			args = {
				buttonWidth = {
					order = 1,
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
				showKeybinds = {
					order = 2,
					type = "toggle",
					name = L["Show Keybinds"],
					desc = L["Toggle whether to show keybinds of an action bar button on the Vehicle Bar."],
					get = function()
						return E.db.mui.vehicleBar.showKeybinds
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.showKeybinds = value
						F.Event.TriggerEvent("VehicleBar.DatabaseUpdate")
					end,
				},
				showMacro = {
					order = 3,
					type = "toggle",
					name = L["Show Macro Text"],
					desc = L["Toggle whether to show macro text of an action bar button on the Vehicle Bar."],
					get = function()
						return E.db.mui.vehicleBar.showMacro
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.showMacro = value
						F.Event.TriggerEvent("VehicleBar.DatabaseUpdate")
					end,
				},
			},
		},
		vigorBargGroup = {
			order = 5,
			type = "group",
			name = L["Vigor Bar"],
			disabled = function()
				return not E.private.actionbar.enable or not E.db.mui.vehicleBar.enable
			end,
			args = {
				vigorBar = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function()
						return E.db.mui.vehicleBar.vigorBar.enable
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.vigorBar.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				vigorBarBarHeader = {
					order = 2,
					type = "header",
					name = F.cOption(L["Bar Settings"], "orange"),
				},
				height = {
					order = 3,
					type = "range",
					name = L["Bar Height"],
					desc = L["Change the Skyriding Bar's height."],
					min = 4,
					max = 20,
					step = 1,
					get = function()
						return E.db.mui.vehicleBar.vigorBar.height
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.vigorBar.height = value
						F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
					end,
				},
				normalTexture = {
					order = 4,
					type = "select",
					name = L["Normal Texture"],
					desc = L["Vigor bar texture for Normal and Gradient Mode"],
					dialogControl = "LSM30_Statusbar",
					values = LSM:HashTable("statusbar"),
					get = function()
						return E.db.mui.vehicleBar.vigorBar.normalTexture
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.vigorBar.normalTexture = value
						F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
					end,
				},
				darkTexture = {
					order = 5,
					type = "select",
					name = L["Dark Texture"],
					desc = L["Vigor bar texture for Dark Mode."],
					dialogControl = "LSM30_Statusbar",
					values = LSM:HashTable("statusbar"),
					get = function()
						return E.db.mui.vehicleBar.vigorBar.darkTexture
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.vigorBar.darkTexture = value
						F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
					end,
				},
				vigorBarcolorHeader = {
					order = 6,
					type = "header",
					name = F.cOption(L["Color Settings"], "orange"),
				},
				useCustomColor = {
					order = 7,
					type = "toggle",
					name = L["Use Custom Color"],
					get = function()
						return E.db.mui.vehicleBar.vigorBar.useCustomColor
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.vigorBar.useCustomColor = value
						F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
					end,
				},
				customColorLeft = {
					order = 8,
					type = "color",
					name = L["Left Color"],
					disabled = function()
						return not E.db.mui.vehicleBar.vigorBar.useCustomColor
					end,
					get = function()
						local t = E.db.mui.vehicleBar.vigorBar.customColorLeft
						return t.r, t.g, t.b, t.a
					end,
					set = function(_, r, g, b, a)
						local t = E.db.mui.vehicleBar.vigorBar.customColorLeft
						t.r, t.g, t.b, t.a = r, g, b, a
						F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
					end,
				},
				customColorRight = {
					order = 9,
					type = "color",
					name = L["Right Color"],
					disabled = function()
						return not E.db.mui.vehicleBar.vigorBar.useCustomColor
					end,
					get = function()
						local t = E.db.mui.vehicleBar.vigorBar.customColorRight
						return t.r, t.g, t.b, t.a
					end,
					set = function(_, r, g, b, a)
						local t = E.db.mui.vehicleBar.vigorBar.customColorRight
						t.r, t.g, t.b, t.a = r, g, b, a
						F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
					end,
				},
				speedTextHeader = {
					order = 10,
					type = "header",
					name = F.cOption(L["Speed Text Settings"], "orange"),
				},
				showSpeedText = {
					order = 11,
					type = "toggle",
					name = L["Show Speed Text"],
					get = function()
						return E.db.mui.vehicleBar.vigorBar.showSpeedText
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.vigorBar.showSpeedText = value
						F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
					end,
				},
				thrillColor = {
					order = 12,
					type = "color",
					name = L["Thrill Color"],
					get = function()
						local t = E.db.mui.vehicleBar.vigorBar.thrillColor
						return t.r, t.g, t.b, t.a
					end,
					set = function(_, r, g, b, a)
						local t = E.db.mui.vehicleBar.vigorBar.thrillColor
						t.r, t.g, t.b, t.a = r, g, b, a
						F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
					end,
				},
				speedTextFont = {
					order = 13,
					type = "select",
					name = L["Font"],
					dialogControl = "LSM30_Font",
					values = LSM:HashTable("font"),
					get = function()
						return E.db.mui.vehicleBar.vigorBar.speedTextFont
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.vigorBar.speedTextFont = value
						F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
					end,
				},
				speedTextOffsetY = {
					order = 14,
					type = "range",
					name = L["Offset Y"],
					min = -10,
					max = 10,
					step = 1,
					get = function()
						return E.db.mui.vehicleBar.vigorBar.speedTextOffsetY
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.vigorBar.speedTextOffsetY = value
						F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
					end,
				},
				speedTextUpdateRate = {
					order = 15,
					type = "range",
					name = L["Update Rate"],
					desc = L["How often the speed text is updated."],
					min = 0.05,
					max = 1,
					step = 0.05,
					get = function()
						return E.db.mui.vehicleBar.vigorBar.speedTextUpdateRate
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.vigorBar.speedTextUpdateRate = value
						F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
					end,
				},
			},
		},
		animationsGroup = {
			order = 6,
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
	},
}
