local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("mUIMisc")

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
local IsInGroup = IsInGroup
local SendChatMessage = SendChatMessage
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local UnitName = UnitName
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
	local eligible, forTank, forHealer, forDamage = GetLFGRoleShortageRewards(1671, _G.LFG_ROLE_SHORTAGE_RARE) -- 1671 Random Battle For Azeroth Heroic
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
	[126459] = true, -- Blingtron 4000
	[161414] = true, -- Blingtron 5000
	[298926] = true, -- Blingtron 7000
	[185709] = true, -- Sugar-Crusted Fish Feast
	[199109] = true, -- Auto-Hammer
	[226241] = true, -- Codex of the Tranquil Mind
	[22700] = true,	-- Field Repair Bot 74A
	[256230] = true, -- Codex of the Quiet Mind
	[259409] = true, -- Galley Banquet
	[259410] = true, -- BounPtiful Captain's Feast
	[276972] = true, -- Mystical Cauldron
	[286050] = true, -- Sanguinated Feast
	[44389] = true,	-- Field Repair Bot 110G
	[54710] = true, -- MOLL-E
	[54711] = true,	-- Scrapbot
	[67826] = true,	-- Jeeves
	[265116] = true, -- Unstable Temporal Time Shifter
}

function module:ItemAlert_Update(unit, _, spellID)
	if (UnitInRaid(unit) or UnitInParty(unit)) and spellID and itemList[spellID] and lastTime ~= GetTime() then
		local who = UnitName(unit)
		local link = GetSpellLink(spellID)
		local name = GetSpellInfo(spellID)
		SendChatMessage(format("%s has placed down %s", who, link or name), MER:CheckChat())

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

function module:AddAlerts()
	if E.db.mui.misc.alerts.lfg then
		eventframe:RegisterEvent('LFG_UPDATE_RANDOM_INFO')
	end

	if E.db.mui.misc.alerts.itemAlert then
		self:PlacedItemAlert()
	end
end
