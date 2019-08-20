local MER, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS:

local function databarsTable()
	E.Options.args.mui.args.modules.args.databars = {
		order = 15,
		type = "group",
		name = L["DataBars"],
		get = function(info) return E.db.mui.databars[ info[#info] ] end,
		set = function(info, value) E.db.mui.databars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["DataBars"]),
			},
			progressbar = {
				order = 2,
				type = "toggle",
				name = E.NewSign..L["Progress Bar"],
				desc = L["Shows Azerite/Honor/XP/Rep."],
			},
		},
	}
end
tinsert(MER.Config, databarsTable)
