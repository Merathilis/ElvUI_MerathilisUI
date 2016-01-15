local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

local function muiSkins()
	E.Options.args.mui.args.skins = {
		order = 11,
		type = 'group',
		name = L['Skins'],
		guiInline = true,
		args = {
			MasterPlan = {
				order = 1,
				type = 'toggle',
				name = L['MasterPlan'],
				desc = L['Skins the additional Tabs from MasterPlan.'],
				get = function(info) return E.db.muiSkins[ info[#info] ] end,
				set = function(info, value) E.db.muiSkins[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
		},
	}
end
tinsert(E.MerConfig, muiSkins)
