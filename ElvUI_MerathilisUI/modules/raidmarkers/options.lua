local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");
local RMA = E:GetModule("RaidMarkers");

local SHIFT_KEY, CTRL_KEY, ALT_KEY = SHIFT_KEY, CTRL_KEY, ALT_KEY
local AGGRO_WARNING_IN_PARTY = AGGRO_WARNING_IN_PARTY
local CUSTOM = CUSTOM

local function RaidMarkers()
	E.Options.args.mui.args.raidmarkers = {
		type = "group",
		name = RMA.modName or RMA:GetName(),
		order = 17,
		get = function(info) return E.db.mui.raidmarkers[ info[#info] ] end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(RMA.modName or RMA:GetName()),
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
						name = format("|cff9482c9Shadow&Light|r"),
					},
				},
			},
			marksheader = {
				order = 3,
				type = "group",
				name = MER:cOption(RMA.modName or RMA:GetName()),
				guiInline = true,
				args = {
					info = {
						order = 4,
						type = "description",
						name = L["Options for panels providing fast access to raid markers and flares."],
						},
					enable = {
						order = 5,
						type = "toggle",
						name = L["Enable"],
						desc = L["Show/Hide raid marks."],
						set = function(info, value) E.db.mui.raidmarkers.enable = value; RMA:Visibility() end,
					},
					reset = {
						order = 6,
						type = 'execute',
						name = L["Restore Defaults"],
						desc = L["Reset these options to defaults"],
						disabled = function() return not E.db.mui.raidmarkers.enable end,
						func = function() MER:Reset("marks") end,
					},
					space1 = {
						order = 7,
						type = 'description',
						name = "",
					},
					backdrop = {
						type = 'toggle',
						order = 8,
						name = L["Backdrop"],
						disabled = function() return not E.db.mui.raidmarkers.enable end,
						set = function(info, value) E.db.mui.raidmarkers.backdrop = value; RMA:Backdrop() end,
					},
					buttonSize = {
						order = 9,
						type = 'range',
						name = L["Button Size"],
						min = 16, max = 40, step = 1,
						disabled = function() return not E.db.mui.raidmarkers.enable end,
						set = function(info, value) E.db.mui.raidmarkers.buttonSize = value; RMA:UpdateBar() end,
					},
					spacing = {
						order = 10,
						type = 'range',
						name = L["Button Spacing"],
						min = -4, max = 10, step = 1,
						disabled = function() return not E.db.mui.raidmarkers.enable end,
						set = function(info, value) E.db.mui.raidmarkers.spacing = value; RMA:UpdateBar() end,
					},
					orientation = {
						order = 11,
						type = 'select',
						name = L["Orientation"],
						disabled = function() return not E.db.mui.raidmarkers.enable end,
						set = function(info, value) E.db.mui.raidmarkers.orientation = value; RMA:UpdateBar() end,
						values = {
							["HORIZONTAL"] = L["Horizontal"],
							["VERTICAL"] = L["Vertical"],
						},
					},
					reverse = {
						type = 'toggle',
						order = 12,
						name = L["Reverse"],
						disabled = function() return not E.db.mui.raidmarkers.enable end,
						set = function(info, value) E.db.mui.raidmarkers.reverse = value; RMA:UpdateBar() end,
					},
					modifier = {
						order = 13,
						type = 'select',
						name = L["Modifier Key"],
						desc = L["Set the modifier key for placing world markers."],
						disabled = function() return not E.db.mui.raidmarkers.enable end,
						set = function(info, value) E.db.mui.raidmarkers.modifier = value; RMA:UpdateWorldMarkersAndTooltips() end,
						values = {
							["shift-"] = SHIFT_KEY,
							["ctrl-"] = CTRL_KEY,
							["alt-"] = ALT_KEY,
						},
					},
					visibility = {
						type = 'select',
						order = 14,
						name = L["Visibility"],
						disabled = function() return not E.db.mui.raidmarkers.enable end,
						set = function(info, value) E.db.mui.raidmarkers.visibility = value; RMA:Visibility() end,
						values = {
							["DEFAULT"] = DEFAULT,
							["INPARTY"] = AGGRO_WARNING_IN_PARTY,
							["ALWAYS"] = L["Always Display"],
							["CUSTOM"] = CUSTOM,
						},
					},
					customVisibility = {
						order = 15,
						type = 'input',
						width = 'full',
						name = L["Visibility State"],
						disabled = function() return E.db.mui.raidmarkers.visibility ~= "CUSTOM" or not E.db.mui.raidmarkers.enable end,
						set = function(info, value) E.db.mui.raidmarkers.customVisibility = value; RMA:Visibility() end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, RaidMarkers)