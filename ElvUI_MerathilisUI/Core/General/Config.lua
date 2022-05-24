local MER, F, E, L, V, P, G = unpack(select(2, ...))

if E.db.mui == nil then E.db.mui = {} end

local format, select, unpack = format, select, unpack
local tconcat, tinsert, tsort = table.concat, table.insert, table.sort

local CreateTextureMarkup = CreateTextureMarkup
local IsAddOnLoaded = IsAddOnLoaded

local logo = CreateTextureMarkup("Interface/AddOns/ElvUI_MerathilisUI/Core/Media/textures/m2", 64, 64, 20, 20, 0, 1, 0, 1, 0, -1)

local function AddColor(string)
	if type(string) ~= "string" then
		string = tostring(string)
	end
	return F.CreateColorString(string, {r = 0.204, g = 0.596, b = 0.859})
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

local function AddOptions()
	local icon = F.GetIconString(MER.Media.Textures.pepeSmall, 14)
	E.Options.name = E.Options.name.." + " .. icon .. " " ..MER.Title.. format(": |cFF00c0fa%s|r", MER.Version)

	local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
	local ACH = E.Libs.ACH

	local function CreateButton(number, text, ...)
		local path = {}
		local num = select("#", ...)
		for i = 1, num do
			local name = select(i, ...)
			tinsert(path, #(path)+1, name)
		end
		local config = {
			order = number,
			type = 'execute',
			name = text,
			customWidth = 140,
			func = function() ACD:SelectGroup("ElvUI", "mui", unpack(path)) end,
		}
		return config
	end

	-- Main options
	E.Options.args.mui = {
		order = 6,
		type = 'group',
		name = logo..MER.Title,
		desc = L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."],
		childGroups = "tree",
		get = function(info) return E.db.mui.general[ info[#info] ] end,
		set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = ACH:Header(MER.Title..F.cOption(MER.Version, 'blue')..L["by Merathilis (|cFF00c0faEU-Shattrath|r)"], 1),
			logo = {
				order = 2,
				type = "description",
				name = L["MER_DESC"]..E.NewSign,
				fontSize = "medium",
				image = function() return "Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\Textures\\mUI1.tga", 200, 200 end,
			},
			install = {
				order = 3,
				type = "execute",
				name = L["Install"],
				desc = L["Run the installation process."],
				customWidth = 140,
				func = function() E:GetModule("PluginInstaller"):Queue(MER.installTable); E:ToggleOptionsUI() end,
			},
			changelog = {
				order = 4,
				type = "execute",
				name = L["Changelog"],
				desc = L['Open the changelog window.'],
				customWidth = 140,
				func = function() MER:ToggleChangeLog(); E:ToggleOptionsUI() end,
			},
			discordButton = {
				order = 5,
				type = "execute",
				name = L["|cffffffffMerathilis|r|cffff7d0aUI|r Discord"],
				customWidth = 140,
				func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://discord.gg/s4B76at55Y") end,
			},
			general = {
				order = 8,
				type = "group",
				name = F.cOption(L["General"], 'gradient'),
				icon = MER.Media.Icons.general,
				args = {
					generalHeader = ACH:Header(F.cOption(L["General"], 'orange'), 1),
					LoginMsg = {
						order = 2,
						type = "toggle",
						name = L["Login Message"],
						desc = L["Enable/Disable the Login Message in Chat"],
					},
					splashScreen = {
						order = 3,
						type = "toggle",
						name = L["SplashScreen"],
						desc = L["Enable/Disable the Splash Screen on Login."],
					},
					AFK = {
						order = 4,
						type = "toggle",
						name = L["AFK"],
						desc = L["Enable/Disable the MUI AFK Screen. Disabled if BenikUI is loaded"],
					},
					GameMenu = {
						order = 5,
						type = "toggle",
						name = L["GameMenu"],
						desc = L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu. (e.g. Pepe, Logo, Bars)"],
					},
					FlightPoint = {
						order = 6,
						type = "toggle",
						name = L["Flight Point"],
						desc = L["Enable/Disable the MerathilisUI Flight Points on the FlightMap."],
						hidden = function() return IsAddOnLoaded("WorldFlightMap") end,
					},
					shadow = {
						order = 7,
						type = "group",
						name = E.NewSign..F.cOption(L["Shadows"].." ".."|cffFF0000WIP|r"),
						guiInline = true,
						get = function(info) return E.db.mui.general.shadow[ info[#info] ] end,
						set = function(info, value) E.db.mui.general.shadow[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
							},
							increasedSize = {
								order = 2,
								type = "range",
								name = L["Increase Size"],
								desc = L["Make shadow thicker."],
								min = 0, max = 10, step = 1
							},
						},
					},
				},
			},
			info = {
				order = 50,
				type = "group",
				name = F.cOption(L["Information"], 'gradient'),
				icon = MER.Media.Icons.information,
				args = {
					name = ACH:Header(F.cOption(L["Information"], 'orange'), 1),
					support = {
						order = 2,
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
								name = E.NewSign .. " |cffe74c3c" .. format(L["Before you submit a bug, please enable debug mode with %s and test it one more time."], "|cff00ff00/muidebug|r") .."|r",
								width = "full"
							},
						},
					},
					testing = {
						order = 4,
						type = "group",
						name = F.cOption(L["Testing & Inspiration"], 'orange'),
						guiInline = true,
						args = {
							tukui = ACH:Description(format("|cffffffff%s|r", "Benik, Darth Predator, Rockxana, ElvUI community"), 1),
						},
					},
					donors = {
						order = 5,
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
						order = 5,
						type = "group",
						name = F.cOption(L["Version"], 'orange'),
						guiInline = true,
						args = {
							version = ACH:Description(MER.Title..MER.Version, 1),
						},
					},
				},
			},
			modules = {
				order = 20,
				type = "group",
				childGroups = "select",
				name = F.cOption(L["Modules"], 'gradient'),
				icon = MER.Media.Icons.modules,
				args = {
					info = ACH:Description(L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules.\nPlease use the dropdown to navigate through the modules."]),
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
	}
	local nameString = strjoin(", ", unpack(DEVELOPER))

	E.Options.args.mui.args.info.args.coding = {
		order = 3,
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
end
tinsert(MER.Config, AddOptions)
