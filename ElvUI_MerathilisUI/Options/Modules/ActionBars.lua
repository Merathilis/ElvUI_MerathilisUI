local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local AB = MER:GetModule("MER_Actionbars")
local CM = MER:GetModule("MER_ColorModifiers") ---@type ColorModifiers
local options = module.options.modules.args

local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut

options.actionbars = {
	type = "group",
	name = module:AddCategorieIcon(L["ActionBars"], "actionbars"),
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["ActionBars"],
		},
		specBar = {
			order = 3,
			type = "group",
			name = L["Specialization Bar"],
			hidden = E.Forever,
			guiInline = true,
			disabled = module.RequirementsDisabled(I.Requirements.ActionBars),
			get = function(info)
				return E.db.mui.actionbars.specBar[info[#info]]
			end,
			set = function(info, value)
				local key = info[#info]
				E.db.mui.actionbars.specBar[key] = value

				-- Mouseover is read live, the rest builds the bar
				local bar = AB.specBar
				if key == "mouseover" and bar then
					if value then
						UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), 0)
					else
						UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), 1)
					end
				else
					E:StaticPopup_Show("CONFIG_RL")
				end
			end,
			args = {
				requirements = module.RequirementsNotice(I.Requirements.ActionBars),
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					width = "full",
				},
				mouseover = {
					order = 2,
					type = "toggle",
					name = L["Mouseover"],
					disabled = function()
						return not MER:HasRequirements(I.Requirements.ActionBars) or not E.db.mui.actionbars.specBar.enable
					end,
				},
				size = {
					order = 3,
					type = "range",
					name = L["Button Size"],
					min = 20,
					max = 60,
					step = 1,
					disabled = function()
						return not MER:HasRequirements(I.Requirements.ActionBars) or not E.db.mui.actionbars.specBar.enable
					end,
				},
				frameStrata = {
					order = 4,
					type = "select",
					name = L["Frame Strata"],
					disabled = function()
						return not MER:HasRequirements(I.Requirements.ActionBars) or not E.db.mui.actionbars.specBar.enable
					end,
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
					min = 1,
					max = 256,
					step = 1,
					disabled = function()
						return not MER:HasRequirements(I.Requirements.ActionBars) or not E.db.mui.actionbars.specBar.enable
					end,
				},
			},
		},
		colorModifiers = {
			order = 4,
			type = "group",
			name = L["Color Modifier Keys"],
			desc = L["Enabling this colors your modifier keys."],
			guiInline = true,
			get = function(info)
				return E.db.mui.colorModifiers[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.colorModifiers[info[#info]] = value
				CM:DatabaseUpdate()
			end,
			disabled = module.RequirementsDisabled(I.Requirements.ActionBars),
			args = {
				requirements = module.RequirementsNotice(I.Requirements.ActionBars),
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Credits: ElvUI_ToxiUI"],
					width = "full",
				},
			},
		},
	},
}
