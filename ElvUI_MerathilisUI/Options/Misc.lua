local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.misc.args
local MI = MER:GetModule("MER_Misc")
local RIF = MER:GetModule("MER_RaidInfoFrame")

local GetClassColor = GetClassColor

options.general = {
	order = 1,
	type = "group",
	name = L["General"],
	get = function(info)
		return E.db.mui.misc[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["General"], "orange"),
		},
		gmotd = {
			order = 2,
			type = "toggle",
			name = L.GUILD_MOTD_LABEL2,
			desc = L["Display the Guild Message of the Day in an extra window, if updated."],
		},
		funstuff = {
			order = 4,
			type = "toggle",
			name = L["Fun Stuff"],
			desc = L["Change the NPC Talk Frame."],
		},
		wowheadlinks = {
			order = 5,
			type = "toggle",
			name = L["Wowhead Links"],
			desc = L["Adds Wowhead links to the Achievement- and WorldMap Frame"],
		},
		tradeTabs = {
			order = 6,
			type = "toggle",
			name = L["Trade Tabs"],
			desc = L["Enable Tabs on the Profession Frames"],
		},
		spacer = {
			order = 7,
			type = "description",
			name = " ",
		},
		blockRequest = {
			order = 8,
			type = "toggle",
			name = L["Block Join Requests"],
			desc = L["|nIf checked, only popout join requests from friends and guild members."],
		},
		petFilterTab = {
			order = 11,
			type = "toggle",
			name = L["Pet Filter Tab"],
			desc = L["Adds a filter tab to the Pet Journal, which allows you to filter pets by their type."],
			get = function()
				return E.db.mui.misc.petFilterTab
			end,
			set = function(_, value)
				E.db.mui.misc.petFilterTab = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
	},
}

options.gameMenu = {
	order = 2,
	type = "group",
	name = L["Game Menu"],
	get = function(info)
		return E.db.mui.gameMenu[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.gameMenu[info[#info]] = value
		E:StaticPopup_Show("CONFIG_RL")
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Game Menu"], "orange"),
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable/Disable the MerathilisUI Style from the Blizzard Game Menu. (e.g. Pepe, Logo, Bars)"],
		},
		bgColor = {
			order = 2,
			type = "color",
			name = L["Background Color"],
			hasAlpha = true,
			get = function(info)
				local t = E.db.mui.gameMenu[info[#info]]
				local d = P.gameMenu[info[#info]]
				return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
			end,
			set = function(info, r, g, b, a)
				local t = E.db.mui.gameMenu[info[#info]]
				t.r, t.g, t.b, t.a = r, g, b, a
			end,
			hidden = function()
				return not E.db.mui.gameMenu.enable
			end,
		},
		info = {
			order = 2,
			type = "group",
			name = L["Info"],
			guiInline = true,
			hidden = function()
				return not E.db.mui.gameMenu.enable
			end,
			args = {
				showCollections = {
					order = 1,
					type = "toggle",
					name = L["Show Collections"],
				},
				showWeeklyDevles = {
					order = 2,
					type = "toggle",
					name = L["Show Weekly Delves Keys"],
				},
				mythic = {
					order = 3,
					type = "group",
					name = "|cffFF0000WIP|r" .. " " .. L["Mythic+"],
					args = {
						showMythicKey = {
							order = 1,
							type = "toggle",
							name = L["Show Mythic+ Infos"],
						},
						showMythicScore = {
							order = 2,
							type = "toggle",
							name = L["Show Mythic+ Score"],
							disabled = function()
								return not E.db.mui.gameMenu.enable or not E.db.mui.gameMenu.showMythicKey
							end,
						},
						mythicHistoryLimit = {
							order = 3,
							type = "range",
							name = L["History Limit"],
							desc = L["Number of Mythic+ dungeons shown in the latest runs."],
							min = 1,
							max = 10,
							step = 1,
							get = function()
								return E.db.mui.gameMenu.mythicHistoryLimit
							end,
							set = function(_, value)
								E.db.mui.gameMenu.mythicHistoryLimit = value
							end,
							disabled = function()
								return not E.db.mui.gameMenu.enable or not E.db.mui.gameMenu.showMythicKey
							end,
						},
					},
				},
			},
		},
	},
}

options.scale = {
	order = 4,
	type = "group",
	name = L["Scale"],
	hidden = function()
		return not MER:HasRequirements(I.Requirements.AdditionalScaling)
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Scale"], "orange"),
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			get = function(_)
				return E.db.mui.scale.enable
			end,
			set = function(_, value)
				E.db.mui.scale.enable = value
				if value then
					MI:Scale()
				else
					E:StaticPopup_Show("CONFIG_RL")
				end
			end,
		},
		spacer = {
			order = 2,
			type = "description",
			name = " ",
		},
		characterGroup = {
			order = 3,
			type = "group",
			name = F.cOption(L["Character"], "orange"),
			guiInline = true,
			hidden = function()
				return not E.db.mui.scale.enable
			end,
			args = {
				character = {
					order = 1,
					type = "range",
					name = L["Character Frame"],
					get = function(_)
						return E.db.mui.scale.characterFrame.scale
					end,
					set = function(_, value)
						E.db.mui.scale.characterFrame.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 2,
					step = 0.05,
				},
				dressingRoom = {
					order = 2,
					type = "range",
					name = L["Dressing Room"],
					get = function(_)
						return E.db.mui.scale.dressingRoom.scale
					end,
					set = function(_, value)
						E.db.mui.scale.dressingRoom.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 2,
					step = 0.05,
				},
				inspectFrame = {
					order = 3,
					type = "range",
					name = L["Inspect Frame"],
					disabled = function()
						return E.db.mui.scale.syncInspect.enabled
					end,
					get = function(_)
						return E.db.mui.scale.inspectFrame.scale
					end,
					set = function(_, value)
						E.db.mui.scale.inspectFrame.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 2,
					step = 0.05,
				},
				syncInspect = {
					order = 4,
					type = "toggle",
					name = L["Sync Inspect"],
					desc = L["Toggling this on makes your inspect frame scale have the same value as the character frame scale."],
					get = function(_)
						return E.db.mui.scale.syncInspect.enabled
					end,
					set = function(_, value)
						E.db.mui.scale.syncInspect.enabled = value
						MI:Scale()
					end,
				},
			},
		},
		spacer1 = {
			order = 4,
			type = "description",
			name = " ",
		},
		otherGroup = {
			order = 5,
			type = "group",
			name = F.cOption(L["Other"], "orange"),
			desc = L["Scale other frames.\n\n"],
			guiInline = true,
			hidden = function()
				return not E.db.mui.scale.enable
			end,
			args = {
				talents = {
					order = 1,
					type = "range",
					name = L["Talents"],
					get = function(_)
						return E.db.mui.scale.talents.scale
					end,
					set = function(_, value)
						E.db.mui.scale.talents.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 2,
					step = 0.05,
				},
				collections = {
					order = 2,
					type = "range",
					name = L["Collections"],
					get = function(_)
						return E.db.mui.scale.collections.scale
					end,
					set = function(_, value)
						E.db.mui.scale.collections.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 2,
					step = 0.05,
				},
				wardrobe = {
					order = 3,
					type = "range",
					name = L["Wardrobe"],
					get = function(_)
						return E.db.mui.scale.wardrobe.scale
					end,
					set = function(_, value)
						E.db.mui.scale.wardrobe.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 2,
					step = 0.05,
				},
				auctionHouse = {
					order = 4,
					type = "range",
					name = L["Auction House"],
					get = function(_)
						return E.db.mui.scale.auctionHouse.scale
					end,
					set = function(_, value)
						E.db.mui.scale.auctionHouse.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 2,
					step = 0.05,
				},
				profession = {
					order = 5,
					type = "range",
					name = L["Profession"],
					get = function(_)
						return E.db.mui.scale.profession.scale
					end,
					set = function(_, value)
						E.db.mui.scale.profession.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 2,
					step = 0.05,
				},
				transmog = {
					order = 6,
					type = "toggle",
					name = L["Transmog Frame"],
					desc = L["Makes the transmogrification frame bigger. Credits to Kayr for code."],
					get = function(_)
						return E.db.mui.scale.transmog.enable
					end,
					set = function(_, value)
						E.db.mui.scale.transmog.enable = value
						if value then
							MI:Scale()
						else
							E:StaticPopup_Show("CONFIG_RL")
						end
					end,
				},
				groupFinder = {
					order = 7,
					type = "range",
					name = L["Group Finder"],
					get = function(_)
						return E.db.mui.scale.groupFinder.scale
					end,
					set = function(_, value)
						E.db.mui.scale.groupFinder.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 3,
					step = 0.05,
				},
				itemUpgrade = {
					order = 8,
					type = "range",
					name = L["Item Upgrade"],
					get = function(_)
						return E.db.mui.scale.itemUpgrade.scale
					end,
					set = function(_, value)
						E.db.mui.scale.itemUpgrade.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 3,
					step = 0.05,
				},
				equipmentFlyout = {
					order = 9,
					type = "range",
					name = L["Equipment Upgrade"],
					get = function(_)
						return E.db.mui.scale.equipmentFlyout.scale
					end,
					set = function(_, value)
						E.db.mui.scale.equipmentFlyout.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 3,
					step = 0.05,
				},
				vendor = {
					order = 10,
					type = "range",
					name = L["Vendor"],
					get = function(_)
						return E.db.mui.scale.vendor.scale
					end,
					set = function(_, value)
						E.db.mui.scale.vendor.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 3,
					step = 0.05,
				},
				classTrainer = {
					order = 11,
					type = "range",
					name = L["Class Trainer"],
					get = function(_)
						return E.db.mui.scale.classTrainer.scale
					end,
					set = function(_, value)
						E.db.mui.scale.classTrainer.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 3,
					step = 0.05,
				},
				gossip = {
					order = 12,
					type = "range",
					name = L["Gossip"],
					get = function(_)
						return E.db.mui.scale.gossip.scale
					end,
					set = function(_, value)
						E.db.mui.scale.gossip.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 3,
					step = 0.05,
				},
				quest = {
					order = 13,
					type = "range",
					name = L["Quest"],
					get = function(_)
						return E.db.mui.scale.quest.scale
					end,
					set = function(_, value)
						E.db.mui.scale.quest.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 3,
					step = 0.05,
				},
				mailbox = {
					order = 14,
					type = "range",
					name = L["Mailbox"],
					get = function(_)
						return E.db.mui.scale.mailbox.scale
					end,
					set = function(_, value)
						E.db.mui.scale.mailbox.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 3,
					step = 0.05,
				},
				friends = {
					order = 15,
					type = "range",
					name = L["Friends"],
					get = function(_)
						return E.db.mui.scale.friends.scale
					end,
					set = function(_, value)
						E.db.mui.scale.friends.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 3,
					step = 0.05,
				},
				encounterjournal = {
					order = 16,
					type = "range",
					name = L["Encounter Journal"],
					get = function(_)
						return E.db.mui.scale.encounterjournal.scale
					end,
					set = function(_, value)
						E.db.mui.scale.encounterjournal.scale = value
						MI:Scale()
					end,
					min = 0.5,
					max = 3,
					step = 0.05,
				},
			},
		},
	},
}

options.tags = {
	order = 5,
	type = "group",
	name = L["Tags"],
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
					name = L["Add more oUF tags. You can use them on UnitFrames configuration."],
					fontSize = "medium",
				},
			},
		},
	},
}
options.singingSockets = {
	order = 10,
	type = "group",
	name = L["Singing Sockets"],
	get = function(info)
		return E.db.mui.misc.singingSockets[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc.singingSockets[info[#info]] = value
		E:StaticPopup_Show("CONFIG_RL")
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
					name = L["Adds a Singing sockets selection tool on the Socketing Frame."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
		},
	},
}

options.raidInfo = {
	order = 11,
	type = "group",
	name = L["Raid Info Frame"],
	get = function(info)
		return E.db.mui.misc.raidInfo[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc.raidInfo[info[#info]] = value
		E:StaticPopup_Show("CONFIG_RL")
	end,
	args = {
		desc = {
			order = 0,
			type = "description",
			name = MER.Title
				.. L[" provides a Raid Info Frame that shows a list of players per role in your raid."]
				.. "\n\n",
			fontSize = "medium",
		},
		credits = {
			order = 1,
			type = "group",
			name = F.cOption(L["Credits"], "orange"),
			guiInline = true,
			args = {
				toxiui = {
					order = 1,
					type = "description",
					name = "|cff1784d1ElvUI|r |cffffffffToxi|r|cff18a8ffUI|r",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable the Raid Info Frame."],
		},
		toggle = {
			order = 3,
			type = "execute",
			name = L["Toggle"],
			desc = L["Temporarily shows the frame even outside of a raid for easier customization."],
			func = function()
				RIF:ToggleFrame()
			end,
			disabled = function()
				return not E.db.mui.misc.raidInfo.enable
			end,
		},
		customization = {
			order = 4,
			type = "group",
			name = F.cOption(L["Customization"], "orange"),
			guiInline = true,
			disabled = function()
				return not E.db.mui.misc.raidInfo.enable
			end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = F.cOption(L["Customization"], "orange"),
				},
				size = {
					order = 1,
					type = "range",
					name = L["Size"],
					desc = L["Set the size of the text and icons."],
					min = 8,
					max = 64,
					step = 1,
					get = function()
						return E.db.mui.misc.raidInfo.size
					end,
					set = function(_, value)
						E.db.mui.misc.raidInfo.size = value
						RIF:UpdateSize()
					end,
				},
				padding = {
					order = 2,
					type = "range",
					name = L["Padding"],
					desc = L["Set the outside padding of the frame."],
					min = 0,
					max = 32,
					step = 1,
					get = function()
						return E.db.mui.misc.raidInfo.padding
					end,
					set = function(_, value)
						E.db.mui.misc.raidInfo.padding = value
						RIF:UpdateSpacing()
					end,
				},
				spacing = {
					order = 3,
					type = "range",
					name = L["Spacing"],
					desc = L["Set the spacing between the icons."],
					min = 0,
					max = 32,
					step = 1,
					get = function()
						return E.db.mui.misc.raidInfo.spacing
					end,
					set = function(_, value)
						E.db.mui.misc.raidInfo.spacing = value
						RIF:UpdateSpacing()
					end,
				},
				backdropColor = {
					order = 4,
					type = "color",
					name = L["Backdrop Color"],
					desc = L["Set the backdrop color of the frame."],
					get = function()
						local db = E.db.mui.misc.raidInfo.backdropColor
						local default = P.misc.raidInfo.backdropColor
						return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
					end,
					set = function(_, r, g, b, a)
						local db = E.db.mui.misc.raidInfo.backdropColor
						db.r, db.g, db.b, db.a = r, g, b, a
						RIF:UpdateBackdrop()
					end,
				},
				hideInCombat = {
					order = 5,
					type = "toggle",
					name = L["Hide In Combat"],
					desc = L["Hides the frame while in combat."],
					get = function()
						return E.db.mui.misc.raidInfo.hideInCombat
					end,
					set = function(_, value)
						E.db.mui.misc.raidInfo.hideInCombat = value
					end,
				},
				roleIcons = {
					order = 6,
					type = "select",
					name = L["Style"],
					desc = L["Change the look of the icons"],
					get = function()
						return E.db.mui.elvUIIcons.roleIcons.theme
					end,
					set = function(_, value)
						E.db.mui.elvUIIcons.roleIcons.theme = value
						RIF:UpdateIcons()
					end,
					values = {
						["MERATHILISUI"] = MER.Title .. " Style",
						["MATERIAL"] = "Material",
						["SUNUI"] = "SUNUI",
						["SVUI"] = "SVUI",
						["GLOW"] = "GLOW",
						["CUSTOM"] = "CUSTOM",
						["GRAVED"] = "GRAVED",
						["ElvUI"] = "ElvUI",
					},
				},
			},
		},
	},
}
