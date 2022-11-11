local MER, F, E, L, V, P, G = unpack(select(2, ...))
local options = MER.options.advanced.args

local _G = _G
local format = format

options.core = {
	order = 1,
	type = "group",
	name = L["Core"],
	args = {
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
			}
		}
	}
}

options.gameFix = {
	order = 2,
	type = "group",
	name = L["Game Fix"],
	args = {
		fixCVAR = {
			order = 1,
			type = "toggle",
			name = L["CVar Alert"],
			desc = format(
				L["It will alert you to reload UI when you change the CVar %s."],
				"|cff209ceeActionButtonUseKeyDown|r"
			),
			get = function(info)
				return E.global.mui.core.fixCVAR
			end,
			set = function(info, value)
				E.global.mui.core.fixCVAR = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			width = "full"
		},
		fixLFG = {
			order = 2,
			type = "toggle",
			name = L["Fix LFG Frame error"],
			desc = L["Fix a PlayerStyle lua error that can happen on the LFG Frame."],
			get = function(info)
				return E.global.mui.core.fixLFG
			end,
			set = function(info, value)
				E.global.mui.core.fixLFG = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			width = "full"
		}
	}
}
