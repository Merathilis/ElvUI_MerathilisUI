local MER, E, L, V, P, G = unpack(select(2, ...))
local MERAY = MER:GetModule('MER_Armory')

local _G = _G

local function ArmoryTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.armory = {
		type = "group",
		name = L["Armory"],
		childGroups = 'tab',
		disabled = function() return not E.db.general.itemLevel.displayCharacterInfo end,
		get = function(info) return E.db.mui.armory[ info[#info] ] end,
		set = function(info, value) E.db.mui.armory[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = ACH:Header(MER:cOption(L["Armory"], 'orange'), 1),
			enable = {
				type = "toggle",
				order = 2,
				name = L["Enable"],
				desc = L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."],
			},
		},
	}
end
tinsert(MER.Config, ArmoryTable)
