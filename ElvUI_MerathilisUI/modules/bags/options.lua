local MER, E, L, V, P, G = unpack(select(2, ...))
local MERB = E:GetModule("mUIBags")

--Cache global variables

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function BagTable()
	E.Options.args.mui.args.bags = {
		type = "group",
		name = MERB.modName..MER.NewSign,
		order = 18,
		get = function(info) return E.db.mui.bags[ info[#info] ] end,
		hidden = function() return E.private.bags.enable end, -- hide it, if the ElvUI Bags are enabled.
		args = {
			header = {
				type = "header",
				name = MER:cOption(MERB.modName)..MER.NewSign,
				order = 1
			},
			description = {
				type = "description",
				name = MERB:Info() .. "\n\n",
				order = 2
			},
		},
	}
end
-- tinsert(MER.Config, BagTable)