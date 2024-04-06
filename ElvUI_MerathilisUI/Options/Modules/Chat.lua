local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args
local module = MER:GetModule("MER_Chat")
local CH = E:GetModule("Chat")
local CB = MER:GetModule("MER_ChatBar")
local CL = MER:GetModule("MER_ChatLink")
local CT = MER:GetModule("MER_ChatText")
local CF = MER:GetModule("MER_ChatFade")
local LSM = E.LSM

local _G = _G

options.chat = {
	type = "group",
	name = L["Chat"],
	get = function(info)
		return E.db.mui.chat[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.chat[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Chat"], "orange"),
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
		},
		general = {
			order = 2,
			type = "group",
			name = F.cOption(L["General"], "orange"),
			inline = true,
			args = {
				chatButton = {
					order = 1,
					type = "toggle",
					name = L["Chat Menu"],
					desc = L["Create a chat button to increase the chat size."],
				},
				hideChat = {
					order = 2,
					type = "toggle",
					name = L["Hide Community Chat"],
					desc = L["Adds an overlay to the Community Chat. Useful for streamers."],
				},
				emotes = {
					order = 3,
					type = "toggle",
					name = L["Emotes"],
				},
				editBoxPosition = {
					order = 4,
					type = "select",
					name = E.NewSign .. L["Chat EditBox Position"],
					desc = L["Position of the Chat EditBox, if the Actionbar backdrop is disabled, this will be forced to be above chat."],
					values = {
						["BELOW_CHAT"] = L["Below Chat"],
						["ABOVE_CHAT"] = L["Above Chat"],
						["EAB_1"] = L["Actionbar 1 (below)"],
						["EAB_2"] = L["Actionbar 2 (below)"],
						["EAB_3"] = L["Actionbar 3 (below)"],
						["EAB_4"] = L["Actionbar 4 (below)"],
						["EAB_5"] = L["Actionbar 5 (below)"],
						["EAB_6"] = L["Actionbar 6 (above)"],
					},
					disabled = function()
						return not E.db.mui.chat.enable
					end,
					get = function(info)
						return E.db.mui.chat[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.chat[info[#info]] = value
						CH:UpdateEditboxAnchors()
					end,
				},
			},
		},
		chatLink = {
			order = 10,
			type = "group",
			name = F.cOption(L["Chat Link"], "orange"),
			disabled = function()
				return not E.db.mui.chat.enable
			end,
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
							fontSize = "medium",
						},
					},
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
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
						numbericalQualityTier = {
							order = 2,
							type = "toggle",
							name = L["Numberical Quality Tier"],
							desc = L["Display the numberical quality tier on the item link."],
						},
						translateItem = {
							order = 3,
							type = "toggle",
							name = L["Translate Item"],
							desc = L["Translate the name in item links into your language."],
						},
						icon = {
							order = 4,
							type = "toggle",
							name = L["Icon"],
						},
						armorCategory = {
							order = 5,
							type = "toggle",
							name = L["Armor Category"],
						},
						weaponCategory = {
							order = 6,
							type = "toggle",
							name = L["Weapon Category"],
						},
					},
				},
			},
		},
		seperators = {
			order = 15,
			type = "group",
			name = F.cOption(L["Seperators"], "orange"),
			disabled = function()
				return not E.db.mui.chat.enable
			end,
			get = function(info)
				return E.db.mui.chat.seperators[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.chat.seperators[info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				visibility = {
					order = 2,
					type = "select",
					name = L["Visibility"],
					get = function(info)
						return E.db.mui.chat.seperators[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.chat.seperators[info[#info]] = value
						module:UpdateSeperators()
					end,
					values = {
						HIDEBOTH = L["Hide Both"],
						SHOWBOTH = L["Show Both"],
						LEFT = L["Left Only"],
						RIGHT = L["Right Only"],
					},
				},
			},
		},
		chatFade = {
			order = 16,
			type = "group",
			name = F.cOption(L["Fade Chat"], "orange"),
			disabled = function()
				return not E.db.mui.chat.enable
			end,
			get = function(info)
				return E.db.mui.chat.chatFade[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.chat.chatFade[info[#info]] = value
				CF:Configure_ChatFade()
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				timeout = {
					order = 2,
					type = "range",
					min = 5,
					max = 60,
					step = 1,
					name = L["Auto hide timeout"],
					desc = L["Seconds before fading chat panel"],
					disabled = function()
						return not E.db.mui.chat.chatFade.enable
					end,
				},
				minAlpha = {
					order = 3,
					type = "range",
					min = 0,
					max = 1,
					step = 0.01,
					name = L["Min Alpha"],
					disabled = function()
						return not E.db.mui.chat.chatFade.enable
					end,
				},
				fadeOutTime = {
					order = 4,
					type = "range",
					min = 0.1,
					max = 2,
					step = 0.01,
					name = L["Fadeout duration"],
					disabled = function()
						return not E.db.mui.chat.chatFade.enable
					end,
				},
			},
		},
		filter = {
			order = 20,
			type = "group",
			name = F.cOption(L["Filter"], "orange"),
			disabled = function()
				return not E.db.mui.chat.enable
			end,
			get = function(info)
				return E.db.mui.chat.filter[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.chat.filter[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Filters some messages out of your chat, that some Spam AddOns use."],
				},
			},
		},
		chatBar = {
			order = 30,
			type = "group",
			name = F.cOption(L["Chat Bar"], "orange"),
			disabled = function()
				return not E.db.mui.chat.enable
			end,
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
					end,
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
							desc = L["Hide channels not exist."],
						},
						mouseOver = {
							order = 2,
							type = "toggle",
							name = L["Mouse Over"],
							desc = L["Only show chat bar when you mouse over it."],
						},
						orientation = {
							order = 3,
							type = "select",
							name = L["Orientation"],
							values = {
								HORIZONTAL = L["Horizontal"],
								VERTICAL = L["Vertical"],
							},
						},
					},
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
							desc = L["Show a backdrop of the bar."],
						},
						backdropSpacing = {
							order = 2,
							type = "range",
							name = L["Backdrop Spacing"],
							desc = L["The spacing between the backdrop and the buttons."],
							min = 1,
							max = 30,
							step = 1,
						},
					},
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
							step = 1,
						},
						buttonHeight = {
							order = 2,
							type = "range",
							name = L["Button Height"],
							desc = L["The height of the buttons."],
							min = 2,
							max = 60,
							step = 1,
						},
						spacing = {
							order = 3,
							type = "range",
							name = L["Spacing"],
							min = 0,
							max = 80,
							step = 1,
						},
						style = {
							order = 4,
							type = "select",
							name = L["Style"],
							values = {
								BLOCK = L["Block"],
								TEXT = L["Text"],
							},
						},
					},
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
							name = L["Block Shadow"],
						},
						tex = {
							order = 2,
							type = "select",
							name = L["Texture"],
							dialogControl = "LSM30_Statusbar",
							values = LSM:HashTable("statusbar"),
						},
					},
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
							name = L["Use Color"],
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
									values = LSM:HashTable("font"),
								},
								style = {
									order = 2,
									type = "select",
									name = L["Outline"],
									values = MER.Values.FontFlags,
									sortByValue = true,
								},
								size = {
									order = 3,
									name = L["Size"],
									type = "range",
									min = 5,
									max = 60,
									step = 1,
								},
							},
						},
					},
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
									name = L["Enable"],
								},
								color = {
									order = 2,
									type = "color",
									name = L["Color"],
									hasAlpha = true,
									get = function(info)
										local colordb = E.db.mui.chat.chatBar.channels.world.color
										local default = P.chat.chatBar.channels.world.color
										return colordb.r,
											colordb.g,
											colordb.b,
											colordb.a,
											default.r,
											default.g,
											default.b,
											default.a
									end,
									set = function(info, r, g, b, a)
										E.db.mui.chat.chatBar.channels.world.color = {
											r = r,
											g = g,
											b = b,
											a = a,
										}
										CB:UpdateBar()
									end,
								},
								abbr = {
									order = 3,
									type = "input",
									hidden = function()
										return not (E.db.mui.chat.chatBar.style == "TEXT")
									end,
									name = L["Abbreviation"],
								},
								name = {
									order = 4,
									type = "input",
									name = L["Channel Name"],
								},
								autoJoin = {
									order = 5,
									type = "toggle",
									name = L["Auto Join"],
								},
							},
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
									name = L["Enable"],
								},
								color = {
									order = 2,
									type = "color",
									name = L["Color"],
									hasAlpha = true,
									get = function(info)
										local colordb = E.db.mui.chat.chatBar.channels.community.color
										local default = P.chat.chatBar.channels.community.color
										return colordb.r,
											colordb.g,
											colordb.b,
											colordb.a,
											default.r,
											default.g,
											default.b,
											default.a
									end,
									set = function(info, r, g, b, a)
										E.db.mui.chat.chatBar.channels.community.color = {
											r = r,
											g = g,
											b = b,
											a = a,
										}
										CB:UpdateBar()
									end,
								},
								abbr = {
									order = 3,
									type = "input",
									hidden = function()
										return not (E.db.mui.chat.chatBar.style == "TEXT")
									end,
									name = L["Abbreviation"],
								},
								name = {
									order = 4,
									type = "input",
									name = L["Channel Name"],
								},
								communityDesc = {
									order = 5,
									type = "description",
									width = "full",
									name = L["Please use Blizzard Communities UI add the channel to your main chat frame first."],
								},
							},
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
									name = L["Enable"],
								},
								color = {
									order = 2,
									type = "color",
									name = L["Color"],
									hasAlpha = true,
									get = function(info)
										local colordb = E.db.mui.chat.chatBar.channels.roll.color
										local default = P.chat.chatBar.channels.roll.color
										return colordb.r,
											colordb.g,
											colordb.b,
											colordb.a,
											default.r,
											default.g,
											default.b,
											default.a
									end,
									set = function(info, r, g, b, a)
										E.db.mui.chat.chatBar.channels.roll.color = {
											r = r,
											g = g,
											b = b,
											a = a,
										}
										CB:UpdateBar()
									end,
								},
								icon = {
									order = 3,
									type = "toggle",
									name = L["Use Icon"],
									desc = L["Use a icon rather than text"],
									hidden = function()
										return not (E.db.mui.chat.chatBar.style == "TEXT")
									end,
								},
								abbr = {
									order = 4,
									type = "input",
									hidden = function()
										return not (E.db.mui.chat.chatBar.style == "TEXT")
									end,
									name = L["Abbreviation"],
								},
							},
						},
					},
				},
			},
		},
	},
}

local SampleStrings = {}
do
	local icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.sunTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.sunHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.sunDPS, ":16:16")
	SampleStrings.sunui = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.lynTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.lynHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.lynDPS, ":16:16")
	SampleStrings.lynui = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.svuiTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.svuiHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.svuiDPS, ":16:16")
	SampleStrings.svui = icons

	icons = ""
	icons = icons .. E:TextureString(E.Media.Textures.Tank, ":16:16") .. " "
	icons = icons .. E:TextureString(E.Media.Textures.Healer, ":16:16") .. " "
	icons = icons .. E:TextureString(E.Media.Textures.DPS, ":16:16")
	SampleStrings.elvui = icons

	icons = ""
	icons = icons .. CT.cache.blizzardRoleIcons.Tank .. " "
	icons = icons .. CT.cache.blizzardRoleIcons.Healer .. " "
	icons = icons .. CT.cache.blizzardRoleIcons.DPS
	SampleStrings.blizzard = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.customTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.customHeal, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.customDPS, ":16:16")
	SampleStrings.custom = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.glowTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.glowHeal, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.glowDPS, ":16:16")
	SampleStrings.glow = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.mainTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.mainHeal, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.mainDPS, ":16:16")
	SampleStrings.main = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.whiteTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.whiteHeal, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.whiteDPS, ":16:16")
	SampleStrings.white = icons

	icons = ""
	icons = icons .. E:TextureString(MER.Media.Textures.materialTank, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.materialHeal, ":16:16") .. " "
	icons = icons .. E:TextureString(MER.Media.Textures.materialDPS, ":16:16")
	SampleStrings.material = icons
end

do
	local newRuleName, newRuleAbbr, selectedRule

	options.chat.args.chatText = {
		order = 10,
		type = "group",
		name = F.cOption(L["Chat Text"], "orange"),
		get = function(info)
			return E.db.mui.chat.chatText[info[#info]]
		end,
		set = function(info, value)
			E.db.mui.chat.chatText[info[#info]] = value
			CT:ProfileUpdate()
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
						name = L["Modify the chat text style."],
						fontSize = "medium",
					},
				},
			},
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				width = "full",
			},
			general = {
				order = 2,
				type = "group",
				inline = true,
				name = L["General"],
				disabled = function()
					return not E.db.mui.chat.chatText.enable
				end,
				get = function(info)
					return E.db.mui.chat.chatText[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.chat.chatText[info[#info]] = value
					CT:ProfileUpdate()
				end,
				args = {
					removeBrackets = {
						order = 1,
						type = "toggle",
						name = L["Remove Brackets"],
					},
					classIcon = {
						order = 2,
						type = "toggle",
						name = L["Class Icon"],
						desc = L["Show the class icon before the player name."]
							.. "\n"
							.. L["This feature only works for message that sent by this module."],
					},
					classIconStyle = {
						order = 3,
						type = "select",
						name = L["Class Icon Style"],
						desc = L["Select the style of class icon."],
						values = function()
							local v = {}
							for _, style in pairs(F.GetClassIconStyleList()) do
								local rogueSample = F.GetClassIconStringWithStyle("ROGUE", style, 16, 16)
								local druidSample = F.GetClassIconStringWithStyle("DRUID", style, 16, 16)
								local paladinSample = F.GetClassIconStringWithStyle("PALADIN", style, 16, 16)

								local sample = rogueSample .. " " .. druidSample .. " " .. paladinSample
								v[style] = sample
							end
							return v
						end,
					},
					factionIcon = {
						order = 4,
						type = "toggle",
						name = L["Faction Icon"],
						desc = L["Show the faction icon before the player name."]
							.. "\n"
							.. L["This feature only works for message that sent by this module."],
					},
				},
			},
			enhancements = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Enhancements"],
				disabled = function()
					return not E.db.mui.chat.chatText.enable
				end,
				get = function(info)
					return E.db.mui.chat.chatText[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.chat.chatText[info[#info]] = value
					CT:ProfileUpdate()
				end,
				args = {
					guildMemberStatus = {
						order = 1,
						type = "toggle",
						name = L["Guild Member Status"],
						desc = L["Enhance the message when a guild member comes online or goes offline."],
						width = 1.2,
					},
					guildMemberStatusInviteLink = {
						order = 2,
						type = "toggle",
						name = L["Online Invite Link"],
						desc = L["Add an invite link to the guild member online message."],
						width = 1.2,
						disabled = function()
							return not E.db.mui.chat.chatText.enable or not E.db.mui.chat.chatText.guildMemberStatus
						end,
					},
					mergeAchievement = {
						order = 3,
						type = "toggle",
						name = L["Merge Achievement"],
						desc = L["Merge the achievement message into one line."],
						width = 1.2,
					},
					bnetFriendOnline = {
						order = 4,
						type = "toggle",
						name = L["BNet Friend Online"],
						desc = L["Show a message when a Battle.net friend's wow character comes online."]
							.. "\n"
							.. L["The message will only be shown in the chat frame (or chat tab) with Blizzard service alert channel on."],
						width = 1.2,
					},
					bnetFriendOffline = {
						order = 5,
						type = "toggle",
						name = L["BNet Friend Offline"],
						desc = L["Show a message when a Battle.net friend's wow character goes offline."]
							.. "\n"
							.. L["The message will only be shown in the chat frame (or chat tab) with Blizzard service alert channel on."],
						width = 1.2,
					},
				},
			},
			characterName = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Character Name"],
				disabled = function()
					return not E.db.mui.chat.chatText.enable
				end,
				get = function(info)
					return E.db.mui.chat.chatText[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.chat.chatText[info[#info]] = value
					CT:ProfileUpdate()
					CH:CheckLFGRoles() -- We need to call GROUP_ROSTER_UPDATE to run the Update, so do it with this function
				end,
				args = {
					removeRealm = {
						order = 1,
						type = "toggle",
						name = L["Remove Realm"],
						disabled = function()
							return not E.db.mui.chat.chatText.enable
						end,
					},
					roleIconStyle = {
						order = 2,
						type = "select",
						name = L["Style"],
						values = {
							SUNUI = SampleStrings.sunui,
							LYNUI = SampleStrings.lynui,
							SVUI = SampleStrings.svui,
							CUSTOM = SampleStrings.custom,
							GLOW = SampleStrings.glow,
							MAIN = SampleStrings.main,
							WHITE = SampleStrings.white,
							MATERIAL = SampleStrings.material,
							BLIZZARD = SampleStrings.blizzard,
							DEFAULT = SampleStrings.elvui,
						},
					},
					roleIconSize = {
						order = 3,
						type = "range",
						name = L["Size"],
						min = 5,
						max = 25,
						step = 1,
					},
				},
			},
			channelAbbreviation = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Abbreviation Customization"],
				disabled = function()
					return not E.db.mui.chat.chatText.enable
				end,
				args = {
					abbreviation = {
						order = 1,
						type = "select",
						name = L["Channel Abbreviation"],
						desc = L["Modify the style of abbreviation of channels."],
						disabled = function()
							return not E.db.mui.chat.chatText.enable
						end,
						get = function(info)
							return E.db.mui.chat.chatText[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.chat.chatText[info[#info]] = value
							CT:ProfileUpdate()
						end,
						values = {
							NONE = L["None"],
							SHORT = L["Short"],
							DEFAULT = L["Default"],
						},
					},
					newRule = {
						order = 2,
						type = "group",
						inline = true,
						name = L["New Channel Abbreviation Rule"],
						args = {
							channelName = {
								order = 1,
								type = "input",
								name = L["Channel Name"],
								get = function()
									return newRuleName
								end,
								set = function(_, value)
									newRuleName = value
								end,
							},
							abbrName = {
								order = 2,
								type = "input",
								name = L["Abbreviation"],
								get = function()
									return newRuleAbbr
								end,
								set = function(_, value)
									newRuleAbbr = value
								end,
							},
							addButton = {
								order = 3,
								type = "execute",
								name = L["Add / Update"],
								desc = L["Add or update the rule with custom abbreviation."],
								func = function()
									if newRuleName and newRuleAbbr then
										E.db.mui.chat.chatText.customAbbreviation[newRuleName] = newRuleAbbr
										newRuleAbbr = nil
										newRuleName = nil
									else
										print(L["Please set the channel and abbreviation first."])
									end
								end,
							},
						},
					},
					deleteRule = {
						order = 3,
						type = "group",
						inline = true,
						name = L["Delete Channel Abbreviation Rule"],
						args = {
							list = {
								order = 1,
								type = "select",
								name = L["List"],
								get = function()
									return selectedRule
								end,
								set = function(_, value)
									selectedRule = value
								end,
								values = function()
									return E.db.mui.chat.chatText.customAbbreviation
								end,
								width = 2,
							},
							deleteButton = {
								order = 3,
								type = "execute",
								name = L["Remove"],
								func = function()
									if selectedRule then
										E.db.mui.chat.chatText.customAbbreviation[selectedRule] = nil
									end
								end,
							},
						},
					},
				},
			},
		},
	}
end

local channels = { "SAY", "YELL", "EMOTE", "PARTY", "RAID", "RAID_WARNING", "GUILD", "OFFICER" }
for index, name in ipairs(channels) do
	options.chat.args.chatBar.args.channels.args[name] = {
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
				name = L["Enable"],
			},
			color = {
				order = 2,
				type = "color",
				name = L["Color"],
				hasAlpha = true,
				get = function(info)
					local colordb = E.db.mui.chat.chatBar.channels[name].color
					local default = P.chat.chatBar.channels[name].color
					return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
				end,
				set = function(info, r, g, b, a)
					E.db.mui.chat.chatBar.channels[name].color = {
						r = r,
						g = g,
						b = b,
						a = a,
					}
					CB:UpdateBar()
				end,
			},
			abbr = {
				order = 3,
				type = "input",
				hidden = function()
					return not (E.db.mui.chat.chatBar.style == "TEXT")
				end,
				name = L["Abbreviation"],
			},
		},
	}
end

options.chat.args.chatBar.args.channels.args.INSTANCE = {
	order = index,
	type = "group",
	name = _G.INSTANCE,
	get = function(info)
		return E.db.mui.chat.chatBar.channels.INSTANCE[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.chat.chatBar.channels.INSTANCE[info[#info]] = value
		CB:UpdateBar()
	end,
	args = {
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
		},
		color = {
			order = 2,
			type = "color",
			name = L["Color"],
			hasAlpha = true,
			get = function(info)
				local colordb = E.db.mui.chat.chatBar.channels.INSTANCE.color
				local default = P.chat.chatBar.channels.INSTANCE.color
				return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
			end,
			set = function(info, r, g, b, a)
				E.db.mui.chat.chatBar.channels.INSTANCE.color = {
					r = r,
					g = g,
					b = b,
					a = a,
				}
				CB:UpdateBar()
			end,
		},
		abbr = {
			order = 3,
			type = "input",
			hidden = function()
				return not (E.db.mui.chat.chatBar.style == "TEXT")
			end,
			name = L["Abbreviation"],
		},
	},
}
