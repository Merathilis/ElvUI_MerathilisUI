local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

local MNP = MER:GetModule("MER_Nameplates")
local LSM = E.Libs.LSM

local pairs, tonumber, tsort = pairs, tonumber, table.sort

local options = module.options.modules.args

F.MarkTabAsNew("nameplates")

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
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["NamePlates"],
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
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
						requirements = module.RequirementsNotice(I.Requirements.NamePlates),
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
						desc = {
							order = 1,
							type = "description",
							dialogControl = "MERNewFeatureLabel",
							name = F.NewFeatureTrailingText(L["Animated arrows next to the nameplate of your target. While enabled, they replace the arrows of ElvUI's target indicator, its glow stays."]),
						},
						enable = {
							order = 2,
							type = "toggle",
							name = L["Enable"],
						},
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
						customColor = CustomColorOption(8, function()
							return E.db.mui.nameplates.targetArrows
						end, P.nameplates.targetArrows, function()
							MNP:UpdateTargetArrows()
						end, TargetArrowsCustomColorDisabled),
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
						desc = {
							order = 1,
							type = "description",
							dialogControl = "MERNewFeatureLabel",
							name = F.NewFeatureTrailingText(L["Restyles the highlight on the health bar of the nameplate under your mouse. Needs the Highlight option of ElvUI's nameplates."]),
						},
						enable = {
							order = 2,
							type = "toggle",
							name = L["Enable"],
						},
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
						customColor = CustomColorOption(8, function()
							return E.db.mui.nameplates.highlight
						end, P.nameplates.highlight, function()
							MNP:UpdateHighlights()
						end, HighlightCustomColorDisabled),
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
						desc = {
							order = 1,
							type = "description",
							dialogControl = "MERNewFeatureLabel",
							name = F.NewFeatureTrailingText(L["Lays a texture over the health bar of your focus target's nameplate."]),
						},
						preview = {
							order = 1.5,
							type = "description",
							dialogControl = "MERNameplateHealthPreview",
							name = "focusHighlight",
							width = "full",
						},
						enable = {
							order = 2,
							type = "toggle",
							name = L["Enable"],
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
						customColor = CustomColorOption(6, function()
							return E.db.mui.nameplates.focusHighlight
						end, P.nameplates.focusHighlight, function()
							MNP:UpdateFocusHighlights()
						end, FocusHighlightCustomColorDisabled),
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
						desc = {
							order = 1,
							type = "description",
							dialogControl = "MERNewFeatureLabel",
							name = F.NewFeatureTrailingText(L["Tints the health bar of a nameplate with a raid marker in the color of that marker."]),
						},
						preview = {
							order = 1.5,
							type = "description",
							dialogControl = "MERNameplateHealthPreview",
							name = "markerColor",
							width = "full",
						},
						enable = {
							order = 2,
							type = "toggle",
							name = L["Enable"],
						},
						alpha = {
							order = 3,
							type = "range",
							name = L["Alpha"],
							disabled = function()
								return not MER:HasRequirements(I.Requirements.NamePlates) or not E.db.mui.nameplates.markerColor.enable
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
						desc = {
							order = 1,
							type = "description",
							dialogControl = "MERNewFeatureLabel",
							name = F.NewFeatureTrailingText(L["During a Mythic+ keystone run, shows next to the health bar how much an enemy contributes to the Enemy Forces requirement."]),
						},
						preview = {
							order = 1.5,
							type = "description",
							dialogControl = "MERNameplateHealthPreview",
							name = "enemyForces",
							width = "full",
						},
						enable = {
							order = 2,
							type = "toggle",
							name = L["Enable"],
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
				interruptReady = module.InterruptReadyOptions(4, function()
					return E.db.mui.nameplates.interruptReady
				end, function()
					MNP:UpdateInterruptReady()
				end, module.RequirementsDisabled(I.Requirements.NamePlates), "nameplates"),
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
						desc = {
							order = 1,
							type = "description",
							dialogControl = "MERNewFeatureLabel",
							name = F.NewFeatureTrailingText(L["Marks the castbar of hostile units while their cast targets you. Channeled spells are not marked."]),
						},
						preview = {
							order = 1.5,
							type = "description",
							dialogControl = "MERCastTargetPreview",
							name = "nameplates",
							width = "full",
						},
						enable = {
							order = 2,
							type = "toggle",
							name = L["Enable"],
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
				executeLine = module.ExecuteLineOptions(6, function()
					return E.db.mui.nameplates.executeLine
				end, function()
					MNP:UpdateExecuteLines()
				end, module.RequirementsDisabled(I.Requirements.NamePlates)),
			},
		},
	},
}
