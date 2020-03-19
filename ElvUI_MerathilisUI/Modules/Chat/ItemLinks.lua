local MER, E, L, V, P, G = unpack(select(2, ...))
local MERC = MER:GetModule("muiChat")

-- Credits: SDPhantom - ChatLinkIcons

-- Cache global variables
-- Lua functions
local _G = _G
local assert, next, ipairs, pcall, pairs, select, tostring, tonumber, unpack = assert, next, ipairs, pcall, pairs, select, tostring, tonumber, unpack
local split, gsub, gmatch, format, strfind, strmatch, sub = string.split, string.gsub, string.gmatch, string.format, string.find, string.match, string.sub
local tinsert = table.insert
local abs, floor = math.abs, math.floor
local rawget, rawset = rawget, rawset
local getmetatable, setmetatable = getmetatable, setmetatable
local error = error
-- WoW API / Variable
local BNGetFriendInfoByID = BNGetFriendInfoByID
local BNGetGameAccountInfo = BNGetGameAccountInfo
local BNet_GetClientEmbeddedTexture = BNet_GetClientEmbeddedTexture
local C_Calendar_GetDayEvent = C_Calendar.GetDayEvent
local C_FriendList_ShowFriends = C_FriendList.ShowFriends
local C_FriendList_GetNumFriends = C_FriendList.GetNumFriends
local C_FriendList_GetFriendInfoByIndex = C_FriendList.GetFriendInfoByIndex
local C_TransmogCollection_GetAppearanceSourceInfo = C_TransmogCollection.GetAppearanceSourceInfo
local ChatTypeInfo = ChatTypeInfo
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
local ChatFrame_MessageEventHandler = ChatFrame_MessageEventHandler
local CreateFrame = CreateFrame
local ConvertRGBtoColorString = ConvertRGBtoColorString
local GetAchievementInfo = GetAchievementInfo
local GetCurrencyLink = GetCurrencyLink
local GetCurrencyInfo = GetCurrencyInfo
local GetItemInfo = GetItemInfo
local GetItemIcon = GetItemIcon
local GetItemQualityColor = GetItemQualityColor
local GetItemStats = GetItemStats
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetSpellInfo = GetSpellInfo
local IsAddOnLoaded = IsAddOnLoaded
local GetAtlasInfo = GetAtlasInfo
local GetNormalizedRealmName = GetNormalizedRealmName
local GuildRoster = GuildRoster
local GetNumGuildMembers = GetNumGuildMembers
local GetGuildRosterInfo = GetGuildRosterInfo
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local UnitName = UnitName
local UnitGUID = UnitGUID

-- Pawn Stuff
local function GenerateFromAtlas(atlas)
	local tex, w, h, x1, x2, y1, y2 = GetAtlasInfo(atlas)
	if x1 == 0 and x2 == 1 and y1 == 0 and y2 == 1 then
		return ("|T%s:0|t"):format(tostring(tex))
	else
		local filew, fileh = floor(w/abs(x2-x1)+0.5), floor(h/abs(y2-y1)+0.5)--	W and H are the dimensions of the texcoord, not the image
		return ("|T%s:0:0:0:0:%d:%d:%d:%d:%d:%d|t"):format(tostring(tex), filew, fileh, floor(x1*filew+0.5), floor(x2*filew+0.5), floor(y1*fileh+0.5), floor(y2*fileh+0.5))
	end
end

local PawnIsLoaded = IsAddOnLoaded("Pawn")
local PawnUpgradeIcon = GenerateFromAtlas("bags-greenarrow")

local OptionTypeLookup = {
	currency = "item",
	transmogappearance = "item",

	BNplayer = "player",
	BNplayerCommunity = "player",
	playerCommunity = "player",
	playerGM = "player",

	enchant = "spell",
	trade = "spell",
	unit = "player",
}

--------------------------
--[[	Texture Tables	]]
--------------------------
local Races = {}
do	--	Races/Genders
	local TexturePath,TextureWidth,TextureHeight,IconSize,RaceGrid;
	if _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE then
		TexturePath = "Interface\\Glues\\CharacterCreate\\CharacterCreateIcons"
		TextureWidth = 512
		TextureHeight = 512
		IconSize = 66

		RaceGrid = {
--			Race			Male, Female
			Human			={{3,1},{2,1}};
			Orc			={{5,2},{4,2}};
			Dwarf			={{0,1},{6,0}};
			NightElf		={{3,2},{2,2}};
			Scourge			={{5,3},{4,3}};
			Tauren			={{2,5},{2,4}};
			Gnome			={{0,3},{0,2}};
			Troll			={{3,3},{2,6}};
			Goblin			={{0,5},{0,4}};
			BloodElf		={{1,0},{0,0}};
			Draenei			={{5,0},{4,0}};
			Worgen			={{3,6},{3,5}};
			Pandaren		={{2,3},{6,2}};
			Nightborne		={{1,6},{1,5}};
			HighmountainTauren	={{1,1},{0,6}};
			VoidElf			={{3,4},{6,3}};
			LightforgedDraenei	={{1,2},{6,1}};
			ZandalariTroll		={{5,4},{4,4}};
			KulTiran		={{5,1},{4,1}};
			DarkIronDwarf		={{3,0},{2,0}};
			Vulpera			={{5,5},{4,6}};
			MagharOrc		={{1,4},{1,3}};
			Mechagnome		={{4,5},{6,4}};
		};
	elseif _G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC then
		TexturePath = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races"
		TextureWidth = 256
		TextureHeight = 256
		IconSize = 64

		RaceGrid = {
--			Race			Male, Female
			Human			={{0,0},{0,2}};
			Orc			={{3,1},{3,3}};
			Dwarf			={{1,0},{1,2}};
			NightElf		={{3,0},{3,2}};
			Scourge			={{1,1},{1,3}};
			Tauren			={{0,1},{0,3}};
			Gnome			={{2,0},{2,2}};
			Troll			={{2,1},{2,3}};
		};
	else
		error("Invalid WoW Project ID")
	end

--	|Tpath:size1:size2:xoffset:yoffset:dimx:dimy:coordx1:coordx2:coordy1:coordy2|t
	for race,data in pairs(RaceGrid) do
		for index,pos in ipairs(data) do
--			Gender from GetPlayerInfoByGUID() is 2/3
			Races[race..(index+1)]=("|T%s:0:0:0:0:%d:%d:%d:%d:%d:%d|t"):format(TexturePath, TextureWidth, TextureHeight, pos[1]*IconSize, (pos[1]+1)*IconSize, pos[2]*IconSize, (pos[2]+1)*IconSize)
		end
	end
end

local Classes = {--	Classes
	WARRIOR		= "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:0:64:0:64|t";
	MAGE		= "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:64:128:0:64|t";
	ROGUE		= "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:128:192:0:64|t";
	DRUID		= "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:192:256:0:64|t";
	HUNTER		= "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:0:64:64:128|t";
	SHAMAN		= "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:64:128:64:128|t";
	PRIEST		= "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:128:192:64:128|t";
	WARLOCK		= "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:192:256:64:128|t";
	PALADIN		= "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:0:64:128:192|t";
	DEATHKNIGHT	= "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:64:128:128:192|t";
	MONK		= "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:128:192:128:192|t";
	DEMONHUNTER	= "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:192:256:128:192|t";
}

----------------------------------
--[[	PlayerCache Prescan	]]--	Prescan helps system messages get icons when someone logs in
----------------------------------
local ServerTag
local PlayerCache = setmetatable({},{
	__index=function(t, k) return ServerTag and rawget(t, ("%s-%s"):format(k, ServerTag)) end,
	__newindex=function(t, k, v)--	k = Name v = GUID
		if not ServerTag then return; end
		if not k:find("%-") then
			k = ("%s-%s"):format(k, ServerTag)
		end
		rawset(t, k, v)
	end
})

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("PLAYER_GUILD_UPDATE")
EventFrame:RegisterEvent("FRIENDLIST_UPDATE")
EventFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
EventFrame:SetScript("OnEvent",function(self,event,...)
	if event == "PLAYER_LOGIN" then
		ServerTag = GetNormalizedRealmName()--	Update server tag
		PlayerCache[UnitName("player")] = UnitGUID("player")--	Register player GUID
		C_FriendList_ShowFriends()--	Request friend list
		GuildRoster()--	Request guild roster
	elseif event == "PLAYER_GUILD_UPDATE" then GuildRoster()--	Player joined/left guild
	elseif event =="FRIENDLIST_UPDATE" then
		for i = 1, C_FriendList_GetNumFriends() do
			local info = C_FriendList_GetFriendInfoByIndex(i)
			if info and info.name and info.guid then
				PlayerCache[info.name] = info.guid
			end--	Register friend
		end
	elseif event == "GUILD_ROSTER_UPDATE" then
--		(...) is true if the a refresh is needed, false if a refresh has been done
		if (...) then
			GuildRoster()
		else
			for i = 1, (GetNumGuildMembers()) do
				local name,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,guid = GetGuildRosterInfo(i)
				if name and guid then
					PlayerCache[name]=guid
				end--	Register guildmate
			end
		end
	end
end)

--------------------------
--[[	Link Transform	]]
--------------------------
local function IsItemUpgrade(link)--	Modified PawnIsItemIDAnUpgrade() (Allows full links to compare upgraded items)
	if not (PawnIsLoaded and PawnIsReady() and link) then return nil end
	local item = PawnGetItemData(link);
	if not item then return nil; end
	return PawnIsItemAnUpgrade(item) and true or false
end

local function IconsFromGUID(guid)
	if not guid then return "","" end
	local _,class,_,race,gender = GetPlayerInfoByGUID(guid)
	return Races[race..gender] or "", class and Classes[class] or ""
end

--	Texture generation functions
local TextureFunctions = {
	achievement = function(id, text) return "|T"..select(10, GetAchievementInfo(tonumber(id:match("%d+"))))..":0|t" end,
	calendarEvent = function(id, text)
		local offset, day, index = split(":", id)
		local event = C_Calendar_GetDayEvent(tonumber(offset), tonumber(day), tonumber(index))
		if event then
			return "|T"..event.iconTexture..":0|t"
		end
	end,

	currency = function(id, text) return "|T"..select(3, GetCurrencyInfo(tonumber(id:match("%d+"))))..":0|t"; end;
	item = function(id, text) return "|T"..GetItemIcon(tonumber(id:match("%d+")))..":0|t"; end;
	transmogappearance = function(id, text) return "|T"..GetItemIcon(tonumber(select(6, C_TransmogCollection_GetAppearanceSourceInfo(tonumber(id))):match("|Hitem:(%d+)")))..":0|t"; end;

	BNplayer = function(id, text)
		local _,_,_,_,_,acctid,client,online = BNGetFriendInfoByID((select(6, tonumber(id:match(":(%d+)")))));
		local _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,guid = BNGetGameAccountInfo(acctid);
		if not online then return BNet_GetClientEmbeddedTexture(nil); end
		if client ~= BNET_CLIENT_WOW or not guid then return BNet_GetClientEmbeddedTexture(client); end

		local race, class = IconsFromGUID(guid);
		return (E.db.mui.chat.linkIcons.icons.Race and race or "")..(E.db.mui.chat.linkIcons.icons.Class and class or "");
	end;
	player = function(id, text) local race, class = IconsFromGUID(PlayerCache[id:match("[^:]+")]); return (E.db.mui.chat.linkIcons.icons.Race and race or "")..(E.db.mui.chat.linkIcons.icons.Class and class or ""); end;
	unit = function(id, text) local race, class = IconsFromGUID(id:match("[^:]+")); return (E.db.mui.chat.linkIcons.icons.Race and race or "")..(E.db.mui.chat.linkIcons.icons.Class and class or ""); end;

	spell = function(id, text) return "|T"..select(3, GetSpellInfo(tonumber(id:match("%d+"))))..":0|t"; end;
	trade = function(id, text) return "|T"..select(3, GetSpellInfo(tonumber(id:match(":(%d+)"))))..":0|t"; end;
}

--	Shared functions
TextureFunctions["BNplayerCommunity"] = TextureFunctions["BNplayer"]
TextureFunctions["enchant"] = TextureFunctions["spell"]
TextureFunctions["playerCommunity"] = TextureFunctions["player"]
TextureFunctions["playerGM"] = TextureFunctions["player"]

local ConvertLinks
do--	function(str)
	local LinkPattern="(|H([^:|]+):([^|]-)|h(.-)|h)";
	local function Callback(link,type,id,text)--	Conversion Function
		local func=TextureFunctions[type];

	--	Pawn Itegration (Append after all textures)
		local upgradeicon = (type == "item" and E.db.mui.chat.linkIcons.PawnIntegration and IsItemUpgrade("item:"..id)) and PawnUpgradeIcon or "";

	--	Return if no function or link type is disabled
		if not func or E.db.mui.chat.linkIcons.links[OptionTypeLookup[type] or type] == false then return link..upgradeicon; end

	--	Rarely, the game doesn't give us the icons we need in the time we need them
	--	Leting any error halt conversion and return
		local ok, pre, post = pcall(func, id, text);
		if not ok then return link..upgradeicon; end

	--	Return modified link
		return ("%s%s%s%s"):format(pre or "",link, post or "", upgradeicon);
	end

	function ConvertLinks(str)
		local fix; str, fix = str:gsub(LinkPattern,Callback);
		if fix>0 then
--			Fix some links relinking with textures and blocking the ability to send them (Blizzard seems to have fixed this, but still doing it to preserve legacy behavior)
			repeat str, fix = str:gsub("(|c%x%x%x%x%x%x%x%x)(%s*|T[^|]*|t%s*)","%2%1"); until fix<=0
			repeat str, fix = str:gsub("(%s*|T[^|]*|t%s*)(|r)","%2%1"); until fix<=0
		end
		return str;
	end
end

--------------------------
--[[	Message Hooks	]]
--------------------------
local function MessageFilter(self,event,msg,...)
	local name,_,_,_,_,_,_,_,_,_,guid=...;
	if (name or "") ~= "" and (guid or "") ~= "" then PlayerCache[name] = guid; end
	return false, ConvertLinks(msg), ...;
end

local function PassThroughHook(tbl,key)
	if key == nil then tbl,key=_G,tbl; end
	local orig = assert(tbl[key]);
	tbl[key] = function(...) return ConvertLinks(orig(...)); end
end

--------------------------
--[[	Item Level	]]
--------------------------
local function isItemHasLevel(link)
	local name, _, rarity, level, _, class, subclass, _, equipSlot, _, _, classID = GetItemInfo(link)
	if name and level and rarity > 1 and (classID == _G.LE_ITEM_CLASS_WEAPON or classID == _G.LE_ITEM_CLASS_ARMOR) then
		local itemLevel = MER:GetItemLevel(link)

		if (equipSlot and strfind(equipSlot, 'INVTYPE_')) then
			itemLevel = format('%s %s', itemLevel, _G[equipSlot] or equipSlot)
		elseif (class == ARMOR) then
			itemLevel = format('%s %s', itemLevel, class)
		elseif (subclass and strfind(subclass, RELICSLOT)) then
			itemLevel = format('%s %s', itemLevel, RELICSLOT)
		end

		return name, itemLevel
	end
end

local function isItemHasGem(link)
	local stats = GetItemStats(link)
	for index in pairs(stats) do
		if strfind(index, 'EMPTY_SOCKET_') then
			return '|TInterface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic:0|t'
		end
	end
	return ''
end

local itemCache = {}
local function convertItemLevel(link)
	if itemCache[link] then return itemCache[link] end

	local itemLink = strmatch(link, '|Hitem:.-|h')
	if itemLink then
		local name, itemLevel = isItemHasLevel(itemLink)
		if name and itemLevel then
			link = gsub(link, '|h%[(.-)%]|h', '|h'..name..' ('..itemLevel..isItemHasGem(itemLink)..')|h')
			itemCache[link] = link
		end
	end
	return link
end

function MERC:UpdateChatItemLevel(_, msg, ...)
	msg = gsub(msg, '(|Hitem:%d+:.-|h.-|h)', convertItemLevel)
	return false, msg, ...
end

-- Show item's real color for BN chat
local queuedMessages = {}

local function GetLinkColor(data)
	local type, arg1, arg2, arg3 = split(':', data)
	if(type == 'item') then
		local _, _, quality = GetItemInfo(arg1)
		if(quality) then
			local _, _, _, color = GetItemQualityColor(quality)
			return '|c' .. color
		else
			return nil, true
		end
	elseif(type == 'quest') then
		if(arg2) then
			return ConvertRGBtoColorString(GetQuestDifficultyColor(arg2))
		else
			return '|cffffd100'
		end
	elseif(type == 'currency') then
		local link = GetCurrencyLink(arg1)
		if(link) then
			return sub(link, 0, 10)
		else
			return '|cffffffff'
		end
	elseif(type == 'battlepet') then
		if(arg3 ~= -1) then
			local _, _, _, color = GetItemQualityColor(arg3)
			return '|c' .. color
		else
			return '|cffffd200'
		end
	elseif(type == 'garrfollower') then
		local _, _, _, color = GetItemQualityColor(arg2)
		return '|c' .. color
	elseif(type == 'spell') then
		return '|cff71d5ff'
	elseif(type == 'achievement' or type == 'garrmission') then
		return '|cffffff00'
	elseif(type == 'trade' or type == 'enchant') then
		return '|cffffd000'
	elseif(type == 'instancelock') then
		return '|cffff8000'
	elseif(type == 'glyph' or type == 'journal') then
		return '|cff66bbff'
	elseif(type == 'talent' or type == 'battlePetAbil' or type == 'garrfollowerability') then
		return '|cff4e96f7'
	elseif(type == 'levelup') then
		return '|cffff4e00'
	end
end

local function UpdateLinkColor(self, event, message, ...)
	for link, data in gmatch(message, '(|H(.-)|h.-|h)') do
		local color, queue = GetLinkColor(data)
		if(queue) then
			tinsert(queuedMessages, {self, event, message, ...})
			return true
		elseif(color) then
			local matchLink = '|H' .. data .. '|h.-|h'
			message = gsub(message, matchLink, color .. link .. '|r', 1)
		end
	end

	return false, message, ...
end

local f = CreateFrame('Frame')
f:RegisterEvent('GET_ITEM_INFO_RECEIVED')
f:SetScript('OnEvent', function()
	if(#queuedMessages > 0) then
		for index, data in next, queuedMessages do
			ChatFrame_MessageEventHandler(unpack(data))
			queuedMessages[index] = nil
		end
	end
end)

function MERC:ItemLinks()
	if E.db.mui.chat.linkIcons.enable ~= true then return end

	for type in next, getmetatable(ChatTypeInfo).__index do
		ChatFrame_AddMessageEventFilter("CHAT_MSG_"..type, MessageFilter)
	end

	PassThroughHook("GetBNPlayerCommunityLink")
	PassThroughHook("GetBNPlayerLink")
	PassThroughHook("GetGMLink")
	PassThroughHook("GetPlayerCommunityLink")
	PassThroughHook("GetPlayerLink")

	ChatFrame_AddMessageEventFilter('CHAT_MSG_LOOT', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_YELL', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER_INFORM', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID_LEADER', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY_LEADER', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_GUILD', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_BATTLEGROUND', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT_LEADER', self.UpdateChatItemLevel)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_SYSTEM', self.UpdateChatItemLevel)

	ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER', UpdateLinkColor)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER_INFORM', UpdateLinkColor)
end
