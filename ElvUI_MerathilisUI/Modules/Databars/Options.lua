local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS:

local function databarsTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.databars = {
		type = "group",
		name = L["DataBars"],
		get = function(info) return E.db.mui.databars[ info[#info] ] end,
		set = function(info, value) E.db.mui.databars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = ACH:Header(MER:cOption(L["DataBars"], 'orange'), 1),
		},
	}
end
--tinsert(MER.Config, databarsTable)
