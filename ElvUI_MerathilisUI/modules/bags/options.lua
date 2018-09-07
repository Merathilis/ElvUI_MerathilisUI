local MER, E, L, V, P, G = unpack(select(2, ...))
local MERB = MER:GetModule("mUIBags")

--Cache global variables

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function BagTable()
	E.Options.args.mui.args.modules.args.bags = {
		type = "group",
		name = MERB.modName,
		order = 19,
		get = function(info) return E.db.mui.bags[ info[#info] ] end,
		set = function(info, value) E.db.mui.bags[ info[#info] ] = value; end,
		disabled = function() return not E.private.bags.enable end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = MER:cOption(L["Bags"]),
			},
			splitBags = {
				order =2,
				type = "group",
				name = MER:cOption(L["Split Bags"]),
				guiInline = true,
				get = function(info) return E.db.mui.bags.splitBags[ info[#info] ] end,
				set = function(info, value) E.db.mui.bags.splitBags[ info[#info] ] = value; MERB:Layout(false) end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						width = "full",
						set = function(info, value) E.db.mui.bags.splitBags[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
					},
					credits = {
						order = 2,
						type = "group",
						name = MER:cOption(L["Credits"]),
						guiInline = true,
						args = {
							original = {
								order = 1,
								type = "description",
								fontSize = "medium",
								name = "ElvUI_SplitBag (by SMRTL)",
							},
						},
					},
					spacer1 = {
						order = 3,
						type = "description",
						name = "",
					},
					description = {
						order = 4,
						type = "description",
						name = L["With the options below, you are able to split the ElvUI All In One Bag. You can select each bag to be splitted."],
					},
					spacer2 = {
						order = 5,
						type = "description",
						name = "",
					},
					bag1 = {
						order = 6,
						type = "toggle",
						name = L["Split Bag 1"],
						disabled = function() return not E.db.mui.bags.splitBags.enable end,
					},
					bag2 = {
						order = 7,
						type = "toggle",
						name = L["Split Bag 2"],
						disabled = function() return not E.db.mui.bags.splitBags.enable end,
					},
					bag3 = {
						order = 8,
						type = "toggle",
						name = L["Split Bag 3"],
						disabled = function() return not E.db.mui.bags.splitBags.enable end,
					},
					bag4 = {
						order = 9,
						type = "toggle",
						name = L["Split Bag 4"],
						disabled = function() return not E.db.mui.bags.splitBags.enable end,
					},
					bagSpacing = {
						order = 10,
						type = "range",
						name = L["Bag spacing"],
						min = 0, max = 20, step = 1,
						disabled = function() return not E.db.mui.bags.splitBags.enable end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, BagTable)