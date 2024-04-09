local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_RaidMarkers")
local options = MER.options.modules.args

local format = string.format

options.raidmarkers = {
	type = "group",
	name = L["Raid Markers"],
	args = {
		name = {
			order = 0,
			type = "header",
			name = F.cOption(L["Raid Markers"], "orange"),
		},
		desc = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = L["Add an extra bar to let you set raid markers efficiently."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			desc = L["Toggle raid markers bar."],
			get = function(info)
				return E.db.mui.raidmarkers[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.raidmarkers[info[#info]] = value
				module:ProfileUpdate()
			end,
		},
		inverse = {
			order = 3,
			type = "toggle",
			name = L["Inverse Mode"],
			desc = L["Swap the functionality of normal click and click with modifier keys."],
			get = function(info)
				return E.db.mui.raidmarkers[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.raidmarkers[info[#info]] = value
				module:ToggleSettings()
			end,
			disabled = function()
				return not E.db.mui.raidmarkers.enable
			end,
			width = 2,
		},
		visibilityConfig = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Visibility"],
			get = function(info)
				return E.db.mui.raidmarkers[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.raidmarkers[info[#info]] = value
				module:ToggleSettings()
			end,
			disabled = function()
				return not E.db.mui.raidmarkers.enable
			end,
			args = {
				visibility = {
					type = "select",
					order = 1,
					name = L["Visibility"],
					values = {
						DEFAULT = L["Default"],
						INPARTY = L["In Party"],
						ALWAYS = L["Always Display"],
					},
				},
				mouseOver = {
					order = 2,
					type = "toggle",
					name = L["Mouse Over"],
					desc = L["Only show raid markers bar when you mouse over it."],
				},
				tooltip = {
					order = 3,
					type = "toggle",
					name = L["Tooltip"],
					desc = L["Show the tooltip when you mouse over the button."],
				},
				modifier = {
					order = 4,
					type = "select",
					name = L["Modifier Key"],
					desc = L["Set the modifier key for placing world markers."],
					values = {
						shift = L["Shift Key"],
						ctrl = L["Ctrl Key"],
						alt = L["Alt Key"],
					},
				},
			},
		},
		barConfig = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Raid Markers Bar"],
			get = function(info)
				return E.db.mui.raidmarkers[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.raidmarkers[info[#info]] = value
				module:ToggleSettings()
			end,
			disabled = function()
				return not E.db.mui.raidmarkers.enable
			end,
			args = {
				backdrop = {
					order = 1,
					type = "toggle",
					name = L["Bar Backdrop"],
					desc = L["Show a backdrop of the bar."],
				},
				backdropSpacing = {
					order = 2,
					type = "range",
					name = L["Backdrop Spacing"],
					desc = L["The spacing between the backdrop and the buttons."],
					min = 1,
					max = 30,
					step = 1,
				},
				orientation = {
					order = 3,
					type = "select",
					name = L["Orientation"],
					desc = L["Arrangement direction of the bar."],
					values = {
						HORIZONTAL = L["Horizontal"],
						VERTICAL = L["Vertical"],
					},
				},
			},
		},
		raidButtons = {
			order = 6,
			type = "group",
			inline = true,
			name = L["Raid Buttons"],
			get = function(info)
				return E.db.mui.raidmarkers[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.raidmarkers[info[#info]] = value
				module:UpdateBar()
				module:UpdateCountDownButton()
			end,
			disabled = function()
				return not E.db.mui.raidmarkers.enable
			end,
			args = {
				readyCheck = {
					order = 1,
					type = "toggle",
					name = L["Ready Check"] .. " / " .. L["Advanced Combat Logging"],
					desc = format(
						"%s\n%s",
						L["Left Click to ready check."],
						L["Right click to toggle advanced combat logging."]
					),
					width = 2,
				},
				countDown = {
					order = 2,
					type = "toggle",
					name = L["Count Down"],
				},
				countDownTime = {
					order = 3,
					type = "range",
					name = L["Count Down Time"],
					desc = L["Count down time in seconds."],
					min = 1,
					max = 30,
					step = 1,
				},
			},
		},
		buttonsConfig = {
			order = 7,
			type = "group",
			inline = true,
			name = L["Buttons"],
			get = function(info)
				return E.db.mui.raidmarkers[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.raidmarkers[info[#info]] = value
				module:ToggleSettings()
			end,
			disabled = function()
				return not E.db.mui.raidmarkers.enable
			end,
			args = {
				buttonSize = {
					order = 1,
					type = "range",
					name = L["Button Size"],
					desc = L["The size of the buttons."],
					min = 15,
					max = 60,
					step = 1,
				},
				spacing = {
					order = 2,
					type = "range",
					name = L["Button Spacing"],
					desc = L["The spacing between buttons."],
					min = 1,
					max = 30,
					step = 1,
				},
				buttonBackdrop = {
					order = 3,
					type = "toggle",
					name = L["Button Backdrop"],
				},
				buttonAnimation = {
					order = 4,
					type = "toggle",
					name = L["Button Animation"],
				},
			},
		},
	},
}
