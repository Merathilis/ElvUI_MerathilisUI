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
						desc = OPTION_TOOLTIP_SHOW_LUA_ERRORS..L["\n\nDefault: |cffff00000|r"],
						set = function(info, value)
							E.db.mui.cvars.general[info[#info]] = value
							SetCVar("scriptErrors", (value == true and 1 or 0))
						end,
					},
					trackQuestSorting = {
						order = 4,
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
					autoLootDefault = {
						order = 5,
						type = "toggle",
						name = L["autoLootDefault"],
						desc = OPTION_TOOLTIP_AUTO_LOOT_DEFAULT..L["\n\nDefault: |cffff00000|r"],
						set = function(info, value)
							E.db.mui.cvars.general[info[#info]] = value
							SetCVar("autoLootDefault", (value == true and 1 or 0))
						end,
					},
					autoDismountFlying = {
						order = 6,
						type = "toggle",
						name = L["autoDismountFlying"],
						desc = OPTION_TOOLTIP_AUTO_DISMOUNT_FLYING..L["\n\nDefault: |cffff00000|r"],
						set = function(info, value)
							E.db.mui.cvars.general[info[#info]] = value
							SetCVar("autoDismountFlying", (value == true and 1 or 0))
						end,
					},
					removeChatDelay = {
						order = 7,
						type = "toggle",
						name = L["removeChatDelay"],
						desc = REMOVE_CHAT_DELAY_TEXT..L["\n\nDefault: |cffff00000|r"],
						set = function(info, value)
							E.db.mui.cvars.general[info[#info]] = value
							SetCVar("removeChatDelay", (value == true and 1 or 0))
						end,
					},
					screenshotQuality = {
						order = 8,
						type = "range",
						min = 1, max = 10, step = 1,
						name = L["screenshotQuality"],
						desc = L["screenshotQuality_DESC"],
						set = function(info, value)
							E.db.mui.cvars.general[info[#info]] = value
							SetCVar("screenshotQuality", value)
						end,
					},
					showTutorials = {
						order = 9,
						type = "toggle",
						name = L["showTutorials"],
						desc = OPTION_TOOLTIP_SHOW_TUTORIALS..L["\n\nDefault: |cff00ff001|r"],
						set = function(info, value)
							E.db.mui.cvars.general[info[#info]] = value
							SetCVar("showTutorials", (value == true and 1 or 0))
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
								desc = OPTION_TOOLTIP_SHOW_DAMAGE..L["\n\nDefault: |cff00ff001|r"],
								set = function(info, value)
									E.db.mui.cvars.combatText.targetCombatText[info[#info]] = value
									SetCVar("floatingCombatTextCombatDamage", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextCombatLogPeriodicSpells = {
								order = 2,
								type = "toggle",
								name = L["floatingCombatTextCombatLogPeriodicSpells"],
								desc = OPTION_TOOLTIP_LOG_PERIODIC_EFFECTS..L["\n\nDefault: |cff00ff001|r"],
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
								desc = OPTION_TOOLTIP_PET_SPELL_DAMAGE..L["\n\nDefault: |cff00ff001|r"],
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
								desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING..L["\n\nDefault: |cff00ff001|r"],
								set = function(info, value)
									E.db.mui.cvars.combatText.targetCombatText[info[#info]] = value
									SetCVar("floatingCombatTextCombatHealing", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextCombatHealingAbsorbTarget = {
								order = 6,
								type = "toggle",
								name = L["floatingCombatTextCombatHealingAbsorbTarget"],
								desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING_ABSORB_TARGET..L["\n\nDefault: |cff00ff001|r"],
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
								desc = OPTION_TOOLTIP_SHOW_TARGET_EFFECTS..L["\n\nDefault: |cffff00000|r"],
								set = function(info, value)
									E.db.mui.cvars.combatText.targetCombatText[info[#info]] = value
									SetCVar("floatingCombatTextSpellMechanics", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextSpellMechanicsOther = {
								order = 8,
								type = "toggle",
								name = L["floatingCombatTextSpellMechanicsOther"],
								desc = OPTION_TOOLTIP_SHOW_OTHER_TARGET_EFFECTS..L["\n\nDefault: |cffff00000|r"],
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
								desc = OPTION_TOOLTIP_SHOW_COMBAT_TEXT..L["\n\nDefault: |cffff00000|r"],
								set = function(info, value)
									E.db.mui.cvars.combatText.playerCombatText[info[#info]] = value
									SetCVar("enableFloatingCombatText", (value == true and 1 or 0))
								end,
							},
							floatingCombatTextFloatMode = {
								order = 2,
								type = "select",
								name = L["floatingCombatTextFloatMode"],
								desc = OPTION_TOOLTIP_COMBAT_TEXT_MODE..L["\n\nDefault: |cff00ff001|r"],
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
								desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_DODGE_PARRY_MISS..L["\n\nDefault: |cffff00000|r"],
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
								desc = OPTION_TOOLTIP_SHOW_COMBAT_HEALING_ABSORB_SELF..L["\n\nDefault: |cff00ff001|r"],
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
								desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_RESISTANCES..L["\n\nDefault: |cffff00000|r"],
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
								desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_LOW_HEALTH_MANA..L["\n\nDefault: |cff00ff001|r"],
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
								desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_REPUTATION..L["\n\nDefault: |cffff00000|r"],
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
								desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_ENERGIZE..L["\n\nDefault: |cffff00000|r"],
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
								desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBO_POINTS..L["\n\nDefault: |cffff00000|r"],
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
								desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_REACTIVES..L["\n\nDefault: |cff00ff001|r"],
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
								desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE..L["\n\nDefault: |cffff00000|r"],
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
								desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_FRIENDLY_NAMES..L["\n\nDefault: |cffff00000|r"],
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
								desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_HONOR_GAINED..L["\n\nDefault: |cffff00000|r"],
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
								desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_COMBAT_STATE..L["\n\nDefault: |cffff00000|r"],
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
								desc = OPTION_TOOLTIP_COMBAT_TEXT_SHOW_AURAS..L["\n\nDefault: |cffff00000|r"],
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
