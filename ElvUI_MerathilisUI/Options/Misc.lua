local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local MI = MER:GetModule("MER_Misc")
	local RIF = MER:GetModule("MER_RaidInfoFrame")
	local LSM = MER:GetModule("MER_Loot")

	local options = module.options.misc.args

	local format, pairs, sort, tconcat, tinsert = format, pairs, sort, table.concat, tinsert

	options.general = {
		order = 1,
		type = "group",
		name = module:AddCategorieIcon(L["General"], "OptionsHome"),
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
				name = L["General"],
			},
			gmotd = module.ToggleCard({
				order = 2,
				name = GUILD_MOTD_LABEL2,
				desc = L["Display the Guild Message of the Day in an extra window, if updated."],
			}, 0.5),
			wowheadlinks = module.ToggleCard({
				order = 5,
				name = L["Wowhead Links"],
				desc = L["Adds Wowhead links to the Achievement- and WorldMap Frame"],
			}, 0.5),
			tradeTabs = module.ToggleCard({
				order = 6,
				name = L["Trade Tabs"],
				desc = L["Enable Tabs on the Profession Frames"],
			}, 0.5),
			blockRequest = module.ToggleCard({
				order = 8,
				name = L["Block Join Requests"],
				-- The tooltip text starts with a line break, the card body doesn't need it
				desc = (L["|nIf checked, only popout join requests from friends and guild members."]:gsub("^|n", "")),
			}, 0.5),
			petFilterTab = module.ToggleCard({
				order = 9,
				name = L["Pet Filter Tab"],
				desc = L["Adds a filter tab to the Pet Journal, which allows you to filter pets by their type."],
				get = function()
					return E.db.mui.misc.petFilterTab
				end,
				set = function(_, value)
					E.db.mui.misc.petFilterTab = value
					E:StaticPopup_Show("PRIVATE_RL")
				end,
			}, 0.5),
			auctionEnhanced = module.ToggleCard({
				order = 10,
				name = L["Auction Enhanced"],
				desc = L["Show the tertiary stats of equipments in auction house."],
			}, 0.5),
			lootSpecManager = {
				order = 40,
				type = "group",
				name = L["LootSpecManager"],
				desc = L["|nBase on LootSpecManager, auto change your loot spec between bosses, support Raid and M+."],
				inline = true,
				get = function(info)
					return E.db.mui.lootSpecManager[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.lootSpecManager[info[#info]] = value
					LSM:ProfileUpdate()
				end,
				args = {
					enable = module.ToggleCard({
						order = 1,
						name = L["Enable"],
						desc = (
							L["|nBase on LootSpecManager, auto change your loot spec between bosses, support Raid and M+."]:gsub(
								"^|n",
								""
							)
						),
					}),
					togglePanel = {
						order = 2,
						type = "execute",
						name = L["Toggle Panel"],
						func = function()
							LSM:TogglePanel()
						end,
						disabled = function()
							return not E.db.mui.lootSpecManager.enable
						end,
					},
				},
			},
			copyMog = {
				order = 50,
				type = "group",
				name = L["Copy Transmog"],
				desc = L["Adds a button to the character and inspect frame that allows you to copy a list of the currently transmogrified items."],
				inline = true,
				get = function(info)
					return E.db.mui.misc.copyMog[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.misc.copyMog[info[#info]] = value
					E:StaticPopup_Show("PRIVATE_RL")
				end,
				args = {
					enable = module.ToggleCard({
						order = 1,
						name = L["Enable"],
						desc = L["Adds a button to the character and inspect frame that allows you to copy a list of the currently transmogrified items."],
					}),
					ShowHideVisual = {
						order = 2,
						type = "toggle",
						name = L["Show/Hide Visual"],
						disabled = function()
							return not E.db.mui.misc.copyMog.enable
						end,
					},
					ShowIllusion = {
						order = 3,
						type = "toggle",
						name = L["Show Illusion"],
						desc = L["Show the illusion of the item in the list."],
						disabled = function()
							return not E.db.mui.misc.copyMog.enable
						end,
					},
				},
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
				name = L["Game Menu"],
			},
			enable = module.ToggleCard({
				order = 1,
				name = L["Enable"],
				desc = L["Enable/Disable the MerathilisUI Style from the Blizzard Game Menu. (e.g. Pepe, Logo, Bars)"],
			}),
			showRandomPets = {
				order = 2,
				type = "toggle",
				name = L["Show Random Pets"],
				desc = L["Shows random battle pets"],
			},
			animations = {
				order = 2.5,
				type = "toggle",
				name = L["Fade In Content"],
				desc = L["Fades the info blocks in one after the other when the game menu opens."],
				-- Read every time the menu opens, no reload needed
				set = function(info, value)
					E.db.mui.gameMenu[info[#info]] = value
				end,
				hidden = function()
					return not E.db.mui.gameMenu.enable
				end,
			},
			bgColor = {
				order = 3,
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
				order = 4,
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
					showGreatVault = {
						order = 2.1,
						type = "toggle",
						name = L["Show Great Vault"],
						desc = L["Shows your Great Vault progress for raids, dungeons and the world."],
					},
					showClock = {
						order = 2.2,
						type = "toggle",
						name = L["Show Clock"],
						desc = L["Shows the time, the date and the time until the weekly reset."],
						-- The clock is always built, it is only shown or hidden when the menu opens
						set = function(info, value)
							E.db.mui.gameMenu[info[#info]] = value
						end,
					},
					mythic = {
						order = 3,
						type = "group",
						name = L["Mythic+"],
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
		-- Shown but locked with the reason, instead of silently hiding the tab
		disabled = module.RequirementsDisabled(I.Requirements.AdditionalScaling),
		args = {
			header = {
				order = 0,
				type = "header",
				name = L["Scale"],
			},
			requirements = module.RequirementsNotice(I.Requirements.AdditionalScaling, 0.5),
			enable = module.ToggleCard({
				order = 1,
				name = L["Enable"],
				desc = L["Scales the character, dressing room, inspect, talent and collection frames on their own, independent of the UI scale."],
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
			}),
			characterGroup = {
				order = 3,
				type = "group",
				name = L["Character"],
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
							return E.db.mui.scale.syncInspect.enable
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
							return E.db.mui.scale.syncInspect.enable
						end,
						set = function(_, value)
							E.db.mui.scale.syncInspect.enable = value
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
				name = L["Other"],
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
						name = L["Transmog Frame"],
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
						name = L["Equipment Flyout"],
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
				order = 1,
				type = "description",
				dialogControl = "MERTextCard",
				fontSize = "medium",
				name = function()
					-- Every tag Core/Tags.lua registers under our category, with its description
					local tags = {}
					for tagName, info in pairs(E.TagInfo) do
						if info.category == MER.Title then
							tinsert(
								tags,
								format("%s  %s", F.String.RGB("[" .. tagName .. "]", I.Colors.Accent), info.description)
							)
						end
					end
					sort(tags)

					return L["Add more oUF tags. You can use them on UnitFrames configuration."]
						.. "\n\n"
						.. tconcat(tags, "\n")
				end,
				arg = { title = L["Tags"] },
			},
			previewHeader = {
				order = 2,
				type = "header",
				name = _G.PREVIEW,
			},
			preview = {
				order = 3,
				type = "description",
				dialogControl = "MERTagPreview",
				name = "",
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
			enable = module.ToggleCard({
				order = 1,
				name = L["Singing Sockets"],
				desc = L["Adds a Singing sockets selection tool on the Socketing Frame."],
			}),
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
			RIF:DatabaseUpdate()
		end,
		args = {
			enable = module.ToggleCard({
				order = 1,
				name = L["Enable"],
				desc = MER.Title
					.. L[" provides a Raid Info Frame that shows a list of players per role in your raid."],
			}),
			credits = module.CreditsCard(2, "|cff1784d1ElvUI|r |cffffffffToxi|r|cff18a8ffUI|r"),
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
				name = L["Customization"],
				guiInline = true,
				disabled = function()
					return not E.db.mui.misc.raidInfo.enable
				end,
				args = {
					header = {
						order = 0,
						type = "header",
						name = L["Customization"],
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
							RIF:UpdateVisibility()
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
end)
