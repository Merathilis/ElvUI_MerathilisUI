local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

local options = module.options.modules.args

-- The Minimap button bars share one anchor/size/spacing block. getBar() returns
-- the settings table of the bar the block belongs to; the toggles above it keep
-- the group's own get/set, so the block brings its own.
local function AddMinimapBarLayout(args, getBar)
	local function get(info)
		return getBar()[info[#info]]
	end

	local function set(info, value)
		getBar()[info[#info]] = value
		F.Event.TriggerEvent("MinimapButtons.SettingsUpdate")
	end

	local layout = {
		layoutSpacer = {
			order = 20,
			type = "description",
			name = "",
		},
		point = {
			order = 21,
			type = "select",
			name = L["Anchor Point"],
			get = get,
			set = set,
			values = {
				TOPLEFT = L["Top Left"],
				TOP = L["Top"],
				TOPRIGHT = L["Top Right"],
				LEFT = L["Left"],
				RIGHT = L["Right"],
				BOTTOMLEFT = L["Bottom Left"],
				BOTTOM = L["Bottom"],
				BOTTOMRIGHT = L["Bottom Right"],
			},
		},
		growth = {
			order = 22,
			type = "select",
			name = L["Growth Direction"],
			desc = L["Which way the bar extends as buttons are added."],
			get = get,
			set = set,
			values = {
				DOWN = L["Down"],
				UP = L["Up"],
				LEFT = L["Left"],
				RIGHT = L["Right"],
			},
		},
		size = {
			order = 23,
			type = "range",
			name = L["Size"],
			get = get,
			set = set,
			min = 14,
			max = 40,
			step = 1,
		},
		spacing = {
			order = 24,
			type = "range",
			name = L["Spacing"],
			get = get,
			set = set,
			min = 0,
			max = 20,
			step = 1,
		},
		xOffset = {
			order = 25,
			type = "range",
			name = L["X-Offset"],
			get = get,
			set = set,
			min = -100,
			max = 100,
			step = 1,
		},
		yOffset = {
			order = 26,
			type = "range",
			name = L["Y-Offset"],
			get = get,
			set = set,
			min = -100,
			max = 100,
			step = 1,
		},
	}

	for key, option in pairs(layout) do
		args[key] = option
	end

	return args
end

local function MainBarDB()
	return E.db.mui.minimapButtons
end

local function ElementBarDB()
	return E.db.mui.minimapButtons.elements
end

options.maps = {
	type = "group",
	name = module:AddCategorieIcon(L["Maps"], "maps"),
	args = {
		header = {
			order = 0,
			type = "header",
			name = L["Maps"],
		},
		locationPanel = {
			order = 1,
			type = "group",
			guiInline = true,
			name = L["Location Panel"],
			get = function(info)
				return E.db.mui.locationPanel[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.locationPanel[info[#info]] = value
				F.Event.TriggerEvent("LocationPanel.SettingsUpdate")
			end,
			disabled = function()
				return not E.private.general.minimap.enable
			end,
			args = {
				desc = {
					order = 0,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						feature = {
							order = 1,
							type = "description",
							name = L["Shows the current zone in a panel above your Minimap. Click it to open the World Map."],
							fontSize = "medium",
						},
					},
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					set = function(info, value)
						E.db.mui.locationPanel[info[#info]] = value
						F.Event.TriggerEvent("LocationPanel.DatabaseUpdate")
					end,
				},
				clusterDisable = {
					order = 2,
					type = "toggle",
					name = L["Disable ElvUI Cluster"],
					desc = L["ElvUI's Minimap Cluster shows the zone text and the clock above the Minimap. Disable it so it does not overlap the panel."],
					get = function()
						return E.db.general.minimap.clusterDisable
					end,
					set = function(_, value)
						E.db.general.minimap.clusterDisable = value
						E:GetModule("Minimap"):UpdateSettings()
						E:StaticPopup_Show("PRIVATE_RL")
					end,
				},
				hideLocationText = {
					order = 2.5,
					type = "toggle",
					name = L["Hide ElvUI Location Text"],
					desc = L["Hides the zone text ElvUI shows on the Minimap, the panel shows it already."],
					get = function()
						return E.db.general.minimap.locationText == "HIDE"
					end,
					set = function(_, value)
						E.db.general.minimap.locationText = value and "HIDE" or "MOUSEOVER"
						E:GetModule("Minimap"):UpdateSettings()
					end,
				},
				spacer = {
					order = 4,
					type = "description",
					name = "",
				},
				height = {
					order = 5,
					type = "range",
					name = L["Height"],
					min = 14,
					max = 40,
					step = 1,
				},
				spacing = {
					order = 6,
					type = "range",
					name = L["Spacing"],
					desc = L["Gap between the panel and the Minimap."],
					min = 0,
					max = 20,
					step = 1,
				},
				textMode = {
					order = 7,
					type = "select",
					name = L["Text"],
					values = {
						MINIMAP = L["Minimap Zone Text"],
						ZONE = L["Zone"],
						ZONE_SUBZONE = L["Zone and Subzone"],
					},
				},
				colorMode = {
					order = 8,
					type = "select",
					name = L["Text Color"],
					values = {
						PVP = L["Zone PvP Status"],
						CLASS = L["Class Color"],
						CUSTOM = L["Custom Color"],
					},
				},
				customColor = {
					order = 9,
					type = "color",
					name = L["Custom Color"],
					hasAlpha = false,
					hidden = function()
						return E.db.mui.locationPanel.colorMode ~= "CUSTOM"
					end,
					get = function(info)
						local db = E.db.mui.locationPanel[info[#info]]
						local default = P.locationPanel[info[#info]]
						return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
					end,
					set = function(info, r, g, b)
						local db = E.db.mui.locationPanel[info[#info]]
						db.r, db.g, db.b = r, g, b
						F.Event.TriggerEvent("LocationPanel.SettingsUpdate")
					end,
				},
				coordsGroup = {
					order = 10,
					type = "group",
					inline = true,
					name = L["Coordinates"],
					args = {
						coords = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Shows your X coordinate left and your Y coordinate right of the zone text."],
						},
						coordsFormat = {
							order = 2,
							type = "select",
							name = L["Format"],
							values = {
								["%.0f"] = "45",
								["%.1f"] = "45.3",
								["%.2f"] = "45.27",
							},
							disabled = function()
								return not E.db.mui.locationPanel.coords
							end,
						},
						coordsColor = {
							order = 3,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							disabled = function()
								return not E.db.mui.locationPanel.coords
							end,
							get = function(info)
								local db = E.db.mui.locationPanel[info[#info]]
								local default = P.locationPanel[info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.mui.locationPanel[info[#info]]
								db.r, db.g, db.b = r, g, b
								F.Event.TriggerEvent("LocationPanel.SettingsUpdate")
							end,
						},
					},
				},
				font = {
					order = 11,
					type = "group",
					inline = true,
					name = L["Font"],
					get = function(info)
						return E.db.mui.locationPanel.font[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.locationPanel.font[info[#info]] = value
						F.Event.TriggerEvent("LocationPanel.SettingsUpdate")
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
							order = 2,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 40,
							step = 1,
						},
						style = {
							order = 3,
							type = "select",
							name = L["Outline"],
							values = MER.Values.FontFlags,
							sortByValue = true,
						},
					},
				},
			},
		},
		minimapButtons = {
			order = 2,
			type = "group",
			guiInline = true,
			name = L["Minimap Buttons"],
			get = function(info)
				return E.db.mui.minimapButtons[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.minimapButtons[info[#info]] = value
				F.Event.TriggerEvent("MinimapButtons.SettingsUpdate")
			end,
			args = {
				desc = {
					order = 0,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						feature = {
							order = 1,
							type = "description",
							name = L["Add a bar of extra buttons next to your Minimap."],
							fontSize = "medium",
						},
					},
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				spacer = {
					order = 2,
					type = "description",
					name = "",
				},
				buttons = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Buttons"],
					get = function(info)
						return E.db.mui.minimapButtons[info[#info]].enable
					end,
					set = function(info, value)
						E.db.mui.minimapButtons[info[#info]].enable = value
						F.Event.TriggerEvent("MinimapButtons.SettingsUpdate")
					end,
					args = AddMinimapBarLayout({
						greatVault = {
							order = 1,
							type = "toggle",
							name = L["Great Vault"],
						},
						mplusPortals = {
							order = 2,
							type = "toggle",
							name = L["M+ Portals"],
						},
						testGreatVaultPulse = {
							order = 3,
							type = "execute",
							name = L["Test Pulse"],
							desc = L["Briefly plays the Great Vault button's pulse animation, even without any unclaimed rewards."],
							func = function()
								MER:GetModule("MER_MinimapButtons"):TestGreatVaultPulse()
							end,
							disabled = function()
								return not E.db.mui.minimapButtons.greatVault.enable
							end,
						},
					}, MainBarDB),
				},
				elements = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Elements"],
					get = function(info)
						return E.db.mui.minimapButtons[info[#info]].enable
					end,
					set = function(info, value)
						E.db.mui.minimapButtons[info[#info]].enable = value
						F.Event.TriggerEvent("MinimapButtons.SettingsUpdate")
					end,
					args = AddMinimapBarLayout({
						elementsDesc = {
							order = 0,
							type = "description",
							name = L["A second bar for the Blizzard indicators, anchored on its own."],
						},
						tracking = {
							order = 1,
							type = "toggle",
							name = L["Tracking"],
							desc = L["Replaces the Blizzard icon on your Minimap with one in this bar."],
						},
						calendar = {
							order = 2,
							type = "toggle",
							name = L["Calendar"],
							desc = L["Replaces the Blizzard icon on your Minimap with one in this bar."]
								.. "\n"
								.. L["The tooltip lists your raid lockouts, the realm time and the weekly reset."],
						},
						addonCompartment = {
							order = 2.5,
							type = "toggle",
							name = L["Addon Compartment"],
							desc = L["Replaces the Blizzard icon on your Minimap with one in this bar."]
								.. "\n"
								.. L["Opens Blizzard's addon list. Hidden while ElvUI's own option hides the addon compartment."],
						},
						mail = {
							order = 3,
							type = "toggle",
							name = L["Mail"],
							desc = L["Replaces the Blizzard icon on your Minimap with one in this bar."]
								.. "\n"
								.. L["Only shown while there is something to report."],
						},
						craftingOrders = {
							order = 4,
							type = "toggle",
							name = L["Crafting Orders"],
							desc = L["Replaces the Blizzard icon on your Minimap with one in this bar."]
								.. "\n"
								.. L["Only shown while there is something to report."],
						},
					}, ElementBarDB),
				},
			},
		},
	},
}
