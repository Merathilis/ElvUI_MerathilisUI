local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args

options.actionbars = {
	type = "group",
	name = L["ActionBars"],
	get = function(info) return E.db.mui.actionbars[ info[#info] ] end,
	set = function(info, value) E.db.mui.actionbars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["ActionBars"], 'orange'),
		},
		--[[
		general = {
			order = 2,
			type = "group",
			name = F.cOption(L["General"], 'orange'),
			guiInline = true,
			args = {
			},
		},]]
		specBar = {
			order = 3,
			type = "group",
			name = F.cOption(L["Specialization Bar"], 'orange'),
			guiInline = true,
			disabled = function() return not E.private.actionbar.enable end,
			hidden = not E.Retail,
			get = function(info) return E.db.mui.actionbars.specBar[ info[#info] ] end,
			set = function(info, value) E.db.mui.actionbars.specBar[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					disabled = function() return not E.private.actionbar.enable end,
					width = "full",
				},
				mouseover = {
					order = 2,
					type = "toggle",
					name = L["Mouseover"],
					disabled = function() return not E.private.actionbar.enable or not E.db.mui.actionbars.specBar.enable end,
				},
				size = {
					order = 3,
					type = "range",
					name = L["Button Size"],
					min = 20, max = 60, step = 1,
					disabled = function() return not E.private.actionbar.enable or not E.db.mui.actionbars.specBar.enable end,
				},
				frameStrata = {
					order = 4,
					type = "select",
					name = L["Frame Strata"],
					disabled = function() return not E.private.actionbar.enable or not E.db.mui.actionbars.specBar.enable end,
					values = {
						BACKGROUND = L["BACKGROUND"],
						LOW = L["LOW"],
						MEDIUM = L["MEDIUM"],
						HIGH = L["HIGH"],
					},
				},
				frameLevel = {
					order = 5,
					type = "range",
					name = L["Frame Level"],
					min = 1, max = 256, step = 1,
					disabled = function() return not E.private.actionbar.enable or not E.db.mui.actionbars.specBar.enable end,
				},
			},
		},
		keyfeedback = {
			order = 4,
			type = "group",
			name = F.cOption(L["KeyFeedback"], 'orange'),
			guiInline = true,
			disabled = function() return not E.private.actionbar.enable end,
			get = function(info) return E.db.mui.actionbars.keyfeedback[info[#info]] end,
			set = function(info, value) E.db.mui.actionbars.keyfeedback[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					disabled = function() return not E.private.actionbar.enable end,
					width = "full",
				},
				mirrorSize = {
					order = 2,
					type = "range",
					name = L["Button Size"],
					min = 20, max = 60, step = 1,
				},
				enableCastLine = {
					order = 3,
					type = "toggle",
					name = L["Mirror"],
				},
				lineIconSize = {
					order = 4,
					type = "range",
					name = L["Mirror Button Size"],
					min = 18, max = 62, step = 1,
					disabled = function() return not E.db.mui.actionbars.keyfeedback.enableCastLine end,
				},
				lineDirection = {
					order = 5,
					type = "select",
					name = L["Mirror Direction"],
					disabled = function() return not E.db.mui.actionbars.keyfeedback.enableCastLine end,
					values = {
						LEFT = L["LEFT"],
						RIGHT = L["RIGHT"],
					},
				},
			},
		},
	},
}
