local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.misc.args
local AK = MER:GetModule("MER_AlreadyKnown")
local AM = MER:GetModule("MER_Automation")
local MI = MER:GetModule("MER_Misc")
local SA = MER:GetModule("MER_SpellAlert")
local CM = MER:GetModule("MER_ContextMenu")
local async = MER.Utilities.Async
local LSM = E.LSM

local _G = _G

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
		missingStats = {
			order = 9,
			type = "toggle",
			name = L["Missing Stats"],
			desc = L["Show all stats on the Character Frame"],
		},
		blockRequest = {
			order = 10,
			type = "toggle",
			name = L["Block Join Requests"],
			desc = L["|nIf checked, only popout join requests from friends and guild members."],
		},
		hotKey = {
			order = 11,
			type = "toggle",
			name = L["HotKey Above CD"],
			desc = format(
				"%s\n %s",
				L["Show hotkeys above the ElvUI cooldown animation."],
				F.CreateColorString(L["Only works with ElvUI action bar and ElvUI cooldowns."], E.db.general.valuecolor)
			),
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

options.spellAlert = {
	order = 2,
	type = "group",
	name = L["Spell Alert Scale"],
	get = function(info)
		return E.db.mui.misc.spellAlert[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc.spellAlert[info[#info]] = value
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
				return not E.db.mui.misc.spellAlert.enable
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
				return not E.db.mui.misc.spellAlert.enable
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
				return not E.db.mui.misc.spellAlert.enable
			end,
			set = function(info, value)
				E.db.mui.misc.spellAlert[info[#info]] = value
				SA:Update()
				SA:Preview()
			end,
		},
	},
}

options.scale = {
	order = 3,
	type = "group",
	name = L["Scale"],
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
				professions = {
					order = 5,
					type = "range",
					name = L["Professions Book"],
					get = function(_)
						return E.db.mui.scale.professions.scale
					end,
					set = function(_, value)
						E.db.mui.scale.professions.scale = value
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
			},
		},
	},
}

options.tags = {
	order = 7,
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
	order = 8,
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
							return format(
								"|cffff3860" .. L["Because of %s, this module will not be loaded."] .. "|r",
								AK.StopRunning
							)
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
	order = 9,
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
	order = 10,
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
	order = 15,
	type = "group",
	name = E.NewSign .. L["Context Menu"],
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
