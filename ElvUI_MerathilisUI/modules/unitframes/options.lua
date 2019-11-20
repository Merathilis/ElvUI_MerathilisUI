local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local tinsert = table.insert
-- WoW API / Variables
-- GLOBALS:

local function UnitFramesTable()
	E.Options.args.mui.args.modules.args.unitframes = {
		type = "group",
		name = E.NewSign..L["UnitFrames"],
		disabled = function() return not E.private.unitframe.enable end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["UnitFrames"]),
			},
			general = {
				order = 2,
				type = "group",
				name = MER:cOption(L["General"]),
				guiInline = true,
				args = {
					healPrediction = {
						order = 1,
						type = "toggle",
						name = L["Heal Prediction"],
						desc = L["Changes the Heal Prediction texture to the default Blizzard ones."],
						get = function(info) return E.db.mui.unitframes[ info[#info] ] end,
						set = function(info, value) E.db.mui.unitframes[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,
					},
					auras = {
						order = 2,
						type = "toggle",
						name = E.NewSign..L["Auras"],
						desc = L["Adds a shadow to the debuffs that the debuff color is more visible."],
						get = function(info) return E.db.mui.unitframes[ info[#info] ] end,
						set = function(info, value) E.db.mui.unitframes[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL"); end,
					},
					swing = {
						order = 3,
						type = "toggle",
						name = E.NewSign..L["Swing Bar"],
						desc = L["Creates a weapon Swing Bar"],
						get = function(info) return E.db.mui.unitframes.swing.enable end,
						set = function(info, value) E.db.mui.unitframes.swing.enable = value; E:StaticPopup_Show("CONFIG_RL"); end,
					},
					infoPanel = {
						order = 4,
						type = "toggle",
						name = L["InfoPanel Style"],
						get = function(info) return E.db.mui.unitframes.infoPanel.style end,
						set = function(info, value) E.db.mui.unitframes.infoPanel.style = value; E:StaticPopup_Show("CONFIG_RL"); end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, UnitFramesTable)
