local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua functions

--WoW API / Variables

--Global variables that we don"t cache, list them here for mikk"s FindGlobals script
-- GLOBALS: TOOLTIP_BATTLE_PET, FACTION, ACHIEVEMENT_BUTTON

local function Tooltip()
	E.Options.args.mui.args.modules.args.tooltip = {
		type = "group",
		name = E.NewSign..L["Tooltip"],
		order = 20,
		get = function(info) return E.db.mui.tooltip[ info[#info] ] end,
		set = function(info, value) E.db.mui.tooltip[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["Tooltip"]),
			},
			tooltip = {
				order = 2,
				type = "toggle",
				name = L["Tooltip"],
				desc = L["Change the visual appearance of the Tooltip."],
			},
			petIcon = {
				order = 3,
				type = "toggle",
				name = TOOLTIP_BATTLE_PET,
				desc = L["Adds an Icon for battle pets on the tooltip."],
			},
			factionIcon = {
				order = 4,
				type = "toggle",
				name = FACTION,
				desc = L["Adds an Icon for the faction on the tooltip."],
			},
			achievement = {
				order = 5,
				type = "toggle",
				name = ACHIEVEMENT_BUTTON,
				desc = L["Adds information to the tooltip, on which char you earned an achievement."],
			},
			keystone = {
				order = 6,
				type = "toggle",
				name = L["Keystone"],
				desc = L["Adds descriptions for mythic keystone properties to their tooltips."],
			},
			titleColor = {
				order = 7,
				type = "toggle",
				name = E.NewSign..L["Title Color"],
				desc = L["Change the color of the title in the Tooltip."],
			},
			header = {
				order = 8,
				type = "header",
				name = MER:cOption(L["Realm Info"]),
			},
			nameHover = {
				order = 10,
				type = "group",
				guiInline = true,
				name = L["Name Hover"],
				desc = L["Shows the Unit Name on the mouse."],
				get = function(info) return E.db.mui.nameHover[ info[#info] ] end,
				set = function(info, value) E.db.mui.nameHover[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					fontSize = {
						order = 2,
						type = "range",
						name = L["Size"],
						min = 4, max = 24, step = 1,
					},
					fontOutline = {
						order = 3,
						type = "select",
						name = L["Font Outline"],
						values = {
							["NONE"] = NONE,
							["OUTLINE"] = "OUTLINE",
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE",
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, Tooltip)
