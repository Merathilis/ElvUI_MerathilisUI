local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_ZoneText')

local _G = _G
local unpack = unpack
local random = random

local FadingFrame_Show = FadingFrame_Show
local IsAddOnLoaded = IsAddOnLoaded

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

function module:SetBlizzFonts()
	module.db = E.db.mui.media

	if E.private.general.replaceBlizzFonts then
		if module.db.zoneText.enable then
			_G["ZoneTextString"]:SetFont(E.LSM:Fetch('font', module.db.zoneText.zone.font), module.db.zoneText.zone.size) -- Main zone name
			_G["PVPInfoTextString"]:SetFont(E.LSM:Fetch('font', module.db.zoneText.pvp.font), module.db.zoneText.pvp.size) -- PvP status for main zone
			_G["PVPArenaTextString"]:SetFont(E.LSM:Fetch('font', module.db.zoneText.pvp.font), module.db.zoneText.pvp.size) -- PvP status for subzone
			_G["SubZoneTextString"]:SetFont(E.LSM:Fetch('font', module.db.zoneText.subzone.font), module.db.zoneText.subzone.size) -- Subzone name
		end

		if E.Retail then
			if module.db.miscText.mail.enable then
				_G["SendMailBodyEditBox"]:SetFont(E.LSM:Fetch('font', module.db.miscText.mail.font), module.db.miscText.mail.size, 'OUTLINE') --Writing letter text
				_G["OpenMailBodyText"]:SetFont(E.LSM:Fetch('font', module.db.miscText.mail.font), module.db.miscText.mail.size, 'OUTLINE') --Received letter text
			end
		end

		if module.db.miscText.gossip.enable then
			_G["QuestFont"]:SetFont(E.LSM:Fetch('font', module.db.miscText.gossip.font), module.db.miscText.gossip.size) -- Font in Quest Log/Petitions and shit. It's fucking hedious with any outline so fuck it.
		end

		if module.db.miscText.questFontSuperHuge.enable then
			_G["QuestFont_Super_Huge"]:SetFont(E.LSM:Fetch('font', module.db.miscText.questFontSuperHuge.font), module.db.miscText.questFontSuperHuge.size) -- No idea what that is for
			_G["QuestFont_Enormous"]:SetFont(E.LSM:Fetch('font', module.db.miscText.questFontSuperHuge.font), module.db.miscText.questFontSuperHuge.size) -- No idea what that is for
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

	module.db = E.db.mui.media

	if module.db.zoneText.enable then
		hooksecurefunc("SetZoneText", ZoneTextPos)
	end

	-- hooksecurefunc(E, "UpdateBlizzardFonts", module.SetBlizzFonts)
	-- module.SetBlizzFonts()
end

MER:RegisterModule(module:GetName())
