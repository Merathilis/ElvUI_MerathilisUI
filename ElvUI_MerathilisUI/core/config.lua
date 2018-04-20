local MER, E, L, V, P, G = unpack(select(2, ...))

if E.db.mui == nil then E.db.mui = {} end

-- Cache global variables
-- Lua functions
local format = format
local tinsert = table.insert
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: StaticPopup_Show

local function AddOptions()
	E.Options.args.ElvUI_Header.name = E.Options.args.ElvUI_Header.name.." + |cffff7d0aMerathilisUI|r"..format(": |cFF00c0fa%s|r", MER.Version)

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
				name = L["MerathilisUI is an external ElvUI mod. Mostly it changes the look to be more transparency.\n\n|cff00c0faNew Function are marked with:|r"]..MER.NewSign,
				fontSize = "medium",
				image = function() return "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI1.tga", 125, 125 end,
				imageCoords = { 0, 0.99, 0.01, 0.99 },
			},
			install = {
				order = 3,
				type = "execute",
				name = L["Install"],
				desc = L["Run the installation process."],
				func = function() E:GetModule("PluginInstaller"):Queue(MER.installTable); E:ToggleConfig() end,
			},
			general = {
				order = 5,
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
					chatButton = {
						order = 10,
						type = "toggle",
						name = L["Chat Menu"]..MER.NewSign,
						desc = L["Create a chat button to increase the chat size and chat menu button."],
						get = function(info) return E.db.mui.chat[ info[#info] ] end,
						set = function(info, value) E.db.mui.chat[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					iLevelLink = {
						order = 11,
						type = "toggle",
						name = L["Chat Item Level"],
						desc = L["Shows the slot and item level in the chat"],
						get = function(info) return E.db.mui.chat[ info[#info] ] end,
						set = function(info, value) E.db.mui.chat[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					hidePlayerBrackets = {
						order = 12,
						type = "toggle",
						name = L["Hide Player Brackets"]..MER.NewSign,
						desc = L["Removes brackets around the person who posts a chat message."],
						get = function(info) return E.db.mui.chat[ info[#info] ] end,
						set = function(info, value) E.db.mui.chat[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},

				},
			},
			info = {
				order = 6,
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
					changelog = {
						order = 5,
						type = "group",
						name = MER:cOption(L["Changelog"]),
						guiInline = true,
						args = {
							changelog = {
								order = 1,
								type = "execute",
								name = L["Changelog"],
								func = function() MER:ToggleChangeLog(); E:ToggleConfig() end,
							},
						},
					},
					version = {
						order = 6,
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
			Notification = {
				order = 8,
				type = "group",
				name = L["Notification"],
				get = function(info) return E.db.mui.general.Notification[ info[#info] ] end,
				set = function(info, value) E.db.mui.general.Notification[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					notificationHeader = {
						order = 1,
						type = "header",
						name = MER:cOption(L["Notification"]),
					},
					general = {
						order = 2,
						type = "group",
						guiInline = true,
						name = MER:cOption(L["General"]),
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
							},
							Header1 = {
								order = 2,
								type = "header",
								name = MER:cOption(L["Settings"]),
								disabled = function() return not E.db.mui.general.Notification.enable end,
								hidden = function() return not E.db.mui.general.Notification.enable end,
							},
							desc = {
								order = 3,
								type = "description",
								fontSize = "small",
								name = L["Here you can enable/disable the different notification types."],
								disabled = function() return not E.db.mui.general.Notification.enable end,
								hidden = function() return not E.db.mui.general.Notification.enable end,
							},
							mail = {
								order = 4,
								type = "toggle",
								name = L["Enable Mail"],
								disabled = function() return not E.db.mui.general.Notification.enable end,
								hidden = function() return not E.db.mui.general.Notification.enable end,
							},
							vignette = {
								order = 5,
								type = "toggle",
								name = L["Enable Vignette"],
								desc = L["If a Rar Mob or a treasure gets spotted on the minimap."],
								disabled = function() return not E.db.mui.general.Notification.enable end,
								hidden = function() return not E.db.mui.general.Notification.enable end,
							},
							invites = {
								order = 6,
								type = "toggle",
								name = L["Enable Invites"],
								disabled = function() return not E.db.mui.general.Notification.enable end,
								hidden = function() return not E.db.mui.general.Notification.enable end,
							},
							guildEvents = {
								order = 7,
								type = "toggle",
								name = L["Enable Guild Events"],
								disabled = function() return not E.db.mui.general.Notification.enable end,
								hidden = function() return not E.db.mui.general.Notification.enable end,
							},
							quickJoin = {
								order = 7,
								type = "toggle",
								name = L["Enable Quick Join Notification"],
								disabled = function() return not E.db.mui.general.Notification.enable end,
								hidden = function() return not E.db.mui.general.Notification.enable end,
							},
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, AddOptions)