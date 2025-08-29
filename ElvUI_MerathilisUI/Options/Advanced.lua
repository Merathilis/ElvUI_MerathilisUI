local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.advanced.args

local _G = _G
local format = format

local newSignIgnored = [[|TInterface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon:14:14|t]]

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
			get = function(info)
				return E.global.mui.core.loginMsg
			end,
			set = function(info, value)
				E.global.mui.core.loginMsg = value
			end,
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
			get = function(info)
				return E.global.mui.advancedOptions.cvarAlert
			end,
			set = function(info, value)
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
			get = function(info)
				return E.global.mui.advancedOptions.guildNews
			end,
			set = function(info, value)
				E.global.mui.advancedOptions.guildNews = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			width = "full",
		},
		advancedCLEUEventTrace = {
			order = 3,
			type = "toggle",
			name = L["Advanced CLEU Etrace"],
			desc = L["Enhanced Combat Log Events in /etrace frame."],
			get = function(info)
				return E.global.mui.advancedOptions.advancedCLEUEventTrace
			end,
			set = function(info, value)
				E.global.mui.advancedOptions.advancedCLEUEventTrace = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			width = "full",
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
				.. "\n|cffff3860"
				.. L["Set to 2 if you do not understand the meaning of log level."]
				.. "|r",
			get = function(_)
				return E.global.mui.developer.logLevel
			end,
			set = function(_, value)
				E.global.mui.developer.logLevel = value
			end,
			values = {
				[1] = "1 - |cffff3860[ERROR]|r",
				[2] = "2 - |cffffdd57[WARNING]|r",
				[3] = "3 - |cff209cee[INFO]|r",
				[4] = "4 - |cff00d1b2[DEBUG]|r",
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
