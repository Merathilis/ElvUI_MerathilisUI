local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_FriendsList')

local _G = _G
local format = format
local pairs = pairs
local strmatch = strmatch
local strsplit = strsplit

local BNConnected = BNConnected
local BNet_GetClientEmbeddedAtlas = BNet_GetClientEmbeddedAtlas
local FriendsFrame_Update = FriendsFrame_Update
local GetQuestDifficultyColor = GetQuestDifficultyColor

local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_ClassColor_GetClassColor = C_ClassColor.GetClassColor
local C_FriendList_GetFriendInfoByIndex = C_FriendList.GetFriendInfoByIndex

local BNET_CLIENT_APP = BNET_CLIENT_APP
local BNET_CLIENT_ARCADE = BNET_CLIENT_ARCADE
local BNET_CLIENT_ARCLIGHT = BNET_CLIENT_ARCLIGHT
local BNET_CLIENT_CLNT = BNET_CLIENT_CLNT
local BNET_CLIENT_COD = BNET_CLIENT_COD
local BNET_CLIENT_COD_BOCW = BNET_CLIENT_COD_BOCW
local BNET_CLIENT_COD_MW2 = BNET_CLIENT_COD_MW2
local BNET_CLIENT_COD_MW = BNET_CLIENT_COD_MW
local BNET_CLIENT_COD_VANGUARD = BNET_CLIENT_COD_VANGUARD
local BNET_CLIENT_CRASH4 = BNET_CLIENT_CRASH4
local BNET_CLIENT_D2 = BNET_CLIENT_D2
local BNET_CLIENT_D3 = BNET_CLIENT_D3
local BNET_CLIENT_DESTINY2 = BNET_CLIENT_DESTINY2
local BNET_CLIENT_DI = BNET_CLIENT_DI
local BNET_CLIENT_HEROES = BNET_CLIENT_HEROES
local BNET_CLIENT_OVERWATCH = BNET_CLIENT_OVERWATCH
local BNET_CLIENT_SC2 = BNET_CLIENT_SC2
local BNET_CLIENT_SC = BNET_CLIENT_SC
local BNET_CLIENT_WC3 = BNET_CLIENT_WC3
local BNET_CLIENT_WOW = BNET_CLIENT_WOW
local BNET_CLIENT_WTCG = BNET_CLIENT_WTCG

local CINEMATIC_NAME_2 = CINEMATIC_NAME_2
local CINEMATIC_NAME_3 = CINEMATIC_NAME_3

local WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE
local WOW_PROJECT_CLASSIC = WOW_PROJECT_CLASSIC
local WOW_PROJECT_CLASSIC_TBC = 5
local WOW_PROJECT_CLASSIC_WRATH = 11

local FRIENDS_TEXTURE_AFK, FRIENDS_TEXTURE_DND = FRIENDS_TEXTURE_AFK, FRIENDS_TEXTURE_DND
local FRIENDS_TEXTURE_OFFLINE, FRIENDS_TEXTURE_ONLINE = FRIENDS_TEXTURE_OFFLINE, FRIENDS_TEXTURE_ONLINE
local LOCALIZED_CLASS_NAMES_FEMALE = LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE

local FRIENDS_BUTTON_TYPE_DIVIDER = FRIENDS_BUTTON_TYPE_DIVIDER
local FRIENDS_BUTTON_TYPE_WOW = FRIENDS_BUTTON_TYPE_WOW
local FRIENDS_BUTTON_TYPE_BNET = FRIENDS_BUTTON_TYPE_BNET
local BNET_FRIEND_TOOLTIP_WOW_CLASSIC = BNET_FRIEND_TOOLTIP_WOW_CLASSIC

local MediaPath = "Interface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\FriendList\\"

--[[
    /run for i,v in pairs(_G) do if type(v)=="string" and i:match("BNET_CLIENT_") then print(i,"=",v) end end
]]

local cache = {}

local gameIcons = {
	["Alliance"] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_WOW, 16),
		Modern = MediaPath .. "GameIcons\\Alliance"
	},
	["Horde"] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_WOW, 16),
		Modern = MediaPath .. "GameIcons\\Horde"
	},
	["Neutral"] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_WOW, 16),
		Modern = MediaPath .. "GameIcons\\WoW"
	},
	[BNET_CLIENT_WOW] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_WOW, 16),
		Modern = MediaPath .. "GameIcons\\WoWSL"
	},
	[BNET_CLIENT_WOW .. "C"] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_WOW, 16),
		Modern = MediaPath .. "GameIcons\\WoW"
	},
	[BNET_CLIENT_WOW .. "C_TBC"] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_WOW, 16),
		Modern = MediaPath .. "GameIcons\\WoWC"
	},
	[BNET_CLIENT_WOW .. "C_WRATH"] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_WOW, 16),
		Modern = MediaPath .. "GameIcons\\WoWWLK"
	},
	[BNET_CLIENT_D2] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_D2, 16),
		Modern = MediaPath .. "GameIcons\\D2"
	},
	[BNET_CLIENT_D3] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_D3, 16),
		Modern = MediaPath .. "GameIcons\\D3"
	},
	[BNET_CLIENT_WTCG] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_WTCG, 16),
		Modern = MediaPath .. "GameIcons\\HS"
	},
	[BNET_CLIENT_SC] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_SC, 16),
		Modern = MediaPath .. "GameIcons\\SC"
	},
	[BNET_CLIENT_SC2] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_SC2, 16),
		Modern = MediaPath .. "GameIcons\\SC2"
	},
	[BNET_CLIENT_APP] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_APP, 16),
		Modern = MediaPath .. "GameIcons\\App"
	},
	["BSAp"] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_APP, 16),
		Modern = MediaPath .. "GameIcons\\Mobile"
	},
	[BNET_CLIENT_HEROES] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_HEROES, 16),
		Modern = MediaPath .. "GameIcons\\HotS"
	},
	[BNET_CLIENT_OVERWATCH] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_OVERWATCH, 16),
		Modern = MediaPath .. "GameIcons\\OW"
	},
	[BNET_CLIENT_COD] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_COD, 16),
		Modern = MediaPath .. "GameIcons\\COD"
	},
	[BNET_CLIENT_COD_BOCW] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_COD_BOCW, 16),
		Modern = MediaPath .. "GameIcons\\COD_CW"
	},
	[BNET_CLIENT_COD_MW] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_COD_MW, 16),
		Modern = MediaPath .. "GameIcons\\COD_MW"
	},
	[BNET_CLIENT_COD_MW2] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_COD_MW2, 16),
		Modern = MediaPath .. "GameIcons\\COD_MW2"
	},
	[BNET_CLIENT_WC3] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_WC3, 16),
		Modern = MediaPath .. "GameIcons\\WC3"
	},
	[BNET_CLIENT_CLNT] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_CLNT, 16),
		Modern = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_CLNT, 16)
	},
	[BNET_CLIENT_CRASH4] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_CRASH4, 16),
		Modern = MediaPath .. "GameIcons\\CRASH4"
	},
	[BNET_CLIENT_ARCADE] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_ARCADE, 16),
		Modern = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_ARCADE, 16)
	},
	[BNET_CLIENT_COD_VANGUARD] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_COD_VANGUARD, 16),
		Modern = MediaPath .. "GameIcons\\COD_VG"
	},
	[BNET_CLIENT_DI] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_DI, 16),
		Modern = MediaPath .. "GameIcons\\DI"
	},
	[BNET_CLIENT_ARCLIGHT] = {
		Default = BNet_GetClientEmbeddedAtlas(BNET_CLIENT_ARCLIGHT, 16),
		Modern = MediaPath .. "GameIcons\\ARCLIGHT"
	}
}

local statusIcons = {
	Default = {
		Online = FRIENDS_TEXTURE_ONLINE,
		Offline = FRIENDS_TEXTURE_OFFLINE,
		DND = FRIENDS_TEXTURE_DND,
		AFK = FRIENDS_TEXTURE_AFK
	},
	Square = {
		Online = MediaPath .. "StatusIcons\\Square\\Online",
		Offline = MediaPath .. "StatusIcons\\Square\\Offline",
		DND = MediaPath .. "StatusIcons\\Square\\DND",
		AFK = MediaPath .. "StatusIcons\\Square\\AFK"
	},
	D3 = {
		Online = MediaPath .. "StatusIcons\\D3\\Online",
		Offline = MediaPath .. "StatusIcons\\D3\\Offline",
		DND = MediaPath .. "StatusIcons\\D3\\DND",
		AFK = MediaPath .. "StatusIcons\\D3\\AFK"
	}
}

local RegionLocales = {
	[1] = L["America"],
	[2] = L["Korea"],
	[3] = L["Europe"],
	[4] = L["Taiwan"],
	[5] = L["China"]
}

local MaxLevel = {
	[BNET_CLIENT_WOW .. "C"] = 60,
	[BNET_CLIENT_WOW .. "C_TBC"] = 70,
	[BNET_CLIENT_WOW .. "C_WRATH"] = 80,
	[BNET_CLIENT_WOW] = MER.MaxLevelForPlayerExpansion
}

local classicVersionTable = {
	[WOW_PROJECT_CLASSIC] = {
		code = BNET_CLIENT_WOW .. "C",
		name = nil
	},
	[WOW_PROJECT_CLASSIC_TBC] = {
		code = BNET_CLIENT_WOW .. "C_TBC",
		name = CINEMATIC_NAME_2
	},
	[WOW_PROJECT_CLASSIC_WRATH] = {
		code = BNET_CLIENT_WOW .. "C_WRATH",
		name = CINEMATIC_NAME_3
	}
}

local BNColor = {
	[BNET_CLIENT_ARCADE] = {r = 0.509, g = 0.772, b = 1},
	[BNET_CLIENT_CRASH4] = {r = 0.509, g = 0.772, b = 1},
	[BNET_CLIENT_CLNT] = {r = 0.509, g = 0.772, b = 1},
	[BNET_CLIENT_APP] = {r = 0.509, g = 0.772, b = 1},
	[BNET_CLIENT_WC3] = {r = 0.796, g = 0.247, b = 0.145},
	[BNET_CLIENT_SC] = {r = 0.749, g = 0.501, b = 0.878},
	[BNET_CLIENT_SC2] = {r = 0.749, g = 0.501, b = 0.878},
	[BNET_CLIENT_D3] = {r = 0.768, g = 0.121, b = 0.231},
	[BNET_CLIENT_WOW] = {r = 0.866, g = 0.690, b = 0.180},
	[BNET_CLIENT_WTCG] = {r = 1, g = 0.694, b = 0},
	[BNET_CLIENT_HEROES] = {r = 0, g = 0.8, b = 1},
	[BNET_CLIENT_OVERWATCH] = {r = 1, g = 1, b = 1},
	[BNET_CLIENT_COD] = {r = 0, g = 0.8, b = 0},
	[BNET_CLIENT_COD_MW] = {r = 0, g = 0.8, b = 0},
	[BNET_CLIENT_COD_MW2] = {r = 0, g = 0.8, b = 0},
	[BNET_CLIENT_COD_BOCW] = {r = 0, g = 0.8, b = 0},
	[BNET_CLIENT_DI] = {r = 0.768, g = 0.121, b = 0.231},
	[BNET_CLIENT_ARCLIGHT] = {r = 0.945, g = 0.757, b = 0.149},
	[BNET_CLIENT_WOW .. "C"] = {r = 0.866, g = 0.690, b = 0.180},
	["BSAp"] = {r = 0.509, g = 0.772, b = 1},
}

local function GetClassColor(className)
	for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_MALE) do
		if className == localizedName then
			return C_ClassColor_GetClassColor(class)
		end
	end

	if GetLocale() == "deDE" or GetLocale() == "frFR" then
		for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
			if className == localizedName then
				return C_ClassColor_GetClassColor(class)
			end
		end
	end
end

function module:UpdateFriendButton(button)
	if not self.db.enable then
		if cache.name and cache.info then
			F.SetFontDB(button.name, cache.name)
			F.SetFontDB(button.info, cache.info)
		end
		return
	end

	if button.buttonType == FRIENDS_BUTTON_TYPE_DIVIDER then
		return
	end

	local game, realID, name, server, class, area, level, note, faction, status, isInCurrentRegion, regionID

	if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
		game = BNET_CLIENT_WOW
		local friendInfo = C_FriendList_GetFriendInfoByIndex(button.id)
		name, server = strsplit("-", friendInfo.name)
		level = friendInfo.level
		class = friendInfo.className
		area = friendInfo.area
		note = friendInfo.notes
		faction = E.myfaction

		if friendInfo.connected then
			if friendInfo.afk then
				status = "AFK"
			elseif friendInfo.dnd then
				status = "DND"
			else
				status = "Online"
			end
		else
			status = "Offline"
		end
	elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET and BNConnected() then
		local friendAccountInfo = C_BattleNet_GetFriendAccountInfo(button.id)
		if friendAccountInfo then
			realID = friendAccountInfo.accountName
			note = friendAccountInfo.note

			local gameAccountInfo = friendAccountInfo.gameAccountInfo
			game = gameAccountInfo.clientProgram

			if gameAccountInfo.isOnline then
				if friendAccountInfo.isAFK or gameAccountInfo.isGameAFK then
					status = "AFK"
				elseif friendAccountInfo.isDND or gameAccountInfo.isGameBusy then
					status = "DND"
				else
					status = "Online"
				end
			else
				status = "Offline"
			end

			-- Fetch version if friend playing WoW
			if game == BNET_CLIENT_WOW then
				name = gameAccountInfo.characterName or ""
				level = gameAccountInfo.characterLevel or 0
				faction = gameAccountInfo.factionName or nil
				class = gameAccountInfo.className or ""
				area = gameAccountInfo.areaName or ""
				isInCurrentRegion = gameAccountInfo.isInCurrentRegion or false
				regionID = gameAccountInfo.regionID or false

				if classicVersionTable[gameAccountInfo.wowProjectID] then
					local versionInfomation = classicVersionTable[gameAccountInfo.wowProjectID]
					game = versionInfomation.code
					local versionSuffix = versionInfomation.name and " (" .. versionInfomation.name .. ")" or ""
					local serverStrings = {strsplit(" - ", gameAccountInfo.richPresence)}
					server = (serverStrings[#serverStrings] or BNET_FRIEND_TOOLTIP_WOW_CLASSIC .. versionSuffix) .. "*"
				else
					server = gameAccountInfo.realmDisplayName or ""
				end
			end
		end
	end

	if status then
		button.status:SetTexture(statusIcons[self.db.textures.status][status])
	end

	if game and game ~= "" then
		local buttonTitle, buttonText

		-- Override Real ID or name with note
		if self.db.useNoteAsName and note and note ~= "" then
			if realID then
				realID = note
			else
				name = note
			end
		end

		-- Real ID
		local realIDString =
			realID and self.db.useGameColor and BNColor[game] and F.CreateColorString(realID, BNColor[game]) or realID

		local nameString = name

		local classColor = GetClassColor(class)
		if self.db.useClassColor and classColor then
			nameString = F.CreateColorString(name, classColor)
		end

		if self.db.level then
			if level and level ~= 0 and MaxLevel[game] and (level ~= MaxLevel[game] or not self.db.hideMaxLevel) then
				nameString = nameString .. F.CreateColorString(": " .. level, GetQuestDifficultyColor(level))
			end
		end

		if nameString and realIDString then
			buttonTitle = realIDString .. " \124\124 " .. nameString
		elseif nameString then
			buttonTitle = nameString
		else
			buttonTitle = realIDString or ""
		end

		button.name:SetText(buttonTitle)

		if area then
			if server and server ~= "" and server ~= E.myrealm then
				buttonText = F.CreateColorString(area .. " - " .. server, self.db.areaColor)
			else
				buttonText = F.CreateColorString(area, self.db.areaColor)
			end

			if not isInCurrentRegion and RegionLocales[regionID] and not E.db.mui.blizzard.filter.unblockProfanityFilter then
				-- Unblocking profanity filter will change the region
				local regionText = format("[%s]", RegionLocales[regionID])
				buttonText = buttonText .. " " .. F.CreateColorString(regionText, {r = 0.62, g = 0.62, b = 0.62})
			end

			button.info:SetText(buttonText)
		end

		local iconGroup = self.db.textures.factionIcon and faction or game
		local iconTex = gameIcons[iconGroup] and gameIcons[iconGroup][self.db.textures.game] or BNet_GetClientEmbeddedAtlas(game)..name
		button.gameIcon:SetTexture(iconTex)
		button.gameIcon:Show()
		button.gameIcon:SetAlpha(1)

		if button.summonButton:IsShown() then
			button.gameIcon:Hide()
		else
			button.gameIcon:Show()
			button.gameIcon:Point("TOPRIGHT", -21, -2)
		end
	else
		if self.db.useNoteAsName and note and note ~= "" then
			button.name:SetText(note)
		end
	end

	if not cache.name then
		local name, size, style = button.name:GetFont()
		cache.name = {
			name = name,
			size = size,
			style = style
		}
	end

	if not cache.info then
		local name, size, style = button.info:GetFont()
		cache.info = {
			name = name,
			size = size,
			style = style
		}
	end

	F.SetFontOutline(button.name)
	F.SetFontDB(button.name, self.db.nameFont)

	F.SetFontOutline(button.info)
	F.SetFontDB(button.info, self.db.infoFont)

	if button.Favorite:IsShown() then
		button.Favorite:ClearAllPoints()
		button.Favorite:Point("LEFT", button.name, "LEFT", button.name:GetStringWidth(), 0)
	end
end

function module:Initialize()
	if not E.db.mui.blizzard.friendsList.enable then
		return
	end

	self.db = E.db.mui.blizzard.friendsList

	self:SecureHook("FriendsFrame_UpdateFriendButton", "UpdateFriendButton")
	self.initialized = true
end

function module:ProfileUpdate()
	self.db = E.db.mui.blizzard.friendsList

	if self.db and self.db.enable and not self.initialized then
		self:SecureHook("FriendsFrame_UpdateFriendButton", "UpdateFriendButton")
	end

	FriendsFrame_Update()
end

MER:RegisterModule(module:GetName())
