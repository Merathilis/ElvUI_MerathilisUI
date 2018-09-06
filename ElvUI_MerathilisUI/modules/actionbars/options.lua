local MER, E, L, V, P, G = unpack(select(2, ...))
local MAB = MER:GetModule("mUIActionbars")

--Cache global variables
local format = string.format
local tinsert = table.insert
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: AceGUIWidgetLSMlists, COLOR_PICKER

local function abTable()
	E.Options.args.mui.args.modules.args.actionbars = {
		order = 10,
		type = "group",
		name = MAB.modName,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["ActionBars"]),
			},
			general = {
				order = 2,
				type = "group",
				name = MER:cOption(L["General"]),
				guiInline = true,
				args = {
					cleanButton = {
						order = 1,
						type = "toggle",
						name = L["Clean Boss Button"],
						disabled = function() return not E.private.actionbar.enable end,
						get = function(info) return E.db.mui.actionbars[ info[#info] ] end,
						set = function(info, value) E.db.mui.actionbars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					transparent = {
						order = 2,
						type = "toggle",
						name = L["Transparent Backdrops"],
						desc = L["Applies transparency in all actionbar backdrops and actionbar buttons."],
						disabled = function() return not E.private.actionbar.enable end,
						get = function(info) return E.db.mui.actionbars[ info[#info] ] end,
						set = function(info, value) E.db.mui.actionbars[ info[#info] ] = value; MAB:TransparentBackdrops() end,
					},
					specBar = {
						order = 3,
						type = "toggle",
						name = L["Specialisation Bar"],
						disabled = function() return not E.private.actionbar.enable end,
						get = function(info) return E.db.mui.actionbars[ info[#info] ] end,
						set = function(info, value) E.db.mui.actionbars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					equipBar = {
						order = 4,
						type = "toggle",
						name = L["EquipSet Bar"],
						disabled = function() return not E.private.actionbar.enable end,
						get = function(info) return E.db.mui.actionbars[ info[#info] ] end,
						set = function(info, value) E.db.mui.actionbars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
				},
			},
			microBar = {
				order = 3,
				type = "group",
				name = MER:cOption(L["Micro Bar"]),
				guiInline = true,
				get = function(info) return E.db.mui.actionbars.microBar[ info[#info] ] end,
				set = function(info, value) E.db.mui.actionbars.microBar[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL");end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						disabled = function() return not E.private.actionbar.enable end,
						width = "full",
					},
					scale = {
						order = 2,
						type = "range",
						name = L["Scale"],
						isPercent = true,
						min = 0.5, max = 1.0, step = 0.01,
						disabled = function() return not E.db.mui.actionbars.microBar.enable end,
					},
					hideInCombat = {
						order = 3,
						type = "toggle",
						name = L["Hide In Combat"],
						disabled = function() return not E.db.mui.actionbars.microBar.enable end,
					},
					hideInOrderHall = {
						order = 4,
						type = "toggle",
						name = L["Hide In Orderhall"],
						disabled = function() return not E.db.mui.actionbars.microBar.enable end,
					},
					text = {
						order = 5,
						type = "group",
						name = MER:cOption(L["Text"]),
						guiInline = true,
						disabled = function() return not E.db.mui.actionbars.microBar.enable end,
						args = {
							friends = {
								order = 1,
								type = "toggle",
								name = FRIENDS,
								desc = L["Show/Hide the friend text on MicroBar."],
								get = function(info) return E.db.mui.actionbars.microBar.text.friends end,
								set = function(info, value) E.db.mui.actionbars.microBar.text.friends = value; E:StaticPopup_Show("PRIVATE_RL"); end,
							},
							guild = {
								order = 2,
								type = "toggle",
								name = GUILD,
								desc = L["Show/Hide the guild text on MicroBar."],
								get = function(info) return E.db.mui.actionbars.microBar.text.guild end,
								set = function(info, value) E.db.mui.actionbars.microBar.text.guild = value; E:StaticPopup_Show("PRIVATE_RL"); end,
							},
							position = {
								order = 3,
								type = "select",
								name = L["Position"],
								values = {
									["TOP"] = L["Top"],
									["BOTTOM"] = L["Bottom"],
								},
								get = function(info) return E.db.mui.actionbars.microBar.text.position end,
								set = function(info, value) E.db.mui.actionbars.microBar.text.position = value; E:StaticPopup_Show("PRIVATE_RL"); end,
							},
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, abTable)
