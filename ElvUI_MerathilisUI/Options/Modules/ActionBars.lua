local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local AB = MER:GetModule("MER_Actionbars")
	local CM = MER:GetModule("MER_ColorModifiers") ---@type ColorModifiers
	local options = module.options.modules.args

	local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut

	local function AssistedRotationDisabled()
		return not MER:HasRequirements(I.Requirements.ActionBars)
			or not C_ActionBar.IsAssistedCombatAction
			or not E.db.mui.actionbars.assistedRotation.enable
	end

	options.actionbars = {
		type = "group",
		name = module:AddCategorieIcon(L["ActionBars"], "actionbars"),
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["ActionBars"],
			},
			specBar = {
				order = 3,
				type = "group",
				name = L["Specialization Bar"],
				guiInline = true,
				disabled = module.RequirementsDisabled(I.Requirements.ActionBars),
				get = function(info)
					return E.db.mui.actionbars.specBar[info[#info]]
				end,
				set = function(info, value)
					local key = info[#info]
					E.db.mui.actionbars.specBar[key] = value

					-- Mouseover is read live, the rest builds the bar
					local bar = AB.specBar
					if key == "mouseover" and bar then
						if value then
							UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), 0)
						else
							UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), 1)
						end
					else
						E:StaticPopup_Show("CONFIG_RL")
					end
				end,
				args = {
					requirements = module.RequirementsNotice(I.Requirements.ActionBars),
					enable = module.ToggleCard({
						order = 1,
						name = L["Enable"],
						desc = L["The Specialization Bar switches your spec with a left click and your loot spec with a right click."],
						image = I.Media.Icons.Categories.actionbars,
					}),
					preview = module.PreviewOption(1.5, "MERSpecBarPreview", "specBar"),
					mouseover = {
						order = 2,
						type = "toggle",
						name = L["Mouseover"],
						disabled = function()
							return not MER:HasRequirements(I.Requirements.ActionBars)
								or not E.db.mui.actionbars.specBar.enable
						end,
					},
					size = {
						order = 3,
						type = "range",
						name = L["Button Size"],
						min = 20,
						max = 60,
						step = 1,
						disabled = function()
							return not MER:HasRequirements(I.Requirements.ActionBars)
								or not E.db.mui.actionbars.specBar.enable
						end,
					},
					frameStrata = {
						order = 4,
						type = "select",
						name = L["Frame Strata"],
						disabled = function()
							return not MER:HasRequirements(I.Requirements.ActionBars)
								or not E.db.mui.actionbars.specBar.enable
						end,
						values = {
							BACKGROUND = L["BACKGROUND"],
							LOW = L["LOW"],
							MEDIUM = L["MEDIUM"],
							HIGH = L["HIGH"],
						},
					},
					frameLevel = {
						order = 5,
						type = "range",
						name = L["Frame Level"],
						min = 1,
						max = 256,
						step = 1,
						disabled = function()
							return not MER:HasRequirements(I.Requirements.ActionBars)
								or not E.db.mui.actionbars.specBar.enable
						end,
					},
				},
			},
			assistedRotation = {
				order = 4,
				type = "group",
				-- Blizzard's localized name, the spell only exists for specs that have it
				name = function()
					local spellID = C_AssistedCombat and C_AssistedCombat.GetActionSpell()
					return spellID and C_Spell.GetSpellName(spellID) or L["Single-Button Assistant"]
				end,
				guiInline = true,
				disabled = function()
					return not MER:HasRequirements(I.Requirements.ActionBars) or not C_ActionBar.IsAssistedCombatAction
				end,
				get = function(info)
					return E.db.mui.actionbars.assistedRotation[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.actionbars.assistedRotation[info[#info]] = value
					AB:AssistedRotation_Refresh()
				end,
				args = {
					requirements = module.RequirementsNotice(I.Requirements.ActionBars),
					enable = module.ToggleCard({
						order = 1,
						name = L["Enable"],
						desc = L["Brings back Blizzard's rotation frame around its action button, which ElvUI's action bars leave out."],
						image = I.Media.Icons.Categories.actionbars,
					}),
					preview = {
						order = 1.5,
						type = "description",
						dialogControl = "MERAssistedRotationPreview",
						name = " ",
						width = "full",
					},
					animation = {
						order = 2,
						type = "toggle",
						name = L["Combat Animation"],
						desc = L["Spins a glow around the frame while you are in combat."],
						disabled = AssistedRotationDisabled,
					},
					colorMode = {
						order = 3,
						type = "select",
						name = L["Color"],
						disabled = AssistedRotationDisabled,
						values = {
							DEFAULT = L["Default"],
							CLASS = L["Class Color"],
							CUSTOM = L["Custom Color"],
						},
					},
					customColor = {
						order = 4,
						type = "color",
						name = L["Custom Color"],
						hasAlpha = false,
						disabled = AssistedRotationDisabled,
						hidden = function()
							return E.db.mui.actionbars.assistedRotation.colorMode ~= "CUSTOM"
						end,
						get = function(info)
							local db = E.db.mui.actionbars.assistedRotation[info[#info]]
							local default = P.actionbars.assistedRotation[info[#info]]
							return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
						end,
						set = function(info, r, g, b)
							local db = E.db.mui.actionbars.assistedRotation[info[#info]]
							db.r, db.g, db.b = r, g, b
							AB:AssistedRotation_Refresh()
						end,
					},
				},
			},
			colorModifiers = {
				order = 5,
				type = "group",
				name = L["Color Modifier Keys"],
				desc = L["Enabling this colors your modifier keys."],
				guiInline = true,
				get = function(info)
					return E.db.mui.colorModifiers[info[#info]]
				end,
				set = function(info, value)
					E.db.mui.colorModifiers[info[#info]] = value
					CM:DatabaseUpdate()
				end,
				disabled = module.RequirementsDisabled(I.Requirements.ActionBars),
				args = {
					requirements = module.RequirementsNotice(I.Requirements.ActionBars),
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Credits: ElvUI_ToxiUI"],
						width = "full",
					},
				},
			},
		},
	}
end)
