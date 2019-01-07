local MER, E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule("NamePlates")
local NA = MER:GetModule("NameplateAuras")
local COMP = MER:GetModule("mUICompatibility")

--Cache global variables
local pairs, select, tonumber, tostring, type = pairs, select, tonumber, tostring, type
local setmetatable = setmetatable
local getmetatable = getmetatable
local format = string.format
--WoW API / Variables
local GetSpellInfo = GetSpellInfo
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: deepcopy

local function NameplateAurasTable()
	E.Options.args.mui.args.modules.args.NameplateAuras = {
		type = "group",
		name = NA.modName,
		order = 16,
		get = function(info) return E.db.mui.NameplateAuras[ info[#info] ] end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(NA.modName),
			},
			spacer = {
				order = 4,
				type = "description",
				name = "",
			},
			enable = {
				order = 5,
				type = "toggle",
				name = L["Enable"],
				set = function(info, value)  E.db.mui.NameplateAuras[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				disabled = COMP.CUI,
			},
		},
	}
end
tinsert(MER.Config, NameplateAurasTable)
