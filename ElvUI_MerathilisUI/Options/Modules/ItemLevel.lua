local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local IL = MER:GetModule('MER_ItemLevel')
local options = MER.options.modules.args
local LSM = E.LSM

options.itemLevel = {
	type = "group",
	name = L["Item Level"],
	get = function(info)
		return E.db.mui.itemLevel[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.itemLevel[info[#info]] = value
		IL:ProfileUpdate()
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Item Level"], 'orange'),
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
					name = L["Add an extra item level text to some equipment buttons."],
					fontSize = "medium"
				}
			}
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			width = "full"
		},
		flyout = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Flyout Button"],
			disabled = function()
				return not E.db.mui.itemLevel.enable
			end,
			get = function(info)
				return E.db.mui.itemLevel.flyout[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.itemLevel.flyout[info[#info]] = value
			end,
			args = {
				enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					width = "full"
				},
				font = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Font"],
					get = function(info)
						return E.db.mui.itemLevel.flyout.font[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.itemLevel.flyout.font[info[#info]] = value
					end,
					disabled = function()
						return E.db.mui.itemLevel.flyout.useBagsFontSetting or not E.db.mui.itemLevel.enable
					end,
					args = {
						useBagsFontSetting = {
							order = 0,
							get = function(info)
								return E.db.mui.itemLevel.flyout[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.itemLevel.flyout[info[#info]] = value
							end,
							disabled = function()
								return not E.db.mui.itemLevel.enable
							end,
							type = "toggle",
							name = L["Use Bags Setting"],
							desc = L["Render the item level text with the setting in ElvUI bags."]
						},
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font")
						},
						style = {
							order = 2,
							type = "select",
							name = L["Outline"],
							values = {
								NONE = L["None"],
								OUTLINE = L["OUTLINE"],
								MONOCHROME = L["MONOCHROME"],
								MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
								THICKOUTLINE = L["THICKOUTLINE"]
							}
						},
						size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1
						},
						xOffset = {
							order = 4,
							name = L["X-Offset"],
							type = "range",
							min = -50,
							max = 50,
							step = 1
						},
						yOffset = {
							order = 5,
							name = L["Y-Offset"],
							type = "range",
							min = -50,
							max = 50,
							step = 1
						}
					}
				},
				color = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Color"],
					disabled = function()
						return E.db.mui.itemLevel.flyout.qualityColor or not E.db.mui.itemLevel.enable
					end,
					args = {
						qualityColor = {
							order = 0,
							get = function(info)
								return E.db.mui.itemLevel.flyout[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.itemLevel.flyout[info[#info]] = value
							end,
							disabled = function()
								return not E.db.mui.itemLevel.enable
							end,
							type = "toggle",
							name = L["Quality Color"]
						},
						color = {
							order = 6,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.mui.itemLevel.flyout.font.color
								local default = P.itemLevel.flyout.font.color
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.mui.itemLevel.flyout.font.color
								db.r, db.g, db.b = r, g, b
							end
						},
					},
				},
			},
		},
		scrappingMachine = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Scrapping Machine"],
			disabled = function()
				return not E.db.mui.itemLevel.enable
			end,
			get = function(info)
				return E.db.mui.itemLevel.scrappingMachine[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.itemLevel.scrappingMachine[info[#info]] = value
			end,
			args = {
				enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					width = "full"
				},
				font = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Font"],
					get = function(info)
						return E.db.mui.itemLevel.scrappingMachine.font[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.itemLevel.scrappingMachine.font[info[#info]] = value
					end,
					disabled = function()
						return E.db.mui.itemLevel.scrappingMachine.useBagsFontSetting or
							not E.db.mui.itemLevel.enable
					end,
					args = {
						useBagsFontSetting = {
							order = 0,
							get = function(info)
								return E.db.mui.itemLevel.scrappingMachine[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.itemLevel.scrappingMachine[info[#info]] = value
							end,
							disabled = function()
								return not E.db.mui.itemLevel.enable
							end,
							type = "toggle",
							name = L["Use Bags Setting"],
							desc = L["Render the item level text with the setting in ElvUI bags."]
						},
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font")
						},
						style = {
							order = 2,
							type = "select",
							name = L["Outline"],
							values = {
								NONE = L["None"],
								OUTLINE = L["OUTLINE"],
								MONOCHROME = L["MONOCHROME"],
								MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
								THICKOUTLINE = L["THICKOUTLINE"]
							}
						},
						size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1
						},
						xOffset = {
							order = 4,
							name = L["X-Offset"],
							type = "range",
							min = -50,
							max = 50,
							step = 1
						},
						yOffset = {
							order = 5,
							name = L["Y-Offset"],
							type = "range",
							min = -50,
							max = 50,
							step = 1
						},
					},
				},
				color = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Color"],
					disabled = function()
						return E.db.mui.itemLevel.scrappingMachine.qualityColor or not E.db.mui.itemLevel.enable
					end,
					args = {
						qualityColor = {
							order = 0,
							get = function(info)
								return E.db.mui.itemLevel.scrappingMachine[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.itemLevel.scrappingMachine[info[#info]] = value
							end,
							disabled = function()
								return not E.db.mui.itemLevel.enable
							end,
							type = "toggle",
							name = L["Quality Color"]
						},
						color = {
							order = 6,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.mui.itemLevel.scrappingMachine.font.color
								local default = P.itemLevel.scrappingMachine.font.color
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.mui.itemLevel.scrappingMachine.font.color
								db.r, db.g, db.b = r, g, b
							end
						},
					},
				},
			},
		},
	},
}
