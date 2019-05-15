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
		order = 16,
		get = function(info) return E.db.mui.nameplates[ info[#info] ] end,
		set = function(info, value) E.db.mui.nameplates[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
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
		},
	}
end
tinsert(MER.Config, NameplatesTable)
