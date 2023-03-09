local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Armory')
local options = MER.options.modules.args
local M = E.Misc

local _G = _G

local fontStyleList = {
	["NONE"] = NONE,
	["OUTLINE"] = 'OUTLINE',
	["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
	["THICKOUTLINE"] = 'THICKOUTLINE'
}

options.armory = {
	type = "group",
	name = L["Armory"],
	childGroups = "tab",
	hidden = not E.Wrath,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Armory"], 'orange'),
		},
		character = {
			order = 2,
			type = "group",
			name = L["Character Armory"],
			desc = "",
			get = function(info) return E.db.mui.armory.character[info[#info]] end,
			set = function(info, value)
				E.db.mui.armory.character[info[#info]] = value;
				E:StaticPopup_Show("PRIVATE_RL")
				M:UpdatePageInfo(_G.CharacterFrame, 'Character')

				if not E.db.general.itemLevel.displayCharacterInfo then
					M:ClearPageInfo(_G.CharacterFrame, 'Character')
				end
			end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = F.cOption(L["Character Armory"], 'orange'),
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."],
				},
			},
		},
	},
}
