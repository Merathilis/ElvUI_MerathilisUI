local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local C = MER.Utilities.Color

local options = MER.options.advanced.args

local _G = _G
local format = format

options.core = {
	order = 1,
	type = "group",
	name = L["Core"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["General"], "orange"),
		},
		loginMessage = {
			order = 1,
			type = "toggle",
			name = L["Login Message"],
			desc = L["The message will be shown in chat when you login."],
			get = function()
				return E.global.mui.core.loginMsg
			end,
			set = function(_, value)
				E.global.mui.core.loginMsg = value
			end,
		},
		compatibilityCheck = {
			order = 2,
			type = "toggle",
			name = L["Compatibility Check"],
			desc = L["Help you to enable/disable the modules for a better experience with other plugins."],
			get = function()
				return E.global.mui.core.compatibilityCheck
			end,
			set = function(_, value)
				E.global.mui.core.compatibilityCheck = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
	},
}

options.gameFix = {
	order = 2,
	type = "group",
	name = L["Blizzard Fixes"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Blizzard Fixes"], "orange"),
		},
		cvarAlert = {
			order = 1,
			type = "toggle",
			name = L["CVar Alert"],
			desc = format(
				L["It will alert you to reload UI when you change the CVar %s."],
				"|cff209ceeActionButtonUseKeyDown|r"
			),
			get = function()
				return E.global.mui.advancedOptions.cvarAlert
			end,
			set = function(_, value)
				E.global.mui.advancedOptions.cvarAlert = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			width = "full",
		},
		guildNews = {
			order = 2,
			type = "toggle",
			name = L["Guild News"],
			desc = L["This will fix the current Guild News jam."],
			get = function()
				return E.global.mui.advancedOptions.guildNews
			end,
			set = function(_, value)
				E.global.mui.advancedOptions.guildNews = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			width = 2,
		},
		advancedCLEUEventTrace = {
			order = 3,
			type = "toggle",
			name = L["Advanced CLEU Etrace"],
			desc = L["Enhanced Combat Log Events in /etrace frame."],
			get = function()
				return E.global.mui.advancedOptions.advancedCLEUEventTrace
			end,
			set = function(_, value)
				E.global.mui.advancedOptions.advancedCLEUEventTrace = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			width = "full",
		},
		fixSetPassThroughButtons = {
			order = 3,
			type = "toggle",
			name = L["Fix SetPassThroughButtons"],
			desc = L["Fix the issue that sometimes SetPassThroughButtons got tainted."],
			get = function(info)
				return E.global.mui.advancedOptions.fixSetPassThroughButtons
			end,
			set = function(info, value)
				E.global.mui.advancedOptions.fixSetPassThroughButtons = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			width = 2,
		},
	},
}

options.developer = {
	order = 3,
	type = "group",
	name = L["Developer"],
	args = {
		logLevel = {
			order = 1,
			type = "select",
			name = L["Log Level"],
			desc = L["Only display log message that the level is higher than you choose."]
				.. "\n"
				.. C.StringByTemplate(L["Set to 2 if you do not understand the meaning of log level."], "rose-500"),
			get = function(_)
				return E.global.mui.developer.logLevel
			end,
			set = function(_, value)
				E.global.mui.developer.logLevel = value
			end,
			values = {
				[1] = "1 - |cffff2457[ERROR]|r",
				[2] = "2 - |cfffdc600[WARNING]|r",
				[3] = "3 - |cff00a4f3[INFO]|r",
				[4] = "4 - |cff00d3bc[DEBUG]|r",
			},
		},
		tableAttributeDisplay = {
			order = 2,
			type = "group",
			name = L["Table Attribute Display"],
			desc = L["Modify the debug tool that displays table attributes."],
			inline = true,
			get = function(info)
				return E.global.mui.developer.tableAttributeDisplay[info[#info]]
			end,
			set = function(info, value)
				E.global.mui.developer.tableAttributeDisplay[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
				},
				width = {
					order = 1,
					type = "range",
					name = L["Width"],
					min = 0,
					max = 2000,
					step = 10,
				},
				height = {
					order = 2,
					type = "range",
					name = L["Height"],
					min = 0,
					max = 2000,
					step = 10,
				},
			},
		},
	},
}

options.reset = {
	order = 4,
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
		cooldownViewer = {
			order = 11,
			type = "execute",
			name = L["Cooldown Viewer"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Cooldown Viewer"], nil, function()
					E.private.mui.skins.cooldownViewer = V.skins.cooldownViewer
				end)
			end,
		},
		blizzard = {
			order = 12,
			type = "execute",
			name = L["Blizzard"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Blizzard"], nil, function()
					E.private.mui.skins.blizzard = V.skins.blizzard
				end)
			end,
		},
		addonSkins = {
			order = 6,
			type = "execute",
			name = L["Addons"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Addon Skins"], nil, function()
					E.private.mui.skins.addonSkins = V.skins.addonSkins
				end)
			end,
		},
		libraries = {
			order = 6,
			type = "execute",
			name = L["Libraries"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Libraries"], nil, function()
					E.private.mui.skins.libraries = V.skins.libraries
				end)
			end,
		},
		widgets = {
			order = 8,
			type = "execute",
			name = L["Widgets"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Widgets"], nil, function()
					E.private.mui.skins.widgets = V.skins.widgets
				end)
			end,
		},
		spacer1 = {
			order = 15,
			type = "description",
			name = " ",
		},
		misc = {
			order = 16,
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
			order = 50,
			type = "description",
			name = " ",
		},
		resetAllModules = {
			order = 51,
			type = "execute",
			name = L["Reset All Modules"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_ALL_MODULES")
			end,
			width = "full",
		},
	},
}
