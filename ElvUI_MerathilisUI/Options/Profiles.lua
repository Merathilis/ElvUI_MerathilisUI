local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local Profile = MER:GetModule("MER_Profiles")
	local C = W.Utilities.Color
	local LSM = E.Libs.LSM

	local options = module.options.profiles.args

	local _G = _G
	local format, ipairs, unpack = format, ipairs, unpack
	local strfind, strlower = strfind, strlower

	local C_UI_Reload = C_UI.Reload
	local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

	local Ok = F.GetIconString(I.Media.Icons.Ok, 14, 14)
	local No = F.GetIconString(I.Media.Icons.No, 14, 14)

	-- "DEFAULT" in the override tables means "keep the font / outline the profile uses"
	local OutlineValues = E:CopyTable({ DEFAULT = L["Default"] }, MER.Values.FontFlags)

	-- Font + outline override for one of the fonts the ElvUI profile is built from
	local function FontOverrideGroup(order, name, baseFont)
		return {
			order = order,
			type = "group",
			inline = true,
			name = name,
			args = {
				font = {
					order = 1,
					type = "select",
					dialogControl = "LSM30_Font",
					name = L["Font"],
					values = LSM:HashTable("font"),
					get = function()
						return F.FontOverride(baseFont)
					end,
					set = function(_, value)
						-- picking the base font again clears the override
						E.db.mui.general.fontOverride[baseFont] = value == baseFont and "DEFAULT" or value
					end,
				},
				outline = {
					order = 2,
					type = "select",
					name = L["Outline"],
					desc = L["Default keeps the outline each element uses in the profile."],
					values = OutlineValues,
					sortByValue = true,
					get = function()
						return E.db.mui.general.fontStyleOverride[baseFont] or "DEFAULT"
					end,
					set = function(_, value)
						E.db.mui.general.fontStyleOverride[baseFont] = value
					end,
				},
			},
		}
	end

	options.fonts = {
		order = 1,
		type = "group",
		name = L["Fonts"],
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L["This group allows to update all fonts used in the "]
					.. MER.Title
					.. " "
					.. F.String.ElvUI()
					.. " Profile.\n\n"
					.. F.String.Error(
						L["WARNING: Some fonts might still not look ideal! The results will not be ideal, but it should help you customize the fonts :)\n"]
					),
				fontSize = "medium",
			},
			header = {
				order = 2,
				type = "header",
				name = L["Fonts"],
			},
			applyButton = {
				order = 3,
				type = "execute",
				name = Ok .. F.String.Good(L[" Apply"]),
				desc = L["Applies all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."],
				func = function()
					Profile:ApplyFontChange()
				end,
			},
			resetButton = {
				order = 4,
				type = "execute",
				name = No .. F.String.Error(L[" Reset"]),
				desc = L["Resets all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."],
				func = function()
					E.db.mui.general.fontOverride = E:CopyTable({}, P.general.fontOverride)
					E.db.mui.general.fontStyleOverride = E:CopyTable({}, P.general.fontStyleOverride)
					E.db.mui.general.fontScale = P.general.fontScale

					Profile:ApplyFontChange()
				end,
			},
			spacer = {
				order = 5,
				type = "description",
				name = "",
			},
			applyHint = {
				order = 6,
				type = "description",
				name = F.String.Warning(L["Changes are only applied to the ElvUI profile after clicking Apply."]),
				fontSize = "medium",
			},
			primaryFont = FontOverrideGroup(7, L["Main Font"], I.Fonts.Primary),
			numberFont = FontOverrideGroup(8, L["Number Font"], I.Fonts.GothamRaid),
			fontScale = {
				order = 9,
				type = "range",
				name = L["Font Size Offset"],
				desc = L["Added to every font size the profile sets."],
				min = -4,
				max = 4,
				step = 1,
				get = function()
					return E.db.mui.general.fontScale
				end,
				set = function(_, value)
					E.db.mui.general.fontScale = value
				end,
			},
		},
	}

	options.addons = {
		order = 2,
		type = "group",
		name = L["AddOns"],
		args = {
			info = {
				order = 1,
				type = "description",
				name = F.String.MERATHILISUI(L["MER_PROFILE_DESC"]),
				fontSize = "medium",
			},
			space = {
				order = 2,
				type = "description",
				name = "",
			},
			header = {
				order = 3,
				type = "header",
				name = L["Profiles"],
			},
		},
	}

	for index, v in ipairs(I.AddOnProfiles) do
		local addon, addonName, applyMethod = unpack(v)

		local iconTexture = GetAddOnMetadata(addon, "IconTexture")
		local iconAtlas = GetAddOnMetadata(addon, "IconAtlas")

		if not iconTexture and not iconAtlas then
			iconTexture = [[Interface\ICONS\INV_Misc_QuestionMark]]
		end

		-- Spell icons get their built-in border cropped, like everywhere else in ElvUI
		local imageCoords = iconTexture and strfind(strlower(iconTexture), "^interface[\\/]icons[\\/]") and E.TexCoords
		-- Enabling an AddOn needs a reload, so the state at load time stays valid
		local enabled = E:IsAddOnEnabled(addon)

		options.addons.args[addon] = {
			order = 3 + index,
			type = "execute",
			dialogControl = "MERLinkTile",
			name = addonName,
			desc = L["This will create and apply profile for "] .. addonName,
			image = iconTexture,
			imageCoords = imageCoords,
			width = "relative",
			relWidth = 0.333,
			arg = {
				subtitle = enabled and L["Create and apply the profile"] or L["AddOn is not enabled"],
				atlas = not iconTexture and iconAtlas or nil,
			},
			func = function()
				Profile[applyMethod](Profile)
			end,
			disabled = not enabled,
		}
	end

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

		options.importExport = {
			order = 3,
			type = "group",
			name = L["Import / Export"],
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
							desc = format(
								L["Export the setting of %s that stored in ElvUI Profile database."],
								MER.Title
							),
							func = function()
								text = F.Profiles.GetOutputString(true, false)
							end,
						},
						exportPrivateButton = {
							order = 5,
							type = "execute",
							name = L["Export Private"],
							desc = format(
								L["Export the setting of %s that stored in ElvUI Private database."],
								MER.Title
							),
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
			},
		}
	end

	options.importExport.args.autoCopyPrivateProfile = {
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
	}
end)
