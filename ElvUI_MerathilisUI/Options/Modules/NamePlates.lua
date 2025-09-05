local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local NP = E:GetModule("NamePlates")
local NPA = MER:GetModule("MER_NameplateAuras")
local options = MER.options.modules.args

options.nameplates = {
	type = "group",
	name = L["NamePlates"],
	get = function(info)
		return E.db.mui.nameplates[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.nameplates[info[#info]] = value
		E:StaticPopup_Show("GLOBAL_RL")
	end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["NamePlates"], "orange"),
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			args = {
				castbarShield = {
					order = 1,
					type = "toggle",
					name = L["Castbar Shield"],
					desc = L["Show a shield icon on the castbar for non interruptible spells."],
				},
			},
		},
	},
}
