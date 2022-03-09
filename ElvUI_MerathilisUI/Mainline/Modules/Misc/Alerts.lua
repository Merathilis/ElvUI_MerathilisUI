local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Misc')

--Cache global variables
--Lua functions
local _G = _G
local print, tonumber = print, tonumber
local twipe = table.wipe
local format = string.format
local gsub = gsub
local strsplit = strsplit
local Ambiguate = Ambiguate
--WoW API / Variables
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage
local C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix
local C_LFGList_GetAvailableRoles = C_LFGList.GetAvailableRoles
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local ChatTypeInfo = ChatTypeInfo
local CreateFrame = CreateFrame
local GetTime = GetTime
local IsInGuild = IsInGuild
local IsInGroup = IsInGroup
local IsPartyLFG = IsPartyLFG
local IsInRaid = IsInRaid
local GetLFGRoleShortageRewards = GetLFGRoleShortageRewards
local PlaySound = PlaySound
local RaidNotice_AddMessage = RaidNotice_AddMessage
local GetSpellInfo = GetSpellInfo
local GetSpellLink = GetSpellLink
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsInGroup = IsInGroup
local SendChatMessage = SendChatMessage
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local UnitName = UnitName
local TANKE, HEALER, DAMAGER = TANK, HEALER, DAMAGER
-- GLOBALS:

local eventframe = CreateFrame('Frame')
eventframe:SetScript('OnEvent', function(self, event, ...)
	eventframe[event](self, ...)
end)

--[[---------------------
  LFG Call to Arms rewards
------------------------]]
local LFG_Timer = 0
function eventframe:LFG_UPDATE_RANDOM_INFO()
	local _, forTank, forHealer, forDamage = GetLFGRoleShortageRewards(2087, _G.LFG_ROLE_SHORTAGE_RARE) -- 2087 Random Shadowlands Heroic
	local IsTank, IsHealer, IsDamage = C_LFGList_GetAvailableRoles()

	local ingroup, tank, healer, damager, result

	tank = IsTank and forTank and "|cff00B2EE"..TANK.."|r" or ""
	healer = IsHealer and forHealer and "|cff00EE00"..HEALER.."|r" or ""
	damager = IsDamage and forDamage and "|cffd62c35"..DAMAGER.."|r" or ""

	if IsInGroup(_G.LE_PARTY_CATEGORY) or IsInGroup(_G.LE_PARTY_CATEGORY_INSTANCE) then
		ingroup = true
	end

	if ((IsTank and forTank) or (IsHealer and forHealer) or (IsDamage and forDamage)) and not ingroup then
		if GetTime() - LFG_Timer > 20 then
			PlaySound(8959) --Sound\\Interface\\RaidWarning.ogg
			RaidNotice_AddMessage(_G.RaidWarningFrame, format(_G.LFG_CALL_TO_ARMS, tank.." "..healer.." "..damager), ChatTypeInfo["RAID_WARNING"])
			MER:Print(format(_G.LFG_CALL_TO_ARMS, tank.." "..healer.." "..damager))
			LFG_Timer = GetTime()
		end
	end
end

--[[---------------------
  Item Alerts
------------------------]]
local lastTime = 0
local itemList = {
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

function module:ItemAlert_Update(unit, _, spellID)
	if (UnitInRaid(unit) or UnitInParty(unit)) and spellID and itemList[spellID] and lastTime ~= GetTime() then
		local who = UnitName(unit)
		local link = GetSpellLink(spellID)
		local name = GetSpellInfo(spellID)
		SendChatMessage(format(L.ANNOUNCE_FP_PRE, who, link or name), MER:CheckChat())

		lastTime = GetTime()
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
	self:ItemAlert_CheckGroup()

	MER:RegisterEvent("GROUP_LEFT", self.ItemAlert_CheckGroup)
	MER:RegisterEvent("GROUP_JOINED", self.ItemAlert_CheckGroup)
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
			SendChatMessage(format(L.ANNOUNCE_FP_PRE, srcName, GetSpellLink(spellID)), MER:CheckChat())
		-- Ritual of Summoning
		elseif db.portals and spellID == 698 then
			SendChatMessage(format(L.ANNOUNCE_FP_CLICK, srcName, GetSpellLink(spellID)), MER:CheckChat())
		-- Soul Well
		elseif db.feasts and spellID == 29893 then
			SendChatMessage(format(L.ANNOUNCE_FP_PRE, srcName, GetSpellLink(spellID)), MER:CheckChat())
		-- Piccolo of the Flaming Fire
		elseif db.toys and spellID == 182346 then
			SendChatMessage(format(L.ANNOUNCE_FP_USE, srcName, GetSpellLink(spellID)), MER:CheckChat())
		end
	elseif subEvent == "SPELL_CREATE" then
		if db.portals and MER.Announce[spellID] then
			SendChatMessage(format(L.ANNOUNCE_FP_CAST, srcName, GetSpellLink(spellID)), MER:CheckChat())
		end
	end
end)

function module:AddAlerts()
	if E.db.mui.misc.alerts.lfg then
		eventframe:RegisterEvent('LFG_UPDATE_RANDOM_INFO')
	end

	if E.db.mui.misc.alerts.itemAlert then
		self:PlacedItemAlert()
	end
end
