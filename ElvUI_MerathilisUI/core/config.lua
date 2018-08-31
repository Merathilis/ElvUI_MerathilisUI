local MER, E, L, V, P, G = unpack(select(2, ...))

if E.db.mui == nil then E.db.mui = {} end

-- Cache global variables
-- Lua functions
local format, select, unpack = format, select, unpack
local tinsert = table.insert
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: StaticPopup_Show

local function AddOptions()
	E.Options.args.ElvUI_Header.name = E.Options.args.ElvUI_Header.name.." + |cffff7d0aMerathilisUI|r"..format(": |cFF00c0fa%s|r", MER.Version)

	local ACD = LibStub("AceConfigDialog-3.0-ElvUI")

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
			func = function() ACD:SelectGroup("ElvUI", "mui", unpack(path)) end,
		}
		return config
	end

	-- Main options
	E.Options.args.mui = {
		order = 9001,
		type = 'group',
		name = MER.Title,
		desc = L["Plugin for |cff1784d1ElvUI|r by\nMerathilis."],
		icon = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\m2",
		iconCoords = {.08, .92, .08, .92},
		get = function(info) return E.db.mui.general[ info[#info] ] end,
		set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER.Title..MER:cOption(MER.Version)..L["by Merathilis (EU-Shattrath)"],
			},
			logo = {
				order = 2,
				type = "description",
				name = L["MER_DESC"],
				fontSize = "medium",
				image = function() return "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI1.tga", 160, 160 end,
			},
			install = {
				order = 3,
				type = "execute",
				name = L["Install"],
				desc = L["Run the installation process."],
				func = function() E:GetModule("PluginInstaller"):Queue(MER.installTable); E:ToggleConfig() end,
			},
			changelog = {
				order = 4,
				type = "execute",
				name = L["Changelog"],
				desc = L['Open the changelog window.'],
				func = function() MER:ToggleChangeLog(); E:ToggleConfig() end,
			},
			modulesButton = CreateButton(5, L["Modules"], "modules"),
			skinsButton = CreateButton(6, L["Skins & AddOns"], "skins"),
			general = {
				order = 7,
				type = "group",
				name = "",
				guiInline = true,
				args = {
					generalHeader = {
						order = 1,
						type = "header",
						name = MER:cOption(L["General"]),
					},
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
					FlightMode = {
						order = 6,
						type = "toggle",
						name = L["FlightMode"],
						desc = L["Enable/Disable the MerathilisUI FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options."],
						hidden = function() return not IsAddOnLoaded("ElvUI_BenikUI") end,
					},
					FlightPoint = {
						order = 7,
						type = "toggle",
						name = L["Flight Point"],
						desc = L["Enable/Disable the MerathilisUI Flight Points on the FlightMap."],
						hidden = function() return IsAddOnLoaded("WorldFlightMap") end,
					},
					CombatState = {
						order = 8,
						type = "toggle",
						name = L["Combat State"],
						desc = L["Enable/Disable the '+'/'-' combat message if you enter/leave the combat."],
					},
					MerchantiLevel = {
						order = 9,
						type = "toggle",
						name = L["Show Merchant ItemLevel"],
						desc = L["Display the item level on the MerchantFrame, to change the font you have to set it in ElvUI - Bags - ItemLevel"],
					},
				},
			},
			info = {
				order = 19,
				type = "group",
				name = L["Information"],
				args = {
					name = {
						order = 1,
						type = "header",
						name = MER.Title,
					},
					support = {
						order = 2,
						type = "group",
						name = MER:cOption(L["Support & Downloads"]),
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
								func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://git.tukui.org/Merathilis/ElvUI_MerathilisUI/issues") end,
							},
							curse = {
								order = 3,
								type = "execute",
								name = L["Curse.com"],
								func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "http://www.curse.com/addons/wow/merathilis-ui") end,
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
								func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://git.tukui.org/Merathilis/ElvUI_MerathilisUI/-/archive/development/ElvUI_MerathilisUI-development.zip") end,
							},
						},
					},
					coding = {
						order = 3,
						type = "group",
						name = MER:cOption(L["Coding"]),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = "description",
								fontSize = "medium",
								name = format("|cffffd200%s|r", "Elv, Benik, Darth Predator, Blazeflack, Simpy <3"),
							},
						},
					},
					testing = {
						order = 4,
						type = "group",
						name = MER:cOption(L["Testing & Inspiration"]),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = "description",
								fontSize = "medium",
								name = format("|cffffd200%s|r", "Benik, Darth Predator, Rockxana, ElvUI community"),
							},
						},
					},
					version = {
						order = 5,
						type = "group",
						name = MER:cOption(L["Version"]),
						guiInline = true,
						args = {
							version = {
								order = 1,
								type = "description",
								fontSize = "medium",
								name = MER.Title..MER.Version,
							},
						},
					},
				},
			},
			modules = {
				order = 20,
				type = "group",
				childGroups = "select",
				name = L["Modules"],
				args = {
					info = {
						type = "description",
						order = 1,
						name = L["Here you find the options for all the different |cffff8000MerathilisUI|r modules.\nPlease use the dropdown to navigate through the modules."],
					},
				},
			},
		},
	}
end
tinsert(MER.Config, AddOptions)