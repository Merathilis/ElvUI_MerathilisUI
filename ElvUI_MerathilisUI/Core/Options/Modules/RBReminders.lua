local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_RaidBuffs')
local options = MER.options.modules.args

local AGGRO_WARNING_IN_PARTY = AGGRO_WARNING_IN_PARTY
local CUSTOM, DEFAULT = CUSTOM, DEFAULT

options.raidBuffs = {
	type = "group",
	name = L["Raid Buff Reminder"],
	get = function(info) return E.db.mui.raidBuffs[ info[#info] ] end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Raid Buff Reminder"], 'orange'),
		},
		rbreminder = {
			order = 2,
			type = "group",
			name = F.cOption(L["Raid Buff Reminder"], 'orange'),
			guiInline = true,
			args = {
				enable = {
					order = 1,
					type = 'toggle',
					name = L["Enable"],
					desc = L["Shows a frame with flask/food/rune."],
					set = function(info, value) E.db.mui.raidBuffs.enable = value; module:Visibility() end,
				},
				space1 = {
					order = 2,
					type = 'description',
					name = "",
					hidden = function() return not E.db.mui.raidBuffs.enable end,
				},
				visibility = {
					type = 'select',
					order = 3,
					name = L["Visibility"],
					disabled = function() return not E.db.mui.raidBuffs.enable end,
					set = function(info, value) E.db.mui.raidBuffs.visibility = value; module:Visibility() end,
					values = {
						["DEFAULT"] = DEFAULT,
						["INPARTY"] = AGGRO_WARNING_IN_PARTY,
						["ALWAYS"] = L["Always Display"],
						["CUSTOM"] = CUSTOM,
					},
				},
				size = {
					type = 'range',
					order = 4,
					name = L["Size"],
					disabled = function() return not E.db.mui.raidBuffs.enable end,
					min = 10, max = 40, step = 1,
					set = function(info, value) E.db.mui.raidBuffs.size = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				},
				alpha = {
					order = 5,
					type = 'range',
					name = L["Alpha"],
					desc = L["Change the alpha level of the icons."],
					min = 0, max = 1, step = 0.1,
					disabled = function() return not E.db.mui.raidBuffs.enable end,
					set = function(info, value) E.db.mui.raidBuffs.alpha = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				},
				class = {
					order = 6,
					type = 'toggle',
					name = L["Class Specific Buffs"],
					desc = L["Shows all the class specific raid buffs."],
					disabled = function() return not E.db.mui.raidBuffs.enable end,
					set = function(info, value) E.db.mui.raidBuffs.class = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				},
				glow = {
					order = 7,
					type = "toggle",
					name = L["Glow"],
					desc = L["Shows the pixel glow on missing raidbuffs."],
					disabled = function() return not E.db.mui.raidBuffs.enable end,
					set = function(info, value) E.db.mui.raidBuffs.glow = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				},
				customVisibility = {
					order = 8,
					type = 'input',
					width = 'full',
					name = L["Visibility State"],
					disabled = function() return E.db.mui.raidBuffs.visibility ~= "CUSTOM" or not E.db.mui.raidBuffs.enable end,
					set = function(info, value) E.db.mui.raidBuffs.customVisibility = value; module:Visibility() end,
				},
			},
		},
	},
}
