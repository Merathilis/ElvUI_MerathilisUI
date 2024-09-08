local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args
local LFGPI = MER.Utilities.LFGPlayerInfo

local _G = _G

local cache = {
	groupInfo = {},
}

options.tooltip = {
	type = "group",
	name = L["Tooltip"],
	get = function(info)
		return E.db.mui.tooltip[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.tooltip[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Tooltip"], "orange"),
		},
		modifier = {
			order = 1,
			type = "select",
			name = L["Modifier Key"],
			desc = format(L["The modifer key to show additional information from %s."], MER.Title),
			set = function(info, value)
				E.db.mui.tooltip[info[#info]] = value
			end,
			values = {
				NONE = L["None"],
				SHIFT = L["Shift"],
				CTRL = L["Ctrl"],
				ALT = L["Alt"],
				ALT_SHIFT = format("%s + %s", L["Alt"], L["Shift"]),
				CTRL_SHIFT = format("%s + %s", L["Ctrl"], L["Shift"]),
				CTRL_ALT = format("%s + %s", L["Ctrl"], L["Alt"]),
				CTRL_ALT_SHIFT = format("%s + %s + %s", L["Ctrl"], L["Alt"], L["Shift"]),
			},
		},
		spacer = {
			order = 2,
			type = "description",
			name = " ",
		},
		icon = {
			order = 3,
			type = "toggle",
			name = L["Tooltip Icons"],
			desc = L["Adds an icon for spells and items on your tooltip."],
		},
		factionIcon = {
			order = 4,
			type = "toggle",
			name = L.FACTION,
			desc = L["Adds an Icon for the faction on the tooltip."],
		},
		petIcon = {
			order = 5,
			type = "toggle",
			name = L["Pet Icon"],
			desc = L["Add an icon for indicating the type of the pet."],
		},
		specIcon = {
			order = 6,
			type = "toggle",
			name = L["Spec Icon"],
			desc = L["Show the icon of the specialization."],
		},
		raceIcon = {
			order = 7,
			type = "toggle",
			name = L["Race Icon"],
			desc = L["Show the icon of the player race."],
		},
		petId = {
			order = 8,
			type = "toggle",
			name = L["Pet ID"],
			desc = L["Show battle pet species ID in tooltips."],
		},
		gradientName = {
			order = 9,
			type = "toggle",
			name = L["Gradient Name"],
		},
		nameHover = {
			order = 15,
			type = "group",
			guiInline = true,
			name = "",
			desc = L["Shows the Unit Name on the mouse."],
			get = function(info)
				return E.db.mui.nameHover[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.nameHover[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = F.cOption(L["Name Hover"], "orange"),
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				fontSize = {
					order = 2,
					type = "range",
					name = L["Size"],
					min = 4,
					max = 24,
					step = 1,
				},
				fontOutline = {
					order = 3,
					type = "select",
					name = L["Font Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
				},
				targettarget = {
					order = 4,
					type = "toggle",
					name = L["Display TargetTarget"],
				},
				gradient = {
					order = 5,
					type = "toggle",
					name = L["Gradient Color"],
					desc = L["Colors the player names in a gradient instead of class color"],
				},
			},
		},
		healthBar = {
			order = 16,
			type = "group",
			inline = true,
			name = "",
			get = function(info)
				return E.db.mui.tooltip[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.tooltip[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = F.cOption(L["Health Bar"], "orange"),
				},
				yOffsetOfHealthBar = {
					order = 1,
					type = "range",
					name = L["Health Bar Y-Offset"],
					desc = L["Change the postion of the health bar."],
					min = -50,
					max = 50,
					step = 1,
				},
				yOffsetOfHealthText = {
					order = 2,
					type = "range",
					name = L["Health Text Y-Offset"],
					desc = L["Change the postion of the health text."],
					min = -50,
					max = 50,
					step = 1,
				},
			},
		},
		groupInfo = {
			order = 16,
			type = "group",
			guiInline = true,
			get = function(info)
				return E.db.mui.tooltip.groupInfo[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.tooltip.groupInfo[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			name = "",
			args = {
				header = {
					order = 0,
					type = "header",
					name = F.cOption(L["Group Info"], "orange"),
				},
				credits = {
					order = 1,
					type = "group",
					name = F.cOption(L["Credits"], "orange"),
					guiInline = true,
					args = {
						tukui = {
							order = 1,
							type = "description",
							name = "ElvUI_Windtools - fang2hou",
						},
					},
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add LFG group info to tooltip."],
				},
				title = {
					order = 3,
					type = "toggle",
					name = L["Add Title"],
					desc = L["Display an additional title."],
				},
				mode = {
					order = 4,
					name = L["Mode"],
					type = "select",
					values = {
						NORMAL = L["Normal"],
						COMPACT = L["Compact"],
					},
				},
				classIconStyle = {
					order = 5,
					name = L["Class Icon Style"],
					type = "select",
					values = function()
						local result = {}
						for _, style in pairs(F.GetClassIconStyleList()) do
							local monkIcon = F.GetClassIconStringWithStyle("MONK", style)
							local druidIcon = F.GetClassIconStringWithStyle("DRUID", style)
							local evokerIcon = F.GetClassIconStringWithStyle("EVOKER", style)

							if monkIcon and druidIcon and evokerIcon then
								result[style] = format("%s %s %s", monkIcon, druidIcon, evokerIcon)
							end
						end
						return result
					end,
				},
				betterAlign1 = {
					order = 6,
					type = "description",
					name = "",
					width = "full",
				},
				template = {
					order = 7,
					type = "input",
					name = L["Template"],
					desc = L["Please click the button below to read reference."],
					width = "full",
					get = function(info)
						return cache.groupInfo.template or E.db.mui.tooltip[info[#info - 1]].template
					end,
					set = function(info, value)
						cache.groupInfo.template = value
					end,
				},
				resourcePage = {
					order = 8,
					type = "execute",
					name = F.GetStyledText(L["Reference"]),
					desc = format(
						"|cff00d1b2%s|r (%s)\n%s\n%s\n%s",
						L["Tips"],
						L["Editbox"],
						L["CTRL+A: Select All"],
						L["CTRL+C: Copy"],
						L["CTRL+V: Paste"]
					),
					func = function()
						if E.global.general.locale == "zhCN" or E.global.general.locale == "zhTW" then
							E:StaticPopup_Show(
								"WINDTOOLS_EDITBOX",
								nil,
								nil,
								"https://github.com/fang2hou/ElvUI_WindTools/wiki/预组建队伍玩家信息"
							)
						else
							E:StaticPopup_Show(
								"WINDTOOLS_EDITBOX",
								nil,
								nil,
								"https://github.com/fang2hou/ElvUI_WindTools/wiki/LFG-Player-Info"
							)
						end
					end,
				},
				useDefaultTemplate = {
					order = 9,
					type = "execute",
					name = L["Default"],
					func = function(info)
						E.db.mui.tooltip[info[#info - 1]].template = P.tooltip[info[#info - 1]].template
						cache.groupInfo.template = nil
					end,
				},
				applyButton = {
					order = 10,
					type = "execute",
					name = L["Apply"],
					disabled = function()
						return not cache.groupInfo.template
					end,
					func = function(info)
						E.db.mui.tooltip[info[#info - 1]].template = cache.groupInfo.template
					end,
				},
				betterAlign2 = {
					order = 11,
					type = "description",
					name = "",
					width = "full",
				},
				previewText = {
					order = 12,
					type = "description",
					name = function(info)
						LFGPI:SetClassIconStyle(E.db.mui.tooltip[info[#info - 1]].classIconStyle)
						local text =
							LFGPI:ConductPreview(cache.groupInfo.template or E.db.mui.tooltip[info[#info - 1]].template)
						return L["Preview"] .. ": " .. text
					end,
				},
			},
		},
	},
}
