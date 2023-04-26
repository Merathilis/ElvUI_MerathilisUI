local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args
local module = MER:GetModule('MER_Announcement')

local format = format
local gsub = gsub
local pairs = pairs
local tonumber = tonumber

local GetSpellLink = GetSpellLink

local function ImportantColorString(string)
	return F.CreateColorString(string, { r = 0.204, g = 0.596, b = 0.859 })
end

local function FormatDesc(code, helpText)
	return ImportantColorString(code) .. " = " .. helpText
end

options.announcement = {
	type = "group",
	name = L["Announcement"],
	hidden = E.Classic,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Announcement"], 'orange'),
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
	name = L["Enable"]
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
					fontSize = "medium"
				}
			}
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.mui.announcement[info[#info - 1]][info[#info]] = value
			end
		},
		disableBlizzard = {
			order = 3,
			type = "toggle",
			name = L["Disable Blizzard"],
			desc = L["Disable Blizzard quest progress message."],
			set = function(info, value)
				E.db.mui.announcement[info[#info - 1]][info[#info]] = value
				module:UpdateBlizzardQuestAnnouncement()
			end
		},
		includeDetails = {
			order = 4,
			type = "toggle",
			name = L["Include Details"],
			desc = L["Announce every time the progress has been changed."]
		},
		channel = {
			order = 5,
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
						SAY = L["Say"]
					}
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
						SAY = L["Say"]
					}
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
						SAY = L["Say"]
					}
				}
			}
		},
		tag = {
			order = 6,
			type = "group",
			inline = true,
			name = L["Tag"],
			get = function(info)
				return E.db.mui.announcement.quest[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.announcement.quest[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["The category of the quest."]
				},
				color = {
					order = 2,
					type = "color",
					name = L["Color"],
					hasAlpha = false,
					get = function(info)
						local colordb = E.db.mui.announcement.quest[info[#info - 1]].color
						local default = P.announcement.quest[info[#info - 1]].color
						return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						E.db.mui.announcement.quest[info[#info - 1]].color = {
							r = r,
							g = g,
							b = b
						}
					end
				}
			}
		},
		suggestedGroup = {
			order = 7,
			type = "group",
			inline = true,
			name = L["Suggested Group"],
			get = function(info)
				return E.db.mui.announcement.quest[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.announcement.quest[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["If the quest is suggested with multi-players, add the number of players to the message."]
				},
				color = {
					order = 2,
					type = "color",
					name = L["Color"],
					hasAlpha = false,
					get = function(info)
						local colordb = E.db.mui.announcement.quest[info[#info - 1]].color
						local default = P.announcement.quest[info[#info - 1]].color
						return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						E.db.mui.announcement.quest[info[#info - 1]].color = {
							r = r,
							g = g,
							b = b
						}
					end
				}
			}
		},
		level = {
			order = 8,
			type = "group",
			inline = true,
			name = L["Level"],
			get = function(info)
				return E.db.mui.announcement.quest[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.announcement.quest[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["The level of the quest."]
				},
				color = {
					order = 2,
					type = "color",
					name = L["Color"],
					hasAlpha = false,
					get = function(info)
						local colordb = E.db.mui.announcement.quest[info[#info - 1]].color
						local default = P.announcement.quest[info[#info - 1]].color
						return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						E.db.mui.announcement.quest[info[#info - 1]].color = {
							r = r,
							g = g,
							b = b
						}
					end
				},
				hideOnMax = {
					order = 3,
					type = "toggle",
					name = L["Hide Max Level"],
					desc = L["Hide the level part if the quest level is the max level of this expansion."]
				}
			}
		},
		daily = {
			order = 9,
			type = "group",
			inline = true,
			name = L["Daily"],
			get = function(info)
				return E.db.mui.announcement.quest[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.announcement.quest[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add the prefix if the quest is a daily quest."]
				},
				color = {
					order = 2,
					type = "color",
					name = L["Color"],
					hasAlpha = false,
					get = function(info)
						local colordb = E.db.mui.announcement.quest[info[#info - 1]].color
						local default = P.announcement.quest[info[#info - 1]].color
						return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						E.db.mui.announcement.quest[info[#info - 1]].color = {
							r = r,
							g = g,
							b = b
						}
					end
				}
			}
		},
		weekly = {
			order = 10,
			type = "group",
			inline = true,
			name = L["Weekly"],
			get = function(info)
				return E.db.mui.announcement.quest[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.announcement.quest[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add the prefix if the quest is a weekly quest."]
				},
				color = {
					order = 2,
					type = "color",
					name = L["Color"],
					hasAlpha = false,
					get = function(info)
						local colordb = E.db.mui.announcement.quest[info[#info - 1]].color
						local default = P.announcement.quest[info[#info - 1]].color
						return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						E.db.mui.announcement.quest[info[#info - 1]].color = {
							r = r,
							g = g,
							b = b
						}
					end
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
					fontSize = "medium"
				}
			}
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.mui.announcement[info[#info - 1]][info[#info]] = value
				module:ResetAuthority()
			end
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
						SAY = L["Say"]
					}
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
						SAY = L["Say"]
					}
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
						SAY = L["Say"]
					}
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
						SAY = L["Say"]
					},
				},
			},
		},
	},
}

if E.Retail then
	do
		local categoryLocales = {
			feasts = L["Feasts"],
			bots = L["Bots"],
			toys = L["Toys"],
			portals = L["Portals"],
			hero = L["Heroism/Bloodlust"]
		}

		local specialExampleSpell = {
			feasts = 286050,
			bots = 67826,
			toys = 61031,
			portals = 10059,
			hero = 32182,
		}

		local spellOptions = options.announcement.args.utility.args
		local spellOrder = 10
		local categoryOrder = 50
		for categoryOrId, config in pairs(P.announcement.utility.spells) do
			local groupName, groupOrder, exampleSpellId
			local id = tonumber(categoryOrId)
			if id then
				groupName = GetSpellInfo(id)
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
						name = L["Enable"]
					},
					includePlayer = {
						order = 2,
						type = "toggle",
						name = L["Include Player"],
						desc = L["Uncheck this box, it will not send message if you cast the spell."]
					},
					raidWarning = {
						order = 3,
						type = "toggle",
						name = L["Raid Warning"],
						desc = L["If you have privilege, it would the message to raid warning(/rw) rather than raid(/r)."]
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
						width = 2.5
					},
					useDefaultText = {
						order = 5,
						type = "execute",
						func = function()
							E.db.mui.announcement.utility.spells[categoryOrId].text =
							P.announcement.utility.spells[categoryOrId].text
						end,
						name = L["Default Text"]
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
						end
					}
				}
			}
		end
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
					fontSize = "medium"
				}
			}
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"]
		},
		prefix = {
			order = 3,
			type = "toggle",
			name = L["Prefix"]
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
						SAY = L["Say"]
					}
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
						SAY = L["Say"]
					}
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
						SAY = L["Say"]
					}
				}
			}
		}
	}
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
					fontSize = "medium"
				}
			}
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"]
		},
		text = {
			order = 3,
			type = "input",
			name = L["Text"],
			desc = FormatDesc("%keystone%", L["Keystone"]),
			width = 2
		},
		useDefaultText = {
			order = 4,
			type = "execute",
			func = function(info)
				E.db.mui.announcement.keystone.text = P.announcement.keystone.text
			end,
			name = L["Default Text"]
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
						SAY = L["Say"]
					}
				}
			}
		}
	}
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
			desc = L["The text template used in emote channel."] .. "\n" .. format(L["Default is %s."], F.StringByTemplate(": %s", "info")),
			width = 2
		}
	}
}
