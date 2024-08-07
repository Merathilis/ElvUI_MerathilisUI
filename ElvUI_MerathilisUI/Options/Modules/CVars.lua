local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args

local GetCVarBool = C_CVar.GetCVarBool
local SetCVar = C_CVar.SetCVar

options.cvars = {
	type = "group",
	name = L["CVars"],
	get = function(info)
		return GetCVarBool(info[#info])
	end,
	set = function(info, value)
		SetCVar(info[#info], value and "1" or "0")
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["CVars"], "orange"),
		},
		desc = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = format(
						"%s |cffff3860%s|r %s",
						L["A simple editor for CVars."],
						format(L["%s never lock the CVars."], MER.Title),
						L["If you found the CVars changed automatically, please check other addons."]
					),
					fontSize = "medium",
				},
			},
		},
		combat = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Combat"],
			args = {
				floatingCombatTextCombatDamage = {
					order = 1,
					type = "toggle",
					name = L["Floating Damage Text"],
				},
				floatingCombatTextCombatHealing = {
					order = 2,
					type = "toggle",
					name = L["Floating Healing Text"],
				},
				WorldTextScale = {
					order = 3,
					type = "range",
					name = L["Floating Text Scale"],
					get = function(info)
						return tonumber(GetCVar(info[#info]))
					end,
					set = function(info, value)
						return SetCVar(info[#info], value)
					end,
					min = 0.1,
					max = 5,
					step = 0.1,
				},
				SpellQueueWindow = {
					order = 4,
					type = "range",
					name = L["Spell Queue Window"],
					get = function(info)
						return tonumber(GetCVar(info[#info]))
					end,
					set = function(info, value)
						return SetCVar(info[#info], value)
					end,
					min = 0,
					max = 400,
					step = 1,
				},
			},
		},
		visualEffect = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Visual Effect"],
			args = {
				ffxGlow = {
					order = 1,
					type = "toggle",
					name = L["Glow Effect"],
				},
				ffxDeath = {
					order = 2,
					type = "toggle",
					name = L["Death Effect"],
				},
				ffxNether = {
					order = 3,
					type = "toggle",
					name = L["Nether Effect"],
				},
			},
		},
		mouse = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Mouse"],
			args = {
				rawMouseEnable = {
					order = 1,
					type = "toggle",
					name = L["Raw Mouse"],
					desc = L["It will fix the problem if your cursor has abnormal movement."],
				},
				rawMouseAccelerationEnable = {
					order = 2,
					type = "toggle",
					name = L["Raw Mouse Acceleration"],
					desc = L["Changes the rate at which your mouse pointer moves based on the speed you are moving the mouse."],
				},
			},
		},
		nameplate = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Nameplate"],
			args = {
				tip = {
					order = 1,
					type = "description",
					name = format(
						"%s\n|cff209cee-|r %s |cff00d1b2%s|r\n|cff209cee-|r %s |cff00d1b2%s|r\n|cff209cee-|r %s |cffff3860%s|r",
						L["To enable the name of friendly player in instances, you can set as following:"],
						L["Friendly Player Name"],
						L["On"],
						L["Nameplate Only Names"],
						L["On"],
						L["Debuff on Friendly Nameplates"],
						L["Off"]
					),
				},
				UnitNameFriendlyPlayerName = {
					order = 2,
					type = "toggle",
					width = 1.5,
					name = L["Friendly Player Name"],
					desc = L["Show friendly players' names in the game world."],
				},
				nameplateShowOnlyNames = {
					order = 3,
					type = "toggle",
					width = 1.5,
					name = L["Nameplate Only Names"],
					desc = L["Disable the health bar of nameplate."],
				},
				nameplateShowDebuffsOnFriendly = {
					order = 4,
					type = "toggle",
					width = 1.5,
					name = L["Debuff on Friendly Nameplates"],
				},
				nameplateMotion = {
					order = 5,
					type = "toggle",
					width = 1.5,
					name = L["Stack Nameplates"],
				},
			},
		},
		misc = {
			order = 6,
			type = "group",
			inline = true,
			name = L["Misc"],
			args = {
				alwaysCompareItems = {
					order = 1,
					type = "toggle",
					name = L["Auto Compare"],
					width = 1.5,
				},
				autoOpenLootHistory = {
					order = 2,
					type = "toggle",
					name = L["Auto Open Loot History"],
					width = 1.5,
				},
			},
		},
	},
}
