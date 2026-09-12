local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local AU = MER:GetModule("MER_Auras")

local options = module.options.modules.args

local function Get(info)
	return E.db.mui.auras.buffsCollapse[info[#info]]
end

local function Set(info, value)
	E.db.mui.auras.buffsCollapse[info[#info]] = value
	AU:Refresh()
end

F.MarkTabAsNew("auras")

options.auras = {
	type = "group",
	name = module:AddCategorieIcon(L["BUFFOPTIONS_LABEL"], "auras"),
	get = Get,
	set = Set,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.NewFeatureText(L["BUFFOPTIONS_LABEL"]),
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Collapse & Expand Button"],
			desc = L["Adds Blizzard's Collapse/Expand arrow button back to ElvUI's Player Buffs. Collapsing shrinks the buffs down to a single row, keeping only the ones about to expire visible while long-lasting buffs are hidden."],
			width = "full",
		},
	},
}
