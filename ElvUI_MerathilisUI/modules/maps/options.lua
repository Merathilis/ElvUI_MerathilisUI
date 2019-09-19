local MER, E, L, V, P, G = unpack(select(2, ...))
local SMB = MER:GetModule("mUIMinimapButtons")
local COMP = MER:GetModule("mUICompatibility")

--Cache global variables
--Lua functions
local format = string.format
local tinsert = table.insert
--WoW API / Variables
-- GLOBALS:

local function Minimap()
	E.Options.args.mui.args.modules.args.minimap = {
		type = "group",
		name = E.NewSign..L["MiniMap"],
		order = 16,
		get = function(info) return E.db.mui.maps.minimap[ info[#info] ] end,
		set = function(info, value) E.db.mui.maps.minimap[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		disabled = function() return not E.private.general.minimap.enable end,
		args = {
			header1 = {
				type = "header",
				name = MER:cOption(L["MiniMap"]),
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
					difficulty = {
						order = 2,
						type = "toggle",
						name = E.NewSign..L["Instance Difficulty"],
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
						disabled = function() return not E.db.mui.maps.minimap.ping.enable end,
					},
					xOffset = {
						order = 6,
						type = "range",
						name = L["X-Offset"],
						min = -50, max = 50, step = 1,
						disabled = function() return not E.db.mui.maps.minimap.ping.enable end,
					},
					yOffset = {
						order = 7,
						type = "range",
						name = L["Y-Offset"],
						min = -50, max = 50, step = 1,
						disabled = function() return not E.db.mui.maps.minimap.ping.enable end,
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
						disabled = function() return not E.db.mui.maps.minimap.coords.enable end,
					},
				},
			},
			smb = {
				order = 5,
				type = "group",
				name = MER:cOption(L["Minimap Buttons"]),
				guiInline = true,
				get = function(info) return E.db.mui.smb[ info[#info] ] end,
				set = function(info, value) E.db.mui.smb[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				disabled = function() return (COMP.PA and _G.ProjectAzilroka.db.SMB == true or COMP.SLE and E.private.sle.minimap.mapicons.enable) end,
				args = {
					credits = {
						order = 1,
						type = "group",
						name = L["Credits"],
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = "description",
								fontSize = "medium",
								name = format("|cff0080ffNDui|r - siweia"),
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
					position = {
						order = 2,
						type = "select",
						name = L["Position"],
						values = {
							["BOTTOMLEFT"] = L["Bottom Left"],
							["BOTTOMRIGHT"] = L["Bottom Right"],
							["TOPLEFT"] = L["Top Left"],
							["TOPRIGHT"] = L["Top Right"],
						},
						disabled = function() return not E.db.mui.smb.enable end,
					},
					size = {
						order = 2,
						type = "range",
						name = L["Icon Size"],
						min = 20, max = 36, step = 1,
						disabled = function() return not E.db.mui.smb.enable end,
					},
					xOffset = {
						order = 6,
						type = "range",
						name = L["X-Offset"],
						min = -20, max = 20, step = 1,
						disabled = function() return not E.db.mui.smb.enable end,
					},
					yOffset = {
						order = 7,
						type = "range",
						name = L["Y-Offset"],
						min = -20, max = 20, step = 1,
						disabled = function() return not E.db.mui.smb.enable end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, Minimap)
