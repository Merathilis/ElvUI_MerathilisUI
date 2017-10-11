local MER, E, L, V, P, G = unpack(select(2, ...))
local EFL = E:GetModule("EnhancedFriendsList")

local function EnhancedFriendsList()
	E.Options.args.mui.args.efl = {
		type = "group",
		name = EFL.modName..MER.NewSign,
		order = 22,
		get = function(info) return E.db.mui.efl[ info[#info] ] end,
		set = function(info, value) E.db.mui.efl[ info[#info] ] = value; end,
		args = {
			header1 = {
				type = "header",
				name = MER:cOption(EFL.modName)..MER.NewSign,
				order = 1
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
						name = "EnhancedFriendsList - by Azilroka",
					},
				},
			},
			general = {
				order = 3,
				type = "group",
				name = MER:cOption(L["General"]),
				guiInline = true,
				get = function(info) return E.db.mui.efl[info[#info]] end,
				set = function(info, value) E.db.mui.efl[info[#info]] = value; FriendsFrame_UpdateFriends() end, -- causes an error if the FriendsFrame isnt open
				args = {
					NameFont = {
						type = "select", dialogControl = 'LSM30_Font',
						order = 1,
						name = L["Name Font"],
						values = AceGUIWidgetLSMlists.font,
					},
					NameFontSize = {
						order = 2,
						name = FONT_SIZE,
						type = "range",
						min = 6, max = 22, step = 1,
					},
					NameFontFlag = {
						name = L["Font Outline"],
						order = 3,
						type = "select",
						values = {
							['NONE'] = 'None',
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROME'] = 'MONOCHROME',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
					},
					InfoFont = {
						type = "select", dialogControl = 'LSM30_Font',
						order = 4,
						name = L["Info Font"],
						values = AceGUIWidgetLSMlists.font,
					},
					InfoFontSize = {
						order = 5,
						name = FONT_SIZE,
						type = "range",
						min = 6, max = 22, step = 1,
					},
					InfoFontFlag = {
						order = 6,
						name = L["Font Outline"],
						type = "select",
						values = {
							['NONE'] = 'None',
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROME'] = 'MONOCHROME',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
					},
					GameIconPack = {
						name = L["Game Icon Pack"],
						order = 7,
						type = "select",
						values = {
							['Default'] = 'Default',
							['BlizzardChat'] = 'Blizzard Chat',
							['Flat'] = 'Flat Style',
							['Gloss'] = 'Glossy',
						},
					},
					StatusIconPack = {
						name = L["Status Icon Pack"],
						order = 8,
						type = "select",
						values = {
							['Default'] = 'Default',
							['Square'] = 'Square',
							['D3'] = 'Diablo 3',
						},
					},
				},
			},
			GameIcons = {
				order = 4,
				type = "group",
				name = L["Game Icon Preview"],
				guiInline = true,
				args = {
					Alliance = {
						order = 1,
						type = "execute",
						name = FACTION_ALLIANCE,
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.mui.efl["GameIconPack"]][info[#info]], 24, 24 end,
					},
					Horde = {
						order = 2,
						type = "execute",
						name = FACTION_HORDE,
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.mui.efl["GameIconPack"]][info[#info]], 24, 24 end,
					},
					Neutral = {
						order = 3,
						type = "execute",
						name = FACTION_STANDING_LABEL4, --Neutral
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.mui.efl["GameIconPack"]][info[#info]], 24, 24 end,
					},
					D3 = {
						order = 4,
						type = "execute",
						name = L["Diablo 3"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.mui.efl["GameIconPack"]][info[#info]], 24, 24 end,
					},
					WTCG = {
						order = 5,
						type = "execute",
						name = L["Hearthstone"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.mui.efl["GameIconPack"]][info[#info]], 24, 24 end,
					},
					S1 = {
						order = 6,
						type = "execute",
						name = L["Starcraft"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.mui.efl["GameIconPack"]][info[#info]], 24, 24 end,
					},
					S2 = {
						order = 6,
						type = "execute",
						name = L["Starcraft 2"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.mui.efl["GameIconPack"]][info[#info]], 24, 24 end,
					},
					App = {
						order = 7,
						type = "execute",
						name = L["App"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.mui.efl["GameIconPack"]][info[#info]], 24, 24 end,
					},
					Hero = {
						order = 8,
						type = "execute",
						name = L["Hero of the Storm"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.mui.efl["GameIconPack"]][info[#info]], 24, 24 end,
					},
					Pro = {
						order = 9,
						type = "execute",
						name = L["Overwatch"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.mui.efl["GameIconPack"]][info[#info]], 24, 24 end,
					},
					DST2 = {
						order = 9,
						type = "execute",
						name = L["Destiny 2"],
						func = function() return end,
						image = function(info) return EFL.GameIcons[E.db.mui.efl["GameIconPack"]][info[#info]], 24, 24 end,
					},
				},
			},
			StatusIcons = {
				order = 5,
				type = "group",
				name = L["Status Icon Preview"],
				guiInline = true,
				args = {
					Online = {
						order = 1,
						type = "execute",
						name = FRIENDS_LIST_ONLINE,
						func = function() return end,
						image = function(info) return EFL.StatusIcons[E.db.mui.efl["StatusIconPack"]][info[#info]], 16, 16 end,
					},
					Offline = {
						order = 2,
						type = "execute",
						name = FRIENDS_LIST_OFFLINE,
						func = function() return end,
						image = function(info) return EFL.StatusIcons[E.db.mui.efl["StatusIconPack"]][info[#info]], 16, 16 end,
					},
					DND = {
						order = 3,
						type = "execute",
						name = DEFAULT_DND_MESSAGE,
						func = function() return end,
						image = function(info) return EFL.StatusIcons[E.db.mui.efl["StatusIconPack"]][info[#info]], 16, 16 end,
					},
					AFK = {
						order = 4,
						type = "execute",
						name = DEFAULT_AFK_MESSAGE,
						func = function() return end,
						image = function(info) return EFL.StatusIcons[E.db.mui.efl["StatusIconPack"]][info[#info]], 16, 16 end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, EnhancedFriendsList)