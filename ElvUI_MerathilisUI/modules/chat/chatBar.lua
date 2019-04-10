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

local BlockChannelName = {
	["EUIGVC"] = true,
	["ElvUIGVC"] = true,
}

local function ChannelShortText(index)
	local channelNum, channelName = GetChannelName(index)
	if not channelName or BlockChannelName[channelName] then return 0 end

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
		["name"] = L["ChatBar_Say"] or "S",
		["cmd"] = "/s ",
		["show"] = function() return true end,
	},
	["YELL"] = {
		["name"] = L["ChatBar_Yell"] or "Y",
		["cmd"] = "/y ",
		["show"] = function() return true end,
	},
	["GUILD"] = {
		["name"] = L["ChatBar_G"],
		["cmd"] = "/g ",
		["show"] = function() return IsInGuild() end,
	},
	["OFFICER"] = {
		["name"] = L["ChatBar_O"],
		["cmd"] = "/o ",
		["show"] = function() return CanEditOfficerNote() end,
	},
	["PARTY"] = {
		["name"] = L["ChatBar_P"],
		["cmd"] = "/p ",
		["show"] = function() return IsPartyLFG() or IsInGroup() or IsInRaid() end,
	},
	["RAID"] = {
		["name"] = L["ChatBar_R"],
		["cmd"] = "/raid ",
		["show"] = function() return IsInRaid() end,
	},
	["RAID_WARNING"] = {
		["name"] = L["ChatBar_RW"],
		["cmd"] = "/rw ",
		["show"] = function() return IsInRaid() end,
	},
	["INSTANCE_CHAT"] = {
		["name"] = L["ChatBar_I"],
		["cmd"] = "/i ",
		["show"] = function() return IsPartyLFG() end,
	},
	["BATTLE_CHAT"] = {
		["name"] = L["ChatBar_BG"],
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
	f:SetWidth(width)
	f:SetHeight(height)
	f:SetPoint("LEFT", parent, "LEFT", (postion == 1) and 7 or (7 + (postion - 1) * 20), 0)
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
	f.text:SetShadowOffset(2, 2)
	f.text:SetShadowColor(0, 0, 0, 0.2)
	f.text:SetPoint("CENTER", 0, 0)
	f.text:SetTextColor(unpack(color))

	f:SetScript("OnEnter", function(self)
		self.text:SetShadowColor(f.text:GetTextColor())
		_G.GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
		_G.GameTooltip:AddLine(self.text:GetText())
		_G.GameTooltip:Show()
	end)
	f:SetScript("OnLeave", function(self)
		self.text:SetShadowColor(0, 0, 0, 0.2)
		_G.GameTooltip:Hide()
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

	local chat = CreateFrame("Frame", "mUIChatbarFrame", _G.LeftChatPanel)
	chat:SetPoint("BOTTOM", _G.LeftChatPanel, "BOTTOM", 0, -21)
	chat:SetWidth(_G.LeftChatPanel:GetWidth())
	chat:SetHeight(20)

	chat:SetTemplate('Transparent', nil, true)
	chat:SetBackdropColor(E.db.chat.panelColor.r, E.db.chat.panelColor.g, E.db.chat.panelColor.b, E.db.chat.panelColor.a)
	chat:Styling()

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
	self.chatbar = chat

	local Emote = self.ChatEmote
	local ChatEmote = CreateFrame("Button", nil, self.chatbar)
	ChatEmote:SetPoint("RIGHT", self.chatbar, "RIGHT", -28, 0)
	ChatEmote:SetParent(self.chatbar)
	ChatEmote:SetWidth(14)
	ChatEmote:SetHeight(14)
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
	roll:SetWidth(18)
	roll:SetHeight(18)
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
