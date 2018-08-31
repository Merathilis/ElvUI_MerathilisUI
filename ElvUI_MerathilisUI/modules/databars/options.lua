local MER, E, L, V, P, G = unpack(select(2, ...))
local MDB = MER:GetModule("mUI_databars")

--Cache global variables

--WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: 

local function databarsTable()
	E.Options.args.mui.args.modules.args.databars = {
		order = 15,
		type = "group",
		name = MDB.modName,
		disabled = function() return IsAddOnLoaded("ElvUI_BenikUI") end,
		hidden = function() return IsAddOnLoaded("ElvUI_BenikUI") end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(MDB.modName),
			},
			enable = {
				order = 2,
				type = "toggle",
				name = L["Style DataBars"],
				desc = L["Add some stylish buttons at the bottom of the DataBars"],
				get = function(info) return E.db.mui.databars.enable end,
				set = function(info, value) E.db.mui.databars.enable = value, E:StaticPopup_Show("PRIVATE_RL"); end,
			},
		},
	}
end
-- tinsert(MER.Config, databarsTable)