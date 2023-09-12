local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args
local module = MER:GetModule('MER_Bags')
local MERBI = MER:GetModule('MER_BagInfo')

options.bags = {
	type = "group",
	name = L["Bags"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Bags"], 'orange'),
		},
		equipManager = {
			order = 1,
			type = "group",
			guiInline = true,
			name = F.cOption(L["Equip Manager"], 'orange'),
			hidden = function() return not E.private.bags.enable end,
			args = {
				equipOverlay = {
					order = 1,
					type = "toggle",
					name = L["Equipment Set Overlay"],
					desc = L["Show the associated equipment sets for the items in your bags (or bank)."],
					get = function(_) return E.db.mui.bags.equipOverlay end,
					set = function(_, value)
						E.db.mui.bags.equipOverlay = value; MERBI:ToggleSettings();
					end,
				},
			},
		},
	},
}

