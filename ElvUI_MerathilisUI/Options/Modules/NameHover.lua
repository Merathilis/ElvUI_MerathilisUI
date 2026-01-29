local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local NH = MER:GetModule("MER_NameHover")
local options = MER.options.modules.args

options.nameHover = {
	type = "group",
	name = L["Name Hover"],
	get = function(info)
		return E.db.mui.nameHover[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.nameHover[info[#info]] = value
		E:StaticPopup_Show("GLOBAL_RL")
	end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["ActionBars"], "orange"),
		},
		credits = {
			order = 2,
			type = "group",
			name = F.cOption(L["Credits"], "orange"),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "description",
					name = "ncHoverName by Nightcracker",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			width = "full",
		},
		textGroup = {
			order = 3,
			type = "group",
			name = L["Text Options"],
			guiInline = true,
			args = {
				mainTextOutline = {
					order = 3,
					type = "select",
					name = L["Main Text Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
				},
				mainTextSize = {
					order = 4,
					name = L["Main Text Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
				headerTextOutline = {
					order = 5,
					type = "select",
					name = L["Header Text Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
				},
				headerTextSize = {
					order = 6,
					name = L["Header Text Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
				subTextOutline = {
					order = 7,
					type = "select",
					name = L["Sub Text Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
				},
				subTextSize = {
					order = 8,
					name = L["Sub Text Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
			},
		},
		targettarget = {
			order = 5,
			type = "toggle",
			name = L["Show Target of Target"],
			width = "full",
			get = function()
				return E.db.mui.nameHover.targettarget
			end,
			set = function(_, value)
				E.db.mui.nameHover.targettarget = value
			end,
		},
	},
}
