local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Chat')
local S = MER:GetModule('MER_Skins')
local CH = E:GetModule('Chat')
local LO = E:GetModule('Layout')

local _G = _G
local unpack = unpack
local format = format
local BetterDate = BetterDate
local gsub = string.gsub
local CreateFrame = CreateFrame
local ChatTypeInfo = ChatTypeInfo
local hooksecurefunc = hooksecurefunc
local UIParent = UIParent

local ChatFrame_SystemEventHandler = ChatFrame_SystemEventHandler

local r, g, b = unpack(E.media.rgbvaluecolor)

function module:AddMessage(msg, infoR, infoG, infoB, infoID, accessID, typeID, isHistory, historyTime)
	local historyTimestamp --we need to extend the arguments on AddMessage so we can properly handle times without overriding
	if isHistory == "ElvUI_ChatHistory" then historyTimestamp = historyTime end

	if (CH.db.timeStampFormat and CH.db.timeStampFormat ~= 'NONE' ) then
		local timeStamp = BetterDate(CH.db.timeStampFormat, historyTimestamp or CH:GetChatTime())
		timeStamp = gsub(timeStamp, ' $', '')
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
	if not E.db.mui.chat.chatButton or not E.private.chat.enable then return end

	E.db.mui.chat.expandPanel = 150
	E.db.mui.chat.panelHeight = E.db.mui.chat.panelHeight or E.db.chat.panelHeight

	local panelBackdrop = E.db.chat.panelBackdrop
	local ChatButton = CreateFrame("Frame", "mUIChatButton", _G["LeftChatPanel"].backdrop)
	ChatButton:ClearAllPoints()
	ChatButton:Point("TOPLEFT", _G["LeftChatPanel"].backdrop, "TOPLEFT", 4, -8)
	ChatButton:Size(13, 13)
	if E.db.chat.panelBackdrop == "HIDEBOTH" or E.db.chat.panelBackdrop == "ONLYRIGHT" then
		ChatButton:SetAlpha(0)
	else
		ChatButton:SetAlpha(0.55)
	end
	ChatButton:SetFrameLevel(_G["LeftChatPanel"]:GetFrameLevel() + 5)

	ChatButton.tex = ChatButton:CreateTexture(nil, "OVERLAY")
	ChatButton.tex:SetInside()
	ChatButton.tex:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\Textures\\chatButton")

	ChatButton:SetScript("OnMouseUp", function(self, btn)
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
		if E.db.chat.panelBackdrop == "HIDEBOTH" or E.db.chat.panelBackdrop == "ONLYRIGHT" then
			self:SetAlpha(0)
		else
			self:SetAlpha(0.55)
		end
		GameTooltip:Hide()
	end)
end

function module:UpdateRoleIcons()
	if not self.db or not self.db.roleIcons.enable then
		return
	end

	local pack = self.db.roleIcons.enable and self.db.roleIcons.roleIconStyle or "DEFAULT"
	local sizeString = self.db.roleIcons.enable and format(":%d:%d", self.db.roleIcons.roleIconSize, self.db.roleIcons.roleIconSize) or ":16:16"

	if pack ~= "DEFAULT" then
		sizeString = sizeString and (sizeString .. ":0:0:64:64:2:62:0:58")
	end

	if pack == "SUNUI" then
		CH.RoleIcons = {
			TANK = E:TextureString(MER.Media.Textures.sunTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.sunHealer, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.sunDPS, sizeString)
		}
	elseif pack == "LYNUI" then
		CH.RoleIcons = {
			TANK = E:TextureString(MER.Media.Textures.lynTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.lynHealer, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.lynDPS, sizeString)
		}
	elseif pack == "SVUI" then
		CH.RoleIcons = {
			TANK = E:TextureString(MER.Media.Textures.svuiTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.svuiHealer, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.svuiDPS, sizeString)
		}
	elseif pack == "DEFAULT" then
		CH.RoleIcons = {
			TANK = E:TextureString(E.Media.Textures.Tank, sizeString),
			HEALER = E:TextureString(E.Media.Textures.Healer, sizeString),
			DAMAGER = E:TextureString(E.Media.Textures.DPS, sizeString)
		}
	elseif pack == "CUSTOM" then
		CH.RoleIcons = {
			TANK = E:TextureString(MER.Media.Textures.customTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.customHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.customDPS, sizeString)
		}
	elseif pack == "GLOW" then
		CH.RoleIcons = {
			TANK = E:TextureString(MER.Media.Textures.glowTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.glowHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.glowDPS, sizeString)
		}
	elseif pack == "GLOW1" then
		CH.RoleIcons = {
			TANK = E:TextureString(MER.Media.Textures.glow1Tank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.glow1Heal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.gravedDPS, sizeString)
		}
	elseif pack == "GRAVED" then
		CH.RoleIcons = {
			TANK = E:TextureString(MER.Media.Textures.gravedTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.gravedHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.glow1DPS, sizeString)
		}
	elseif pack == "MAIN" then
		CH.RoleIcons = {
			TANK = E:TextureString(MER.Media.Textures.mainTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.mainHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.mainDPS, sizeString)
		}
	elseif pack == "WHITE" then
		CH.RoleIcons = {
			TANK = E:TextureString(MER.Media.Textures.whiteTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.whiteHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.whiteDPS, sizeString)
		}
	end
end

function module:AddCustomEmojis()
	--Custom Emojis
	local t = "|TInterface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\chatEmojis\\%s:16:16|t"

	-- Twitch Emojis
	CH:AddSmiley(':monkaomega:', format(t, 'monkaomega'))
	CH:AddSmiley(':salt:', format(t, 'salt'))
	CH:AddSmiley(':sadge:', format(t, 'sadge'))
end

local onlinestring
local offlinestring

local function ReplaceSystemMessage(_, event, message, ...)
	if not E.db.mui.chat.customOnlineMessage then
		return
	end

	if E.locale == "deDE" then
		onlinestring = "online"
		offlinestring = "offline"
	elseif E.locale == "enUS" or E.locale == "enGB" or E.locale == "enCN" or E.locale == "enTW" then
		onlinestring = "online"
		offlinestring = "offline"
	elseif E.locale == "zhCN" then
		onlinestring = "在线"
		offlinestring = "下线了"
	elseif E.locale == "zhTW" then
		onlinestring = "目前在線"
		offlinestring = "下線了"
	elseif E.locale == "esMX" or E.locale == "esES" then
		onlinestring = "conectado"
		offlinestring = " desconectado"
	elseif E.locale == "frFR" then
		onlinestring = "en ligne "
		offlinestring = "déconnecter"
	elseif E.locale == "itIT" then
		onlinestring = "online"
		offlinestring = "offline"
	elseif E.locale == "koKR" then
		onlinestring = "접속 중"
		offlinestring = "님이 게임을 종료했습니다."
	elseif E.locale == "ptBR" or E.locale == "ptPT" then
		onlinestring = "conectado"
		offlinestring = "desconectou"
	elseif E.locale == "ruRU" then
		onlinestring = "В сети"
		offlinestring = "выходит из игрового"
	end

	if message:find(onlinestring) then --german, english, italian all use the same online/offline
		return false, gsub(message, onlinestring, "|cff298F00"..onlinestring.."|r"), ...
	end

	if message:find(offlinestring) then
		return false, gsub(message, offlinestring, "|cffff0000"..offlinestring.."|r"), ...
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", ReplaceSystemMessage)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_ALERT", ReplaceSystemMessage)
ChatFrame_AddMessageEventFilter("ROLE_CHANGED_INFORM", ReplaceSystemMessage)
ChatFrame_AddMessageEventFilter("PLAYER_ROLES_ASSIGNED", ReplaceSystemMessage)

function module:Initialize()
	module.db = E.db.mui.chat
	if not module.db or not E.private.chat.enable then
		return
	end

	module:StyleChat()
	module:StyleVoicePanel()
	if E.Retail then
		module:ChatFilter()
	end
	module:DamageMeterFilter()
	module:LoadChatFade()
	-- module:UpdateSeperators()
	module:CreateChatButtons()
	module:UpdateRoleIcons()
	module:AddCustomEmojis()
end

function module:Configure_All()
	module:Configure_ChatFade()
end

MER:RegisterModule(module:GetName())
