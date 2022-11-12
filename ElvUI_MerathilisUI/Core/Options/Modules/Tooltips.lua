local MER, F, E, L, V, P, G = unpack(select(2, ...))
local options = MER.options.modules.args

local _G = _G

options.tooltip = {
	type = "group",
	name = L["Tooltip"],
	get = function(info) return E.db.mui.tooltip[info[#info]] end,
	set = function(info, value) E.db.mui.tooltip[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Tooltip"], 'orange'),
		},
		tooltipIcon = {
			order = 2,
			type = "toggle",
			name = L["Tooltip Icons"],
			desc = L["Adds an icon for spells and items on your tooltip."],
		},
		factionIcon = {
			order = 3,
			type = "toggle",
			name = L.FACTION,
			desc = L["Adds an Icon for the faction on the tooltip."],
		},
		petIcon = {
			order = 4,
			type = "toggle",
			name = L["Pet Battle"],
			desc = L["Adds an Icon for battle pets on the tooltip."],
			hidden = not E.Retail,
		},
		keystone = {
			order = 5,
			type = "toggle",
			name = L["Keystone"],
			desc = L["Adds descriptions for mythic keystone properties to their tooltips."],
			hidden = not E.Retail,
		},
		dominationRank = {
			order = 6,
			type = "toggle",
			name = L["Domination Rank"],
			desc = L["Show the rank of shards."],
			hidden = not E.Retail,
		},
		covenant = {
			order = 7,
			type = "group",
			guiInline = true,
			name = "",
			get = function(info) return E.db.mui.tooltip.covenant[info[#info]] end,
			set = function(info, value) E.db.mui.tooltip.covenant[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			hidden = not E.Retail,
			args = {
				header0 = {
					order = 0,
					type = "header",
					name = F.cOption(L["Covenant"], 'orange'),
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Shows the Players Covenant on the Tooltip."]
				},
				showNotInGroup = {
					order = 2,
					type = "toggle",
					name = L["Show not in group"],
					desc = L["Keep the Covenant Line when not in a group. Showing: <Not in Group>"],
				},
			},
		},
		nameHover = {
			order = 11,
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
