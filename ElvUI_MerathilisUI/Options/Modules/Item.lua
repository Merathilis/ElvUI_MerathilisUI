local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local DI = MER:GetModule("MER_DeleteItem")
local options = MER.options.modules.args
local LSM = E.LSM

options.delete = {
	type = "group",
	name = E.NewSign .. L["Delete Item"],
	get = function(info)
		return E.db.mui.item.delete[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.item.delete[info[#info]] = value
		DI:ProfileUpdate()
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Delete Item"], "orange"),
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
					name = L["This module provides several easy-to-use methods of deleting items."],
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
		delKey = {
			order = 3,
			type = "toggle",
			name = L["Use Delete Key"],
			desc = L["Allow you to use Delete Key for confirming deleting."],
		},
		fillIn = {
			order = 4,
			name = L["Fill In"],
			type = "select",
			values = {
				NONE = L["Disable"],
				CLICK = L["Fill by click"],
				AUTO = L["Auto Fill"],
			},
		},
	},
}
