local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

local function muiSkins()
	E.Options.args.mui.args.config.args.skins = {
		order = 16,
		type = 'group',
		name = L['Skins'],
		args = {
			BLIZZARD = {
				order = 1,
				type = 'group',
				name = L["Blizzard"],
				guiInline = true,
				args = {
					ENCOUNTERJOURNAL = {
						order = 1,
						type = 'toggle',
						name = L["Encounter Journal"],
						get = function(info) return E.db.muiSkins.blizzard.encounterjournal end,
						set = function(info, value) E.db.muiSkins.blizzard.encounterjournal = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					SPELLBOOK = {
						order = 2,
						type = 'toggle',
						name = L["Spellbook"],
						get = function(info) return E.db.muiSkins.blizzard.spellbook end,
						set = function(info, value) E.db.muiSkins.blizzard.spellbook = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					OBJECTIVETRACKER = {
						order = 3,
						type = 'toggle',
						name = OBJECTIVES_TRACKER_LABEL,
						get = function(info) return E.db.muiSkins.blizzard.objectivetracker end,
						set = function(info, value) E.db.muiSkins.blizzard.objectivetracker = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
				},
			},
			ADDONS = {
				order = 2,
				type = 'group',
				name = L["AddOns"],
				guiInline = true,
				args = {
					MasterPlan = {
						order = 1,
						type = 'toggle',
						name = L['MasterPlan'],
						desc = L['Skins the additional Tabs from MasterPlan.'],
						get = function(info) return E.db.muiSkins.addons.MasterPlan end,
						set = function(info, value) E.db.muiSkins.addons.MasterPlan = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
				},
			},
		},
	}
end
tinsert(E.MerConfig, muiSkins)
