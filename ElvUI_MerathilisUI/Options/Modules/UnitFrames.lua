local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local MUF = MER:GetModule("MER_UnitFrames")

local options = module.options.modules.args

F.MarkTabAsNew("unitframes")

-- Own disabled replaces the group's, so every own disabled repeats the requirement
local function UnitFramesDisabled()
	return not MER:HasRequirements(I.Requirements.UnitFrames)
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
				raidIcons = {
					order = 1,
					type = "toggle",
					name = L["Raid Icon"],
					desc = L["Change the default raid icons."],
				},
				highlight = {
					order = 2,
					type = "toggle",
					name = L["Highlight"],
					desc = L["Adds an own highlight to the Unitframes"],
				},
				spacer = {
					order = 10,
					type = "description",
					name = "",
				},
				interruptReady = module.InterruptReadyOptions(12, function()
					return E.db.mui.unitframes.interruptReady
				end, function()
					MUF:UpdateInterruptReady()
				end, UnitFramesDisabled, "unitframes", {
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
				}),
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
								E:StaticPopup_Show("CONFIG_RL")
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
