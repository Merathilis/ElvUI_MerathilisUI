local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");
local CF = E:GetModule("CooldownFlash");

local function CooldownFlash()
	E.Options.args.mui.args.cooldownFlash = {
		type = "group",
		name = (CF.modName or CF:GetName()),
		order = 20,
		get = function(info) return E.db.mui.cooldownFlash[ info[#info] ] end,
		set = function(info, value) E.db.mui.cooldownFlash[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			header = {
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
				type = "toggle",
				name = CF.toggleLabel or (L["Enable"]),
				width = "double",
				desc = CF.modName or CF:GetName(),
				order = 3,
				get = function() return E.db.mui.cooldownFlash.enable ~= false or false end,
				set = function(info, v) CF.db.enable = v if v then CF:EnableCooldownFlash() else CF:DisableCooldownFlash() end end,
			},
			settingsHeader = {
				type = "header",
				name = L["Settings"],
				order = 4,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			iconSize = {
				order = 5,
				name = L["Icon Size"],
				type = "range",
				min = 30, max = 125, step = 1,
				set = function(info, value) E.db.mui.cooldownFlash[ info[#info] ] = value; CF.DCP:SetSize(value, value) end,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			fadeInTime = {
				order = 6,
				name = L["Fadein duration"],
				type = "range",
				min = 0, max = 2.5, step = 0.1,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			fadeOutTime = {
				order = 7,
				name = L["Fadeout duration"],
				type = "range",
				min = 0, max = 2.5, step = 0.1,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			maxAlpha = {
				order = 8,
				name = L["Transparency"],
				type = "range",
				min = 0, max = 1, step = 0.05,
				isPercent = true,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			holdTime = {
				order = 9,
				name = L["Duration time"],
				type = "range",
				min = 0, max = 2.5, step = 0.1,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			animScale = {
				order = 10,
				name = L["Animation size"],
				type = "range",
				min = 0, max = 2, step = 0.1,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			showSpellName = {
				order = 11,
				name = L["Display spell name"],
				type = "toggle",
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			enablePet = {
				order = 12,
				name = L["Watch on pet spell"],
				type = "toggle",
				get = function(info) return E.db.mui.cooldownFlash[ info[#info] ] end,
				set = function(info, value) E.db.mui.cooldownFlash[ info[#info] ] = value; if value then CF.DCP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") else CF.DCP:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end end,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			},
			test = {
				order = 13,
				name = L["Test"],
				type = "execute",
				func = function() CF:TestMode() end,
				hidden = function() return not E.db.mui.cooldownFlash.enable end,
			}
		},
	}
end
tinsert(MER.Config, CooldownFlash)