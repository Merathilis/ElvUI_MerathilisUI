local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args

options.Notification = {
	type = "group",
	name = L["Notification"],
	get = function(info) return E.db.mui.notification[ info[#info] ] end,
	set = function(info, value) E.db.mui.notification[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Notification"], 'orange'),
		},
		credits = {
			order = 1,
			type = "group",
			name = F.cOption(L["Credits"], 'orange'),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "description",
					name = "RealUI - Nibelheim, Gethe"
				},
			},
		},
		desc = {
			order = 2,
			type = "description",
			fontSize = "small",
			name = L["Here you can enable/disable the different notification types."],
			disabled = function() return not E.db.mui.notification.enable end,
		},
		enable = {
			order = 3,
			type = "toggle",
			name = L["Enable"],
		},
		noSound = {
			order = 4,
			type = "toggle",
			name = L["No Sounds"],
			disabled = function() return not E.db.mui.notification.enable end,
		},
		mail = {
			order = 5,
			type = "toggle",
			name = L["Enable Mail"],
			disabled = function() return not E.db.mui.notification.enable end,
		},
		invites = {
			order = 6,
			type = "toggle",
			name = L["Enable Invites"],
			disabled = function() return not E.db.mui.notification.enable end,
		},
		guildEvents = {
			order = 7,
			type = "toggle",
			name = L["Enable Guild Events"],
			disabled = function() return not E.db.mui.notification.enable end,
		},
		paragon = {
			order = 8,
			type = "toggle",
			name = L["MISC_PARAGON"],
			disabled = function() return not E.db.mui.notification.enable end,
		},
		quickJoin = {
			order = 9,
			type = "toggle",
			name = L["Quick Join"],
			disabled = function() return not E.db.mui.notification.enable end,
		},
		callToArms = {
			order = 10,
			type = "toggle",
			name = _G.BATTLEGROUND_HOLIDAY,
			disabled = function() return not E.db.mui.notification.enable end,
		},
		vignette = {
			order = 20,
			type = "group",
			name = L["Vignette"],
			guiInline = true,
			get = function(info) return E.db.mui.notification.vignette[info[#info]] end,
			set = function(info, value) E.db.mui.notification.vignette[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			disabled = function() return not E.db.mui.notification.enable end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				print = {
					order = 2,
					type = "toggle",
					name = L["Vignette Print"],
				},
				debugPrint = {
					order = 3,
					type = "toggle",
					name = F.cOption(L["Debug Print"], 'red'),
					desc = L["Enable this option to get a chat print of the Name and ID from the Vignettes on the Minimap"]
				}
			},
		},
		fontSettings = {
			order = 40,
			type = "group",
			name = L["Font"],
			guiInline = true,
			args = {
				titleFont = {
					order = 1,
					type = "group",
					name = L["Title Font"],
					get = function(info)
						return E.db.mui.notification.titleFont[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.notification.titleFont[info[#info]] = value
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = E.LSM:HashTable("font"),
						},
						size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1
						},
						style = {
							order = 2,
							type = "select",
							name = L["Outline"],
							values = {
								NONE = L["None"],
								OUTLINE = L["OUTLINE"],
								SHADOW = '|cff888888Shadow|r',
								SHADOWOUTLINE = '|cff888888Shadow|r Outline',
								SHADOWTHICKOUTLINE = '|cff888888Shadow|r Thick',
								MONOCHROME = L["MONOCHROME"],
								MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
								THICKOUTLINE = L["THICKOUTLINE"]
							},
						},
					},
				},
				textFont = {
					order = 2,
					type = "group",
					name = L["Text Font"],
					get = function(info)
						return E.db.mui.notification.textFont[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.notification.textFont[info[#info]] = value
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = E.LSM:HashTable("font"),
						},
						size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1
						},
						style = {
							order = 2,
							type = "select",
							name = L["Outline"],
							values = {
								NONE = L["None"],
								OUTLINE = L["OUTLINE"],
								SHADOW = '|cff888888Shadow|r',
								SHADOWOUTLINE = '|cff888888Shadow|r Outline',
								SHADOWTHICKOUTLINE = '|cff888888Shadow|r Thick',
								MONOCHROME = L["MONOCHROME"],
								MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
								THICKOUTLINE = L["THICKOUTLINE"]
							},
						},
					},
				},
			},
		},
	},
}

do
	local selectedKey
	local tempID

	options.Notification.args.vignette.args.blacklist = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Blacklist"],
		disabled = function() return not E.db.mui.notification.enable end,
		args = {
			name = {
				order = 1,
				type = "input",
				name = L["Vignette ID"],
				get = function()
					return tonumber(tempID)
				end,
				set = function(_, value)
					tempID = value
				end
			},
			addButton = {
				order = 3,
				type = "execute",
				name = L["Add"],
				func = function()
					if tempID then
						E.db.mui.notification.vignette.blacklist[tonumber(tempID)] = true
						tempID = nil
					else
						F.Print(L["Please set the ID first."])
					end
				end
			},
			spacer = {
				order = 4,
				type = "description",
				name = " ",
				width = "full"
			},
			listTable = {
				order = 5,
				type = "select",
				name = L["Spell List"],
				get = function()
					return selectedKey
				end,
				set = function(_, value)
					selectedKey = value
				end,
				values = function()
					local result = {}
					for fullID in pairs(E.db.mui.notification.vignette.blacklist) do
						result[fullID] = fullID
					end
					return result
				end
			},
			deleteButton = {
				order = 6,
				type = "execute",
				name = L["Delete"],
				func = function()
					if selectedKey then
						E.db.mui.notification.vignette.blacklist[selectedKey] = nil
					end
				end
			},
		},
	}
end
