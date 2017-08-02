local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = E:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")
local isEnabled = E.private["unitframe"].enable and true or false

-- Cache global variables
-- Lua functions
local _G = _G
local tinsert = table.insert
-- WoW API / Variables
local DEFAULT = DEFAULT

local function UnitFramesTable()
	E.Options.args.mui.args.unitframes = {
		order = 15,
		type = "group",
		name = MUF.modName,
		childGroups = "tab",
		disabled = function() return not E.private.unitframe.enable end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(MUF.modName),
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				args = {
					aura = {
						type = "group",
						name = "AuraIconText",
						guiInline = true,
						get = function(info) return E.db.mui.unitframes.AuraIconText[info[#info]] end,
						set = function(info, value) E.db.mui.unitframes.AuraIconText[info[#info]] = value; E:StaticPopup_Show("CONFIG_RL"); end,
						args = {
							dur = {
								order = 1,
								type = "group",
								name = L["Duration Text"],
								args = {
									hideDurationText = {
										order = 1,
										type = "toggle",
										name = L["Hide Text"],
										set = function(info, value) E.db.mui.unitframes.AuraIconText.hideDurationText = value; end,
										disabled = function() return not isEnabled end,
									},
									durationFilterOwner = {
										order = 2,
										type = "toggle",
										name = L["Hide From Others"],
										desc = L["Will hide duration text on auras that are not cast by you."],
										set = function(info, value) E.db.mui.unitframes.AuraIconText.durationFilterOwner = value; end,
										disabled = function() return (not isEnabled or E.db.mui.unitframes.AuraIconText.hideDurationText) end,
									},
									durationThreshold = {
										order = 3,
										type = "range",
										name = L["Threshold"],
										desc = L["Duration text will be hidden until it reaches this threshold (in seconds). Set to -1 to always show duration text."],
										set = function(info, value) E.db.mui.unitframes.AuraIconText.durationThreshold = value; end,
										disabled = function() return (not isEnabled or E.db.mui.unitframes.AuraIconText.hideDurationText) end,
										min = -1, max = 60, step = 1,
									},
									durationTextPos = {
										order = 4,
										type = "select",
										name = L["Position"],
										desc = L["Position of the duration text on the aura icon."],
										disabled = function() return not isEnabled end,
										values = {
											["BOTTOMLEFT"] = L["Bottom Left"],
											["BOTTOMRIGHT"] = L["Bottom Right"],
											["TOPLEFT"] = L["Top Left"],
											["TOPRIGHT"] = L["Top Right"],
											["CENTER"] = L["Center"],
										},
									},
									durationTextOffsetX = {
										order = 5,
										type = "range",
										name = L["X-Offset"],
										disabled = function() return not isEnabled end,
										min = -20, max = 20, step = 1,
									},
									durationTextOffsetY = {
										order = 6,
										type = "range",
										name = L["Y-Offset"],
										disabled = function() return not isEnabled end,
										min = -20, max = 20, step = 1,
									},
								},
							},
							stack = {
								order = 2,
								type = "group",
								name = L["Stack Text"],
								guiInline = true,
								args = {
									hideStackText = {
										order = 1,
										type = "toggle",
										name = L["Hide Text"],
										set = function(info, value) E.db.mui.unitframes.AuraIconText.hideStackText = value; end,
										disabled = function() return not isEnabled end,
									},
									stackFilterOwner = {
										order = 2,
										type = "toggle",
										name = L["Hide From Others"],
										desc = L["Will hide stack text on auras that are not cast by you."],
										set = function(info, value) E.db.mui.unitframes.AuraIconText.stackFilterOwner = value; end,
										disabled = function() return (not isEnabled or E.db.mui.unitframes.AuraIconText.hideStackText) end,
									},
									stackTextPos = {
										order = 3,
										type = "select",
										name = L["Position"],
										desc = L["Position of the stack count on the aura icon."],
										disabled = function() return not isEnabled end,
										values = {
											["BOTTOMLEFT"] = L["Bottom Left"],
											["BOTTOMRIGHT"] = L["Bottom Right"],
											["TOPLEFT"] = L["Top Left"],
											["TOPRIGHT"] = L["Top Right"],
											["CENTER"] = L["Center"],
										},
									},
									spacer = {
										order = 4,
										type = "description",
										name = "",
									},
									stackTextOffsetX = {
										order = 5,
										type = "range",
										name = L["X-Offset"],
										disabled = function() return not isEnabled end,
										min = -20, max = 20, step = 1,
									},
									stackTextOffsetY = {
										order = 6,
										type = "range",
										name = L["Y-Offset"],
										disabled = function() return not isEnabled end,
										min = -20, max = 20, step = 1,
									},
								},
							},
						},
					},
					spacing = {
						type = 'range',
						order = 1,
						name = L["Aura Spacing"],
						desc = L["Sets space between individual aura icons."],
						get = function(info) return E.db.mui.unitframes.AuraIconSpacing.spacing end,
						set = function(info, value) E.db.mui.unitframes.AuraIconSpacing.spacing = value; MUF:UpdateAuraSettings(); end,
						disabled = function() return not isEnabled end,
						min = 0, max = 10, step = 1,
					},
					units = {
						type = "multiselect",
						order = 2,
						name = L["Set Aura Spacing On Following Units"],
						get = function(info, key) return E.db.mui.unitframes.AuraIconSpacing.units[key] end,
						set = function(info, key, value) E.db.mui.unitframes.AuraIconSpacing.units[key] = value; MUF:UpdateAuraSettings(); end,
						disabled = function() return not isEnabled end,
						values = {
							['player'] = L["Player"],
							['target'] = L["Target"],
							['targettarget'] = L["TargetTarget"],
							['targettargettarget'] = L["TargetTargetTarget"],
							['focus'] = L["Focus"],
							['focustarget'] = L["FocusTarget"],
							['pet'] = L["Pet"],
							['pettarget'] = L["PetTarget"],
							['arena'] = L["Arena"],
							['boss'] = L["Boss"],
							['party'] = L["Party"],
							['raid'] = L["Raid"],
							['raid40'] = L["Raid40"],
							['raidpet'] = L["RaidPet"],
							["tank"] = L["Tank"],
							["assist"] = L["Assist"],
						},
					},
				},
			},
			player = {
				order = 3,
				type = "group",
				name = L["Player Frame"],
				args = {
					portrait = {
						order = 1,
						type = "execute",
						name = L["Player Portrait"],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "unitframe", "player", "portrait") end,
					},
				},
			},
			target = {
				order = 4,
				type = "group",
				name = L["Target Frame"],
				args = {
					portrait = {
						order = 1,
						type = "execute",
						name = L["Target Portrait"],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "unitframe", "target", "portrait") end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, UnitFramesTable)

local strataValues = {
	BACKGROUND = "BACKGROUND",
	LOW = "LOW",
	MEDIUM = "MEDIUM",
	HIGH = "HIGH",
	DIALOG = "DIALOG",
	TOOLTIP = "TOOLTIP",
}

local function ufPlayerTable()
	E.Options.args.unitframe.args.player.args.portrait.args.mui = {
		order = 10,
		type = "group",
		name = MER.Title,
		guiInline = true,
		get = function(info) return E.db.mui.unitframes.player[ info[#info] ] end,
		set = function(info, value) E.db.mui.unitframes.player[ info[#info] ] = value; MUF:ArrangePlayer(); end,
		hidden = function() return IsAddOnLoaded("ElvUI_BenikUI") end,
		args = {
			detachPortrait = {
				order = 1,
				type = "toggle",
				name = L["Detach Portrait"],
				set = function(info, value)
					E.db.mui.unitframes.player[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.player.args.portrait.args.width.min = 0
						E.db.unitframe.units.player.portrait.width = 0
						E.db.unitframe.units.player.orientation = "LEFT"
					else
						E.Options.args.unitframe.args.player.args.portrait.args.width.min = 15
						E.db.unitframe.units.player.portrait.width = 45
					end
					UF:CreateAndUpdateUF("player")
				end,
				disabled = function() return E.db.unitframe.units.player.portrait.overlay end,
			},
			portraitTransparent = {
				order = 2,
				type = "toggle",
				name = L["Transparent"],
				desc = L["Apply transparency on the portrait backdrop."],
				disabled = function() return E.db.unitframe.units.player.portrait.overlay end,
			},
			portraitShadow = {
				order = 3,
				type = 'toggle',
				name = L["Shadow"],
				desc = L["Apply shadow under the portrait"],
				disabled = function() return not E.db.mui.unitframes.player.detachPortrait end,
			},
			portraitWidth = {
				order = 4,
				type = 'range',
				name = L["Width"],
				desc = L["Change the detached portrait width"],
				disabled = function() return not E.db.mui.unitframes.player.detachPortrait end,
				min = 10, max = 500, step = 1,
			},
			portraitHeight = {
				order = 5,
				type = "range",
				name = L["Height"],
				desc = L["Change the detached portrait height"],
				disabled = function() return not E.db.mui.unitframes.player.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 6,
				type = "select",
				name = L["Frame Strata"],
				disabled = function() return not E.db.mui.unitframes.player.detachPortrait end,
				values = strataValues,
			},
		},
	}
end
tinsert(MER.Config, ufPlayerTable)

local function ufTargetTable()
	E.Options.args.unitframe.args.target.args.portrait.args.mui = {
		order = 10,
		type = "group",
		name = MER.Title,
		guiInline = true,
		get = function(info) return E.db.mui.unitframes.target[ info[#info] ] end,
		set = function(info, value) E.db.mui.unitframes.target[ info[#info] ] = value; MUF:ArrangeTarget(); end,
		hidden = function() return IsAddOnLoaded("ElvUI_BenikUI") end,
		args = {
			detachPortrait = {
				order = 1,
				type = "toggle",
				name = L["Detach Portrait"],
				set = function(info, value)
					E.db.mui.unitframes.target[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.target.args.portrait.args.width.min = 0
						E.db.unitframe.units.target.portrait.width = 0
						E.db.unitframe.units.target.orientation = "RIGHT"
					else
						E.Options.args.unitframe.args.target.args.portrait.args.width.min = 15
						E.db.unitframe.units.target.portrait.width = 45
					end
					UF:CreateAndUpdateUF("target")
				end,
				disabled = function() return E.db.unitframe.units.target.portrait.overlay end,
			},
			portraitTransparent = {
				order = 2,
				type = "toggle",
				name = L["Transparent"],
				desc = L["Makes the portrait backdrop transparent"],
				disabled = function() return E.db.unitframe.units.target.portrait.overlay end,
			},
			portraitShadow = {
				order = 3,
				type = "toggle",
				name = L["Shadow"],
				desc = L["Add shadow under the portrait"],
				disabled = function() return not E.db.mui.unitframes.target.detachPortrait end,
			},
			getPlayerPortraitSize = {
				order = 4,
				type = "toggle",
				name = L["Player Size"],
				desc = L["Copy Player portrait width and height"],
				disabled = function() return not E.db.mui.unitframes.target.detachPortrait end,
			},
			portraitWidth = {
				order = 5,
				type = "range",
				name = L["Width"],
				desc = L["Change the detached portrait width"],
				disabled = function() return E.db.mui.unitframes.target.getPlayerPortraitSize or not E.db.mui.unitframes.target.detachPortrait end,
				min = 10, max = 500, step = 1,
			},
			portraitHeight = {
				order = 6,
				type = "range",
				name = L["Height"],
				desc = L["Change the detached portrait height"],
				disabled = function() return E.db.mui.unitframes.target.getPlayerPortraitSize or not E.db.mui.unitframes.target.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 7,
				type = "select",
				name = L["Frame Strata"],
				disabled = function() return not E.db.mui.unitframes.target.detachPortrait end,
				values = strataValues,
			},
		},
	}
end
tinsert(MER.Config, ufTargetTable)