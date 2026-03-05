local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

local options = module.options.modules.args

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
