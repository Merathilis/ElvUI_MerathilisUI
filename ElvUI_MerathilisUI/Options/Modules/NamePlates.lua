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
				interruptReady = module.InterruptReadyOptions(4, function()
					return E.db.mui.nameplates.interruptReady
				end, function()
					MNP:UpdateInterruptReady()
				end, module.RequirementsDisabled(I.Requirements.NamePlates), "nameplates"),
			},
		},
	},
}
