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
		logLevel = {
			order = 3,
			type = "select",
			name = L["Log Level"],
			desc = L["Only display log message that the level is higher than you choose."]
				.. "\n|cffff3860"
				.. L["Set to 2 if you do not understand the meaning of log level."]
				.. "|r",
			get = function(info)
				return E.global.mui.core.logLevel
			end,
			set = function(info, value)
				E.global.mui.core.logLevel = value
			end,
			hidden = function() end,
			values = {
				[1] = "1 - |cffff3860[ERROR]|r",
				[2] = "2 - |cffffdd57[WARNING]|r",
				[3] = "3 - |cff209cee[INFO]|r",
				[4] = "4 - |cff00d1b2[DEBUG]|r",
			},
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
				return E.global.mui.core.cvarAlert
			end,
			set = function(info, value)
				E.global.mui.core.cvarAlert = value
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
				return E.global.mui.core.guildNews
			end,
			set = function(info, value)
				E.global.mui.core.guildNews = value
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
				return E.global.mui.core.advancedCLEUEventTrace
			end,
			set = function(info, value)
				E.global.mui.core.advancedCLEUEventTrace = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			width = "full",
		},
		forceDisableCPUProfiler = {
			order = 4,
			type = "toggle",
			name = E.NewSign .. L["Disable CPU Profiling"],
			desc = L["If enable it will disable the CPU Profiling CVar. Which can cause some performance issues and should not be enabled by default."],
			get = function(info)
				return E.global.mui.core.forceDisableCPUProfiler
			end,
			set = function(info, value)
				E.global.mui.core.forceDisableCPUProfiler = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			width = "full",
		},
	},
}
