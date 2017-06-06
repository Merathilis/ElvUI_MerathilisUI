local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
local _G = _G
-- Lua functions
local format, gsub = string.format, string.gsub
-- WoW API
local BNGetFriendInfo = BNGetFriendInfo
local BNGetGameAccountInfo = BNGetGameAccountInfo
local GetFriendInfo = GetFriendInfo
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetRealZoneText = GetRealZoneText

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%%d", "%%s")
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%$d", "%$s")

local BC = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	BC[v] = k
end

for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	BC[v] = k
end

local function getDiffColorString(level)
	local color = GetQuestDifficultyColor(level)
	return E:RGBToHex(color.r, color.g, color.b)
end

local function getClassColorString(class)
	local color = MER.colors.class[BC[class] or class]
	return E:RGBToHex(color.r, color.g, color.b)
end

local function updateFriendsColor()
	local scrollFrame = FriendsFrameFriendsScrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons

	local playerArea = GetRealZoneText()

	for i = 1, #buttons do
		local nameText, infoText, button, index
		button = buttons[i]
		index = offset + i
		if(button:IsShown()) then
			if ( button.buttonType == FRIENDS_BUTTON_TYPE_WOW ) then
				local name, level, class, area, connected, status, note = GetFriendInfo(button.id)
				if(connected) then
					nameText = getClassColorString(class) .. name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, getDiffColorString(level) .. level .. '|r', class)
					if(area == playerArea) then
						infoText = format('|cff00ff00%s|r', area)
					end
				end
			elseif (button.buttonType == FRIENDS_BUTTON_TYPE_BNET) then
				local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(button.id)
				if(isOnline and client==BNET_CLIENT_WOW) then
					local hasFocus, toonName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText, broadcastText, broadcastTime = BNGetGameAccountInfo(toonID)
					if(presenceName and toonName and class) then
						nameText = presenceName .. ' ' .. FRIENDS_WOW_NAME_COLOR_CODE..'('..
						getClassColorString(class) .. toonName .. FRIENDS_WOW_NAME_COLOR_CODE .. ')'
						if(zoneName == playerArea) then
							infoText = format('|cff00ff00%s|r', zoneName)
						end
					end
				end
			end
		end

		if(nameText) then
			button.name:SetText(nameText)
		end
		if(infoText) then
			button.info:SetText(infoText)
		end
	end
end

local function styleFriends()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.friends ~= true or E.private.muiSkins.blizzard.friends ~= true then return end

	for i = 1, FRIENDS_TO_DISPLAY do
		local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
		local ic = _G["FriendsFrameFriendsScrollFrameButton"..i.."GameIcon"]

		ic:Size(22, 22)
		ic:SetTexCoord(.15, .85, .15, .85)

		ic:ClearAllPoints()
		ic:Point("RIGHT", bu, "RIGHT", -24, 0)
		ic.SetPoint = MER.dummy
	end

	MERS:CreateGradient(FriendsListFrame)
	if not FriendsListFrame.stripes then
		MERS:CreateStripes(FriendsListFrame)
	end
	MERS:CreateGradient(WhoFrame)
	if not WhoFrame.stripes then
		MERS:CreateStripes(WhoFrame)
	end
	MERS:CreateGradient(ChannelFrame)
	if not ChannelFrame.stripes then
		MERS:CreateStripes(ChannelFrame)
	end
	MERS:CreateGradient(RaidFrame)
	if not RaidFrame.stripes then
		MERS:CreateStripes(RaidFrame)
	end

	hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", updateFriendsColor)
	hooksecurefunc("FriendsFrame_UpdateFriends", updateFriendsColor)
end

S:AddCallback("mUIFriends", styleFriends)