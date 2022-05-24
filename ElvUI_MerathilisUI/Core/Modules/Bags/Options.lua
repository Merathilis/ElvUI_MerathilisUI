local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MERBI = MER:GetModule('MER_BagInfo')

local tinsert = table.insert

local function BagTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.bags = {
		type = "group",
		name = L["Bags"],
		get = function(info) return E.db.mui.bags[ info[#info] ] end,
		set = function(info, value) E.db.mui.bags[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
		args = {
			header = ACH:Header(F.cOption(L["Bags"], 'orange'), 1),
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
end
tinsert(MER.Config, BagTable)
