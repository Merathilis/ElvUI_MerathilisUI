local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args

local _G = _G

options.tooltip = {
	type = "group",
	name = L["Tooltip"],
	get = function(info) return E.db.mui.tooltip[info[#info]] end,
	set = function(info, value) E.db.mui.tooltip[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Tooltip"], 'orange'),
		},
		modifier = {
			order = 1,
			type = "select",
			name = L["Modifier Key"],
			desc = format(L["The modifer key to show additional information from %s."], MER.Title),
			set = function(info, value)
				E.db.mui.tooltip[info[#info]] = value
			end,
			hidden = not E.Retail,
			values = {
				NONE = L["None"],
				SHIFT = L["Shift"],
				CTRL = L["Ctrl"],
				ALT = L["Alt"],
				ALT_SHIFT = format("%s + %s", L["Alt"], L["Shift"]),
				CTRL_SHIFT = format("%s + %s", L["Ctrl"], L["Shift"]),
				CTRL_ALT = format("%s + %s", L["Ctrl"], L["Alt"]),
				CTRL_ALT_SHIFT = format("%s + %s + %s", L["Ctrl"], L["Alt"], L["Shift"])
			},
		},
		spacer = {
			order = 2,
			type = "description",
			name = " ",
		},
		icon = {
			order = 3,
			type = "toggle",
			name = L["Tooltip Icons"],
			desc = L["Adds an icon for spells and items on your tooltip."],
		},
		factionIcon = {
			order = 4,
			type = "toggle",
			name = L.FACTION,
			desc = L["Adds an Icon for the faction on the tooltip."],
		},
		petIcon = {
			order = 5,
			type = "toggle",
			name = L["Pet Icon"],
			desc = L["Add an icon for indicating the type of the pet."],
			hidden = not E.Retail,
		},
		petId = {
			order = 6,
			type = "toggle",
			name = L["Pet ID"],
			desc = L["Show battle pet species ID in tooltips."],
			hidden = not E.Retail,
		},
		keystone = {
			order = 7,
			type = "toggle",
			name = L["Keystone"],
			desc = L["Adds descriptions for mythic keystone properties to their tooltips."],
			hidden = not E.Retail,
		},
		gradientName = {
			order = 8,
			type = "toggle",
			name = E.NewSign..L["Gradient Name"],
			hidden = not E.Retail,
		},
		nameHover = {
			order = 15,
			type = "group",
			guiInline = true,
			name = "",
			desc = L["Shows the Unit Name on the mouse."],
			get = function(info) return E.db.mui.nameHover[info[#info]] end,
			set = function(info, value) E.db.mui.nameHover[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			args = {
				header1 = {
					order = 0,
					type = "header",
					name = F.cOption(L["Name Hover"], 'orange'),
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				fontSize = {
					order = 2,
					type = "range",
					name = L["Size"],
					min = 4, max = 24, step = 1,
				},
				fontOutline = {
					order = 3,
					type = "select",
					name = L["Font Outline"],
					values = {
						["NONE"] = _G.NONE,
						["OUTLINE"] = "OUTLINE",
						["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
						["THICKOUTLINE"] = "THICKOUTLINE",
					},
				},
				targettarget = {
					order = 4,
					type = "toggle",
					name = L["Display TargetTarget"],
				},
			},
		},
	},
}
