local MER, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM or E.Libs.LSM

MER.Media = {
	Icons = {},
	Textures = {},
}

local MediaPath = "Interface/Addons/ElvUI_MerathilisUI/Core/Media/"

do
	local cuttedIconTemplate = "|T%s:%d:%d:0:0:64:64:5:59:5:59|t"
	local textureTemplate = "|T%s:%d:%d|t"
	local aspectRatioTemplate = "|T%s:0:aspectRatio|t"
	local s = 14

	function F.GetIconString(icon, height, width)
		width = width or height
		return format(cuttedIconTemplate, icon, height or s, width or s)
	end

	function F.GetTextureString(texture, height, width, aspectRatio)
		if aspectRatio then
			return format(aspectRatioTemplate, texture)
		else
			width = width or height
			return format(textureTemplate, texture, height or s, width or s)
		end
	end
end

local function AddMedia(name, file, type)
	MER.Media[type][name] = MediaPath .. type .. "/" .. file
end

AddMedia("barAchievements", "MicroBar/Achievements.tga", "Icons")
AddMedia("barBags", "MicroBar/Bags.tga", "Icons")
AddMedia("barBlizzardShop", "MicroBar/BlizzardShop.tga", "Icons")
AddMedia("barCharacter", "MicroBar/Character.tga", "Icons")
AddMedia("barCollections", "MicroBar/Collections.tga", "Icons")
AddMedia("barEncounterJournal", "MicroBar/EncounterJournal.tga", "Icons")
AddMedia("barGameMenu", "MicroBar/GameMenu.tga", "Icons")
AddMedia("barFriends", "MicroBar/Friends.tga", "Icons")
AddMedia("barGroupFinder", "MicroBar/GroupFinder.tga", "Icons")
AddMedia("barGuild", "MicroBar/Guild.tga", "Icons")
AddMedia("barHome", "MicroBar/Home.tga", "Icons")
AddMedia("barMissionReports", "MicroBar/MissionReports.tga", "Icons")
AddMedia("barNotification", "MicroBar/Notification.tga", "Icons")
AddMedia("barOptions", "MicroBar/Options.tga", "Icons")
AddMedia("barPetJournal", "MicroBar/PetJournal.tga", "Icons")
AddMedia("barProfession", "MicroBar/Profession.tga", "Icons")
AddMedia("barScreenShot", "MicroBar/ScreenShot.tga", "Icons")
AddMedia("barSound", "MicroBar/Sound.tga", "Icons")
AddMedia("barSpellBook", "MicroBar/SpellBook.tga", "Icons")
AddMedia("barTalents", "MicroBar/Talents.tga", "Icons")
AddMedia("barToyBox", "MicroBar/ToyBox.tga", "Icons")
AddMedia("barVolume", "MicroBar/Volume.tga", "Icons")

AddMedia("favorite", "Favorite.tga", "Icons")
AddMedia("general", "General.tga", "Icons")
AddMedia("information", "Information.tga", "Icons")
AddMedia("list", "List.tga", "Icons")
AddMedia("media", "Media.tga", "Icons")
AddMedia("modules", "Modules.tga", "Icons")
AddMedia("skins", "Skins.tga", "Icons")

AddMedia("discord", "Discord.tga", "Icons")
AddMedia("github", "Github.tga", "Icons")

AddMedia("arrow", "arrow.tga", "Textures")
AddMedia("pepeSmall", "pepeSmall.tga", "Textures")
AddMedia("ROLES", "UI-LFG-ICON-ROLES.tga", "Textures")
AddMedia("exchange", "Exchange.tga", "Textures")
