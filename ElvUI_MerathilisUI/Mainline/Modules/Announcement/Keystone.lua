local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Announcement')

local gsub = gsub

local GetContainerItemID = GetContainerItemID
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumSlots = GetContainerNumSlots

local C_Item_IsItemKeystoneByID = C_Item.IsItemKeystoneByID
local C_MythicPlus_GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local C_MythicPlus_GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel

local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local NUM_BAG_SLOTS = NUM_BAG_SLOTS

local cache = {}

function module:Keystone(event)
	local config = self.db.keystone

	if not config or not config.enable then
		return
	end

	local mapID = C_MythicPlus_GetOwnedKeystoneChallengeMapID()
	local keystoneLevel = C_MythicPlus_GetOwnedKeystoneLevel()

	if event == "PLAYER_ENTERING_WORLD" then
		cache.mapID = mapID
		cache.keystoneLevel = keystoneLevel
	elseif event == "CHALLENGE_MODE_COMPLETED" then
		if cache.mapID ~= mapID or cache.keystoneLevel ~= keystoneLevel then
			cache.mapID = mapID
			cache.keystoneLevel = keystoneLevel
			for bagIndex = 0, NUM_BAG_SLOTS do
				for slotIndex = 1, GetContainerNumSlots(bagIndex) do
					local itemID = GetContainerItemID(bagIndex, slotIndex)
					if itemID and C_Item_IsItemKeystoneByID(itemID) then
						local message = gsub(config.text, "%%keystone%%", GetContainerItemLink(bagIndex, slotIndex))
						self:SendMessage(message, self:GetChannel(config.channel))
					end
				end
			end
		end
	end
end
