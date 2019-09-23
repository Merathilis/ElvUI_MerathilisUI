local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("LocPanel")

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variables
-- GLOBALS:

local function RaidManagerOptions()
	E.Options.args.mui.args.modules.args.raidmanager = {
		type = "group",
		name = E.NewSign..L["Raid Manager"],
		order = 20,
		get = function(info) return E.db.mui.raidmanager[ info[#info] ] end,
		set = function(info, value) E.db.mui.raidmanager[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(E.NewSign..L["Raid Manager"]),
			},
			credits = {
				order = 2,
				type = "group",
				name = MER:cOption(L["Description"]),
				guiInline = true,
				args = {
					tukui = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = (L["This will disable the ElvUI Raid Control and replace it with my own."]),
					},
				},
			},
			enable = {
				order = 3,
				type = "toggle",
				name = L["Enable"],
			},
		},
	}
end
tinsert(MER.Config, RaidManagerOptions)
