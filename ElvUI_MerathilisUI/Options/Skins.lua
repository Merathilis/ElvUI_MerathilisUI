local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local options = MER.options.skins.args
local C = W.Utilities.Color
local LSM = E.Libs.LSM

local _G = _G
local ipairs, unpack = ipairs, unpack
local format = string.format

local DoesAddOnExist = C_AddOns.DoesAddOnExist
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

local DecorAddons = {
	{ "ACP", L["AddOn Control Panel"], "acp" },
	{ "BagSync", L["BagSync"], "bSync" },
	{ "Capping", L["Capping"], "cap" },
	{ "Clique", L["Clique"], "cl" },
	{ "GlobalIgnoreList", L["GlobalIgnoreList"], "gil" },
	{ "HomeBound", L["Home Bound"], "homeBound" },
	{ "KeystoneLoot", L["KeystoneLoot"], "klf" },
	{ "MountRoutePlanner", L["Mount Route Planner"], "mrp" },
	{ "Pawn", L["Pawn"], "pawn" },
	{ "tdBattlePetScript", L["Pet Battle Scripts"], "pbs" },
	{ "ParagonReputation", L["Paragon Reputation"], "paragonReputation" },
	{ "ProjectAzilroka", L["ProjectAzilroka"], "pa" },
	{ "SimpleAddonManager", L["Simple Addon Manager"], "sam" },
	{ "ls_Toasts", L["ls_Toasts"], "ls" },
	{ "WIM", L["WIM"], "wim" },
	{ "WowLua", L["WowLua"], "wowLua" },
}

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
	},
}

options.addonskins = {
	order = 6,
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

local addorder = 8
for _, v in ipairs(DecorAddons) do
	local addonName, addonString, addonOption = unpack(v)
	local iconTexture = GetAddOnMetadata(addonName, "IconTexture")
	local iconAtlas = GetAddOnMetadata(addonName, "IconAtlas")

	if not iconTexture and not iconAtlas then
		iconTexture = [[Interface\ICONS\INV_Misc_QuestionMark]]
	end

	if iconTexture then
		addonString = CreateSimpleTextureMarkup(iconTexture, 14, 14) .. " " .. addonString
	elseif iconAtlas then
		addonString = CreateAtlasMarkup(iconAtlas, 14, 14) .. " " .. addonString
	end

	options.addonskins.args[addonOption] = {
		order = addorder + 1,
		type = "toggle",
		name = addonString,
		icon = addonIcon,
		desc = format("%s " .. addonString .. " %s", L["Enable/Disable"], L["decor."]),
		disabled = function()
			return not DoesAddOnExist(addonName)
		end,
	}
end

options.Embed = {
	order = 9,
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
	order = 10,
	type = "group",
	name = L["Advanced Skin Settings"],
	disabled = function()
		return not E.private.mui.skins.enable
	end,
	args = {
		bigWigsSkin = {
			order = 2,
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
				return not DoesAddOnExist("BigWigs")
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
						if not DoesAddOnExist("BigWigs") then
							return C.StringByTemplate(format(L["%s is not loaded."], L["BigWigs"]), "rose-500")
						end

						return C.StringByTemplate(
							format(
								"%s\n%s\n\n",
								format(L["The options below are only for BigWigs %s bar style."], MER.Title),
								format(L["You need to manually set the bar style to %s in BigWigs first."], MER.Title)
							),
							"yellow-400"
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
			order = 3,
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
				return not DoesAddOnExist("Details")
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
						if not DoesAddOnExist("Details") then
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
