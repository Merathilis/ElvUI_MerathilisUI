local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MM = MER:GetModule('MER_Minimap')
local MP = MER:GetModule('MER_MiniMapPing')
local SMB = MER:GetModule('MER_MiniMapButtons')
local RM = MER:GetModule('MER_RectangleMinimap')
local WM = MER:GetModule('MER_WorldMap')
local options = MER.options.modules.args
local LSM = E.LSM

local _G = _G
local format = string.format

local envs = {
	superTracker = {
		inputCommand = nil,
		selectedCommand = nil
	}
}

options.maps = {
	type = "group",
	name = L["Maps"],
	get = function(info) return E.db.mui.maps.minimap[ info[#info] ] end,
	set = function(info, value) E.db.mui.maps.minimap[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
	disabled = function() return not E.private.general.minimap.enable end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Maps"], 'orange'),
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			args = {
				flash = {
					order = 1,
					type = "toggle",
					name = L["Blinking Minimap"],
					desc = L["Enable the blinking animation for new mail or pending invites."],
				},
			},
		},
		worldMap = {
			order = 4,
			type = "group",
			name = L["World Map"],
			get = function(info) return E.db.mui.maps.worldMap[info[#info]] end,
			set = function(info, value) E.db.mui.maps.worldMap[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			args = {
				desc = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						feature = {
							order = 1,
							type = "description",
							name = function()
								if WM.StopRunning then
									return format(
										"|cffff3860" .. L["Because of %s, this module will not be loaded."] .. "|r",
										WM.StopRunning
									)
								else
									return L["This module will help you to reveal and resize maps."]
								end
							end,
							fontSize = "medium"
						}
					}
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"]
				},
				reveal = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Reveal"],
					get = function(info)
						return E.db.mui.maps.worldMap.reveal[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.maps.worldMap.reveal[info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Remove Fog of War from your world map."]
						},
						useColor = {
							order = 2,
							type = "toggle",
							name = L["Use Colored Fog"],
							disabled = function()
								return not E.db.mui.maps.worldMap.reveal.enable
							end,
							desc = L["Style Fog of War with special color."]
						},
						color = {
							order = 3,
							type = "color",
							hasAlpha = true,
							name = L["Color"],
							disabled = function()
								return not E.db.mui.maps.worldMap.reveal.useColor or
									not E.db.mui.maps.worldMap.reveal.enable
							end,
							get = function(info)
								local db = E.db.mui.maps.worldMap.reveal[info[#info]]
								local default = P.maps.worldMap.reveal[info[#info]]
								return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
							end,
							set = function(info, r, g, b, a)
								local db = E.db.mui.maps.worldMap.reveal[info[#info]]
								db.r, db.g, db.b, db.a = r, g, b, a
								E:StaticPopup_Show("PRIVATE_RL")
							end
						}
					}
				},
				scale = {
					order = 4,
					type = "group",
					name = L["Scale"],
					get = function(info) return E.db.mui.maps.worldMap.scale[info[#info]] end,
					set = function(info, value) E.db.mui.maps.worldMap.scale[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					hidden = not E.Retail,
					guiInline = true,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Resize world map."]
						},
						size = {
							order = 2,
							type = "range",
							name = L["Size"],
							min = 0.1,
							max = 3,
							step = 0.01
						},
					},
				},
			},
		},
		ping = {
			order = 4,
			type = "group",
			name = L["Minimap Ping"],
			get = function(info) return E.db.mui.maps.minimap.ping[ info[#info] ] end,
			set = function(info, value) E.db.mui.maps.minimap.ping[ info[#info] ] = value; MP:ProfileUpdate(); end,
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
								local default = P.maps.minimap.ping[info[#info]]
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
		rectangleMinimap = {
			order = 5,
			type = "group",
			name = L["Rectangle Minimap"],
			get = function(info)
				return E.db.mui.maps.rectangleMinimap[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.maps.rectangleMinimap[info[#info]] = value
				RM:ChangeShape()
			end,
			args = {
				desc = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						feature = {
							order = 1,
							type = "description",
							name = L["Change the shape of ElvUI minimap."],
							fontSize = "medium"
						}
					}
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					width = "full"
				},
				heightPercentage = {
					order = 3,
					type = "range",
					name = L["Height Percentage"],
					desc = L["Percentage of ElvUI minimap size."],
					min = 0.01, max = 1, step = 0.01
				},
			},
		},
		smb = {
			order = 6,
			type = "group",
			name = L["Minimap Buttons"],
			get = function(info) return E.db.mui.smb[ info[#info] ] end,
			set = function(info, value) E.db.mui.smb[ info[#info] ] = value; SMB:Update() end,
			args = {
				desc = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						feature = {
							order = 1,
							type = "description",
							name = L["Add an extra bar to collect minimap buttons."],
							fontSize = "medium"
						}
					}
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					desc = L["Toggle minimap buttons bar."],
					get = function(info)
						return E.db.mui.smb[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.smb[info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end
				},
				mouseOver = {
					order = 3,
					type = "toggle",
					name = L["Mouse Over"],
					desc = L["Only show minimap buttons bar when you mouse over it."],
					get = function(info)
						return E.db.mui.smb[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.smb[info[#info]] = value
						SMB:UpdateMouseOverConfig()
					end
				},
				barConfig = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Minimap Buttons Bar"],
					get = function(info)
						return E.db.mui.smb[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.smb[info[#info]] = value
						SMB:UpdateLayout()
					end,
					args = {
						backdrop = {
							order = 1,
							type = "toggle",
							name = L["Bar Backdrop"],
							desc = L["Show a backdrop of the bar."]
						},
						backdropSpacing = {
							order = 2,
							type = "range",
							name = L["Backdrop Spacing"],
							desc = L["The spacing between the backdrop and the buttons."],
							min = 0,
							max = 30,
							step = 1
						},
						inverseDirection = {
							order = 3,
							type = "toggle",
							name = L["Inverse Direction"],
							desc = L["Reverse the direction of adding buttons."]
						},
						orientation = {
							order = 4,
							type = "select",
							name = L["Orientation"],
							desc = L["Arrangement direction of the bar."],
							values = {
								NOANCHOR = L["Drag"],
								HORIZONTAL = L["Horizontal"],
								VERTICAL = L["Vertical"]
							},
							set = function(info, value)
								E.db.mui.smb[info[#info]] = value
								if value == "NOANCHOR" and E.db.mui.smb.calendar then
									E:StaticPopup_Show("PRIVATE_RL")
								else
									SMB:UpdateLayout()
								end
							end
						}
					}
				},
				buttonsConfig = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Buttons"],
					get = function(info)
						return E.db.mui.smb[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.smb[info[#info]] = value
						SMB:UpdateLayout()
					end,
					args = {
						buttonsPerRow = {
							order = 1,
							type = "range",
							name = L["Buttons Per Row"],
							desc = L["The amount of buttons to display per row."],
							min = 1,
							max = 30,
							step = 1
						},
						buttonSize = {
							order = 2,
							type = "range",
							name = L["Button Size"],
							desc = L["The size of the buttons."],
							get = function(info)
								return E.db.mui.smb[info[#info]]
							end,
							set = function(info, value)
								E.db.mui.smb[info[#info]] = value
								SMB:SkinMinimapButtons()
							end,
							min = 15,
							max = 60,
							step = 1
						},
						spacing = {
							order = 3,
							type = "range",
							name = L["Button Spacing"],
							desc = L["The spacing between buttons."],
							min = 0,
							max = 30,
							step = 1
						},
					},
				},
				blizzardButtonsConfig = {
					order = 6,
					type = "group",
					inline = true,
					name = L["Blizzard Buttons"],
					get = function(info)
						return E.db.mui.smb[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.smb[info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					args = {
						expansionLandingPage = {
							order = 1,
							type = "toggle",
							name = L["Expansion Landing Page"],
							desc = L["Add garrison button to the bar."]
						},
					},
				},
			},
		},
		superTracker = {
			order = 7,
			type = "group",
			name = L["Super Tracker"],
			hidden = not E.Retail,
			get = function(info)
				return E.db.mui.maps.superTracker[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.maps.superTracker[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				desc = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						feature = {
							order = 1,
							type = "description",
							name = L["Additional features for waypoint."],
							fontSize = "medium"
						}
					}
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					width = "full"
				},
				general = {
					order = 3,
					type = "group",
					inline = true,
					name = L["General"],
					args = {
						autoTrackWaypoint = {
							order = 1,
							type = "toggle",
							name = L["Auto Track Waypoint"],
							desc = L["Auto track the waypoint after setting."],
							width = 1.5,
						},
						middleClickToClear = {
							order = 2,
							type = "toggle",
							name = L["Middle Click To Clear"],
							desc = L["Middle click the waypoint to clear it."],
							width = 1.5,
						},
						noLimit = {
							order = 3,
							type = "toggle",
							name = L["No Distance Limitation"],
							desc = L["Force to track the target even if it over 1000 yds."],
							width = 1.5,
						}
					}
				},
				distanceText = {
					order = 4,
					type = "group",
					name = L["Distance Text"],
					inline = true,
					get = function(info)
						return E.db.mui.maps.superTracker.distanceText[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.maps.superTracker.distanceText[info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
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
						color = {
							order = 4,
							type = "color",
							name = L["Color"],
							get = function(info)
								local db = E.db.mui.maps.superTracker.distanceText[info[#info]]
								local default = P.maps.superTracker.distanceText[info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b, a)
								local db = E.db.mui.maps.superTracker.distanceText[info[#info]]
								db.r, db.g, db.b, db.a = r, g, b, nil
								E:StaticPopup_Show("PRIVATE_RL")
							end,
						},
					},
				},
				waypointParse = {
					order = 5,
					type = "group",
					name = L["Waypoint Parse"],
					inline = true,
					get = function(info)
						return E.db.mui.maps.superTracker.waypointParse[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.maps.superTracker.waypointParse[info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"]
						},
						worldMapInput = {
							order = 2,
							type = "toggle",
							name = L["Input Box"],
							desc = L["Add a input box to the world map."]
						},
						command = {
							order = 3,
							type = "toggle",
							name = L["Command"],
							desc = L["Enable to use the command to set the waypoint."]
						},
						virtualTomTom = {
							order = 4,
							type = "toggle",
							name = L["Virtual TomTom"],
							desc = L["Support TomTom-style /way command without TomTom."],
							hidden = function()
								return not E.db.mui.maps.superTracker.waypointParse.command
							end
						},
						commandConfiguration = {
							order = 5,
							type = "group",
							name = L["Command Configuration"],
							hidden = function()
								return not E.db.mui.maps.superTracker.waypointParse.command
							end,
							args = {
								commandInput = {
									order = 1,
									type = "input",
									name = L["New Command"],
									desc = L["The command to set a waypoint."],
									get = function(info)
										return envs.superTracker.inputCommand
									end,
									set = function(info, value)
										envs.superTracker.inputCommand = value
									end
								},
								addCommand = {
									order = 2,
									type = "execute",
									name = L["Add Command"],
									disabled = function()
										return not envs.superTracker.inputCommand
									end,
									func = function()
										if not envs.superTracker.inputCommand then
											return
										end

										E.db.mui.maps.superTracker.waypointParse.commandKeys[envs.superTracker.inputCommand] = true
										E:StaticPopup_Show("PRIVATE_RL")
									end
								},
								betterAlign = {
									order = 3,
									type = "description",
									name = " ",
									width = "full"
								},
								commandList = {
									order = 4,
									type = "select",
									name = L["Command List"],
									values = function()
										local keys = {}
										for k, _ in pairs(E.db.mui.maps.superTracker.waypointParse.commandKeys) do
											keys[k] = k
										end
										return keys
									end,
									get = function(info)
										return envs.superTracker.selectedCommand
									end,
									set = function(info, value)
										envs.superTracker.selectedCommand = value
									end
								},
								deleteCommand = {
									order = 5,
									type = "execute",
									name = L["Delete Command"],
									desc = L["Delete the selected command."],
									confirm = function()
										return format(
											L["Are you sure to delete the %s command?"],
											F.CreateColorString(envs.superTracker.selectedCommand, E.db.general.valuecolor)
										)
									end,
									disabled = function()
										return not envs.superTracker.selectedCommand
									end,
									func = function()
										if not envs.superTracker.selectedCommand then
											return
										end

										E.db.mui.maps.superTracker.waypointParse.commandKeys[envs.superTracker.selectedCommand] = nil
										E:StaticPopup_Show("PRIVATE_RL")
									end
								},
							},
						},
					},
				},
			},
		},
		instanceDifficulty = {
			order = 6,
			type = "group",
			name = L["Instance Difficulty"],
			get = function(info)
				return E.db.mui.maps.instanceDifficulty[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.maps.instanceDifficulty[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				desc = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						feature = {
							order = 1,
							type = "description",
							name = L["Reskin the instance diffculty in text style."],
							fontSize = "medium"
						}
					}
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"]
				},
				align = {
					order = 3,
					type = "select",
					name = L["Text Align"],
					values = {
						LEFT = L["Left"],
						CENTER = L["Center"],
						RIGHT = L["Right"]
					}
				},
				hideBlizzard = {
					order = 4,
					type = "toggle",
					name = L["Hide Blizzard Indicator"]
				},
				font = {
					order = 5,
					type = "group",
					name = L["Font"],
					inline = true,
					get = function(info)
						return E.db.mui.maps.instanceDifficulty.font[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.maps.instanceDifficulty.font[info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
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
	},
}
