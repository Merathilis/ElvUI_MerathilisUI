local MER, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')
local RB = MER:GetModule("RaidBuffs")

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variables
local AGGRO_WARNING_IN_PARTY = AGGRO_WARNING_IN_PARTY
local CUSTOM, DEFAULT = CUSTOM, DEFAULT
-- GLOBALS:

local function RaidBuffs()
	E.Options.args.mui.args.modules.args.raidBuffs = {
		type = "group",
		name = L["Raid Buff Reminder"],
		order = 18,
		get = function(info) return E.db.mui.raidBuffs[ info[#info] ] end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["Raid Buff Reminder"]),
			},
			rbreminder = {
				order = 2,
				type = "group",
				name = MER:cOption(L["Raid Buff Reminder"]),
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Shows a frame with flask/food/rune."],
						set = function(info, value) E.db.mui.raidBuffs.enable = value; RB:Visibility() end,
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
						set = function(info, value) E.db.mui.raidBuffs.visibility = value; RB:Visibility() end,
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
						set = function(info, value) E.db.mui.raidBuffs.customVisibility = value; RB:Visibility() end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, RaidBuffs)
