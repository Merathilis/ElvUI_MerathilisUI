local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args
local MERBI = MER:GetModule("MER_BagInfo")

options.bags = {
	type = "group",
	name = L["Bags"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Bags"], "orange"),
		},
	},
}
