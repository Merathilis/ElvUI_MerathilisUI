local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Chat')
local S = MER:GetModule('MER_Skins')
local CH = E:GetModule('Chat')
local LO = E:GetModule('Layout')

local _G = _G
local unpack = unpack
local format = format
local time = time
local BetterDate = BetterDate
local gsub = string.gsub
local CreateFrame = CreateFrame
local ChatTypeInfo = ChatTypeInfo
local GetRealmName = GetRealmName
local hooksecurefunc = hooksecurefunc
local UIParent = UIParent

local ChatFrame_SystemEventHandler = ChatFrame_SystemEventHandler
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

local r, g, b = unpack(E.media.rgbvaluecolor)

function module:RemoveCurrentRealmName(msg, author, ...)
	local realmName = gsub(GetRealmName(), " ", "")

	if msg and msg:find("-" .. realmName) then
		return false, gsub(msg, "%-"..realmName, ""), author, ...
	end
end

function module:AddMessage(msg, infoR, infoG, infoB, infoID, accessID, typeID, isHistory, historyTime)
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
		msg = format('|Hcpl:%s|h%s|h %s', self:GetID(), E:TextureString(E.Media.Textures.ArrowRight, ':14'), msg)
	end

	if E.db.mui.chat.hidePlayerBrackets then
		msg = gsub(msg, "(|HB?N?player.-|h)%[(.-)%]|h", "%1%2|h")
	end

	self.OldAddMessage(self, msg, infoR, infoG, infoB, infoID, accessID, typeID)
end

function CH:AddMessage(msg, ...)
	return module.AddMessage(self, msg, ...)
end

function CH:ChatFrame_SystemEventHandler(chat, event, message, ...)
	if event == "GUILD_MOTD" then
		if message and message ~= "" then
			local info = ChatTypeInfo["GUILD"]
			local GUILD_MOTD = "GMOTD"
			chat:AddMessage(format('|cff00c0fa%s|r: %s', GUILD_MOTD, message), info.r, info.g, info.b, info.id)
		end
		return true
	else
		return ChatFrame_SystemEventHandler(chat, event, message, ...)
	end
end

function module:StyleChat()
	-- Style the chat
	_G.LeftChatPanel.backdrop:Styling()
	_G.RightChatPanel.backdrop:Styling()

	S:CreateBackdropShadow(_G.LeftChatPanel, true)
	S:CreateBackdropShadow(_G.RightChatPanel, true)
end

function module:StyleVoicePanel()
	if _G.ElvUIChatVoicePanel then
		_G.ElvUIChatVoicePanel:Styling()
		S:CreateShadow(_G.ElvUIChatVoicePanel)
	end
end

-- Hide communities chat. Useful for streamers
-- Credits Nnogga
local commOpen = CreateFrame("Frame", nil, UIParent)
commOpen:RegisterEvent("ADDON_LOADED")
commOpen:RegisterEvent("CHANNEL_UI_UPDATE")
commOpen:SetScript("OnEvent", function(self, event, addonName)
	if event == "ADDON_LOADED" and addonName == "Blizzard_Communities" then
		--create overlay
		local f = CreateFrame("Button", nil, UIParent)
		f:SetFrameStrata("HIGH")

		f.tex = f:CreateTexture(nil, "BACKGROUND")
		f.tex:SetAllPoints()
		f.tex:SetColorTexture(0.1, 0.1, 0.1, 1)

		f.text = f:CreateFontString()
		f.text:FontTemplate(nil, 20, "OUTLINE")
		f.text:SetShadowOffset(-2, 2)
		f.text:SetText(L["Chat Hidden. Click to show"])
		f.text:SetTextColor(r, g, b)
		f.text:SetJustifyH("CENTER")
		f.text:SetJustifyV("MIDDLE")
		f.text:Height(20)
		f.text:Point("CENTER", f, "CENTER", 0, 0)

		f:EnableMouse(true)
		f:RegisterForClicks("AnyUp")
		f:SetScript("OnClick",function(...)
			f:Hide()
		end)

		--toggle
		local function toggleOverlay()
			if _G.CommunitiesFrame:GetDisplayMode() == COMMUNITIES_FRAME_DISPLAY_MODES.CHAT and E.db.mui.chat.hideChat then
				f:SetAllPoints(_G.CommunitiesFrame.Chat.InsetFrame)
				f:Show()
			else
				f:Hide()
			end
		end

		local function hideOverlay()
			f:Hide()
		end
		toggleOverlay() --run once

		--hook
		hooksecurefunc(_G.CommunitiesFrame, "SetDisplayMode", toggleOverlay)
		hooksecurefunc(_G.CommunitiesFrame, "Show", toggleOverlay)
		hooksecurefunc(_G.CommunitiesFrame, "Hide", hideOverlay)
		hooksecurefunc(_G.CommunitiesFrame, "OnClubSelected", toggleOverlay)
	end
end)

function module:CreateSeparators()
	if E.db.mui.chat.seperators.enable ~= true then return end

	--Left Chat Tab Separator
	local ltabseparator = CreateFrame('Frame', 'LeftChatTabSeparator', _G.LeftChatPanel, "BackdropTemplate")
	ltabseparator:SetFrameStrata('BACKGROUND')
	ltabseparator:SetFrameLevel(_G.LeftChatPanel:GetFrameLevel() + 2)
	ltabseparator:Height(1)
	ltabseparator:Point('TOPLEFT', _G.LeftChatPanel, 5, -24)
	ltabseparator:Point('TOPRIGHT', _G.LeftChatPanel, -5, -24)
	ltabseparator:SetTemplate('Transparent')

	--Right Chat Tab Separator
	local rtabseparator = CreateFrame('Frame', 'RightChatTabSeparator', _G.RightChatPanel, "BackdropTemplate")
	rtabseparator:SetFrameStrata('BACKGROUND')
	rtabseparator:SetFrameLevel(_G.RightChatPanel:GetFrameLevel() + 2)
	rtabseparator:Height(1)
	rtabseparator:Point('TOPLEFT', _G.RightChatPanel, 5, -24)
	rtabseparator:Point('TOPRIGHT', _G.RightChatPanel, -5, -24)
	rtabseparator:SetTemplate('Transparent')

	module:UpdateSeperators()
end
hooksecurefunc(LO, "CreateChatPanels", module.CreateSeparators)

function module:UpdateSeperators()
	if E.db.mui.chat.seperators.enable ~= true then return end

	local visibility = E.db.mui.chat.seperators.visibility
	if visibility == 'SHOWBOTH' then
		_G.LeftChatTabSeparator:Show()
		_G.RightChatTabSeparator:Show()
	elseif visibility =='HIDEBOTH' then
		_G.LeftChatTabSeparator:Hide()
		_G.RightChatTabSeparator:Hide()
	elseif visibility =='LEFT' then
		_G.LeftChatTabSeparator:Show()
		_G.RightChatTabSeparator:Hide()
	else
		_G.LeftChatTabSeparator:Hide()
		_G.RightChatTabSeparator:Show()
	end
end

function module:CreateChatButtons()
	if E.db.mui.chat.chatButton ~= true or E.private.chat.enable ~= true then return end

	E.db.mui.chat.expandPanel = 150
	E.db.mui.chat.panelHeight = E.db.mui.chat.panelHeight or E.db.chat.panelHeight

	local panelBackdrop = E.db.chat.panelBackdrop
	local ChatButton = CreateFrame("Frame", "mUIChatButton", _G["LeftChatPanel"].backdrop)
	ChatButton:ClearAllPoints()
	ChatButton:Point("TOPLEFT", _G["LeftChatPanel"].backdrop, "TOPLEFT", 4, -8)
	ChatButton:Size(13, 13)
	if E.db.chat.panelBackdrop == "HIDEBOTH" or E.db.chat.panelBackdrop == "LEFT" then
		ChatButton:SetAlpha(0)
	else
		ChatButton:SetAlpha(0.55)
	end
	ChatButton:SetFrameLevel(_G["LeftChatPanel"]:GetFrameLevel() + 5)

	ChatButton.tex = ChatButton:CreateTexture(nil, "OVERLAY")
	ChatButton.tex:SetInside()
	ChatButton.tex:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\Textures\\chatButton")

	ChatButton:SetScript("OnMouseUp", function (self, btn)
		if InCombatLockdown() then return end
		if btn == "LeftButton" then
			if E.db.mui.chat.isExpanded then
				E.db.chat.panelHeight = E.db.chat.panelHeight - E.db.mui.chat.expandPanel
				CH:PositionChats()
				E.db.mui.chat.isExpanded = false
			else
				E.db.chat.panelHeight = E.db.chat.panelHeight + E.db.mui.chat.expandPanel
				CH:PositionChats()
				E.db.mui.chat.isExpanded = true
			end
		end
	end)

	ChatButton:SetScript("OnEnter", function(self)
		if GameTooltip:IsForbidden() then return end

		self:SetAlpha(0.8)
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 6)
		GameTooltip:ClearLines()
		if E.db.mui.chat.isExpanded then
			GameTooltip:AddLine(F.cOption(L["BACK"]), 'orange')
		else
			GameTooltip:AddLine(F.cOption(L["Expand the chat"]), 'orange')
		end
		GameTooltip:Show()
		if InCombatLockdown() then GameTooltip:Hide() end
	end)

	ChatButton:SetScript("OnLeave", function(self)
		if E.db.chat.panelBackdrop == "HIDEBOTH" or E.db.chat.panelBackdrop == "LEFT" then
			self:SetAlpha(0)
		else
			self:SetAlpha(0.55)
		end
		GameTooltip:Hide()
	end)
end

function module:Initialize()
	if E.private.chat.enable ~= true then return; end

	local db = E.db.mui.chat

	if db.customOnlineMessage then
		_G["ERR_FRIEND_ONLINE_SS"] = "%s "..L["ERR_FRIEND_ONLINE"]
		_G["ERR_FRIEND_OFFLINE_S"] = "%s "..L["ERR_FRIEND_OFFLINE"]

		_G["BN_INLINE_TOAST_FRIEND_ONLINE"] = "%s"..L["BN_INLINE_TOAST_FRIEND_ONLINE"]
		_G["BN_INLINE_TOAST_FRIEND_OFFLINE"] = "%s"..L["BN_INLINE_TOAST_FRIEND_OFFLINE"]
	end

	-- Remove the Realm Name from system messages
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", module.RemoveCurrentRealmName)

	module:EasyChannel()
	module:StyleChat()
	module:StyleVoicePanel()
	if E.Retail then
		module:ChatFilter()
	end
	module:DamageMeterFilter()
	module:LoadChatFade()
	module:UpdateSeperators()
	module:CreateChatButtons()

	--Custom Emojis
	local t = "|TInterface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\chatEmojis\\%s:16:16|t"

	-- Twitch Emojis
	CH:AddSmiley(':monkaomega:', format(t, 'monkaomega'))
	CH:AddSmiley(':salt:', format(t, 'salt'))
end

function module:Configure_All()
	module:Configure_ChatFade()
end

MER:RegisterModule(module:GetName())
