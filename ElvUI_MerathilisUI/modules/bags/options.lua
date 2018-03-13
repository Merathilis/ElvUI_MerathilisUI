local MER, E, L, V, P, G = unpack(select(2, ...))
local MERB = E:GetModule("mUIBags")

--Cache global variables

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function BagTable()
	E.Options.args.mui.args.bags = {
		type = "group",
		name = MERB.modName..MER.NewSign,
		order = 18,
		get = function(info) return E.db.mui.bags[ info[#info] ] end,
		hidden = function() return E.private.bags.enable end, -- hide it, if the ElvUI Bags are enabled.
		args = {
			header = {
				type = "header",
				name = MER:cOption(MERB.modName)..MER.NewSign,
				order = 1
			},
			description = {
				type = "description",
				name = MERB:Info() .. "\n\n",
				order = 2
			},
			enable = {
				type = "toggle",
				name = L["Enable"],
				width = "double",
				order = 3,
				set = function(info, value) E.db.mui.bags[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			},
			settingsHeader = {
				type = "header",
				name = MER:cOption(L["Settings"]),
				order = 4,
			},
			bagSize = {
				order = 5,
				type = "range",
				name = L["Size of slot in bags"],
				min = 15, max = 45, step = 1,
				set = function(info, value) E.db.mui.bags[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				disabled = function() return not E.db.mui.bags.enable end,
			},
			sortInverted = {
				order = 8,
				type = "toggle",
				name = L["Order by desc"],
				set = function(info, value) E.db.mui.bags[ info[#info] ] = value; end,
				disabled = function() return not E.db.mui.bags.enable end,
			},
			bagWidth = {
				order = 6,
				type = "range",
				name = L["BagsFrame width"],
				min = 8, max = 20, step = 1,
				set = function(info, value) E.db.mui.bags[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				disabled = function() return not E.db.mui.bags.enable end,
			},
			bankWidth = {
				order = 7,
				type = "range",
				name = L["BankFrame width"],
				min = 8, max = 20, step = 1,
				set = function(info, value) E.db.mui.bags[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				disabled = function() return not E.db.mui.bags.enable end,
			},
			itemLevel = {
				order = 9,
				type = "toggle",
				name = L["Show item level"],
				set = function(info, value) E.db.mui.bags[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				hidden = function() return not E.db.mui.bags.enable end,
			}
		},
	}
end
tinsert(MER.Config, BagTable)