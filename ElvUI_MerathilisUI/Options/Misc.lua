local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.misc.args
local C = MER.Utilities.Color
local AK = MER:GetModule("MER_AlreadyKnown")
local AM = MER:GetModule("MER_Automation")
local MI = MER:GetModule("MER_Misc")
local SA = MER:GetModule("MER_SpellAlert")
local CM = MER:GetModule("MER_ContextMenu")
local RIF = MER:GetModule("MER_RaidInfoFrame")
local MF = MER:GetModule("MER_MoveFrames") ---@type MoveFrames
local LL = MER:GetModule("MER_LFGList")
local LSM = E.LSM

local async = MER.Utilities.Async

local GetClassColor = GetClassColor

local C_CVar_GetCVar = C_CVar.GetCVar
local C_CVar_GetCVarBool = C_CVar.GetCVarBool
local C_CVar_SetCVar = C_CVar.SetCVar

local function GetClassColorString(class)
	local hexString = select(4, GetClassColor(class))
	return "|c" .. hexString
end

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
		hideBossBanner = {
			order = 6,
			type = "toggle",
			name = L["Hide Boss Banner"],
			desc = L["This will hide the popup, that shows loot, after you kill a boss"],
		},
		tradeTabs = {
			order = 7,
			type = "toggle",
			name = L["Trade Tabs"],
			desc = L["Enable Tabs on the Profession Frames"],
		},
		spacer = {
			order = 8,
			type = "description",
			name = " ",
		},
		blockRequest = {
			order = 9,
			type = "toggle",
			name = L["Block Join Requests"],
			desc = L["|nIf checked, only popout join requests from friends and guild members."],
		},
		focuser = {
			order = 10,
			type = "toggle",
			name = L["SHIFT - Focus"],
			desc = L["Hold SHIFT and click to set focus on the NamePlate."],
			get = function()
				return E.db.mui.misc.focuser.enable
			end,
			set = function(_, value)
				E.db.mui.misc.focuser.enable = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
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
		reshiiWrapsUpgrade = {
			order = 12,
			type = "toggle",
			name = L["Reshii Wraps Upgrade"],
			desc = L["Middle click the character back slot to open the Reshii Wraps upgrade menu."],
		},
		randomtoy = {
			order = 20,
			type = "input",
			name = L["Random Toy Macro"],
			desc = L["Creates a random toy macro."],
			get = function()
				return "/randomtoy"
			end,
			set = function()
				return
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

options.spellActivationAlert = {
	order = 3,
	type = "group",
	name = L["Spell Alert Scale"],
	get = function(info)
		return E.db.mui.misc.spellActivationAlert[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc.spellActivationAlert[info[#info]] = value
		SA:Update()
	end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Spell Alert Scale"], "orange"),
		},
		desc = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = L["Spell activation alert frame customizations."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 3,
			type = "toggle",
			name = L["Enable"],
		},
		visibility = {
			order = 4,
			type = "toggle",
			name = L["Visibility"],
			desc = L["Enable/Disable the spell activation alert frame."],
			get = function(info)
				return C_CVar_GetCVarBool("displaySpellActivationOverlays")
			end,
			set = function(info, value)
				C_CVar_SetCVar("displaySpellActivationOverlays", value and "1" or "0")
			end,
			disabled = function()
				return not E.db.mui.misc.spellActivationAlert.enable
			end,
		},
		opacity = {
			order = 5,
			type = "range",
			name = L["Opacity"],
			desc = L["Set the opacity of the spell activation alert frame. (Blizzard CVar)"],
			get = function(info)
				return tonumber(C_CVar_GetCVar("spellActivationOverlayOpacity"))
			end,
			set = function(info, value)
				C_CVar_SetCVar("spellActivationOverlayOpacity", value)
				SA:Update()
				SA:Preview()
			end,
			min = 0,
			max = 1,
			step = 0.01,
			disabled = function()
				return not E.db.mui.misc.spellActivationAlert.enable
			end,
		},
		scale = {
			order = 6,
			type = "range",
			name = L["Scale"],
			desc = L["Set the scale of the spell activation alert frame."],
			min = 0.1,
			max = 5,
			step = 0.01,
			disabled = function()
				return not E.db.mui.misc.spellActivationAlert.enable
			end,
			set = function(info, value)
				E.db.mui.misc.spellActivationAlert[info[#info]] = value
				SA:Update()
				SA:Preview()
			end,
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

do
	local examples = {}

	local className = {
		WARRIOR = L["Warrior"],
		PALADIN = L["Paladin"],
		HUNTER = L["Hunter"],
		ROGUE = L["Rogue"],
		PRIEST = L["Priest"],
		DEATHKNIGHT = L["Deathknight"],
		SHAMAN = L["Shaman"],
		MAGE = L["Mage"],
		WARLOCK = L["Warlock"],
		DRUID = L["Druid"],
		MONK = L["Monk"],
		DEMONHUNTER = L["Demonhunter"],
		EVOKER = L["Evoker"],
	}

	for index, style in pairs(F.GetClassIconStyleList()) do
		examples["classIcon_" .. style] = {
			order = 5 + index,
			name = L["Class Icon"] .. " - " .. style,
			["PLAYER_ICON"] = {
				order = 1,
				type = "description",
				image = function()
					return F.GetClassIconWithStyle(E.myclass, style), 64, 64
				end,
				width = 1,
			},
			["PLAYER_TAG"] = {
				order = 2,
				text = L["The class icon of the player's class"],
				tag = "[classicon-" .. style .. "]",
				width = 1.5,
			},
		}

		for i = 1, GetNumClasses() do
			local upperText = select(2, GetClassInfo(i))
			local coloredClassName = GetClassColorString(upperText) .. className[upperText] .. "|r"
			examples["classIcon_" .. style][upperText .. "_ALIGN"] = {
				order = 3 * i,
				type = "description",
			}
			examples["classIcon_" .. style][upperText .. "_ICON"] = {
				order = 3 * i + 1,
				type = "description",
				image = function()
					return F.GetClassIconWithStyle(upperText, style), 64, 64
				end,
				width = 1,
			}
			examples["classIcon_" .. style][upperText .. "_TAG"] = {
				order = 3 * i + 2,
				text = coloredClassName,
				tag = "[classicon-" .. style .. ":" .. strlower(upperText) .. "]",
				width = 1.5,
			}
		end

		for cat, catTable in pairs(examples) do
			options.tags.args[cat] = {
				order = catTable.order,
				type = "group",
				name = catTable.name,
				args = {},
			}

			local subIndex = 1
			for key, data in pairs(catTable) do
				if not F.In(key, { "name", "order" }) then
					options.tags.args[cat].args[key] = {
						order = data.order or subIndex,
						type = data.type or "input",
						width = data.width or "full",
						name = data.text or "",
						get = function()
							return data.tag
						end,
					}
					if data.image then
						options.tags.args[cat].args[key].image = data.image
					end
					subIndex = subIndex + 1
				end
			end
		end
	end
end

options.alreadyKnown = {
	order = 6,
	type = "group",
	name = L["Already Known"],
	get = function(info)
		return E.db.mui.misc.alreadyKnown[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc.alreadyKnown[info[#info]] = value
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
					name = function()
						if AK.StopRunning then
							local errorMsg = format(L["Because of %s, this module will not be loaded."], AK.StopRunning)
							return C.StringByTemplate(errorMsg, "rose-500")
						else
							return L["Puts a overlay on already known learnable items on vendors and AH."]
						end
					end,
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			disabled = function()
				return AK.StopRunning
			end,
			set = function(info, value)
				E.db.mui.misc.alreadyKnown[info[#info]] = value
				AK:ToggleSetting()
			end,
			width = "full",
		},
		mode = {
			order = 3,
			name = L["Mode"],
			type = "select",
			disabled = function()
				return AK.StopRunning
			end,
			values = {
				COLOR = L["Custom Color"],
				MONOCHROME = L["Monochrome"],
			},
		},
		color = {
			order = 4,
			type = "color",
			name = L["Color"],
			disabled = function()
				return AK.StopRunning
			end,
			hidden = function()
				return not (E.db.mui.misc.alreadyKnown.mode == "COLOR")
			end,
			hasAlpha = false,
			get = function(info)
				local db = E.db.mui.misc.alreadyKnown.color
				local default = P.misc.alreadyKnown.color
				return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
			end,
			set = function(info, r, g, b)
				local db = E.db.mui.misc.alreadyKnown.color
				db.r, db.g, db.b = r, g, b
			end,
		},
	},
}

options.mute = {
	order = 7,
	type = "group",
	name = L["Mute"],
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
					name = L["Disable some annoying sound effects."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			get = function(info)
				return E.db.mui.misc.mute.enable
			end,
			set = function(info, value)
				E.db.mui.misc.mute.enable = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		mount = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Mount"],
			get = function(info)
				return E.db.mui.misc.mute[info[#info - 1]][tonumber(info[#info])]
			end,
			set = function(info, value)
				E.db.mui.misc.mute[info[#info - 1]][tonumber(info[#info])] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {},
		},
		other = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Others"],
			get = function(info)
				return E.db.mui.misc.mute[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.misc.mute[info[#info - 1]][info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				["Tortollan"] = {
					order = 1,
					type = "toggle",
					name = L["Tortollan"],
					width = 1.3,
				},
				["Crying"] = {
					order = 2,
					type = "toggle",
					name = L["Crying"],
					desc = L["Mute crying sounds of all races."]
						.. "\n|cffff3860"
						.. L["It will affect the cry emote sound."]
						.. "|r",
					width = 1.3,
				},
				["Dragonriding"] = {
					order = 3,
					type = "toggle",
					name = L["Dragonriding"],
					desc = L["Mute the sound of dragonriding."],
					width = 1.3,
				},
				["Jewelcrafting"] = {
					order = 4,
					type = "toggle",
					name = L["Jewelcrafting"],
					desc = L["Mute the sound of jewelcrafting."],
					width = 1.3,
				},
			},
		},
	},
}

do
	for id in pairs(P.misc.mute.mount) do
		async.WithSpellID(id, function(spell)
			local icon = spell:GetSpellTexture()
			local name = spell:GetSpellName()

			local iconString = F.GetIconString(icon, 12, 12)

			options.mute.args.mount.args[tostring(id)] = {
				order = id,
				type = "toggle",
				name = iconString .. " " .. name,
				width = 1.5,
			}
		end)
	end

	local itemList = {
		["Smolderheart"] = {
			id = 180873,
			desc = nil,
		},
		["Elegy of the Eternals"] = {
			id = 188270,
			desc = "|cffff3860" .. L["It will also affect the crying sound of all female Blood Elves."] .. "|r",
		},
	}

	for name, data in pairs(itemList) do
		async.WithItemID(data.id, function(item)
			local icon = item:GetItemIcon()
			local name = item:GetItemName()
			local color = item:GetItemQualityColor()

			local iconString = F.GetIconString(icon)
			local nameString = F.CreateColorString(name, color)

			options.mute.args.other.args[name] = {
				order = data.id,
				type = "toggle",
				name = iconString .. " " .. nameString,
				desc = data.desc,
				width = 1.3,
			}
		end)
	end
end

options.automation = {
	order = 8,
	type = "group",
	name = L["Automation"],
	get = function(info)
		return E.db.mui.misc.automation[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc.automation[info[#info]] = value
		AM:ProfileUpdate()
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
					name = L["Automate your game life."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.mui.misc.automation[info[#info]] = value
			end,
			width = "full",
		},
		hideWorldMapAfterEnteringCombat = {
			order = 3,
			type = "toggle",
			name = L["Auto Hide Map"],
			desc = L["Automatically close world map if player enters combat."],
			disabled = function()
				return not E.db.mui.misc.automation.enable
			end,
			width = 1.5,
		},
		hideBagAfterEnteringCombat = {
			order = 4,
			type = "toggle",
			name = L["Auto Hide Bag"],
			desc = L["Automatically close bag if player enters combat."],
			disabled = function()
				return not E.db.mui.misc.automation.enable
			end,
			width = 1.5,
		},
		acceptResurrect = {
			order = 5,
			type = "toggle",
			name = L["Accept Resurrect"],
			desc = L["Accept resurrect from other player automatically when you not in combat."],
			disabled = function()
				return not E.db.mui.misc.automation.enable
			end,
			width = 1.5,
		},
		acceptCombatResurrect = {
			order = 6,
			type = "toggle",
			name = L["Accept Combat Resurrect"],
			desc = L["Accept resurrect from other player automatically when you in combat."],
			disabled = function()
				return not E.db.mui.misc.automation.enable
			end,
			width = 1.5,
		},
		confirmSummon = {
			order = 7,
			type = "toggle",
			name = L["Confirm Summon"],
			desc = L["Confirm summon from other player automatically."],
			disabled = function()
				return not E.db.mui.misc.automation.enable
			end,
			width = 1.5,
		},
	},
}

options.contextMenu = {
	order = 9,
	type = "group",
	name = L["Context Menu"],
	get = function(info)
		return E.db.mui.misc.contextMenu[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc.contextMenu[info[#info]] = value
		CM:ProfileUpdate()
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
					name = L["Add features to the context menu."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
		},
		sectionTitle = {
			order = 2,
			type = "toggle",
			name = L["Section Title"],
			desc = L["Add a styled section title to the context menu."],
		},
		align = {
			order = 3,
			type = "description",
			name = " ",
			width = "full",
		},
		normalConfig = {
			order = 4,
			type = "group",
			inline = true,
			name = L["General"],
			disabled = function()
				return not E.db.mui.misc.contextMenu.enable
			end,
			args = {
				guildInvite = {
					order = 1,
					type = "toggle",
					name = L["Guild Invite"],
				},
				who = {
					order = 2,
					type = "toggle",
					name = L["Who"],
				},
				reportStats = {
					order = 3,
					type = "toggle",
					name = L["Report Stats"],
				},
			},
		},
		armoryConfig = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Armory"],
			disabled = function()
				return not E.db.mui.misc.contextMenu.enable
			end,
			args = {
				armory = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function(info)
						return E.db.mui.misc.contextMenu[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.misc.contextMenu[info[#info]] = value
						CM:ProfileUpdate()
					end,
				},
				setArea = {
					order = 2,
					type = "select",
					name = L["Set Region"],
					desc = L["If the game language is different from the primary language in this server, you need to specify which area you play on."],
					get = function()
						local list = E.db.mui.misc.contextMenu.armoryOverride
						if list[E.myrealm] then
							return list[E.myrealm]
						else
							return "NONE"
						end
					end,
					set = function(_, value)
						local list = E.db.mui.misc.contextMenu.armoryOverride
						if value == "NONE" then
							list[E.myrealm] = nil
						else
							list[E.myrealm] = value
						end
					end,
					values = {
						NONE = L["Auto-detect"],
						tw = L["Taiwan"],
						kr = L["Korea"],
						us = L["Americas & Oceania"],
						eu = L["Europe"],
					},
				},
				list = {
					order = 3,
					type = "select",
					name = L["Server List"],
					get = function()
						return customListSelected
					end,
					set = function(_, value)
						customListSelected = value
					end,
					values = function()
						local list = E.db.mui.misc.contextMenu.armoryOverride

						local displayName = {
							tw = L["Taiwan"],
							kr = L["Korea"],
							us = L["Americas & Oceania"],
							eu = L["Europe"],
						}

						local result = {}
						for key, value in pairs(list) do
							result[key] = key .. " > " .. displayName[value]
						end

						return result
					end,
					width = 2,
				},
				deleteButton = {
					order = 4,
					type = "execute",
					name = L["Delete"],
					desc = L["Delete the selected NPC."],
					func = function()
						if customListSelected then
							local list = E.db.mui.misc.contextMenu.armoryOverride
							if list[customListSelected] then
								list[customListSelected] = nil
							end
						end
					end,
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

options.screenshot = {
	order = 12,
	type = "group",
	name = L["Screenshot"],
	get = function(info)
		return E.db.mui.misc.screenshot[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc.screenshot[info[#info]] = value
		E:StaticPopup_Show("CONFIG_RL")
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Screenshot"], "orange"),
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
		},
		printMsg = {
			order = 2,
			type = "toggle",
			name = L["Print Message"],
			desc = L["Prints a message in the chat when you take a screenshot."],
			disabled = function()
				return not E.db.mui.misc.screenshot.enable
			end,
		},
		hideUI = {
			order = 3,
			type = "toggle",
			name = L["Hide UI"],
			desc = L["Hides the UI when you take a screenshot."],
			disabled = function()
				return not E.db.mui.misc.screenshot.enable
			end,
		},
		types = {
			order = 4,
			type = "group",
			inline = true,
			name = F.cOption(L["Types"], "orange"),
			guiInline = true,
			disabled = function()
				return not E.db.mui.misc.screenshot.enable
			end,
			args = {
				achievementEarned = {
					order = 1,
					type = "toggle",
					name = L["Achievement Earned"],
					desc = L["Takes a screenshot when you earn an achievement."],
					disabled = function()
						return not E.db.mui.misc.screenshot.enable
					end,
				},
				challengeModeCompleted = {
					order = 2,
					type = "toggle",
					name = L["Challenge Mode Completed"],
					desc = L["Takes a screenshot when you complete a challenge mode."],
					disabled = function()
						return not E.db.mui.misc.screenshot.enable
					end,
				},
				playerLevelUp = {
					order = 3,
					type = "toggle",
					name = L["Player Level Up"],
					desc = L["Takes a screenshot when you level up."],
					disabled = function()
						return not E.db.mui.misc.screenshot.enable
					end,
				},
				playerDead = {
					order = 4,
					type = "toggle",
					name = L["Player Dead"],
					desc = L["Takes a screenshot when you die."],
					disabled = function()
						return not E.db.mui.misc.screenshot.enable
					end,
				},
			},
		},
	},
}

options.moveFrames = {
	order = 13,
	type = "group",
	name = L["Move Frames"],
	get = function(info)
		return E.private.mui.misc.moveFrames[info[#info]]
	end,
	set = function(info, value)
		E.private.mui.misc.moveFrames[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		desc = {
			order = 0,
			type = "group",
			inline = true,
			name = L["Description"],
			disabled = false,
			args = {
				feature = {
					order = 1,
					type = "description",
					name = function()
						if MF.StopRunning then
							local errorMsg = format(L["Because of %s, this module will not be loaded."], MF.StopRunning)
							return C.StringByTemplate(errorMsg, "rose-500")
						else
							return L["This module provides the feature that repositions the frames with drag and drop."]
						end
					end,
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			disabled = function()
				return MF.StopRunning
			end,
		},
		elvUIBags = {
			order = 2,
			type = "toggle",
			name = L["Move ElvUI Bags"],
			disabled = function()
				return not MF:IsRunning()
			end,
		},
		tradeSkillMasterCompatible = {
			order = 3,
			type = "toggle",
			name = L["TSM Compatible"],
			desc = L["Fix the merchant frame showing when you using Trade Skill Master."],
			disabled = function()
				return not MF:IsRunning()
			end,
		},
		remember = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Remember Positions"],
			disabled = function()
				return not MF:IsRunning()
			end,
			args = {
				rememberPositions = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					set = function(info, value)
						E.private.mui.misc.moveFrames[info[#info]] = value
					end,
				},
				clearHistory = {
					order = 2,
					type = "execute",
					name = L["Clear History"],
					func = function()
						E.private.mui.misc.moveFrames.framePositions = {}
					end,
				},
				notice = {
					order = 999,
					type = "description",
					name = format(
						"\n|cffff3860%s|r %s",
						L["Notice"],
						format(
							L["%s may cause some frames to get messed, but you can use %s button to reset frames."],
							L["Remember Positions"],
							F.CreateColorString(L["Clear History"], E.db.general.valuecolor)
						)
					),
					fontSize = "medium",
				},
			},
		},
		credits = {
			order = 5,
			type = "group",
			name = F.cOption(L["Credits"], "orange"),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "description",
					name = F.GetMERStyleText("ElvUI_Windtools"),
				},
			},
		},
	},
}

options.exitPhaseDiving = {
	order = 14,
	type = "group",
	name = L["Exit Phase Diving"],
	get = function(info)
		return E.db.mui.misc.exitPhaseDiving[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc.exitPhaseDiving[info[#info]] = value
		MI:UpdateExitPhaseDivingButton()
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
					name = L["Add a button to exit phase diving."]
						.. "\n"
						.. L["You can use ElvUI Mover to reposition it."]
						.. "\n\n"
						.. C.StringByTemplate(
							L["Due to Blizzard restrictions, the button area cannot be clicked through even when the button is hidden."],
							"yellow-400"
						),
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		width = {
			order = 3,
			type = "range",
			name = L["Width"],
			min = 5,
			max = 1000,
			step = 1,
			disabled = function()
				return not E.db.mui.misc.exitPhaseDiving.enable
			end,
		},
		height = {
			order = 4,
			type = "range",
			name = L["Height"],
			min = 5,
			max = 1000,
			step = 1,
			disabled = function()
				return not E.db.mui.misc.exitPhaseDiving.enable
			end,
		},
		credits = {
			order = 5,
			type = "group",
			name = F.cOption(L["Credits"], "orange"),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "description",
					name = F.GetMERStyleText("ElvUI_Windtools"),
				},
			},
		},
	},
}

local SampleStrings = {}
do
	local icons = ""
	icons = icons .. E:TextureString(I.Media.RoleIcons.SunUITank, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.SunUIHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.SunUIDPS, ":16:16")
	SampleStrings.sunui = icons

	icons = ""
	icons = icons .. E:TextureString(I.Media.RoleIcons.LynUITank, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.LynUIHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.LynUIDPS, ":16:16")
	SampleStrings.lynui = icons

	icons = ""
	icons = icons .. E:TextureString(I.Media.RoleIcons.SVUITank, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.SVUIHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.SVUIDPS, ":16:16")
	SampleStrings.svui = icons

	icons = ""
	icons = icons .. E:TextureString(E.Media.Textures.Tank, ":16:16") .. " "
	icons = icons .. E:TextureString(E.Media.Textures.Healer, ":16:16") .. " "
	icons = icons .. E:TextureString(E.Media.Textures.DPS, ":16:16")
	SampleStrings.elvui = icons

	icons = ""
	icons = icons .. E:TextureString(I.Media.RoleIcons.CustomTank, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.CustomHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.CustomDPS, ":16:16")
	SampleStrings.custom = icons

	icons = ""
	icons = icons .. E:TextureString(I.Media.RoleIcons.GlowTank, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.GlowHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.GlowDPS, ":16:16")
	SampleStrings.glow = icons

	icons = ""
	icons = icons .. E:TextureString(I.Media.RoleIcons.MainTank, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.MainHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.MainDPS, ":16:16")
	SampleStrings.main = icons

	icons = ""
	icons = icons .. E:TextureString(I.Media.RoleIcons.WhiteTank, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.WhiteHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.WhiteDPS, ":16:16")
	SampleStrings.white = icons

	icons = ""
	icons = icons .. E:TextureString(I.Media.RoleIcons.MaterialTank, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.MaterialHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.MaterialDPS, ":16:16")
	SampleStrings.material = icons

	icons = ""
	icons = icons .. E:TextureString(I.Media.RoleIcons.ElvUITank, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.ElvUIHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(I.Media.RoleIcons.ElvUIDPS, ":16:16")
	SampleStrings.elvui_old = icons
end

options.lfgList = {
	order = 15,
	type = "group",
	name = E.NewSign .. L["LFG List"],
	get = function(info)
		return E.db.mui.misc.lfgList[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc.lfgList[info[#info]] = value
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
					name = function()
						if LL.StopRunning then
							local errorMsg = format(L["Because of %s, this module will not be loaded."], LL.StopRunning)
							return C.StringByTemplate(errorMsg, "rose-500")
						else
							return L["QoLs for LFG list."]
						end
					end,
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		icon = {
			order = 3,
			type = "group",
			name = L["Icon"],
			disabled = function()
				return not E.db.mui.misc.lfgList.enable
			end,
			get = function(info)
				return E.db.mui.misc.lfgList.icon[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.misc.lfgList.icon[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				leader = {
					order = 2,
					type = "toggle",
					name = L["Leader"],
					desc = L["Add an indicator for the leader."],
				},
				reskin = {
					order = 3,
					type = "toggle",
					name = L["Reskin Icon"],
					desc = L["Change role icons."],
				},
				pack = {
					order = 4,
					type = "select",
					name = L["Style"],
					desc = L["Change the icons that indicate the role."],
					hidden = function()
						return not E.db.mui.misc.lfgList.reskin
					end,
					values = {
						SPEC = L["Specialization"],
						SQUARE = L["Square"],
						SUNUI = SampleStrings.sunui,
						LYNUI = SampleStrings.lynui,
						SVUI = SampleStrings.svui,
						CUSTOM = SampleStrings.custom,
						GLOW = SampleStrings.glow,
						MAIN = SampleStrings.main,
						WHITE = SampleStrings.white,
						MATERIAL = SampleStrings.material,
						BLIZZARD = SampleStrings.blizzard,
						ELVUI_OLD = SampleStrings.elvui_old,
						DEFAULT = SampleStrings.elvui,
					},
				},
				border = {
					order = 5,
					type = "toggle",
					name = L["Border"],
				},
				size = {
					order = 6,
					type = "range",
					name = L["Size"],
					min = 1,
					max = 20,
					step = 1,
				},
				alpha = {
					order = 7,
					type = "range",
					name = L["Alpha"],
					min = 0,
					max = 1,
					step = 0.01,
				},
				hideDefaultClassCircle = {
					order = 8,
					type = "toggle",
					name = L["Hide default class circles"],
					desc = L["Disable the default class-colored background circle in LFG Lists, leaving only the skinned icons from preferences"],
				},
			},
		},
		line = {
			order = 4,
			type = "group",
			name = L["Class Line"],
			disabled = function()
				return not E.db.mui.misc.lfgList.enable
			end,
			get = function(info)
				return E.db.mui.misc.lfgList.line[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.misc.lfgList.line[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add a line in class color."],
				},
				tex = {
					order = 2,
					type = "select",
					name = L["Texture"],
					dialogControl = "LSM30_Statusbar",
					values = LSM:HashTable("statusbar"),
				},
				width = {
					order = 4,
					type = "range",
					name = L["Width"],
					min = 1,
					max = 20,
					step = 1,
				},
				height = {
					order = 4,
					type = "range",
					name = L["Height"],
					min = 1,
					max = 20,
					step = 1,
				},
				offsetX = {
					order = 5,
					type = "range",
					name = L["X-Offset"],
					min = -20,
					max = 20,
					step = 1,
				},
				offsetY = {
					order = 6,
					type = "range",
					name = L["Y-Offset"],
					min = -20,
					max = 20,
					step = 1,
				},
				alpha = {
					order = 7,
					type = "range",
					name = L["Alpha"],
					min = 0,
					max = 1,
					step = 0.01,
				},
			},
		},
		additionalText = {
			order = 5,
			type = "group",
			name = L["Additional Text"],
			disabled = function()
				return not E.db.mui.misc.lfgList.enable
			end,
			get = function(info)
				return E.db.mui.misc.lfgList.additionalText[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.misc.lfgList.additionalText[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add some additional information into title or description."],
					width = "full",
				},
				target = {
					order = 2,
					type = "select",
					name = L["Target"],
					values = {
						TITLE = L["Title"],
						DESC = L["Description"],
					},
					width = 0.8,
				},
				shortenDescription = {
					order = 3,
					type = "toggle",
					name = L["Shorten Description"],
					desc = L["Remove useless part from description."],
					width = 1.5,
				},
				template = {
					order = 4,
					type = "input",
					name = L["Template"],
					desc = function()
						return format(
							"%s = %s\n%s = %s\n%s = %s",
							C.StringByTemplate("{{score}}", "teal-400"),
							L["Leader Score"],
							C.StringByTemplate("{{best}}", "teal-400"),
							L["Leader Best Run"],
							C.StringByTemplate("{{text}}", "teal-400"),
							L["Original Text"]
						)
					end,
					width = "full",
				},
			},
		},
		partyKeystone = {
			order = 6,
			type = "group",
			name = L["Party Keystone"],
			disabled = function()
				return not E.db.mui.misc.lfgList.enable
			end,
			get = function(info)
				return E.db.mui.misc.lfgList.partyKeystone[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.misc.lfgList.partyKeystone[info[#info]] = value
				LL:UpdatePartyKeystoneFrame()
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add an additional frame to show party members' keystone."],
				},
				font = {
					order = 6,
					type = "group",
					name = L["Font Setting"],
					inline = true,
					get = function(info)
						return E.db.mui.misc.lfgList.partyKeystone[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.mui.misc.lfgList.partyKeystone[info[#info - 1]][info[#info]] = value
						LL:UpdatePartyKeystoneFrame()
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
							values = {
								NONE = L["None"],
								OUTLINE = L["OUTLINE"],
								THICKOUTLINE = L["THICKOUTLINE"],
								SHADOW = L["SHADOW"],
								SHADOWOUTLINE = L["SHADOWOUTLINE"],
								SHADOWTHICKOUTLINE = L["SHADOWTHICKOUTLINE"],
								MONOCHROME = L["MONOCHROME"],
								MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
								MONOCHROMETHICKOUTLINE = L["MONOCHROMETHICKOUTLINE"],
							},
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
		rightPanel = {
			order = 7,
			type = "group",
			name = L["Right Panel"],
			disabled = function()
				return not E.db.mui.misc.lfgList.enable
			end,
			get = function(info)
				return E.db.mui.misc.lfgList.rightPanel[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.misc.lfgList.rightPanel[info[#info]] = value
				LL:UpdateRightPanel()
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add an additional frame to filter the groups."],
				},
				autoRefresh = {
					order = 2,
					type = "toggle",
					name = L["Auto Refresh"],
					desc = L["Automatically refresh the list after you changing the filter."],
				},
				automations = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Automation"],
					args = {
						autoJoin = {
							order = 3,
							type = "toggle",
							name = L["Auto Join"],
							desc = L["Automatically join the dungeon when clicking on the LFG row, without asking for role confirmation."],
						},
						skipConfirmation = {
							order = 4,
							type = "toggle",
							name = L["Skip Confirmation"],
							desc = L["Skip signup confirmation during automatic join on listing click"],
						},
					},
				},
				adjustFontSize = {
					order = 4,
					type = "range",
					name = L["Font Size Adjustment"],
					desc = L["Adjust the font size of the right panel."],
					min = -10,
					max = 20,
					step = 1,
					set = function(info, value)
						E.db.mui.misc.lfgList.rightPanel[info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
				},
				filtersBehaviour = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Filters"],
					args = {
						feature = {
							order = 1,
							type = "description",
							name = format(
								"%s\n|cffff0000%s|r\n\n%s\n%s",
								L["Automatic filters behaviour"],
								format(
									"!! - %s: %s - !!",
									L["WARNING"],
									L["Change this only if you know what you are doing"]
								),
								format(
									"- |cff00aaff%s|r: %s",
									L["Unchecked"],
									L["When selecting 'Has Tank' / 'Has Healer', the 'Role Available' filter is disabled automatically and vice-versa."]
								),
								format(
									"- |cff00aaff%s|r: %s",
									L["Checked"],
									L["No automatic removal of filters, might cause empty results if you already have the roles in your party."]
								)
							),
							fontSize = "medium",
						},
						disableSafeFilters = {
							order = 2,
							type = "toggle",
							name = L["Disable safe filters"],
							desc = L["Disable the default behaviour that prevents inconsistent filters with flags 'Has Tank', 'Has Healer' and 'Role Available'"],
						},
					},
				},
			},
		},
	},
}
