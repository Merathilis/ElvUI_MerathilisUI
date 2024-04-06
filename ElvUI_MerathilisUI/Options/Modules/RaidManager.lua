local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args

options.raidmanager = {
	type = "group",
	name = L["Raid Manager"],
	get = function(info)
		return E.db.mui.raidmanager[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.raidmanager[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		name = {
			order = 1,
			type = "header",
			name = F.cOption(L["Raid Manager"], "orange"),
		},
		credits = {
			order = 2,
			type = "group",
			name = F.cOption(L["Description"], "orange"),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "description",
					name = L["This will disable the ElvUI Raid Control and replace it with my own."],
				},
			},
		},
		enable = {
			order = 3,
			type = "toggle",
			name = L["Enable"],
		},
		count = {
			order = 4,
			type = "input",
			name = L["Pull Timer Count"],
			desc = L["Change the Pulltimer for DBM or BigWigs"],
			usage = L["Only accept values format with '', e.g.: '5', '8', '10' etc."],
			width = "half",
			get = function(info)
				return E.db.mui.raidmanager.count
			end,
			set = function(info, value)
				E.db.mui.raidmanager.count = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			disabled = function()
				return not E.db.mui.raidmanager.enable
			end,
		},
	},
}
