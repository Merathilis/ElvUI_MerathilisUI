local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua functions

--WoW API / Variables

--Global variables that we don"t cache, list them here for mikk"s FindGlobals script
-- GLOBALS:

local function Tooltip()
	E.Options.args.mui.args.tooltip = {
		type = "group",
		name = L["Tooltip"],
		order = 18,
		get = function(info) return E.db.mui.tooltip[ info[#info] ] end,
		set = function(info, value) E.db.mui.tooltip[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["Tooltip"]),
			},
			petIcon = {
				order = 2,
				type = "toggle",
				name = TOOLTIP_BATTLE_PET,
				desc = L["Adds an Icon for battle pets on the tooltip."],
			},
			factionIcon = {
				order = 3,
				type = "toggle",
				name = FACTION,
				desc = L["Adds an Icon for the faction on the tooltip."],
			},
			achievement = {
				order = 4,
				type = "toggle",
				name = ACHIEVEMENT_BUTTON,
				desc = L["Adds information to the tooltip, on which char you earned an achievement."],
			},
			modelIcon = {
				order = 5,
				type = "toggle",
				name = L["Model"],
				desc = L["Adds an Model icon on the tooltip."],
			},
			keystone = {
				order = 6,
				type = "toggle",
				name = L["Keystone"],
				desc = L["Adds descriptions for mythic keystone properties to their tooltips."],
			},
		},
	}
end
tinsert(MER.Config, Tooltip)