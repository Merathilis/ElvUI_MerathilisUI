local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_FriendsList')

local _G = _G
local format = format
local pairs = pairs
local strmatch = strmatch
local strsplit = strsplit

local BNConnected = BNConnected
local BNet_GetClientAtlas = BNet_GetClientAtlas
local FriendsFrame_Update = FriendsFrame_Update
local GetQuestDifficultyColor = GetQuestDifficultyColor

local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_ClassColor_GetClassColor = C_ClassColor.GetClassColor
local C_FriendList_GetFriendInfoByIndex = C_FriendList.GetFriendInfoByIndex

local BNET_FRIEND_TOOLTIP_WOW_CLASSIC = BNET_FRIEND_TOOLTIP_WOW_CLASSIC
local FRIENDS_BUTTON_TYPE_BNET = FRIENDS_BUTTON_TYPE_BNET
local FRIENDS_BUTTON_TYPE_DIVIDER = FRIENDS_BUTTON_TYPE_DIVIDER
local FRIENDS_BUTTON_TYPE_WOW = FRIENDS_BUTTON_TYPE_WOW
local FRIENDS_TEXTURE_AFK = FRIENDS_TEXTURE_AFK
local FRIENDS_TEXTURE_DND = FRIENDS_TEXTURE_DND
local FRIENDS_TEXTURE_OFFLINE = FRIENDS_TEXTURE_OFFLINE
local FRIENDS_TEXTURE_ONLINE = FRIENDS_TEXTURE_ONLINE
local LOCALIZED_CLASS_NAMES_FEMALE = LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE
local WOW_PROJECT_BURNING_CRUSADE_CLASSIC = 5
local WOW_PROJECT_CLASSIC = 2
local WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE
local WOW_PROJECT_WRATH_CLASSIC = 11

local MediaPath = "Interface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\FriendList\\"

--[[
	/run for i,v in pairs(_G) do if type(v)=="string" and i:match("BNET_CLIENT_") then print(i,"=",v) end end
]]

local cache = {}

-- Manully code the atlas "battlenetclienticon"
-- note: Destiny 2 is not included
local projectCodes = {
	["ANBS"] = "Diablo Immortal",
	["Hero"] = "Heroes of the Storm",
	["OSI"] = "Diablo II",
	["S2"] = "StarCraft II",
	["VIPR"] = "Call of Duty: Black Ops 4",
	["W3"] = "WarCraft III",
	["APP"] = "Battle.net App",
	["FORE"] = "Call of Duty: Vanguard",
	["LAZR"] = "Call of Duty: MW2 Campaign Remastered",
	["RTRO"] = "Blizzard Arcade Collection",
	["WLBY"] = "Crash Bandicoot 4: It's About Time",
	["WTCG"] = "Hearthstone",
	["ZEUS"] = "Call of Duty: Blac Ops Cold War",
	["D3"] = "Diablo III",
	["GRY"] = "Warcraft Arclight Rumble",
	["ODIN"] = "Call of Duty: Mordern Warfare II",
	["S1"] = "StarCraft",
	["WOW"] = "World of Warcraft",
	["PRO"] = "Overwatch",
	["PRO-ZHCN"] = "Overwatch"
}

local clientData = {
	["Diablo Immortal"] = {
		color = { r = 0.768, g = 0.121, b = 0.231 }
	},
	["Heroes of the Storm"] = {
		color = { r = 0, g = 0.8, b = 1 }
	},
	["Diablo II"] = {
		color = { r = 0.768, g = 0.121, b = 0.231 }
	},
	["StarCraft II"] = {
		color = { r = 0.749, g = 0.501, b = 0.878 }
	},
	["Call of Duty: Black Ops 4"] = {
		color = { r = 0, g = 0.8, b = 0 }
	},
	["WarCraft III"] = {
		color = { r = 0.796, g = 0.247, b = 0.145 }
	},
	["Battle.net App"] = {
		color = { r = 0.509, g = 0.772, b = 1 }
	},
	["Call of Duty: Vanguard"] = {
		color = { r = 0, g = 0.8, b = 0 }
	},
	["Call of Duty: MW2 Campaign Remastered"] = {
		color = { r = 0, g = 0.8, b = 0 }
	},
	["Blizzard Arcade Collection"] = {
		color = { r = 0.509, g = 0.772, b = 1 }
	},
	["Crash Bandicoot 4: It's About Time"] = {
		color = { r = 0.509, g = 0.772, b = 1 }
	},
	["Hearthstone"] = {
		color = { r = 1, g = 0.694, b = 0 }
	},
	["Call of Duty: Blac Ops Cold War"] = {
		color = { r = 0, g = 0.8, b = 0 }
	},
	["Diablo III"] = {
		color = { r = 0.768, g = 0.121, b = 0.231 }
	},
	["Warcraft Arclight Rumble"] = {
		color = { r = 0.945, g = 0.757, b = 0.149 }
	},
	["Call of Duty: Mordern Warfare II"] = {
		color = { r = 0, g = 0.8, b = 0 }
	},
	["StarCraft"] = {
		color = { r = 0.749, g = 0.501, b = 0.878 }
	},
	["World of Warcraft"] = {
		color = { r = 0.866, g = 0.690, b = 0.180 }
	},
	["Overwatch"] = {
		color = { r = 1, g = 1, b = 1 }
	}
}

for code, name in pairs(projectCodes) do
	if clientData[name] then
		if code ~= "PRO-ZHCN" then -- There is a special Overwatch Chinese version
			clientData[name]["icon"] = {
				modern = MediaPath .. "GameIcons\\" .. code,
				blizzard = BNet_GetClientAtlas("Battlenet-ClientIcon-", code)
			}
		end
	end
end

local expansionData = {
	[WOW_PROJECT_MAINLINE] = {
		name = "Retail",
		suffix = nil,
		maxLevel = GetMaxLevelForPlayerExpansion(),
		icon = {
			modern = MediaPath .. "GameIcons\\WOW_Retail",
			blizzard = BNet_GetClientAtlas("Battlenet-ClientIcon-", "WoW")
		}
	},
	[WOW_PROJECT_CLASSIC] = {
		name = "Classic",
		suffix = "Classic",
		maxLevel = 60,
		icon = {
			modern = MediaPath .. "GameIcons\\WOW_Classic",
			blizzard = BNet_GetClientAtlas("Battlenet-ClientIcon-", "WoW")
		}
	},
	[WOW_PROJECT_BURNING_CRUSADE_CLASSIC] = {
		name = "TBC",
		suffix = "TBC",
		maxLevel = 70,
		icon = {
			modern = MediaPath .. "GameIcons\\WOW_TBC",
			blizzard = BNet_GetClientAtlas("Battlenet-ClientIcon-", "WoW")
		}
	},
	[WOW_PROJECT_WRATH_CLASSIC] = {
		name = "WotLK",
		suffix = "WotLK",
		maxLevel = 80,
		icon = {
			modern = MediaPath .. "GameIcons\\WOW_WotLK",
			blizzard = BNet_GetClientAtlas("Battlenet-ClientIcon-", "WoW")
		}
	}
}

local factionIcons = {
	["Alliance"] = MediaPath .. "Alliance",
	["Horde"] = MediaPath .. "Horde"
}

local statusIcons = {
	default = {
		Online = FRIENDS_TEXTURE_ONLINE,
		Offline = FRIENDS_TEXTURE_OFFLINE,
		DND = FRIENDS_TEXTURE_DND,
		AFK = FRIENDS_TEXTURE_AFK
	},
	square = {
		Online = MediaPath .. "StatusIcons\\Square\\Online",
		Offline = MediaPath .. "StatusIcons\\Square\\Offline",
		DND = MediaPath .. "StatusIcons\\Square\\DND",
		AFK = MediaPath .. "StatusIcons\\Square\\AFK"
	},
	d3 = {
		Online = MediaPath .. "StatusIcons\\D3\\Online",
		Offline = MediaPath .. "StatusIcons\\D3\\Offline",
		DND = MediaPath .. "StatusIcons\\D3\\DND",
		AFK = MediaPath .. "StatusIcons\\D3\\AFK"
	}
}

local regionLocales = {
	[1] = L["America"],
	[2] = L["Korea"],
	[3] = L["Europe"],
	[4] = L["Taiwan"],
	[5] = L["China"]
}

local function GetClassColor(className)
	for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_MALE) do
		if className == localizedName then
			return C_ClassColor_GetClassColor(class)
		end
	end

	if MER.Locale == "deDE" or MER.Locale == "frFR" then
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
			F.SetFontWithDB(button.name, cache.name)
			F.SetFontWithDB(button.info, cache.info)
		end
		return
	end

	if button.buttonType == FRIENDS_BUTTON_TYPE_DIVIDER then
		return
	end

	local gameName, realID, name, server, class, area, level, note, faction, status, isInCurrentRegion, regionID, wowID

	if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
		-- WoW friends
		wowID = WOW_PROJECT_MAINLINE
		gameName = projectCodes["WOW"]
		local friendInfo = C_FriendList_GetFriendInfoByIndex(button.id)
		name, server = strsplit("-", friendInfo.name) -- server is nil if it's not a cross-realm friend
		level = friendInfo.level
		class = friendInfo.className
		area = friendInfo.area
		note = friendInfo.notes
		faction = E.myfaction -- friend should in the same faction

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
		-- Battle.net friends
		local friendAccountInfo = C_BattleNet_GetFriendAccountInfo(button.id)
		if friendAccountInfo then
			realID = friendAccountInfo.accountName
			note = friendAccountInfo.note

			local gameAccountInfo = friendAccountInfo.gameAccountInfo
			game = gameAccountInfo.clientProgram
			gameName = projectCodes[strupper(gameAccountInfo.clientProgram)]

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
			if gameName == "World of Warcraft" then
				wowID = gameAccountInfo.wowProjectID
				name = gameAccountInfo.characterName or ""
				level = gameAccountInfo.characterLevel or 0
				faction = gameAccountInfo.factionName or nil
				class = gameAccountInfo.className or ""
				area = gameAccountInfo.areaName or ""
				isInCurrentRegion = gameAccountInfo.isInCurrentRegion or false
				regionID = gameAccountInfo.regionID or false

				if wowID and wowID ~= 1 and expansionData[wowID] then
					local suffix = expansionData[wowID].suffix and " (" .. expansionData[wowID].suffix .. ")" or ""
					local serverStrings = { strsplit(" - ", gameAccountInfo.richPresence) }
					server = (serverStrings[#serverStrings] or BNET_FRIEND_TOOLTIP_WOW_CLASSIC .. suffix) .. "*"
				else
					server = gameAccountInfo.realmDisplayName or ""
				end
			end
		end
	end

	-- Status icon
	if status then
		local pack = module.db.textures.status
		if statusIcons[pack] then
			button.status:SetTexture(statusIcons[pack][status])
		end
	end

	-- reset game icon with elvui style
	button.gameIcon:SetTexCoord(0, 1, 0, 1)

	if gameName then
		local buttonTitle, buttonText

		-- override Real ID or name with note
		if module.db.useNoteAsName and note and note ~= "" then
			if realID then
				realID = note
			else
				name = note
			end
		end

		-- real ID
		local clientColor = module.db.useClientColor and clientData[gameName] and clientData[gameName].color
		local realIDString = realID and clientColor and F.CreateColorString(realID, clientColor) or realID

		-- name
		local classColor = module.db.useClassColor and GetClassColor(class)
		local nameString = name and classColor and F.CreateColorString(name, classColor) or name

		if module.db.level and wowID and expansionData[wowID] and level and level ~= 0 then
			if level ~= expansionData[wowID].maxLevel or not module.db.hideMaxLevel then
				nameString = nameString .. F.CreateColorString(": " .. level, GetQuestDifficultyColor(level))
			end
		end

		-- combine Real ID and Name
		if nameString and realIDString then
			buttonTitle = realIDString .. " \124\124 " .. nameString
		elseif nameString then
			buttonTitle = nameString
		else
			buttonTitle = realIDString or ""
		end

		button.name:SetText(buttonTitle)

		-- area
		if area then
			if server and server ~= "" and server ~= E.myrealm then
				buttonText = F.CreateColorString(area .. " - " .. server, module.db.areaColor)
			else
				buttonText = F.CreateColorString(area, module.db.areaColor)
			end

			if not isInCurrentRegion and regionLocales[regionID] and not E.db.mui.blizzard.filter.unblockProfanityFilter then
				-- Unblocking profanity filter will change the region
				local regionText = format("[%s]", regionLocales[regionID])
				buttonText = buttonText .. " " .. F.CreateColorString(regionText, { r = 0.62, g = 0.62, b = 0.62 })
			end

			button.info:SetText(buttonText)
		end

		-- temporary fix for upgrading db from old version
		if module.db.textures.client ~= "blizzard" then
			module.db.textures.client = "modern"
		end

		-- game icon
		local texOrAtlas = clientData[gameName] and clientData[gameName]["icon"][module.db.textures.client]

		if wowID then
			texOrAtlas = expansionData[wowID]["icon"][module.db.textures.client]
		end

		if module.db.textures.factionIcon then
			if faction and factionIcons[faction] then
				texOrAtlas = factionIcons[faction]
			end
		end

		if texOrAtlas then
			if module.db.textures.client == "blizzard" then
				button.gameIcon:SetAtlas(texOrAtlas)
				button.gameIcon:SetTexCoord(0, 1, 0, 1)
			else
				button.gameIcon:SetTexture(texOrAtlas)
				button.gameIcon:SetTexCoord(.1, .9, .1, .9)
			end
		end
	else
		if module.db.useNoteAsName and note and note ~= "" then
			button.name:SetText(note)
		end
	end

	-- font style hack
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
	F.SetFontDB(button.name, module.db.nameFont)

	F.SetFontOutline(button.info)
	F.SetFontDB(button.info, module.db.infoFont)

	-- favorite icon
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
