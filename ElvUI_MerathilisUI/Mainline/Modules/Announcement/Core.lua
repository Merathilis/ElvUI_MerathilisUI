local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Announcement')

local _G = _G

local format = format
local pairs = pairs

local IsEveryoneAssistant = IsEveryoneAssistant
local IsInGroup = IsInGroup
local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local IsPartyLFG = IsPartyLFG
local SendChatMessage = SendChatMessage
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid

local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME

--[[ Credits to this belongs to fang2hou - Windtools ]]

--[[
	Send Message
	@param {string} text The text you want to send to others
	@param {string} channel the channel in Blizzard codes format
	@param {boolean} raidWarning Let the function send raid warning if possible
	@param {string} whisperTarget The target if the channel is whisper
]]
function module:SendMessage(text, channel, raidWarning, whisperTarget)
	-- Skip if the channel is NONE
	if channel == "NONE" then
		return
	end

	-- Change channel if it is protected by Blizzard
	if channel == "YELL" or channel == "SAY" then
		if not IsInInstance() then
			channel = "SELF"
		end
	end

	if channel == "SELF" then
		_G.ChatFrame1:AddMessage(text)
		return
	end

	if channel == "WHISPER" then
		if whisperTarget then
			SendChatMessage(text, channel, nil, whisperTarget)
		end
		return
	end

	if channel == "EMOTE" then
		if self.db and self.db.emoteFormat then
			text = format(self.db.emoteFormat, text)
		else
			text = ": " .. text
		end
	end

	if channel == "RAID" and raidWarning and IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant() then
			channel = "RAID_WARNING"
		end
	end

	SendChatMessage(text, channel)
end

--[[
    @param {object} channelDB
    @return {string}
]]
function module:GetChannel(channelDB)
	if (IsPartyLFG() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE)) and
		channelDB.instance
	then
		return channelDB.instance
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) and channelDB.raid then
		return channelDB.raid
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) and channelDB.party then
		return channelDB.party
	elseif channelDB.solo and channelDB.solo then
		return channelDB.solo
	end
	return "NONE"
end

do
	local delimiterList = {
		["zhCN"] = "的",
		["zhTW"] = "的",
		["enUS"] = "'s",
		["koKR"] = "의"
	}

	function module:GetPetInfo(petName)
		E.ScanTooltip:SetOwner(_G.UIParent, "ANCHOR_NONE")
		E.ScanTooltip:ClearLines()
		E.ScanTooltip:SetUnit(petName)
		local details = E.ScanTooltip.TextLeft2:GetText()

		if not details then
			return
		end

		local delimiter = delimiterList[W.Locale] or "'s"
		local raw = { F.Strings.Split(details, delimiter) }

		local owner, role = raw[1], raw[#raw]
		if owner and role then
			return owner, role
		end

		return nil, nil
	end
end

function module:IsGroupMember(name)
	if name then
		if UnitInParty(name) then
			return 1
		elseif UnitInRaid(name) then
			return 2
		elseif name == E.myname then
			return 3
		end
	end

	return false
end

function module:Initialize()
	self.db = E.db.mui.announcement

	if not self.db.enable or self.initialized then
		return
	end

	for _, event in pairs(self.EventList) do
		module:RegisterEvent(event)
	end

	self:InitializeAuthority()
	self:ResetAuthority()
	self:UpdateBlizzardQuestAnnouncement()

	self.initialized = true
end

function module:ProfileUpdate()
	self:Initialize()
	self:UpdateBlizzardQuestAnnouncement()

	if self.db.enable or not self.initialized then
		return
	end

	for _, event in pairs(self.EventList) do
		module:UnregisterEvent(event)
	end

	self:ResetAuthority()
	self.initialized = false
end

MER:RegisterModule(module:GetName())
