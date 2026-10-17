local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local MNP = MER:GetModule("MER_Nameplates")
	local LSM = E.Libs.LSM

	local pairs, tonumber, tsort = pairs, tonumber, table.sort

	local options = module.options.modules.args

	-- Own disabled replaces the group's, so the children repeat the requirement
	local function FactionIndicatorDisabled()
		return not MER:HasRequirements(I.Requirements.NamePlates) or not E.db.mui.nameplates.factionIndicator.enable
	end

	local function TargetArrowsDisabled()
		return not MER:HasRequirements(I.Requirements.NamePlates) or not E.db.mui.nameplates.targetArrows.enable
	end

	local function TargetArrowsCustomColorDisabled()
		return TargetArrowsDisabled() or E.db.mui.nameplates.targetArrows.colorMode ~= "CUSTOM"
	end

	local function TargetEmphasisDisabled()
		return not MER:HasRequirements(I.Requirements.NamePlates) or not E.db.mui.nameplates.targetEmphasis.enable
	end

	local function HighlightDisabled()
		return not MER:HasRequirements(I.Requirements.NamePlates) or not E.db.mui.nameplates.highlight.enable
	end

	local function HighlightCustomColorDisabled()
		return HighlightDisabled() or E.db.mui.nameplates.highlight.colorMode ~= "CUSTOM"
	end

	local function FocusHighlightDisabled()
		return not MER:HasRequirements(I.Requirements.NamePlates) or not E.db.mui.nameplates.focusHighlight.enable
	end

	local function FocusHighlightCustomColorDisabled()
		return FocusHighlightDisabled() or E.db.mui.nameplates.focusHighlight.colorMode ~= "CUSTOM"
	end

	local function EnemyForcesDisabled()
		return not MER:HasRequirements(I.Requirements.NamePlates) or not E.db.mui.nameplates.enemyForces.enable
	end

	local function CastTargetDisabled()
		return not MER:HasRequirements(I.Requirements.NamePlates) or not E.db.mui.nameplates.castTarget.enable
	end

	local function NeutralNameOnlyDisabled()
		return not MER:HasRequirements(I.Requirements.NamePlates) or not E.db.mui.nameplates.neutralNameOnly.enable
	end

	local COLOR_MODES = {
		CLASS = L["Class Color"],
		CUSTOM = L["Custom"],
	}

	-- ElvUI's arrow textures, shown as icons and sorted by their number
	local arrowValues, arrowSorting = {}, {}
	for key, texture in pairs(E.Media.Arrows) do
		arrowValues[key] = E:TextureString(texture, ":16:16")
		arrowSorting[#arrowSorting + 1] = key
	end
	tsort(arrowSorting, function(a, b)
		local numA, numB = tonumber(a:match("%d+")), tonumber(b:match("%d+"))
		if numA and numB then
			return numA < numB
		end
		return a < b
	end)

	-- tbl: settings table getter, update: refresh after a change
	local function CustomColorOption(order, tbl, defaults, update, disabled)
		return {
			order = order,
			type = "color",
			name = L["Custom Color"],
			hasAlpha = false,
			disabled = disabled,
			get = function()
				local db = tbl().customColor
				local default = defaults.customColor
				return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
			end,
			set = function(_, r, g, b)
				local db = tbl().customColor
				db.r, db.g, db.b = r, g, b
				update()
			end,
		}
	end

	options.nameplates = {
		type = "group",
		name = module:AddCategorieIcon(L["NamePlates"], "nameplates"),
		-- One tab per topic instead of one long page of eleven groups
		childGroups = "tab",
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["NamePlates"],
			},
			requirements = module.RequirementsNotice(I.Requirements.NamePlates, 1.5),
			indicators = {
				order = 2,
				type = "group",
				name = L["Indicators"],
				args = {
					factionIndicator = {
						order = 1,
						type = "group",
						name = L["Faction Indicator"],
						guiInline = true,
						get = function(info)
							return E.db.mui.nameplates.factionIndicator[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.nameplates.factionIndicator[info[#info]] = value
							MNP:UpdateFactionIndicators()
						end,
						disabled = module.RequirementsDisabled(I.Requirements.NamePlates),
						args = {
							enable = module.ToggleCard({
								order = 1,
								name = L["Enable"],
								desc = L["Shows the faction icon of players from the opposing faction."],
							}),
							preview = module.PreviewOption(1.5, "MERFactionIndicatorPreview", "nameplates"),
							style = {
								order = 3,
								type = "select",
								name = L["Style"],
								disabled = FactionIndicatorDisabled,
								values = {
									crest = L["Crest"],
									round = L["Round"],
								},
							},
							size = {
								order = 4,
								type = "range",
								name = L["Size"],
								disabled = FactionIndicatorDisabled,
								min = 8,
								max = 60,
								step = 1,
							},
							position = {
								order = 5,
								type = "select",
								name = L["Anchor Point"],
								disabled = FactionIndicatorDisabled,
								values = I.Values.positionValues,
							},
							xOffset = {
								order = 6,
								type = "range",
								name = L["X-Offset"],
								disabled = FactionIndicatorDisabled,
								min = -100,
								max = 100,
								step = 1,
							},
							yOffset = {
								order = 7,
								type = "range",
								name = L["Y-Offset"],
								disabled = FactionIndicatorDisabled,
								min = -100,
								max = 100,
								step = 1,
							},
						},
					},
					targetArrows = {
						order = 2,
						type = "group",
						name = L["Target Arrows"],
						guiInline = true,
						get = function(info)
							return E.db.mui.nameplates.targetArrows[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.nameplates.targetArrows[info[#info]] = value
							MNP:UpdateTargetArrows()
						end,
						disabled = module.RequirementsDisabled(I.Requirements.NamePlates),
						args = {
							enable = module.ToggleCard({
								order = 1,
								name = L["Enable"],
								desc = L["Animated arrows next to the nameplate of your target. While enabled, they replace the arrows of ElvUI's target indicator, its glow stays."],
							}),
							preview = module.PreviewOption(1.5, "MERTargetArrowsPreview", "nameplates"),
							layout = {
								order = 3,
								type = "select",
								name = L["Layout"],
								disabled = TargetArrowsDisabled,
								values = {
									sides = L["Side Arrows"],
									top = L["Top Arrow"],
									all = L["Side Arrows"] .. " + " .. L["Top Arrow"],
								},
							},
							animation = {
								order = 4,
								type = "select",
								name = L["Animation"],
								disabled = TargetArrowsDisabled,
								values = {
									none = L["None"],
									slide = L["Slide In"],
									bounce = L["Bounce"],
									slideBounce = L["Slide In"] .. " + " .. L["Bounce"],
								},
							},
							size = {
								order = 5,
								type = "range",
								name = L["Size"],
								disabled = TargetArrowsDisabled,
								min = 8,
								max = 48,
								step = 1,
							},
							spacing = {
								order = 6,
								type = "range",
								name = L["Spacing"],
								disabled = TargetArrowsDisabled,
								min = -20,
								max = 30,
								step = 1,
							},
							colorMode = {
								order = 7,
								type = "select",
								name = L["Color"],
								disabled = TargetArrowsDisabled,
								values = COLOR_MODES,
							},
							customColor = CustomColorOption(
								8,
								function()
									return E.db.mui.nameplates.targetArrows
								end,
								P.nameplates.targetArrows,
								function()
									MNP:UpdateTargetArrows()
								end,
								TargetArrowsCustomColorDisabled
							),
							arrow = {
								order = 9,
								type = "select",
								name = L["Arrow Texture"],
								disabled = TargetArrowsDisabled,
								values = arrowValues,
								sorting = arrowSorting,
							},
						},
					},
					targetEmphasis = {
						order = 2.5,
						type = "group",
						name = L["Target Emphasis"],
						guiInline = true,
						get = function(info)
							return E.db.mui.nameplates.targetEmphasis[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.nameplates.targetEmphasis[info[#info]] = value
							MNP:UpdateTargetEmphasis()
						end,
						disabled = module.RequirementsDisabled(I.Requirements.NamePlates),
						args = {
							enable = module.ToggleCard({
								order = 1,
								name = F.NewFeatureText(L["Enable"]),
								desc = L["Makes the nameplate of your target stand out: while you have a target, the other nameplates fade and get a dark shade, the new target pops up once."],
							}),
							preview = module.PreviewOption(1.5, "MERTargetEmphasisPreview", "nameplates"),
							shade = {
								order = 3,
								type = "toggle",
								name = L["Shade Other Plates"],
								desc = L["Lays a dark shade over the health bar of the nameplates that aren't your target."],
								disabled = TargetEmphasisDisabled,
							},
							shadeAlpha = {
								order = 4,
								type = "range",
								name = L["Shade Strength"],
								disabled = function()
									return TargetEmphasisDisabled() or not E.db.mui.nameplates.targetEmphasis.shade
								end,
								min = 0.05,
								max = 0.9,
								step = 0.05,
								isPercent = true,
							},
							fade = {
								order = 5,
								type = "toggle",
								name = L["Fade Other Plates"],
								desc = L["Lowers the alpha of the nameplates that aren't your target. Plates that use the Visibility settings of ElvUI keep their own alpha."],
								disabled = TargetEmphasisDisabled,
							},
							alpha = {
								order = 6,
								type = "range",
								name = L["Alpha"],
								disabled = function()
									return TargetEmphasisDisabled() or not E.db.mui.nameplates.targetEmphasis.fade
								end,
								min = 0.1,
								max = 1,
								step = 0.05,
								isPercent = true,
							},
							keepCasting = {
								order = 7,
								type = "toggle",
								name = L["Keep Casting Units"],
								desc = L["Units that are casting keep their full alpha, so their castbar stays easy to see."],
								disabled = function()
									return TargetEmphasisDisabled() or not E.db.mui.nameplates.targetEmphasis.fade
								end,
							},
							pop = {
								order = 8,
								type = "toggle",
								name = L["Pop on Target"],
								desc = L["The nameplate of a new target grows for a moment."],
								disabled = TargetEmphasisDisabled,
							},
							popScale = {
								order = 9,
								type = "range",
								name = L["Pop Size"],
								disabled = function()
									return TargetEmphasisDisabled() or not E.db.mui.nameplates.targetEmphasis.pop
								end,
								min = 1.02,
								max = 1.3,
								step = 0.01,
								isPercent = true,
							},
							glow = {
								order = 9.1,
								type = "toggle",
								name = L["Stronger Border Glow"],
								desc = L["Makes the border glow of ElvUI's target indicator wider and lets it fade in on a new target. Needs one of the Border styles as Target Glow Style, the color stays ElvUI's Glow Color."],
								disabled = TargetEmphasisDisabled,
							},
							glowSize = {
								order = 9.2,
								type = "range",
								name = L["Glow Size"],
								disabled = function()
									return TargetEmphasisDisabled() or not E.db.mui.nameplates.targetEmphasis.glow
								end,
								min = 5,
								max = 16,
								step = 1,
							},
							glowPulse = {
								order = 9.3,
								type = "toggle",
								name = L["Pulse"],
								desc = L["The border glow slowly pulses."],
								disabled = function()
									return TargetEmphasisDisabled() or not E.db.mui.nameplates.targetEmphasis.glow
								end,
							},
							raise = {
								order = 9.5,
								type = "toggle",
								name = L["Bring Target to Front"],
								desc = L["Draws the nameplate of your target above the nameplates it overlaps."],
								disabled = TargetEmphasisDisabled,
							},
							combatOnly = {
								order = 10,
								type = "toggle",
								name = L["Only In Combat"],
								desc = L["Only fades and shades the other nameplates while you are in combat."],
								disabled = TargetEmphasisDisabled,
							},
							friendly = {
								order = 11,
								type = "toggle",
								name = L["Friendly Plates"],
								desc = L["Also fades and shades the nameplates of friendly units."],
								disabled = TargetEmphasisDisabled,
							},
						},
					},
					markerColor = {
						order = 3.2,
						type = "group",
						name = L["Raid Marker Color"],
						guiInline = true,
						get = function(info)
							return E.db.mui.nameplates.markerColor[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.nameplates.markerColor[info[#info]] = value
							MNP:UpdateMarkerColors()
						end,
						disabled = module.RequirementsDisabled(I.Requirements.NamePlates),
						args = {
							enable = module.ToggleCard({
								order = 1,
								name = L["Enable"],
								desc = L["Tints the health bar of a nameplate with a raid marker in the color of that marker."],
							}),
							preview = {
								order = 1.5,
								type = "description",
								dialogControl = "MERNameplateHealthPreview",
								name = "markerColor",
								width = "full",
							},
							alpha = {
								order = 3,
								type = "range",
								name = L["Alpha"],
								disabled = function()
									return not MER:HasRequirements(I.Requirements.NamePlates)
										or not E.db.mui.nameplates.markerColor.enable
								end,
								min = 0.05,
								max = 1,
								step = 0.05,
								isPercent = true,
							},
						},
					},
					enemyForces = {
						order = 3.3,
						type = "group",
						name = L["Enemy Forces"],
						hidden = E.Forever,
						guiInline = true,
						get = function(info)
							return E.db.mui.nameplates.enemyForces[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.nameplates.enemyForces[info[#info]] = value
							MNP:UpdateEnemyForces()
						end,
						disabled = module.RequirementsDisabled(I.Requirements.NamePlates),
						args = {
							enable = module.ToggleCard({
								order = 1,
								name = L["Enable"],
								desc = L["During a Mythic+ keystone run, shows next to the health bar how much an enemy contributes to the Enemy Forces requirement."],
							}),
							preview = {
								order = 1.5,
								type = "description",
								dialogControl = "MERNameplateHealthPreview",
								name = "enemyForces",
								width = "full",
							},
							format = {
								order = 3,
								type = "select",
								name = L["Contribution Format"],
								desc = L["How the enemy's own contribution is shown."],
								disabled = EnemyForcesDisabled,
								values = {
									PERCENT = L["Percent"],
									NUMBER = L["Number"],
									BOTH = L["Both"],
								},
							},
							fontSize = {
								order = 4,
								type = "range",
								name = L["Font Size"],
								disabled = EnemyForcesDisabled,
								min = 6,
								max = 24,
								step = 1,
							},
							color = {
								order = 5,
								type = "color",
								name = L["Color"],
								hasAlpha = false,
								disabled = EnemyForcesDisabled,
								get = function()
									local db = E.db.mui.nameplates.enemyForces.color
									local default = P.nameplates.enemyForces.color
									return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
								end,
								set = function(_, r, g, b)
									local db = E.db.mui.nameplates.enemyForces.color
									db.r, db.g, db.b = r, g, b
									MNP:UpdateEnemyForces()
								end,
							},
							position = {
								order = 6,
								type = "select",
								name = L["Anchor Point"],
								disabled = EnemyForcesDisabled,
								values = I.Values.positionValues,
							},
							xOffset = {
								order = 7,
								type = "range",
								name = L["X-Offset"],
								disabled = EnemyForcesDisabled,
								min = -100,
								max = 100,
								step = 1,
							},
							yOffset = {
								order = 8,
								type = "range",
								name = L["Y-Offset"],
								disabled = EnemyForcesDisabled,
								min = -100,
								max = 100,
								step = 1,
							},
						},
					},
				},
			},
			highlight = {
				order = 3,
				type = "group",
				name = L["Highlight"],
				args = {
					highlight = {
						order = 3,
						type = "group",
						name = L["Hover Highlight"],
						guiInline = true,
						get = function(info)
							return E.db.mui.nameplates.highlight[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.nameplates.highlight[info[#info]] = value
							MNP:UpdateHighlights()
						end,
						disabled = module.RequirementsDisabled(I.Requirements.NamePlates),
						args = {
							enable = module.ToggleCard({
								order = 1,
								name = L["Enable"],
								desc = L["Restyles the highlight on the health bar of the nameplate under your mouse. Needs the Highlight option of ElvUI's nameplates."],
							}),
							preview = module.PreviewOption(1.5, "MERNameplateHealthPreview", "highlight"),
							fade = {
								order = 3,
								type = "toggle",
								name = L["Fade In"],
								disabled = HighlightDisabled,
							},
							additive = {
								order = 4,
								type = "toggle",
								name = L["Additive Blend"],
								desc = L["Brightens the health bar instead of laying the texture over it."],
								disabled = HighlightDisabled,
							},
							texture = {
								order = 5,
								type = "select",
								name = L["Texture"],
								dialogControl = "LSM30_Statusbar",
								values = LSM:HashTable("statusbar"),
								disabled = HighlightDisabled,
							},
							alpha = {
								order = 6,
								type = "range",
								name = L["Alpha"],
								disabled = HighlightDisabled,
								min = 0.05,
								max = 1,
								step = 0.05,
								isPercent = true,
							},
							colorMode = {
								order = 7,
								type = "select",
								name = L["Color"],
								disabled = HighlightDisabled,
								values = COLOR_MODES,
							},
							customColor = CustomColorOption(
								8,
								function()
									return E.db.mui.nameplates.highlight
								end,
								P.nameplates.highlight,
								function()
									MNP:UpdateHighlights()
								end,
								HighlightCustomColorDisabled
							),
						},
					},
					focusHighlight = {
						order = 3.1,
						type = "group",
						name = L["Focus Highlight"],
						guiInline = true,
						get = function(info)
							return E.db.mui.nameplates.focusHighlight[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.nameplates.focusHighlight[info[#info]] = value
							MNP:UpdateFocusHighlights()
						end,
						disabled = module.RequirementsDisabled(I.Requirements.NamePlates),
						args = {
							enable = module.ToggleCard({
								order = 1,
								name = L["Enable"],
								desc = L["Lays a texture over the health bar of your focus target's nameplate."],
							}),
							preview = {
								order = 1.5,
								type = "description",
								dialogControl = "MERNameplateHealthPreview",
								name = "focusHighlight",
								width = "full",
							},
							texture = {
								order = 3,
								type = "select",
								name = L["Texture"],
								dialogControl = "LSM30_Statusbar",
								values = LSM:HashTable("statusbar"),
								disabled = FocusHighlightDisabled,
							},
							alpha = {
								order = 4,
								type = "range",
								name = L["Alpha"],
								disabled = FocusHighlightDisabled,
								min = 0.05,
								max = 1,
								step = 0.05,
								isPercent = true,
							},
							colorMode = {
								order = 5,
								type = "select",
								name = L["Color"],
								disabled = FocusHighlightDisabled,
								values = COLOR_MODES,
							},
							customColor = CustomColorOption(
								6,
								function()
									return E.db.mui.nameplates.focusHighlight
								end,
								P.nameplates.focusHighlight,
								function()
									MNP:UpdateFocusHighlights()
								end,
								FocusHighlightCustomColorDisabled
							),
						},
					},
				},
			},
			castbar = {
				order = 4,
				type = "group",
				name = L["Castbar"],
				args = {
					interruptReady = module.InterruptReadyOptions(4, function()
						return E.db.mui.nameplates.interruptReady
					end, function()
						MNP:UpdateInterruptReady()
					end, module.RequirementsDisabled(I.Requirements.NamePlates), "nameplates"),
					castbarShield = module.CastbarShieldOptions(
						4.5,
						function()
							return E.db.mui.nameplates.castbarShield
						end,
						function()
							MNP:UpdateCastbarShield()
						end,
						module.RequirementsDisabled(I.Requirements.NamePlates),
						"nameplates",
						{
							desc = {
								order = 1,
								type = "description",
								name = L["Shows a shield icon on the castbar of hostile units while their cast can't be interrupted."],
								width = "full",
							},
						}
					),
					castTarget = {
						order = 5,
						type = "group",
						name = L["Cast on You"],
						guiInline = true,
						get = function(info)
							return E.db.mui.nameplates.castTarget[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.nameplates.castTarget[info[#info]] = value
							MNP:UpdateCastTargets()
						end,
						disabled = module.RequirementsDisabled(I.Requirements.NamePlates),
						args = {
							enable = module.ToggleCard({
								order = 1,
								name = L["Enable"],
								desc = L["Marks the castbar of hostile units while their cast targets you. Channeled spells are not marked."],
							}),
							preview = {
								order = 1.5,
								type = "description",
								dialogControl = "MERCastTargetPreview",
								name = "nameplates",
								width = "full",
							},
							border = {
								order = 3,
								type = "toggle",
								name = L["Castbar Border"],
								desc = L["A colored border around the castbar."],
								disabled = CastTargetDisabled,
							},
							borderSize = {
								order = 4,
								type = "range",
								name = L["Border Size"],
								disabled = function()
									return CastTargetDisabled() or not E.db.mui.nameplates.castTarget.border
								end,
								min = 1,
								max = 5,
								step = 1,
							},
							tint = {
								order = 5,
								type = "toggle",
								name = L["Castbar Color"],
								desc = L["Colors the filled part of the castbar. The Interrupt Ready colors stay on top."],
								disabled = CastTargetDisabled,
							},
							color = {
								order = 6,
								type = "color",
								name = L["Color"],
								hasAlpha = false,
								disabled = CastTargetDisabled,
								get = function()
									local db = E.db.mui.nameplates.castTarget.color
									local default = P.nameplates.castTarget.color
									return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
								end,
								set = function(_, r, g, b)
									local db = E.db.mui.nameplates.castTarget.color
									db.r, db.g, db.b = r, g, b
									MNP:UpdateCastTargets()
								end,
							},
						},
					},
				},
			},
			healthBar = {
				order = 5,
				type = "group",
				name = L["Health Bar"],
				args = {
					executeLine = module.ExecuteLineOptions(6, function()
						return E.db.mui.nameplates.executeLine
					end, function()
						MNP:UpdateExecuteLines()
					end, module.RequirementsDisabled(I.Requirements.NamePlates), "nameplates"),
				},
			},
			neutralNameOnly = {
				order = 6,
				type = "group",
				name = L["Neutral Name Only"],
				get = function(info)
					return E.db.mui.nameplates.neutralNameOnly[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.nameplates.neutralNameOnly[info[#info]] = value
					MNP:UpdateNeutralNameOnly()
				end,
				disabled = module.RequirementsDisabled(I.Requirements.NamePlates),
				args = {
					enable = module.ToggleCard({
						order = 1,
						name = L["Enable"],
						desc = L["Neutral NPCs use the Friendly NPC settings of ElvUI's nameplates, by default only their name is shown."],
					}),
					target = {
						order = 2,
						type = "toggle",
						name = L["Show on Target"],
						desc = L["Shows the full nameplate while the unit is your target."],
						disabled = NeutralNameOnlyDisabled,
					},
					combat = {
						order = 3,
						type = "toggle",
						name = L["Show in Combat"],
						desc = L["Shows the full nameplate while the unit fights you or your group."],
						disabled = NeutralNameOnlyDisabled,
					},
					gradientName = {
						order = 4,
						type = "toggle",
						name = L["Gradient Name"],
						desc = L["Shows the name with the [name:MER:gradient] tag instead of the Friendly NPC name format."],
						disabled = NeutralNameOnlyDisabled,
					},
				},
			},
		},
	}
	F.MarkTabAsNew("nameplates")
	F.MarkTabAsNew("indicators")
end)
