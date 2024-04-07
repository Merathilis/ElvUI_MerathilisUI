local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local LSM = E.LSM or E.Libs.LSM

MER.Media = {
	Icons = {},
	Textures = {},
	Logos = {},
}

local MediaPath = "Interface/Addons/ElvUI_MerathilisUI/Media/"

local function AddMedia(name, file, type)
	MER.Media[type][name] = MediaPath .. type .. "/" .. file
end

MER.ClassIcons = {
	["WARRIOR"] = "Interface/AddOns/ElvUI_MerathilisUI/Media/Icons/ClassIcon/Warrior",
	["PALADIN"] = "Interface/AddOns/ElvUI_MerathilisUI/Media/Icons/ClassIcon/Paladin",
	["HUNTER"] = "Interface/AddOns/ElvUI_MerathilisUI/Media/Icons/ClassIcon/Hunter",
	["ROGUE"] = "Interface/AddOns/ElvUI_MerathilisUI/Media/Icons/ClassIcon/Rogue",
	["PRIEST"] = "Interface/AddOns/ElvUI_MerathilisUI/Media/Icons/ClassIcon/Priest",
	["DEATHKNIGHT"] = "Interface/AddOns/ElvUI_MerathilisUI/Media/Icons/ClassIcon/DeathKnight",
	["SHAMAN"] = "Interface/AddOns/ElvUI_MerathilisUI/Media/Icons/ClassIcon/Shaman",
	["MAGE"] = "Interface/AddOns/ElvUI_MerathilisUI/Media/Icons/ClassIcon/Mage",
	["WARLOCK"] = "Interface/AddOns/ElvUI_MerathilisUI/Media/Icons/ClassIcon/Warlock",
	["MONK"] = "Interface/AddOns/ElvUI_MerathilisUI/Media/Icons/ClassIcon/Monk",
	["DRUID"] = "Interface/AddOns/ElvUI_MerathilisUI/Media/Icons/ClassIcon/Druid",
	["DEMONHUNTER"] = "Interface/AddOns/ElvUI_MerathilisUI/Media/Icons/ClassIcon/DemonHunter",
	["EVOKER"] = "Interface/AddOns/ElvUI_MerathilisUI/Media/Icons/ClassIcon/Evoker",
}

F.AddMedia("texture", "WidgetsTips")

F.AddMedia("logo", "LogoSmall")

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
AddMedia("information", "Information.tga", "Icons")
AddMedia("innovation", "Innovation.tga", "Icons")
AddMedia("list", "List.tga", "Icons")
AddMedia("media", "Media.tga", "Icons")
AddMedia("modules", "Modules.tga", "Icons")
AddMedia("skins", "Skins.tga", "Icons")
AddMedia("accept", "Accept.tga", "Icons")
AddMedia("complete", "Complete.tga", "Icons")
AddMedia("discord", "Discord.tga", "Icons")
AddMedia("github", "Github.tga", "Icons")

--Option Icons
AddMedia("home", "Options/home.tga", "Icons")
AddMedia("config", "Options/config.tga", "Icons")
AddMedia("system", "Options/system.tga", "Icons")
AddMedia("tips", "Options/tips.tga", "Icons")
AddMedia("bill", "Options/bill.tga", "Icons")
AddMedia("save", "Options/save.tga", "Icons")
AddMedia("more", "Options/more.tga", "Icons")
AddMedia("tool", "Options/tool.tga", "Icons")
AddMedia("gradient", "Options/gradient.tga", "Icons")
AddMedia("changelog", "Options/changelog.tga", "Icons")

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
AddMedia("Pushed", "pushed.tga", "Textures")

AddMedia("PepeArt", "PepeArt.tga", "Textures")

AddMedia("PepoLove", "Peepo/love.tga", "Textures")
AddMedia("PepoBedge", "Peepo/bedge.tga", "Textures")
AddMedia("PepoOkaygeL", "Peepo/okaygeL.tga", "Textures")
AddMedia("PepoStrongge", "Peepo/strongge.tga", "Textures")

AddMedia("flag", "flag.tga", "Textures")

AddMedia("dc", "materialDC.tga", "Textures")
AddMedia("dead", "materialDead.tga", "Textures")

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

AddMedia("mainTank", "RoleIcons/Main/Tank.tga", "Textures")
AddMedia("mainHeal", "RoleIcons/Main/Healer.tga", "Textures")
AddMedia("mainDPS", "RoleIcons/Main/DPS.tga", "Textures")

AddMedia("whiteTank", "RoleIcons/White/Tank.tga", "Textures")
AddMedia("whiteHeal", "RoleIcons/White/Healer.tga", "Textures")
AddMedia("whiteDPS", "RoleIcons/White/DPS.tga", "Textures")

AddMedia("materialTank", "RoleIcons/Material/Tank.tga", "Textures")
AddMedia("materialHeal", "RoleIcons/Material/Healer.tga", "Textures")
AddMedia("materialDPS", "RoleIcons/Material/DPS.tga", "Textures")

AddMedia("emptyTex", "bgTex.blp", "Textures")
AddMedia("glowTex", "glowTex.blp", "Textures")
AddMedia("MinimapDifficulty", "minimap-difficulty.tga", "Textures")

AddMedia("noiseInner", "NoiseInner.blp", "Textures")
AddMedia("shadowInner", "ShadowInner.blp", "Textures")
AddMedia("shadowInnerSmall", "ShadowInnerSmall.blp", "Textures")

-- Fonts
LSM:Register("font", "Prototype", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\PROTOTYPE.TTF]])
LSM:Register(
	"font",
	"PrototypeRU",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\PROTOTYPE_RU.TTF]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"Visitor1",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\visitor1.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register("font", "Visitor2", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\visitor2.ttf]])
LSM:Register(
	"font",
	"Tukui",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\uf_font.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register("font", "ArialN", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\ARIALN.ttf]])
LSM:Register("font", "Default", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\default.ttf]])
LSM:Register(
	"font",
	"Roboto-Black",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\Roboto-Black.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"Roboto-Bold",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\Roboto-Bold.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"Roboto-Medium",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\Roboto-Medium.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"Roboto-Regular",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\Roboto-Regular.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"RobotoCondensed-Regular",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\RobotoCondensed-Regular.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register("font", "GoodDogCool", [[Interface\AddOns\ElvUI_MerathilisUI\edia\Fonts\gdcool.ttf]])
LSM:Register("font", "BadaBoom", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\BADABB__.ttf]])
LSM:Register("font", "Gothic-Bold", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\CenturyGothicBold.ttf]])
LSM:Register("font", "Gotham Narrow Black", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\GothamNarrow-Black.ttf]])
LSM:Register("font", "Gotham Narrow Ultra", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\GothamNarrow-Ultra.otf]])
LSM:Register(
	"font",
	"Montserrat-Black",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\Montserrat-Black.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"Montserrat-Bold",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\Montserrat-Bold.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"Montserrat-ExtraBold",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\Montserrat-ExtraBold.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"Montserrat-ExtraLight",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\Montserrat-ExtraLight.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"Montserrat-Light",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\Montserrat-Light.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"Montserrat-Medium",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\Montserrat-Medium.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"Montserrat-Regular",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\Montserrat-Regular.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"Montserrat-SemiBold",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\Montserrat-SemiBold.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"NotoSans-Medium",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\NotoSans-Medium.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)
LSM:Register(
	"font",
	"OldSchool Runescape",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\Fonts\Runescape.ttf]],
	LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
)

-- Backgrounds
-- Border

-- Statusbars
LSM:Register("statusbar", "MerathilisBlank", [[Interface\BUTTONS\WHITE8X8.blp]])
LSM:Register("statusbar", "MerathilisUI1", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\mUI2.tga]])
LSM:Register("statusbar", "MerathilisUI2", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\mUI3.tga]])
LSM:Register("statusbar", "MerathilisUI4", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\mUI4.tga]])
LSM:Register("statusbar", "MerathilisOnePixel", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\OnePixel.tga]])
LSM:Register("statusbar", "MerathilisMelli", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\Melli.tga]])
LSM:Register("statusbar", "MerathilisMelliDark", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\MelliDark.tga]])
LSM:Register("statusbar", "MerathilisEmpty", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\Empty.tga]])
LSM:Register("statusbar", "MerathilisnormTex", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\normTex.tga]])
LSM:Register("statusbar", "MerathilisDefault", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\default.tga]])
LSM:Register("statusbar", "MerathilisLight", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\Light.tga]])
LSM:Register(
	"statusbar",
	"MerathilisFeint",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\MerathilisFeint.tga]]
)
LSM:Register("statusbar", "MerathilisBorder", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\Border.tga]])
LSM:Register("statusbar", "Gradient", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\gradient1.tga]])
LSM:Register("statusbar", "MER_NormTex", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\MERNormTex.tga]])
LSM:Register("statusbar", "Lyn1", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\lyn1.tga]])
LSM:Register("statusbar", "Skullflower", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\Skullflower.tga]])
LSM:Register(
	"statusbar",
	"SkullflowerLight",
	[[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\SkullflowerLight.tga]]
)
LSM:Register("statusbar", "Duffed", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\Duffed.tga]])
LSM:Register("statusbar", "RenAscension", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\RenAscension.tga]])
LSM:Register("statusbar", "RenAscensionL", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\RenAscensionL.tga]])
LSM:Register("statusbar", "4Pixel", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\Line4pixel.tga]])
LSM:Register("statusbar", "Asphyxia", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\AsphyxiaNorm.tga]])
LSM:Register("statusbar", "MER_Stripes", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\MER_Stripes.tga]])
LSM:Register("statusbar", "Simpy19", [[Interface\AddOns\ElvUI_MerathilisUI\Media\StatusBars\simpy_tex19.tga]])

-- Sounds
LSM:Register("sound", "warning", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Sounds\warning.ogg]])
LSM:Register("sound", "OnePlus Light", [[Interface\AddOns\ElvUI_MerathilisUI\Media\Sounds\OnePlusLight.ogg]])

-- Custom Textures
E.media.roleIcons = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\UI-LFG-ICON-ROLES]]
E.media.checked = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\checked]]
