local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: KuiNameplatesCoreSaved, LibStub

function MER:LoadKuiNamePlatesCoreProfile()
	--[[----------------------------------
	--	KuiNamePlates - Settings
	--]]----------------------------------
	KuiNameplatesCoreSaved = {
		["auras_icon_squareness"] = 0.75,
		["auras_centre"] = false,
		["auras_icon_normal_size"] = 30,
		["class_colour_enemy_names"] = true,
		["font_face"] = "Merathilis Roboto-Bold",
		["ignore_uiscale"] = true,
		["bar_animation"] = 2,
		["nameonly_neutral"] = true,
		["bar_texture"] = "MerathilisBlank",
		["profiles"] = {
			["MerathilisUI"] = {
				["bossmod_clickthrough"] = true,
				["auras_vanilla_filter"] = false,
				["font_face"] = "Merathilis Roboto-Bold",
				["auras_centre"] = false,
				["bar_animation"] = 2,
				["colour_player_class"] = true,
				["nameonly_neutral"] = true,
				["bar_texture"] = "MerathilisFlat",
			},
		},
	}
end