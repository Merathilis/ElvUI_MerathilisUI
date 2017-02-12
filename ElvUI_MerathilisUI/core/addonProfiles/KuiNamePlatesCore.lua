local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

function MER:LoadKuiNamePlatesCoreProfile()
	--[[----------------------------------
	--	KuiNamePlates - Settings
	--]]----------------------------------
	KuiNameplatesCoreSaved = {
		["profiles"] = {
			["MerathilisUI"] = {
				["auras_icon_squareness"] = 0.75,
				["auras_centre"] = false,
				["auras_icon_normal_size"] = 30,
				["class_colour_enemy_names"] = true,
				["font_face"] = "Merathilis Roboto-Bold",
				["ignore_uiscale"] = true,
				["bar_animation"] = 2,
				["nameonly_neutral"] = true,
				["bar_texture"] = "MerathilisFlat",
			},
		},
	}
	
	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(KuiNameplatesCoreSaved, nil, true)
	db:SetProfile("MerathilisUI") -- it will not set automatically
end