local MER, E, L, V, P, G = unpack(select(2, ...))
local MERB = MER:GetModule("mUIBags")
local MERBI = MER:GetModule("mUIBagInfo")

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
				order = 0,
				type = "header",
				name = MER:cOption(L["Bags"]),
			},
			general = {
				order = 1,
				type = "group",
				guiInline = true,
				name = L["General"],
				args = {
					transparentSlots = {
						order = 1,
						type = "toggle",
						name = L["Transparent Slots"],
						disabled = function() return not E.private.bags.enable end,
					},
				},
			},
			equipManager = {
				order = 2,
				type = "group",
				guiInline = true,
				name = L["Equipment Manager"],
				args = {
					equipOverlay = {
						type = "toggle",
						order = 1,
						name = L["Equipment Set Overlay"],
						desc = L["Show the associated equipment sets for the items in your bags (or bank)."],
						disabled = function() return not E.private.bags.enable end,
						get = function(info) return E.db.mui.bags.equipOverlay end,
						set = function(info, value) E.db.mui.bags.equipOverlay = value; MERBI:ToggleSettings(); end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, BagTable)
