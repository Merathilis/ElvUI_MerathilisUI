local MER, F, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua functions
local _G = _G
local format = string.format
local tinsert = table.insert
--WoW API / Variables
-- GLOBALS:

local function PvPTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.pvp = {
		type = "group",
		name = L["PVP"],
		get = function(info) return E.db.mui.pvp.duels[ info[#info] ] end,
		set = function(info, value) E.db.mui.pvp.duels[ info[#info] ] = value; end,
		args = {
			header = ACH:Header(MER:cOption(L["PVP"], 'orange'), 0),
			credits = {
				order = 1,
				type = "group",
				name = MER:cOption(L["Credits"], 'orange'),
				guiInline = true,
				args = {
					tukui = ACH:Header(format("|cff9482c9Shadow & Light - Darth & Repooc|r"), 1),
				},
			},
			spacer = ACH:Spacer(2),
			duels = {
				order = 3,
				type = "group",
				name = MER:cOption(L["Duels"], 'orange'),
				guiInline = true,
				args = {
					regular = {
						order = 2,
						type = "toggle",
						name = _G.PVP,
						desc = L["Automatically cancel PvP duel requests."],
					},
					pet = {
						order = 3,
						type = "toggle",
						name = _G.PET_BATTLE_PVP_DUEL,
						desc = L["Automatically cancel pet battles duel requests."],
					},
					announce = {
						order = 4,
						type = "toggle",
						name = L["Announce"],
						desc = L["Announce in chat if duel was rejected."],
					},
				},
			},
			killingBlow = {
				order = 4,
				type = "group",
				name = MER:cOption(KILLING_BLOWS, 'orange'),
				guiInline = true,
				get = function(info) return E.db.mui.pvp.killingBlow[ info[#info] ] end,
				set = function(info, value) E.db.mui.pvp.killingBlow[ info[#info] ] = value end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Show your PvP killing blows as a popup."],
						set = function(info, value) E.db.mui.pvp.killingBlow[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					sound = {
						order = 2,
						type = "toggle",
						name = L["Sound"],
						desc = L["Play sound when killing blows popup is shown."],
						disabled = function() return not E.db.mui.pvp.killingBlow.enable end,
					},
				},
			},
		},
	}
end

tinsert(MER.Config, PvPTable)
