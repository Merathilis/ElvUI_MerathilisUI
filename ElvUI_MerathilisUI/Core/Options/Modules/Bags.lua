local MER, F, E, L, V, P, G = unpack(select(2, ...))
local options = MER.options.modules.args
local module = MER:GetModule('MER_Bags')
local MERBI = MER:GetModule('MER_BagInfo')

local C_Container_SetSortBagsRightToLeft = C_Container and C_Container.SetSortBagsRightToLeft -- MER.isNewPatch

local function updateBagSortOrder()
	if MER.isNewPatch then
		C_Container_SetSortBagsRightToLeft(E.db.mui.bags.BagSortMode == 1)
	else
		SetSortBagsRightToLeft(E.db.mui.bags.BagSortMode == 1)
	end
end

options.bags = {
	type = "group",
	name = L["Bags"],
	hidden = E.Classic,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Bags"], 'orange'),
		},
		Enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			width = "full",
		},
		spacer = {
			order = 2,
			type = "description",
			name = "",
			fontSize = "medium",
		},
		header1 = {
			order = 3,
			type = "description",
			name = L["BANK_DESC"],
		},
		ItemFilter = {
			order = 4,
			type = "multiselect",
			name = L["Item Filter"],
			get = function(_, key) return E.db.mui.bags[key] end,
			set = function(_, key, value) E.db.mui.bags[key] = value; module:UpdateAllBags() end,
			disabled = function() return not E.db.mui.bags.Enable end,
			values = {
				FilterJunk = L["Junk"],
				FilterConsumable = L["Consumable"],
				FilterEquipment = L["Equipments"],
				FilterEquipSet = L["EquipSets"],
				FilterCollection = L["Collection"],
				FilterFavourite = L["Favorite"],
				FilterGoods = L["Goods"],
				FilterQuest = L["Quest"],
			},
		},
		GatherEmpty = {
			order = 5,
			type = "toggle",
			name = L["Collect Empty Slots"],
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateAllBags() end,
			disabled = function() return not E.db.mui.bags.Enable end,
		},
		-- SpecialBagsColor = {
			-- order = 6,
			-- type = "toggle",
			-- name = L["Special Bags Color"],
			-- desc = L["|nShow color for special bags:|n- Herb bag|n- Mining bag|n- Gem bag|n- Enchanted mageweave pouch"],
			-- get = function(info) return E.db.mui.bags[info[#info]] end,
			-- set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateAllBags() end,
			-- disabled = function() return not E.db.mui.bags.Enable end,
		-- },
		ShowNewItem = {
			order = 7,
			type = "toggle",
			name = L["New Item Glow"],
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateAllBags() end,
			disabled = function() return not E.db.mui.bags.Enable end,
			hidden = not E.Retail,
		},
		BagsiLvl = {
			order = 8,
			type = "toggle",
			name = L["Show ItemLevel"],
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateAllBags() end,
			disabled = function() return not E.db.mui.bags.Enable end,
		},
		PetTrash = {
			order = 9,
			type = "toggle",
			name = L["Pet Trash Currencies"],
			desc = L["|nIn patch 9.1, you can buy 3 battle pets by using specific trash items. Keep this enabled, will sort these items into Collection Filter, and won't be sold by auto junk selling."],
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateAllBags() end,
			disabled = function() return not E.db.mui.bags.Enable end,
			hidden = not E.Retail,
		},
		CenterText = {
			order = 10,
			type = "toggle",
			name = L["Center Text"],
			desc = L["Displays additional Infos for an item: e.g. Anima amount"],
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateAllBags() end,
			disabled = function() return not E.db.mui.bags.Enable end,
			hidden = not E.Retail,
		},
		iLvlToShow = {
			order = 11,
			type = "range",
			name = L["ItemLevel Threshold"],
			min = 1, max = 500, step = 1,
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateAllBags() end,
			disabled = function() return not E.db.mui.bags.Enable end,
		},
		BagSortMode = {
			order = 12,
			type = "select",
			name = L["BagSort Mode"],
			desc = L["|nIf you have empty slots after bag sort, please disable bags module, and turn off all bags filter in default ui containers."],
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; updateBagSortOrder() end,
			disabled = function() return not E.db.mui.bags.Enable end,
			values = {
				[1] = L["Forward"],
				[2] = L["Backwards"],
				[3] = _G.DISABLE,
			}
		},
		spacer1 = {
			order = 13,
			type = "description",
			name = "",
			hidden = not E.Retail,
		},
		BagsPerRow = {
			order = 14,
			type = "range",
			name = L["Bags per Row"],
			desc = L["|nIf Bags ItemFilter enabled, change the bags per row for anchoring."],
			min = 1, max = 20, step = 1,
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateAllAnchors() end,
			disabled = function() return not E.db.mui.bags.Enable end,
		},
		BankPerRow = {
			order = 15,
			type = "range",
			name = L["Bank bags per Row"],
			desc = L["|nIf Bags ItemFilter enabled, change the bank bags per row for anchoring."],
			min = 1, max = 20, step = 1,
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateAllAnchors() end,
			disabled = function() return not E.db.mui.bags.Enable end,
		},
		IconSize = {
			order = 16,
			type = "range",
			name = L["Icon Size"],
			min = 20, max = 50, step = 1,
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateBagSize() end,
			disabled = function() return not E.db.mui.bags.Enable end,
		},
		IconSpacing = {
			order = 17,
			type = "range",
			name = L["Icon Spacing"],
			min = 0, max = 30, step = 1,
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateBagSize() end,
			disabled = function() return not E.db.mui.bags.Enable end,
		},
		FontSize = {
			order = 18,
			type = "range",
			name = L["Font Size"],
			min = 10, max = 50, step = 1,
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateBagSize() end,
			disabled = function() return not E.db.mui.bags.Enable end,
		},
		BagsWidth = {
			order = 19,
			type = "range",
			name = L["Bags Width"],
			min = 10, max = 40, step = 1,
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateBagSize() end,
			disabled = function() return not E.db.mui.bags.Enable end,
		},
		BankWidth = {
			order = 20,
			type = "range",
			name = L["Bank Width"],
			min = 10, max = 40, step = 1,
			get = function(info) return E.db.mui.bags[info[#info]] end,
			set = function(info, value) E.db.mui.bags[info[#info]] = value; module:UpdateBagSize() end,
			disabled = function() return not E.db.mui.bags.Enable end,
		},
		equipManager = {
			order = 40,
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
					get = function(info) return E.db.mui.bags.equipOverlay end,
					set = function(info, value) E.db.mui.bags.equipOverlay = value; MERBI:ToggleSettings(); end,
				},
			},
		},
	},
}

local itemFilter = options.bags.args.ItemFilter.values
if E.Retail then
	itemFilter.FilterAzerite = L["Azerite"]
	itemFilter.FilterAnima = L["Anima"]
	itemFilter.FilterRelic = L["Relic"]
	itemFilter.FilterLegendary = L["Legendarys"]
elseif E.Classic or E.TBC or E.Wrath then
	itemFilter.FilterAmmo = L["Ammo"]
end
