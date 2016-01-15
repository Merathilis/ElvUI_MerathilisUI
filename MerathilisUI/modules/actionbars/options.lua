local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERAB = E:GetModule('muiActionbars');

local function muiActionbars()
	E.Options.args.mui.args.config.args.actionbars = {
		order = 12,
		type = 'group',
		name = L["ActionBars"],
		args = {
			oor = {
				order = 1,
				type = 'group',
				name = L["Out of Range"],
				guiInline = true,
				args = {
					enable = {
						type = 'toggle',
						order = 1,
						name = L["Enable"],
						desc = L["Change the Out of Range Check to be on the Hotkey instead of the Button."],
						get = function(info) return E.private.muiActionbars.oor.enable end,
						set = function(info, value) E.private.muiActionbars.oor.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
				},
			},
		},
	}
end
tinsert(E.MerConfig, muiActionbars)