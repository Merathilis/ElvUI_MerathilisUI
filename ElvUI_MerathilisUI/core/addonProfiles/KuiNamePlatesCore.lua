local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: KuiNameplatesCoreSaved, LibStub

local playerName = UnitName("player")
local profileName = playerName.."-mUI"

function MER:LoadKuiNamePlatesCoreProfile()
	--[[----------------------------------
	--	KuiNamePlates - Settings
	--]]----------------------------------
	if (not KuiNameplatesCoreSaved.profiles[profileName]) then
		KuiNameplatesCoreSaved.profiles[profileName] = {
			["auras_icon_squareness"] = 0.75,
			["auras_centre"] = false,
			["auras_icon_normal_size"] = 30,
			["class_colour_enemy_names"] = true,
			["font_face"] = "Merathilis Roboto-Bold",
			["ignore_uiscale"] = true,
			["bar_animation"] = 2,
			["nameonly_neutral"] = true,
			["bar_texture"] = "MerathilisBlank",
		}

		-- Profile creation
		local db = LibStub("AceDB-3.0"):New(KuiNameplatesCoreSaved, nil, true)
		db:SetProfile(profileName)
	end
end