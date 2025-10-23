local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args
local module = MER:GetModule("MER_Announcement")
local QP = MER:GetModule("MER_QuestProgress")
local C = MER.Utilities.Color

---@cast QP QuestProgress

local format = format
local gsub = gsub
local pairs = pairs
local strjoin = strjoin
local tonumber = tonumber

local GetSpellLink = C_Spell.GetSpellLink
local GetSpellName = C_Spell.GetSpellName

local function ImportantColorString(s)
	return C.StringByTemplate(s, "blue-400")
end

local function FormatDesc(code, helpText)
	return ImportantColorString(code) .. " = " .. helpText
end

options.announcement = {
	type = "group",
	name = L["Announcement"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Announcement"], "orange"),
		},
	},
}

options.announcement.args.enable = {
	order = 2,
	type = "toggle",
	get = function(info)
		return E.db.mui.announcement[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.announcement[info[#info]] = value
		module:ProfileUpdate()
	end,
	name = L["Enable"],
}

options.announcement.args.quest = {
	order = 3,
	type = "group",
	name = L["Quest"],
	get = function(info)
		return E.db.mui.announcement[info[#info - 1]][info[#info]]
	end,
	set = function(info, value)
		E.db.mui.announcement[info[#info - 1]][info[#info]] = value
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
					name = L["Let your teammates know the progress of quests."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.mui.announcement[info[#info - 1]][info[#info]] = value
				SB:ProfileUpdate()
			end,
		},
		includeDetails = {
			order = 3,
			type = "toggle",
			name = L["Include Details"],
			desc = L["Announce every time the progress has been changed."],
		},
		template = {
			order = 4,
			type = "input",
			name = L["Message Template"],
			desc = strjoin(
				"\n",
				L["The template for rendering announcement message."],
				format(L["The template of each element can be customized in %s module."], L["Quest Progress"]),
				"",
				F.GetMERStyleText(L["Template Elements"]),
				FormatDesc("{{level}}", L["Quest level"]),
				FormatDesc("{{daily}}", L["Daily quest label"]),
				FormatDesc("{{weekly}}", L["Weekly quest label"]),
				FormatDesc("{{link}}", L["Quest link"]),
				FormatDesc("{{tag}}", L["Quest tags (Quest series)"]),
				FormatDesc("{{progress}}", L["Quest progress (including objectives)"]),
				FormatDesc("{{title}}", L["Quest title"]),
				FormatDesc("{{suggestedGroup}}", L["Suggested group size"])
			),
			width = "full",
		},
		example = {
			order = 5,
			type = "description",
			name = function()
				local context = QP:GetTestContext()
				context.progress = L["Test Target"] .. ": 3/10"
				local message = QP:RenderTemplate(E.db.mui.announcement.quest.template, context)
				return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
			end,
		},
		useDefault = {
			order = 6,
			type = "execute",
			name = L["Default"],
			desc = L["Reset the template to default value."],
			func = function(info)
				E.db.mui.announcement.quest.template = P.announcement.quest.template
			end,
		},
		channel = {
			order = 7,
			type = "group",
			inline = true,
			name = L["Channel"],
			get = function(info)
				return E.db.mui.announcement[info[#info - 2]][info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.announcement[info[#info - 2]][info[#info - 1]][info[#info]] = value
			end,
			args = {
				party = {
					order = 1,
					name = L["In Party"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				instance = {
					order = 2,
					name = L["In Instance"],
					type = "select",
					values = {
						NONE = L["None"],
						PARTY = L["Party"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						INSTANCE_CHAT = L["Instance"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				raid = {
					order = 3,
					name = L["In Raid"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						RAID = L["Raid"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
			},
		},
	},
}

options.announcement.args.utility = {
	order = 4,
	type = "group",
	name = L["Utility"],
	get = function(info)
		return E.db.mui.announcement[info[#info - 1]][info[#info]]
	end,
	set = function(info, value)
		E.db.mui.announcement[info[#info - 1]][info[#info]] = value
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
					name = L["Send the use of portals, ritual of summoning, feasts, etc."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.mui.announcement[info[#info - 1]][info[#info]] = value
				module:ResetAuthority()
			end,
		},
		channel = {
			order = 3,
			name = L["Channel"],
			type = "group",
			inline = true,
			get = function(info)
				return E.db.mui.announcement.utility[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.announcement.utility[info[#info - 1]][info[#info]] = value
				module:ResetAuthority()
			end,
			args = {
				solo = {
					order = 1,
					name = L["Solo"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				party = {
					order = 2,
					name = L["In Party"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				instance = {
					order = 3,
					name = L["In Instance"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						INSTANCE_CHAT = L["Instance"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				raid = {
					order = 4,
					name = L["In Raid"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						RAID = L["Raid"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
			},
		},
	},
}

do
	local categoryLocales = {
		feasts = L["Feasts"],
		bots = L["Bots"],
		toys = L["Toys"],
		portals = L["Portals"],
	}

	local specialExampleSpell = {
		feasts = 286050,
		bots = 67826,
		toys = 61031,
		portals = 10059,
	}

	local spellOptions = options.announcement.args.utility.args
	local spellOrder = 10
	local categoryOrder = 50
	for categoryOrId, config in pairs(P.announcement.utility.spells) do
		local groupName, groupOrder, exampleSpellId
		local id = tonumber(categoryOrId)
		if id then
			groupName = GetSpellName(id)
			exampleSpellId = id
			groupOrder = spellOrder
			spellOrder = spellOrder + 1
		else
			groupName = categoryLocales[categoryOrId]
			exampleSpellId = specialExampleSpell[categoryOrId]
			groupOrder = categoryOrder
			categoryOrder = categoryOrder + 1
		end

		exampleSpellId = exampleSpellId or 20484

		spellOptions[categoryOrId] = {
			order = groupOrder,
			name = groupName,
			type = "group",
			get = function(info)
				return E.db.mui.announcement.utility.spells[categoryOrId][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.announcement.utility.spells[categoryOrId][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				includePlayer = {
					order = 2,
					type = "toggle",
					name = L["Include Player"],
					desc = L["Uncheck this box, it will not send message if you cast the spell."],
				},
				raidWarning = {
					order = 3,
					type = "toggle",
					name = L["Raid Warning"],
					desc = L["If you have privilege, it would the message to raid warning(/rw) rather than raid(/r)."],
				},
				text = {
					order = 4,
					type = "input",
					name = L["Text"],
					desc = format(
						"%s\n%s\n%s",
						FormatDesc("%player%", L["Name of the player"]),
						FormatDesc("%target%", L["Target name"]),
						FormatDesc("%spell%", L["The spell link"])
					),
					width = 2.5,
				},
				useDefaultText = {
					order = 5,
					type = "execute",
					func = function()
						E.db.mui.announcement.utility.spells[categoryOrId].text =
							P.announcement.utility.spells[categoryOrId].text
					end,
					name = L["Default Text"],
				},
				example = {
					order = 6,
					type = "description",
					name = function()
						local message = E.db.mui.announcement.utility.spells[categoryOrId].text
						message = gsub(message, "%%player%%", E.myname)
						message = gsub(message, "%%target%%", L["Sylvanas"])
						message = gsub(message, "%%spell%%", GetSpellLink(exampleSpellId))
						return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n"
					end,
				},
			},
		}
	end
end

options.announcement.args.resetInstance = {
	order = 5,
	type = "group",
	name = L["Reset Instance"],
	get = function(info)
		return E.db.mui.announcement[info[#info - 1]][info[#info]]
	end,
	set = function(info, value)
		E.db.mui.announcement[info[#info - 1]][info[#info]] = value
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
					name = L["Send a message after instance resetting."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		prefix = {
			order = 3,
			type = "toggle",
			name = L["Prefix"],
		},
		channel = {
			order = 4,
			name = L["Channel"],
			type = "group",
			inline = true,
			get = function(info)
				return E.db.mui.announcement.resetInstance[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.announcement.resetInstance[info[#info - 1]][info[#info]] = value
			end,
			args = {
				party = {
					order = 1,
					name = L["In Party"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				instance = {
					order = 2,
					name = L["In Instance"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						INSTANCE_CHAT = L["Instance"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				raid = {
					order = 3,
					name = L["In Raid"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						RAID = L["Raid"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
			},
		},
	},
}

options.announcement.args.keystone = {
	order = 6,
	type = "group",
	name = L["Keystone"],
	get = function(info)
		return E.db.mui.announcement[info[#info - 1]][info[#info]]
	end,
	set = function(info, value)
		E.db.mui.announcement[info[#info - 1]][info[#info]] = value
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
					name = L["Announce the new mythic keystone."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		text = {
			order = 3,
			type = "input",
			name = L["Text"],
			desc = FormatDesc("%keystone%", L["Keystone"]),
			width = 2,
		},
		useDefaultText = {
			order = 4,
			type = "execute",
			func = function(info)
				E.db.mui.announcement.keystone.text = P.announcement.keystone.text
			end,
			name = L["Default Text"],
		},
		channel = {
			order = 5,
			name = L["Channel"],
			type = "group",
			inline = true,
			get = function(info)
				return E.db.mui.announcement.keystone[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.announcement.keystone[info[#info - 1]][info[#info]] = value
			end,
			args = {
				party = {
					order = 1,
					name = L["In Party"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
			},
		},
	},
}

options.announcement.args.general = {
	order = 7,
	type = "group",
	name = L["General"],
	get = function(info)
		return E.db.mui.announcement[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.announcement[info[#info]] = value
	end,
	args = {
		emoteFormat = {
			order = 1,
			type = "input",
			name = L["Emote Format"],
			desc = L["The text template used in emote channel."]
				.. "\n"
				.. format(L["Default is %s."], C.StringByTemplate(": %s", "sky-500")),
			width = 2,
		},
		betterAlign = {
			order = 2,
			type = "description",
			fontSize = "small",
			name = " ",
			width = "full",
		},
		sameMessageInterval = {
			order = 3,
			type = "range",
			name = L["Same Message Interval"],
			desc = L["Time interval between sending same messages measured in seconds."]
				.. " "
				.. L["Set to 0 to disable."],
			min = 0,
			max = 3600,
			step = 1,
			width = 1.5,
		},
	},
}
