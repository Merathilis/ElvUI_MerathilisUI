local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");

if E.db.mui == nil then E.db.mui = {} end

-- Cache global variables
-- Lua functions
local format = format
local tinsert = table.insert

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: StaticPopup_Show

local function AddOptions()
	-- Main options
	local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
	MER.ACD = ACD
	E.Options.args.mui = {
		order = 9001,
		type = 'group',
		name = MER.Title,
		desc = L["Plugin for |cff1784d1ElvUI|r by\nMerathilis."],
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER.Title..MER:cOption(MER.Version)..L["by Merathilis (EU-Shattrath)"],
			},
			logo = {
				order = 2,
				type = "description",
				name = L["MerathilisUI is an external ElvUI mod. Mostly it changes the Look of your UI. It is high recommended that you download |cff00c0faElvUI BenikUI|r to get the whole Style.\n\n|cff00c0faNew Function are marked with:|r"]..MER.NewSign,
				fontSize = "medium",
				image = function() return "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI1.tga", 150, 150 end,
				imageCoords = {0,0.99,0.01,0.99},
			},
			install = {
				order = 3,
				type = "execute",
				name = L["Install"],
				desc = L["Run the installation process."],
				func = function() E:GetModule("PluginInstaller"):Queue(MER.installTable); E:ToggleConfig() end,
			},
			addons = {
				order = 4,
				type = "execute",
				name = L["AddOn Presets"],
				desc = L["Choose an AddOn Presets, where selected AddOns gets loaded."],
				func = function() E:StaticPopup_Show("MERUI_SelectUI"); E:ToggleConfig() end,
				hidden = function() return not MER:IsDeveloper() and MER:IsDeveloperRealm() end,
			},
			spacer1 = {
				order = 5,
				type = "header",
				name = "",
			},
			general = {
				order = 6,
				type = "group",
				name = MER:cOption(L["General"]),
				guiInline = true,
				args = {
					LoginMsg = {
						order = 1,
						type = "toggle",
						name = L["Login Message"],
						desc = L["Enable/Disable the Login Message in Chat"],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; end,
					},
					SplashScreen = {
						order = 2,
						type = "toggle",
						name = L["SplashScreen"],
						desc = L["Enable/Disable the Splash Screen on Login."],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; end,
					},
					AFK = {
						order = 3,
						type = "toggle",
						name = L["AFK"],
						desc = L["Enable/Disable the MUI AFK Screen"],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					GameMenu = {
						order = 4,
						type = "toggle",
						name = L["GameMenu"],
						desc = L["Enable/Disable the MerathilisUI Style from the Blizzard GameMenu."],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					FlightMode = {
						order = 5,
						type = "toggle",
						name = L["FlightMode"],
						desc = L["Enable/Disable the MerathilisUI FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options."],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
						disabled = function() return not IsAddOnLoaded("ElvUI_BenikUI") end, 
					},
					CombatState = {
						order = 6,
						type = "toggle",
						name = L["Combat State"],
						desc = L["Enable/Disable the '+'/'-' combat message if you enter/leave the combat."],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; end,
					},
					HideOrderhallBar = {
						order = 7,
						type = "toggle",
						name = L["Hide OrderHallBar"],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					MerchantiLevel = {
						order = 8,
						type = "toggle",
						name = L["Show Merchant ItemLevel"],
						desc = L["Display the item level on the MerchantFrame, to change the font you have to set it in ElvUI - Bags - ItemLevel"],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					Notification = {
						order = 9,
						type = "toggle",
						name = L["Notification"]..MER.NewSign,
						desc = L["Display a Toast Frame for different notifications."],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					--[[
					ItemLevelLink = {
						order = 10,
						type = "toggle",
						name = L["ItemLevelLink"]..MER.NewSign,
						desc = L["Display the ItemLevel and other informations in the ItemLink."],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					--]]
				},
			},
			info = {
				order = 30,
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
								func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "http://www.tukui.org/addons/index.php?act=view&id=286") end,
								},
							git = {
								order = 2,
								type = "execute",
								name = L["Git Ticket tracker"],
								func = function() E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "http://git.tukui.org/Merathilis/UI-Settings/issues") end,
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
								name = format("|cffffd200%s|r", "Elv, Benik, Darth Predator, Blazeflack"),
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
		},
	}
end
tinsert(MER.Config, AddOptions)
