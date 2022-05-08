local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Media')
local LSM = E.LSM or E.Libs.LSM

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
local random = random
-- WoW API / Variables
local FadingFrame_Show = FadingFrame_Show
local IsAddOnLoaded = IsAddOnLoaded
--GLOBALS: hooksecurefunc

MER.Media = {
	Icons = {},
	Textures = {},
}

local MediaPath = "Interface/Addons/ElvUI_MerathilisUI/Core/Media/"

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

AddMedia("arrow", "arrow.tga", "Textures")
AddMedia("pepeSmall", "pepeSmall.tga", "Textures")
AddMedia("ROLES", "UI-LFG-ICON-ROLES.tga", "Textures")
AddMedia("exchange", "Exchange.tga", "Textures")

module.Zones = L["MER_MEDIA_ZONES"]
module.PvPInfo = L["MER_MEDIA_PVP"]
module.Subzones = L["MER_MEDIA_SUBZONES"]
module.PVPArena = L["MER_MEDIA_PVPARENA"]

local Colors = {
	[1] = {0.41, 0.8, 0.94}, -- sanctuary
	[2] = {1.0, 0.1, 0.1}, -- hostile
	[3] = {0.1, 1.0, 0.1}, --friendly
	[4] = {1.0, 0.7, 0}, --contested
	[5] = {1.0, 0.9294, 0.7607}, --white
}

local function ZoneTextPos()
	_G["SubZoneTextString"]:ClearAllPoints()
	if (_G["PVPInfoTextString"]:GetText() == "") then
		_G["SubZoneTextString"]:Point("TOP", "ZoneTextString", "BOTTOM", 0, 0)
	else
		_G["SubZoneTextString"]:Point("TOP", "PVPInfoTextString", "BOTTOM", 0, 0)
	end
end

local function MakeFont(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

function module:SetBlizzFonts()
	module.db = E.db.mui.media

	if E.private.general.replaceBlizzFonts then
		if module.db.zoneText.enable then
			_G["ZoneTextString"]:SetFont(E.LSM:Fetch('font', module.db.zoneText.zone.font), module.db.zoneText.zone.size, module.db.zoneText.zone.outline) -- Main zone name
			_G["PVPInfoTextString"]:SetFont(E.LSM:Fetch('font', module.db.zoneText.pvp.font), module.db.zoneText.pvp.size, module.db.zoneText.pvp.outline) -- PvP status for main zone
			_G["PVPArenaTextString"]:SetFont(E.LSM:Fetch('font', module.db.zoneText.pvp.font), module.db.zoneText.pvp.size, module.db.zoneText.pvp.outline) -- PvP status for subzone
			_G["SubZoneTextString"]:SetFont(E.LSM:Fetch('font', module.db.zoneText.subzone.font), module.db.zoneText.subzone.size, module.db.zoneText.subzone.outline) -- Subzone name
		end

		if E.Retail then
			if module.db.miscText.mail.enable then
				_G["SendMailBodyEditBox"]:SetFont(E.LSM:Fetch('font', module.db.miscText.mail.font), module.db.miscText.mail.size, module.db.miscText.mail.outline) --Writing letter text
				_G["OpenMailBodyText"]:SetFont(E.LSM:Fetch('font', module.db.miscText.mail.font), module.db.miscText.mail.size, module.db.miscText.mail.outline) --Received letter text
			end
		end

		if module.db.miscText.gossip.enable then
			_G["QuestFont"]:SetFont(E.LSM:Fetch('font', module.db.miscText.gossip.font), module.db.miscText.gossip.size, module.db.miscText.gossip.outline) -- Font in Quest Log/Petitions and shit. It's fucking hedious with any outline so fuck it.
		end

		if module.db.miscText.questFontSuperHuge.enable then
			_G["QuestFont_Super_Huge"]:SetFont(E.LSM:Fetch('font', module.db.miscText.questFontSuperHuge.font), module.db.miscText.questFontSuperHuge.size, module.db.miscText.questFontSuperHuge.outline) -- No idea what that is for
			_G["QuestFont_Enormous"]:SetFont(E.LSM:Fetch('font', module.db.miscText.questFontSuperHuge.font), module.db.miscText.questFontSuperHuge.size, module.db.miscText.questFontSuperHuge.outline) -- No idea what that is for
		end
	end
end

function module:TextShow()
	local z, i, a, s, c = random(1, #module.Zones), random(1, #module.PvPInfo), random(1, #module.PVPArena), random(1, #module.Subzones), random(1, #Colors)
	local red, green, blue = unpack(Colors[c])

	--Setting texts--
	_G["ZoneTextString"]:SetText(module.Zones[z])
	_G["PVPInfoTextString"]:SetText(module.PvPInfo[i])
	_G["PVPArenaTextString"]:SetText(module.PVPArena[a])
	_G["SubZoneTextString"]:SetText(module.Subzones[s])

	ZoneTextPos()--nil, true)

	-- Applying colors
	_G["ZoneTextString"]:SetTextColor(red, green, blue)
	_G["PVPInfoTextString"]:SetTextColor(red, green, blue)
	_G["PVPArenaTextString"]:SetTextColor(red, green, blue)
	_G["SubZoneTextString"]:SetTextColor(red, green, blue)

	FadingFrame_Show(_G["ZoneTextFrame"])
	FadingFrame_Show(_G["SubZoneTextFrame"])
end

function module:Initialize()
	if IsAddOnLoaded("ElvUI_SLE") then return; end
	MER:RegisterDB(self, "media")

	module.db = E.db.mui.media
	function module:ForUpdateAll()
		module.db = E.db.mui.media

		if module.db.zoneText.enable then
			hooksecurefunc("SetZoneText", ZoneTextPos)
		end
	end
	self:ForUpdateAll()

	if module.db.zoneText.enable then
		hooksecurefunc("SetZoneText", ZoneTextPos)
	end

	hooksecurefunc(E, "UpdateBlizzardFonts", module.SetBlizzFonts)
	module.SetBlizzFonts()
end

MER:RegisterModule(module:GetName())
