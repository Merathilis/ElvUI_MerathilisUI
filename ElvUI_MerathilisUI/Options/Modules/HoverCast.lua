local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local options = module.options.modules.args

	-- The whole editor is one custom widget (Options/Widgets/HoverCastPage.lua),
	-- the bindings are account-wide and live in E.global.mui.hoverCast
	options.hoverCast = {
		type = "group",
		name = module:AddCategorieIcon(L["HoverCast"], "hover_cast"),
		args = {
			preview = module.PreviewOption(0, "MERHoverCastPreview", "hovercast"),
			page = {
				order = 1,
				type = "description",
				name = "",
				dialogControl = "MERHoverCastPage",
			},
		},
	}
end)
