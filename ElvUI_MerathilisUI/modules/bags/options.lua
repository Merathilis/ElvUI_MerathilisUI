local MER, E, L, V, P, G = unpack(select(2, ...))
local MERB = MER:GetModule("mUIBags")

--Cache global variables

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function BagTable()
	E.Options.args.mui.args.modules.args.bags = {
		type = "group",
		name = MERB.modName,
		order = 19,
		get = function(info) return E.db.mui.bags[ info[#info] ] end,
		set = function(info, value) E.db.mui.bags[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = MER:cOption(L["Bags"]),
			},
			transparentSlots = {
				order = 2,
				type = "toggle",
				name = L["Transparent Slots"],
				disabled = function() return not E.private.bags.enable end,
			},
		},
	}
end
tinsert(MER.Config, BagTable)
