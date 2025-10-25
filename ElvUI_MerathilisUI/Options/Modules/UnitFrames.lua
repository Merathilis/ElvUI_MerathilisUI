local MER, W, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local options = MER.options.modules.args
local C = MER.Utilities.Color
local LSM = E.Libs.LSM

local format = string.format

options.unitframes = {
	type = "group",
	name = L["UnitFrames"],
	childGroups = "tab",
	get = function(info)
		return E.db.mui.unitframes[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.unitframes[info[#info]] = value
	end,
	disabled = function()
		return not E.private.unitframe.enable
	end,
	args = {
		name = {
			order = 1,
			type = "header",
			name = F.cOption(L["UnitFrames"], "orange"),
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			args = {
				style = {
					order = 1,
					type = "toggle",
					name = L["UnitFrame Style"],
					desc = L["Adds my styling to the Unitframes if you use transparent health."],
				},
				raidIcons = {
					order = 2,
					type = "toggle",
					name = L["Raid Icon"],
					desc = L["Change the default raid icons."],
				},
				highlight = {
					order = 4,
					type = "toggle",
					name = L["Highlight"],
					desc = L["Adds an own highlight to the Unitframes"],
				},
				auras = {
					order = 5,
					type = "toggle",
					name = L["Auras"],
					desc = L["Adds an shadow around the auras"],
				},
				spacer = {
					order = 10,
					type = "description",
					name = "",
				},
				power = {
					order = 11,
					type = "group",
					name = F.cOption(L["Power"], "orange"),
					guiInline = true,
					get = function(info)
						return E.db.mui.unitframes.power[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.unitframes.power[info[#info]] = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					args = {
						texture = {
							order = 1,
							type = "select",
							name = L["Power"],
							desc = L["Power statusbar texture."],
							dialogControl = "LSM30_Statusbar",
							values = LSM:HashTable("statusbar"),
							-- function() return not E.db.mui.unitframes.power.enable end,
							get = function(info)
								return E.db.mui.unitframes.power[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.unitframes.power[info[#info]] = value
								module:ChangePowerBarTexture()
							end,
						},
					},
				},
				castbar = {
					order = 12,
					type = "group",
					name = F.cOption(L["Castbar"], "orange"),
					guiInline = true,
					get = function(info)
						return E.db.mui.unitframes.castbar[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.unitframes.castbar[info[#info]] = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
						},
						texture = {
							order = 2,
							type = "select",
							name = L["Texture"],
							dialogControl = "LSM30_Statusbar",
							values = LSM:HashTable("statusbar"),
							disabled = function()
								return not E.db.mui.unitframes.castbar.enable
							end,
						},
						spacer = {
							order = 3,
							type = "description",
							name = " ",
						},
						spark = {
							order = 10,
							type = "group",
							name = F.cOption(L["Spark"], "orange"),
							guiInline = true,
							get = function(info)
								return E.db.mui.unitframes.castbar.spark[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.unitframes.castbar.spark[info[#info]] = value
								E:StaticPopup_Show("CONFIG_RL")
							end,
							disabled = function()
								return not E.db.mui.unitframes.castbar.enable
							end,
							args = {
								enable = {
									order = 1,
									type = "toggle",
									name = L["Enable"],
								},
								texture = {
									order = 2,
									type = "select",
									name = L["Spark Texture"],
									dialogControl = "LSM30_Statusbar",
									values = LSM:HashTable("statusbar"),
								},
								color = {
									order = 3,
									type = "color",
									name = _G.COLOR,
									hasAlpha = false,
									disabled = function()
										return not E.db.mui.unitframes.castbar.enable
											or not E.db.mui.unitframes.castbar.spark.enable
									end,
									get = function(info)
										local t = E.db.mui.unitframes.castbar.spark[info[#info]]
										local d = P.unitframes.castbar.spark[info[#info]]
										return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mui.unitframes.castbar.spark[info[#info]]
										t.r, t.g, t.b, t.a = r, g, b, a
										E:StaticPopup_Show("CONFIG_RL")
									end,
								},
								width = {
									order = 4,
									type = "range",
									name = L["Size"],
									min = 2,
									max = 10,
									step = 1,
									disabled = function()
										return not E.db.mui.unitframes.castbar.enable
											or not E.db.mui.unitframes.castbar.spark.enable
									end,
								},
							},
						},
					},
				},
			},
		},
		individualUnits = {
			order = 3,
			type = "group",
			name = L["Individual Units"],
			args = {
				player = {
					order = 1,
					type = "group",
					name = L["Player"],
					args = {
						restingIndicator = {
							order = 1,
							type = "group",
							name = F.cOption(L["Resting Indicator"], "orange"),
							guiInline = true,
							get = function(info)
								return E.db.mui.unitframes.restingIndicator[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.unitframes.restingIndicator[info[#info]] = value
								E:StaticPopup_Show("PRIVATE_RL")
							end,
							disabled = function()
								return not E.db.unitframe.units.player.enable
									or not E.db.unitframe.units.player.RestIcon.enable
							end,
							args = {
								enable = {
									order = 1,
									type = "toggle",
									name = L["Enable"],
								},
								customClassColor = {
									order = 2,
									type = "toggle",
									name = L["Custom Gradient Color"],
								},
							},
						},
					},
				},
			},
		},
		groupUnits = {
			order = 4,
			type = "group",
			name = L["Group Units"],
			args = {
				party = {
					order = 1,
					type = "group",
					name = L["Party"],
					args = {},
				},
			},
		},
	},
}
