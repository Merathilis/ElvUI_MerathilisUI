local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local C = W.Utilities.Color

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
