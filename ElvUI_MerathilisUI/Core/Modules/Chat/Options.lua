local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Chat')
local CB = MER:GetModule('MER_ChatBar')
local CL = MER:GetModule('MER_ChatLink')
local LSM = E.LSM

local _G = _G
local tinsert = table.insert

local function ChatTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.chat = {
		type = "group",
		name = L["Chat"],
		get = function(info) return E.db.mui.chat[ info[#info] ] end,
		set = function(info, value) E.db.mui.chat[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			header = ACH:Header(MER:cOption(L["Chat"], 'orange'), 1),
			chatButton = {
				order = 2,
				type = "toggle",
				name = L["Chat Menu"],
				desc = L["Create a chat button to increase the chat size."],
			},
			hidePlayerBrackets = {
				order = 3,
				type = "toggle",
				name = L["Hide Player Brackets"],
				desc = L["Removes brackets around the person who posts a chat message."],
			},
			hideChat = {
				order = 4,
				type = "toggle",
				name = L["Hide Community Chat"],
				desc = L["Adds an overlay to the Community Chat. Useful for streamers."],
			},
			emotes = {
				order = 5,
				type = "toggle",
				name = L["Emotes"],
			},
			customOnlineMessage = {
				order = 6,
				type = "toggle",
				name = L["Custom Online Message"],
			},
			seperators = {
				order = 10,
				type = "group",
				name = MER:cOption(L["Seperators"], 'orange'),
				guiInline = true,
				get = function(info) return E.db.mui.chat.seperators[ info[#info] ] end,
				set = function(info, value) E.db.mui.chat.seperators[ info[#info] ] = value; end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"]
					},
					visibility = {
						order = 2,
						type = 'select',
						name = L["Visibility"],
						get = function(info) return E.db.mui.chat.seperators[ info[#info] ] end,
						set = function(info, value) E.db.mui.chat.seperators[ info[#info] ] = value; module:UpdateSeperators() end,
						values = {
							HIDEBOTH = L["Hide Both"],
							SHOWBOTH = L["Show Both"],
							LEFT = L["Left Only"],
							RIGHT = L["Right Only"],
						},
					}
				},
			},
			chatFade = {
				order = 15,
				type = "group",
				name = MER:cOption(L["Fade Chat"], 'orange'),
				guiInline = true,
				get = function(info) return E.db.mui.chat.chatFade[ info[#info] ] end,
				set = function(info, value) E.db.mui.chat.chatFade[ info[#info] ] = value; module:Configure_ChatFade() end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					timeout = {
						order = 2,
						type = "range",
						min = 5, max = 60, step = 1,
						name = L["Auto hide timeout"],
						desc = L["Seconds before fading chat panel"],
						disabled = function() return not E.db.mui.chat.chatFade.enable end
					},
					minAlpha = {
						order = 3,
						type = "range",
						min = 0, max = 1, step = 0.01,
						name = L["Min Alpha"],
						disabled = function() return not E.db.mui.chat.chatFade.enable end
					},
					fadeOutTime = {
						order = 4,
						type = "range",
						min = 0.1, max = 2, step = 0.01,
						name = L["Fadeout duration"],
						disabled = function() return not E.db.mui.chat.chatFade.enable end,
					},
				},
			},
			filter = {
				order = 20,
				type = "group",
				name = MER:cOption(L["Filter"], 'orange'),
				guiInline = true,
				get = function(info) return E.db.mui.chat.filter[ info[#info] ] end,
				set = function(info, value) E.db.mui.chat.filter[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					damagemeter = {
						order = 2,
						type = "toggle",
						name = L["Damage Meter Filter"],
						disabled = function() return not E.db.mui.chat.filter.enable end,
					}
				},
			},
			chatBar = {
				order = 30,
				type = "group",
				name = MER:cOption(L["Chat Bar"], 'orange'),
				guiInline = true,
				get = function(info)
					return E.db.mui.chat.chatBar[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.chat.chatBar[info[#info]] = value
					CB:UpdateBar()
				end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						set = function(info, value)
							E.db.mui.chat.chatBar[info[#info]] = value
							CB:ProfileUpdate()
						end
					},
					general = {
						order = 2,
						type = "group",
						inline = true,
						name = L["General"],
						disabled = function()
							return not E.db.mui.chat.chatBar.enable
						end,
						args = {
							autoHide = {
								order = 1,
								type = "toggle",
								name = L["Auto Hide"],
								desc = L["Hide channels not exist."]
							},
							mouseOver = {
								order = 2,
								type = "toggle",
								name = L["Mouse Over"],
								desc = L["Only show chat bar when you mouse over it."]
							},
							orientation = {
								order = 3,
								type = "select",
								name = L["Orientation"],
								values = {
									HORIZONTAL = L["Horizontal"],
									VERTICAL = L["Vertical"]
								}
							}
						}
					},
					backdrop = {
						order = 3,
						type = "group",
						inline = true,
						name = L["Backdrop"],
						disabled = function()
							return not E.db.mui.chat.chatBar.enable
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
								min = 1,
								max = 30,
								step = 1
							}
						}
					},
					button = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Button"],
						disabled = function()
							return not E.db.mui.chat.chatBar.enable
						end,
						args = {
							buttonWidth = {
								order = 1,
								type = "range",
								name = L["Button Width"],
								desc = L["The width of the buttons."],
								min = 2,
								max = 80,
								step = 1
							},
							buttonHeight = {
								order = 2,
								type = "range",
								name = L["Button Height"],
								desc = L["The height of the buttons."],
								min = 2,
								max = 60,
								step = 1
							},
							spacing = {
								order = 3,
								type = "range",
								name = L["Spacing"],
								min = 0,
								max = 80,
								step = 1
							},
							style = {
								order = 4,
								type = "select",
								name = L["Style"],
								values = {
									BLOCK = L["Block"],
									TEXT = L["Text"]
								}
							}
						}
					},
					blockStyle = {
						order = 5,
						type = "group",
						inline = true,
						hidden = function()
							return not (E.db.mui.chat.chatBar.style == "BLOCK")
						end,
						disabled = function()
							return not E.db.mui.chat.chatBar.enable
						end,
						name = L["Style"],
						args = {
							blockShadow = {
								order = 1,
								type = "toggle",
								name = L["Block Shadow"]
							},
							tex = {
								order = 2,
								type = "select",
								name = L["Texture"],
								dialogControl = "LSM30_Statusbar",
								values = LSM:HashTable("statusbar")
							}
						}
					},
					textStyle = {
						order = 6,
						type = "group",
						inline = true,
						disabled = function()
							return not E.db.mui.chat.chatBar.enable
						end,
						hidden = function()
							return not (E.db.mui.chat.chatBar.style == "TEXT")
						end,
						name = L["Style"],
						args = {
							color = {
								order = 1,
								type = "toggle",
								name = L["Use Color"]
							},
							font = {
								type = "group",
								order = 2,
								name = L["Font Setting"],
								get = function(info)
									return E.db.mui.chat.chatBar.font[info[#info]]
								end,
								set = function(info, value)
									E.db.mui.chat.chatBar.font[info[#info]] = value
									CB:UpdateBar()
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
									}
								}
							}
						}
					},
					channels = {
						order = 7,
						type = "group",
						inline = true,
						name = L["Channels"],
						disabled = function()
							return not E.db.mui.chat.chatBar.enable
						end,
						args = {
							world = {
								order = 100,
								type = "group",
								name = L["World"],
								get = function(info)
									return E.db.mui.chat.chatBar.channels.world[info[#info]]
								end,
								set = function(info, value)
									E.db.mui.chat.chatBar.channels.world[info[#info]] = value
									CB:UpdateBar()
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"]
									},
									color = {
										order = 2,
										type = "color",
										name = L["Color"],
										hasAlpha = true,
										get = function(info)
											local colordb = E.db.mui.chat.chatBar.channels.world.color
											local default = P.mui.chat.chatBar.channels.world.color
											return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
										end,
										set = function(info, r, g, b, a)
											E.db.mui.chat.chatBar.channels.world.color = {
												r = r,
												g = g,
												b = b,
												a = a
											}
											CB:UpdateBar()
										end
									},
									abbr = {
										order = 3,
										type = "input",
										hidden = function()
											return not (E.db.mui.chat.chatBar.style == "TEXT")
										end,
										name = L["Abbreviation"]
									},
									name = {
										order = 4,
										type = "input",
										name = L["Channel Name"]
									},
									autoJoin = {
										order = 5,
										type = "toggle",
										name = L["Auto Join"]
									}
								}
							},
							community = {
								order = 101,
								type = "group",
								name = L["Community"],
								get = function(info)
									return E.db.mui.chat.chatBar.channels.community[info[#info]]
								end,
								set = function(info, value)
									E.db.mui.chat.chatBar.channels.community[info[#info]] = value
									CB:UpdateBar()
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"]
									},
									color = {
										order = 2,
										type = "color",
										name = L["Color"],
										hasAlpha = true,
										get = function(info)
											local colordb = E.db.mui.chat.chatBar.channels.community.color
											local default = P.mui.chat.chatBar.channels.community.color
											return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
										end,
										set = function(info, r, g, b, a)
											E.db.mui.chat.chatBar.channels.community.color = {
												r = r,
												g = g,
												b = b,
												a = a
											}
											CB:UpdateBar()
										end
									},
									abbr = {
										order = 3,
										type = "input",
										hidden = function()
											return not (E.db.mui.chat.chatBar.style == "TEXT")
										end,
										name = L["Abbreviation"]
									},
									name = {
										order = 4,
										type = "input",
										name = L["Channel Name"]
									},
									communityDesc = {
										order = 5,
										type = "description",
										width = "full",
										name = L["Please use Blizzard Communities UI add the channel to your main chat frame first."]
									}
								}
							},
							roll = {
								order = 103,
								type = "group",
								name = _G.ROLL,
								get = function(info)
									return E.db.mui.chat.chatBar.channels.roll[info[#info]]
								end,
								set = function(info, value)
									E.db.mui.chat.chatBar.channels.roll[info[#info]] = value
									CB:UpdateBar()
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"]
									},
									color = {
										order = 2,
										type = "color",
										name = L["Color"],
										hasAlpha = true,
										get = function(info)
											local colordb = E.db.mui.chat.chatBar.channels.roll.color
											local default = P.mui.chat.chatBar.channels.roll.color
											return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
										end,
										set = function(info, r, g, b, a)
											E.db.mui.chat.chatBar.channels.roll.color = {
												r = r, g = g, b = b, a = a
											}
											CB:UpdateBar()
										end
									},
									icon = {
										order = 3,
										type = "toggle",
										name = L["Use Icon"],
										desc = L["Use a icon rather than text"],
										hidden = function()
											return not (E.db.mui.chat.chatBar.style == "TEXT")
										end
									},
									abbr = {
										order = 4,
										type = "input",
										hidden = function()
											return not (E.db.mui.chat.chatBar.style == "TEXT")
										end,
										name = L["Abbreviation"]
									}
								}
							}
						},
					},
				},
			},
			chatLink = {
				order = 40,
				type = "group",
				name = E.NewSign..MER:cOption(L["Chat Link"], 'orange'),
				guiInline = true,
				get = function(info)
					return E.db.mui.chat.chatLink[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.chat.chatLink[info[#info]] = value
					CL:ProfileUpdate()
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
								name = L["Add extra information on the link, so that you can get basic information but do not need to click"],
								fontSize = "medium"
							}
						}
					},
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"]
					},
					general = {
						order = 2,
						type = "group",
						inline = true,
						name = L["Additional Information"],
						disabled = function()
							return not E.db.mui.chat.chatLink.enable
						end,
						args = {
							level = {
								order = 1,
								type = "toggle",
								name = L["Level"],
							},
							translateItem = {
								order = 2,
								type = "toggle",
								name = L["Translate Item"],
								desc = L["Translate the name in item links into your language."],
							},
							icon = {
								order = 3,
								type = "toggle",
								name = L["Icon"],
							},
							armorCategory = {
								order = 4,
								type = "toggle",
								name = L["Armor Category"],
							},
							weaponCategory = {
								order = 5,
								type = "toggle",
								name = L["Weapon Category"],
							},
						},
					},
				},
			},
		},
	}

	local channels = {"SAY", "YELL", "EMOTE", "PARTY", "INSTANCE", "RAID", "RAID_WARNING", "GUILD", "OFFICER"}

	for index, name in ipairs(channels) do
		E.Options.args.mui.args.modules.args.chat.args.chatBar.args.channels.args[name] = {
			order = index,
			type = "group",
			name = _G[name],
			get = function(info)
				return E.db.mui.chat.chatBar.channels[name][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.chat.chatBar.channels[name][info[#info]] = value
				CB:UpdateBar()
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"]
				},
				color = {
					order = 2,
					type = "color",
					name = L["Color"],
					hasAlpha = true,
					get = function(info)
						local colordb = E.db.mui.chat.chatBar.channels[name].color
						local default = P.mui.chat.chatBar.channels[name].color
						return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						E.db.mui.chat.chatBar.channels[name].color = {
							r = r,
							g = g,
							b = b,
							a = a
						}
						CB:UpdateBar()
					end
				},
				abbr = {
					order = 3,
					type = "input",
					hidden = function()
						return not (E.db.mui.chat.chatBar.style == "TEXT")
					end,
					name = L["Abbreviation"]
				}
			}
		}
	end
end

tinsert(MER.Config, ChatTable)
