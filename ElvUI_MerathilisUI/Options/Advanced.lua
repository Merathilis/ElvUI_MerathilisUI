local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local C = W.Utilities.Color

local options = module.options.advanced.args

local _G = _G
local format = string.format
local select = select

local C_UI_Reload = C_UI.Reload

-- Resets replace the whole table with a fresh copy of the defaults. Merging (E:CopyTable into the
-- current table) kept everything the user added on top, e.g. list entries or custom categories.
-- The reset popup reloads the UI afterwards, so no module keeps a reference to the old table.
local function ResetProfile(...)
	for i = 1, select("#", ...) do
		local key = select(i, ...)
		E.db.mui[key] = E:CopyTable({}, P[key])
	end
end

local function ResetPrivateSkins(key)
	E.private.mui.skins[key] = E:CopyTable({}, V.skins[key])
end

options.core = {
	order = 1,
	type = "group",
	name = module:AddCategorieIcon(L["General"], "OptionsHome"),
	args = {
		header = {
			order = 0,
			type = "header",
			name = L["General"],
		},
		loginMessage = module.ToggleCard({
			order = 1,
			name = L["Login Message"],
			desc = L["The message will be shown in chat when you login."],
			image = I.Media.Icons.Categories.chat,
			get = function()
				return E.global.mui.core.loginMsg
			end,
			set = function(_, value)
				E.global.mui.core.loginMsg = value
			end,
		}, 0.5),
		changlogPopup = module.ToggleCard({
			order = 2,
			name = L["Changelog Popup"],
			desc = L["Show the changelog popup rather than chat message after every update."],
			image = I.Media.Icons.Categories.Changelog,
			get = function()
				return E.global.mui.core.changlogPopup
			end,
			set = function(_, value)
				E.global.mui.core.changlogPopup = value
			end,
		}, 0.5),
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
			name = L["Reset"],
		},
		desc = module.TextCard(
			1,
			F.String.MERATHILISUI(L["This section will help reset specfic settings back to default."])
		),
		general = {
			order = 5,
			type = "execute",
			name = L["General"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["General"], nil, function()
					ResetProfile("general", "style")
				end)
			end,
		},
		gameMenu = {
			order = 6,
			type = "execute",
			name = L["Game Menu"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Game Menu"], nil, function()
					ResetProfile("gameMenu")
				end)
			end,
		},
		scale = {
			order = 7,
			type = "execute",
			name = L["Scale"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Scale"], nil, function()
					ResetProfile("scale")
				end)
			end,
		},
		misc = {
			order = 8,
			type = "execute",
			name = L["Misc"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Misc"], nil, function()
					ResetProfile("misc", "lootSpecManager", "elvUIIcons")
				end)
			end,
		},
		actionbars = {
			order = 9,
			type = "execute",
			name = L["ActionBars"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["ActionBars"], nil, function()
					ResetProfile("actionbars")
				end)
			end,
		},
		chat = {
			order = 9.1,
			type = "execute",
			name = L["Chat"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Chat"], nil, function()
					ResetProfile("chat")
				end)
			end,
		},
		nameplates = {
			order = 9.2,
			type = "execute",
			name = L["NamePlates"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["NamePlates"], nil, function()
					ResetProfile("nameplates")
				end)
			end,
		},
		colorModifiers = {
			order = 10,
			type = "execute",
			name = L["Color Modifier Keys"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Color Modifier Keys"], nil, function()
					ResetProfile("colorModifiers")
				end)
			end,
		},
		armory = {
			order = 11,
			type = "execute",
			name = L["Armory"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Armory"], nil, function()
					ResetProfile("armory")
				end)
			end,
		},
		bags = {
			order = 12,
			type = "execute",
			name = L["Bags"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Bags"], nil, function()
					ResetProfile("bags")
				end)
			end,
		},
		buffReminder = {
			order = 13,
			type = "execute",
			name = L["Buff Reminder"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Buff Reminder"], nil, function()
					ResetProfile("buffReminder")
				end)
			end,
		},
		cursor = {
			order = 14,
			type = "execute",
			name = L["Cursor"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Cursor"], nil, function()
					ResetProfile("cursor")
				end)
			end,
		},
		itemLevel = {
			order = 15,
			type = "execute",
			name = L["Item Level"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Item Level"], nil, function()
					ResetProfile("itemLevel")
				end)
			end,
		},
		lootRoll = {
			order = 15.5,
			type = "execute",
			name = L["Loot Roll"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Loot Roll"], nil, function()
					ResetProfile("lootRoll")
				end)
			end,
		},
		mail = {
			order = 16,
			type = "execute",
			name = L["Mail"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Mail"], nil, function()
					ResetProfile("mail")
				end)
			end,
		},
		locationPanel = {
			order = 17,
			type = "execute",
			name = L["Location Panel"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Location Panel"], nil, function()
					ResetProfile("locationPanel")
					F.Event.TriggerEvent("LocationPanel.DatabaseUpdate")
				end)
			end,
		},
		minimapButtons = {
			order = 18,
			type = "execute",
			name = L["Minimap Buttons"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Minimap Buttons"], nil, function()
					ResetProfile("minimapButtons")
				end)
			end,
		},
		movementAlert = {
			order = 18.5,
			type = "execute",
			name = L["Movement Alert"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Movement Alert"], nil, function()
					ResetProfile("movementAlert")
					MER:GetModule("MER_MovementAlert"):ProfileUpdate()
				end)
			end,
		},
		nameHover = {
			order = 19,
			type = "execute",
			name = L["Name Hover"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Name Hover"], nil, function()
					ResetProfile("nameHover")
				end)
			end,
		},
		notification = {
			order = 20,
			type = "execute",
			name = L["Notification"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Notification"], nil, function()
					ResetProfile("notification")
				end)
			end,
		},
		panels = {
			order = 21,
			type = "execute",
			name = L["Panels"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Panels"], nil, function()
					ResetProfile("panels")
				end)
			end,
		},
		theme = {
			order = 22,
			type = "execute",
			name = L["Theme"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Theme"], nil, function()
					ResetProfile("themes")
				end)
			end,
		},
		tracker = {
			order = 22.5,
			type = "execute",
			name = L["Tracker"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Tracker"], nil, function()
					ResetProfile("tracker")
					MER:GetModule("MER_Tracker"):ProfileUpdate()
				end)
			end,
		},
		unitframes = {
			order = 23,
			type = "execute",
			name = L["UnitFrames"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["UnitFrames"], nil, function()
					ResetProfile("unitframes")
				end)
			end,
		},
		vehicleBar = {
			order = 24,
			type = "execute",
			name = L["VehicleBar"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["VehicleBar"], nil, function()
					ResetProfile("vehicleBar")
				end)
			end,
		},
		auras = {
			order = 25,
			type = "execute",
			name = L["Auras"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Auras"], nil, function()
					ResetProfile("auras")
				end)
			end,
		},
		datatexts = {
			order = 27,
			type = "execute",
			name = L["DataTexts"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["DataTexts"], nil, function()
					ResetProfile("datatexts")
				end)
			end,
		},
		tooltip = {
			order = 29,
			type = "execute",
			name = L["Tooltip"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Tooltip"], nil, function()
					ResetProfile("tooltip")
				end)
			end,
		},
		spacer1 = {
			order = 30,
			type = "description",
			name = " ",
		},
		blizzard = {
			order = 31,
			type = "execute",
			name = L["Blizzard"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Blizzard"], nil, function()
					ResetPrivateSkins("blizzard")
				end)
			end,
		},
		addonSkins = {
			order = 32,
			type = "execute",
			name = L["Addons"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Addon Skins"], nil, function()
					ResetPrivateSkins("addonSkins")
				end)
			end,
		},
		embed = {
			order = 33,
			type = "execute",
			name = L["Embed Settings"],
			func = function()
				E:StaticPopup_Show("MERATHILISUI_RESET_MODULE", L["Embed Settings"], nil, function()
					ResetPrivateSkins("embed")
				end)
			end,
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
			-- Only reload on success, otherwise the error message would be lost
			if F.Profiles.ImportByString(text) then
				C_UI_Reload()
			end
		end,
		whileDead = 1,
		hideOnEscape = true,
	}

	options.profiles = {
		order = 5,
		type = "group",
		name = L["Profiles"],
		args = {
			desc = module.TextCard(1, format(L["Import and export your %s settings."], MER.Title)),
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
