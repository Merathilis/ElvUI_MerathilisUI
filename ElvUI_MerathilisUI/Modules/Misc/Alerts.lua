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
	return eventframe[event](self, ...)
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
local spells = {
	-- Items/Misc
	[54710] = true, -- MOLL-E
	[67826] = true,	-- Jeeves
	[199109] = true, -- Auto-Hammer
	[265116] = true, -- Unstable Temporal Time Shifter

	-- Shadowlands
	[308458] = true,	-- Surprisingly Palatable Feast
	[308462] = true,	-- Feast of Gluttonous Hedonism
	[345130] = true,	-- Disposable Spectrophasic Reanimator
	[307157] = true,	-- Eternal Cauldron
	[324029] = true,	-- Codex of the Still Mind

	-- Portals
	-- Alliance
	[10059] = true,		-- Stormwind
	[11416] = true,		-- Ironforge
	[11419] = true,		-- Darnassus
	[32266] = true,		-- Exodar
	[49360] = true,		-- Theramore
	[33691] = true,		-- Shattrath
	[88345] = true,		-- Tol Barad
	[132620] = true,	-- Vale of Eternal Blossoms
	[176246] = true,	-- Stormshield
	[281400] = true,	-- Boralus
	-- Horde
	[11417] = true,		-- Orgrimmar
	[11420] = true,		-- Thunder Bluff
	[11418] = true,		-- Undercity
	[32267] = true,		-- Silvermoon
	[49361] = true,		-- Stonard
	[35717] = true,		-- Shattrath
	[88346] = true,		-- Tol Barad
	[132626] = true,	-- Vale of Eternal Blossoms
	[176244] = true,	-- Warspear
	[281402] = true,	-- Dazar'alor
	-- Alliance/Horde
	[53142] = true,		-- Dalaran
	[120146] = true,	-- Ancient Dalaran
	[224871] = true,	-- Dalaran, Broken Isles
	[344597] = true,	-- Oribos

	[43987] = true, -- Conjure Refreshment Table
	[698] = true, -- Ritual of Summoning
}

local lastAnnounced = {}
function module:AnnounceSpell(spellID, casterName, casterServer)
	if not spellID then return end
	local fullName = casterName .. "-" .. (casterServer or "")
	lastAnnounced[fullName] = lastAnnounced[fullName] or {}
	local now = GetTime()
	local lastTime = lastAnnounced[fullName][spellID]
	if ( lastTime ~= nil and (now - lastTime) < 5 ) then return end
	lastAnnounced[fullName][spellID] = now

	local spellLink = GetSpellLink(spellID)
	local spellName = GetSpellInfo(spellID)
	local message = format(L.ANNOUNCE_FP_CAST, casterName, (spellLink or spellName))
	local channel = MER:CheckChat()
	SendChatMessage(message, channel)
end

function module:GROUP_ROSTER_UPDATE()
	if IsInGroup() then
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	else
		self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		lastAnnounced = {}
	end
end

function module:UNIT_SPELLCAST_SUCCEEDED(unitID, _, _, _, spellID)
	if not spells[spellID] then return end
	local name, server = UnitName(unitID)
	self:announceSpell(spellID, name, server)
end

function module:AddAlerts()
	if E.db.mui.misc.alerts.lfg then
		eventframe:RegisterEvent('LFG_UPDATE_RANDOM_INFO')
	end

	if E.db.mui.misc.alerts.itemAlert then
		eventframe:RegisterEvent('GROUP_ROSTER_UPDATE')
	end
end
