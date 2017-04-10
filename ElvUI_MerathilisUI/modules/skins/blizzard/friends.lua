local E, L, V, P, G = unpack(ElvUI);

-- Based on EnhancedFriendList by Azilroka
if IsAddOnLoaded("EnhancedFriendsList") then return end

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, tonumber = pairs, tonumber
local format = string.format
-- WoW API / Variables
local BNGetFriendInfo = BNGetFriendInfo
local BNGetGameAccountInfo = BNGetGameAccountInfo
local BNGetNumFriends = BNGetNumFriends
local CanCooperateWithGameAccount = CanCooperateWithGameAccount
local GetFriendInfo = GetFriendInfo
local GetLocale = GetLocale
local GetNumFriends = GetNumFriends
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetRealmName = GetRealmName
local LEVEL = LEVEL
local UnitFactionGroup = UnitFactionGroup
-- GLOBALS: BNET_CLIENT_APP, BNET_CLIENT_D3, BNET_CLIENT_HEROES, BNET_CLIENT_WOW, BNET_CLIENT_WTCG, BNET_CLIENT_PRO, LOCALIZED_CLASS_NAMES_MALE
-- GLOBALS: LOCALIZED_CLASS_NAMES_FEMALE, BNET_CLIENT_OVERWATCH, BNET_CLIENT_SC2, CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS, j

local function ColoringFriendsList()
	local friendOffset = _G["HybridScrollFrame_GetOffset"](_G["FriendsFrameFriendsScrollFrame"])
	if not friendOffset then return end
	if friendOffset < 0 then friendOffset = 0 end
	local button = "FriendsFrameFriendsScrollFrameButton"
	local _, numBNetOnline = BNGetNumFriends()
	if numBNetOnline > 0 then
		for i = 1, numBNetOnline, 1 do
			local _, realName, _, _, toonName, toonID, client, _, _, _, _, _, _, _, _ = BNGetFriendInfo(i)
			if client == BNET_CLIENT_APP then -- Battle.net App
				local icon = _G[button .. (i - friendOffset) .. "GameIcon"]
				if icon then icon:SetTexture(E["media"].app) end
				local nameString = _G[button .. (i - friendOffset) .. "Name"]
				if nameString then
					nameString:SetTextColor(125/255,133/255,138/255)
				end
				local nameString = _G[button .. (i - friendOffset) .. "Info"]
				if nameString then
					nameString:SetTextColor(125/255,133/255,138/255)
				end
			end
			if client == BNET_CLIENT_D3 then -- Diablo 3
				local icon = _G[button .. (i - friendOffset) .. "GameIcon"]
				if icon then icon:SetTexture(E["media"].d3) end
				local nameString = _G[button .. (i - friendOffset) .. "Name"]
				if nameString then
					nameString:SetTextColor(125/255,133/255,138/255)
				end
				local nameString = _G[button .. (i - friendOffset) .. "Info"]
				if nameString then
					nameString:SetTextColor(125/255,133/255,138/255)
				end
			end
			if client == BNET_CLIENT_HEROES then -- Heroes of the Storm
				local icon = _G[button .. (i - friendOffset) .. "GameIcon"]
				if icon then icon:SetTexture(E["media"].heroes) end
				local nameString = _G[button .. (i - friendOffset) .. "Name"]
				if nameString then
					nameString:SetTextColor(125/255,133/255,138/255)
				end
				local nameString = _G[button .. (i - friendOffset) .. "Info"]
				if nameString then
					nameString:SetTextColor(125/255,133/255,138/255)
				end
			end
			if client == BNET_CLIENT_WTCG then -- Hearthstone
				local icon = _G[button .. (i - friendOffset) .. "GameIcon"]
				if icon then icon:SetTexture(E["media"].wtcg) end
				local nameString = _G[button .. (i - friendOffset) .. "Name"]
				if nameString then
					nameString:SetTextColor(125/255,133/255,138/255)
				end
				local nameString = _G[button .. (i - friendOffset) .. "Info"]
				if nameString then
					nameString:SetTextColor(125/255,133/255,138/255)
				end
			end
			if client == BNET_CLIENT_OVERWATCH then -- Overwatch
				local icon = _G[button .. (i - friendOffset) .. "GameIcon"]
				if icon then icon:SetTexture(E["media"].pro) end
				local nameString = _G[button .. (i - friendOffset) .. "Name"]
				if nameString then
					nameString:SetTextColor(125/255,133/255,138/255)
				end
				local nameString = _G[button .. (i - friendOffset) .. "Info"]
				if nameString then
					nameString:SetTextColor(125/255,133/255,138/255)
				end
			end
			if client == BNET_CLIENT_SC2 then -- StarCraft 2
				local icon = _G[button .. (i - friendOffset) .. "GameIcon"]
				if icon then icon:SetTexture(E["media"].sc2) end
				local nameString = _G[button .. (i - friendOffset) .. "Name"]
				if nameString then
					nameString:SetTextColor(125/255,133/255,138/255)
				end
				local nameString = _G[button .. (i - friendOffset) .. "Info"]
				if nameString then
					nameString:SetTextColor(125/255,133/255,138/255)
				end
			end
			if client == BNET_CLIENT_WOW then -- World of Warcraft
				local _, _, _, realmName, _, faction, _, class, _, zoneName, level, _ = BNGetGameAccountInfo(toonID)
				for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
					if class == v then class = k end
				end
				if GetLocale() ~= "enUS" then
					for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
						if class == v then class = k end
					end
				end
				local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
				if not classc then return end
				local nameString = _G[button .. (i - friendOffset) .. "Name"]
				local icon = _G[button .. (i - friendOffset) .. "GameIcon"]
				if nameString then
					if (level == nil or tonumber(level) == nil) then level = 0 end
					local r, g, b = GetQuestDifficultyColor(level).r, GetQuestDifficultyColor(level).g, GetQuestDifficultyColor(level).b
					local Diff = format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
					nameString:SetTextColor(classc.r, classc.g, classc.b)
					nameString:SetText("|cFF82C4FC" .. realName .. "|r |cFFFFFFFF(|r" .. toonName .. "|cFFFFFFFF - " .. LEVEL .. "|r " .. Diff .. level .. "|r|cFFFFFFFF)|r")
					icon:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gameIcons\]] .. faction)
				end
				if CanCooperateWithGameAccount(toonID) ~= true then
					local nameString = _G[button .. (i - friendOffset) .. "Info"]
					if nameString then
						nameString:SetTextColor(125/255,133/255,138/255)
						if realmName == GetRealmName() and faction == UnitFactionGroup("unit") then
							nameString:SetText("|cFFFFFFFF" .. zoneName .. " (|r|cFFFFF573" .. realmName .. "|r|cFFFFFFFF)|r")
						elseif realmName == GetRealmName() then
							nameString:SetText(zoneName .. " (|cFFFFF573" .. realmName .. "|r)")
						else
							nameString:SetText(zoneName .. " (" .. realmName .. ")")
						end
					end
				end
			end
		end
	end
	local onlineFriends = GetNumFriends()
	if onlineFriends > 0 then
		for i = 1, onlineFriends, 1 do
			j = i + numBNetOnline
			local name, level, class, _, connected = GetFriendInfo(i)
			for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
				if class == v then class = k end
			end
			if GetLocale() ~= "enUS" then
				for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
					if class == v then class = k end
				end
			end
			local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
			if not classc then return end
			if connected then
				local nameString = _G[button .. (j - friendOffset) .. "Name"]
				local r, g, b = GetQuestDifficultyColor(level).r, GetQuestDifficultyColor(level).g, GetQuestDifficultyColor(level).b
				local Diff = format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
				if(nameString and name) then
					nameString:SetText(name .. "|cFFFFFFFF - " .. LEVEL .. "|r " .. Diff .. level)
					nameString:SetTextColor(classc.r, classc.g, classc.b)
				end
			end
		end
	end
end

hooksecurefunc("FriendsList_Update", ColoringFriendsList)
hooksecurefunc("HybridScrollFrame_Update", ColoringFriendsList)
