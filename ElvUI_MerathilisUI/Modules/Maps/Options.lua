local MER, E, L, V, P, G = unpack(select(2, ...))
local MM = MER:GetModule('MER_Minimap')
local SMB = MER:GetModule('MER_MiniMapButtons')
local COMP = MER:GetModule('MER_Compatibility')
local LSM = E.LSM

--Cache global variables
--Lua functions
local format = string.format
local tinsert = table.insert
--WoW API / Variables
local C_Texture_GetAtlasInfo = C_Texture.GetAtlasInfo
-- GLOBALS:

local function Minimap()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.minimap = {
		type = "group",
		name = L["MiniMap"],
		get = function(info) return E.db.mui.maps.minimap[ info[#info] ] end,
		set = function(info, value) E.db.mui.maps.minimap[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		disabled = function() return not E.private.general.minimap.enable end,
		args = {
			header = ACH:Header(MER:cOption(L["MiniMap"]), 1),
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
						name = L["Instance Difficulty"],
					},
					rectangle = {
						order = 3,
						type = "toggle",
						name = L["Rectangle Minimap"],
						desc = L["|cffFF0000WARNING:|r If you enable this, you must adjust your Interface manually."],
					},
				},
			},
			ping = {
				order = 3,
				type = "group",
				name = MER:cOption(L["Minimap Ping"]),
				guiInline = true,
				get = function(info) return E.db.mui.maps.minimap.ping[ info[#info] ] end,
				set = function(info, value) E.db.mui.maps.minimap.ping[ info[#info] ] = value; MM:UpdatePing(); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						width = "full",
					},
					general = {
						order = 3,
						type = "group",
						inline = true,
						name = L["General"],
						args = {
							addRealm = {
								order = 1,
								type = "toggle",
								name = L["Add Server Name"]
							},
							onlyInCombat = {
								order = 2,
								type = "toggle",
								name = L["Only In Combat"]
							}
						}
					},
					position = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Position"],
						args = {
							xOffset = {
								order = 1,
								type = "range",
								name = L["X-Offset"],
								min = -200,
								max = 200,
								step = 1
							},
							yOffset = {
								order = 2,
								type = "range",
								name = L["Y-Offset"],
								min = -200,
								max = 200,
								step = 1
							}
						}
					},
					animation = {
						order = 5,
						type = "group",
						inline = true,
						name = L["Animation"],
						args = {
							fadeInTime = {
								order = 1,
								type = "range",
								name = L["Fade-In"],
								desc = L["The time of animation. Set 0 to disable animation."],
								min = 0,
								max = 5,
								step = 0.1
							},
							stayTime = {
								order = 2,
								type = "range",
								name = L["Duration"],
								desc = L["The time of animation. Set 0 to disable animation."],
								min = 0,
								max = 10,
								step = 0.1
							},
							fadeOutTime = {
								order = 3,
								type = "range",
								name = L["Fade Out"],
								desc = L["The time of animation. Set 0 to disable animation."],
								min = 0,
								max = 5,
								step = 0.1
							}
						}
					},
					color = {
						order = 6,
						type = "group",
						inline = true,
						name = L["Color"],
						args = {
							classColor = {
								order = 1,
								type = "toggle",
								name = L["Use Class Color"]
							},
							customColor = {
								order = 2,
								type = "color",
								name = L["Custom Color"],
								get = function(info)
									local db = E.db.mui.maps.minimap.ping[info[#info]]
									local default = P.mui.maps.minimap.ping[info[#info]]
									return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
								end,
								set = function(info, r, g, b, a)
									local db = E.db.mui.maps.minimap.ping[info[#info]]
									db.r, db.g, db.b, db.a = r, g, b, nil
								end
							}
						}
					},
					font = {
						order = 7,
						type = "group",
						inline = true,
						name = L["Font"],
						get = function(info)
							return E.db.mui.maps.minimap.ping.font[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.maps.minimap.ping.font[info[#info]] = value
							MM:UpdatePing()
						end,
						args = {
							name = {
								order = 1,
								type = "select",
								dialogControl = "LSM30_Font",
								name = L["Font"],
								values = LSM:HashTable("font")
							},
							style = {
								order = 2,
								type = "select",
								name = L["Outline"],
								values = {
									NONE = L["None"],
									OUTLINE = L["OUTLINE"],
									MONOCHROME = L["MONOCHROME"],
									MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
									THICKOUTLINE = L["THICKOUTLINE"]
								}
							},
							size = {
								order = 3,
								name = L["Size"],
								type = "range",
								min = 5,
								max = 60,
								step = 1
							},
						},
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
				set = function(info, value) E.db.mui.smb[ info[#info] ] = value; SMB:Update() end,
				disabled = function() return (COMP.PA and _G.ProjectAzilroka.db.SquareMinimapButtons.Enable) end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						width = "full",
						get = function(info) return E.db.mui.smb.enable end,
						set = function(info, value) E.db.mui.smb.enable = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					credits = {
						order = 2,
						type = "group",
						name = L["Credits"],
						guiInline = true,
						args = {
							credit = ACH:Description(format("|cFF16C3F2Project|r|cFFFFFFFFAzilroka|r"), 1),
						},
					},
					minimapButtons = {
						order = 3,
						type = "group",
						name = L["Button Settings"],
						guiInline = true,
						args = {
							size = {
								order = 1,
								type = "range",
								name = L["Button Size"],
								min = 20, max = 36, step = 1,
								disabled = function() return not E.db.mui.smb.enable end,
							},
							perRow = {
								order = 2,
								type = "range",
								name = L["Buttons Per Row"],
								min = 1, max = 100, step = 1,
								disabled = function() return not E.db.mui.smb.enable end,
							},
							spacing = {
								order = 3,
								type = "range",
								name = L["Button Spacing"],
								min = 0, max = 10, step = 1,
								disabled = function() return not E.db.mui.smb.enable end,
							},
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, Minimap)
