local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local C = MER.Utilities.Color

local options = MER.options.information.args

local unpack = unpack
local tconcat, tsort = table.concat, table.sort

local newSignIgnored = [[|TInterface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon:14:14|t]]

local function SortList(a, b)
	return E:StripString(a) < E:StripString(b)
end

local DONATORS = {
	"enii",
	"Hope",
	"Kisol",
	"Natsuruseno",
	"Rylok",
	"Amenitra",
	"zarbol",
	"Olli2k",
	"Dlarge",
	"N3",
	"Aary",
	"Daniel",
	"skychilde",
	"Grougwarth",
	"Sylfarion",
	"Andrey",
	"Jake",
	"Jiberish",
	"Xu Dehua",
	"Baraius",
	"Dream",
}
tsort(DONATORS, SortList)
local DONATOR_STRING = tconcat(DONATORS, ", ")

local PATRONS = {
	"Graldur",
	"Deezyl",
	"Zhadar",
	"Dadedadeur ",
}
tsort(PATRONS, SortList)
local PATRONS_STRING = tconcat(PATRONS, ", ")

options.name = {
	order = 1,
	type = "group",
	name = L["Information"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Information"], "orange"),
		},
		support = {
			order = 1,
			type = "group",
			name = F.cOption(L["Support & Downloads"], "orange"),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "execute",
					name = L["Tukui"],
					func = function()
						E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://www.tukui.org/addons.php?id=1")
					end,
				},
				curse = {
					order = 2,
					type = "execute",
					name = L["CurseForge"],
					func = function()
						E:StaticPopup_Show(
							"MERATHILISUI_CREDITS",
							nil,
							nil,
							"https://www.curseforge.com/wow/addons/merathilis-ui"
						)
					end,
				},
				development = {
					order = 3,
					type = "execute",
					name = L["Development Version"],
					desc = L["Here you can download the latest development version."],
					func = function()
						E:StaticPopup_Show(
							"MERATHILISUI_CREDITS",
							nil,
							nil,
							"https://github.com/Merathilis/ElvUI_MerathilisUI/archive/refs/heads/development.zip"
						)
					end,
				},
				spacer = {
					order = 4,
					type = "description",
					name = " ",
				},
				discord = {
					order = 5,
					type = "execute",
					name = L["Tukui Discord Server"],
					image = I.Media.Icons.Discord,
					func = function()
						E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://discord.gg/xFWcfgE")
					end,
				},
				git = {
					order = 6,
					type = "execute",
					name = L["Github"],
					image = I.Media.Icons.Github,
					func = function()
						E:StaticPopup_Show(
							"MERATHILISUI_CREDITS",
							nil,
							nil,
							"https://github.com/Merathilis/ElvUI_MerathilisUI/issues"
						)
					end,
				},
				spacer1 = {
					order = 7,
					type = "description",
					name = " ",
				},
				debugModeTip = {
					order = 8,
					type = "description",
					fontSize = "medium",
					name = newSignIgnored
						.. " |cffe74c3c"
						.. format(
							L["Before you submit a bug, please enable debug mode with %s and test it one more time."],
							"|cff00ff00/muidebug|r"
						)
						.. "|r",
					width = "full",
				},
			},
		},
		testing = {
			order = 2,
			type = "group",
			name = F.cOption(L["Testing & Inspiration"], "orange"),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "description",
					name = format(
						"|cffffffff%s|r",
						"Benik, Darth Predator, Rockxana, |TInterface/AddOns/ElvUI_MerathilisUI/Media/Textures/Tukui:15:15:0:0:64:64:5:59:5:59|t The Tukui Community"
					),
				},
			},
		},
		donors = {
			order = 3,
			type = "group",
			name = F.cOption(L["Donations"], "orange"),
			guiInline = true,
			args = {
				patron = {
					order = 1,
					type = "description",
					fontSize = "medium",
					name = format("|cffff005aPatrons: |r|cffffffff%s\n|r", PATRONS_STRING),
				},
				paypal = {
					order = 2,
					type = "description",
					fontSize = "medium",
					name = format("|cff009fffPayPal: |r|cffffffff%s\n|r", DONATOR_STRING),
				},
			},
		},
	},
}

local DEVELOPER = {
	"|cff0070DEAzilroka|r",
	"|cffd12727Blazeflack|r",
	"|cff00c0faBenik|r",
	"|cff9482c9Darth Predator|r",
	"|TInterface/AddOns/ElvUI/Core/Media/ChatLogos/Beer:15:15:0:0:64:64:5:59:5:59|t |cfff48cbaRepooc|r",
	E:TextGradient(
		"Simpy but my name needs to be longer",
		0.27,
		0.72,
		0.86,
		0.51,
		0.36,
		0.80,
		0.69,
		0.28,
		0.94,
		0.94,
		0.28,
		0.63,
		1.00,
		0.51,
		0.00,
		0.27,
		0.96,
		0.43
	),
	"fgprodigal",
	C.StringByTemplate("fang2hou", "blue-400"),
	"siweia",
	"|cff0080ffWitness|r (NDui_Plus)",
	"|cff1784d1Eltreum|r",
	"|cff18a8ffToxi|r",
	"mcc1",
}

local nameString = strjoin(", ", unpack(DEVELOPER))

options.name.args.coding = {
	order = 6,
	type = "group",
	name = F.cOption(L["Coding"], "orange"),
	guiInline = true,
	args = {
		credits = {
			order = 1,
			type = "description",
			name = format(
				L["Many thanks to these wonderful persons for letting me use some of their code: %s."],
				nameString
			),
		},
	},
}

options.name.args.localization = {
	order = 7,
	type = "group",
	name = F.cOption(L["Localization"], "orange"),
	guiInline = true,
	args = {},
}

do
	local german = F.GetIconString(I.Media.Icons.German, 10, 20)
	local russian = F.GetIconString(I.Media.Icons.Russian, 10, 20)
	local korean = F.GetIconString(I.Media.Icons.Korean, 10, 20)

	local localizationList = {
		["Deutsche (deDE)" .. " " .. german] = {
			"|cff00c0faDlarge|r",
		},
		["русский язык (ruRU)" .. " " .. russian] = {
			"Hollicsh @ GitHub",
		},
		["한국어 (koKR)" .. " " .. korean] = {
			"Crazyyoungs @ GitHub",
		},
	}

	local configOrder = 1
	for langName, credits in pairs(localizationList) do
		options.name.args.localization.args[tostring(configOrder)] = {
			order = configOrder,
			type = "description",
			name = C.StringByTemplate(langName, "blue-500"),
		}
		configOrder = configOrder + 1

		for _, credit in pairs(credits) do
			options.name.args.localization.args[tostring(configOrder)] = {
				order = configOrder,
				type = "description",
				name = "  - " .. credit,
			}
			configOrder = configOrder + 1
		end
	end
end

options.reset = {
	order = 2,
	type = "group",
	name = L["Reset"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Reset"], "orange"),
		},
		desc = {
			order = 1,
			type = "description",
			name = F.String.MERATHILISUI(L["This section will help reset specfic settings back to default."]),
		},
		spacer = {
			order = 2,
			type = "description",
			name = " ",
		},
		autoButtons = {
			order = 3,
			type = "execute",
			name = L["AutoButtons"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["AutoButtons"], nil, function()
					E:CopyTable(E.db.mui.autoButtons, P.autoButtons)
				end)
			end,
		},
		microBar = {
			order = 4,
			type = "execute",
			name = L["Micro Bar"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Micro Bar"], nil, function()
					E:CopyTable(E.db.mui.microBar, P.microBar)
				end)
			end,
		},
		cooldownFlash = {
			order = 5,
			type = "execute",
			name = L["Cooldown Flash"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Cooldown Flash"], nil, function()
					E:CopyTable(E.db.mui.cooldownFlash, P.cooldownFlash)
				end)
			end,
		},
		raidmarkers = {
			order = 6,
			type = "execute",
			name = L["Raid Markers"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Raid Markers"], nil, function()
					E:CopyTable(E.db.mui.raidmarkers, P.raidmarkers)
				end)
			end,
		},
		smb = {
			order = 7,
			type = "execute",
			name = L["Minimap Buttons"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Minimap Buttons"], nil, function()
					E:CopyTable(E.db.mui.smb, P.smb)
				end)
			end,
		},
		eventTracker = {
			order = 8,
			type = "execute",
			name = L["Event Tracker"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Event Tracker"], nil, function()
					E.db.mui.maps.eventTracker = P.maps.eventTracker
				end)
			end,
		},
		bigWigsSkin = {
			order = 9,
			type = "execute",
			name = L["BigWigs Skin"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["BigWigs Skin"], nil, function()
					E.private.mui.skins.addonSkins.bw = V.skins.addonSkins.bw
				end)
			end,
		},
		chatBar = {
			order = 10,
			type = "execute",
			name = L["Chat Bar"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Chat Bar"], nil, function()
					E.db.mui.maps.chat.chatBar = P.chat.chatBar
				end)
			end,
		},
		spacer1 = {
			order = 20,
			type = "description",
			name = " ",
		},
		misc = {
			order = 15,
			type = "group",
			inline = true,
			name = L["Misc"],
			args = {
				general = {
					order = 1,
					type = "execute",
					name = L["General"],
					func = function()
						E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["General"], nil, function()
							E.db.mui.misc.betterGuildMemberStatus = P.misc.betterGuildMemberStatus
						end)
					end,
				},
			},
		},
		spacer2 = {
			order = 20,
			type = "description",
			name = " ",
		},
		resetAllModules = {
			order = 21,
			type = "execute",
			name = L["Reset All Modules"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_ALL_MODULES")
			end,
			width = "full",
		},
	},
}
