local MER, F, E, L, V, P, G = unpack(select(2, ...))
local options = MER.options.modules.args
local MERBI = MER:GetModule('MER_BagInfo')

options.bags = {
	type = "group",
	name = F.cOption(L["Bags"], 'orange'),
	get = function(info) return E.db.mui.bags[ info[#info] ] end,
	set = function(info, value) E.db.mui.bags[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Bags"], 'orange'),
		},
		equipManager = {
			order = 2,
			type = "group",
			guiInline = true,
			name = F.cOption(L["Equip Manager"], 'orange'),
			hidden = not E.Retail,
			args = {
				equipOverlay = {
					type = "toggle",
					order = 1,
					name = L["Equipment Set Overlay"],
					desc = L["Show the associated equipment sets for the items in your bags (or bank)."],
					disabled = function() return not E.private.bags.enable end,
					get = function(info) return E.db.mui.bags.equipOverlay end,
					set = function(info, value) E.db.mui.bags.equipOverlay = value; MERBI:ToggleSettings(); end,
				},
			},
		},
	},
}

