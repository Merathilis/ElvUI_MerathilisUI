local MER, E, L, V, P, G = unpack(select(2, ...))

if E.db.mui == nil then E.db.mui = {} end

local format, select, unpack = format, select, unpack
local tconcat, tinsert, tsort = table.concat, table.insert, table.sort

local CreateTextureMarkup = CreateTextureMarkup
local IsAddOnLoaded = IsAddOnLoaded

local logo = CreateTextureMarkup("Interface/AddOns/ElvUI_MerathilisUI/media/textures/m2", 64, 64, 20, 20, 0, 1, 0, 1, 0, -1)

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
tsort(DONATORS, function(a, b) return E:StripString(a) < E:StripString(b) end)
local DONATOR_STRING = tconcat(DONATORS, ", ")

local PATRONS = {
	'Graldur',
	'Deezyl',
	'Zhadar',
}
tsort(PATRONS, function(a, b) return E:StripString(a) < E:StripString(b) end)
local PATRONS_STRING = tconcat(PATRONS, ", ")

local function AddOptions()
	local icon = MER:GetIconString(MER.Media.Textures.pepeSmall, 14)
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
			name = ACH:Header(MER.Title..MER:cOption(MER.Version, 'blue')..L["by Merathilis (|cFF00c0faEU-Shattrath|r)"], 1),
			logo = {
				order = 2,
				type = "description",
				name = L["MER_DESC"]..E.NewSign,
				fontSize = "medium",
				image = function() return "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI1.tga", 200, 200 end,
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
				func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://discord.gg/ZhNqCu2") end,
			},
			general = {
				order = 8,
				type = "group",
				name = MER:cOption(L["General"], 'gradient'),
				icon = MER.Media.Icons.general,
				args = {
					generalHeader = ACH:Header(MER:cOption(L["General"], 'orange'), 1),
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
						disabled = function() return IsAddOnLoaded("ElvUI_BenikUI") end,
					},
					GameMenu = {
						order = 5,
						type = "toggle",
						name = L["GameMenu"],
						desc = L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu."],
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
						name = E.NewSign..MER:cOption(L["Shadows"].." ".."|cffFF0000WIP|r"),
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
				name = MER:cOption(L["Information"], 'gradient'),
				icon = MER.Media.Icons.information,
				args = {
					name = ACH:Header(MER:cOption(L["Information"], 'orange'), 1),
					support = {
						order = 2,
						type = "group",
						name = MER:cOption(L["Support & Downloads"], 'orange'),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = "execute",
								name = L["TukUI.org"],
								func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://www.tukui.org/addons.php?id=1") end,
								},
							git = {
								order = 2,
								type = "execute",
								name = L["Git Ticket tracker"],
								func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://github.com/Merathilis/ElvUI_MerathilisUI/issues") end,
							},
							curse = {
								order = 3,
								type = "execute",
								name = L["Curse.com"],
								func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://www.curseforge.com/wow/addons/merathilis-ui") end,
							},
							discord = {
								order = 4,
								type = "execute",
								name = L["TukUI.org Discord Server"],
								func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://discord.gg/xFWcfgE") end,
							},
							development = {
								order = 5,
								type = 'execute',
								name = L["Development Version"],
								desc = L["Here you can download the latest development version."],
								func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://github.com/Merathilis/ElvUI_MerathilisUI/archive/refs/heads/development.zip") end,
							},
						},
					},
					coding = {
						order = 3,
						type = "group",
						name = MER:cOption(L["Coding"], 'orange'),
						guiInline = true,
						args = {
							tukui = ACH:Description(format("|cffffd200%s|r", "Elv, Benik, Darth Predator, Blazeflack, Simpy <3, fgprodigal, fang2hou"), 1),
						},
					},
					testing = {
						order = 4,
						type = "group",
						name = MER:cOption(L["Testing & Inspiration"], 'orange'),
						guiInline = true,
						args = {
							tukui = ACH:Description(format("|cffffd200%s|r", "Benik, Darth Predator, Rockxana, ElvUI community"), 1),
						},
					},
					donors = {
						order = 5,
						type = 'group',
						name = MER:cOption(L["Donations"], 'orange'),
						guiInline = true,
						args = {
							patron = {
								order = 1,
								type = 'description',
								fontSize = 'medium',
								name = format("|cffff005aPatrons: |r|cffffd200%s\n|r", PATRONS_STRING)
							},
							paypal = {
								order = 2,
								type = 'description',
								fontSize = 'medium',
								name = format("|cff009fffPayPal: |r|cffffd200%s\n|r", DONATOR_STRING)
							},
						},
					},
					version = {
						order = 5,
						type = "group",
						name = MER:cOption(L["Version"], 'orange'),
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
				name = MER:cOption(L["Modules"], 'gradient'),
				icon = MER.Media.Icons.modules,
				args = {
					info = ACH:Description(L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules.\nPlease use the dropdown to navigate through the modules."]),
				},
			},
		},
	}
end
tinsert(MER.Config, AddOptions)
