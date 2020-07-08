local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("Progress")

--Cache global variables
--Lua functions
local _G = _G
local tinsert, twipe = table.insert, table.wipe
--WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS:

local function Tooltip()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.tooltip = {
		type = "group",
		name = L["Tooltip"],
		get = function(info) return E.db.mui.tooltip[info[#info]] end,
		set = function(info, value) E.db.mui.tooltip[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = ACH:Header(MER:cOption(L["Tooltip"]), 1),
			petIcon = {
				order = 2,
				type = "toggle",
				name = L["Pet Battle"],
				desc = L["Adds an Icon for battle pets on the tooltip."],
			},
			factionIcon = {
				order = 3,
				type = "toggle",
				name = L.FACTION,
				desc = L["Adds an Icon for the faction on the tooltip."],
			},
			achievement = {
				order = 4,
				type = "toggle",
				name = L["ACHIEVEMENTS"],
				desc = L["Adds information to the tooltip, on which char you earned an achievement."],
			},
			roleIcon = {
				order = 5,
				type = "toggle",
				name = L["Role Icon"],
			},
			keystone = {
				order = 6,
				type = "toggle",
				name = L["Keystone"],
				desc = L["Adds descriptions for mythic keystone properties to their tooltips."],
			},
			titleColor = {
				order = 7,
				type = "toggle",
				name = L["Title Color"],
				desc = L["Change the color of the title in the Tooltip."],
			},
			azerite = {
				order = 10,
				type = "group",
				name = L.HEART_OF_AZEROTH_MISSING_ACTIVE_POWERS,
				guiInline = true,
				hidden = function() return IsAddOnLoaded("AzeriteTooltip") end,
				get = function(info) return E.db.mui.tooltip.azerite[info[#info]] end,
				set = function(info, value) E.db.mui.tooltip.azerite[info[#info]] = value; end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						set = function(info, value) E.db.mui.tooltip.azerite.enable = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					onlyIcons = {
						order = 2,
						type = "toggle",
						name = L["Only Icons"],
					},
				},
			},
			nameHover = {
				order = 11,
				type = "group",
				guiInline = true,
				name = L["Name Hover"],
				desc = L["Shows the Unit Name on the mouse."],
				get = function(info) return E.db.mui.nameHover[info[#info]] end,
				set = function(info, value) E.db.mui.nameHover[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					header = ACH:Header(MER:cOption(L["Name Hover"]), 0),
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					fontSize = {
						order = 2,
						type = "range",
						name = L["Size"],
						min = 4, max = 24, step = 1,
					},
					fontOutline = {
						order = 3,
						type = "select",
						name = L["Font Outline"],
						values = {
							["NONE"] = _G.NONE,
							["OUTLINE"] = "OUTLINE",
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE",
						},
					},
				},
			},
			progressInfo = {
				order = 12,
				type = "group",
				name = L["Progress Info"],
				guiInline = true,
				disabled = function() return not E.private.tooltip.enable end,
				hidden = function() return IsAddOnLoaded("RaiderIO") end,
				get = function(info) return E.db.mui.tooltip.progressInfo[ info[#info] ] end,
				set = function(info, value) E.db.mui.tooltip.progressInfo[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					raid = {
						order = 1,
						name = L["Raid"],
						type = "group",
						get = function(info) return E.db.mui.tooltip.progressInfo.raid[info[#info]] end,
						set = function(info, value) E.db.mui.tooltip.progressInfo.raid[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						disabled = function() return not not E.private.tooltip.enable or not E.db.mui.tooltip.progressInfo.enable end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								width = "full",
								disabled = function() return not E.db.mui.tooltip.progressInfo.enable end,
							},
							Uldir = {
								order = 2,
								type = "toggle",
								name = L["Uldir"],
								disabled = function() return not E.db.mui.tooltip.progressInfo.enable or not E.db.mui.tooltip.progressInfo.raid.enable end,
							},
							BattleOfDazaralor = {
								order = 3,
								type = "toggle",
								name = L["Battle Of Dazaralor"],
								disabled = function() return not E.db.mui.tooltip.progressInfo.enable or not E.db.mui.tooltip.progressInfo.raid.enable end,
							},
							CrucibleOfStorms = {
								order = 4,
								type = "toggle",
								name = L["Crucible Of Storms"],
								disabled = function() return not E.db.mui.tooltip.progressInfo.enable or not E.db.mui.tooltip.progressInfo.raid.enable end,
							},
							EternalPalace = {
								order = 4,
								type = "toggle",
								name = L["Eternal Palace"],
								disabled = function() return not E.db.mui.tooltip.progressInfo.enable or not E.db.mui.tooltip.progressInfo.raid.enable end,
							},
							Nyalotha = {
								order = 4,
								type = "toggle",
								name = L["Ny'alotha"],
								disabled = function() return not E.db.mui.tooltip.progressInfo.enable or not E.db.mui.tooltip.progressInfo.raid.enable end,
							},
						}
					},
				},
			},
			corruption = {
				order = 13,
				type = "group",
				name = L["Corruption"],
				guiInline = true,
				disabled = function() return not E.private.tooltip.enable end,
				get = function(info) return E.db.mui.tooltip.corruption[ info[#info] ] end,
				set = function(info, value) E.db.mui.tooltip.corruption[ info[#info] ] = value; end,
				args = {
					credits = ACH:Description(L["Credits: siweia | NdUI"], 0),
					spacer = ACH:Spacer(1),
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						width = "full",
						set = function(info, value) E.db.mui.tooltip.corruption.enable = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, Tooltip)
