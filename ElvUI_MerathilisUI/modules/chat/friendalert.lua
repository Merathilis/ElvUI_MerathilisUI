local E, L, V, P, G = unpack(ElvUI)

-- Cache global variables
-- Lua functions
local format = string.format
local print = print
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local BNConnected = BNConnected
local BNGetNumFriends = BNGetNumFriends
local BNGetFriendInfo = BNGetFriendInfo
local PlaySound = PlaySound
local C_TimerAfter = C_Timer.After

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: BATTLENET_FONT_COLOR_CODE, FONT_COLOR_CODE_CLOSE, C_Timer

-- Code taken from Battle.net Friend Alert by Clinton Caldwell
if IsAddOnLoaded("BattleNetFriendAlert") then return; end

local interval = 3
local friends = {}
local icons = {
	["Friend"] = "|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:16:16:0:0:32:32:2:30:2:30|t",
	["App"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Battlenet:14|t",
	["WoW"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WoW:14|t",
	["D3"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-D3:14|t",
	["WTCG"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-WTCG:14|t",
	["Hero"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-HotS:14|t",
	["S2"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-SC2:14|t",
	["CLNT"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-CLNT:14|t",
	["Pro"] = "|TInterface\\CHATFRAME\\UI-ChatIcon-Overwatch:14|t"
};

local function BNPlayerLink(accountName, bnetIDAccount)
	return format("|HBNplayer:%s:%s|h[%s]|h", accountName, bnetIDAccount, accountName)
end

local function ScanFriends()
	if E.db.mui.misc.FriendAlert ~= true then return; end
	
	if BNConnected() then
		for index = 1, BNGetNumFriends() do
			local bnetIDAccount, accountName, _, _, characterName, _, game = BNGetFriendInfo(index)
			if game and friends[bnetIDAccount] and friends[bnetIDAccount]["game"] then
				if game ~= friends[bnetIDAccount]["game"] then
					if game == "App" then
						print(BATTLENET_FONT_COLOR_CODE .. icons["Friend"] .. format(L["%s stopped playing (%sIn Battle.net)."], BNPlayerLink(accountName, bnetIDAccount), icons[game]) .. FONT_COLOR_CODE_CLOSE)
					else
						print(BATTLENET_FONT_COLOR_CODE .. icons["Friend"] .. format(L["%s is now playing (%s%s)."], BNPlayerLink(accountName, bnetIDAccount), icons[game], characterName or L["Unknown"]) .. FONT_COLOR_CODE_CLOSE)
						PlaySound("UI_BnetToast")
					end
				end
			end
			-- Record latest friend info
			friends[bnetIDAccount] = {["game"] = game}
		end
	end
	-- Scan again in interval seconds
	C_TimerAfter(interval, ScanFriends)
end

local f = CreateFrame("Frame", "BNFAEventsFrame", E.UIParent)
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" then
		C_TimerAfter(interval, ScanFriends)
		self:UnregisterEvent("PLAYER_LOGIN")
	end
end)
