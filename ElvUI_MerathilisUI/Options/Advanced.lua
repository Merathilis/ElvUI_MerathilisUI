local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local C = W.Utilities.Color

local options = module.options.advanced.args

local _G = _G
local format = string.format

local C_UI_Reload = C_UI.Reload

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
		changlogPopup = {
			order = 2,
			type = "toggle",
			name = L["Changelog Popup"],
			desc = L["Show the changelog popup rather than chat message after every update."],
			get = function(info)
				return E.global.mui.core.changlogPopup
			end,
			set = function(info, value)
				E.global.mui.core.changlogPopup = value
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

do
	local text = ""

	E.PopupDialogs.MERATHILISUI_IMPORT_STRING = {
		text = format(
			"%s\n%s",
			L["Are you sure you want to import this string?"],
			C.StringByTemplate(format(L["It will override your %s setting."], MER.Title), "rose-500")
		),
		button1 = _G.ACCEPT,
		button2 = _G.CANCEL,
		OnAccept = function()
			F.Profiles.ImportByString(text)
			C_UI_Reload()
		end,
		whileDead = 1,
		hideOnEscape = true,
	}

	options.profiles = {
		order = 5,
		type = "group",
		name = E.NewSign .. L["Profiles"],
		args = {
			desc = {
				order = 1,
				type = "group",
				inline = true,
				name = L["Description"],
				args = {
					feature = {
						order = 1,
						type = "description",
						name = format(L["Import and export your %s settings."], MER.Title),
						fontSize = "medium",
					},
				},
			},
			textArea = {
				order = 2,
				type = "group",
				inline = true,
				name = format("%s %s", MER.Title, L["String"]),
				args = {
					text = {
						order = 1,
						type = "input",
						name = " ",
						multiline = 15,
						width = "full",
						get = function()
							return text
						end,
						set = function(_, value)
							text = value
						end,
					},
					importButton = {
						order = 2,
						type = "execute",
						name = L["Import"],
						func = function()
							if text ~= "" then
								E:StaticPopup_Show("MERATHILISUI_IMPORT_STRING")
							end
						end,
					},
					exportAllButton = {
						order = 3,
						type = "execute",
						name = L["Export All"],
						desc = format(L["Export all setting of %s."], MER.Title),
						func = function()
							text = F.Profiles.GetOutputString(true, true)
						end,
					},
					exportProfileButton = {
						order = 4,
						type = "execute",
						name = L["Export Profile"],
						desc = format(L["Export the setting of %s that stored in ElvUI Profile database."], MER.Title),
						func = function()
							text = F.Profiles.GetOutputString(true, false)
						end,
					},
					exportPrivateButton = {
						order = 5,
						type = "execute",
						name = L["Export Private"],
						desc = format(L["Export the setting of %s that stored in ElvUI Private database."], MER.Title),
						func = function()
							text = F.Profiles.GetOutputString(false, true)
						end,
					},
					betterAlign = {
						order = 6,
						type = "description",
						fontSize = "small",
						name = " ",
						width = "full",
					},
					tip = {
						order = 7,
						type = "description",
						name = format(
							"%s\n%s\n%s\n%s\n%s",
							C.StringByTemplate(L["I want to sync setting of MerathilisUI!"], "blue-500"),
							L["MerathilisUI saves all data in ElvUI Profile and Private database."],
							L["So if you set ElvUI Profile and Private these |cffff0000TWO|r databases to the same across multiple character, the setting of MerathilisUI will be synced."],
							L["Sharing ElvUI Profile is a very common thing nowadays, but actually ElvUI Private database is also exist for saving configuration of General, Skins, etc."],
							L["Check the setting of ElvUI Private database in ElvUI Options -> Profiles -> Private (tab)."]
						),
						width = "full",
					},
				},
			},
			autoCopyPrivateProfileGroup = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Auto Copy Private Profile"],
				args = {
					desc = {
						order = 1,
						type = "description",
						name = format(
							"%s\n%s\n%s\n%s",
							L["Automatically copy the selected private profile to a new character on first login."],
							L["This is useful when you have multiple characters but want to use a specific private profile as the starting point for new ones."],
							L["If you simply want to share the same private settings across all characters, it is recommended to set the same private profile for them in ElvUI > Profiles > Private."],
							L["Note: This feature only copies the private profile once per character. It does not synchronize settings afterwards."]
						),
					},
					enable = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
						get = function()
							return E.global.mui.core.autoCopyPrivateProfile.enable
						end,
						set = function(_, value)
							E.global.mui.core.autoCopyPrivateProfile.enable = value
						end,
					},
					copyFrom = {
						order = 3,
						type = "select",
						name = L["Copy From"],
						desc = L["The profile from which the private settings will be copied."],
						get = function()
							return E.global.mui.core.autoCopyPrivateProfile.copyFrom or "__NOT_SET__"
						end,
						set = function(_, value)
							E.global.mui.core.autoCopyPrivateProfile.copyFrom = value ~= "__NOT_SET__" and value
						end,
						hidden = function()
							return not E.global.mui.core.autoCopyPrivateProfile.enable
						end,
						values = function()
							local profilesNames = E.charSettings:GetProfiles()
							local result = {
								["__NOT_SET__"] = L["Not Set"],
							}
							for _, profileName in ipairs(profilesNames) do
								result[profileName] = _G[profileName] or profileName
							end
							return result
						end,
						width = 1.5,
					},
					clearInitializedCharacters = {
						order = 4,
						type = "execute",
						name = L["Clear Initialized Characters"],
						desc = L["Clear the record of initialized characters, allowing the profile to be copied again on next login."],
						func = function()
							E.global.mui.core.autoCopyPrivateProfile.initializedCharacters = {}
							E:StaticPopup_Show("PRIVATE_RL")
						end,
						hidden = function()
							return not E.global.mui.core.autoCopyPrivateProfile.enable
						end,
						width = 1.5,
					},
				},
			},
		},
	}
end
