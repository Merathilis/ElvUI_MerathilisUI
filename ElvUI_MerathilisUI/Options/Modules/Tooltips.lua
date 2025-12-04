local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args

local _G = _G

options.tooltip = {
	type = "group",
	name = L["Tooltip"],
	get = function(info)
		return E.db.mui.tooltip[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.tooltip[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Tooltip"], "orange"),
		},
		nameHover = {
			order = 1,
			type = "group",
			name = L["Name Hover"],
			desc = L["Shows the Unit Name on the mouse."],
			get = function(info)
				return E.db.mui.nameHover[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.nameHover[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = F.cOption(L["Name Hover"], "orange"),
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
					min = 4,
					max = 24,
					step = 1,
				},
				fontOutline = {
					order = 3,
					type = "select",
					name = L["Font Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
				},
				targettarget = {
					order = 4,
					type = "toggle",
					name = L["Display TargetTarget"],
				},
				gradient = {
					order = 5,
					type = "toggle",
					name = L["Gradient Color"],
					desc = L["Colors the player names in a gradient instead of class color"],
				},
			},
		},
	},
}
