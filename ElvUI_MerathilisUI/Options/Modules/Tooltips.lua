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
	},
}
