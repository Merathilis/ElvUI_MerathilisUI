local MER, E, L, V, P, G = unpack(select(2, ...))
local CF = E:GetModule("CooldownFlash")
local OCD = E:GetModule("OzCooldowns")

local function CooldownFlash()
	E.Options.args.mui.args.cooldownFlash = {
		type = "group",
		name = CF.modName,
		order = 20,
		get = function(info) return E.global.mui.cooldownFlash[ info[#info] ] end,
		set = function(info, value) E.global.mui.cooldownFlash[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			header1 = {
				type = "header",
				name = MER:cOption(CF.modName),
				order = 1
			},
			credits = {
				order = 2,
				type = "group",
				name = MER:cOption(L["Credits"]),
				guiInline = true,
				args = {
					tukui = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = "Doom_CooldownPulse - by Woffle of Dark Iron[US]",
					},
				},
			},
			toggle = {
				order = 3,
				type = "toggle",
				name = L["Enable"],
				desc = CF.modName,
				get = function() return E.global.mui.cooldownFlash.enable ~= false or false end,
				set = function(info, v) CF.db.enable = v if v then CF:EnableCooldownFlash() else CF:DisableCooldownFlash() end end,
			},
			iconSize = {
				order = 4,
				name = L["Icon Size"],
				type = "range",
				min = 30, max = 125, step = 1,
				set = function(info, value) E.global.mui.cooldownFlash[ info[#info] ] = value; CF.DCP:SetSize(value, value) end,
				hidden = function() return not E.global.mui.cooldownFlash.enable end,
			},
			fadeInTime = {
				order = 5,
				name = L["Fadein duration"],
				type = "range",
				min = 0.5, max = 2.5, step = 0.1,
				hidden = function() return not E.global.mui.cooldownFlash.enable end,
			},
			fadeOutTime = {
				order = 6,
				name = L["Fadeout duration"],
				type = "range",
				min = 0.5, max = 2.5, step = 0.1,
				hidden = function() return not E.global.mui.cooldownFlash.enable end,
			},
			maxAlpha = {
				order = 7,
				name = L["Transparency"],
				type = "range",
				min = 0.25, max = 1, step = 0.05,
				isPercent = true,
				hidden = function() return not E.global.mui.cooldownFlash.enable end,
			},
			holdTime = {
				order = 8,
				name = L["Duration time"],
				type = "range",
				min = 0.3, max = 2.5, step = 0.1,
				hidden = function() return not E.global.mui.cooldownFlash.enable end,
			},
			animScale = {
				order = 9,
				name = L["Animation size"],
				type = "range",
				min = 0.5, max = 2, step = 0.1,
				hidden = function() return not E.global.mui.cooldownFlash.enable end,
			},
			showSpellName = {
				order = 10,
				name = L["Display spell name"],
				type = "toggle",
				hidden = function() return not E.global.mui.cooldownFlash.enable end,
			},
			enablePet = {
				order = 11,
				name = L["Watch on pet spell"],
				type = "toggle",
				get = function(info) return E.global.mui.cooldownFlash[ info[#info] ] end,
				set = function(info, value) E.global.mui.cooldownFlash[ info[#info] ] = value; if value then CF.DCP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") else CF.DCP:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end end,
				hidden = function() return not E.global.mui.cooldownFlash.enable end,
			},
			test = {
				order = 12,
				name = L["Test"],
				type = "execute",
				func = function() CF:TestMode() end,
				hidden = function() return not E.global.mui.cooldownFlash.enable end,
			},
		},
	}
end
tinsert(MER.Config, CooldownFlash)

local function OzCooldowns()
	E.Options.args.mui.args.ozcooldowns = {
		type = "group",
		name = OCD.modName,
		order = 21,
		get = function(info) return E.db.mui.misc.ozcooldowns[info[#info]] end,
		set = function(info, value) E.db.mui.misc.ozcooldowns[info[#info]] = value; OCD:BuildCooldowns() end,
		args = {
			enable = {
				order = 1,
				name = L["Enable"],
				type = "toggle",
				get = function(info) return E.db.mui.misc.ozcooldowns[ info[#info] ] end,
				set = function(info, value) E.db.mui.misc.ozcooldowns[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			},
			spells = {
				order = 2,
				type = "group",
				name = L["Spells"],
				guiInline = true,
				hidden = function() return not E.db.mui.misc.ozcooldowns.enable end,
				args = OCD:GenerateSpellOptions(),
				get = function(info) return E.private.muiMisc.ozcooldowns.spellCDs[info[#info]] end,
				set = function(info, value)
					E.private.muiMisc.ozcooldowns.spellCDs[info[#info]] = value;
					OCD:BuildCooldowns()
				end,
			},
			duration = {
				order = 3,
				type = "group",
				name = L["Duration"],
				guiInline = true,
				hidden = function() return not E.db.mui.misc.ozcooldowns.enable end,
				args = {
					DurationFont = {
						type = "select", dialogControl = 'LSM30_Font',
						order = 1,
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
						disabled = function() return not E.db.mui.misc.ozcooldowns["StatusBar"] end,
					},
					DurationFontSize = {
						order = 2,
						name = L["Font Size"],
						type = "range",
						min = 8, max = 22, step = 1,
						disabled = function() return not E.db.mui.misc.ozcooldowns["StatusBar"] end,
					},
					DurationFontFlag = {
						name = L["Font Outline"],
						order = 3,
						type = "select",
						values = {
							["NONE"] = 'None',
							["OUTLINE"] = 'OUTLINE',
							["MONOCHROME"] = 'MONOCHROME',
							["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
							["THICKOUTLINE"] = 'THICKOUTLINE',
						},
						disabled = function() return not E.db.mui.misc.ozcooldowns["StatusBar"] end,
					},
					DurationText = {
						order = 4,
						type = "toggle",
						name = L["Duration Text"],
						disabled = function() return E.db.mui.misc.ozcooldowns["Mode"] == "DIM" end,
					},
					SortByDuration = {
						order = 5,
						type = "toggle",
						name = L["Sort by Current Duration"],
						disabled = function() return E.db.mui.misc.ozcooldowns["Mode"] == "DIM" end,
					},
					MinimumDuration = {
						order = 6,
						type = "range",
						name = L["Minimum Duration Visibility"],
						min = 2, max = 600, step = 1,
					},
				},
			},
			icons = {
				order = 4,
				type = "group",
				name = L["Icons"],
				guiInline = true,
				hidden = function() return not E.db.mui.misc.ozcooldowns.enable end,
				args = {
					Vertical = {
						order = 1,
						type = "toggle",
						name = L["Vertical"],
					},
					Tooltips = {
						order = 2,
						type = "toggle",
						name = L["Tooltip"],
					},
					Announce = {
						order = 3,
						type = "toggle",
						name = L["Announce on Click"],
					},
					Size = {
						order = 4,
						type = "range",
						width = "full",
						name = L["Size"],
						min = 30, max = 60, step = 1,
					},
					Spacing = {
						order = 5,
						type = "range",
						width = "full",
						name = L["Spacing"],
						min = 0, max = 20, step = 1,
					},
					Mode = {
						order = 6,
						type = "select",
						name = L["Dim or Hide"],
						width = "full",
						values = {
							["DIM"] = "DIM",
							["HIDE"] = "HIDE",
						},
					},
				},
			},
			statusbar = {
				order = 5,
				type = "group",
				name = L["Status Bar"],
				guiInline = true,
				hidden = function() return not E.db.mui.misc.ozcooldowns.enable end,
				args = {
					StatusBar = {
						order = 1,
						type = "toggle",
						name = L["Enabled"],
					},
					StatusBarTexture = {
						type = "select", dialogControl = 'LSM30_Statusbar',
						order = 2,
						name = L["Texture"],
						values = AceGUIWidgetLSMlists.statusbar,
						disabled = function() return not E.db.mui.misc.ozcooldowns["StatusBar"] end,
					},
					FadeMode = {
						order = 3,
						type = "select",
						name = L["Fade Mode"],
						values = {
							["None"] = "None",
							["RedToGreen"] = "Red to Green",
							["GreenToRed"] = "Green to Red",
						},
					},
					StatusBarTextureColor = {
						type = "color",
						order = 4,
						name = L["Texture Color"],
						hasAlpha = false,
						get = function(info)
							local t = E.db.mui.misc.ozcooldowns[info[#info]]
							return t.r, t.g, t.b, t.a
						end,
						set = function(info, r, g, b)
							E.db.mui.misc.ozcooldowns[info[#info]] = {}
							local t = E.db.mui.misc.ozcooldowns[info[#info]]
							t.r, t.g, t.b = r, g, b
						end,
						disabled = function() return not E.db.mui.misc.ozcooldowns["StatusBar"] or E.db.mui.misc.ozcooldowns["FadeMode"] == "GreenToRed" or E.db.mui.misc.ozcooldowns["FadeMode"] == "RedToGreen" end,
					},
				},
			},
			about = {
				type = "group",
				name = L["Help"],
				order = 6,
				guiInline = true,
				hidden = function() return not E.db.mui.misc.ozcooldowns.enable end,
				args = {
					reset = {
						type = 'execute',
						order = 1,
						name = L["Reset Settings"],
						desc = CONFIRM_RESET_SETTINGS,
						confirm = true,
						func = function()
							E.db.mui.misc.ozcooldowns = CopyTable(Defaults)
							E.db.mui.misc.ozcooldowns.optionsCopied = true;
							E.private.muiMisc.ozcooldowns.spellCDs = CopyTable(E.private.muiMisc.ozcooldowns.spellDefaults);
						end,
					}
				}
			}
		},
	}
end
tinsert(MER.Config, OzCooldowns)

