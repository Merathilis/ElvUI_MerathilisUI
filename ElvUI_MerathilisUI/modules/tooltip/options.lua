local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");

--Cache global variables
--Lua functions

--WoW API / Variables

--Global variables that we don"t cache, list them here for mikk"s FindGlobals script
-- GLOBALS:

local function Tooltip()
	E.Options.args.mui.args.tooltip = {
		type = "group",
		name = L["Tooltip"]..MER.NewSign,
		order = 18,
		get = function(info) return E.db.mui.tooltip[ info[#info] ] end,
		set = function(info, value) E.db.mui.tooltip[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["Tooltip"]..MER.NewSign),
			},
			tooltipIcon = {
				order = 2,
				type = "toggle",
				name = L["Tooltip Icon"],
				desc = L["Adds an Icon for Items/Spells/Achievement on the Tooltip."],
			},
			petIcon = {
				order = 3,
				type = "toggle",
				name = L["Pet Icon"],
				desc = L["Adds an Icon for battle pets on the tooltip."],
			},
			factionIcon = {
				order = 4,
				type = "toggle",
				name = L["Faction Icon"],
				desc = L["Adds an Icon for the faction on the tooltip."],
			},
			roleIcon = {
				order = 5,
				type = "toggle",
				name = L["Role Icon"],
				desc = L["Adds an role icon on the tooltip."],
			},
		},
	}
end
tinsert(MER.Config, Tooltip)