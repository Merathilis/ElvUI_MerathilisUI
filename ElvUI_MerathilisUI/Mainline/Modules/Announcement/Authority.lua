local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Announcement')

local assert = assert
local format = format
local strmatch = strmatch
local strsplit = strsplit
local tonumber = tonumber

local IsInGroup = IsInGroup
local IsInRaid = IsInRaid

local C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage

local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE

module.prefix = "MER_AS"

local myServerID, myPlayerUID

local channelLevel = {
	EMOTE = 1,
	SAY = 2,
	YELL = 3,
	PARTY = 4,
	INSTANCE_CHAT = 5,
	RAID = 6,
	RAID_WARNING = 7
}

local cache = {}

local function GetBestChannel()
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		return "RAID"
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end
end

function module:InitializeAuthority()
	local successfulRequest = C_ChatInfo_RegisterAddonMessagePrefix(self.prefix)
	assert(successfulRequest, L["The addon message prefix registration is failed."])

	local guidSplitted = { strsplit("-", E.myguid) }
	myServerID = tonumber(guidSplitted[2], 10)
	myPlayerUID = tonumber(guidSplitted[3], 16)
end

function module:CheckAuthority(key)
	if IsInGroup() and cache[key] then
		if cache[key].playerUID ~= myPlayerUID or cache[key].serverID ~= myServerID then
			return false
		end
	end

	return true
end

function module:SendMyLevel(key, value)
	if not IsInGroup() or not key or not value then
		return
	end

	local message = format("%s=%s;%d;%d", key, value, myServerID, myPlayerUID)
	C_ChatInfo_SendAddonMessage(self.prefix, message, GetBestChannel())
end

function module:ReceiveLevel(message)
	if message == "RESET_AUTHORITY" then
		self:UpdatePartyInfo()
		return
	end

	local key, value, serverID, playerUID = strmatch(message, "^(.-)=([0-9]-);([0-9]-);([0-9]+)")
	value = tonumber(value)
	serverID = tonumber(serverID)
	playerUID = tonumber(playerUID)

	if not cache[key] then
		cache[key] = {
			value = value,
			serverID = serverID,
			playerUID = playerUID
		}
		return
	end

	local needUpdate = false
	if value > cache[key].value then
		needUpdate = true
	elseif value == cache[key].value then
		if serverID > cache[key].serverID then
			needUpdate = true
		elseif serverID == cache[key].serverID then
			if playerUID > cache[key].playerUID then
				needUpdate = true
			end
		end
	end

	if needUpdate then
		cache[key].value = value
		cache[key].serverID = serverID
		cache[key].playerUID = playerUID
	end
end

function module:ResetAuthority()
	if not IsInGroup() then
		return
	end

	C_ChatInfo_SendAddonMessage(self.prefix, "RESET_AUTHORITY", GetBestChannel())
end

do
	local waitSend = false
	function module:UpdatePartyInfo()
		if waitSend then
			return
		end

		if not IsInGroup() then
			return
		end

		waitSend = true
		E:Delay(0.5, function()
			if IsInGroup() then
				cache = {}
				module:SendUtilityConfig()
			end
			waitSend = false
		end)
	end
end

-- UTILITY
function module:SendUtilityConfig()
	if not self.db.utility.enable then
		return
	end

	local channel = self:GetChannel(self.db.utility.channel)
	self:SendMyLevel("UTILITY", channelLevel[channel])
end
