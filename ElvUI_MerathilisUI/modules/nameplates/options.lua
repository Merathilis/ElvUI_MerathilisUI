local MER, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')
local NP = E:GetModule("NamePlates")

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variables
-- GLOBALS:

local function NameplatesTable()
	E.Options.args.mui.args.modules.args.nameplates = {
		type = "group",
		name = E.NewSign..L["NamePlates"],
		order = 16,
		get = function(info) return E.db.mui.nameplates[ info[#info] ] end,
		set = function(info, value) E.db.mui.nameplates[ info[#info] ] = value; E:StaticPopup_Show("GLOBAL_RL"); end,
		args = {
			name = {
				order = 0,
				type = "header",
				name = MER:cOption(L["NamePlates"]),
			},
			spacer = {
				order = 1,
				type = "description",
				name = "",
			},
			castbarTarget = {
				order = 2,
				type = "toggle",
				name = L["Castbar Target"],
			},
			castbarShield  = {
				order = 3,
				type = "toggle",
				name = L["Castbar Shield"],
				desc = L["Show a shield icon on the castbar for non interruptible spells."],
			},
			spacer = {
				order = 4,
				type = "description",
				name = " ",
				width = 'full',
			},
			enhancedAuras = {
				order = 10,
				type = "group",
				name = E.NewSign..L["Enhanced NameplateAuras"],
				guiInline = true,
				get = function(info) return E.db.mui.nameplates.enhancedAuras[ info[#info] ] end,
				set = function(info, value) E.db.mui.nameplates.enhancedAuras[ info[#info] ] = value; E:StaticPopup_Show("GLOBAL_RL"); end,
				args = {
					credits = {
						order = 0,
						type = "description",
						fontSize = "medium",
						name = ("Credits: |cff1784d1ElvUI |r|cff8787edC|r|cff8091d4h|r|cff799bbca|r|cff71a5a3o|r|cff6ab08at|r|cff63ba71i|r|cff5cc459c|r|cff54ce40U|r|cff4dd827I|r with |cffFF0000permission|r from NihilisticPandemonium"),
					},
					spacer = {
						order = 1,
						type = "description",
						name = " ",
						width = 'full',
					},
					description = {
						order = 2,
						type = "description",
						fontSize = "medium",
						name = L["|cffFF0000NOTE:|r This will overwrite the ElvUI Nameplate options for Buff/Debuffs width/height. The CC-Buffs are hardcoded to a size of: 30 x 30"],
					},
					spacer1 = {
						order = 3,
						type = "description",
						name = " ",
						width = 'full',
					},
					enable = {
						order = 4,
						type = "toggle",
						name = L["Enable"],
					},
					width = {
						order = 5,
						type = "range",
						name = L["Width"],
						sliderElvUI = true,
						min = 6, max = 60, step = 1,
						get = function(info) return E.db.mui.nameplates.enhancedAuras.width end,
						set = function(info, value) E.db.mui.nameplates.enhancedAuras.width = value; NP:ConfigureAll() end,
					},
					height = {
						order = 6,
						type = "range",
						name = L["Height"],
						sliderElvUI = true,
						min = 6, max = 60, step = 1,
						get = function(info) return E.db.mui.nameplates.enhancedAuras.height end,
						set = function(info, value) E.db.mui.nameplates.enhancedAuras.height = value; NP:ConfigureAll() end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, NameplatesTable)
