local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args

options.reminder = {
	type = "group",
	name = L["Reminder"],
	get = function(info) return E.db.mui.reminder[ info[#info] ] end,
	set = function(info, value) E.db.mui.reminder[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
	args = {
		name = {
			order = 0,
			type = "header",
			name = F.cOption(L["Reminder"], 'orange'),
		},
		enable = {
			order = 1,
			type = 'toggle',
			name = L["Enable"],
			desc = L["Reminds you on self Buffs."],
		},
		size = {
			order = 2,
			type = "range",
			name = L["Size"],
			min = 10, max = 60, step = 1,
		},
	},
}
