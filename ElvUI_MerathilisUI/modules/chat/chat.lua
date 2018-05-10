local MER, E, L, V, P, G = unpack(select(2, ...))
local MERC = E:NewModule("muiChat", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local MERS = E:GetModule("muiSkins")
local CH = E:GetModule("Chat")
MERC.modName = L["Chat"]

-- Cache global variables
-- Lua functions
local _G = _G
local pairs = pairs
local format = format
local time = time
local BetterDate = BetterDate
local gsub = string.gsub
-- WoW API / Variable
local GetRealmName = GetRealmName
local GUILD_MOTD = GUILD_MOTD

-- GLOBALS: CHAT_FRAMES, ChatTypeInfo

local ChatFrame_SystemEventHandler = ChatFrame_SystemEventHandler
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

function MERC:RemoveCurrentRealmName(msg, author, ...)
	local realmName = gsub(GetRealmName(), " ", "")

	if msg and msg:find("-" .. realmName) then
		return false, gsub(msg, "%-"..realmName, ""), author, ...
	end
end

CH.mUIUpdateAnchors = CH.UpdateAnchors
function CH:UpdateAnchors()
	self:mUIUpdateAnchors()

	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName.."EditBox"]
		if not frame then break; end

		frame:SetScript("OnShow", function(self)
			E:UIFrameFadeIn(self, .5, 0, 1)
		end)
	end

	CH:PositionChat(true)
end

function MERC:AddMessage(msg, infoR, infoG, infoB, infoID, accessID, typeID, isHistory, historyTime)
	local historyTimestamp --we need to extend the arguments on AddMessage so we can properly handle times without overriding
	if isHistory == "ElvUI_ChatHistory" then historyTimestamp = historyTime end

	if (CH.db.timeStampFormat and CH.db.timeStampFormat ~= 'NONE' ) then
		local timeStamp = BetterDate(CH.db.timeStampFormat, historyTimestamp or time());
		timeStamp = gsub(timeStamp, ' $', '') --Remove space at the end of the string
		timeStamp = timeStamp:gsub('AM', ' AM')
		timeStamp = timeStamp:gsub('PM', ' PM')
		if CH.db.useCustomTimeColor then
			local color = CH.db.customTimeColor
			local hexColor = E:RGBToHex(color.r, color.g, color.b)
			msg = format("%s[%s]|r %s", hexColor, timeStamp, msg)
		else
			msg = format("[%s] %s", timeStamp, msg)
		end
	end

	if CH.db.copyChatLines then
		msg = format('|Hcpl:%s|h%s|h %s', self:GetID(), [[|TInterface\AddOns\ElvUI\media\textures\ArrowRight:14|t]], msg)
	end

	if E.db.mui.chat.hidePlayerBrackets then
		msg = gsub(msg, "(|HB?N?player.-|h)%[(.-)%]|h", "%1%2|h")
	end

	self.OldAddMessage(self, msg, infoR, infoG, infoB, infoID, accessID, typeID)
end

function CH:AddMessage(msg, ...)
	return MERC.AddMessage(self, msg, ...)
end

function CH:ChatFrame_SystemEventHandler(chat, event, message, ...)
	if event == "GUILD_MOTD" then
		if message and message ~= "" then
			local info = ChatTypeInfo["GUILD"];
			local GUILD_MOTD = "GMOTD"
			chat:AddMessage(format('|cff00c0fa%s|r: %s', GUILD_MOTD, message), info.r, info.g, info.b, info.id)
		end
		return true
	else
		return ChatFrame_SystemEventHandler(chat, event, message, ...)
	end
end

function MERC:Initialize()
	if E.private.chat.enable ~= true then return; end

	-- Style the chat
	_G["LeftChatPanel"].backdrop:Styling()
	_G["RightChatPanel"].backdrop:Styling()

	-- Remove the Realm Name from system messages
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", MERC.RemoveCurrentRealmName)

	self:EasyChannel()
	self:ItemLevelLink()
end

local function InitializeCallback()
	MERC:Initialize()
end

E:RegisterModule(MERC:GetName(), InitializeCallback)