local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args
local module = MER:GetModule('MER_Bags')

options.bags = {
	type = "group",
	name = L["Bags"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Bags"], 'orange'),
		},
	},
}

