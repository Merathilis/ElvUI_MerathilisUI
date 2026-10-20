local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local MUF = MER:GetModule("MER_UnitFrames")

	local options = module.options.modules.args

	-- Own disabled replaces the group's, so every own disabled repeats the requirement
	local function UnitFramesDisabled()
		return not MER:HasRequirements(I.Requirements.UnitFrames)
	end

	local function PortraitsDisabled()
		return UnitFramesDisabled() or not E.db.mui.unitframes.portraits.enable
	end

	-- The unit edited on the Portraits tab
	local portraitUnit = "player"

	local function PortraitUnitDB()
		return E.db.mui.unitframes.portraits.units[portraitUnit]
	end

	local function ClassificationDisabled()
		return PortraitsDisabled() or not E.db.mui.unitframes.portraits.classification.enable
	end

	local function ClassificationStyle()
		return E.db.mui.unitframes.portraits.classification.style
	end

	local function PortraitUnitDisabled()
		return PortraitsDisabled() or not PortraitUnitDB().enable
	end

	local function ColorOption(order, name, key, hidden)
		return {
			order = order,
			type = "color",
			name = name,
			hasAlpha = false,
			hidden = hidden,
			get = function()
				local db = E.db.mui.unitframes.portraits[key]
				local default = P.unitframes.portraits[key]
				return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
			end,
			set = function(_, r, g, b)
				local db = E.db.mui.unitframes.portraits[key]
				db.r, db.g, db.b = r, g, b
				MUF:UpdatePortraits()
			end,
		}
	end

	local function OffsetOption(order, name)
		return {
			order = order,
			type = "range",
			name = name,
			min = -200,
			max = 200,
			step = 1,
			disabled = PortraitUnitDisabled,
		}
	end

	local function RestingIndicatorDisabled()
		return UnitFramesDisabled()
			or not E.db.unitframe.units.player.enable
			or not E.db.unitframe.units.player.RestIcon.enable
			or not E.db.mui.unitframes.restingIndicator.enable
	end

	local function FactionIndicatorOptions(order, unit)
		local group = {
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
		module.LessCommon(group.args, "ufFactionIndicator" .. unit .. "More", { "position", "xOffset", "yOffset" })
		group.desc = L["Shows the faction icon of players from the opposing faction."]
		module.ModuleCard("ufFactionIndicator" .. unit, group, "enable")

		return group
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
								name = L["Shows a shield icon on the castbar of hostile units while their cast can't be interrupted."],
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
						hidden = E.Forever,
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
								name = L["Rounds the corners of the health, power, class and cast bars, including their border."],
								width = "full",
							},
							enable = {
								order = 2,
								type = "toggle",
								name = L["Enable"],
							},
							radius = {
								order = 3,
								type = "range",
								name = L["Radius"],
								desc = L["0 keeps the default subtle corners, any other value is the corner radius in pixels."],
								min = 0,
								max = 16,
								step = 1,
								disabled = function()
									return UnitFramesDisabled() or not E.db.mui.unitframes.roundedCorners.enable
								end,
							},
							units = {
								order = 4,
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
									castbar = L["Cast Bar"],
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
							style = module.Segmented({
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
							}, { "crest", "round" }),
						},
					},
				},
			},
			portraits = {
				order = 2.5,
				type = "group",
				name = L["Portraits"],
				get = function(info)
					return E.db.mui.unitframes.portraits[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.unitframes.portraits[info[#info]] = value
					MUF:UpdatePortraits()
				end,
				args = {
					desc = {
						order = 1,
						type = "description",
						name = L["Shows a portrait next to the unitframes, cut to a shape and framed by a ring in the unit's color."],
						width = "full",
					},
					enable = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
					},
					preview = module.PreviewOption(3, "MERPortraitsPreview", "player:target"),
					style = {
						order = 4,
						type = "group",
						name = L["Style"],
						guiInline = true,
						disabled = PortraitsDisabled,
						args = {
							style = module.Segmented({
								order = 1,
								type = "select",
								name = L["Shape"],
								values = {
									Drop = L["Drop"],
									Circle = L["Circle"],
									Square = L["Square"],
								},
							}, { "Drop", "Circle", "Square" }),
							colorMode = {
								order = 2,
								type = "select",
								name = L["Color"],
								desc = L["Class color for players, reaction color for NPCs. Gradient uses the colors of the Gradient Theme."],
								values = {
									CLASS = L["Class Color"],
									GRADIENT = L["Gradient"],
									CUSTOM = L["Custom Color"],
								},
							},
							customColor = ColorOption(3, L["Custom Color"], "customColor", function()
								return E.db.mui.unitframes.portraits.colorMode ~= "CUSTOM"
							end),
							backgroundColor = ColorOption(4, L["Background Color"], "backgroundColor"),
							shadow = {
								order = 5,
								type = "toggle",
								name = L["Shadow"],
							},
							shadowAlpha = {
								order = 6,
								type = "range",
								name = L["Shadow Alpha"],
								min = 0.1,
								max = 1,
								step = 0.05,
								isPercent = true,
								disabled = function()
									return PortraitsDisabled() or not E.db.mui.unitframes.portraits.shadow
								end,
							},
							innerShadow = {
								order = 7,
								type = "toggle",
								name = L["Inner Shadow"],
								desc = L["Darkens the portrait along the inside of the ring."],
							},
						},
					},
					classification = {
						order = 4.5,
						type = "group",
						name = L["Classification"],
						guiInline = true,
						disabled = PortraitsDisabled,
						get = function(info)
							return E.db.mui.unitframes.portraits.classification[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.unitframes.portraits.classification[info[#info]] = value
							MUF:UpdatePortraits()
						end,
						args = {
							desc = {
								order = 1,
								type = "description",
								name = L["Marks boss, elite and rare NPCs on their portrait."],
								width = "full",
							},
							enable = {
								order = 2,
								type = "toggle",
								name = L["Enable"],
							},
							style = module.Segmented({
								order = 3,
								type = "select",
								name = L["Style"],
								values = {
									DRAGON = L["Dragon"],
									BADGE = L["Badge"],
									RING = L["Ring Color"],
								},
								disabled = ClassificationDisabled,
							}, { "DRAGON", "BADGE", "RING" }),
							types = {
								order = 4,
								type = "multiselect",
								name = L["Show On"],
								values = {
									boss = L["Boss"],
									elite = L["Elite"],
									rareelite = L["Rare Elite"],
									rare = L["Rare"],
								},
								get = function(_, key)
									return E.db.mui.unitframes.portraits.classification.types[key]
								end,
								set = function(_, key, value)
									E.db.mui.unitframes.portraits.classification.types[key] = value
									MUF:UpdatePortraits()
								end,
								disabled = ClassificationDisabled,
							},
							dragonColor = module.Segmented({
								order = 5,
								type = "select",
								name = L["Dragon Color"],
								values = {
									BLIZZARD = L["Blizzard"],
									CLASSIFICATION = L["Classification Color"],
									UNIT = L["Portrait Color"],
								},
								hidden = function()
									return ClassificationStyle() ~= "DRAGON"
								end,
								disabled = ClassificationDisabled,
							}, { "BLIZZARD", "CLASSIFICATION", "UNIT" }),
							dragonScale = {
								order = 6,
								type = "range",
								name = L["Scale"],
								min = 0.5,
								max = 2,
								step = 0.05,
								isPercent = true,
								hidden = function()
									return ClassificationStyle() ~= "DRAGON"
								end,
								disabled = ClassificationDisabled,
							},
							dragonOnTop = {
								order = 7,
								type = "toggle",
								name = L["Above the Ring"],
								desc = L["Draws the dragon over the ring instead of behind it."],
								hidden = function()
									return ClassificationStyle() ~= "DRAGON"
								end,
								disabled = ClassificationDisabled,
							},
							badgeSize = {
								order = 8,
								type = "range",
								name = L["Size"],
								min = 8,
								max = 64,
								step = 1,
								hidden = function()
									return ClassificationStyle() ~= "BADGE"
								end,
								disabled = ClassificationDisabled,
							},
							badgeXOffset = {
								order = 9,
								type = "range",
								name = L["X-Offset"],
								min = -50,
								max = 50,
								step = 1,
								hidden = function()
									return ClassificationStyle() ~= "BADGE"
								end,
								disabled = ClassificationDisabled,
							},
							badgeYOffset = {
								order = 10,
								type = "range",
								name = L["Y-Offset"],
								min = -50,
								max = 50,
								step = 1,
								hidden = function()
									return ClassificationStyle() ~= "BADGE"
								end,
								disabled = ClassificationDisabled,
							},
							colors = {
								order = 11,
								type = "group",
								name = L["Classification Color"],
								guiInline = true,
								hidden = function()
									local db = E.db.mui.unitframes.portraits.classification
									return db.style ~= "RING"
										and not (db.style == "DRAGON" and db.dragonColor == "CLASSIFICATION")
								end,
								disabled = ClassificationDisabled,
								get = function(info)
									local db = E.db.mui.unitframes.portraits.classification.colors[info[#info]]
									local default = P.unitframes.portraits.classification.colors[info[#info]]
									return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
								end,
								set = function(info, r, g, b)
									local db = E.db.mui.unitframes.portraits.classification.colors[info[#info]]
									db.r, db.g, db.b = r, g, b
									MUF:UpdatePortraits()
								end,
								args = {
									boss = { order = 1, type = "color", name = L["Boss"], hasAlpha = false },
									elite = { order = 2, type = "color", name = L["Elite"], hasAlpha = false },
									rareelite = { order = 3, type = "color", name = L["Rare Elite"], hasAlpha = false },
									rare = { order = 4, type = "color", name = L["Rare"], hasAlpha = false },
								},
							},
						},
					},
					units = {
						order = 5,
						type = "group",
						name = L["Units"],
						guiInline = true,
						disabled = PortraitsDisabled,
						get = function(info)
							return PortraitUnitDB()[info[#info]]
						end,
						set = function(info, value)
							PortraitUnitDB()[info[#info]] = value
							MUF:UpdatePortraits()
						end,
						args = {
							unit = {
								order = 1,
								type = "select",
								name = L["Unit"],
								values = {
									player = L["Player"],
									target = L["Target"],
									focus = L["Focus"],
									targettarget = L["TargetTarget"],
									pet = L["Pet"],
									party = L["Party"],
									boss = L["Boss"],
									arena = L["Arena"],
								},
								get = function()
									return portraitUnit
								end,
								set = function(_, value)
									portraitUnit = value
								end,
							},
							enable = {
								order = 2,
								type = "toggle",
								name = L["Enable"],
							},
							preview = {
								order = 3,
								type = "description",
								dialogControl = "MERPortraitsPreview",
								name = function()
									return portraitUnit
								end,
								width = "full",
							},
							size = {
								order = 4,
								type = "range",
								name = L["Size"],
								min = 16,
								max = 128,
								step = 1,
								disabled = PortraitUnitDisabled,
							},
							cast = {
								order = 5,
								type = "toggle",
								name = L["Cast Icon"],
								desc = L["Shows the spell icon instead of the portrait while the unit casts."],
								disabled = PortraitUnitDisabled,
							},
							mirror = {
								order = 6,
								type = "toggle",
								name = L["Mirror"],
								desc = L["Flips the portrait and the shape, for frames on the right side."],
								disabled = PortraitUnitDisabled,
							},
							point = {
								order = 7,
								type = "select",
								name = L["Anchor Point"],
								values = I.Values.positionValues,
								disabled = PortraitUnitDisabled,
							},
							relativePoint = {
								order = 8,
								type = "select",
								name = L["Relative Point"],
								values = I.Values.positionValues,
								disabled = PortraitUnitDisabled,
							},
							xOffset = OffsetOption(9, L["X-Offset"]),
							yOffset = OffsetOption(10, L["Y-Offset"]),
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

	local portraitArgs = options.unitframes.args.portraits.args
	module.LessCommon(
		portraitArgs.style.args,
		"ufPortraitStyle",
		{ "backgroundColor", "shadow", "shadowAlpha", "innerShadow" }
	)
	module.LessCommon(portraitArgs.units.args, "ufPortraitUnits", { "point", "relativePoint", "xOffset", "yOffset" })
	module.ModuleCard("ufPortraitClassification", portraitArgs.classification, "enable")

	local generalArgs = options.unitframes.args.general.args
	module.ModuleCard("ufRoundedCorners", generalArgs.roundedCorners, "enable")
	module.ModuleCard("ufFactionIndicator", generalArgs.factionIndicator, "enable")

	module.ColorModeSelect(portraitArgs.style.args, "colorMode", "customColor", { "CLASS", "GRADIENT", "CUSTOM" })

	local playerArgs = options.unitframes.args.individualUnits.args.player.args
	module.ColorModeSelect(
		playerArgs.restingIndicator.args,
		"colorMode",
		"customColor",
		{ "CLASS_GRADIENT", "CLASS", "BLIZZARD", "CUSTOM" }
	)
	module.ModuleCard("ufRestingIndicator", playerArgs.restingIndicator, "enable")
end)
