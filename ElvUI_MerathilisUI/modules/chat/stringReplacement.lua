local MER, E, L, V, P, G = unpack(select(2, ...))
local MERC = E:GetModule("muiChat")

--Cache global variables
--Lua Variables
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: SetItemRef

function MERC:StringReplacement()
	_G["ERR_FRIEND_ONLINE_SS"] = "|Hplayer:%s|h[%s]|h "..L["has come |cff298F00online|r."]
	_G["ERR_FRIEND_OFFLINE_S"] = "[%s] "..L["has gone |cffff0000offline|r."]

	_G["BN_INLINE_TOAST_FRIEND_ONLINE"] = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s"..L[" has come |cff298F00online|r."]
	_G["BN_INLINE_TOAST_FRIEND_OFFLINE"] = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s"..L[" has gone |cffff0000offline|r."]

	_G["GUILD_MOTD_TEMPLATE"] = "|cff00c0faGMOTD|r: %s"

	_G["ITEM_CREATED_BY"] = "" -- No creator name
	_G["ITEM_LEVEL_AND_MIN"] = "Level: %d (min: %d)"
	_G["ITEM_LEVEL_RANGE"] = L["Requires level: %d - %d"]
	_G["ITEM_LEVEL_RANGE_CURRENT"] = L["Requires level: %d - %d (%d)"]

	_G["CURRENCY_GAINED"] = "+ |CFFFFFFFF%s|r"
	_G["CURRENCY_GAINED_MULTIPLE"] = "+ |CFFFFFFFF%s|r x|CFFFFFFFF%d|r"

	_G["YOU_LOOT_MONEY"] = "|CFFFFFF00+|r |CFFFFFFFF%s"
	_G["YOU_LOOT_MONEY_GUILD"] = "|CFFFFFF00+|r |CFFFFFFFF%s|r |CFFFFFF00+|r |CFFFFFFFF( %s )|r"
	_G["LOOT_MONEY"] = "|CFFFFFF00+|r |CFFFFFFFF%s"
	_G["LOOT_MONEY_SPLIT_GUILD"] = "|CFFFFFF00+|r |CFFFFFFFF%s|r |CFFFFFF00+|r |CFFFFFFFF( %s )|r"
	_G["LOOT_MONEY_SPLIT"] = "|CFFFFFF00+|r |CFFFFFFFF%s"

	_G["LOOT_ITEM"] = "%s |CFFFFFF00+|r %s"
	_G["LOOT_ITEM_MULTIPLE"] = "%s |CFFFFFF00+|r %sx%d"
	_G["LOOT_ITEM_SELF"] = "|CFFFFFF00+|r %s"
	_G["LOOT_ITEM_SELF_MULTIPLE"] = "|CFFFFFF00+|r %sx%d"
	_G["LOOT_ITEM_PUSHED_SELF"] = "|CFFFFFF00+|r %s"
	_G["LOOT_ITEM_PUSHED_SELF_MULTIPLE"] = "|CFFFFFF00+|r %sx%d"

	_G["FACTION_STANDING_DECREASED"] = "%s -%d"
	_G["FACTION_STANDING_INCREASED"] = "%s +%d"
	_G["FACTION_STANDING_INCREASED_ACH_BONUS"] = "%s +%d (+%.1f)"
	_G["FACTION_STANDING_INCREASED_ACH_PART"] = "(+%.1f)"
	_G["FACTION_STANDING_INCREASED_BONUS"] = "%s + %d (+%.1f RAF)"
	_G["FACTION_STANDING_INCREASED_DOUBLE_BONUS"] = "%s +%d (+%.1f RAF) (+%.1f)"
	_G["FACTION_STANDING_INCREASED_REFER_PART"] = "(+%.1f RAF)"
	_G["FACTION_STANDING_INCREASED_REST_PART"] = L["(+%.1f Rested)"]

	_G["ERR_AUCTION_SOLD_S"] = L["|CFF1EFF00%s|r |CFFFF0000Sold.|r"]
end