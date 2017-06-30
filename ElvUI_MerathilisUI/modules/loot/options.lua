local MER, E, L, V, P, G = unpack(select(2, ...))
local LM = E:GetModule("LootMon")

local screenwidth = UIParent:GetWidth()
local screenheight = UIParent:GetHeight()

local function LootMonTable()
	E.Options.args.mui.args.lootMon = {
		type = "group",
		name = LM.modName..MER.NewSign,
		order = 16,
		get = function(info) return E.db.mui.lootMon[ info[#info] ] end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(LM.modName)..MER.NewSign,
			},
			credits = {
				order = 2,
				type = "group",
				name = MER:cOption(L["Credits"]),
				guiInline = true,
				args = {
					tukui = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = format("|cff9482c9LootMon - bye LCF|r"),
					},
				},
			},
			general = {
				order = 3,
				type = "group",
				name = MER:cOption(LM.modName),
				guiInline = true,
				get = function(info) return E.db.mui.lootMon[ info[#info] ] end,
				set = function(info, value) E.db.mui.lootMon[ info[#info] ] = value; end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						-- set = function(info, value) E.db.mui.lootMon[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					selfRarity = {
						order = 2,
						type = "select",
						name = L["Self Rarity"],
						desc = L["Min quality for your looted items that will be displayed"],
						disabled = function() return not E.db.mui.lootMon.enable end,
						hidden = function() return not E.db.mui.lootMon.enable end,
						values = {
							[0] = "|cff9d9d9d"..ITEM_QUALITY0_DESC.."|r",
							[1] = "|cffffffff"..ITEM_QUALITY1_DESC.."|r",
							[2] = "|cff1EFF00"..ITEM_QUALITY2_DESC.."|r",
							[3] = "|cff0070DD"..ITEM_QUALITY3_DESC.."|r",
							[4] = "|cffA335EE"..ITEM_QUALITY4_DESC.."|r",
							[5] = "|cffff8000"..ITEM_QUALITY5_DESC.."|r",
							[6] = "|cffe6cc80"..ITEM_QUALITY6_DESC.."|r",
							[7] = "|cffe6cc80"..ITEM_QUALITY7_DESC.."|r",
						},
					},
					Rarity = {
						order = 3,
						type = "select",
						name = L["Other Rarity"],
						desc = L["Min quality for your party members looted items that will be displayed"],
						disabled = function() return not E.db.mui.lootMon.enable end,
						hidden = function() return not E.db.mui.lootMon.enable end,
						values = {
							[0] = "|cff9d9d9d"..ITEM_QUALITY0_DESC.."|r",
							[1] = "|cffffffff"..ITEM_QUALITY1_DESC.."|r",
							[2] = "|cff1EFF00"..ITEM_QUALITY2_DESC.."|r",
							[3] = "|cff0070DD"..ITEM_QUALITY3_DESC.."|r",
							[4] = "|cffA335EE"..ITEM_QUALITY4_DESC.."|r",
							[5] = "|cffff8000"..ITEM_QUALITY5_DESC.."|r",
							[6] = "|cffe6cc80"..ITEM_QUALITY6_DESC.."|r",
							[7] = "|cffe6cc80"..ITEM_QUALITY7_DESC.."|r",
						},
					},
					position = {
						order = 4,
						type = "group",
						name = L["Position"],
						get = function(info) return E.db.mui.lootMon.position[ info[#info] ] end,
						set = function(info, value) E.db.mui.lootMon.position[ info[#info] ] = value; end,
						disabled = function() return not E.db.mui.lootMon.enable end,
						hidden = function() return not E.db.mui.lootMon.enable end,
						args = {
							Xoff = {
								order = 1,
								type = "range",
								name = L["xOffset"],
								min = 0, max = 500, step = 5,
							},
							Yoff = {
								order = 2,
								type = "range",
								name = L["yOffset"],
								min = 0, max = 500, step = 5,
							},
						},
					},
					timers = {
						order = 5,
						type = "group",
						name = L["Timer"],
						get = function(info) return E.db.mui.lootMon.timers[ info[#info] ] end,
						set = function(info, value) E.db.mui.lootMon.timers[ info[#info] ] = value; end,
						disabled = function() return not E.db.mui.lootMon.enable end,
						hidden = function() return not E.db.mui.lootMon.enable end,
						args = {
							fadeIn = {
								order = 1,
								type = "range",
								name = L["Fade In Timer"],
								desc = L["Time to show item"],
								min = 1, max = 10, step = 1,
							},
							fadeOut = {
								order = 2,
								type = "range",
								name = L["Fade Out Timer"],
								desc = L["Time to hide item"],
								min = 1, max = 10, step = 1,
							},
							fade = {
								order = 3,
								type = "range",
								name = L["Fade Timer"],
								desc = L["How long item is shown"],
								min = 3, max = 10, step = 1,
							},
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, LootMonTable)