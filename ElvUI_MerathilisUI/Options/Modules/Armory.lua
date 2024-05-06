local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Armory")
local options = MER.options.modules.args
local M = E.Misc
local LSM = E.LSM

local _G = _G

options.armory = {
	type = "group",
	name = E.NewSign .. L["Armory"],
	childGroups = "tab",
	get = function(info)
		return E.db.mui.armory[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.armory[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	disabled = function()
		return not E.db.general.itemLevel.displayCharacterInfo
	end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Armory"], "orange"),
		},
		credits = {
			order = 2,
			type = "group",
			name = F.cOption(L["Credits"], "orange"),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "description",
					name = "|cff1784d1ElvUI|r |cffffffffToxi|r|cff18a8ffUI|r",
				},
			},
		},
		enable = {
			order = 3,
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable/Disable the |cffff7d0aMerathilisUI|r Armory Mode."],
		},
		enchantGroup = {
			order = 10,
			type = "group",
			name = L["Enchant & Socket Strings"],
			get = function(info)
				return E.db.mui.armory.pageInfo[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.armory.pageInfo[info[#info]] = value
				M:UpdatePageInfo(_G.CharacterFrame, "Character")

				if not E.db.general.itemLevel.displayCharacterInfo then
					M:ClearPageInfo(_G.CharacterFrame, "Character")
				end
			end,
			disabled = function()
				return not E.db.mui.armory.enable
			end,
			hidden = function()
				return not E.db.general.itemLevel.displayCharacterInfo
			end,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Settings for strings displaying enchant and socket info from the items"],
				},
				enchantTextEnabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable/Disable the Enchant text display"],
				},
				missingEnchantText = {
					order = 2,
					type = "toggle",
					name = L["Missing Enchants"],
				},
				missingSocketText = {
					order = 3,
					type = "toggle",
					name = L["Missing Sockets"],
				},
				abbreviateEnchantText = {
					order = 4,
					type = "toggle",
					name = L["Short Enchant Text"],
				},
				spacer = {
					order = 5,
					type = "description",
					name = "",
				},
				enchantFont = {
					order = 6,
					type = "group",
					inline = true,
					name = L["Enchant Font"],
					get = function(info)
						return E.db.mui.armory.pageInfo.enchantFont[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.armory.pageInfo.enchantFont[info[#info]] = value
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
						},
						style = {
							order = 2,
							type = "select",
							name = L["Outline"],
							values = MER.Values.FontFlags,
							sortByValue = true,
						},
						size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1,
						},
					},
				},
			},
		},
		itemLevelGroup = {
			order = 11,
			type = "group",
			name = L["Item Level"],
			get = function(info)
				return E.db.mui.armory.pageInfo[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.armory.pageInfo[info[#info]] = value
				M:UpdatePageInfo(_G.CharacterFrame, "Character")

				if not E.db.general.itemLevel.displayCharacterInfo then
					M:ClearPageInfo(_G.CharacterFrame, "Character")
				end
			end,
			disabled = function()
				return not E.db.mui.armory.enable
			end,
			hidden = function()
				return not E.db.general.itemLevel.displayCharacterInfo
			end,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Settings for the Item Level next tor your item slot"],
				},
				itemLevelTextEnabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable/Disable the Item Level text display"],
				},
				iconsEnabled = {
					order = 2,
					type = "toggle",
					name = L["Sockets"],
					desc = L["Toggle sockets & azerite traits"],
				},
				spacer = {
					order = 3,
					type = "description",
					name = "",
				},
				iLvLFont = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Item Level Font"],
					get = function(info)
						return E.db.mui.armory.pageInfo.iLvLFont[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.armory.pageInfo.iLvLFont[info[#info]] = value
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
						},
						style = {
							order = 2,
							type = "select",
							name = L["Outline"],
							values = MER.Values.FontFlags,
							sortByValue = true,
						},
						size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1,
						},
					},
				},
			},
		},
		gradientGroup = {
			order = 12,
			type = "group",
			name = L["Item Quality Gradient"],
			get = function(info)
				return E.db.mui.armory.pageInfo[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.armory.pageInfo[info[#info]] = value
				M:UpdatePageInfo(_G.CharacterFrame, "Character")

				if not E.db.general.itemLevel.displayCharacterInfo then
					M:ClearPageInfo(_G.CharacterFrame, "Character")
				end
			end,
			disabled = function()
				return not E.db.mui.armory.enable
			end,
			hidden = function()
				return not E.db.general.itemLevel.displayCharacterInfo
			end,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Settings for the color coming out of your item slot."],
				},
				itemQualityGradientEnabled = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Toggling this on enables the Item Quality bars."],
				},
				itemQualityGradientWidth = {
					order = 2,
					type = "range",
					name = L["Width"],
					min = 10,
					max = 120,
					step = 1,
					disabled = function()
						return not E.db.mui.armory.itemQualityGradientEnabled
					end,
				},
				itemQualityGradientHeight = {
					order = 3,
					type = "range",
					name = L["Height"],
					min = 1,
					max = 40,
					step = 1,
					disabled = function()
						return not E.db.mui.armory.itemQualityGradientEnabled
					end,
				},
				itemQualityGradientStartAlpha = {
					order = 4,
					type = "range",
					name = L["Start Alpha"],
					min = 0,
					max = 1,
					step = 0.01,
					isPercent = true,
					disabled = function()
						return not E.db.mui.armory.itemQualityGradientEnabled
					end,
				},
				itemQualityGradientEndAlpha = {
					order = 5,
					type = "range",
					name = L["End Alpha"],
					min = 0,
					max = 1,
					step = 0.01,
					isPercent = true,
					disabled = function()
						return not E.db.mui.armory.itemQualityGradientEnabled
					end,
				},
			},
		},
	},
}
