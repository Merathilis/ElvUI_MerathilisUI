local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Announcement")

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

module.EventList = {
	"CHALLENGE_MODE_COMPLETED",
	"CHAT_MSG_ADDON",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_SYSTEM",
	"COMBAT_LOG_EVENT_UNFILTERED",
	"GROUP_ROSTER_UPDATE",
	"ITEM_CHANGED",
	"PLAYER_ENTERING_WORLD",
	"QUEST_LOG_UPDATE",
	"UNIT_SPELLCAST_SUCCEEDED",
}

-- CHAT_MSG_SYSTEM: text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons
function module:CHAT_MSG_SYSTEM(event, text)
	local data = {}

	self:ResetInstance(text)
end

function module:CHAT_MSG_PARTY(event, ...)
	self:KeystoneLink(event, ...)
end

function module:CHAT_MSG_PARTY_LEADER(event, ...)
	self:KeystoneLink(event, ...)
end

function module:CHAT_MSG_GUILD(event, ...)
	self:KeystoneLink(event, ...)
end

function module:ITEM_CHANGED(event, ...)
	E:Delay(0.5, self.Keystone, self, event)
end

function module:COMBAT_LOG_EVENT_UNFILTERED()
	-- https://wow.gamepedia.com/COMBAT_LOG_EVENT#Base_Parameters
	local timestamp, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, _, _, extraSpellId =
		CombatLogGetCurrentEventInfo()

	if event == "SPELL_CAST_SUCCESS" then
		self:Utility(event, sourceName, spellId)
	elseif event == "SPELL_SUMMON" then
		self:Utility(event, sourceName, spellId)
	elseif event == "SPELL_CREATE" then
		self:Utility(event, sourceName, spellId)
	end
end

function module:PLAYER_ENTERING_WORLD(event, ...)
	self.playerEnteredWorld = true
	self:Quest()
	E:Delay(2, self.Keystone, self, event)
	E:Delay(4, self.ResetAuthority, self)
	E:Delay(10, self.ResetAuthority, self)
end

function module:CHALLENGE_MODE_COMPLETED(event, ...)
	E:Delay(2, self.Keystone, self, event)
end

function module:QUEST_LOG_UPDATE()
	if not self.playerEnteredWorld then
		return
	end
	self:Quest()
end

function module:CHAT_MSG_ADDON(_, prefix, text)
	if prefix == self.prefix then
		self:ReceiveLevel(text)
	end
end

function module:GROUP_ROSTER_UPDATE()
	self:ResetAuthority()
end
