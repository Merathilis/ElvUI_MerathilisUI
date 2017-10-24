local MER, E, L, V, P, G = unpack(select(2, ...))
local EFL = E:NewModule("EnhancedFriendsList")
local LSM = LibStub("LibSharedMedia-3.0")
EFL.modName = L["EnhancedFriendsList"]

-- Cache global variables
-- Lua functions
local format = string.format

-- WoW API / Variables

--GLOBALS: hooksecurefunc

local MediaPath = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\"

EFL.GameIcons = {
	Default = {
		Alliance = BNet_GetClientTexture(BNET_CLIENT_WOW ),
		Horde = BNet_GetClientTexture(BNET_CLIENT_WOW ),
		Neutral = BNet_GetClientTexture(BNET_CLIENT_WOW ),
		D3 = BNet_GetClientTexture(BNET_CLIENT_D3),
		WTCG = BNet_GetClientTexture(BNET_CLIENT_WTCG),
		S1 = BNet_GetClientTexture(BNET_CLIENT_SC),
		S2 = BNet_GetClientTexture(BNET_CLIENT_SC2),
		App = BNet_GetClientTexture(BNET_CLIENT_APP),
		BSAp = BNet_GetClientTexture(BNET_CLIENT_APP),
		Hero = BNet_GetClientTexture(BNET_CLIENT_HEROES),
		Pro = BNet_GetClientTexture(BNET_CLIENT_OVERWATCH),
		DST2 = BNet_GetClientTexture(BNET_CLIENT_DESTINY2),
	},
	BlizzardChat = {
		Alliance = "Interface\\ChatFrame\\UI-ChatIcon-WoW",
		Horde = "Interface\\ChatFrame\\UI-ChatIcon-WoW",
		Neutral = "Interface\\ChatFrame\\UI-ChatIcon-WoW",
		D3 = "Interface\\ChatFrame\\UI-ChatIcon-D3",
		WTCG = "Interface\\ChatFrame\\UI-ChatIcon-WTCG",
		S1 = "Interface\\ChatFrame\\UI-ChatIcon-SC",
		S2 = "Interface\\ChatFrame\\UI-ChatIcon-SC2",
		App = "Interface\\ChatFrame\\UI-ChatIcon-Battlenet",
		BSAp = "Interface\\ChatFrame\\UI-ChatIcon-Battlenet",
		Hero = "Interface\\ChatFrame\\UI-ChatIcon-HotS",
		Pro = "Interface\\ChatFrame\\UI-ChatIcon-Overwatch",
		DST2 = "Interface\\ChatFrame\\UI-ChatIcon-Destiny2",
	},
	Flat = {
		Alliance = MediaPath.."GameIcons\\Flat\\Alliance",
		Horde = MediaPath.."GameIcons\\Flat\\Horde",
		Neutral = MediaPath.."GameIcons\\Flat\\Neutral",
		D3 = MediaPath.."GameIcons\\Flat\\D3",
		WTCG = MediaPath.."GameIcons\\Flat\\Hearthstone",
		S1 = "Interface\\ChatFrame\\UI-ChatIcon-SC",
		S2 = MediaPath.."GameIcons\\Flat\\SC2",
		App = MediaPath.."GameIcons\\Flat\\BattleNet",
		BSAp = MediaPath.."GameIcons\\Flat\\BattleNet",
		Hero = MediaPath.."GameIcons\\Flat\\Heroes",
		Pro = MediaPath.."GameIcons\\Flat\\Overwatch",
		DST2 = "Interface\\ChatFrame\\UI-ChatIcon-Destiny2",
	},
	Gloss = {
		Alliance = MediaPath.."GameIcons\\Gloss\\Alliance",
		Horde = MediaPath.."GameIcons\\Gloss\\Horde",
		Neutral = MediaPath.."GameIcons\\Gloss\\Neutral",
		D3 = MediaPath.."GameIcons\\Gloss\\D3",
		WTCG = MediaPath.."GameIcons\\Gloss\\Hearthstone",
		S1 = "Interface\\ChatFrame\\UI-ChatIcon-SC",
		S2 = MediaPath.."GameIcons\\Gloss\\SC2",
		App = MediaPath.."GameIcons\\Gloss\\BattleNet",
		BSAp = MediaPath.."GameIcons\\Gloss\\BattleNet",
		Hero = MediaPath.."GameIcons\\Gloss\\Heroes",
		Pro = MediaPath.."GameIcons\\Gloss\\Overwatch",
		DST2 = "Interface\\ChatFrame\\UI-ChatIcon-Destiny2",
	},
	Launcher = {
		Alliance = MediaPath.."GameIcons\\Launcher\\WoW",
		Horde = MediaPath.."GameIcons\\Launcher\\WoW",
		Neutral = MediaPath.."GameIcons\\Launcher\\WoW",
		D3 = MediaPath.."GameIcons\\Launcher\\D3",
		WTCG = MediaPath.."GameIcons\\Launcher\\Hearthstone",
		S1 = MediaPath.."GameIcons\\Launcher\\SC",
		S2 = MediaPath.."GameIcons\\Launcher\\SC2",
		App = MediaPath.."GameIcons\\Launcher\\BattleNet",
		BSAp = "Interface\\FriendsFrame\\PlusManz-BattleNet",
		Hero = MediaPath.."GameIcons\\Launcher\\Heroes",
		Pro = MediaPath.."GameIcons\\Launcher\\Overwatch",
		DST2 = MediaPath.."GameIcons\\Launcher\\Destiny2",
	},
}

EFL.StatusIcons = {
	Default = {
		Online = FRIENDS_TEXTURE_ONLINE,
		Offline = FRIENDS_TEXTURE_OFFLINE,
		DND = FRIENDS_TEXTURE_DND,
		AFK = FRIENDS_TEXTURE_AFK,
	},
	Square = {
		Online = MediaPath.."StatusIcons\\Square\\Online",
		Offline = MediaPath.."StatusIcons\\Square\\Offline",
		DND = MediaPath.."StatusIcons\\Square\\DND",
		AFK = MediaPath.."StatusIcons\\Square\\AFK",
	},
	D3 = {
		Online = MediaPath.."StatusIcons\\D3\\Online",
		Offline = MediaPath.."StatusIcons\\D3\\Offline",
		DND = MediaPath.."StatusIcons\\D3\\DND",
		AFK = MediaPath.."StatusIcons\\D3\\AFK",
	},
}

local ClientColor = {
	S1 = "C495DD",
	S2 = "C495DD",
	D3 = "C41F3B",
	Pro = "00C0FA",
	WTCG = "4EFF00",
	Hero = "00CCFF",
	App = "82C5FF",
	DST2 = "00C0FA",
}

local function getDiffColorString(level)
	local color = GetQuestDifficultyColor(level)
	return E:RGBToHex(color.r, color.g, color.b)
end

function EFL:BasicUpdateFriends(button)
	local nameText, nameColor, infoText, broadcastText, _
	if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
		local name, level, class, area, connected, status, note = GetFriendInfo(button.id)
		broadcastText = nil
		if connected then
			button.status:SetTexture(EFL.StatusIcons[E.db.mui.efl["StatusIconPack"]][(status == CHAT_FLAG_DND and 'DND' or status == CHAT_FLAG_AFK and "AFK" or "Online")])
			nameText = MER:GetClassColorString(class) .. name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, getDiffColorString(level) .. level .. "|r", class)
			nameColor = FRIENDS_WOW_NAME_COLOR
			Cooperate = true
		else
			button.status:SetTexture(EFL.StatusIcons[E.db.mui.efl["StatusIconPack"]].Offline)
			nameText = name
			nameColor = FRIENDS_GRAY_COLOR
		end
		infoText = area
	elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET and BNConnected() then
		local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(button.id)
		local realmName, realmID, faction, race, class, zoneName, level, gameText
		broadcastText = messageText
		local characterName = toonName
		if presenceName then
			nameText = presenceName
			if isOnline and not characterName and battleTag then
				characterName = battleTag
			end
		elseif givenName then
			nameText = givenName
		else
			nameText = UNKNOWN
		end

		if characterName then
			_, _, _, realmName, realmID, faction, race, class, _, zoneName, level, gameText = BNGetGameAccountInfo(toonID)
			if client == BNET_CLIENT_WOW then
				if (level == nil or tonumber(level) == nil) then level = 0 end
				local classcolor = MER:GetClassColorString(class)
				local diff = level ~= 0 and format("|cFF%02x%02x%02x", GetQuestDifficultyColor(level).r * 255, GetQuestDifficultyColor(level).g * 255, GetQuestDifficultyColor(level).b * 255) or "|cFFFFFFFF"
				nameText = format("%s |cFFFFFFFF(|r%s%s|r - %s %s%s|r|cFFFFFFFF)|r", nameText, classcolor, characterName, LEVEL, diff, level)
				Cooperate = CanCooperateWithGameAccount(toonID)
			else
				nameText = format("|cFF%s%s|r", ClientColor[client] or "e59400", nameText)
			end
		end

		if isOnline then
			button.status:SetTexture(EFL.StatusIcons[E.db.mui.efl["StatusIconPack"]][(status == CHAT_FLAG_DND and "DND" or status == CHAT_FLAG_AFK and "AFK" or "Online")])
			if client == BNET_CLIENT_WOW then
				if not zoneName or zoneName == "" then
					infoText = UNKNOWN
				else
					if realmName == E.myRealm then
						infoText = zoneName
					else
						infoText = format("%s - %s", zoneName, realmName)
					end
				end
				button.gameIcon:SetTexture(EFL.GameIcons[E.db.mui.efl["GameIconPack"]][faction])
			else
				infoText = gameText
				button.gameIcon:SetTexture(EFL.GameIcons[E.db.mui.efl["GameIconPack"]][client])
			end
			nameColor = FRIENDS_BNET_NAME_COLOR
		else
			button.status:SetTexture(EFL.StatusIcons[E.db.mui.efl["StatusIconPack"]].Offline)
			nameColor = FRIENDS_GRAY_COLOR
			infoText = lastOnline == 0 and FRIENDS_LIST_OFFLINE or format(BNET_LAST_ONLINE_TIME, FriendsFrame_GetLastOnline(lastOnline))
		end
	end

	if button.summonButton:IsShown() then
		button.gameIcon:SetPoint("TOPRIGHT", -50, -2)
	else
		button.gameIcon:SetPoint("TOPRIGHT", -21, -2)
	end

	if nameText then
		button.name:SetText(nameText)
		button.name:SetTextColor(nameColor.r, nameColor.g, nameColor.b)
		button.info:SetText(infoText)
		button.info:SetTextColor(.49, .52, .54)
		if Cooperate then
			button.info:SetTextColor(1, .96, .45)
		end
		if LSM then
			button.name:SetFont(LSM:Fetch("font", E.db.mui.efl.NameFont), E.db.mui.efl.NameFontSize, E.db.mui.efl.NameFontFlag)
			button.info:SetFont(LSM:Fetch("font",E.db.mui.efl.InfoFont), E.db.mui.efl.InfoFontSize, E.db.mui.efl.InfoFontFlag)
		end
	end
end

function EFL:Initialize()
	hooksecurefunc("FriendsFrame_UpdateFriendButton", function(button) EFL:BasicUpdateFriends(button) end)
end

local function InitializeCallback()
	EFL:Initialize()
end

E:RegisterModule(EFL:GetName(), InitializeCallback)