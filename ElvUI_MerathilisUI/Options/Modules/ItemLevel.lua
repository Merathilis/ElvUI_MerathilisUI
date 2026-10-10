local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local options = module.options.modules.args

	options.itemLevel = {
		type = "group",
		name = module:AddCategorieIcon(L["Item Level"], "item_level"),
		args = {
			header = {
				order = 0,
				type = "header",
				name = L["Item Level"],
			},
			enable = module.ToggleCard({
				order = 1,
				name = L["Enable"],
				desc = L["Shows the item level on the items in the merchant and trade windows."]
					.. "\n\n"
					.. F.String.Warning(
						L["The item level on the equipment flyout, the scrapping machine and in the guild news is part of WindTools (Item > Item Level, Misc)."]
					),
				image = I.Media.Icons.Categories.item_level,
				get = function()
					return E.db.mui.itemLevel.enable
				end,
				-- Checked on every update, the next open merchant or trade window follows it
				set = function(_, value)
					E.db.mui.itemLevel.enable = value
					MER:GetModule("MER_ItemLevel"):UpdateHooks()
				end,
			}),
			preview = module.PreviewOption(2, "MERItemLevelPreview", "itemLevel"),
		},
	}
end)
