local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local MUF = MER:GetModule("MER_UnitFrames")

	local options = module.options.modules.args

	F.MarkTabAsNew("unitframes")

	-- Own disabled replaces the group's, so every own disabled repeats the requirement
	local function UnitFramesDisabled()
		return not MER:HasRequirements(I.Requirements.UnitFrames)
	end

	local function RestingIndicatorDisabled()
		return UnitFramesDisabled()
			or not E.db.unitframe.units.player.enable
			or not E.db.unitframe.units.player.RestIcon.enable
			or not E.db.mui.unitframes.restingIndicator.enable
	end

	local function FactionIndicatorOptions(order, unit)
		return {
			order = order,
			type = "group",
			name = L["Faction Indicator"],
			guiInline = true,
			get = function(info)
				return E.db.mui.unitframes.factionIndicator.units[unit][info[#info]]
			end,
			set = function(info, value)
				E.db.mui.unitframes.factionIndicator.units[unit][info[#info]] = value
				MUF:UpdateFactionIndicators()
			end,
			disabled = function()
				return UnitFramesDisabled()
					or not E.db.mui.unitframes.factionIndicator.enable
					or not E.db.unitframe.units[unit].enable
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				preview = module.PreviewOption(1.5, "MERFactionIndicatorPreview", "unitframes:" .. unit),
				size = {
					order = 2,
					type = "range",
					name = L["Size"],
					min = 8,
					max = 60,
					step = 1,
				},
				position = {
					order = 3,
					type = "select",
					name = L["Anchor Point"],
					values = I.Values.positionValues,
				},
				xOffset = {
					order = 4,
					type = "range",
					name = L["X-Offset"],
					min = -100,
					max = 100,
					step = 1,
				},
				yOffset = {
					order = 5,
					type = "range",
					name = L["Y-Offset"],
					min = -100,
					max = 100,
					step = 1,
				},
			},
		}
	end

	options.unitframes = {
		type = "group",
		name = module:AddCategorieIcon(L["UnitFrames"], "unitframes"),
		childGroups = "tab",
		get = function(info)
			return E.db.mui.unitframes[info[#info]]
		end,
		set = function(info, value)
			E.db.mui.unitframes[info[#info]] = value
			E:StaticPopup_Show("CONFIG_RL")
		end,
		disabled = UnitFramesDisabled,
		args = {
			name = {
				order = 1,
				type = "header",
				name = L["UnitFrames"],
			},
			requirements = module.RequirementsNotice(I.Requirements.UnitFrames, 1.5),
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				args = {
					raidIcons = module.ToggleCard({
						order = 1,
						name = L["Raid Icon"],
						desc = L["Change the default raid icons."],
					}, 0.5),
					highlight = module.ToggleCard({
						order = 2,
						name = L["Highlight"],
						desc = L["Adds an own highlight to the Unitframes"],
					}, 0.5),
					stylePreview = module.PreviewOption(3, "MERUnitFrameStylePreview", "unitframes"),
					interruptReady = module.InterruptReadyOptions(
						12,
						function()
							return E.db.mui.unitframes.interruptReady
						end,
						function()
							MUF:UpdateInterruptReady()
						end,
						UnitFramesDisabled,
						"unitframes",
						{
							units = {
								order = 7,
								type = "multiselect",
								name = L["Units"],
								values = {
									target = L["Target"],
									focus = L["Focus"],
									boss = L["Boss"],
									arena = L["Arena"],
								},
								get = function(_, key)
									return E.db.mui.unitframes.interruptReady.units[key]
								end,
								set = function(_, key, value)
									E.db.mui.unitframes.interruptReady.units[key] = value
									MUF:UpdateInterruptReady()
								end,
							},
						}
					),
					castbarShield = module.CastbarShieldOptions(
						12.5,
						function()
							return E.db.mui.unitframes.castbarShield
						end,
						function()
							MUF:UpdateCastbarShield()
						end,
						UnitFramesDisabled,
						"unitframes",
						{
							desc = {
								order = 1,
								type = "description",
								dialogControl = "MERNewFeatureLabel",
								name = F.NewFeatureTrailingText(
									L["Shows a shield icon on the castbar of hostile units while their cast can't be interrupted."]
								),
								width = "full",
							},
							units = {
								order = 7,
								type = "multiselect",
								name = L["Units"],
								values = {
									target = L["Target"],
									focus = L["Focus"],
									boss = L["Boss"],
									arena = L["Arena"],
								},
								get = function(_, key)
									return E.db.mui.unitframes.castbarShield.units[key]
								end,
								set = function(_, key, value)
									E.db.mui.unitframes.castbarShield.units[key] = value
									MUF:UpdateCastbarShield()
								end,
							},
						}
					),
					executeLine = module.ExecuteLineOptions(
						13,
						function()
							return E.db.mui.unitframes.executeLine
						end,
						function()
							MUF:UpdateExecuteLines()
						end,
						UnitFramesDisabled,
						"unitframes",
						{
							units = {
								order = 8,
								type = "multiselect",
								name = L["Units"],
								values = {
									target = L["Target"],
									focus = L["Focus"],
									boss = L["Boss"],
									arena = L["Arena"],
								},
								get = function(_, key)
									return E.db.mui.unitframes.executeLine.units[key]
								end,
								set = function(_, key, value)
									E.db.mui.unitframes.executeLine.units[key] = value
									MUF:UpdateExecuteLines()
								end,
							},
						}
					),
					roundedCorners = {
						order = 13.5,
						type = "group",
						name = L["Rounded Corners"],
						guiInline = true,
						get = function(info)
							return E.db.mui.unitframes.roundedCorners[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.unitframes.roundedCorners[info[#info]] = value
							MUF:UpdateRoundedCorners()
						end,
						args = {
							desc = {
								order = 1,
								type = "description",
								dialogControl = "MERNewFeatureLabel",
								name = F.NewFeatureTrailingText(
									L["Rounds the corners of the health, power and class bars, including their border."]
								),
								width = "full",
							},
							enable = {
								order = 2,
								type = "toggle",
								name = L["Enable"],
							},
							units = {
								order = 3,
								type = "multiselect",
								name = L["Units"],
								values = {
									player = L["Player"],
									target = L["Target"],
									focus = L["Focus"],
									targettarget = L["TargetTarget"],
									pet = L["Pet"],
									pettarget = L["PetTarget"],
									party = L["Party"],
									raid = L["Raid"],
									boss = L["Boss"],
									arena = L["Arena"],
									classbar = L["Class Bar"],
								},
								get = function(_, key)
									return E.db.mui.unitframes.roundedCorners.units[key]
								end,
								set = function(_, key, value)
									E.db.mui.unitframes.roundedCorners.units[key] = value
									MUF:UpdateRoundedCorners()
								end,
								disabled = function()
									return UnitFramesDisabled() or not E.db.mui.unitframes.roundedCorners.enable
								end,
							},
						},
					},
					factionIndicator = {
						order = 11,
						type = "group",
						name = L["Faction Indicator"],
						guiInline = true,
						get = function(info)
							return E.db.mui.unitframes.factionIndicator[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.unitframes.factionIndicator[info[#info]] = value
							MUF:UpdateFactionIndicators()
						end,
						args = {
							desc = {
								order = 1,
								type = "description",
								name = L["Shows the faction icon of players from the opposing faction."],
							},
							enable = {
								order = 2,
								type = "toggle",
								name = L["Enable"],
							},
							preview = module.PreviewOption(2.5, "MERFactionIndicatorPreview", "unitframes"),
							style = {
								order = 3,
								type = "select",
								name = L["Style"],
								values = {
									crest = L["Crest"],
									round = L["Round"],
								},
								disabled = function()
									return UnitFramesDisabled() or not E.db.mui.unitframes.factionIndicator.enable
								end,
							},
						},
					},
				},
			},
			individualUnits = {
				order = 3,
				type = "group",
				name = L["Individual Units"],
				args = {
					player = {
						order = 1,
						type = "group",
						name = L["Player"],
						args = {
							restingIndicator = {
								order = 1,
								type = "group",
								name = L["Resting Indicator"],
								guiInline = true,
								get = function(info)
									return E.db.mui.unitframes.restingIndicator[info[#info]]
								end,
								set = function(info, value)
									E.db.mui.unitframes.restingIndicator[info[#info]] = value
									MUF:UpdateRestingIndicator()
								end,
								disabled = function()
									return UnitFramesDisabled()
										or not E.db.unitframe.units.player.enable
										or not E.db.unitframe.units.player.RestIcon.enable
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
									},
									preview = module.PreviewOption(1.5, "MERRestingIndicatorPreview", "unitframes"),
									colorMode = {
										order = 2,
										type = "select",
										name = L["Color"],
										values = {
											CLASS_GRADIENT = L["Class Gradient"],
											CLASS = L["Class Color"],
											CUSTOM = L["Custom Color"],
											BLIZZARD = L["Blizzard"],
										},
										disabled = RestingIndicatorDisabled,
									},
									customColor = {
										order = 3,
										type = "color",
										name = L["Custom Color"],
										hasAlpha = false,
										disabled = RestingIndicatorDisabled,
										hidden = function()
											return E.db.mui.unitframes.restingIndicator.colorMode ~= "CUSTOM"
										end,
										get = function(info)
											local db = E.db.mui.unitframes.restingIndicator[info[#info]]
											local default = P.unitframes.restingIndicator[info[#info]]
											return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
										end,
										set = function(info, r, g, b)
											local db = E.db.mui.unitframes.restingIndicator[info[#info]]
											db.r, db.g, db.b = r, g, b
											MUF:UpdateRestingIndicator()
										end,
									},
									speed = {
										order = 4,
										type = "range",
										name = L["Animation Speed"],
										min = 0.25,
										max = 3,
										step = 0.05,
										isPercent = true,
										disabled = RestingIndicatorDisabled,
									},
								},
							},
						},
					},
					target = {
						order = 2,
						type = "group",
						name = L["Target"],
						args = {
							factionIndicator = FactionIndicatorOptions(1, "target"),
						},
					},
					targettarget = {
						order = 3,
						type = "group",
						name = L["TargetTarget"],
						args = {
							factionIndicator = FactionIndicatorOptions(1, "targettarget"),
						},
					},
					focus = {
						order = 4,
						type = "group",
						name = L["Focus"],
						args = {
							factionIndicator = FactionIndicatorOptions(1, "focus"),
						},
					},
					focustarget = {
						order = 5,
						type = "group",
						name = L["FocusTarget"],
						args = {
							factionIndicator = FactionIndicatorOptions(1, "focustarget"),
						},
					},
				},
			},
			groupUnits = {
				order = 4,
				type = "group",
				name = L["Group Units"],
				args = {
					arena = {
						order = 1,
						type = "group",
						name = L["Arena"],
						args = {
							factionIndicator = FactionIndicatorOptions(1, "arena"),
						},
					},
				},
			},
		},
	}
end)
