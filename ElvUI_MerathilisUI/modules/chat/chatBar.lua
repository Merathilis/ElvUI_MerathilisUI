local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("muiChatBar")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
local tinsert, tsort, twipe = table.insert, table.sort, table.wipe
local find, split, sub = string.find, string.split, string.sub
local gsub = gsub
-- WoW API / Variable
local C_Club_GetClubInfo = C_Club.GetClubInfo
local ChatFrame_OpenChat = ChatFrame_OpenChat
local ChatTypeInfo = ChatTypeInfo
local CanEditOfficerNote = CanEditOfficerNote
local GetChannelName = GetChannelName
local InCombatLockdown =  InCombatLockdown
local IsInGuild = IsInGuild
local IsInInstance = IsInInstance
local IsPartyLFG = IsPartyLFG
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local CreateFrame = CreateFrame
-- GLOBALS:

local Button = {}

local BlackChannelName = {
	["EUIGVC"] = true,
	["ElvUIGVC"] = true,
}

local function ChannelShortText(index)
	local channelNum, channelName = GetChannelName(index)
	if not channelName or BlackChannelName[channelName] then return 0 end

	if find(channelName, "Community") then
		local _, clubId, _ = split(":", channelName)
		local clubInfo = C_Club_GetClubInfo(clubId)
		if clubInfo then
			channelName = clubInfo.shortName or clubInfo.name
		end
		return E:ShortenString(gsub(channelName, "%s%-%s.*", ""), 1)
	else
		return 0
	end
end

local ChatTypesList = {
	["CHANNEL1"] = 1,
	["CHANNEL2"] = 2,
	["CHANNEL3"] = 3,
	["CHANNEL4"] = 4,
	["CHANNEL5"] = 5,
	["CHANNEL6"] = 6,
	["CHANNEL7"] = 7,
	["CHANNEL8"] = 8,
	["CHANNEL9"] = 9,
	["CHANNEL10"] = 10,
	["SAY"] = {
		["name"] = L["S"],
		["cmd"] = "/s ",
		["show"] = function() return true end,
	},
	["YELL"] = {
		["name"] = L["Y"],
		["cmd"] = "/y ",
		["show"] = function() return true end,
	},
	["GUILD"] = {
		["name"] = L["G"],
		["cmd"] = "/g ",
		["show"] = function() return IsInGuild() end,
	},
	["OFFICER"] = {
		["name"] = L["O"],
		["cmd"] = "/o ",
		["show"] = function() return CanEditOfficerNote() end,
	},
	["PARTY"] = {
		["name"] = L["P"],
		["cmd"] = "/p ",
		["show"] = function() return IsPartyLFG() or IsInGroup() or IsInRaid() end,
	},
	["RAID"] = {
		["name"] = L["R"],
		["cmd"] = "/raid ",
		["show"] = function() return IsInRaid() end,
	},
	["RAID_WARNING"] = {
		["name"] = L["RW"],
		["cmd"] = "/rw ",
		["show"] = function() return IsInRaid() end,
	},
	["INSTANCE_CHAT"] = {
		["name"] = L["I"],
		["cmd"] = "/i ",
		["show"] = function() return IsPartyLFG() end,
	},
	["BATTLE_CHAT"] = {
		["name"] = L["BG"],
		["cmd"] = "/bg ",
		["show"] = function() local inInstance, instanceType = IsInInstance() local isInPVP = inInstance and (instanceType == "pvp") return isInPVP end,
	},
}

local chatTypesListTable = {}
for k, v in pairs(ChatTypesList) do
	tinsert(chatTypesListTable, k)
end
tsort(chatTypesListTable, function(a, b)
	return a < b
end)

local function ChannelButton(parent, width, height, postion, order, text, color)
	local f = CreateFrame("Button", nil, parent)
	f:Width(width)
	f:Height(height)
	f:SetPoint("LEFT", parent, "LEFT", (postion == 1) and 7 or (7 + (postion - 1) * 20), 0)--Lv：“20”间距
	f:RegisterForClicks("AnyUp")
	f:SetScript("OnClick", function()
		local text = ""
		if _G.ChatFrame1EditBox:IsShown() then
			text = _G.ChatFrame1EditBox:GetText()
		end
		if not order:find(" ") then order = order .. " " end
		ChatFrame_OpenChat(order .. text, _G.SELECTED_DOCK_FRAME)
	end)

	f.text = f:CreateFontString(nil, "OVERLAY")
	f.text:FontTemplate()
	f.text:SetText(text)
	f.text:SetPoint("CENTER", 0, 0)
	f.text:SetTextColor(unpack(color))

	f:SetScript("OnEnter", function(self)
		self.text:SetShadowColor(0.9, 0, 0, 0.8)
	end)
	f:SetScript("OnLeave", function(self)
		self.text:SetShadowColor(0, 0, 0, 0.2)
	end)

	f:Show()

	tinsert(Button, f)
end

local function GetChannelColor(name)
	if name and ChatTypeInfo[name] then
		return {ChatTypeInfo[name].r, ChatTypeInfo[name].g, ChatTypeInfo[name].b}
	else
		return {1, 1, 1}
	end
end

local function CreateChannelButton(chat)
	for i = 1, #Button do
		Button[i]:Hide()
		Button[i] = nil
	end
	twipe(Button)

	local i = 1
	for n = 1, #chatTypesListTable do
		if chatTypesListTable[n]:find("CHANNEL") and ChannelShortText(ChatTypesList[chatTypesListTable[n]]) ~= 0 then
			ChannelButton(chat, 16, 16, i, "/" .. sub(chatTypesListTable[n], 8) .. " ", ChannelShortText(ChatTypesList[chatTypesListTable[n]]), GetChannelColor(chatTypesListTable[n]))
			i = i + 1
		end
		if not chatTypesListTable[n]:find("CHANNEL") then
			if ChatTypesList[chatTypesListTable[n]].show() then
				ChannelButton(chat, 16, 16, i, ChatTypesList[chatTypesListTable[n]].cmd, ChatTypesList[chatTypesListTable[n]].name, GetChannelColor(chatTypesListTable[n]))
				i = i + 1
			end
		end
	end
end

function module:Initialize()
	if E.db.mui.chat.chatBar ~= true or E.private.chat.enable ~= true then return end

	local chat = CreateFrame("Frame", "LuiChatbarFrame", _G.LeftChatPanel)
	chat:Point("BOTTOM", _G.LeftChatPanel, "BOTTOM", -3, -22)
	chat:Width(E.db["chat"].panelWidth)
	chat:Height(25)
	self.chatbar = chat
	chat:RegisterEvent("PLAYER_ENTERING_WORLD")
	chat:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
	chat:RegisterEvent("UPDATE_CHAT_COLOR")
	chat:RegisterEvent("RAID_ROSTER_UPDATE")
	chat:RegisterEvent("GROUP_ROSTER_UPDATE")
	chat:RegisterEvent("PLAYER_GUILD_UPDATE")
	chat:RegisterEvent("CLUB_ADDED")
	chat:RegisterEvent("CLUB_REMOVED")
	chat:SetScript("OnEvent", function(self)
		E:ScheduleTimer(CreateChannelButton, 0.3, chat)
	end)

	local Emote = self.ChatEmote
	local ChatEmote = CreateFrame("Button", nil, self.chatbar)
	ChatEmote:SetPoint("RIGHT", self.chatbar, "RIGHT", -20, 0)
	ChatEmote:Width(14)
	ChatEmote:Height(14)
	ChatEmote:SetScript("OnClick", function()
		if InCombatLockdown() then return end
		Emote.ToggleEmoteTable()
	end)

	ChatEmote:SetNormalTexture("Interface\\Addons\\ElvUI\\media\\ChatEmojis\\Smile")
	ChatEmote:SetScript("OnEnter", function(self)
		_G.GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
		_G.GameTooltip:AddLine(L["Click to open Emoticon Frame"])
		_G.GameTooltip:Show()
	end)
	ChatEmote:SetScript("OnLeave", function(self)
		_G.GameTooltip:Hide()
	end)

	local roll = CreateFrame("Button", "rollMacro", E.UIParent, "SecureActionButtonTemplate")
	roll:SetAttribute("*type*", "macro")
	roll:SetAttribute("macrotext", "/roll")
	roll:SetParent(self.chatbar)
	roll:Width(18)
	roll:Height(18)
	roll:SetPoint("LEFT", ChatEmote, "RIGHT", 7, 0)
	roll:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")
	roll:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Down")
	roll:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Highlight")
	roll:SetScript("OnEnter", function(self)
		_G.GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
		_G.GameTooltip:AddLine(L["Roll 1-100"])
		_G.GameTooltip:Show()
	end)
	roll:SetScript("OnLeave", function(self)
		_G.GameTooltip:Hide()
	end)

	self:LoadChatEmote()
end

local function InitializeCallback()
	module:Initialize()
end

MER:RegisterModule(module:GetName(), InitializeCallback)
