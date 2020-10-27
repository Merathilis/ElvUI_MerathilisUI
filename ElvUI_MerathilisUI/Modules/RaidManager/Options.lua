local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_RaidManager')

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variables
-- GLOBALS:

local function RaidManagerOptions()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.raidmanager = {
		type = "group",
		name = L["Raid Manager"],
		get = function(info) return E.db.mui.raidmanager[ info[#info] ] end,
		set = function(info, value) E.db.mui.raidmanager[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = ACH:Header(MER:cOption(L["Raid Manager"]), 1),
			credits = {
				order = 2,
				type = "group",
				name = MER:cOption(L["Description"], 'orange'),
				guiInline = true,
				args = {
					tukui = ACH:Description(L["This will disable the ElvUI Raid Control and replace it with my own."], 1),
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
				get = function(info) return E.db.mui.raidmanager.count end,
				set = function(info, value) E.db.mui.raidmanager.count = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				disabled = function() return not E.db.mui.raidmanager.enable end,
			},
		},
	}
end
tinsert(MER.Config, RaidManagerOptions)
