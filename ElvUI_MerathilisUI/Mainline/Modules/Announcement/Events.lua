local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Announcement')

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

module.EventList = {
	"CHALLENGE_MODE_COMPLETED",
	"CHAT_MSG_ADDON",
	"CHAT_MSG_SYSTEM",
	"COMBAT_LOG_EVENT_UNFILTERED",
	"GROUP_ROSTER_UPDATE",
	"PLAYER_ENTERING_WORLD",
	"QUEST_LOG_UPDATE",
}

-- CHAT_MSG_SYSTEM: text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons
function module:CHAT_MSG_SYSTEM(event, text)
	local data = {}

	self:ResetInstance(text)
end

function module:COMBAT_LOG_EVENT_UNFILTERED()
	-- https://wow.gamepedia.com/COMBAT_LOG_EVENT#Base_Parameters
	local _, event, _, _, sourceName, _, _, _, _, _, _, spellId, _, _, _ = CombatLogGetCurrentEventInfo()
	if event == "SPELL_CAST_SUCCESS" then
		self:Utility(event, sourceName, spellId)
	elseif event == "SPELL_SUMMON" then
		self:Utility(event, sourceName, spellId)
	elseif event == "SPELL_CREATE" then
		self:Utility(event, sourceName, spellId)
	end
end

function module:PLAYER_ENTERING_WORLD()
	E:Delay(2, self.Keystone, self, "PLAYER_ENTERING_WORLD")
	E:Delay(4, self.ResetAuthority, self)
end

function module:CHALLENGE_MODE_COMPLETED()
	E:Delay(2, self.Keystone, self, "CHALLENGE_MODE_COMPLETED")
end

function module:QUEST_LOG_UPDATE()
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
