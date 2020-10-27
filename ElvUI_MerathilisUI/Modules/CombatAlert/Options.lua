local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_CombatText')

local function CVars()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.CombatAlert = {
		type = "group",
		name = L["Combat Alert"],
		get = function(info) return E.db.mui.CombatAlert[info[#info]] end,
		set = function(info, value) E.db.mui.CombatAlert[info[#info]] = value E:StaticPopup_Show("PRIVATE_RL") end,
		args = {
			CombatAlertHeader = ACH:Header(MER:cOption(L["Combat Alert"], 'orange'), 0),
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				desc = L["Enable/Disable the combat message if you enter/leave the combat."]
			},
			font = {
				order = 2,
				name = MER:cOption(L["Font"], 'orange'),
				type = "group",
				guiInline = true,
				get = function(info) return E.db.mui.CombatAlert[info[#info - 1]][info[#info]] end,
				set = function(info, value) E.db.mui.CombatAlert[info[#info - 1]][info[#info]] = value; module:RefreshAlert() end,
				args = {
					name = {
						order = 1,
						type = 'select', dialogControl = 'LSM30_Font',
						name = L["Font"],
						values = E.LSM:HashTable('font'),
					},
					size = {
						order = 3,
						name = L["Size"],
						type = 'range',
						min = 5, max = 60, step = 1,
					},
					style = {
						order = 2,
						type = 'select',
						name = L["Font Outline"],
						values = {
							['NONE'] = L["None"],
							['OUTLINE'] = L["OUTLINE"],
							['MONOCHROME'] = L["MONOCHROME"],
							['MONOCHROMEOUTLINE'] = L["MONOCROMEOUTLINE"],
							['THICKOUTLINE'] = L["THICKOUTLINE"],
						},
					},
				},
			},
			style = {
				order = 2,
				name = MER:cOption(L["Style"], 'orange'),
				type = "group",
				guiInline = true,
				get = function(info) return E.db.mui.CombatAlert.style[info[#info]] end,
				set = function(info, value) E.db.mui.CombatAlert.style[info[#info]] = value; module:RefreshAlert() end,
				args = {
					font_color_enter = {
						order = 1,
						type = "color",
						name = L["Enter Combat"].." - "..L["Color"],
						hasAlpha = false,
						get = function(info)
							local t = E.db.mui.CombatAlert.style.font_color_enter
							return t.r, t.g, t.b
						end,
						set = function(info, r, g, b, a)
							E.db.mui.CombatAlert.style.font_color_enter = {}
							local t = E.db.mui.CombatAlert.style.font_color_enter
							t.r, t.g, t.b, t.a = r, g, b
						end,
					},
					font_color_leave = {
						order = 2,
						type = "color",
						name = L["Leave Combat"].." - "..L["Color"],
						hasAlpha = false,
						get = function(info)
							local t = E.db.mui.CombatAlert.style.font_color_leave
							return t.r, t.g, t.b
						end,
						set = function(info, r, g, b, a)
							E.db.mui.CombatAlert.style.font_color_leave = {}
							local t = E.db.mui.CombatAlert.style.font_color_leave
							t.r, t.g, t.b, t.a = r, g, b
						end,
					},
					backdrop = {
						order = 3,
						type = "toggle",
						name = L["Backdrop"],
					},
					stay_duration = {
						order = 4,
						type = "range",
						name = L["Stay Duration"],
						min = 0.1, max = 5.0, step = 0.01,
					},
					animation_duration = {
						order = 5,
						type = "range",
						name = L["Animation Duration (Fade In)"],
						min = 0.1, max = 5.0, step = 0.01,
					},
					scale = {
						order = 6,
						type = "range",
						name = L["Scale"],
						desc = L["Default is 0.8"],
						min = 0.1, max = 2.0, step = 0.01,
					},
				},
			},
			custom_text = {
				order = 3,
				name = MER:cOption(L["Custom Text"], 'orange'),
				type = "group",
				guiInline = true,
				get = function(info) return E.db.mui.CombatAlert.custom_text[info[#info]] end,
				set = function(info, value) E.db.mui.CombatAlert.custom_text[info[#info]] = value; module:RefreshAlert() end,
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					custom_enter_text = {
						order = 2,
						type = "input",
						name = L["Custom Text (Enter)"],
						width = 'full',
						disabled = function(info) return not E.db.mui.CombatAlert.custom_text.enabled end,
					},
					custom_leave_text = {
						order = 3,
						type = "input",
						name = L["Custom Text (Leave)"],
						width = 'full',
						disabled = function(info) return not E.db.mui.CombatAlert.custom_text.enabled end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, CVars)
