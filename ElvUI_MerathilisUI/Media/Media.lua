local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("MERMedia", "AceHook-3.0")
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
	if (_G["PVPInfoTextString"]:GetText() == "") then
		_G["SubZoneTextString"]:SetPoint("TOP", "ZoneTextString", "BOTTOM", 0, 0)
	else
		_G["SubZoneTextString"]:SetPoint("TOP", "PVPInfoTextString", "BOTTOM", 0, 0)
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

		if module.db.miscText.mail.enable then
			_G["SendMailBodyEditBox"]:SetFont(E.LSM:Fetch('font', module.db.miscText.mail.font), module.db.miscText.mail.size, module.db.miscText.mail.outline) --Writing letter text
			_G["OpenMailBodyText"]:SetFont(E.LSM:Fetch('font', module.db.miscText.mail.font), module.db.miscText.mail.size, module.db.miscText.mail.outline) --Received letter text
		end

		if module.db.miscText.gossip.enable then
			_G["QuestFont"]:SetFont(E.LSM:Fetch('font', module.db.miscText.gossip.font), module.db.miscText.gossip.size, module.db.miscText.gossip.outline) -- Font in Quest Log/Petitions and shit. It's fucking hedious with any outline so fuck it.
		end

		if module.db.miscText.questFontSuperHuge.enable then
			_G["QuestFont_Super_Huge"]:SetFont(E.LSM:Fetch('font', module.db.miscText.questFontSuperHuge.font), module.db.miscText.questFontSuperHuge.size, module.db.miscText.questFontSuperHuge.outline) -- No idea what that is for
			_G["QuestFont_Enormous"]:SetFont(E.LSM:Fetch('font', module.db.miscText.questFontSuperHuge.font), module.db.miscText.questFontSuperHuge.size, module.db.miscText.questFontSuperHuge.outline) -- No idea what that is for
		end

		if module.db.miscText.editbox.enable then
			_G["NumberFont_Shadow_Med"]:SetFont(E.LSM:Fetch('font', module.db.miscText.editbox.font), module.db.miscText.editbox.size, module.db.miscText.editbox.outline) --Chat editbox
		end

		--Objective Frame
		if module.db.miscText.objectiveHeader.enable then
			if not _G["ObjectiveTrackerFrame"].hooked then
				hooksecurefunc("ObjectiveTracker_Update", function(reason, id)
					_G["ObjectiveTrackerBlocksFrame"].QuestHeader.Text:SetFont(E.LSM:Fetch('font', module.db.miscText.objectiveHeader.font), module.db.miscText.objectiveHeader.size, module.db.miscText.objectiveHeader.outline)
					_G["ObjectiveTrackerBlocksFrame"].AchievementHeader.Text:SetFont(E.LSM:Fetch('font', module.db.miscText.objectiveHeader.font), module.db.miscText.objectiveHeader.size, module.db.miscText.objectiveHeader.outline)
					_G["ObjectiveTrackerBlocksFrame"].ScenarioHeader.Text:SetFont(E.LSM:Fetch('font', module.db.miscText.objectiveHeader.font), module.db.miscText.objectiveHeader.size, module.db.miscText.objectiveHeader.outline)
					_G["WORLD_QUEST_TRACKER_MODULE"].Header.Text:SetFont(E.LSM:Fetch('font', module.db.miscText.objectiveHeader.font), module.db.miscText.objectiveHeader.size, module.db.miscText.objectiveHeader.outline)
					_G["BONUS_OBJECTIVE_TRACKER_MODULE"].Header.Text:SetFont(E.LSM:Fetch('font', module.db.miscText.objectiveHeader.font), module.db.miscText.objectiveHeader.size, module.db.miscText.objectiveHeader.outline)
				end)
				_G["ObjectiveTrackerFrame"].hooked = true
			end
			_G["ObjectiveTrackerFrame"].HeaderMenu.Title:SetFont(E.LSM:Fetch('font', module.db.miscText.objectiveHeader.font), module.db.miscText.objectiveHeader.size, module.db.miscText.objectiveHeader.outline)
			_G["ObjectiveTrackerBlocksFrame"].QuestHeader.Text:SetFont(E.LSM:Fetch('font', module.db.miscText.objectiveHeader.font), module.db.miscText.objectiveHeader.size, module.db.miscText.objectiveHeader.outline)
			_G["ObjectiveTrackerBlocksFrame"].AchievementHeader.Text:SetFont(E.LSM:Fetch('font', module.db.miscText.objectiveHeader.font), module.db.miscText.objectiveHeader.size, module.db.miscText.objectiveHeader.outline)
			_G["ObjectiveTrackerBlocksFrame"].ScenarioHeader.Text:SetFont(E.LSM:Fetch('font', module.db.miscText.objectiveHeader.font), module.db.miscText.objectiveHeader.size, module.db.miscText.objectiveHeader.outline)
			_G["BONUS_OBJECTIVE_TRACKER_MODULE"].Header.Text:SetFont(E.LSM:Fetch('font', module.db.miscText.objectiveHeader.font), module.db.miscText.objectiveHeader.size, module.db.miscText.objectiveHeader.outline)
			_G["WORLD_QUEST_TRACKER_MODULE"].Header.Text:SetFont(E.LSM:Fetch('font', module.db.miscText.objectiveHeader.font), module.db.miscText.objectiveHeader.size, module.db.miscText.objectiveHeader.outline)
		end

		if module.db.miscText.objective.enable then
			MakeFont(_G["ObjectiveFont"], E.LSM:Fetch('font', module.db.miscText.objective.font), module.db.miscText.objective.size, module.db.miscText.objective.outline)
			if module.BonusObjectiveBarText then module.BonusObjectiveBarText:SetFont(E.LSM:Fetch('font', module.db.miscText.objective.font), module.db.miscText.objective.size, module.db.miscText.objective.outline) end
		end
	end
end

function module:TextWidth()
	_G["ZoneTextString"]:SetWidth(module.db.zoneText.zone.width)
	_G["PVPInfoTextString"]:SetWidth(module.db.zoneText.pvp.width)
	_G["PVPArenaTextString"]:SetWidth(module.db.zoneText.pvp.width)
	_G["SubZoneTextString"]:SetWidth(module.db.zoneText.subzone.width)
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
			module:TextWidth()
			hooksecurefunc("SetZoneText", ZoneTextPos)
		end
	end
	self:ForUpdateAll()

	if module.db.zoneText.enable then
		module:TextWidth()
		hooksecurefunc("SetZoneText", ZoneTextPos)
	end

	hooksecurefunc(E, "UpdateBlizzardFonts", module.SetBlizzFonts)
	module.SetBlizzFonts()
end

MER:RegisterModule(module:GetName())
