local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERLT = E:GetModule('muiPVP');

-- Cache global variables
-- GLOBALS: PET_BATTLE_PVP_DUEL, PVP, DUEL

local function muiPVP()
	E.Options.args.mui.args.config.args.pvp = {
		order = 15,
		type = 'group',
		name = PVP,
		args = {
			duels = {
				order = 4,
				type = "group",
				name = DUEL,
				guiInline = true,
				get = function(info) return E.db.muiPVP.duels[ info[#info] ] end,
				set = function(info, value) E.db.muiPVP.duels[ info[#info] ] = value; end,
				args = {
					regular = {
						order = 1,
						type = "toggle",
						name = PVP,
						desc = L["Automatically cancel PvP duel requests."],
					},
					pet = {
						order = 2,
						type = "toggle",
						name = PET_BATTLE_PVP_DUEL,
						desc = L["Automatically cancel pet battles duel requests."],
					},
					announce = {
						order = 3,
						type = "toggle",
						name = L["Announce"],
						desc = L["Announce in chat if duel was rejected."],
					},
				},
			},
		},
	}
end
tinsert(E.MerConfig, muiPVP)
