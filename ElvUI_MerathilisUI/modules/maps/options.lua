local MER, E, L, V, P, G = unpack(select(2, ...))
local MM = MER:GetModule("mUIMinimap")
local SMB = MER:GetModule("mUIMinimapButtons")

local COMP = MER:GetModule("mUICompatibility")

local function Minimap()
	E.Options.args.mui.args.modules.args.minimap = {
		type = "group",
		name = MINIMAP_LABEL,
		order = 16,
		get = function(info) return E.db.mui.maps.minimap[ info[#info] ] end,
		set = function(info, value) E.db.mui.maps.minimap[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		disabled = function() return not E.private.general.minimap.enable end,
		args = {
			header1 = {
				type = "header",
				name = MER:cOption(MINIMAP_LABEL),
				order = 1,
			},
			general = {
				order = 2,
				type = "group",
				name = MER:cOption(L["General"]),
				guiInline = true,
				args = {
					flash = {
						order = 1,
						type = "toggle",
						name = L["Blinking Minimap"],
						desc = L["Enable the blinking animation for new mail or pending invites."],
					},
				},
			},
			ping = {
				order = 3,
				type = "group",
				name = MER:cOption(L["Minimap Ping"]),
				guiInline = true,
				get = function(info) return E.db.mui.maps.minimap.ping[ info[#info] ] end,
				set = function(info, value) E.db.mui.maps.minimap.ping[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						width = "full",
					},
					position = {
						order = 2,
						type = "select",
						name = L["Position"],
						values = {
							["TOP"] = L["Top"],
							["BOTTOM"] = L["Bottom"],
							["LEFT"] = L["Left"],
							["RIGHT"] = L["Right"],
							["CENTER"] = L["Center"],
						},
						disabled = function() return not  E.db.mui.maps.minimap.ping.enable end,
					},
					xOffset = {
						order = 6,
						type = "range",
						name = L["X-Offset"],
						min = -50, max = 50, step = 1,
						disabled = function() return not  E.db.mui.maps.minimap.ping.enable end,
					},
					yOffset = {
						order = 7,
						type = "range",
						name = L["Y-Offset"],
						min = -50, max = 50, step = 1,
						disabled = function() return not  E.db.mui.maps.minimap.ping.enable end,
					},
				},
			},
			coords = {
				order = 4,
				type = "group",
				name = MER:cOption(L["Coordinates"]),
				guiInline = true,
				get = function(info) return E.db.mui.maps.minimap.coords[ info[#info] ] end,
				set = function(info, value) E.db.mui.maps.minimap.coords[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					position = {
						order = 2,
						type = "select",
						name = L["Position"],
						values = {
							["TOP"] = L["Top"],
							["BOTTOM"] = L["Bottom"],
							["LEFT"] = L["Left"],
							["RIGHT"] = L["Right"],
							["CENTER"] = L["Center"],
						},
						disabled = function() return not  E.db.mui.maps.minimap.coords.enable end,
					},
				},
			},
			smb = {
				order = 5,
				type = "group",
				name = MER:cOption(SMB.modName),
				guiInline = true,
				get = function(info) return E.db.mui.smb[ info[#info] ] end,
				set = function(info, value) E.db.mui.smb[ info[#info] ] = value; SMB:Update(); end,
				disabled = function() return (COMP.PA and _G.ProjectAzilroka.db.SMB == true or COMP.SLE and E.private.sle.minimap.mapicons.enable) end,
				args = {
					credits = {
						order = 1,
						type = "group",
						name = MER:cOption(L["Credits"]),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = "description",
								fontSize = "medium",
								name = format("|cFF16C3F2Project|r|cFFFFFFFFAzilroka|r"),
							},
						},
					},
					enable = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
						get = function(info) return E.db.mui.smb.enable end,
						set = function(info, value) E.db.mui.smb.enable = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					barMouseOver = {
						order = 3,
						type = "toggle",
						name = L["MouseOver"],
					},
					backdrop = {
						order = 4,
						type = "toggle",
						name = L["Bar Backdrop"],
					},
					iconSize = {
						order = 5,
						type = "range",
						name = L["Icon Size"],
						min = 12, max = 48, step = 1,
					},
					buttonSpacing = {
						order = 6,
						type = "range",
						name = L["Button Spacing"],
						min = 0, max = 10, step = 1,
					},
					buttonsPerRow = {
						order = 7,
						type = "range",
						name = L["Buttons Per Row"],
						min = 1, max = 12, step = 1,
					},
					blizzard = {
						order = 8,
						type = "group",
						name = L['Blizzard'],
						guiInline = true,
						set = function(info, value) E.db.mui.smb[ info[#info] ] = value SMB:Update() SMB:HandleBlizzardButtons() end,
						args = {
							hideGarrison  = {
								order = 1,
								type = "toggle",
								name = L["Hide Garrison"],
								disabled = function() return E.db.mui.smb.moveGarrison end,
							},
							moveGarrison  = {
								order = 2,
								type = 'toggle',
								name = L['Move Garrison Icon'],
								disabled = function() return E.db.mui.smb.hideGarrison end,
							},
							moveTracker  = {
								order = 3,
								type = 'toggle',
								name = L['Move Tracker Icon'],
							},
							moveQueue  = {
								order = 4,
								type = 'toggle',
								name = L['Move Queue Status Icon'],
							},
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, Minimap)