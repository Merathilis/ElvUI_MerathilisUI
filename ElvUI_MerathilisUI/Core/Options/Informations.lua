local MER, F, E, L, V, P, G = unpack(select(2, ...))
local options = MER.options.information.args

local tconcat, tsort = table.concat, table.sort

local newSignIgnored = [[|TInterface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon:14:14|t]]

local function AddColor(string)
	if type(string) ~= "string" then
		string = tostring(string)
	end
	return F.CreateColorString(string, {r = 0, g = 192, b = 250})
end

local function SortList(a, b)
	return E:StripString(a) < E:StripString(b)
end

local DONATORS = {
	'enii',
	'Hope',
	'Kisol',
	'Natsurusenô',
	'Rylok',
	'Amenitra',
	'zarbol',
	'Olli2k',
	'Dlarge',
	'N3',
}
tsort(DONATORS, SortList)
local DONATOR_STRING = tconcat(DONATORS, ", ")

local PATRONS = {
	'Graldur',
	'Deezyl',
	'Zhadar',
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
			name = F.cOption(L["Information"], 'orange'),
		},
		LoginMsg = {
			order = 1,
			type = "toggle",
			name = L["Login Message"],
			desc = L["Enable/Disable the Login Message in Chat"],
			get = function(info)
				return E.global.mui.core.LoginMsg
			end,
			set = function(info, value)
				E.global.mui.core.LoginMsg = value
			end
		},
		compatibilityCheck = {
			order = 2,
			type = "toggle",
			name = L["Compatibility Check"],
			desc = L["Help you to enable/disable the modules for a better experience with other plugins."],
			get = function(info)
				return E.global.mui.core.compatibilityCheck
			end,
			set = function(info, value)
				E.global.mui.core.compatibilityCheck = value
				E:StaticPopup_Show("PRIVATE_RL")
			end
		},
		logLevel = {
			order = 3,
			type = "select",
			name = L["Log Level"],
			desc = L["Only display log message that the level is higher than you choose."] ..
				"\n|cffff3860" .. L["Set to 2 if you do not understand the meaning of log level."] .. "|r",
			get = function(info)
				return E.global.mui.core.logLevel
			end,
			set = function(info, value)
				E.global.mui.core.logLevel = value
			end,
			hidden = function()
			end,
			values = {
				[1] = "1 - |cffff3860[ERROR]|r",
				[2] = "2 - |cffffdd57[WARNING]|r",
				[3] = "3 - |cff209cee[INFO]|r",
				[4] = "4 - |cff00d1b2[DEBUG]|r"
			},
		},
		support = {
			order = 5,
			type = "group",
			name = F.cOption(L["Support & Downloads"], 'orange'),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "execute",
					name = L["Tukui"],
					func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://www.tukui.org/addons.php?id=1") end,
					},
				curse = {
					order = 2,
					type = "execute",
					name = L["CurseForge"],
					func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://www.curseforge.com/wow/addons/merathilis-ui") end,
				},
				development = {
					order = 3,
					type = 'execute',
					name = L["Development Version"],
					desc = L["Here you can download the latest development version."],
					func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://github.com/Merathilis/ElvUI_MerathilisUI/archive/refs/heads/development.zip") end,
				},
				spacer = {
					order = 4,
					type = 'description',
					name = ' ',
				},
				discord = {
					order = 5,
					type = "execute",
					name = L["Tukui Discord Server"],
					image = MER.Media.Icons.discord,
					func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://discord.gg/xFWcfgE") end,
				},
				git = {
					order = 6,
					type = "execute",
					name = L["Github"],
					image = MER.Media.Icons.github,
					func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://github.com/Merathilis/ElvUI_MerathilisUI/issues") end,
				},
				spacer1 = {
					order = 7,
					type = 'description',
					name = ' ',
				},
				debugModeTip = {
					order = 8,
					type = "description",
					fontSize = "medium",
					name = newSignIgnored .. " |cffe74c3c" .. format(L["Before you submit a bug, please enable debug mode with %s and test it one more time."], "|cff00ff00/muidebug|r") .."|r",
					width = "full"
				},
			},
		},
		testing = {
			order = 6,
			type = "group",
			name = F.cOption(L["Testing & Inspiration"], 'orange'),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "description",
					name = format("|cffffffff%s|r", "Benik, Darth Predator, Rockxana, ElvUI community"),
				},
			},
		},
		donors = {
			order = 7,
			type = 'group',
			name = F.cOption(L["Donations"], 'orange'),
			guiInline = true,
			args = {
				patron = {
					order = 1,
					type = 'description',
					fontSize = 'medium',
					name = format("|cffff005aPatrons: |r|cffffffff%s\n|r", PATRONS_STRING)
				},
				paypal = {
					order = 2,
					type = 'description',
					fontSize = 'medium',
					name = format("|cff009fffPayPal: |r|cffffffff%s\n|r", DONATOR_STRING)
				},
			},
		},
		version = {
			order = 8,
			type = "group",
			name = F.cOption(L["Version"], 'orange'),
			guiInline = true,
			args = {
				version = {
					order = 1,
					type = "description",
					name = MER.Title..F.cOption(MER.Version, 'blue')
				},
				build = {
					order = 2,
					type = "description",
					name = L["WoW Build"] .. ": " .. F.cOption(format("%s (%s)", E.wowpatch, E.wowbuild), 'blue'),
				}
			},
		},
	},
}

local DEVELOPER = {
	'|cff0070DEAzilroka|r',
	'|cffd12727Blazeflack|r',
	'|cff00c0faBenik|r',
	'|cff9482c9Darth Predator|r',
	'|TInterface/AddOns/ElvUI/Core/Media/ChatLogos/Beer:15:15:0:0:64:64:5:59:5:59|t |cfff48cbaRepooc|r',
	E:TextGradient('Simpy but my name needs to be longer', 0.27,0.72,0.86, 0.51,0.36,0.80, 0.69,0.28,0.94, 0.94,0.28,0.63, 1.00,0.51,0.00, 0.27,0.96,0.43),
	'fgprodigal',
	AddColor('fang2hou'),
	'|cff1784d1Eltreum|r',
}

local nameString = strjoin(", ", unpack(DEVELOPER))

options.name.args.coding = {
	order = 6,
	type = "group",
	name = F.cOption(L["Coding"], 'orange'),
	guiInline = true,
	args = {
		credits = {
			order = 1,
			type = 'description',
			name = format(L["Many thanks to these wonderful persons %s."], nameString)
		},
	},
}

options.reset = {
	order = 2,
	type = "group",
	name = L["Reset"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Reset"], 'orange'),
		},
		desc = {
			order = 1,
			type = "description",
			name = MER.InfoColor..L["This section will help reset specfic settings back to default."],
		},
		spacer = {
			order = 2,
			type = "description",
			name = ' ',
		},
		armory = {
			order = 3,
			type = "execute",
			name = L["Armory"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["AutoButtons"], nil, function()
					E:CopyTable(E.db.mui.armory, P.armory)
				end)
			end
		},
		autoButtons = {
			order = 4,
			type = "execute",
			name = L["AutoButtons"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["AutoButtons"], nil, function()
					E:CopyTable(E.db.mui.autoButtons, P.autoButtons)
				end)
			end
		},
		locPanel = {
			order = 5,
			type = "execute",
			name = L["Location Panel"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["AutoButtons"], nil, function()
					E:CopyTable(E.db.mui.locPanel, P.locPanel)
				end)
			end
		},
		microBar = {
			order = 6,
			type = "execute",
			name = L["Micro Bar"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Micro Bar"], nil, function()
					E:CopyTable(E.db.mui.microBar, P.microBar)
				end)
			end
		},
		cooldownFlash = {
			order = 7,
			type = "execute",
			name = L["Cooldown Flash"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Micro Bar"], nil, function()
					E:CopyTable(E.db.mui.cooldownFlash, P.cooldownFlash)
				end)
			end
		},
		raidmarkers = {
			order = 7,
			type = "execute",
			name = L["Raid Markers"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Raid Markers"], nil, function()
					E:CopyTable(E.db.mui.raidmarkers, P.raidmarkers)
				end)
			end
		},
		smb = {
			order = 8,
			type = "execute",
			name = L["Minimap Buttons"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Minimap Buttons"], nil, function()
					E:CopyTable(E.db.mui.smb, P.smb)
				end)
			end
		},
		spacer1 = {
			order = 20,
			type = "description",
			name = ' ',
		},
		resetAllModules = {
			order = 21,
			type = "execute",
			name = L["Reset All Modules"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_ALL_MODULES")
			end,
			width = "full"
		},
	},
}
