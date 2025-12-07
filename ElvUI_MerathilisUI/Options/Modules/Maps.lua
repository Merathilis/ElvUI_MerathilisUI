local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args
local MERMM = MER:GetModule("MER_MiniMapCoords")

options.maps = {
	type = "group",
	name = L["Maps"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Maps"], "orange"),
		},
		miniMapCoords = {
			order = 1,
			type = "group",
			guiInline = true,
			name = F.cOption(L["Minimap Coordinates"], "orange"),
			get = function(info)
				return E.db.mui.miniMapCoords[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.miniMapCoords[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				desc = {
					order = 0,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						feature = {
							order = 1,
							type = "description",
							name = L["Add coords to your Minimap."],
							fontSize = "medium",
						},
					},
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				spacer = {
					order = 2,
					type = "description",
					name = "",
				},
				xOffset = {
					order = 3,
					type = "range",
					name = L["X-Offset"],
					min = -300,
					max = 300,
					step = 1,
				},
				yOffset = {
					order = 3,
					type = "range",
					name = L["Y-Offset"],
					min = -300,
					max = 300,
					step = 1,
				},
				mouseOver = {
					order = 4,
					type = "toggle",
					name = L["Mouse Over"],
				},
				font = {
					order = 7,
					type = "group",
					inline = true,
					name = L["Font"],
					get = function(info)
						return E.db.mui.miniMapCoords.font[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.miniMapCoords.font[info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = E.LSM:HashTable("font"),
						},
						size = {
							order = 2,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1,
						},
						style = {
							order = 3,
							type = "select",
							name = L["Outline"],
							values = MER.Values.FontFlags,
							sortByValue = true,
						},
						color = {
							order = 6,
							type = "color",
							name = L["Custom Color"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.mui.miniMapCoords.font[info[#info]]
								local default = P.miniMapCoords.font[info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.mui.miniMapCoords.font[info[#info]]
								db.r, db.g, db.b = r, g, b
								F.Event.TriggerEvent("MiniMapCoords.SettingsUpdate")
							end,
						},
					},
				},
			},
		},
	},
}
