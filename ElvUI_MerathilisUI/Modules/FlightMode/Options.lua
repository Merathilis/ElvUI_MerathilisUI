local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_FlightMode')
local COMP = MER:GetModule('MER_Compatibility')

local format = string.format
local tinsert = table.insert

local function FlightMode()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.cvars = {
		type = "group",
		name = L["FlightMode"],
		get = function(info) return E.db.mui.flightMode[ info[#info] ] end,
		set = function(info, value) E.db.mui.flightMode[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			header = ACH:Header(MER:cOption(L["FlightMode"], 'orange'), 1),
			credits = {
				order = 2,
				type = "group",
				name = MER:cOption(L["Credits"], 'orange'),
				guiInline = true,
				disabled = function() return (COMP.BUI and E.db.benikui.misc.flightMode.enable) end,
				args = {
					tukui = ACH:Description(format("|cff00c0faBenikUI|r"), 1),
				},
			},
			enable = {
				order = 3,
				type = "toggle",
				name = L["Enable"],
			},
			BenikFlightMode = {
				order = 4,
				type = "toggle",
				name = L["|cff00c0faBenikUI|r FlightMode"],
				desc = L["Enhance the |cff00c0faBenikUI|r FlightMode.\nTo completely disable the FlightMode go into the |cff00c0faBenikUI|r Options."],
				hidden = function() return not IsAddOnLoaded("ElvUI_BenikUI") end,
			},
		},
	}
end
tinsert(MER.Config, FlightMode)
