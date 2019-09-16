local MER, E, L, V, P, G = unpack(select(2, ...))
local MERC = MER:GetModule("muiChat")

-- Credits: siweia/NDui

-- Cache global variables
-- Lua functions
local _G = _G
local gsub, pairs = gsub, pairs
local strfind, strmatch = strfind, strmatch
-- WoW API / Variable
local GetItemInfo = GetItemInfo
local GetItemStats = GetItemStats
-- GLOBALS:

-- Show itemlevel on chat hyperlinks
local function isItemHasLevel(link)
	local name, _, rarity, level, _, _, _, _, _, _, _, classID = GetItemInfo(link)
	if name and level and rarity > 1 and (classID == _G.LE_ITEM_CLASS_WEAPON or classID == _G.LE_ITEM_CLASS_ARMOR) then
		local itemLevel = MER:GetItemLevel(link)
		return name, itemLevel
	end
end

local function isItemHasGem(link)
	local stats = GetItemStats(link)
	for index in pairs(stats) do
		if strfind(index, "EMPTY_SOCKET_") then
			return "|TInterface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic:0|t"
		end
	end
	return ""
end

local itemCache = {}
local function convertItemLevel(link)
	if itemCache[link] then return itemCache[link] end

	local itemLink = strmatch(link, "|Hitem:.-|h")
	if itemLink then
		local name, itemLevel = isItemHasLevel(itemLink)
		if name then
			link = gsub(link, "|h%[(.-)%]|h", "|h["..name.."("..itemLevel..isItemHasGem(itemLink)..")]|h")
			itemCache[link] = link
		end
	end
	return link
end

function MERC:UpdateChatItemLevel(_, msg, ...)
	msg = gsub(msg, "(|Hitem:%d+:.-|h.-|h)", convertItemLevel)
	return false, msg, ...
end

function MERC:ChatFilter()
	if E.db.mui.chat.filter.enable and E.db.mui.chat.filter.itemLevel then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", self.UpdateChatItemLevel)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", self.UpdateChatItemLevel)
	end

	if E.db.mui.chat.filter.enable and E.db.mui.chat.filter.lootMessages then
		-- Probably breaks other AddOns :> always a bad idea to replace Blizzards Globals
		_G.CURRENCY_GAINED = "+ %s"
		_G.CURRENCY_GAINED_MULTIPLE = "+ %sx%d"
		_G.CURRENCY_GAINED_MULTIPLE_BONUS = "+ %sx%d (Bonus)"
		_G.CURRENCY_LOST_FROM_DEATH = "- %sx%d"
		_G.LOOT_CURRENCY_REFUND = "+ %sx%d"
		_G.LOOT_DISENCHANT_CREDIT = "- %s : %s (Disenchant)"
		_G.LOOT_ITEM = "+ %s : %s"
		_G.LOOT_ITEM_BONUS_ROLL = "+ %s : %s (Bonus)"
		_G.LOOT_ITEM_BONUS_ROLL_MULTIPLE = "+ %s : %sx%d (Bonus)"
		_G.LOOT_ITEM_BONUS_ROLL_SELF = "+ %s (Bonus)"
		_G.LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE = "+ %sx%d (Bonus)"
		_G.LOOT_ITEM_CREATED_SELF = "+ %s (Craft)"
		_G.LOOT_ITEM_CREATED_SELF_MULTIPLE = "+ %sx%d (Craft)"
		_G.LOOT_ITEM_CREATED = "+ %s : %s (Craft)"
		_G.LOOT_ITEM_CREATED_MULTIPLE = "+ %s : %sx%d (Craft)"
		_G.LOOT_ITEM_MULTIPLE = "+ %s : %sx%d"
		_G.LOOT_ITEM_PUSHED = "+ %s : %s"
		_G.LOOT_ITEM_PUSHED_MULTIPLE = "+ %s : %sx%d"
		_G.LOOT_ITEM_PUSHED_SELF = "+ %s"
		_G.LOOT_ITEM_PUSHED_SELF_MULTIPLE = "+ %sx%d"
		_G.LOOT_ITEM_REFUND = "+ %s"
		_G.LOOT_ITEM_REFUND_MULTIPLE = "+ %sx%d"
		_G.LOOT_ITEM_SELF = "+ %s"
		_G.LOOT_ITEM_SELF_MULTIPLE = "+ %sx%d"
		_G.LOOT_ITEM_WHILE_PLAYER_INELIGIBLE = "+ %s : %s"
		_G.GUILD_NEWS_FORMAT4 = "+ %s : %s (Craft)"
		_G.GUILD_NEWS_FORMAT8 = "+ %s : %s"
		_G.CREATED_ITEM = "+ %s : %s (Craft)";
		_G.CREATED_ITEM_MULTIPLE = "+ %s : %sx%d (Craft)"
		_G.YOU_LOOT_MONEY = "+ %s"
		_G.YOU_LOOT_MONEY_GUILD = "+ %s (%s Guild)"
		_G.TRADESKILL_LOG_FIRSTPERSON = "+ %s : %s (Craft)"
		_G.TRADESKILL_LOG_THIRDPERSON = "+ %s : %s (Craft)"

		_G.COMBATLOG_XPGAIN_EXHAUSTION1 = "%s : +%d xp (%s bonus %s)"
		_G.COMBATLOG_XPGAIN_EXHAUSTION1_GROUP = "%s : +%d xp (%s bonus %s, +%d group)"
		_G.COMBATLOG_XPGAIN_EXHAUSTION1_RAID = "%s : +%d xp (%s bonus %s, -%d raid)"
		_G.COMBATLOG_XPGAIN_EXHAUSTION2 = "%s : +%d xp (%s bonus %s)";
		_G.COMBATLOG_XPGAIN_EXHAUSTION2_GROUP = "%s : +%d xp (%s bonus %s, +%d group)";
		_G.COMBATLOG_XPGAIN_EXHAUSTION2_RAID = "%s : +%d xp (%s bonus %s, -%d raid)";
		_G.COMBATLOG_XPGAIN_EXHAUSTION4 = "%s : +%d xp (%s penalty %s)";
		_G.COMBATLOG_XPGAIN_EXHAUSTION4_GROUP = "%s : +%d xp (%s penalty %s, +%d group)";
		_G.COMBATLOG_XPGAIN_EXHAUSTION4_RAID = "%s : +%d xp (%s xp %s, -%d raid)";
		_G.COMBATLOG_XPGAIN_EXHAUSTION5 = "%s : +%d xp (%s penalty %s)";
		_G.COMBATLOG_XPGAIN_EXHAUSTION5_GROUP = "%s : +%d xp (%s penalty %s, +%d group)";
		_G.COMBATLOG_XPGAIN_EXHAUSTION5_RAID = "%s : +%d xp (%s penalty %s, -%d raid)";
		_G.COMBATLOG_XPGAIN_FIRSTPERSON = "%s : +%d xp.";
		_G.COMBATLOG_XPGAIN_FIRSTPERSON_GROUP = "%s : +%d xp (+%d group)";
		_G.COMBATLOG_XPGAIN_FIRSTPERSON_RAID = "%s : +%d xp (-%d raid)";
	end
end
