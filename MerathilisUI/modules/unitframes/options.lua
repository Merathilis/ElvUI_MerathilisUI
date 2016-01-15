local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

local function muiUnitframes()
	E.Options.args.mui.args.unitframes = {
		order = 10,
		type = 'group',
		name = L['UnitFrames'],
		guiInline = true,
		args = {
			roleIcons = {
				order = 7,
				type = 'toggle',
				name = L['Role Icon'],
				desc = L['Replaces the default role icons with SVUI ones.'],
				get = function(info) return E.db.muiUnitframes[ info[#info] ] end,
				set = function(info, value) E.db.muiUnitframes[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
		},
	}
end
tinsert(E.MerConfig, muiUnitframes)