local MER, F, E, L, V, P, G = unpack(select(2, ...))
local options = MER.options.misc.args
local AK = MER:GetModule('MER_AlreadyKnown')
local MI = MER:GetModule('MER_Misc')
local SA = MER:GetModule('MER_SpellAlert')
local CU = MER:GetModule('MER_Cursor')
local LL = MER:GetModule('MER_LFGInfo')
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
			name = F.cOption(L["General"], 'orange'),
		},
		gmotd = {
			order = 2,
			type = "toggle",
			name = L.GUILD_MOTD_LABEL2,
			desc = L["Display the Guild Message of the Day in an extra window, if updated."],
		},
		guildNewsItemLevel = {
			order = 3,
			type = "toggle",
			name = L["Guild News Item Level"],
			desc = L["Add Item level Infos in Guild News"],
			get = function(info) return E.private.mui.misc[info[#info]] end,
			set = function(info, value) E.private.mui.misc[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
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
		quickDelete = {
			order = 7,
			type = "toggle",
			name = L["Quick Delete"],
			desc = L["This will add the 'DELETE' text to the Item Delete Dialog."],
		},
		quickMenu = {
			order = 8,
			type = "toggle",
			name = L["Quick Menu"],
			desc = L["Shows additional Buttons on your Dropdown for quick actions."],
		},
		selectQuestReward = {
			order = 8,
			type = "toggle",
			name = L["Highest Quest Reward"],
			desc = L["Automatically select the item with the highest reward."],
			get = function(info) return E.db.mui.misc.quest[info[#info]] end,
			set = function(info, value) E.db.mui.misc.quest[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		},
		tradeTabs = {
			order = 9,
			type = "toggle",
			name = L["Trade Tabs"],
			desc = L["Creates additional tabs on the Profession Frame"],
		},
		spacer = {
			order = 10,
			type = "description",
			name = " ",
		},
		randomtoy = {
			order = 11,
			type = "input",
			name = L["Random Toy Macro"],
			desc = L["Creates a random toy macro."],
			get = function() return "/randomtoy" end,
			set = function() return end,
		},
	},
}

options.spellAlert = {
	order = 2,
	type = "group",
	name = L["Spell Alert Scale"],
	hidden = not E.Retail,
	get = function(info) return
		E.db.mui.misc.spellAlert[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc.spellAlert[info[#info]] = value
		SA:Update()
	end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Spell Alert Scale"], 'orange'),
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
					fontSize = "medium"
				}
			}
		},
		enable = {
			order = 3,
			type = "toggle",
			name = L["Enable"]
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
			min = 0, max = 1, step = 0.01,
			disabled = function()
				return not E.db.mui.misc.spellAlert.enable
			end,
		},
		scale = {
			order = 6,
			type = "range",
			name = L["Scale"],
			desc = L["Set the scale of the spell activation alert frame."],
			min = 0.1, max = 5, step = 0.01,
			disabled = function()
				return not E.db.mui.misc.spellAlert.enable
			end,
			set = function(info, value)
				E.db.mui.misc.spellAlert[info[#info]] = value
				SA:Update()
				SA:Preview()
			end,
			disabled = function()
				return not E.db.mui.misc.spellAlert.enable
			end,
		},
	},
}

options.cursor = {
	order = 3,
	type = "group",
	name = L["Flashing Cursor"],
	get = function(info) return
		E.db.mui.misc.cursor[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc.cursor[info[#info]] = value
		CU:UpdateColor()
	end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Flashing Cursor"], 'orange'),
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		colorType = {
			order = 3,
			name = L["Color Type"],
			type = "select",
			disabled = function() return not E.db.mui.misc.cursor.enable end,
			set = function(info, value) E.db.mui.misc.cursor[info[#info]] = value; end,
			values = {
				["DEFAULT"] = L["Default"],
				["CLASS"] = L["Class"],
				["CUSTOM"] = L["Custom"],
			},
		},
		customColor = {
			type = "color",
			order = 4,
			name = L["Custom Color"],
			disabled = function() return not E.db.mui.misc.cursor.enable or E.db.mui.misc.cursor.colorType ~= "CUSTOM" end,
			get = function(info)
				local t = E.db.mui.misc.cursor[info[#info]]
				local d = P.misc.cursor[info[#info]]
				return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
			end,
			set = function(info, r, g, b)
				E.db.mui.misc.cursor[info[#info]] = {}
				local t = E.db.mui.misc.cursor[info[#info]]
				t.r, t.g, t.b = r, g, b
			end,
		},
	},
}

options.lfgInfo = {
	order = 4,
	name = L["LFG Info"],
	type = "group",
	get = function(info)
		return E.db.mui.misc.lfgInfo[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.misc.lfgInfo[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	hidden = not E.Retail,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["LFG Info"], 'orange'),
		},
		feature = {
			order = 2,
			type = "description",
			name = function()
				if LL.StopRunning then
					return format(
						"|cffff3860" .. L["Because of %s, this module will not be loaded."] .. "|r",
						LL.StopRunning
					)
				else
					return L["Enhancments for the LFG list."]
				end
			end,
			fontSize = "medium"
		},
		enable = {
			order = 3,
			type = "toggle",
			name = L["Enable"],
			desc = L["Add LFG group info to tooltip."]
		},
		title = {
			order = 4,
			type = "toggle",
			name = L["Add Title"],
			desc = L["Display an additional title."]
		},
		mode = {
			order = 5,
			name = L["Mode"],
			type = "select",
			values = {
				NORMAL = L["Normal"],
				COMPACT = L["Compact"]
			},
		},
		icon = {
			order = 6,
			type = "group",
			name = L["Icon"],
			guiInline = true,
			get = function(info)
				return E.db.mui.misc.lfgInfo.icon[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.misc.lfgInfo.icon[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				reskin = {
					order = 1,
					type = "toggle",
					name = L["Reskin Icon"],
					desc = L["Change role icons."]
				},
				border = {
					order = 3,
					type = "toggle",
					name = L["Border"]
				},
				size = {
					order = 4,
					type = "range",
					name = L["Size"],
					min = 1,
					max = 20,
					step = 1
				},
				alpha = {
					order = 5,
					type = "range",
					name = L["Alpha"],
					min = 0,
					max = 1,
					step = 0.01
				},
			},
		},
		line = {
			order = 7,
			type = "group",
			name = L["Line"],
			guiInline = true,
			get = function(info)
				return E.db.mui.misc.lfgInfo.line[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.misc.lfgInfo.line[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add a line in class color."]
				},
				tex = {
					order = 2,
					type = "select",
					name = L["Texture"],
					dialogControl = "LSM30_Statusbar",
					values = LSM:HashTable("statusbar")
				},
				width = {
					order = 4,
					type = "range",
					name = L["Width"],
					min = 1, max = 20, step = 1
				},
				height = {
					order = 4,
					type = "range",
					name = L["Height"],
					min = 1, max = 20, step = 1
				},
				offsetX = {
					order = 5,
					type = "range",
					name = L["X-Offset"],
					min = -20, max = 20, step = 1
				},
				offsetY = {
					order = 6,
					type = "range",
					name = L["Y-Offset"],
					min = -20, max = 20, step = 1
				},
				alpha = {
					order = 7,
					type = "range",
					name = L["Alpha"],
					min = 0, max = 1, step = 0.01
				},
			},
		},
	},
}
options.tags = {
	order = 6,
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
					fontSize = "medium"
				}
			}
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
		EVOKER = L["Evoker"]
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
				width = 1
			},
			["PLAYER_TAG"] = {
				order = 2,
				text = L["The class icon of the player's class"],
				tag = "[classicon-" .. style .. "]",
				width = 1.5
			}
		}

		if E.Retail then
			for i = 1, GetNumClasses() do
				local upperText = select(2, GetClassInfo(i))
				local coloredClassName = GetClassColorString(upperText) .. className[upperText] .. "|r"
				examples["classIcon_" .. style][upperText .. "_ALIGN"] = {
					order = 3 * i,
					type = "description"
				}
				examples["classIcon_" .. style][upperText .. "_ICON"] = {
					order = 3 * i + 1,
					type = "description",
					image = function()
						return F.GetClassIconWithStyle(upperText, style), 64, 64
					end,
					width = 1
				}
				examples["classIcon_" .. style][upperText .. "_TAG"] = {
					order = 3 * i + 2,
					text = coloredClassName,
					tag = "[classicon-" .. style .. ":" .. strlower(upperText) .. "]",
					width = 1.5
				}
			end
		end

		for cat, catTable in pairs(examples) do
			options.tags.args[cat] = {
				order = catTable.order,
				type = "group",
				name = catTable.name,
				args = {}
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
						end
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
	order = 7,
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
					fontSize = "medium"
				}
			}
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
			width = "full"
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
				MONOCHROME = L["Monochrome"]
			}
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
			end
		}
	}
}

options.mute = {
	order = 8,
	type = "group",
	name = E.NewSign..L["Mute"],
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
					fontSize = "medium"
				}
			}
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
			end
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
			args = {}
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
					width = 1.3
				},
				["Crying"] = {
					order = 2,
					type = "toggle",
					name = L["Crying"],
					desc = L["Mute crying sounds of all races."] ..
						"\n|cffff3860" .. L["It will affect the cry emote sound."] .. "|r",
					width = 1.3
				},
				["Dragonriding"] = {
					order = 3,
					type = "toggle",
					name = L["Dragonriding"],
					desc = L["Mute the sound of dragonriding."],
					width = 1.3
				},
				["Jewelcrafting"] = {
					order = 4,
					type = "toggle",
					name = L["Jewelcrafting"],
					desc = L["Mute the sound of jewelcrafting."],
					width = 1.3
				}
			}
		}
	}
}

do
	for id in pairs(P.misc.mute.mount) do
		async.WithSpellID(
			id,
			function(spell)
				local icon = spell:GetSpellTexture()
				local name = spell:GetSpellName()

				local iconString = F.GetIconString(icon, 12, 12)

				options.mute.args.mount.args[tostring(id)] = {
					order = id,
					type = "toggle",
					name = iconString .. " " .. name,
					width = 1.5
				}
			end
		)
	end

	local itemList = {
		["Smolderheart"] = {
			id = 180873,
			desc = nil
		},
		["Elegy of the Eternals"] = {
			id = 188270,
			desc = "|cffff3860" .. L["It will also affect the crying sound of all female Blood Elves."] .. "|r"
		}
	}

	for name, data in pairs(itemList) do
		async.WithItemID(
			data.id,
			function(item)
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
					width = 1.3
				}
			end
		)
	end
end
