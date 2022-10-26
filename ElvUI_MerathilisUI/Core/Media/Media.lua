local MER, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM or E.Libs.LSM

MER.Media = {
	Icons = {},
	Textures = {},
}

local MediaPath = "Interface/Addons/ElvUI_MerathilisUI/Core/Media/"

do
	local cuttedIconTemplate = "|T%s:%d:%d:0:0:64:64:5:59:5:59|t"
	local cuttedIconAspectRatioTemplate = "|T%s:%d:%d:0:0:64:64:%d:%d:%d:%d|t"
	local textureTemplate = "|T%s:%d:%d|t"
	local aspectRatioTemplate = "|T%s:0:aspectRatio|t"
	local s = 14

	function F.GetIconString(icon, height, width, aspectRatio)
		if aspectRatio and height and height > 0 and width and width > 0 then
			local proportionality = height / width
			local offset = ceil((54 - 54 * proportionality) / 2)
			if proportionality > 1 then
				return format(cuttedIconAspectRatioTemplate, icon, height, width, 5 + offset, 59 - offset, 5, 59)
			elseif proportionality < 1 then
				return format(cuttedIconAspectRatioTemplate, icon, height, width, 5, 59, 5 + offset, 59 - offset)
			end
		end

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

-- Alternate Class Icons by Releaf
MER.TagClassIcons = {
	["WARRIOR"] = "|TInterface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\Icons\\Classes\\Warrior.tga:0:0:0:0|t",
	["PALADIN"] = "|TInterface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\Icons\\Classes\\Paladin.tga:0:0:0:0|t",
	["HUNTER"] = "|TInterface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\Icons\\Classes\\Hunter.tga:0:0:0:0|t",
	["ROGUE"] = "|TInterface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\Icons\\Classes\\Rogue.tga:0:0:0:0|t",
	["PRIEST"] = "|TInterface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\Icons\\Classes\\Priest.tga:0:0:0:0|t",
	["DEATHKNIGHT"] = "|TInterface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\Icons\\Classes\\DeathKnight.tga:0:0:0:0|t",
	["SHAMAN"] = "|TInterface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\Icons\\Classes\\Shaman.tga:0:0:0:0|t",
	["MAGE"] = "|TInterface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\Icons\\Classes\\Mage.tga:0:0:0:0|t",
	["WARLOCK"] = "|TInterface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\Icons\\Classes\\Warlock.tga:0:0:0:0|t",
	["MONK"] = "|TInterface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\Icons\\Classes\\Monk.tga:0:0:0:0|t",
	["DRUID"] = "|TInterface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\Icons\\Classes\\Druid.tga:0:0:0:0|t",
	["DEMONHUNTER"] = "|TInterface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\Icons\\Classes\\DemonHunter.tga:0:0:0:0|t",
}

MER.ClassIcons = {
	["WARRIOR"] = "Interface/AddOns/ElvUI_MerathilisUI/Core/Media/Icons/Classes/Warrior",
	["PALADIN"] = "Interface/AddOns/ElvUI_MerathilisUI/Core/Media/Icons/Classes/Paladin",
	["HUNTER"] = "Interface/AddOns/ElvUI_MerathilisUI/Core/Media/Icons/Classes/Hunter",
	["ROGUE"] = "Interface/AddOns/ElvUI_MerathilisUI/Core/Media/Icons/Classes/Rogue",
	["PRIEST"] = "Interface/AddOns/ElvUI_MerathilisUI/Core/Media/Icons/Classes/Priest",
	["DEATHKNIGHT"] = "Interface/AddOns/ElvUI_MerathilisUI/Core/Media/Icons/Classes/DeathKnight",
	["SHAMAN"] = "Interface/AddOns/ElvUI_MerathilisUI/Core/Media/Icons/Classes/Shaman",
	["MAGE"] = "Interface/AddOns/ElvUI_MerathilisUI/Core/Media/Icons/Classes/Mage",
	["WARLOCK"] = "Interface/AddOns/ElvUI_MerathilisUI/Core/Media/Icons/Classes/Warlock",
	["MONK"] = "Interface/AddOns/ElvUI_MerathilisUI/Core/Media/Icons/Classes/Monk",
	["DRUID"] = "Interface/AddOns/ElvUI_MerathilisUI/Core/Media/Icons/Classes/Druid",
	["DEMONHUNTER"] = "Interface/AddOns/ElvUI_MerathilisUI/Core/Media/Icons/Classes/DemonHunter",
}

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

AddMedia("calendar", "Calendar.tga", "Icons")
AddMedia("convert", "Convert.tga", "Icons")
AddMedia("favorite", "Favorite.tga", "Icons")
AddMedia("general", "General.tga", "Icons")
AddMedia("information", "Information.tga", "Icons")
AddMedia("list", "List.tga", "Icons")
AddMedia("media", "Media.tga", "Icons")
AddMedia("modules", "Modules.tga", "Icons")
AddMedia("skins", "Skins.tga", "Icons")

AddMedia("accept", "Accept.tga", "Icons")

AddMedia("discord", "Discord.tga", "Icons")
AddMedia("github", "Github.tga", "Icons")

AddMedia("buttonLock", "Button/Lock.tga", "Icons")
AddMedia("buttonUnlock", "Button/Unlock.tga", "Icons")
AddMedia("buttonMinus", "Button/Minus.tga", "Icons")
AddMedia("buttonPlus", "Button/Plus.tga", "Icons")
AddMedia("buttonForward", "Button/Forward.tga", "Icons")

AddMedia("sort", "Sort.tga", "Icons")

AddMedia("anchor", "anchor.tga", "Textures")
AddMedia("arrow", "arrow.tga", "Textures")
AddMedia("arrowUp", "arrowUp.tga", "Textures")
AddMedia("pepeSmall", "pepeSmall.tga", "Textures")
AddMedia("ROLES", "UI-LFG-ICON-ROLES.tga", "Textures")
AddMedia("exchange", "Exchange.tga", "Textures")
AddMedia("PepeArt", "PepeArt.tga", "Textures")
AddMedia("PepoLove", "pepoLove.tga", "Textures")
AddMedia("Pushed", "pushed.tga", "Textures")

-- Role Icons
AddMedia("sunTank", "RoleIcons/SunUI/Tank.tga", "Textures")
AddMedia("sunHealer", "RoleIcons/SunUI/Healer.tga", "Textures")
AddMedia("sunDPS", "RoleIcons/SunUI/DPS.tga", "Textures")

AddMedia("svuiTank", "RoleIcons/SVUI/Tank.tga", "Textures")
AddMedia("svuiHealer", "RoleIcons/SVUI/Healer.tga", "Textures")
AddMedia("svuiDPS", "RoleIcons/SVUI/DPS.tga", "Textures")

AddMedia("lynTank", "RoleIcons/LynUI/Tank.tga", "Textures")
AddMedia("lynHealer", "RoleIcons/LynUI/Healer.tga", "Textures")
AddMedia("lynDPS", "RoleIcons/LynUI/DPS.tga", "Textures")

AddMedia("customTank", "RoleIcons/Custom/Tank.tga", "Textures")
AddMedia("customHeal", "RoleIcons/Custom/Healer.tga", "Textures")
AddMedia("customDPS", "RoleIcons/Custom/DPS.tga", "Textures")

AddMedia("glowTank", "RoleIcons/Glow/Tank.tga", "Textures")
AddMedia("glowHeal", "RoleIcons/Glow/Healer.tga", "Textures")
AddMedia("glowDPS", "RoleIcons/Glow/DPS.tga", "Textures")

AddMedia("gravedTank", "RoleIcons/Graved/Tank.tga", "Textures")
AddMedia("gravedHeal", "RoleIcons/Graved/Healer.tga", "Textures")
AddMedia("gravedDPS", "RoleIcons/Graved/DPS.tga", "Textures")

AddMedia("mainTank", "RoleIcons/Main/Tank.tga", "Textures")
AddMedia("mainHeal", "RoleIcons/Main/Healer.tga", "Textures")
AddMedia("mainDPS", "RoleIcons/Main/DPS.tga", "Textures")

AddMedia("whiteTank", "RoleIcons/White/Tank.tga", "Textures")
AddMedia("whiteHeal", "RoleIcons/White/Healer.tga", "Textures")
AddMedia("whiteDPS", "RoleIcons/White/DPS.tga", "Textures")

AddMedia("emptyTex", "bgTex.blp", "Textures")
AddMedia("glowTex", "glowTex.blp", "Textures")

-- Fonts
LSM:Register("font","Prototype", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\PROTOTYPE.TTF]])
LSM:Register("font","PrototypeRU", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\PROTOTYPE_RU.TTF]], LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font","Visitor1", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\visitor1.ttf]], LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font","Visitor2", [[Interface\AddOns\ElvUI_MerathilisUI\\Core\Media\Fonts\visitor2.ttf]])
LSM:Register("font","Tukui", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\uf_font.ttf]], LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font","ArialN", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\ARIALN.ttf]])
LSM:Register("font","Default", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\default.ttf]])
LSM:Register("font","Roboto-Black", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\Roboto-Black.ttf]])
LSM:Register("font","Roboto-Bold", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\Roboto-Bold.ttf]])
LSM:Register("font","Roboto-Medium", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\Roboto-Medium.ttf]])
LSM:Register("font","Roboto-Regular", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\Roboto-Regular.ttf]])
LSM:Register("font","GoodDogCool", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\gdcool.ttf]])
LSM:Register("font","BadaBoom", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\BADABB__.ttf]])
LSM:Register("font","Gothic-Bold", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\CenturyGothicBold.ttf]])
LSM:Register("font","Gotham Narrow Black", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\GothamNarrow-Black.ttf]])
LSM:Register("font","Gotham Narrow Ultra", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Fonts\GothamNarrow-Ultra.otf]])

-- Backgrounds
-- Border

-- Statusbars
LSM:Register("statusbar","MerathilisBlank", [[Interface\BUTTONS\WHITE8X8.blp]])
LSM:Register("statusbar","MerathilisUI1", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\mUI2.tga]])
LSM:Register("statusbar","MerathilisUI2", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\mUI3.tga]])
LSM:Register("statusbar","MerathilisUI4", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\mUI4.tga]])
LSM:Register("statusbar","MerathilisOnePixel", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\OnePixel.tga]])
LSM:Register("statusbar","MerathilisMelli", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\Melli.tga]])
LSM:Register("statusbar","MerathilisMelliDark", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\MelliDark.tga]])
LSM:Register("statusbar","MerathilisEmpty", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\Empty.tga]])
LSM:Register("statusbar","MerathilisnormTex", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\normTex.tga]])
LSM:Register("statusbar","MerathilisDefault", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\default.tga]])
LSM:Register("statusbar","MerathilisLight", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\Light.tga]])
LSM:Register("statusbar","MerathilisFeint", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\MerathilisFeint.tga]])
LSM:Register("statusbar","MerathilisBorder", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\Border.tga]])
LSM:Register("statusbar","Gradient", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\gradient1.tga]])
LSM:Register("statusbar","MER_NormTex", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\MERNormTex.tga]])
LSM:Register("statusbar","Lyn1", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\lyn1.tga]])
LSM:Register("statusbar","Skullflower", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\Skullflower.tga]])
LSM:Register("statusbar","SkullflowerLight", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\SkullflowerLight.tga]])
LSM:Register("statusbar","Duffed", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\Duffed.tga]])
LSM:Register("statusbar","RenAscension", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\RenAscension.tga]])
LSM:Register("statusbar","RenAscensionL", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\RenAscensionL.tga]])
LSM:Register("statusbar","4Pixel", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\StatusBars\Line4pixel.tga]])

-- Sounds
LSM:Register("sound","warning", [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Sounds\warning.ogg]])

-- Custom Textures
E.media.roleIcons = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\UI-LFG-ICON-ROLES]]
E.media.checked = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\checked]]
