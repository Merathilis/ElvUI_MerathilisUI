local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Chat')
local S = MER:GetModule('MER_Skins')
local CH = E:GetModule('Chat')
local LO = E:GetModule('Layout')

local _G = _G
local format = format
local BetterDate = BetterDate
local gsub = string.gsub
local CreateFrame = CreateFrame
local ChatTypeInfo = ChatTypeInfo
local hooksecurefunc = hooksecurefunc
local UIParent = UIParent
local C_Timer_After = C_Timer.After
local C_PartyInfo_InviteUnit = C_PartyInfo.InviteUnit

local ChatFrame_SystemEventHandler = ChatFrame_SystemEventHandler

local PLAYER_REALM = E:ShortenRealm(E.myrealm)
local PLAYER_NAME = format("%s-%s", E.myname, PLAYER_REALM)

module.cache = {}
local lfgRoles = {}

local offlineMessageTemplate = "%s " .. _G.ERR_FRIEND_OFFLINE_S
local offlineMessagePattern = gsub(_G.ERR_FRIEND_OFFLINE_S, "%%s", "(.+)")
offlineMessagePattern = format("^%s$", offlineMessagePattern)

local onlineMessageTemplate = gsub(_G.ERR_FRIEND_ONLINE_SS, "%[%%s%]", "%%s %%s")
local onlineMessagePattern = gsub(_G.ERR_FRIEND_ONLINE_SS, "|Hplayer:%%s|h%[%%s%]|h", "|Hplayer:(.+)|h%%[(.+)%%]|h")
onlineMessagePattern = format("^%s$", onlineMessagePattern)

local achievementMessageTemplate = L["%player% has earned the achievement %achievement%!"]
local achievementMessageTemplateMultiplePlayers = L["%players% have earned the achievement %achievement%!"]

local guildPlayerCache = {}
local blockedMessageCache = {}
local achievementMessageCache = {
	byAchievement = {},
	byPlayer = {}
}

local roleIcons

module.cache.elvuiRoleIconsPath = {
	Tank = E.Media.Textures.Tank,
	Healer = E.Media.Textures.Healer,
	DPS = E.Media.Textures.DPS
}

module.cache.blizzardRoleIcons = {
	Tank = _G.INLINE_TANK_ICON,
	Healer = _G.INLINE_HEALER_ICON,
	DPS = _G.INLINE_DAMAGER_ICON
}

local function updateGuildPlayerCache(self, event)
	if not (event == "PLAYER_ENTERING_WORLD" or event == "FORCE_UPDATE") then
		return
	end

	if not IsInGuild() then
		return
	end

	for i = 1, GetNumGuildMembers() do
		local name, _, _, _, _, _, _, _, _, _, className = GetGuildRosterInfo(i)
		name = Ambiguate(name, "none")
		guildPlayerCache[name] = className
	end
end

local function addSpaceForAsian(text, revert)
	if MER.Locale == "zhCN" or MER.Locale == "zhTW" or MER.Locale == "koKR" then
		return revert and " " .. text or text .. " "
	end
	return text
end

function module:AddMessage(msg, infoR, infoG, infoB, infoID, accessID, typeID, isHistory, historyTime)
	local historyTimestamp --we need to extend the arguments on AddMessage so we can properly handle times without overriding
	if isHistory == "ElvUI_ChatHistory" then historyTimestamp = historyTime end

	if (CH.db.timeStampFormat and CH.db.timeStampFormat ~= 'NONE') then
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

function module:StyleVoicePanel()
	if _G.ElvUIChatVoicePanel then
		_G.ElvUIChatVoicePanel:Styling()
		S:CreateShadow(_G.ElvUIChatVoicePanel)
	end
end

function module:CreateSeparators()
	if not E.db.mui.chat.seperators.enable then return end

	--Left Chat Tab Separator
	local ltabseparator = CreateFrame('Frame', 'LeftChatTabSeparator', _G.LeftChatPanel, "BackdropTemplate")
	ltabseparator:SetFrameStrata('BACKGROUND')
	ltabseparator:SetFrameLevel(_G.LeftChatPanel:GetFrameLevel() + 2)
	ltabseparator:Height(1)
	ltabseparator:Point('TOPLEFT', _G.LeftChatPanel, 5, -24)
	ltabseparator:Point('TOPRIGHT', _G.LeftChatPanel, -5, -24)
	ltabseparator:SetTemplate('Transparent')
	ltabseparator:Hide()
	_G.LeftChatTabSeparator = ltabseparator

	--Right Chat Tab Separator
	local rtabseparator = CreateFrame('Frame', 'RightChatTabSeparator', _G.RightChatPanel, "BackdropTemplate")
	rtabseparator:SetFrameStrata('BACKGROUND')
	rtabseparator:SetFrameLevel(_G.RightChatPanel:GetFrameLevel() + 2)
	rtabseparator:Height(1)
	rtabseparator:Point('TOPLEFT', _G.RightChatPanel, 5, -24)
	rtabseparator:Point('TOPRIGHT', _G.RightChatPanel, -5, -24)
	rtabseparator:SetTemplate('Transparent')
	rtabseparator:Hide()
	_G.RightChatTabSeparator = rtabseparator

	module:UpdateSeperators()
end
hooksecurefunc(LO, "CreateChatPanels", module.CreateSeparators)

function module:UpdateSeperators()
	if not E.db.mui.chat.seperators.enable then return end

	local myVisibility = E.db.mui.chat.seperators.visibility
	local elvVisibility = E.db.chat.panelBackdrop
	if myVisibility == 'SHOWBOTH' or elvVisibility == 'SHOWBOTH' then
		if _G.LeftChatTabSeparator then
			_G.LeftChatTabSeparator:Show()
		end
		if _G.RightChatTabSeparator then
			_G.RightChatTabSeparator:Show()
		end
	elseif myVisibility == 'HIDEBOTH' or elvVisibility == 'HIDEBOTH' then
		if _G.LeftChatTabSeparator then
			_G.LeftChatTabSeparator:Hide()
		end
		if _G.RightChatTabSeparator then
			_G.RightChatTabSeparator:Hide()
		end
	elseif myVisibility == 'LEFT' or elvVisibility == 'LEFT' then
		if _G.LeftChatTabSeparator then
			_G.LeftChatTabSeparator:Show()
		end
		if _G.RightChatTabSeparator then
			_G.RightChatTabSeparator:Hide()
		end
	else
		if _G.LeftChatTabSeparator then
			_G.LeftChatTabSeparator:Hide()
		end
		if _G.RightChatTabSeparator then
			_G.RightChatTabSeparator:Show()
		end
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

	if pack ~= "DEFAULT" and pack ~= "BLIZZARD" then
		sizeString = sizeString and (sizeString .. ":0:0:64:64:2:62:0:58")
	end

	if pack == "SUNUI" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.sunTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.sunHealer, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.sunDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "LYNUI" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.lynTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.lynHealer, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.lynDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "SVUI" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.svuiTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.svuiHealer, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.svuiDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "DEFAULT" then
		roleIcons = {
			TANK = E:TextureString(module.cache.elvuiRoleIconsPath.Tank, sizeString .. ":0:0:64:64:2:56:2:56"),
			HEALER = E:TextureString(module.cache.elvuiRoleIconsPath.Healer, sizeString .. ":0:0:64:64:2:56:2:56"),
			DAMAGER = E:TextureString(module.cache.elvuiRoleIconsPath.DPS, sizeString)
		}

		_G.INLINE_TANK_ICON = module.cache.blizzardRoleIcons.Tank
		_G.INLINE_HEALER_ICON = module.cache.blizzardRoleIcons.Healer
		_G.INLINE_DAMAGER_ICON = module.cache.blizzardRoleIcons.DPS
	elseif pack == "BLIZZARD" then
		roleIcons = {
			TANK = gsub(module.cache.blizzardRoleIcons.Tank, ":16:16", sizeString),
			HEALER = gsub(module.cache.blizzardRoleIcons.Healer, ":16:16", sizeString),
			DAMAGER = gsub(module.cache.blizzardRoleIcons.DPS, ":16:16", sizeString)
		}

		_G.INLINE_TANK_ICON = module.cache.blizzardRoleIcons.Tank
		_G.INLINE_HEALER_ICON = module.cache.blizzardRoleIcons.Healer
		_G.INLINE_DAMAGER_ICON = module.cache.blizzardRoleIcons.DPS
	elseif pack == "CUSTOM" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.customTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.customHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.customDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "GLOW" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.glowTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.glowHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.glowDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "GLOW1" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.glow1Tank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.glow1Heal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.gravedDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "GRAVED" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.gravedTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.gravedHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.glow1DPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "MAIN" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.mainTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.mainHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.mainDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "WHITE" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.whiteTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.whiteHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.whiteDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	elseif pack == "MATERIAL" then
		roleIcons = {
			TANK = E:TextureString(MER.Media.Textures.materialTank, sizeString),
			HEALER = E:TextureString(MER.Media.Textures.materialHeal, sizeString),
			DAMAGER = E:TextureString(MER.Media.Textures.materialDPS, sizeString)
		}

		_G.INLINE_TANK_ICON = roleIcons.TANK
		_G.INLINE_HEALER_ICON = roleIcons.HEALER
		_G.INLINE_DAMAGER_ICON = roleIcons.DAMAGER
	end
end

function module:CheckLFGRoles()
	if not CH.db.lfgIcons or not IsInGroup() then
		return
	end
	wipe(lfgRoles)

	local playerRole = UnitGroupRolesAssigned("player")
	if playerRole then
		lfgRoles[PLAYER_NAME] = roleIcons[playerRole]
	end

	local unit = (IsInRaid() and "raid" or "party")
	for i = 1, GetNumGroupMembers() do
		if UnitExists(unit .. i) and not UnitIsUnit(unit .. i, "player") then
			local role = UnitGroupRolesAssigned(unit .. i)
			local name, realm = UnitName(unit .. i)

			if role and name then
				name = (realm and realm ~= "" and name .. "-" .. realm) or name .. "-" .. PLAYER_REALM
				lfgRoles[name] = roleIcons[role]
			end
		end
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
		f.text:SetTextColor(F.r, F.g, F.b)
		f.text:SetJustifyH("CENTER")
		f.text:SetJustifyV("MIDDLE")
		f.text:Height(20)
		f.text:Point("CENTER", f, "CENTER", 0, 0)

		f:EnableMouse(true)
		f:RegisterForClicks("AnyUp")
		f:SetScript("OnClick", function(...)
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

function module.GuildMemberStatusMessageHandler(_, _, msg)
	if not module.db or not module.db.enable or not module.db.guildMemberStatus then
		return
	end

	local name, class, link, resultText

	if blockedMessageCache[msg] then
		return true
	end

	name = strmatch(msg, offlineMessagePattern)
	if not name then
		link, name = strmatch(msg, onlineMessagePattern)
	end

	if name then
		class = guildPlayerCache[name]
		if not class then
			updateGuildPlayerCache(nil, "FORCE_UPDATE")
			class = guildPlayerCache[name]
		end
	end

	if class then
		blockedMessageCache[msg] = true

		C_Timer_After(0.1, function()
			blockedMessageCache[msg] = nil
		end)

		local coloredName = F.CreateClassColorString(name, link and guildPlayerCache[link] or guildPlayerCache[name])

		coloredName = addSpaceForAsian(coloredName)
		local classIcon = F.GetClassIconStringWithStyle(class, module.db.classIconStyle, 16, 16)

		if coloredName and classIcon then
			if link then
				resultText = format(onlineMessageTemplate, link, classIcon, coloredName)
				if module.db.guildMemberStatusInviteLink then
					local windInviteLink =
						format("|Hwtinvite:%s|h%s|h", link, F.StringByTemplate(format("[%s]", L["Invite"]), "info"))
					resultText = resultText .. " " .. windInviteLink
				end
				_G.ChatFrame1:AddMessage(resultText, F.RGBFromTemplate("success"))
			else
				resultText = format(offlineMessageTemplate, classIcon, coloredName)
				_G.ChatFrame1:AddMessage(resultText, F.RGBFromTemplate("danger"))
			end

			return true
		end
	end

	return false
end

function module.SendAchivementMessage()
	if not module.db or not module.db.enable or not module.db.mergeAchievement then
		return
	end

	local channelData = {
		{ event = "CHAT_MSG_GUILD_ACHIEVEMENT", color = ChatTypeInfo.GUILD },
		{ event = "CHAT_MSG_ACHIEVEMENT",       color = ChatTypeInfo.SYSTEM }
	}

	for _, data in ipairs(channelData) do
		local event, color = data.event, data.color
		if achievementMessageCache.byPlayer[event] then
			for playerString, achievementTable in pairs(achievementMessageCache.byPlayer[event]) do
				local players = { strsplit("=", playerString) }

				local achievementLinks = {}
				for achievementID in pairs(achievementTable) do
					tinsert(achievementLinks, GetAchievementLink(achievementID))
				end

				local message = nil

				if #players == 1 then
					message = gsub(achievementMessageTemplate, "%%player%%", addSpaceForAsian(players[1]))
				elseif #players > 1 then
					message = gsub(achievementMessageTemplateMultiplePlayers, "%%players%%", addSpaceForAsian(strjoin(", ", unpack(players))))
				end

				if message then
					message = gsub(message, "%%achievement%%", addSpaceForAsian(strjoin(", ", unpack(achievementLinks)), true))
					_G.ChatFrame1:AddMessage(message, color.r, color.g, color.b)
				end
			end
			wipe(achievementMessageCache.byPlayer[event])
		end
	end
end

function module.AchievementMessageHandler(_, event, ...)
	if not module.db or not module.db.enable or not module.db.mergeAchievement then
		return
	end

	local achievementMessage = select(1, ...)
	local guid = select(12, ...)

	if not guid then
		return
	end

	if not achievementMessageCache.byAchievement[event] then
		achievementMessageCache.byAchievement[event] = {}
	end

	if not achievementMessageCache.byPlayer[event] then
		achievementMessageCache.byPlayer[event] = {}
	end

	local cache = achievementMessageCache.byAchievement[event]
	local cacheByPlayer = achievementMessageCache.byPlayer[event]

	local achievementID = strmatch(achievementMessage, "|Hachievement:(%d+):")
	if not achievementID then
		return
	end

	if not cache[achievementID] then
		cache[achievementID] = {}
		C_Timer_After(0.1, function()
				local players = {}
				for k in pairs(cache[achievementID]) do
					tinsert(players, k)
				end

				if #players >= 1 then
					local playerString = strjoin("=", unpack(players))

					if not cacheByPlayer[playerString] then
						cacheByPlayer[playerString] = {}
					end

					cacheByPlayer[playerString][achievementID] = true

					if not module.waitForAchievementMessage then
						module.waitForAchievementMessage = true
						C_Timer_After(0.2, function()
							module.SendAchivementMessage()
							module.waitForAchievementMessage = false
						end)
					end
				end

				cache[achievementID] = nil
			end)
	end

	local playerInfo = CH:GetPlayerInfoByGUID(guid)
	if not playerInfo or not playerInfo.englishClass or not playerInfo.name or not playerInfo.nameWithRealm then
		return
	end

	local coloredName = F.CreateClassColorString(playerInfo.nameWithRealm, playerInfo.englishClass)
	local classIcon = F.GetClassIconStringWithStyle(playerInfo.englishClass, "flat", 16, 16)

	if coloredName and classIcon and cache[achievementID] then
		local playerName = format("|Hplayer:%s|h%s %s|h", playerInfo.nameWithRealm, classIcon, coloredName)
		cache[achievementID][playerName] = true
		return true
	end
end

function module:BetterSystemMessage()
	if not module.db then
		return
	end

	if module.db.guildMemberStatus and not module.isSystemMessageHandled then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", module.GuildMemberStatusMessageHandler)

		local setHyperlink = _G.ItemRefTooltip.SetHyperlink
		function _G.ItemRefTooltip:SetHyperlink(data, ...)
			if strsub(data, 1, 8) == "wtinvite" then
				local player = strmatch(data, "wtinvite:(.+)")
				if player then
					C_PartyInfo_InviteUnit(player)
					return
				end
			end
			setHyperlink(self, data, ...)
		end

		module.isSystemMessageHandled = true
	end

	if module.db.mergeAchievement and not module.isAchievementHandled then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_ACHIEVEMENT", module.AchievementMessageHandler)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", module.AchievementMessageHandler)
		module.isAchievementHandled = true
	end
end

function module:Initialize()
	module.db = E.db.mui.chat
	if not module.db or not E.private.chat.enable then
		return
	end

	module:StyleChat()
	module:StyleVoicePanel()
	module:DamageMeterFilter()
	module:LoadChatFade()
	module:UpdateSeperators()
	module:CreateChatButtons()
	module:UpdateRoleIcons()
	module:AddCustomEmojis()
	module:CheckLFGRoles()
	module:BetterSystemMessage()

	if E.Retail then
		module:ChatFilter()
	end
end

function module:ProfileUpdate()
	module.db = E.db.mui.chat
	if not module.db then
		return
	end

	module:UpdateRoleIcons()
	module:AddCustomEmojis()
	module:CheckLFGRoles()
	module:BetterSystemMessage()
end

MER:RegisterModule(module:GetName())
