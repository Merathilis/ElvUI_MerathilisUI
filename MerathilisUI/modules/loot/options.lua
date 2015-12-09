local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERLT = E:GetModule('MuiLoot');

local tinsert = table.insert

local function muiLoot()
	E.Options.args.mui.args.config.args.loot = {
		order = 12,
		type = 'group',
		name = L["Loot"],
		args = {
			lootIcon = {
				order = 1,
				type = 'group',
				name = L["Loot Icon"],
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Showes icons of items looted/created near respective messages in chat. Does not affect usual messages."],
						get = function(info) return E.db.muiLoot.lootIcon[ info[#info] ] end,
						set = function(info, value) E.db.muiLoot.lootIcon[ info[#info] ] = value; MERLT:LootIconToggle() end,
					},
					position = {
						order = 2,
						type = "select",
						name = L["Position"],
						disabled = function() return not E.db.muiLoot.lootIcon.enable end,
						get = function(info) return E.db.muiLoot.lootIcon[ info[#info] ] end,
						set = function(info, value) E.db.muiLoot.lootIcon[ info[#info] ] = value; end,
						values = {
							LEFT = L["Left"],
							RIGHT = L["Right"],
						},
					},
					size = {
						order = 3,
						type = "range",
						name = L["Size"],
						disabled = function() return not E.db.muiLoot.lootIcon.enable end,
						min = 8, max = 32, step = 1,
						get = function(info) return E.db.muiLoot.lootIcon[ info[#info] ] end,
						set = function(info, value) E.db.muiLoot.lootIcon[ info[#info] ] = value; end,
					},
				},
			},
		},
	}
end
tinsert(E.MerConfig, muiLoot)
