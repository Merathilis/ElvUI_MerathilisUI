local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local options = MER.options.skins.args
local C = MER.Utilities.Color
local LSM = E.Libs.LSM

local _G = _G
local ipairs, pairs, unpack = ipairs, pairs, unpack
local format = string.format
local tinsert = table.insert

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local DecorAddons = {
	{ "ACP", L["AddOn Control Panel"], "acp" },
	{ "ActionBarProfiles", L["ActonBarProfiles"], "abp" },
	{ "AngrierWorldQuests", L["Angrier World Quests"], "awq" },
	{ "Auctionator", L["Auctionator"], "au" },
	{ "BagSync", L["BagSync"], "bSync" },
	{ "BtWQuests", L["BtWQuests"], "btwQ" },
	{ "Capping", L["Capping"], "cap" },
	{ "cargBags_Nivaya", L["cargBags_Nivaya"], "cbn" },
	{ "Clique", L["Clique"], "cl" },
	{ "ElvUI_BenikUI", L["BenikUI"], "bui" },
	{ "ElvUI_mMediaTag", L["mMediaTag & Tools"], "mmt" },
	{ "BugSack", L["BugSack"], "bs" },
	{ "GlobalIgnoreList", L["GlobalIgnoreList"], "gil" },
	{ "Immersion", L["Immersion"], "imm" },
	{ "MythicDungeonTools", L["Mythic Dungeon Tools"], "mdt" },
	{ "Myslot", L["Myslot"], "mys" },
	{ "OmniCD", L["OmniCD"], "omniCD" },
	{ "Pawn", L["Pawn"], "pawn" },
	{ "tdBattlePetScript", L["Pet Battle Scripts"], "pbs" },
	{ "ProjectAzilroka", L["ProjectAzilroka"], "pa" },
	{ "PremadeGroupsFilter", L["PremadeGroupsFilter"], "pf" },
	{ "RaiderIO", L["RaiderIO"], "rio" },
	{ "Rematch", L["Rematch"], "rem" },
	{ "SimpleAddonManager", L["Simple Addon Manager"], "sam" },
	{ "ls_Toasts", L["ls_Toasts"], "ls" },
	{ "TomTom", L["TomTom"], "tom" },
}
if F.IsDeveloper() then
	tinsert(DecorAddons, { "WeakAuras", L["WeakAuras"], "wa" })
	tinsert(DecorAddons, { "WeakAurasOptions", L["WeakAuras Options"], "waOptions" })
end

local function UpdateToggleDirection()
	module:RefreshToggleDirection()
end

local function ResetDetails()
	StaticPopup_Show("RESET_DETAILS")
end

options.general = {
	order = 1,
	type = "group",
	name = L["General"],
	get = function(info)
		return E.private.mui.skins[info[#info]]
	end,
	set = function(info, value)
		E.private.mui.skins[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["General"], "orange"),
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			width = "full",
			get = function(info)
				return E.private.mui.skins[info[#info]]
			end,
			set = function(info, value)
				E.private.mui.skins[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			disabled = function()
				return not E.private.mui.skins.enable
			end,
			args = {
				shadowOverlay = {
					order = 1,
					type = "toggle",
					name = L["Screen Shadow Overlay"],
					desc = L["Enables/Disables a shadow overlay to darken the screen."],
				},
				shadow = {
					order = 8,
					type = "group",
					name = F.cOption(L["Shadows"], "orange"),
					guiInline = true,
					get = function(info)
						return E.private.mui.skins.shadow[info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.shadow[info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
						},
						increasedSize = {
							order = 2,
							type = "range",
							name = L["Increase Size"],
							desc = L["Make shadow thicker."],
							min = 0,
							max = 10,
							step = 1,
						},
						color = {
							order = 3,
							type = "color",
							name = L["Shadow Color"],
							hasAlpha = false,
							get = function(info)
								local db = E.private.mui.skins.shadow.color
								local default = V.skins.shadow.color
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.shadow.color
								db.r, db.g, db.b = r, g, b
								E:StaticPopup_Show("PRIVATE_RL")
							end,
							disabled = function()
								return not E.private.mui.skins.enable
							end,
						},
					},
				},
			},
		},
	},
}

options.font = {
	order = 2,
	type = "group",
	name = L["Fonts"],
	args = {
		actionStatus = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Action Status"],
			get = function(info)
				return E.private.mui.skins.actionStatus[info[#info]]
			end,
			set = function(info, value)
				E.private.mui.skins.actionStatus[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				name = {
					order = 1,
					type = "select",
					dialogControl = "LSM30_Font",
					name = L["Font"],
					values = LSM:HashTable("font"),
				},
				style = {
					order = 2,
					type = "select",
					name = L["Outline"],
					values = MER.Values.FontFlags,
				},
				size = {
					order = 3,
					name = L["Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
			},
		},
		rollResult = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Roll Result"],
			get = function(info)
				return E.private.mui.skins.rollResult[info[#info]]
			end,
			set = function(info, value)
				E.private.mui.skins.rollResult[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = F.cOption(L["Roll Result"], "orange"),
				},
				tip = {
					order = 1,
					type = "description",
					name = format(
						L["It only works when you enable the skin (%s)."],
						format("%s - %s", L["Blizzard"], L["Loot"])
					),
				},
				name = {
					order = 2,
					type = "select",
					dialogControl = "LSM30_Font",
					name = L["Font"],
					values = LSM:HashTable("font"),
				},
				style = {
					order = 3,
					type = "select",
					name = L["Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
				},
				size = {
					order = 4,
					name = L["Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
			},
		},
	},
}

options.widgets = {
	order = 3,
	type = "group",
	name = L["Widgets"],
	disabled = function()
		return not E.private.mui.skins.enable
	end,
	args = {
		desc = {
			order = 1,
			type = "description",
			name = F.String.MERATHILISUI(L["These skins will affect all widgets handled by ElvUI Skins."]),
			width = "full",
			fontSize = "medium",
		},
		header = {
			order = 2,
			type = "header",
			name = F.cOption(L["Widgets"], "orange"),
		},
		enableAll = {
			order = 3,
			type = "execute",
			name = L["Enable All"],
			func = function()
				for key in pairs(V.skins.widgets) do
					E.private.mui.skins.widgets[key].enable = true
				end
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		disableAll = {
			order = 4,
			type = "execute",
			name = L["Disable All"],
			func = function()
				for key in pairs(V.skins.widgets) do
					E.private.mui.skins.widgets[key].enable = false
				end
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		button = {
			order = 10,
			type = "group",
			name = L["Button"],
			desc = function(info)
				return F.GetWidgetTipsString(info[#info])
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					width = "full",
					get = function(info)
						return E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.widgets[info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
				},
				tip = {
					order = 2,
					type = "description",
					name = "",
					image = function()
						return I.Media.Textures.WidgetsTips, 512, 170
					end,
					imageCoords = function(info)
						return F.GetWidgetTips(info[#info - 1])
					end,
				},
				backdrop = {
					order = 3,
					type = "group",
					name = L["Additional Backdrop"],
					inline = true,
					get = function(info)
						return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 2]].enable
							or not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							width = "full",
							disabled = function(info)
								return not E.private.mui.skins.widgets[info[#info - 2]].enable
							end,
						},
						texture = {
							order = 2,
							type = "select",
							name = L["Texture"],
							dialogControl = "LSM30_Statusbar",
							values = LSM:HashTable("statusbar"),
						},
						removeBorderEffect = {
							order = 3,
							type = "toggle",
							name = L["Remove Border Effect"],
							width = 1.5,
						},
						classColor = {
							order = 4,
							type = "toggle",
							name = L["Class Color"],
						},
						color = {
							order = 5,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].classColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
					},
				},
				selected = {
					order = 4,
					type = "group",
					name = L["Selected Backdrop & Border"],
					inline = true,
					get = function(info)
						return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 2]].enable
							or not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							width = "full",
							disabled = function(info)
								return not E.private.mui.skins.widgets[info[#info - 2]].enable
							end,
						},
						backdropClassColor = {
							order = 2,
							type = "toggle",
							name = L["Backdrop Class Color"],
							width = 1.5,
						},
						backdropColor = {
							order = 3,
							type = "color",
							name = L["Backdrop Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].backdropClassColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
						backdropAlpha = {
							order = 4,
							type = "range",
							name = L["Backdrop Alpha"],
							min = 0,
							max = 1,
							step = 0.01,
						},
						borderClassColor = {
							order = 5,
							type = "toggle",
							name = L["Border Class Color"],
							width = 1.5,
						},
						borderColor = {
							order = 6,
							type = "color",
							name = L["Border Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].borderClassColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b, a)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
						borderAlpha = {
							order = 7,
							type = "range",
							name = L["Border Alpha"],
							min = 0,
							max = 1,
							step = 0.01,
						},
					},
				},
				text = {
					order = 5,
					type = "group",
					name = L["Text"],
					inline = true,
					get = function(info)
						return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 2]].enable
							or not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							width = "full",
							disabled = function(info)
								return not E.private.mui.skins.widgets[info[#info - 2]].enable
							end,
						},
						font = {
							order = 6,
							type = "group",
							inline = true,
							name = L["Font Setting"],
							disabled = function(info)
								return not E.private.mui.skins.widgets[info[#info - 3]].enable
									or not E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].enable
							end,
							get = function(info)
								return E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]]
							end,
							set = function(info, value)
								E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]] = value
								E:StaticPopup_Show("PRIVATE_RL")
							end,
							args = {
								name = {
									order = 1,
									type = "select",
									dialogControl = "LSM30_Font",
									name = L["Font"],
									values = LSM:HashTable("font"),
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
		},
		treeGroupButton = {
			order = 11,
			type = "group",
			name = L["Tree Group Button"],
			desc = function(info)
				return F.GetWidgetTipsString(info[#info])
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					width = "full",
					get = function(info)
						return E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.widgets[info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
				},
				tip = {
					order = 2,
					type = "description",
					name = "",
					image = function()
						return I.Media.Textures.WidgetsTips, 512, 170
					end,
					imageCoords = function(info)
						return F.GetWidgetTips(info[#info - 1])
					end,
				},
				backdrop = {
					order = 3,
					type = "group",
					name = L["Additional Backdrop"],
					inline = true,
					get = function(info)
						return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 2]].enable
							or not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							width = "full",
							disabled = function(info)
								return not E.private.mui.skins.widgets[info[#info - 2]].enable
							end,
						},
						texture = {
							order = 2,
							type = "select",
							name = L["Texture"],
							dialogControl = "LSM30_Statusbar",
							values = LSM:HashTable("statusbar"),
						},
						classColor = {
							order = 3,
							type = "toggle",
							name = L["Class Color"],
						},
						color = {
							order = 4,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].classColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
					},
				},
				selected = {
					order = 4,
					type = "group",
					name = L["Selected Backdrop & Border"],
					inline = true,
					get = function(info)
						return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 2]].enable
							or not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							width = "full",
							disabled = function(info)
								return not E.private.mui.skins.widgets[info[#info - 2]].enable
							end,
						},
						texture = {
							order = 2,
							type = "select",
							name = L["Texture"],
							dialogControl = "LSM30_Statusbar",
							values = LSM:HashTable("statusbar"),
						},
						backdropClassColor = {
							order = 3,
							type = "toggle",
							name = L["Backdrop Class Color"],
							width = 1.5,
						},
						backdropColor = {
							order = 4,
							type = "color",
							name = L["Backdrop Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].backdropClassColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
						backdropAlpha = {
							order = 5,
							type = "range",
							name = L["Backdrop Alpha"],
							min = 0,
							max = 1,
							step = 0.01,
						},
						borderClassColor = {
							order = 6,
							type = "toggle",
							name = L["Border Class Color"],
							width = 1.5,
						},
						borderColor = {
							order = 7,
							type = "color",
							name = L["Border Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].borderClassColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
						borderAlpha = {
							order = 8,
							type = "range",
							name = L["Border Alpha"],
							min = 0,
							max = 1,
							step = 0.01,
						},
					},
				},
				text = {
					order = 5,
					type = "group",
					name = L["Text"],
					inline = true,
					get = function(info)
						return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 2]].enable
							or not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							width = "full",
							disabled = function(info)
								return not E.private.mui.skins.widgets[info[#info - 2]].enable
							end,
						},
						normalClassColor = {
							order = 2,
							type = "toggle",
							name = L["Normal Class Color"],
							width = 1.5,
						},
						normalColor = {
							order = 3,
							type = "color",
							name = L["Normal Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].normalClassColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
						selectedClassColor = {
							order = 4,
							type = "toggle",
							name = L["Selected Class Color"],
							width = 1.5,
						},
						selectedColor = {
							order = 5,
							type = "color",
							name = L["Selected Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].selectedClassColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
						font = {
							order = 6,
							type = "group",
							inline = true,
							name = L["Font Setting"],
							disabled = function(info)
								return not E.private.mui.skins.widgets[info[#info - 3]].enable
									or not E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].enable
							end,
							get = function(info)
								return E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]]
							end,
							set = function(info, value)
								E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]] = value
								E:StaticPopup_Show("PRIVATE_RL")
							end,
							args = {
								name = {
									order = 1,
									type = "select",
									dialogControl = "LSM30_Font",
									name = L["Font"],
									values = LSM:HashTable("font"),
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
		},
		tab = {
			order = 12,
			type = "group",
			name = L["Tab"],
			desc = function(info)
				return F.GetWidgetTipsString(info[#info])
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					width = "full",
					get = function(info)
						return E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.widgets[info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
				},
				tip = {
					order = 2,
					type = "description",
					name = "",
					image = function()
						return I.Media.Textures.WidgetsTips, 512, 170
					end,
					imageCoords = function(info)
						return F.GetWidgetTips(info[#info - 1])
					end,
				},
				backdrop = {
					order = 3,
					type = "group",
					name = L["Additional Backdrop"],
					inline = true,
					get = function(info)
						return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 2]].enable
							or not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							width = "full",
							disabled = function(info)
								return not E.private.mui.skins.widgets[info[#info - 2]].enable
							end,
						},
						texture = {
							order = 2,
							type = "select",
							name = L["Texture"],
							dialogControl = "LSM30_Statusbar",
							values = LSM:HashTable("statusbar"),
						},
						classColor = {
							order = 3,
							type = "toggle",
							name = L["Class Color"],
						},
						color = {
							order = 4,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].classColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
					},
				},
				selected = {
					order = 4,
					type = "group",
					name = L["Selected Backdrop & Border"],
					inline = true,
					get = function(info)
						return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 2]].enable
							or not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							width = "full",
							disabled = function(info)
								return not E.private.mui.skins.widgets[info[#info - 2]].enable
							end,
						},
						texture = {
							order = 2,
							type = "select",
							name = L["Texture"],
							dialogControl = "LSM30_Statusbar",
							values = LSM:HashTable("statusbar"),
						},
						backdropClassColor = {
							order = 3,
							type = "toggle",
							name = L["Backdrop Class Color"],
							width = 1.5,
						},
						backdropColor = {
							order = 4,
							type = "color",
							name = L["Backdrop Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].backdropClassColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
						backdropAlpha = {
							order = 5,
							type = "range",
							name = L["Backdrop Alpha"],
							min = 0,
							max = 1,
							step = 0.01,
						},
						borderClassColor = {
							order = 6,
							type = "toggle",
							name = L["Border Class Color"],
							width = 1.5,
						},
						borderColor = {
							order = 7,
							type = "color",
							name = L["Border Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].borderClassColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b, a)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
						borderAlpha = {
							order = 8,
							type = "range",
							name = L["Border Alpha"],
							min = 0,
							max = 1,
							step = 0.01,
						},
					},
				},
				text = {
					order = 5,
					type = "group",
					name = L["Text"],
					inline = true,
					get = function(info)
						return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 2]].enable
							or not E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].enable
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							width = "full",
							disabled = function(info)
								return not E.private.mui.skins.widgets[info[#info - 2]].enable
							end,
						},
						normalClassColor = {
							order = 2,
							type = "toggle",
							name = L["Normal Class Color"],
							width = 1.5,
						},
						normalColor = {
							order = 3,
							type = "color",
							name = L["Normal Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].normalClassColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
						selectedClassColor = {
							order = 4,
							type = "toggle",
							name = L["Selected Class Color"],
							width = 1.5,
						},
						selectedColor = {
							order = 5,
							type = "color",
							name = L["Selected Color"],
							hasAlpha = false,
							hidden = function(info)
								return E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]].selectedClassColor
							end,
							get = function(info)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
							end,
						},
						font = {
							order = 6,
							type = "group",
							inline = true,
							name = L["Font Setting"],
							disabled = function(info)
								return not E.private.mui.skins.widgets[info[#info - 3]].enable
									or not E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].enable
							end,
							get = function(info)
								return E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]]
							end,
							set = function(info, value)
								E.private.mui.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]] = value
								E:StaticPopup_Show("PRIVATE_RL")
							end,
							args = {
								name = {
									order = 1,
									type = "select",
									dialogControl = "LSM30_Font",
									name = L["Font"],
									values = LSM:HashTable("font"),
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
		},
		checkBox = {
			order = 13,
			type = "group",
			name = L["Check Box"],
			desc = function(info)
				return F.GetWidgetTipsString(info[#info])
			end,
			get = function(info)
				return E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.private.mui.skins.widgets[info[#info - 1]][info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					width = "full",
				},
				desc = {
					order = 2,
					type = "description",
					name = "|cffff0000"
						.. L["To enable this feature, you need to enable the check box skin in ElvUI Skins first."]
						.. "|r",
					hidden = function(info)
						return E.private.skins.checkBoxSkin
					end,
				},
				tip = {
					order = 3,
					type = "description",
					name = "",
					image = function()
						return I.Media.Textures.WidgetsTips, 512, 170
					end,
					imageCoords = function(info)
						return F.GetWidgetTips(info[#info - 1])
					end,
				},
				texture = {
					order = 4,
					type = "select",
					name = L["Texture"],
					dialogControl = "LSM30_Statusbar",
					values = LSM:HashTable("statusbar"),
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 1]].enable
					end,
				},
				classColor = {
					order = 5,
					type = "toggle",
					name = L["Class Color"],
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 1]].enable
					end,
				},
				color = {
					order = 6,
					type = "color",
					name = L["Color"],
					hasAlpha = true,
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 1]].enable
					end,
					hidden = function(info)
						return E.private.mui.skins.widgets[info[#info - 1]].classColor
					end,
					get = function(info)
						local db = E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
						local default = V.skins.widgets[info[#info - 1]][info[#info]]
						return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						local db = E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
						db.r, db.g, db.b, db.a = r, g, b, a
					end,
				},
			},
		},
		slider = {
			order = 14,
			type = "group",
			name = L["Slider"],
			desc = function(info)
				return F.GetWidgetTipsString(info[#info])
			end,
			get = function(info)
				return E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.private.mui.skins.widgets[info[#info - 1]][info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					width = "full",
				},
				tip = {
					order = 2,
					type = "description",
					name = "",
					image = function()
						return I.Media.Textures.WidgetsTips, 512, 170
					end,
					imageCoords = function(info)
						return F.GetWidgetTips(info[#info - 1])
					end,
				},
				texture = {
					order = 3,
					type = "select",
					name = L["Texture"],
					dialogControl = "LSM30_Statusbar",
					values = LSM:HashTable("statusbar"),
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 1]].enable
					end,
				},
				classColor = {
					order = 4,
					type = "toggle",
					name = L["Class Color"],
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 1]].enable
					end,
				},
				color = {
					order = 5,
					type = "color",
					name = L["Color"],
					hasAlpha = true,
					disabled = function(info)
						return not E.private.mui.skins.widgets[info[#info - 1]].enable
					end,
					hidden = function(info)
						return E.private.mui.skins.widgets[info[#info - 1]].classColor
					end,
					get = function(info)
						local db = E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
						local default = V.skins.widgets[info[#info - 1]][info[#info]]
						return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						local db = E.private.mui.skins.widgets[info[#info - 1]][info[#info]]
						db.r, db.g, db.b, db.a = r, g, b, a
					end,
				},
			},
		},
	},
}

for _, widget in pairs({ "button", "treeGroupButton", "tab" }) do
	options.widgets.args[widget].args.backdrop.args.animation = {
		order = 10,
		type = "group",
		name = L["Animation Effect"],
		disabled = function()
			return not E.private.mui.skins.enable
				or not E.private.mui.skins.widgets[widget].enable
				or not E.private.mui.skins.widgets[widget].backdrop.enable
		end,
		get = function(info)
			return E.private.mui.skins.widgets[widget].backdrop.animation[info[#info]]
		end,
		set = function(info, value)
			E.private.mui.skins.widgets[widget].backdrop.animation[info[#info]] = value
		end,
		args = {
			type = {
				order = 1,
				type = "select",
				name = L["Type"],
				desc = L["The type of animation activated when a button is hovered."],
				values = {
					fade = L["Fade"],
				},
			},
			duration = {
				order = 2,
				type = "range",
				name = L["Duration"],
				desc = L["The duration of the animation in seconds."],
				min = 0,
				max = 3,
				step = 0.01,
			},
			alpha = {
				order = 3,
				type = "range",
				name = L["Alpha"],
				desc = L["The maximum alpha of the animation."],
				min = 0,
				max = 1,
				step = 0.01,
			},
			fadeEase = {
				order = 4,
				type = "select",
				name = L["Ease"],
				width = 1.3,
				desc = L["The easing function used for fading the backdrop."]
					.. "\n"
					.. L["You can preview the ease type in https://easings.net/"],
				values = MER.AnimationEaseTable,
			},
			fadeEaseInvert = {
				order = 5,
				type = "toggle",
				name = L["Invert Ease"],
				desc = L["When enabled, this option inverts the easing function."]
					.. " "
					.. L["(e.g., 'in-quadratic' becomes 'out-quadratic' and vice versa)"]
					.. "\n"
					.. L["Generally, enabling this option makes the value increase faster in the first half of the animation."],
			},
		},
	}
end

options.blizzard = {
	order = 4,
	type = "group",
	name = L["Blizzard"],
	get = function(info)
		return E.private.mui.skins.blizzard[info[#info]]
	end,
	set = function(info, value)
		E.private.mui.skins.blizzard[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	disabled = function()
		return not E.private.mui.skins.enable
	end,
	args = {
		info = {
			order = 1,
			type = "description",
			name = F.String.MERATHILISUI(L["MER_SKINS_DESC"]),
			fontSize = "medium",
			width = "full",
		},
		space = {
			order = 2,
			type = "description",
			name = "",
		},
		enable = {
			order = 3,
			type = "toggle",
			name = L["Enable"],
		},
		header = {
			order = 4,
			type = "header",
			name = F.cOption(L["Blizzard"], "orange"),
		},
		gotoskins = {
			order = 5,
			type = "execute",
			name = L["ElvUI Skins"],
			func = function()
				LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "skins")
			end,
		},
		enableAll = {
			order = 6,
			type = "execute",
			name = L["Enable All"],
			func = function()
				for key in pairs(V.skins.blizzard) do
					E.private.mui.skins.blizzard[key] = true
				end
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		disableAll = {
			order = 7,
			type = "execute",
			name = L["Disable All"],
			func = function()
				for key in pairs(V.skins.blizzard) do
					if key ~= "enable" then
						E.private.mui.skins.blizzard[key] = false
					end
				end
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		space2 = {
			order = 8,
			type = "description",
			name = "",
		},
		professionBook = {
			type = "toggle",
			name = L["Professions Book"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.professionBook
			end,
		},
		character = {
			type = "toggle",
			name = L["Character Frame"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character
			end,
		},
		gossip = {
			type = "toggle",
			name = L["Gossip Frame"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gossip
			end,
		},
		quest = {
			type = "toggle",
			name = L["Quest Frames"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.quest
			end,
		},
		talent = {
			type = "toggle",
			name = L["TALENTS"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.talent
			end,
		},
		auctionhouse = {
			type = "toggle",
			name = L["AUCTIONS"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.auctionhouse
			end,
		},
		friends = {
			type = "toggle",
			name = L["FRIENDS"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.friends
			end,
		},
		tradeskill = {
			type = "toggle",
			name = L["TRADESKILLS"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.tradeskill
			end,
		},
		lfg = {
			type = "toggle",
			name = L["LFG_TITLE"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfg
			end,
		},
		guild = {
			type = "toggle",
			name = L["GUILD"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.guild
			end,
		},
		addonManager = {
			type = "toggle",
			name = L["AddOn Manager"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.addonManager
			end,
		},
		mail = {
			type = "toggle",
			name = L["Mail Frame"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.mail
			end,
		},
		timemanager = {
			type = "toggle",
			name = L["TIMEMANAGER_TITLE"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.timemanager
			end,
		},
		worldmap = {
			type = "toggle",
			name = L["WORLD_MAP"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.worldmap
			end,
		},
		guildcontrol = {
			type = "toggle",
			name = L["Guild Control Frame"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.guildcontrol
			end,
		},
		macro = {
			type = "toggle",
			name = L["MACROS"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.macro
			end,
		},
		binding = {
			type = "toggle",
			name = L["KEY_BINDINGS"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.binding
			end,
		},
		gbank = {
			type = "toggle",
			name = L["GUILD_BANK"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gbank
			end,
		},
		taxi = {
			type = "toggle",
			name = L["FLIGHT_MAP"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.taxi
			end,
		},
		help = {
			type = "toggle",
			name = L["Help Frame"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.help
			end,
		},
		loot = {
			type = "toggle",
			name = L["Loot Frames"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.loot
			end,
		},
		channels = {
			type = "toggle",
			name = L["CHANNELS"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.channels
			end,
		},
		communities = {
			type = "toggle",
			name = L["COMMUNITIES"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.communities
			end,
		},
		raid = {
			type = "toggle",
			name = L["Raid Frame"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.raid
			end,
		},
		craft = {
			type = "toggle",
			name = L["Craft"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.craft
			end,
		},
		eventToast = {
			type = "toggle",
			name = L["Event Toast Manager"],
			disabled = function()
				return not E.private.skins.blizzard.enable
			end,
		},
		achievement = {
			type = "toggle",
			name = _G.ACHIEVEMENTS,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.achievement
			end,
		},
		encounterjournal = {
			type = "toggle",
			name = ENCOUNTER_JOURNAL,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.encounterjournal
			end,
		},
		questChoice = {
			type = "toggle",
			name = L["Quest Choice"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.questChoice
			end,
		},
		garrison = {
			type = "toggle",
			name = _G.GARRISON_LOCATION_TOOLTIP,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.garrison
			end,
		},
		orderhall = {
			type = "toggle",
			name = L["Orderhall"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.orderhall
			end,
		},
		contribution = {
			type = "toggle",
			name = L["Contribution"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.contribution
			end,
		},
		artifact = {
			type = "toggle",
			name = _G.ITEM_QUALITY6_DESC,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.artifact
			end,
		},
		collections = {
			type = "toggle",
			name = _G.COLLECTIONS,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.collections
			end,
		},
		calendar = {
			type = "toggle",
			name = L["Calendar Frame"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.calendar
			end,
		},
		merchant = {
			type = "toggle",
			name = L["Merchant Frame"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.merchant
			end,
		},
		pvp = {
			type = "toggle",
			name = L["PvP Frames"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.pvp
			end,
		},
		lfguild = {
			type = "toggle",
			name = L["LF Guild Frame"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfguild
			end,
		},
		talkinghead = {
			type = "toggle",
			name = L["TalkingHead"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.talkinghead
			end,
		},
		objectiveTracker = {
			type = "toggle",
			name = _G.OBJECTIVES_TRACKER_LABEL,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker
			end,
		},
		dressingroom = {
			type = "toggle",
			name = _G.DRESSUP_FRAME,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.dressingroom
			end,
		},
		blackmarket = {
			type = "toggle",
			name = _G.BLACK_MARKET_AUCTION_HOUSE,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.bmah
			end,
		},
		deathRecap = {
			type = "toggle",
			name = _G.DEATH_RECAP_TITLE,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.deathRecap
			end,
		},
		challenges = {
			type = "toggle",
			name = _G.CHALLENGES,
			disabled = function()
				return not E.private.skins.blizzard.enable
			end,
		},
		azerite = {
			type = "toggle",
			name = L["AzeriteUI"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.azerite
			end,
		},
		AzeriteRespec = {
			type = "toggle",
			name = _G.AZERITE_RESPEC_TITLE,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.azeriteRespec
			end,
		},
		IslandQueue = {
			type = "toggle",
			name = _G.ISLANDS_HEADER,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.islandQueue
			end,
		},
		IslandsPartyPose = {
			type = "toggle",
			name = L["Island Party Pose"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.islandsPartyPose
			end,
		},
		minimap = {
			type = "toggle",
			name = L["Minimap"],
			disabled = function()
				return not E.private.skins.blizzard.enable
			end,
		},
		Scrapping = {
			type = "toggle",
			name = _G.SCRAP_BUTTON,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.scrapping
			end,
		},
		trainer = {
			type = "toggle",
			name = L["Trainer Frame"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.trainer
			end,
		},
		debug = {
			type = "toggle",
			name = L["Debug Tools"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.debug
			end,
		},
		inspect = {
			type = "toggle",
			name = _G.INSPECT,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.inspect
			end,
		},
		socket = {
			type = "toggle",
			name = L["Socket Frame"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.socket
			end,
		},
		itemUpgrade = {
			type = "toggle",
			name = L["Item Upgrade"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.itemUpgrade
			end,
		},
		trade = {
			type = "toggle",
			name = L["Trade"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.trade
			end,
		},
		voidstorage = {
			type = "toggle",
			name = _G.VOID_STORAGE,
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.voidstorage
			end,
		},
		AlliedRaces = {
			type = "toggle",
			name = L["Allied Races"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.alliedRaces
			end,
		},
		GMChat = {
			type = "toggle",
			name = L["GM Chat"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gmChat
			end,
		},
		Archaeology = {
			type = "toggle",
			name = L["Archaeology Frame"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.archaeology
			end,
		},
		AzeriteEssence = {
			type = "toggle",
			name = L["Azerite Essence"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.azeriteEssence
			end,
		},
		itemInteraction = {
			type = "toggle",
			name = L["Item Interaction"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.itemInteraction
			end,
		},
		animaDiversion = {
			type = "toggle",
			name = L["Anima Diversion"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.animaDiversion
			end,
		},
		soulbinds = {
			type = "toggle",
			name = L["Soulbinds"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.soulbinds
			end,
		},
		covenantSanctum = {
			type = "toggle",
			name = L["Covenant Sanctum"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.covenantSanctum
			end,
		},
		covenantPreview = {
			type = "toggle",
			name = L["Covenant Preview"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.covenantPreview
			end,
		},
		covenantRenown = {
			type = "toggle",
			name = L["Covenant Renown"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.covenantRenown
			end,
		},
		playerChoice = {
			type = "toggle",
			name = L["Player Choice"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.playerChoice
			end,
		},
		chromieTime = {
			type = "toggle",
			name = L["Chromie Time"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.chromieTime
			end,
		},
		levelUp = {
			type = "toggle",
			name = L["LevelUp Display"],
			disabled = function()
				return not E.private.skins.blizzard.enable
			end,
		},
		guide = {
			type = "toggle",
			name = L["Guide Frame"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.guide
			end,
		},
		weeklyRewards = {
			type = "toggle",
			name = L["Weekly Rewards"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.weeklyRewards
			end,
		},
		misc = {
			type = "toggle",
			name = L["Misc"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.misc
			end,
		},
		tooltip = {
			type = "toggle",
			name = L["Tooltip"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.tooltip
			end,
		},
		chatBubbles = {
			type = "toggle",
			name = L["Chat Bubbles"],
			disabled = function()
				return not E.private.skins.blizzard.enable or E.private.general.chatBubbles ~= "nobackdrop"
			end,
		},
		expansionLanding = {
			type = "toggle",
			name = L["Expansion LandingPage"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.expansionLanding
			end,
		},
		majorFactions = {
			type = "toggle",
			name = L["Major Factions"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.majorFactions
			end,
		},
		blizzardOptions = {
			type = "toggle",
			name = L["Settings Panel"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.blizzardOptions
			end,
		},
		editor = {
			type = "toggle",
			name = L["Editor Mode"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.editor
			end,
		},
		perksProgram = {
			type = "toggle",
			name = L["Perks Program"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.perks
			end,
		},
		uiWidgets = {
			type = "toggle",
			name = L["UI Widgets"],
			disabled = function()
				return not E.private.skins.blizzard.enable
			end,
		},
		delves = {
			type = "toggle",
			name = L["Delves"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfg
			end,
		},
		lossOfControl = {
			type = "toggle",
			name = L["LOSS_OF_CONTROL"],
			disabled = function()
				return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.losscontrol
			end,
		},
	},
}

options.addonskins = {
	order = 5,
	type = "group",
	name = L["AddOnSkins"],
	get = function(info)
		return E.private.mui.skins.addonSkins[info[#info]]
	end,
	set = function(info, value)
		E.private.mui.skins.addonSkins[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	disabled = function()
		return not E.private.mui.skins.enable
	end,
	args = {
		info = {
			order = 1,
			type = "description",
			name = F.String.MERATHILISUI(L["MER_ADDONSKINS_DESC"]),
			fontSize = "medium",
		},
		space = {
			order = 2,
			type = "description",
			name = "",
		},
		enable = {
			order = 3,
			type = "toggle",
			name = L["Enable"],
		},
		header = {
			order = 4,
			type = "header",
			name = F.cOption(L["AddOnSkins"], "orange"),
		},
	},
}

local addorder = 6
for _, v in ipairs(DecorAddons) do
	local addonName, addonString, addonOption, Notes = unpack(v)
	options.addonskins.args[addonOption] = {
		order = addorder + 1,
		type = "toggle",
		name = addonString,
		desc = format("%s " .. addonString .. " %s", L["Enable/Disable"], L["decor."]),
		disabled = function()
			return not IsAddOnLoaded(addonName)
		end,
	}
end

options.addonskins.args.ace3 = {
	order = 7,
	type = "toggle",
	name = L["Ace3"],
	get = function(info)
		return E.private.mui.skins.addonSkins[info[#info]]
	end,
	set = function(info, value)
		E.private.mui.skins.addonSkins[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
}

options.Embed = {
	order = 8,
	type = "group",
	name = L["Embed Settings"],
	get = function(info)
		return E.private.mui.skins.embed[info[#info]]
	end,
	set = function(info, value)
		E.private.mui.skins.embed[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		info = {
			order = 1,
			type = "description",
			name = F.String.MERATHILISUI(L["With this option you can embed your Details into an own Panel."]),
			fontSize = "medium",
		},
		header = {
			order = 2,
			type = "header",
			name = F.cOption(L["Embed Settings"], "orange"),
		},
		spacer1 = {
			order = 3,
			type = "description",
			name = " ",
		},
		enable = {
			order = 4,
			type = "toggle",
			name = L["Enable"],
		},
		details = {
			order = 5,
			type = "execute",
			name = L["Reset Settings"],
			func = function()
				ResetDetails()
			end,
			disabled = function()
				return not E.private.mui.skins.embed.enable
			end,
		},
		toggleDirection = {
			order = 5,
			type = "select",
			name = L["Toggle Direction"],
			set = function(_, value)
				E.private.mui.skins.embed.toggleDirection = value
				UpdateToggleDirection()
			end,
			values = {
				[1] = L["LEFT"],
				[2] = L["RIGHT"],
				[3] = L["TOP"],
				[4] = L["BOTTOM"],
				[5] = _G.DISABLE,
			},
		},
		mouseOver = {
			order = 6,
			type = "toggle",
			name = L["Mouse Over"],
		},
	},
}

options.advancedSettings = {
	order = 9,
	type = "group",
	name = L["Advanced Skin Settings"],
	disabled = function()
		return not E.private.mui.skins.enable
	end,
	args = {
		bigWigsSkin = {
			order = 1,
			type = "group",
			name = L["BigWigs Skin"],
			get = function(info)
				return E.private.mui.skins.addonSkins.bw[info[#info]]
			end,
			set = function(info, value)
				E.private.mui.skins.addonSkins.bw[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			disabled = function()
				return not IsAddOnLoaded("BigWigs")
			end,
			args = {
				enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
				},
				alert = {
					order = 1,
					type = "description",
					name = function()
						if not IsAddOnLoaded("BigWigs") then
							return C.StringByTemplate(format(L["%s is not loaded."], L["BigWigs"]), "danger")
						end

						return C.StringByTemplate(
							format(
								"%s\n%s\n\n",
								format(L["The options below are only for BigWigs %s bar style."], MER.Title),
								format(L["You need to manually set the bar style to %s in BigWigs first."], MER.Title)
							),
							"warning"
						) .. L["How to change BigWigs bar style:"] .. "\n" .. L["Open BigWigs Options UI with /bw > Bars > Style."] .. "\n\n"
					end,
					fontSize = "medium",
				},
				bigWigsQueueTimer = {
					order = 2,
					get = function(info)
						return E.private.mui.skins.addonSkins.bw.queueTimer
					end,
					set = function(info, value)
						E.private.mui.skins.addonSkins.bw.queueTimer = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					type = "toggle",
					name = L["BigWigs Queue Timer"],
					disabled = false,
					width = 1,
				},
				bigWigs = {
					order = 3,
					get = function(info)
						return E.private.mui.skins.addonSkins.bw
					end,
					set = function(info, value)
						E.private.mui.skins.addonSkins.bw = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					type = "toggle",
					name = L["BigWigs Bars"],
					disabled = false,
					width = 1,
				},
				normalBar = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Normal Bar"],
					get = function(info)
						return E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]] = value
					end,
					disabled = function()
						return not E.private.mui.skins.addonSkins.bw
					end,
					args = {
						smooth = {
							order = 1,
							type = "toggle",
							name = L["Smooth"],
							desc = L["Smooth the bar animation with ElvUI."],
						},
						spark = {
							order = 2,
							type = "toggle",
							name = L["Spark"],
							desc = L["Show spark on the bar."],
						},
						colorOverride = {
							order = 3,
							type = "toggle",
							name = L["Color Override"],
							desc = L["Override the bar color."],
						},
						colorLeft = {
							order = 4,
							type = "color",
							name = L["Left Color"],
							desc = L["Gradient color of the left part of the bar."],
							hasAlpha = false,
							disabled = function(info)
								return not E.private.mui.skins.addonSkins.bw
									or not E.private.mui.skins.addonSkins.bw[info[#info - 1]].colorOverride
							end,
							get = function(info)
								local db = E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								local default = V.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								db.r, db.g, db.b, db.a = r, g, b, 1
							end,
						},
						colorRight = {
							order = 5,
							type = "color",
							name = L["Right Color"],
							desc = L["Gradient color of the right part of the bar."],
							hasAlpha = false,
							disabled = function(info)
								return not E.private.mui.skins.addonSkins.bw
									or not E.private.mui.skins.addonSkins.bw[info[#info - 1]].colorOverride
							end,
							get = function(info)
								local db = E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								local default = V.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								db.r, db.g, db.b, db.a = r, g, b, 1
							end,
						},
					},
				},
				emphasizedBar = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Emphasized Bar"],
					get = function(info)
						return E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]] = value
					end,
					disabled = function()
						return not E.private.mui.skins.addonSkins.bw
					end,
					args = {
						smooth = {
							order = 1,
							type = "toggle",
							name = L["Smooth"],
							desc = L["Smooth the bar animation with ElvUI."],
						},
						spark = {
							order = 2,
							type = "toggle",
							name = L["Spark"],
							desc = L["Show spark on the bar."],
						},
						colorOverride = {
							order = 3,
							type = "toggle",
							name = L["Color Override"],
							desc = L["Override the bar color."],
						},
						colorLeft = {
							order = 4,
							type = "color",
							name = L["Left Color"],
							desc = L["Gradient color of the left part of the bar."],
							hasAlpha = false,
							disabled = function(info)
								return not E.private.mui.skins.addonSkins.bw
									or not E.private.mui.skins.addonSkins.bw[info[#info - 1]].colorOverride
							end,
							get = function(info)
								local db = E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								local default = V.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								db.r, db.g, db.b, db.a = r, g, b, 1
							end,
						},
						colorRight = {
							order = 5,
							type = "color",
							name = L["Right Color"],
							desc = L["Gradient color of the right part of the bar."],
							hasAlpha = false,
							disabled = function(info)
								return not E.private.mui.skins.addonSkins.bw
									or not E.private.mui.skins.addonSkins.bw[info[#info - 1]].colorOverride
							end,
							get = function(info)
								local db = E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								local default = V.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								db.r, db.g, db.b, db.a = r, g, b, 1
							end,
						},
					},
				},
				queueTimer = {
					order = 6,
					type = "group",
					inline = true,
					name = L["Queue Timer"],
					get = function(info)
						return E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					disabled = function()
						return not E.private.mui.skins.addonSkins.bw
					end,
					args = {
						smooth = {
							order = 1,
							type = "toggle",
							name = L["Smooth"],
							desc = L["Smooth the bar animation with ElvUI."],
						},
						spark = {
							order = 2,
							type = "toggle",
							name = L["Spark"],
							desc = L["Show spark on the bar."],
						},
						colorLeft = {
							order = 3,
							type = "color",
							name = L["Left Color"],
							desc = L["Gradient color of the left part of the bar."],
							hasAlpha = false,
							get = function(info)
								local db = E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								local default = V.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								db.r, db.g, db.b, db.a = r, g, b, 1
							end,
						},
						colorRight = {
							order = 4,
							type = "color",
							name = L["Right Color"],
							desc = L["Gradient color of the right part of the bar."],
							hasAlpha = false,
							get = function(info)
								local db = E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								local default = V.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
							end,
							set = function(info, r, g, b)
								local db = E.private.mui.skins.addonSkins.bw[info[#info - 1]][info[#info]]
								db.r, db.g, db.b, db.a = r, g, b, 1
							end,
						},
						countDown = {
							order = 5,
							type = "group",
							inline = true,
							name = L["Count Down"],
							get = function(info)
								return E.private.mui.skins.addonSkins.bw[info[#info - 2]][info[#info - 1]][info[#info]]
							end,
							set = function(info, value)
								E.private.mui.skins.addonSkins.bw[info[#info - 2]][info[#info - 1]][info[#info]] = value
								E:StaticPopup_Show("PRIVATE_RL")
							end,
							args = {
								name = {
									order = 1,
									type = "select",
									dialogControl = "LSM30_Font",
									name = L["Font"],
									values = LSM:HashTable("font"),
								},
								style = {
									order = 2,
									type = "select",
									name = L["Outline"],
									values = MER.Values.FontFlags,
									sortByValue = true,
								},
								size = {
									order = 3,
									name = L["Size"],
									type = "range",
									min = 5,
									max = 60,
									step = 1,
								},
								offsetX = {
									order = 4,
									name = L["X-Offset"],
									type = "range",
									min = -100,
									max = 100,
									step = 1,
								},
								offsetY = {
									order = 5,
									name = L["Y-Offset"],
									type = "range",
									min = -100,
									max = 100,
									step = 1,
								},
							},
						},
					},
				},
			},
		},
		dtSkin = {
			order = 2,
			type = "group",
			name = L["Details Skin"],
			get = function(info)
				return E.private.mui.skins.addonSkins.dt[info[#info]]
			end,
			set = function(info, value)
				E.private.mui.skins.addonSkins.dt[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			disabled = function()
				return not IsAddOnLoaded("Details")
			end,
			args = {
				enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					width = "full",
				},
				description = {
					order = 1,
					type = "description",
					name = function()
						if not IsAddOnLoaded("Details") then
							return C.StringByTemplate(format(L["%s is not loaded."], L["Details"]), "danger")
						end

						return format(
							"|cfffff400%s",
							L["The options below is only for the Details look, NOT the Embeded."]
						)
					end,
					fontSize = "medium",
				},
				spacer = {
					order = 2,
					type = "description",
					name = " ",
				},
				gradientBars = {
					order = 3,
					type = "toggle",
					name = L["Gradient Bars"],
					disabled = function()
						return not E.private.mui.skins.addonSkins.dt.enable
					end,
				},
				gradientName = {
					order = 4,
					type = "toggle",
					name = L["Gradient Name"],
					disabled = function()
						return not E.private.mui.skins.addonSkins.dt.enable
					end,
				},
				spacer1 = {
					order = 5,
					type = "description",
					name = " ",
				},
				detailsIcons = {
					order = 6,
					type = "execute",
					name = F.cOption(L["Open Details"], "gradient"),
					disabled = function()
						return not E:IsAddOnEnabled("Details")
					end,
					func = function()
						local instance = Details:GetInstance(1)
						Details:OpenOptionsWindow(instance)
					end,
				},
			},
		},
	},
}
