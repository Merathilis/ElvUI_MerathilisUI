local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

local options = module.options.modules.args

options.Notification = {
	type = "group",
	name = module:AddCategorieIcon(L["Notification"], "notifications"),
	get = function(info)
		return E.db.mui.notification[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.notification[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Notification"], "orange"),
		},
		credits = {
			order = 1,
			type = "group",
			name = L["Credits"],
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "description",
					name = "RealUI - Nibelheim, Gethe",
				},
			},
		},
		desc = {
			order = 2,
			type = "description",
			fontSize = "small",
			name = L["Here you can enable/disable the different notification types."],
			disabled = function()
				return not E.db.mui.notification.enable
			end,
		},
		enable = {
			order = 3,
			type = "toggle",
			name = L["Enable"],
		},
		testNotification = {
			order = 3.5,
			type = "execute",
			name = L["Test Notification"],
			desc = L["Sends an example toast notification."],
			func = function()
				MER:GetModule("MER_Notification"):DisplayToast(
					F.cOption("MerathilisUI:", "gradient"),
					L["This is an example of a notification."],
					function()
						F.Print("Banner clicked!")
					end,
					"INTERFACE\\ICONS\\SPELL_FROST_ARCTICWINDS",
					0.08,
					0.92,
					0.08,
					0.92
				)
			end,
			disabled = function()
				return not E.db.mui.notification.enable
			end,
		},
		noSound = {
			order = 4,
			type = "toggle",
			name = L["No Sounds"],
			disabled = function()
				return not E.db.mui.notification.enable
			end,
		},
		mail = {
			order = 5,
			type = "toggle",
			name = L["Enable Mail"],
			disabled = function()
				return not E.db.mui.notification.enable
			end,
		},
		invites = {
			order = 6,
			type = "toggle",
			name = L["Enable Invites"],
			disabled = function()
				return not E.db.mui.notification.enable
			end,
		},
		guildEvents = {
			order = 7,
			type = "toggle",
			name = L["Enable Guild Events"],
			disabled = function()
				return not E.db.mui.notification.enable
			end,
		},
		paragon = {
			order = 8,
			type = "toggle",
			name = L["MISC_PARAGON"],
			disabled = function()
				return not E.db.mui.notification.enable
			end,
		},
		quickJoin = {
			order = 9,
			type = "toggle",
			name = L["Quick Join"],
			disabled = function()
				return not E.db.mui.notification.enable
			end,
		},
		callToArms = {
			order = 10,
			type = "toggle",
			name = _G.BATTLEGROUND_HOLIDAY,
			disabled = function()
				return not E.db.mui.notification.enable
			end,
		},
		bags = {
			order = 11,
			type = "toggle",
			name = L["Bags Full"],
			disabled = function()
				return not E.db.mui.notification.enable
			end,
		},
		greatVault = {
			order = 12,
			type = "toggle",
			name = L["Great Vault"],
			disabled = function()
				return not E.db.mui.notification.enable
			end,
		},
		currencyWarning = {
			order = 15,
			type = "group",
			name = L["Currency Cap Warning"],
			guiInline = true,
			get = function(info)
				return E.db.mui.notification.currencyWarning[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.notification.currencyWarning[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			disabled = function()
				return not E.db.mui.notification.enable
			end,
			args = {
				desc = {
					order = 0,
					type = "description",
					fontSize = "small",
					name = L["Track any currency by ID and get a toast once it nears its weekly or total cap."],
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				threshold = {
					order = 2,
					type = "range",
					name = L["Warn at (%)"],
					min = 50,
					max = 99,
					step = 1,
				},
			},
		},
		vignette = {
			order = 20,
			type = "group",
			name = L["Vignette"],
			guiInline = true,
			get = function(info)
				return E.db.mui.notification.vignette[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.notification.vignette[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			disabled = function()
				return not E.db.mui.notification.enable
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				print = {
					order = 2,
					type = "toggle",
					name = L["Vignette Print"],
				},
				debugPrint = {
					order = 3,
					type = "toggle",
					name = F.cOption(L["Debug Print"], "red"),
					desc = L["Enable this option to get a chat print of the Name and ID from the Vignettes on the Minimap"],
				},
				timeOut = {
					order = 4,
					type = "range",
					name = L["Time Out"],
					desc = L["How long a vignette of the same time should not be notified. In seconds"],
					min = 5,
					max = 120,
					step = 1,
				},
			},
		},
		fontSettings = {
			order = 40,
			type = "group",
			name = L["Font"],
			guiInline = true,
			args = {
				titleFont = {
					order = 1,
					type = "group",
					name = L["Title Font"],
					get = function(info)
						return E.db.mui.notification.titleFont[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.notification.titleFont[info[#info]] = value
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = E.LSM:HashTable("font"),
						},
						size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1,
						},
						style = {
							order = 2,
							type = "select",
							name = L["Outline"],
							values = MER.Values.FontFlags,
							sortByValue = true,
						},
					},
				},
				textFont = {
					order = 2,
					type = "group",
					name = L["Text Font"],
					get = function(info)
						return E.db.mui.notification.textFont[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.notification.textFont[info[#info]] = value
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = E.LSM:HashTable("font"),
						},
						size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1,
						},
						style = {
							order = 2,
							type = "select",
							name = L["Outline"],
							values = MER.Values.FontFlags,
							sortByValue = true,
						},
					},
				},
			},
		},
	},
}

do
	local selectedKey
	local tempID

	options.Notification.args.vignette.args.blacklist = {
		order = 5,
		type = "group",
		inline = true,
		name = L["Blacklist"],
		disabled = function()
			return not E.db.mui.notification.enable
		end,
		args = {
			name = {
				order = 1,
				type = "input",
				name = L["Vignette ID"],
				get = function()
					return tonumber(tempID)
				end,
				set = function(_, value)
					tempID = value
				end,
			},
			addButton = {
				order = 3,
				type = "execute",
				name = L["Add"],
				func = function()
					if tempID then
						E.db.mui.notification.vignette.blacklist[tonumber(tempID)] = true
						tempID = nil
					else
						F.Print(L["Please set the ID first."])
					end
				end,
			},
			spacer = {
				order = 4,
				type = "description",
				name = " ",
				width = "full",
			},
			listTable = {
				order = 5,
				type = "select",
				name = L["Spell List"],
				get = function()
					return selectedKey
				end,
				set = function(_, value)
					selectedKey = value
				end,
				values = function()
					local result = {}
					for fullID in pairs(E.db.mui.notification.vignette.blacklist) do
						result[fullID] = fullID
					end
					return result
				end,
			},
			deleteButton = {
				order = 6,
				type = "execute",
				name = L["Delete"],
				func = function()
					if selectedKey then
						E.db.mui.notification.vignette.blacklist[selectedKey] = nil
					end
				end,
			},
		},
	}
end

do
	local selectedKey

	options.Notification.args.currencyWarning.args.list = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Tracked Currencies"],
		disabled = function()
			return not E.db.mui.notification.enable
		end,
		args = {
			name = {
				order = 1,
				type = "input",
				name = L["Currency ID"],
				desc = L["Enter a currency ID and press Enter to add it."],
				get = function()
					return ""
				end,
				set = function(_, value)
					local id = tonumber(value)
					local currencyInfo = id and C_CurrencyInfo.GetCurrencyInfo(id)
					if currencyInfo and currencyInfo.name and currencyInfo.name ~= "" then
						E.db.mui.notification.currencyWarning.list[id] = true
					else
						F.Print(L["Unknown or undiscovered currency ID."])
					end
				end,
			},
			spacer = {
				order = 4,
				type = "description",
				name = " ",
				width = "full",
			},
			listTable = {
				order = 5,
				type = "select",
				name = L["Currency List"],
				width = 1.3,
				itemControl = "MERDropdownItemIcon",
				get = function()
					return selectedKey
				end,
				set = function(_, value)
					selectedKey = value
				end,
				values = function()
					local result = {}
					for currencyID in pairs(E.db.mui.notification.currencyWarning.list) do
						local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyID)
						result[currencyID] = currencyInfo and currencyInfo.name and format("%s (%d)", currencyInfo.name, currencyID) or currencyID
					end
					return result
				end,
			},
			deleteButton = {
				order = 6,
				type = "execute",
				name = L["Delete"],
				func = function()
					if selectedKey then
						E.db.mui.notification.currencyWarning.list[selectedKey] = nil
						selectedKey = nil
					end
				end,
			},
		},
	}
end
