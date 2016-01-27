local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

local function muiUnitframes()
	E.Options.args.mui.args.unitframes = {
		order = 10,
		type = 'group',
		name = L['UnitFrames'],
		guiInline = true,
		get = function(info) return E.db.muiUnitframes[ info[#info] ] end,
		set = function(info, value) E.db.muiUnitframes[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
		args = {
			roleIcons = {
				order = 1,
				type = 'toggle',
				name = L['Role Icon'],
				desc = L['Replaces the default role icons with SVUI ones.'],
			},
			setRole = {
				order = 2,
				type = 'toggle',
				name = L['Set Role'],
				desc = L['Automatically set your role based on your specc.'],
			},
		},
	}
end
tinsert(E.MerConfig, muiUnitframes)