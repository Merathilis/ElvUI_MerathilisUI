local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

if E.db.mui == nil then E.db.mui = {} end

-- Cache global variables
-- Lua functions
local format = format
local tinsert = table.insert
local select, unpack = select, unpack

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: StaticPopup_Show

local function AddOptions()
	-- Main options
	E.Options.args.mui = {
		order = 9001,
		type = 'group',
		name = MER.Title,
		desc = L['Plugin for |cff1784d1ElvUI|r by\nMerathilis.'],
		args = {
			name = {
				order = 1,
				type = 'header',
				name = MER.Title..MER:cOption(MER.Version)..L['by Merathilis (EU-Shattrath)'],
			},
			logo = {
				order = 2,
				type = 'description',
				name = L['MerathilisUI is an external ElvUI mod. Mostly it changes the Look of your UI. It is high recommended that you download |cff00c0faElvUI BenikUI|r to get the whole Style.\n\nNew Function are marked with:']..MER.NewSign,
				fontSize = 'medium',
				image = function() return 'Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\merathilis_logo.tga', 200, 100 end,
				imageCoords = {0,0.99,0.01,0.99},
			},
			install = {
				order = 3,
				type = 'execute',
				name = L['Install'],
				desc = L['Run the installation process.'],
				func = function() MER:SetupUI(); E:ToggleConfig(); end,
			},
			optionPanel = {
				order = 4,
				type = 'execute',
				name = L['OptionPanel'],
				func = function() MER:OptionPanel(); optionPanel:Show(); E:ToggleConfig(); end,
			},
			spacer1 = {
				order = 5,
				type = 'header',
				name = '',
			},
			general = {
				order = 6,
				type = 'group',
				name = L['General'],
				guiInline = true,
				args = {
					LoginMsg = {
						order = 1,
						type = 'toggle',
						name = L['Login Message'],
						desc = L['Enable/Disable the Login Message in Chat'],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; end,
					},
					SplashScreen = {
						order = 2,
						type = 'toggle',
						name = L['SplashScreen'],
						desc = L['Enable/Disable the Splash Screen on Login.'],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; end,
					},
					AFK = {
						order = 3,
						type = 'toggle',
						name = L['AFK'],
						desc = L['Enable/Disable the MUI AFK Screen'],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					GameMenu = {
						order = 4,
						type = 'toggle',
						name = L['GameMenu'],
						desc = L['Enable/Disable the MerathilisUI Style from the Blizzard GameMenu.'],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					FlightMode = {
						order = 5,
						type = 'toggle',
						name = L['FlightMode'],
						desc = L['Enable/Disable the MerathilisUI FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options.'],
						get = function(info) return E.db.mui.general[ info[#info] ] end,
						set = function(info, value) E.db.mui.general[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
						disabled = function() return not IsAddOnLoaded("ElvUI_BenikUI") end, 
					},
				},
			},
			info = {
				order = 20,
				type = 'group',
				name = L['Information'],
				args = {
					name = {
						order = 1,
						type = 'header',
						name = MER.Title,
					},
					support = {
						order = 2,
						type = 'group',
						name = MER:cOption(L['Support & Downloads']),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = 'execute',
								name = L['Tukui.org'],
								func = function() StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "http://www.tukui.org/addons/index.php?act=view&id=286") end,
								},
							git = {
								order = 2,
								type = 'execute',
								name = L['Git Ticket tracker'],
								func = function() StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "http://git.tukui.org/Merathilis/UI-Settings/issues") end,
							},
							curse = {
								order = 2,
								type = 'execute',
								name = L['Curse.com'],
								func = function() StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "http://www.curse.com/addons/wow/merathilis-ui") end,
							},
						},
					},
					coding = {
						order = 3,
						type = 'group',
						name = MER:cOption(L['Coding']),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = 'description',
								fontSize = 'medium',
								name = format('|cffffd200%s|r', 'Elv, Benik, Darth Predator, Blazeflack'),
							},
						},
					},
					testing = {
						order = 4,
						type = 'group',
						name = MER:cOption(L['Testing & Inspiration']),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = 'description',
								fontSize = 'medium',
								name = format('|cffffd200%s|r', 'Benik, Darth Predator, Rockxana, ElvUI community'),
							},
						},
					},
					addons = {
						order = 5,
						type = 'group',
						name = MER:cOption(L['My other Addon']),
						guiInline = true,
						args = {
							ttic = {
								order = 1,
								type = 'execute',
								name = L['ElvUI Tooltip Icon'],
								desc = L['Adds an Icon for Spells, Items and Achievements (only GameTooltip) to the Tooltip.'],
								func = function() StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "http://www.tukui.org/addons/index.php?act=view&id=269") end,
							},
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, AddOptions)
