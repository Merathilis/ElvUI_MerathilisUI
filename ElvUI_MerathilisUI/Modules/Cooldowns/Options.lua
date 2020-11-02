local MER, E, L, V, P, G = unpack(select(2, ...))
local CF = MER:GetModule('MER_Cooldown')

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variables
-- GLOBALS:

local function Cooldowns()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.cooldowns = {
		type = "group",
		name = L["Cooldowns"],
		args = {
			cooldownFlash = {
				order = 1,
				type = "group",
				name = " ",
				guiInline = true,
				get = function(info) return E.db.mui.cooldownFlash[ info[#info] ] end,
				set = function(info, value) E.db.mui.cooldownFlash[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					header = ACH:Header(MER:cOption(L["Cooldown Flash"], 'orange'), 1),
					credits = {
						order = 2,
						type = "group",
						name = MER:cOption(L["Credits"], 'orange'),
						guiInline = true,
						args = {
							tukui = ACH:Description("Doom_CooldownPulse - by Woffle of Dark Iron[US]"),
						},
					},
					toggle = {
						order = 3,
						type = "toggle",
						name = L["Enable"],
						desc = CF.modName,
						get = function() return E.db.mui.cooldownFlash.enable ~= false or false end,
						set = function(info, v) E.db.mui.cooldownFlash.enable = v if v then CF:EnableCooldownFlash() else CF:DisableCooldownFlash() end end,
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
						min = 0.5, max = 2.5, step = 0.1,
						hidden = function() return not E.db.mui.cooldownFlash.enable end,
					},
					fadeOutTime = {
						order = 6,
						name = L["Fadeout duration"],
						type = "range",
						min = 0.5, max = 2.5, step = 0.1,
						hidden = function() return not E.db.mui.cooldownFlash.enable end,
					},
					maxAlpha = {
						order = 7,
						name = L["Transparency"],
						type = "range",
						min = 0.25, max = 1, step = 0.05,
						isPercent = true,
						hidden = function() return not E.db.mui.cooldownFlash.enable end,
					},
					holdTime = {
						order = 8,
						name = L["Duration time"],
						type = "range",
						min = 0.3, max = 2.5, step = 0.1,
						hidden = function() return not E.db.mui.cooldownFlash.enable end,
					},
					animScale = {
						order = 9,
						name = L["Animation size"],
						type = "range",
						min = 0.5, max = 2, step = 0.1,
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
				},
			},
		},
	}
end
tinsert(MER.Config, Cooldowns)
