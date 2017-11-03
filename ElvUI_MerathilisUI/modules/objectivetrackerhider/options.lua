local MER, E, L, V, P, G = unpack(select(2, ...))
local OTH = E:GetModule("ObjectiveTrackerHider")

--Cache global variables

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: AceGUIWidgetLSMlists, FONT_SIZE, FACTION_ALLIANCE, FACTION_HORDE, FACTION_STANDING_LABEL4
-- GLOBALS: FRIENDS_LIST_ONLINE, FRIENDS_LIST_OFFLINE, DEFAULT_DND_MESSAGE, DEFAULT_AFK_MESSAGE
-- GLOBALS: FriendsFrame_UpdateFriends

local function ObjectiveTrackerHider()
	E.Options.args.mui.args.objectivetrackerhider = {
		type = "group",
		name = OTH.modName..MER.NewSign,
		order = 23,
		args = {
			header = {
				order = 1,
				type = "header",
				name = MER:cOption(OTH.modName)..MER.NewSign,
			},
			credits = {
				order = 2,
				type = "group",
				name = MER:cOption(L["Credits"]),
				guiInline = true,
				args = {
					tukui = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = format("|cff9482c9ObjectiveTrackerHider - by Infinitron|r"),
					},
				},
			},
			general = {
				order = 3,
				type = "group",
				name = MER:cOption(L["General"]),
				guiInline = true,
				args = {
					enabled = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						desc = L["Enable the objective tracker hider."],
						get = function(info) return E.db.mui.objectivetrackerhider[info [#info] ] end,
						set = function(info,value) E.db.mui.objectivetrackerhider[info [#info] ] = value; OTH:Enable(); end,
					},
				},
			},
			objectivetrackerhiderOptions = {
				order = 4,
				type = "group",
				name = MER:cOption(L["Options"]),
				guiInline = true,
				get = function(info) return E.db.mui.objectivetrackerhider[info [#info] ] end,
				set = function(info, value) E.db.mui.objectivetrackerhider[info [#info] ] = value; end,
				args = {
					hidePvP = {
						type = "toggle",
						order = 5,
						name = L["Hide during PvP"],
						desc = L["Hide the objective tracker during PvP (i.e. Battlegrounds)"],
					},
					hideArena = {
						type = "toggle",
						order = 6,
						name = L["Hide in arena"],
						desc = L["Hide the objective tracker when in the arena"],
					},
					hideParty = {
						type = "toggle",
						order = 7,
						name = L["Hide in dungeon"],
						desc = L["Hide the objective tracker when in a dungeon"],
					},
					hideRaid = {
						type = "toggle",
						order = 8,
						name = L["Hide in raid"],
						desc = L["Hide the objective tracker when in a raid"],
					},
					collapsePvP = {
						type = "toggle",
						order = 1,
						name = L["Collapse during PvP"],
						desc = L["Collapse the objective tracker during PvP (i.e. Battlegrounds)"],
					},
					collapseArena = {
						type = "toggle",
						order = 2,
						name = L["Collapse in arena"],
						desc = L["Collapse the objective tracker when in the arena"],
					},
					collapseParty = {
						type = "toggle",
						order = 3,
						name = L["Collapse in dungeon"],
						desc = L["Collapse the objective tracker when in a dungeon"],
					},
					collapseRaid = {
						type = "toggle",
						order = 4,
						name = L["Collapse in raid"],
						desc = L["Collapse the objective tracker during a raid"],
					},
				}
			},
		},
	}
end
tinsert(MER.Config, ObjectiveTrackerHider)