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
						get = function(info) return E.db.muiSkins.EJTitle end,
						set = function(info, value) E.db.muiSkins.EJTitle = value; E:StaticPopup_Show('PRIVATE_RL'); end,
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
						get = function(info) return E.db.muiSkins.MasterPlan end,
						set = function(info, value) E.db.muiSkins.MasterPlan = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
				},
			},
		},
	}
end
tinsert(E.MerConfig, muiSkins)
