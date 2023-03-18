local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_LocPanel')
local options = MER.options.modules.args
local LSM = E.LSM

local ceil = math.ceil
local format = string.format

local CLASS, CUSTOM, DEFAULT = CLASS, CUSTOM, DEFAULT

options.locPanel = {
	type = "group",
	name = L["Location Panel"],
	get = function(info) return E.db.mui.locPanel[ info[#info] ] end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Location Panel"], 'orange'),
		},
		credits = {
			order = 2,
			type = "group",
			name = F.cOption(L["Credits"], 'orange'),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "description",
					name = format("|cff9482c9Shadow & Light - Darth & Repooc|r"),
				},
			},
		},
		panel = {
			order = 3,
			type = "group",
			name = F.cOption(L["Location Panel"], 'orange'),
			guiInline = true,
			args = {
				enable = {
					type = "toggle",
					name = L["Enable"],
					order = 1,
					set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; module:Toggle() end,
				},
				linkcoords = {
					type = "toggle",
					name = L["Link Position"],
					desc = L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."],
					order = 2,
					disabled = function() return not E.db.mui.locPanel.enable end,
					hidden = function() return not E.db.mui.locPanel.enable end,
					set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; end,
				},
				template = {
					order = 3,
					name = L["Template"],
					type = "select",
					disabled = function() return not E.db.mui.locPanel.enable end,
					hidden = function() return not E.db.mui.locPanel.enable end,
					set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; module:Template(); E:StaticPopup_Show("PRIVATE_RL"); end,
					values = {
						["Default"] = DEFAULT,
						["Transparent"] = L["Transparent"],
						["NoBackdrop"] = L["NoBackdrop"],
					},
				},
				autowidth = {
					type = "toggle",
					name = L["Auto Width"],
					desc = L["Change width based on the zone name length."],
					order = 4,
					disabled = function() return not E.db.mui.locPanel.enable end,
					hidden = function() return not E.db.mui.locPanel.enable end,
					set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; module:Resize() end,
				},
				width = {
					order = 5,
					type = "range",
					name = L["Width"],
					min = 100, max = ceil(E.screenWidth) / 2, step = 1,
					disabled = function() return not E.db.mui.locPanel.enable or E.db.mui.locPanel.autowidth end,
					hidden = function() return not E.db.mui.locPanel.enable end,
					set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; module:Resize() end,
				},
				height = {
					order = 6,
					type = "range",
					name = L["Height"],
					min = 10, max = 50, step = 1,
					disabled = function() return not E.db.mui.locPanel.enable end,
					hidden = function() return not E.db.mui.locPanel.enable end,
					set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; module:Resize() end,
				},
				throttle = {
					order = 7,
					type = "range",
					name = L["Update Throttle"],
					desc = L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."],
					min = 0.1, max = 2, step = 0.1,
					disabled = function() return not E.db.mui.locPanel.enable end,
					hidden = function() return not E.db.mui.locPanel.enable end,
					set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; end,
				},
				combathide = {
					order = 8,
					type = "toggle",
					name = L["Hide In Combat"],
					disabled = function() return not E.db.mui.locPanel.enable end,
					hidden = function() return not E.db.mui.locPanel.enable end,
					set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; end,
				},
				orderhallhide = {
					order = 9,
					type = "toggle",
					name = L["Hide In Class Hall"],
					set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; module:Toggle() end,
					disabled = function() return not E.db.mui.locPanel.enable end,
					hidden = function() return not E.db.mui.locPanel.enable end,
				},
				location = {
					order = 20,
					type = "group",
					name = L["Location"],
					hidden = function() return not E.db.mui.locPanel.enable end,
					args = {
						zoneText = {
							type = "toggle",
							name = L["Full Location"],
							order = 1,
							disabled = function() return not  E.db.mui.locPanel.enable end,
							set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; end,
						},
						colorType = {
							order = 2,
							name = L["Color Type"],
							type = "select",
							disabled = function() return not E.db.mui.locPanel.enable end,
							set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; end,
							values = {
								["REACTION"] = L["Reaction"],
								["DEFAULT"] = DEFAULT,
								["CLASS"] = CLASS,
								["CUSTOM"] = CUSTOM,
							},
						},
						customColor = {
							type = "color",
							order = 3,
							name = L["Custom Color"],
							disabled = function() return not E.db.mui.locPanel.enable or E.db.mui.locPanel.colorType ~= "CUSTOM" end,
							get = function(info)
								local t = E.db.mui.locPanel[ info[#info] ]
								local d = P.locPanel[info[#info]]
								return t.r, t.g, t.b, d.r, d.g, d.b
							end,
							set = function(info, r, g, b)
								E.db.mui.locPanel[ info[#info] ] = {}
								local t = E.db.mui.locPanel[ info[#info] ]
								t.r, t.g, t.b = r, g, b
							end,
						},
					},
				},
				coordinates = {
					order = 21,
					type = "group",
					name = L["Coordinates"],
					hidden = function() return not E.db.mui.locPanel.enable end,
					args = {
						format = {
							order = 1,
							name = L["Format"],
							type = "select",
							disabled = function() return not E.db.mui.locPanel.enable or E.db.mui.locPanel.coordshide end,
							set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; end,
							values = {
								["%.0f"] = DEFAULT,
								["%.1f"] = "45.3",
								["%.2f"] = "45.34",
							},
						},
						colorType_Coords = {
							order = 2,
							name = L["Color Type"],
							type = "select",
							disabled = function() return not E.db.mui.locPanel.enable or E.db.mui.locPanel.coordshide end,
							set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; end,
							values = {
								["REACTION"] = L["Reaction"],
								["DEFAULT"] = DEFAULT,
								["CLASS"] = CLASS,
								["CUSTOM"] = CUSTOM,
							},
						},
						customColor_Coords = {
							type = "color",
							order = 3,
							name = L["Custom Color"],
							disabled = function() return not E.db.mui.locPanel.enable or E.db.mui.locPanel.colorType_Coords ~= "CUSTOM" or E.db.mui.locPanel.coordshide end,
							get = function(info)
								local t = E.db.mui.locPanel[ info[#info] ]
								local d = P.locPanel[info[#info]]
								return t.r, t.g, t.b, d.r, d.g, d.b
							end,
							set = function(info, r, g, b)
								E.db.mui.locPanel[ info[#info] ] = {}
								local t = E.db.mui.locPanel[ info[#info] ]
								t.r, t.g, t.b = r, g, b
							end,
						},
						coordshide = {
							type = "toggle",
							order = 4,
							name = L["Hide Coordinates"],
							get = function(info) return E.db.mui.locPanel[ info[#info] ] end,
							set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; module:ToggleCoords() end,
							disabled = function() return not E.db.mui.locPanel.enable or not E.db.mui.locPanel.template == "NoBackdrop" end,
						},
					},
				},
				portals = {
					order = 22,
					type = "group",
					name = L["Relocation Menu"],
					disabled = function() return not E.db.mui.locPanel.enable end,
					hidden = function() return not E.db.mui.locPanel.enable end,
					get = function(info) return E.db.mui.locPanel.portals[ info[#info] ] end,
					set = function(info, value) E.db.mui.locPanel.portals[ info[#info] ] = value; end,
					args = {
						enable = {
							type = "toggle",
							name = L["Enable"],
							desc = L["Right click on the location panel will bring up a menu with available options for relocating your character (e.g. Hearthstones, Portals, etc)."],
							order = 1,
						},
						customWidth = {
							type = "toggle",
							name = L["Custom Width"],
							desc = L["By default menu's width will be equal to the location panel width. Checking this option will allow you to set own width."],
							order = 2,
						},
						customWidthValue = {
							order = 3,
							name = L["Width"],
							type = "range",
							min = 100, max = ceil(E.screenWidth), step = 1,
							disabled = function() return not E.db.mui.locPanel.portals.customWidth or not E.db.mui.locPanel.enable end,
						},
						justify = {
							order = 4,
							name = L["Justify Text"],
							type = "select",
							values = {
								["LEFT"] = L["Left"],
								["CENTER"] = L["Middle"],
								["RIGHT"] = L["Right"],
							},
						},
						cdFormat = {
							order = 5,
							name = L["CD format"],
							type = "select",
							values = {
								["DEFAULT"] = [[(10m |TInterface\FriendsFrame\StatusIcon-Away:16|t)]],
								["DEFAULT_ICONFIRST"] = [[( |TInterface\FriendsFrame\StatusIcon-Away:16|t10m)]],
							},
						},
						HSplace = {
							type = "toggle",
							order = 6,
							name = L["Hearthstone Location"],
							desc = L["Show the name on location your Hearthstone is bound to."],
						},
						showHearthstones = {
							type = "toggle",
							order = 7,
							name = L["Show hearthstones"],
							desc = L["Show hearthstone type items in the list."],
						},
						hsProprity = F.CreateMovableButtons(22, L["Hearthstone Toys Order"], false, P.locPanel.portals, "hsPrio"),
						showToys = {
							type = "toggle",
							order = 20,
							name = L["Show Toys"],
							desc = L["Show toys in the list. This option will affect all other display options as well."],
						},
						showSpells = {
							type = "toggle",
							order = 30,
							name = L["Show spells"],
							desc = L["Show relocation spells in the list."],
						},
						showEngineer = {
							type = "toggle",
							order = 40,
							name = L["Show engineer gadgets"],
							desc = L["Show items used only by engineers when the profession is learned."],
						},
						ignoreMissingInfo = {
							type = "toggle",
							order = 50,
							name = L["Ignore missing info"],
							desc = L["MER_LOCPANEL_IGNOREMISSINGINFO"],
						},
					},
				},
				fontGroup = {
					order = 23,
					type = "group",
					name = L["Fonts"],
					disabled = function() return not E.db.mui.locPanel.enable end,
					hidden = function() return not E.db.mui.locPanel.enable end,
					get = function(info) return E.db.mui.locPanel[ info[#info] ] end,
					set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; module:Fonts() end,
					args = {
						font = {
							type = "select", dialogControl = "LSM30_Font",
							order = 1,
							name = L["Font"],
							values = LSM:HashTable("font"),
						},
						fontSize = {
							order = 2,
							name = L["Font Size"],
							type = "range",
							min = 6, max = 22, step = 1,
							set = function(info, value) E.db.mui.locPanel[ info[#info] ] = value; module:Fonts(); module:Resize() end,
						},
						fontOutline = {
							order = 3,
							name = L["Font Outline"],
							type = "select",
							values = {
								["NONE"] = L["None"],
								["OUTLINE"] = "OUTLINE",
								["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
								["THICKOUTLINE"] = "THICKOUTLINE",
							},
						},
					},
				},
			},
		},
	},
}
