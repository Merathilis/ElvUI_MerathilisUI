local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Misc')

local _G = _G
local print, tonumber = print, tonumber
local twipe = table.wipe
local format = string.format
local gsub = gsub
local strsplit = strsplit
local Ambiguate = Ambiguate

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local CreateFrame = CreateFrame
local GetSpellInfo = GetSpellInfo
local GetSpellLink = GetSpellLink
local InCombatLockdown = InCombatLockdown
local IsInGroup = IsInGroup
local SendChatMessage = SendChatMessage
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local UnitName = UnitName

local eventframe = CreateFrame('Frame')
eventframe:SetScript('OnEvent', function(self, event, ...)
	eventframe[event](self, ...)
end)

--[[---------------------
  Item Alerts
------------------------]]
local spellList = {
	[54710] = true, -- MOLL-E
	[54711] = true,	-- Scrapbot
	[67826] = true,	-- Jeeves
	[199109] = true, -- Auto-Hammer
	[265116] = true, -- Unstable Temporal Time Shifter
	[308458] = true,	-- Surprisingly Palatable Feast
	[308462] = true,	-- Feast of Gluttonous Hedonism
	[345130] = true,	-- Disposable Spectrophasic Reanimator
	[307157] = true,	-- Eternal Cauldron
	[324029] = true,	-- Codex of the Still Mind
	[359336] = true,	 -- Kettle of Stone Soup
}

function module:ItemAlert_Update(unit, castID, spellID)
	if (UnitInRaid(unit) or UnitInParty(unit)) and spellList[spellID] and (spellList[spellID] ~= castID) then
		SendChatMessage(format(L.ANNOUNCE_FP_PRE, UnitName(unit), GetSpellLink(spellID) or GetSpellInfo(spellID)), F.CheckChat())
		spellList[spellID] = castID
	end
end

function module:ItemAlert_CheckGroup()
	if IsInGroup() then
		MER:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", module.ItemAlert_Update)
	else
		MER:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED", module.ItemAlert_Update)
	end
end

function module:PlacedItemAlert()
	module:ItemAlert_CheckGroup()

	MER:RegisterEvent("GROUP_LEFT", module.ItemAlert_CheckGroup)
	MER:RegisterEvent("GROUP_JOINED", module.ItemAlert_CheckGroup)
end

--[[---------------------
  Various Alerts
------------------------]]
local frame = CreateFrame('Frame')
frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
frame:SetScript('OnEvent', function()
	if not IsInGroup() or InCombatLockdown() then return end
	local db = E.db.mui.misc.alerts
	local _, subEvent, _, _, srcName, _, _, _, destName, _, _, spellID = CombatLogGetCurrentEventInfo()
	if not subEvent or not spellID or not srcName then return end
	if not UnitInRaid(srcName) and not UnitInParty(srcName) then return end

	local srcName = srcName:gsub('%-[^|]+', '')
	if subEvent == "SPELL_CAST_SUCCESS" then
		-- Refreshment Table
		if db.feasts and spellID == 190336 then
			SendChatMessage(format(L.ANNOUNCE_FP_PRE, srcName, GetSpellLink(spellID)), F.CheckChat())
		-- Ritual of Summoning
		elseif db.portals and spellID == 698 then
			SendChatMessage(format(L.ANNOUNCE_FP_CLICK, srcName, GetSpellLink(spellID)), F.CheckChat())
		-- Soul Well
		elseif db.feasts and spellID == 29893 then
			SendChatMessage(format(L.ANNOUNCE_FP_PRE, srcName, GetSpellLink(spellID)), F.CheckChat())
		-- Piccolo of the Flaming Fire
		elseif db.toys and spellID == 182346 then
			SendChatMessage(format(L.ANNOUNCE_FP_USE, srcName, GetSpellLink(spellID)), F.CheckChat())
		end
	elseif subEvent == "SPELL_CREATE" then
		if db.portals and MER.Announce[spellID] then
			SendChatMessage(format(L.ANNOUNCE_FP_CAST, srcName, GetSpellLink(spellID)), F.CheckChat())
		end
	end
end)

function module:AddAlerts()
	if E.db.mui.misc.alerts.itemAlert then
		self:PlacedItemAlert()
	end
end
