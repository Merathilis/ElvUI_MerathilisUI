local MER, E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variables
-- GLOBALS:

local function NameplatesTable()
	E.Options.args.mui.args.modules.args.nameplates = {
		type = "group",
		name = L["NamePlates"],
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
			castbarShield  = {
				order = 2,
				type = "toggle",
				name = L["Castbar Shield"],
				desc = L["Show a shield icon on the castbar for non interruptible spells."],
			},
			spacer1 = {
				order = 3,
				type = "description",
				name = " ",
				width = 'full',
			},
			enhancedAuras = {
				order = 10,
				type = "group",
				name = L["Enhanced NameplateAuras"],
				guiInline = true,
				get = function(info) return E.db.mui.nameplates.enhancedAuras[ info[#info] ] end,
				set = function(info, value) E.db.mui.nameplates.enhancedAuras[ info[#info] ] = value; E:StaticPopup_Show("GLOBAL_RL"); end,
				args = {
					credits = {
						order = 0,
						type = "description",
						fontSize = "medium",
						name = ("Credits: |cff1784d1ElvUI |r|cffff2020NihilistUI|r with |cffFF0000permission|r from NihilisticPandemonium"),
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
						name = L["|cffFF0000NOTE:|r This will overwrite the ElvUI Nameplate options for Buff/Debuffs width/height. The CC-Buffs are hardcoded to a size of: 32 x 32"],
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
