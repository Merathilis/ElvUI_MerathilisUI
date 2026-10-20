local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	-- Movies and music data are Retail
	if E.Forever then
		return
	end

	local MP = MER:GetModule("MER_MediaPlayer")

	local options = module.options.modules.args

	options.mediaPlayer = {
		type = "group",
		name = module:AddCategorieIcon(L["Media Player"], "media_player"),
		args = {
			header = {
				order = 0,
				type = "header",
				name = L["Media Player"],
			},
			description = {
				order = 1,
				type = "description",
				name = L["Browse the game's music by expansion and zone and play it as a playlist, or replay the cinematics. The search finds tracks, zones and cinematics. The game's own music pauses while a track plays."]
					.. "\n\n"
					.. format(L["Also opens with %s."], F.String.MERATHILISUI("/muimedia")),
				fontSize = "medium",
				width = "full",
			},
			open = module.ActionCard({
				order = 2,
				name = L["Open Media Player"],
				desc = L["Browse and play the game's music by expansion and zone, and replay the cinematics."],
				func = function()
					MP:OpenFromOptions()
				end,
			}, { icon = I.Media.Icons.Categories.media_player, relWidth = 0.5 }),
		},
	}

	F.MarkTabAsNew("mediaPlayer")
end)
