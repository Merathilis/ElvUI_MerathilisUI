local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variables
local SetCVar = SetCVar
-- GLOBALS:

local function CVars()
	E.Options.args.mui.args.modules.args.cvars = {
		type = "group",
		name = E.NewSign..L["CVars"],
		args = {
			header = {
				order = 1,
				type = "header",
				name = MER:cOption(L["CVars"]),
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				get = function(info)
					return E.db.mui.cvars.general[info[#info]]
				end,
				args = {
					alwaysCompareItems = {
						order = 1,
						type = "toggle",
						name = L["alwaysCompareItems"],
						desc = L["alwaysCompareItems_DESC"],
						set = function(info, value)
							E.db.mui.cvars.general[info[#info]] = value
							SetCVar("alwaysCompareItems", (value == true and 1 or 0))
						end,
					},
					breakUpLargeNumbers = {
						order = 2,
						type = "toggle",
						name = L["breakUpLargeNumbers"],
						desc = L["breakUpLargeNumbers_DESC"],
						set = function(info, value)
							E.db.mui.cvars.general[info[#info]] = value
							SetCVar("breakUpLargeNumbers", (value == true and 1 or 0))
						end,
					},
					scriptErrors = {
						order = 3,
						type = "toggle",
						name = L["scriptErrors"],
						desc = L["scriptErrors_DESC"],
						set = function(info, value)
							E.db.mui.cvars.general[info[#info]] = value
							SetCVar("scriptErrors", (value == true and 1 or 0))
						end,
					},
					enableWoWMouse = {
						order = 4,
						type = "toggle",
						name = L["enableWoWMouse"],
						desc = L["enableWoWMouse_DESC"],
						set = function(info, value)
							E.db.mui.cvars.general[info[#info]] = value
							SetCVar("enableWoWMouse", (value == true and 1 or 0))
						end,
					},
					rawMouseEnable = {
						order = 5,
						type = "toggle",
						name = L["rawMouseEnable"],
						desc = L["rawMouseEnable_DESC"],
						set = function(info, value)
							E.db.mui.cvars.general[info[#info]] = value
							SetCVar("rawMouseEnable", (value == true and 1 or 0))
						end,
					},
					trackQuestSorting = {
						order = 6,
						type = "select",
						name = L["trackQuestSorting"],
						desc = L["trackQuestSorting_DESC"],
						values = {
							["top"] = L["TOP"],
							["proximity"] = L["proximity"],
						},
						set = function(info, value)
							E.db.mui.cvars.general[info[#info]] = value
							SetCVar("trackQuestSorting", value)
						end,
					},
				},
			},
			combatText = {
				order = 3,
				type = "group",
				name = L["Combat Text"],
				get = function(info)
					return E.db.mui.cvars.combatText[info[#info]]
				end,
				args = {
					worldTextScale = {
						order = 1,
						type = "range",
						min = 0.5, max = 2.5, step = 0.1,
						name = L["World Text Scale"],
						desc = L["WorldTextScale_DESC"],
						set = function(info, value)
							E.db.mui.cvars.combatText[info[#info]] = value
							SetCVar("WorldTextScale", value)
						end,
					},
					targetCombatText = {
						order = 2,
						type = "group",
						guiInline = true,
						name = L["Target Combat Text"],
						get = function(info)
							return E.db.mui.cvars.combatText.targetCombatText[info[#info]]
						end,
						args = {
							floatingCombatTextCombatDamage = {
								order = 1,
								type = "toggle",
								name = L["floatingCombatTextCombatDamage"],
								desc = L["floatingCombatTextCombatDamage_DESC"],
								set = function(info, value)
									E.db.mui.cvars.combatText.targetCombatText[info[#info]] = value
									SetCVar("floatingCombatTextCombatDamage", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextCombatLogPeriodicSpells = {
								order = 2,
								type = "toggle",
								name = L["floatingCombatTextCombatLogPeriodicSpells"],
								desc = L["floatingCombatTextCombatLogPeriodicSpells_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.targetCombatText["floatingCombatTextCombatDamage"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.targetCombatText[info[#info]] = value
									SetCVar("floatingCombatTextCombatLogPeriodicSpells", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextPetMeleeDamage = {
								order = 3,
								type = "toggle",
								name = L["floatingCombatTextPetMeleeDamage"],
								desc = L["floatingCombatTextPetMeleeDamage_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.targetCombatText["floatingCombatTextCombatDamage"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.targetCombatText[info[#info]] = value
									SetCVar("floatingCombatTextPetMeleeDamage", (value == true and 1 or 0))
									SetCVar("floatingCombatTextPetSpellDamage", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextCombatDamageDirectionalScale = {
								order = 4,
								type = "range",
								min = 1, max = 5, step = 1,
								name = L["floatingCombatTextCombatDamageDirectionalScale"],
								desc = L["floatingCombatTextCombatDamageDirectionalScale_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.targetCombatText["floatingCombatTextCombatDamage"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.targetCombatText[info[#info]] = value
									SetCVar("floatingCombatTextCombatDamageDirectionalScale", value)
								end,
							},
							floatingCombatTextCombatHealing = {
								order = 5,
								type = "toggle",
								name = L["floatingCombatTextCombatHealing"],
								desc = L["floatingCombatTextCombatHealing_DESC"],
								set = function(info, value)
									E.db.mui.cvars.combatText.targetCombatText[info[#info]] = value
									SetCVar("floatingCombatTextCombatHealing", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextCombatHealingAbsorbTarget = {
								order = 6,
								type = "toggle",
								name = L["floatingCombatTextCombatHealingAbsorbTarget"],
								desc = L["floatingCombatTextCombatHealingAbsorbTarget_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.targetCombatText["floatingCombatTextCombatHealing"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.targetCombatText[info[#info]] = value
									SetCVar("floatingCombatTextCombatHealingAbsorbTarget", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextSpellMechanics = {
								order = 7,
								type = "toggle",
								name = L["floatingCombatTextSpellMechanics"],
								desc = L["floatingCombatTextSpellMechanics_DESC"],
								set = function(info, value)
									E.db.mui.cvars.combatText.targetCombatText[info[#info]] = value
									SetCVar("floatingCombatTextSpellMechanics", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextSpellMechanicsOther = {
								order = 8,
								type = "toggle",
								name = L["floatingCombatTextSpellMechanicsOther"],
								desc = L["floatingCombatTextSpellMechanicsOther_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.targetCombatText["floatingCombatTextSpellMechanics"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.targetCombatText[info[#info]] = value
									SetCVar("floatingCombatTextSpellMechanicsOther", (value == true and 1 or 0))
								end,
							},
						}
					},
					playerCombatText = {
						order = 3,
						type = "group",
						guiInline = true,
						name = L["Player Combat Text"],
						get = function(info)
							return E.db.mui.cvars.combatText.playerCombatText[info[#info]]
						end,
						set = function(info, value)
							E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
						end,
						args = {
							enableFloatingCombatText = {
								order = 1,
								type = "toggle",
								name = L["enableFloatingCombatText"],
								desc = L["enableFloatingCombatText_DESC"],
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("enableFloatingCombatText", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextFloatMode = {
								order = 2,
								type = "select",
								name = L["floatingCombatTextFloatMode"],
								desc = L["floatingCombatTextFloatMode_DESC"],
								values = {
									[1] = L["FloatModeUp"],
									[2] = L["FloatModeDown"],
									[3] = L["FloatModeARC"],
								},
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextFloatMode", value)
								end,
							},
							floatingCombatTextDodgeParryMiss = {
								order = 3,
								type = "toggle",
								name = L["floatingCombatTextDodgeParryMiss"],
								desc = L["floatingCombatTextDodgeParryMiss_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextDodgeParryMiss", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextCombatHealingAbsorbSelf = {
								order = 4,
								type = "toggle",
								name = L["floatingCombatTextCombatHealingAbsorbSelf"],
								desc = L["floatingCombatTextCombatHealingAbsorbSelf_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextCombatHealingAbsorbSelf", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextDamageReduction = {
								order = 5,
								type = "toggle",
								name = L["floatingCombatTextDamageReduction"],
								desc = L["floatingCombatTextDamageReduction_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextDamageReduction", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextLowManaHealth = {
								order = 6,
								type = "toggle",
								name = L["floatingCombatTextLowManaHealth"],
								desc = L["floatingCombatTextLowManaHealth_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextLowManaHealth", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextRepChanges = {
								order = 7,
								type = "toggle",
								name = L["floatingCombatTextRepChanges"],
								desc = L["floatingCombatTextRepChanges_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextRepChanges", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextEnergyGains = {
								order = 8,
								type = "toggle",
								name = L["floatingCombatTextEnergyGains"],
								desc = L["floatingCombatTextEnergyGains_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextEnergyGains", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextComboPoints = {
								order = 9,
								type = "toggle",
								name = L["floatingCombatTextComboPoints"],
								desc = L["floatingCombatTextComboPoints_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextComboPoints", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextReactives = {
								order = 10,
								type = "toggle",
								name = L["floatingCombatTextReactives"],
								desc = L["floatingCombatTextReactives_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextReactives", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextPeriodicEnergyGains = {
								order = 11,
								type = "toggle",
								name = L["floatingCombatTextPeriodicEnergyGains"],
								desc = L["floatingCombatTextPeriodicEnergyGains_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextPeriodicEnergyGains", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextFriendlyHealers = {
								order = 12,
								type = "toggle",
								name = L["floatingCombatTextFriendlyHealers"],
								desc = L["floatingCombatTextFriendlyHealers_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextFriendlyHealers", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextHonorGains = {
								order = 13,
								type = "toggle",
								name = L["floatingCombatTextHonorGains"],
								desc = L["floatingCombatTextHonorGains_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextHonorGains", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextCombatState = {
								order = 14,
								type = "toggle",
								name = L["floatingCombatTextCombatState"],
								desc = L["floatingCombatTextCombatState_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.lui.modules.cvar.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextCombatState", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextAuras = {
								order = 15,
								type = "toggle",
								name = L["floatingCombatTextAuras"],
								desc = L["floatingCombatTextAuras_DESC"],
								disabled = function(info)
									return not E.db.mui.cvars.combatText.playerCombatText["enableFloatingCombatText"]
								end,
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("floatingCombatTextAuras", (value == true and 1 or 0))
								end,
							},
						},
					},
				}
			},
		},
	}
end
tinsert(MER.Config, CVars)
