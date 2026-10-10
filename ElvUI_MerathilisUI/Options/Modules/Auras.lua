local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local AU = MER:GetModule("MER_Auras")

	local options = module.options.modules.args

	local function Get(info)
		return E.db.mui.auras.buffsCollapse[info[#info]]
	end

	local function Set(info, value)
		E.db.mui.auras.buffsCollapse[info[#info]] = value
		AU:Refresh()
	end

	options.auras = {
		type = "group",
		name = module:AddCategorieIcon(L["BUFFOPTIONS_LABEL"], "auras"),
		get = Get,
		set = Set,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["BUFFOPTIONS_LABEL"],
			},
			requirements = module.RequirementsNotice(I.Requirements.Auras, 1.5),
			enable = module.ToggleCard({
				order = 2,
				name = L["Collapse & Expand Button"],
				disabled = module.RequirementsDisabled(I.Requirements.Auras),
				desc = L["Adds Blizzard's Collapse/Expand arrow button back to ElvUI's Player Buffs. Collapsing shrinks the buffs down to a single row, keeping only the ones about to expire visible while long-lasting buffs are hidden."],
				image = I.Media.Icons.Categories.auras,
			}),
			preview = module.PreviewOption(3, "MERAurasPreview", "auras"),
		},
	}
end)
