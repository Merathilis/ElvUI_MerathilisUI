local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");
local MERCO = E:GetModule("mUICooldowns");
local CF = E:GetModule("CooldownFlash");

local function CooldownFlash()
	E.Options.args.mui.args.cooldownFlash = {
		type = "group",
		name = (MERCO.modName or MERCO:GetName())..MER.NewSign,
		order = 20,
		get = function(info) return E.db.mui.cooldownFlash[ info[#info] ] end,
		set = function(info, value) E.db.mui.cooldownFlash[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			header1 = {
				type = "header",
				name = MER:cOption(CF.modName or CF:GetName()),
				order = 1
			},
			credits = {
				order = 2,
				type = "group",
				name = MER:cOption(L["Credits"]),
				guiInline = true,
				args = {
					tukui = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = "Doom_CooldownPulse - by Woffle of Dark Iron[US]",
					},
				},
			},
			toggle = {
				order = 3,
				type = "toggle",
				name = CF.toggleLabel or (L["Enable"]),
				desc = CF.modName or CF:GetName(),
				get = function() return E.db.mui.cooldownFlash.enable ~= false or false end,
				set = function(info, v) CF.db.enable = v if v then CF:EnableCooldownFlash() else CF:DisableCooldownFlash() end end,
			},
			iconSize = {
				order = 4,
				name = L["Icon Size"],
				type = "range",
				min = 30, max = 125, step = 1,
				set = function(info, value) E.db.mui.cooldownFlash[ info[#info] ] = value; CF.DCP:SetSize(value, value) end,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			fadeInTime = {
				order = 5,
				name = L["Fadein duration"],
				type = "range",
				min = 0, max = 2.5, step = 0.1,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			fadeOutTime = {
				order = 6,
				name = L["Fadeout duration"],
				type = "range",
				min = 0, max = 2.5, step = 0.1,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			maxAlpha = {
				order = 7,
				name = L["Transparency"],
				type = "range",
				min = 0, max = 1, step = 0.05,
				isPercent = true,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			holdTime = {
				order = 8,
				name = L["Duration time"],
				type = "range",
				min = 0, max = 2.5, step = 0.1,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			animScale = {
				order = 9,
				name = L["Animation size"],
				type = "range",
				min = 0, max = 2, step = 0.1,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			showSpellName = {
				order = 10,
				name = L["Display spell name"],
				type = "toggle",
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			enablePet = {
				order = 11,
				name = L["Watch on pet spell"],
				type = "toggle",
				get = function(info) return E.db.mui.cooldownFlash[ info[#info] ] end,
				set = function(info, value) E.db.mui.cooldownFlash[ info[#info] ] = value; if value then CF.DCP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") else CF.DCP:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end end,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			test = {
				order = 12,
				name = L["Test"],
				type = "execute",
				func = function() CF:TestMode() end,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			header2 = {
				type = "header",
				name = MER:cOption(MERCO.modName or MERCO:GetName()),
				order = 13,
			},
			cooldowns = {
				order = 14,
				type = "group",
				name = MER:cOption(MERCO.modName or MERCO:GetName())..MER.NewSign,
				guiInline = true,
				get = function(info) return E.db.mui.misc.cooldowns[ info[#info] ] end,
				set = function(info, value) E.db.mui.misc.cooldowns[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					spacer = {
						type = "description",
						name = "",
						desc = "",
						order = 2,
					},
					showpets = {
						order = 3,
						type = "toggle",
						name = L["Show pet cooldown"],
						hidden = function() return not E.db.mui.misc.cooldowns.enable end,
					},
					showequip = {
						order = 4,
						type = "toggle",
						name = L["Show equipment cooldown"],
						hidden = function() return not E.db.mui.misc.cooldowns.enable end,
					},
					showbags = {
						order = 5,
						type = "toggle",
						name = L["Show item cooldown"],
						hidden = function() return not E.db.mui.misc.cooldowns.enable end,
					},
					size = {
						order = 6,
						type = "range",
						name = L["Size"],
						min = 24, max = 60, step = 1,
						hidden = function() return not E.db.mui.misc.cooldowns.enable end,
					},
					growthx = {
						order = 7,
						type = "select",
						name = L["Growth-x"],
						values = {
							["LEFT"] = L["Left"],
							["RIGHT"] = L["Right"],
						},
						hidden = function() return not E.db.mui.misc.cooldowns.enable end,
					},
					growthy = {
						order = 8,
						type = "select",
						name = L["Growth-y"],
						values = {
							["UP"] = L["Up"],
							["DOWN"] = L["Down"],
						},
						hidden = function() return not E.db.mui.misc.cooldowns.enable end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, CooldownFlash)