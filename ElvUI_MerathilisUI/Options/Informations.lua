local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local C = W.Utilities.Color

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

local function Color(string)
	if type(string) ~= "string" then
		string = tostring(string)
	end
	return C.StringWithRGB(string, E.db.general.valuecolor)
end

options.changelog = {
	order = 2,
	type = "group",
	childGroups = "select",
	name = L["Changelog"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Changelog"], "orange"),
		},
	},
}

local function renderChangeLogLine(line)
	line = gsub(line, "%[!%]", E.NewSign)
	line = gsub(line, "%[[^%[]+%]", Color)
	return line
end

for version, data in pairs(MER.Changelog) do
	local versionString = format("%d.%02d", version / 100, mod(version, 100))
	local changelogVer = tonumber(versionString)
	local addonVer = tonumber(MER.Version)
	local dateTable = { strsplit("/", data.RELEASE_DATE) }
	local dateString = data.RELEASE_DATE
	if #dateTable == 3 then
		dateString = L["%day%-%month%-%year%"]
		dateString = gsub(dateString, "%%day%%", dateTable[1])
		dateString = gsub(dateString, "%%month%%", dateTable[2])
		dateString = gsub(dateString, "%%year%%", dateTable[3])
	end

	options.changelog.args[tostring(version)] = {
		order = 1000 - version,
		name = versionString,
		type = "group",
		args = {},
	}

	local page = options.changelog.args[tostring(version)].args

	page.date = {
		order = 1,
		type = "description",
		name = "|cffbbbbbb" .. dateString .. " " .. L["Released"] .. "|r",
		fontSize = "small",
	}

	page.version = {
		order = 2,
		type = "description",
		name = L["Version"] .. " " .. F.String.MERATHILISUI(versionString),
		fontSize = "large",
	}

	local warningIcon = F.GetIconString(I.Media.Icons.Warning, 12)
	local thunderIcon = F.GetIconString(I.Media.Icons.Flash, 12)
	local newIcon = F.GetIconString(I.Media.Icons.New, 12)

	local fixPart = data and data.FIXES
	if fixPart and #fixPart > 0 then
		page.importantHeader = {
			order = 3,
			type = "header",
			name = warningIcon .. " " .. F.String.FastGradientHex(L["Fixes"], "#ffa270", "#c63f17"),
		}
		page.important = {
			order = 4,
			type = "description",
			name = function()
				local text = ""
				for index, line in ipairs(fixPart) do
					text = text .. format("%02d", index) .. ". " .. renderChangeLogLine(line) .. "\n"
				end
				return text .. "\n"
			end,
			fontSize = "medium",
		}
	end

	local newPart = data and data.NEW
	if newPart and #newPart > 0 then
		page.newHeader = {
			order = 5,
			type = "header",
			name = newIcon .. " " .. F.String.FastGradientHex(L["New"], "#fffd61", "#c79a00"),
		}
		page.new = {
			order = 6,
			type = "description",
			name = function()
				local text = ""
				for index, line in ipairs(newPart) do
					text = text .. format("%02d", index) .. ". " .. renderChangeLogLine(line) .. "\n"
				end
				return text .. "\n"
			end,
			fontSize = "medium",
		}
	end

	local improvementPart = data and data.IMPROVEMENTS
	if improvementPart and #improvementPart > 0 then
		page.improvementHeader = {
			order = 7,
			type = "header",
			name = thunderIcon .. " " .. F.String.FastGradientHex(L["Improvements"], "#98ee99", "#338a3e"),
		}
		page.improvement = {
			order = 8,
			type = "description",
			name = function()
				local text = ""
				for index, line in ipairs(improvementPart) do
					text = text .. format("%02d", index) .. ". " .. renderChangeLogLine(line) .. "\n"
				end
				return text .. "\n"
			end,
			fontSize = "medium",
		}
	end

	page.beforeConfirm1 = {
		order = 9,
		type = "description",
		name = " ",
		width = "full",
		hidden = function()
			local dbVer = E.global.mui and E.global.mui.changelogRead and tonumber(E.global.mui.changelogRead)
			return dbVer and dbVer >= changelogVer or addonVer < changelogVer
		end,
	}

	page.beforeConfirm2 = {
		order = 10,
		type = "description",
		name = " ",
		width = "full",
		hidden = function()
			local dbVer = E.global.mui and E.global.mui.changelogRead and tonumber(E.global.mui.changelogRead)
			return dbVer and dbVer >= changelogVer or addonVer < changelogVer
		end,
	}

	page.confirm = {
		order = 11,
		type = "execute",
		name = C.StringByTemplate(L["I got it!"], "teal-400"),
		desc = L["Mark as read, the changelog message will be hidden when you login next time."],
		width = "full",
		hidden = function()
			local dbVer = E.global.mui and E.global.mui.changelogRead and tonumber(E.global.mui.changelogRead)
			return dbVer and dbVer >= changelogVer or addonVer < changelogVer
		end,
		func = function()
			E.global.mui.changelogRead = versionString
		end,
	}
end
