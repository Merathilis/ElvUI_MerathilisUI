local MER, F, E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")
local options = MER.options.modules.args

options.nameplates = {
	type = "group",
	name = L["NamePlates"],
	get = function(info) return E.db.mui.nameplates[ info[#info] ] end,
	set = function(info, value) E.db.mui.nameplates[ info[#info] ] = value; E:StaticPopup_Show("GLOBAL_RL"); end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["NamePlates"], 'orange'),
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			args = {
				castbarShield  = {
					order = 1,
					type = "toggle",
					name = L["Castbar Shield"],
					desc = L["Show a shield icon on the castbar for non interruptible spells."],
				},
			},
		},
		enhancedAuras = {
			order = 10,
			type = "group",
			name = L["Enhanced NameplateAuras"],
			get = function(info) return E.db.mui.nameplates.enhancedAuras[ info[#info] ] end,
			set = function(info, value) E.db.mui.nameplates.enhancedAuras[ info[#info] ] = value; E:StaticPopup_Show("GLOBAL_RL"); end,
			args = {
				description = {
					order = 1,
					type = "description",
					name = L["|cffFF0000NOTE:|r This will overwrite the ElvUI Nameplate options for Buff/Debuffs width/height. The CC-Buffs are hardcoded to a size of: 32 x 32"],
				},
				spacer1 = {
					order = 1,
					type = "description",
					name = '',
				},
				enable = {
					order = 4,
					type = "toggle",
					name = L["Enable"],
				},
				width = {
					order = 5,
					type = "range",
					name = L["Width"],
					min = 6, max = 60, step = 1,
					get = function(info) return E.db.mui.nameplates.enhancedAuras.width end,
					set = function(info, value) E.db.mui.nameplates.enhancedAuras.width = value; NP:ConfigureAll() end,
				},
				height = {
					order = 6,
					type = "range",
					name = L["Height"],
					min = 6, max = 60, step = 1,
					get = function(info) return E.db.mui.nameplates.enhancedAuras.height end,
					set = function(info, value) E.db.mui.nameplates.enhancedAuras.height = value; NP:ConfigureAll() end,
				},
			},
		},
	},
}
