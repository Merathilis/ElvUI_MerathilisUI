local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Announcement") ---@class Announcement

local gsub = gsub

local GetContainerItemID = C_Container.GetContainerItemID
local GetContainerItemLink = C_Container.GetContainerItemLink
local GetContainerNumSlots = C_Container.GetContainerNumSlots

local IsItemKeystoneByID = C_Item.IsItemKeystoneByID
local GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel

local NUM_BAG_SLOTS = NUM_BAG_SLOTS

local cache = {}

local function getKeystoneLink()
	for bagIndex = 0, NUM_BAG_SLOTS do
		for slotIndex = 1, GetContainerNumSlots(bagIndex) do
			local itemID = GetContainerItemID(bagIndex, slotIndex)
			if itemID and IsItemKeystoneByID(itemID) then
				return GetContainerItemLink(bagIndex, slotIndex)
			end
		end
	end
end

function module:Keystone(event)
	local config = self.db.keystone

	if not config or not config.enable then
		return
	end

	local mapID = GetOwnedKeystoneChallengeMapID()
	local keystoneLevel = GetOwnedKeystoneLevel()

	if event == "PLAYER_ENTERING_WORLD" then
		cache.mapID = mapID
		cache.keystoneLevel = keystoneLevel
	elseif event == "CHALLENGE_MODE_COMPLETED" or event == "ITEM_CHANGED" then
		if cache.mapID ~= mapID or cache.keystoneLevel ~= keystoneLevel then
			cache.mapID = mapID
			cache.keystoneLevel = keystoneLevel
			local link = getKeystoneLink()
			if link then
				local message = gsub(config.text, "%%keystone%%", link)
				self:SendMessage(message, self:GetChannel(config.channel))
			end
		end
	end
end

function module:KeystoneLink(event, text)
	local config = self.db.keystone

	if not config or not config.enable or not config.command then
		return
	end

	if strlower(text) ~= "!keys" then
		return
	end

	local channel
	if event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
		channel = "PARTY"
	elseif event == "CHAT_MSG_GUILD" then
		channel = "GUILD"
	end

	if channel then
		local link = getKeystoneLink()
		if link then
			self:SendMessage(link, channel)
		end
	end
end
