local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Mail = MER:GetModule("MER_Mail")

local options = module.options.modules.args

options.mail = {
	type = "group",
	name = module:AddCategorieIcon(L["Mail"], "mail"),
	get = function(info)
		return E.db.mui.mail[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.mail[info[#info]] = value
		E:StaticPopup_Show("CONFIG_RL")
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Mail"], "orange"),
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
					name = L["Add small extras to the Mail Frame."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			width = "full",
		},
	},
}
