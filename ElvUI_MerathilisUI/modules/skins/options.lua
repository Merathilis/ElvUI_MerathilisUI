local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

local function Skins()
	E.Options.args.mui.args.skins = {
		order = 16,
		type = 'group',
		name = L['Skins'],
		args = {
			name = {
				order = 1,
				type = 'header',
				name = MER:cOption(L['Skins']),
			},
			BLIZZARD = {
				order = 2,
				type = 'group',
				name = L["Blizzard"],
				guiInline = true,
				args = {
					ENCOUNTERJOURNAL = {
						order = 1,
						type = 'toggle',
						name = L["Encounter Journal"],
						get = function(info) return E.private.mui.skins.blizzard.encounterjournal end,
						set = function(info, value) E.private.mui.skins.blizzard.encounterjournal = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					SPELLBOOK = {
						order = 2,
						type = 'toggle',
						name = L["Spellbook"],
						get = function(info) return E.private.mui.skins.blizzard.spellbook end,
						set = function(info, value) E.private.mui.skins.blizzard.spellbook = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					OBJECTIVETRACKER = {
						order = 3,
						type = 'toggle',
						name = OBJECTIVES_TRACKER_LABEL,
						get = function(info) return E.private.mui.skins.blizzard.objectivetracker end,
						set = function(info, value) E.private.mui.skins.blizzard.objectivetracker = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					}, 
				},
			},
			ADDONS = {
				order = 3,
				type = 'group',
				name = L["AddOns"],
				guiInline = true,
				args = {
					MasterPlan = {
						order = 1,
						type = 'toggle',
						name = L['MasterPlan'],
						desc = L['Skins the additional Tabs from MasterPlan.'],
						get = function(info) return E.private.mui.skins.addons.MasterPlan end,
						set = function(info, value) E.private.mui.skins.addons.MasterPlan = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, Skins)
