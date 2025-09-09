local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_ChatBar") ---@class ChatBar : AceModule, AceHook-3.0, AceEvent-3.0
local S = MER:GetModule("MER_Skins")
local LSM = E.LSM

local _G = _G
local format = format
local ipairs = ipairs
local pairs = pairs
local sort = sort
local strmatch = strmatch
local tinsert = tinsert
local tostring = tostring

local ChatFrame_AddChannel = ChatFrame_AddChannel
local ChatFrame_OpenChat = ChatFrame_OpenChat
local CreateFrame = CreateFrame
local DefaultChatFrame = _G.DEFAULT_CHAT_FRAME
local GetChannelList = GetChannelList
local GetChannelName = GetChannelName
local InCombatLockdown = InCombatLockdown
local IsEveryoneAssistant = IsEveryoneAssistant
local IsInGroup = IsInGroup
local IsInGuild = IsInGuild
local IsInRaid = IsInRaid
local JoinPermanentChannel = JoinPermanentChannel
local LeaveChannelByName = LeaveChannelByName
local RandomRoll = RandomRoll
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader

local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE

local BUTTON_HOVER_FONT_SIZE_INCREASE = 4
local MOUSE_OVER_HEIGHT_PADDING = 6
local NORMAL_CHANNELS = { "SAY", "YELL", "PARTY", "INSTANCE", "RAID", "RAID_WARNING", "GUILD", "OFFICER", "EMOTE" }

local checkFunctions = {
	PARTY = function()
		return IsInGroup(LE_PARTY_CATEGORY_HOME)
	end,
	INSTANCE = function()
		return IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	end,
	RAID = function()
		return IsInRaid()
	end,
	RAID_WARNING = function()
		return IsInRaid() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant())
	end,
	GUILD = function()
		return IsInGuild()
	end,
	OFFICER = function()
		return IsInGuild() and C_GuildInfo_IsGuildOfficer()
	end,
}

---Get community channel ID by channel name
---@param text string The community channel name to search for
---@return number? channelId The channel ID if found
local function GetCommunityChannelByName(text)
	local channelList = { GetChannelList() }
	for _, v in pairs(channelList) do
		local clubId = strmatch(tostring(v), "Community:(.-):")
		if clubId then
			local info = C_Club_GetClubInfo(clubId)
			if info and info.name == text then
				return select(1, GetChannelName(tostring(v)))
			end
		end
	end
end

---Calculate the next button position offset
---@param anchor string The anchor direction ("LEFT" or "TOP")
---@param offsetX number Current X offset
---@param offsetY number Current Y offset
---@param buttonWidth number Width of the button
---@param buttonHeight number Height of the button
---@param spacing number Spacing between buttons
---@return number newOffsetX The new X offset
---@return number newOffsetY The new Y offset
local function CalculateNextOffset(anchor, offsetX, offsetY, buttonWidth, buttonHeight, spacing)
	if anchor == "LEFT" then
		return offsetX + buttonWidth + spacing, offsetY
	else
		return offsetX, offsetY - buttonHeight - spacing
	end
end

---Calculate the total size of the chat bar
---@param orientation string Bar orientation ("HORIZONTAL" or "VERTICAL")
---@param numberOfButtons number Total number of buttons
---@param spacing number Spacing between buttons
---@param buttonWidth number Width of each button
---@param buttonHeight number Height of each button
---@param hasBackdrop boolean Whether the bar has a backdrop
---@param backdropSpacing number Spacing for the backdrop
---@return number width The calculated bar width
---@return number height The calculated bar height
local function CalculateBarSize(
	orientation,
	numberOfButtons,
	spacing,
	buttonWidth,
	buttonHeight,
	hasBackdrop,
	backdropSpacing
)
	local width, height

	if hasBackdrop then
		if orientation == "HORIZONTAL" then
			width = backdropSpacing * 2 + buttonWidth * numberOfButtons + spacing * (numberOfButtons - 1)
			height = backdropSpacing * 2 + buttonHeight
		else
			width = backdropSpacing * 2 + buttonWidth
			height = backdropSpacing * 2 + buttonHeight * numberOfButtons + spacing * (numberOfButtons - 1)
		end
	else
		if orientation == "HORIZONTAL" then
			width = buttonWidth * numberOfButtons + spacing * (numberOfButtons - 1)
			height = buttonHeight
		else
			width = buttonWidth
			height = buttonHeight * numberOfButtons + spacing * (numberOfButtons - 1)
		end
	end

	return width, height
end

---Get the initial offset for button positioning
---@param hasBackdrop boolean Whether the bar has a backdrop
---@param backdropSpacing number Spacing for the backdrop
---@param anchor string The anchor direction ("LEFT" or "TOP")
---@return number offsetX The initial X offset
---@return number offsetY The initial Y offset
local function GetInitialOffset(hasBackdrop, backdropSpacing, anchor)
	local offsetX, offsetY = 0, 0

	if hasBackdrop then
		if anchor == "LEFT" then
			offsetX = offsetX + backdropSpacing
		else
			offsetY = offsetY - backdropSpacing
		end
	end

	return offsetX, offsetY
end

---Find the best matching world channel configuration
---@param configTable table Array of channel configurations
---@return table? config The best matching configuration or nil
local function GetBestWorldChannelConfig(configTable)
	local validConfigs = {}

	for _, c in pairs(configTable) do
		if
			(c.region == "ALL" or c.region == MER.RealRegion)
			and (c.faction == "ALL" or c.faction == E.myfaction)
			and (c.realmID == "ALL" or c.realmID == MER.CurrentRealmID)
		then
			tinsert(validConfigs, c)
		end
	end

	sort(validConfigs, function(a, b)
		if a.region ~= "ALL" and b.region == "ALL" then
			return true
		end

		if a.region == "ALL" and b.region ~= "ALL" then
			return false
		end

		if a.faction ~= "ALL" and b.faction == "ALL" then
			return true
		end

		if a.faction == "ALL" and b.faction ~= "ALL" then
			return false
		end

		if a.realmID == "ALL" and b.realmID ~= "ALL" then
			return true
		end

		return false
	end)

	return validConfigs[1]
end

function module:OnEnterBar()
	if self.db.mouseOver then
		E:UIFrameFadeIn(self.bar, 0.2, self.bar:GetAlpha(), 1)
	end
end

function module:OnLeaveBar()
	if self.db.mouseOver then
		E:UIFrameFadeOut(self.bar, 0.2, self.bar:GetAlpha(), 0)
	end
end

---Update or create a chat button
---@param name string The button name/identifier
---@param func function The click handler function
---@param anchorPoint string The anchor point for positioning
---@param x number X position offset
---@param y number Y position offset
---@param color RGBA? Color configuration for the button
---@param tex string? Texture name for block style
---@param tooltip string? Tooltip text
---@param tips table? Array of tooltip tips
---@param abbr string Button abbreviation or icon
---@return Button button The created or updated button
function module:UpdateButton(name, func, anchorPoint, x, y, color, tex, tooltip, tips, abbr)
	local ElvUIValueColor = E.db.general.valuecolor

	if not self.bar[name] then
		local button = CreateFrame("Button", nil, self.bar, "SecureActionButtonTemplate, BackdropTemplate")
		button:StripTextures()
		button:SetBackdropBorderColor(0, 0, 0)
		button:RegisterForClicks("AnyDown")
		button:SetScript("OnMouseUp", func)

		button.colorBlock = button:CreateTexture(nil, "ARTWORK")
		button.colorBlock:SetAllPoints()
		button:CreateBackdrop("Transparent")
		S:CreateShadow(button.backdrop, 3, nil, nil, nil, true)

		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:Point("CENTER", button, "CENTER", 0, 0)
		F.SetFontDB(button.text, self.db.font)
		button.defaultFontSize = self.db.font.size

		-- Tooltip
		button:SetScript("OnEnter", function(btn)
			if module.db.style == "BLOCK" then
				if btn.backdrop.shadow then
					btn.backdrop.shadow:SetBackdropBorderColor(ElvUIValueColor.r, ElvUIValueColor.g, ElvUIValueColor.b)
					btn.backdrop.shadow:Show()
				end
			else
				local fontName, _, fontFlags = btn.text:GetFont()
				btn.text:FontTemplate(fontName, btn.defaultFontSize + BUTTON_HOVER_FONT_SIZE_INCREASE, fontFlags)
			end

			_G.GameTooltip:SetOwner(btn, "ANCHOR_TOP", 0, 7)
			_G.GameTooltip:SetText(button.tooltip or _G[name] or "")

			if tips then
				for _, tip in ipairs(button.tips) do
					_G.GameTooltip:AddLine(tip)
				end
			end

			_G.GameTooltip:Show()
		end)

		button:SetScript("OnLeave", function(btn)
			_G.GameTooltip:Hide()
			if module.db.style == "BLOCK" then
				btn.backdrop.MERshadow:SetBackdropBorderColor(0, 0, 0)

				if not module.db.blockShadow then
					if btn.backdrop.MERshadow then
						btn.backdrop.MERshadow:Hide()
					end
				end
			else
				local fontName, _, fontFlags = btn.text:GetFont()
				btn.text:FontTemplate(fontName, btn.defaultFontSize, fontFlags)
			end
		end)

		self:HookScript(button, "OnEnter", "OnEnterBar")
		self:HookScript(button, "OnLeave", "OnLeaveBar")

		self.bar[name] = button
	end

	self.bar[name].tooltip = tooltip
	self.bar[name].tips = tips

	-- Block style
	if self.db.style == "BLOCK" then
		self.bar[name].colorBlock:SetTexture(tex and LSM:Fetch("statusbar", tex) or E.media.normTex)

		if color then
			self.bar[name].colorBlock:SetVertexColor(color.r, color.g, color.b, color.a)
		end

		self.bar[name].colorBlock:Show()
		self.bar[name].backdrop:Show()
		if self.bar[name].backdrop.shadow then
			if self.db.blockShadow then
				self.bar[name].backdrop.shadow:Show()
			else
				self.bar[name].backdrop.shadow:Hide()
			end
		end

		self.bar[name].text:Hide()
	else
		local buttonText = self.db.color and color and F.CreateColorString(abbr, color) or abbr
		self.bar[name].text:SetText(buttonText)
		self.bar[name].defaultFontSize = self.db.font.size
		F.SetFontDB(self.bar[name].text, self.db.font)
		self.bar[name].text:Show()

		self.bar[name].colorBlock:Hide()
		self.bar[name].backdrop:Hide()
	end

	-- Update size and position
	self.bar[name]:Size(module.db.buttonWidth, module.db.buttonHeight)
	self.bar[name]:ClearAllPoints()
	self.bar[name]:Point(anchorPoint, module.bar, anchorPoint, x, y)

	self.bar[name]:Show()
	return self.bar[name]
end

---Hide/disable a chat button
---@param name string The button name to disable
function module:DisableButton(name)
	if self.bar[name] then
		self.bar[name]:Hide()
	end
end

function module:UpdateBar()
	if not self.bar then
		return
	end

	if InCombatLockdown() then
		F.TaskManager:AfterCombat(self.UpdateBar, self)
		return
	end

	local numberOfButtons = 0
	local orientation, hasBackdrop, backdropSpacing = self.db.orientation, self.db.backdrop, self.db.backdropSpacing
	local buttonWidth, buttonHeight, spacing = self.db.buttonWidth, self.db.buttonHeight, self.db.spacing
	local anchor = self.db.orientation == "HORIZONTAL" and "LEFT" or "TOP"
	local offsetX, offsetY = GetInitialOffset(hasBackdrop, backdropSpacing, anchor)

	for _, name in ipairs(NORMAL_CHANNELS) do
		local db = self.db.channels[name]
		local show = db and db.enable

		if show and self.db.autoHide then
			if checkFunctions[name] then
				show = checkFunctions[name]() and true or false
			end
		end

		if show then
			local chatFunc = function(_, mouseButton)
				if mouseButton ~= "LeftButton" or not db.cmd then
					return
				end
				local currentText = DefaultChatFrame.editBox:GetText()
				local command = format("/%s ", db.cmd)
				ChatFrame_OpenChat(command .. currentText, DefaultChatFrame)
			end

			self:UpdateButton(name, chatFunc, anchor, offsetX, offsetY, db.color, self.db.tex, nil, nil, db.abbr)
			numberOfButtons = numberOfButtons + 1
			offsetX, offsetY = CalculateNextOffset(anchor, offsetX, offsetY, buttonWidth, buttonHeight, spacing)
		else
			self:DisableButton(name)
		end
	end

	if self.db.channels.world.enable then
		local db = self.db.channels.world
		local config = GetBestWorldChannelConfig(db.config)

		if not config or not config.name or config.name == "" then
			F.Print(L["World channel no found, please setup again."])
			self:DisableButton("WORLD")
		else
			local chatFunc = function(_, mouseButton)
				local channelId = GetChannelName(config.name)
				if mouseButton == "LeftButton" then
					local autoJoined = false
					if channelId == 0 and config.autoJoin then
						JoinPermanentChannel(config.name)
						ChatFrame_AddChannel(DefaultChatFrame, config.name)
						channelId = GetChannelName(config.name)
						autoJoined = true
					end
					if channelId == 0 then
						return
					end
					local currentText = DefaultChatFrame.editBox:GetText()
					local command = format("/%s ", channelId)
					if autoJoined then
						-- If the channel is just joined, delay a bit to let the server process it
						E:Delay(0.5, ChatFrame_OpenChat, command .. currentText, DefaultChatFrame)
					else
						ChatFrame_OpenChat(command .. currentText, DefaultChatFrame)
					end
				elseif mouseButton == "RightButton" then
					if channelId == 0 then
						JoinPermanentChannel(config.name)
						ChatFrame_AddChannel(DefaultChatFrame, config.name)
					else
						LeaveChannelByName(config.name)
					end
				end
			end

			self:UpdateButton("WORLD", chatFunc, anchor, offsetX, offsetY, db.color, self.db.tex, config.name, {
				L["Left Click: Change to"] .. " " .. config.name,
				L["Right Click: Join/Leave"] .. " " .. config.name,
			}, db.abbr)

			numberOfButtons = numberOfButtons + 1
			offsetX, offsetY = CalculateNextOffset(anchor, offsetX, offsetY, buttonWidth, buttonHeight, spacing)
		end
	else
		self:DisableButton("WORLD")
	end

	if self.db.channels.community.enable then
		local db = self.db.channels.community
		local name = db.name
		if not name or name == "" then
			F.Print(L["Club channel no found, please setup again."])
			self:DisableButton("CLUB")
		else
			local chatFunc = function(_, mouseButton)
				if mouseButton ~= "LeftButton" then
					return
				end
				local clubChannelId = GetCommunityChannelByName(name)
				if not clubChannelId then
					F.Print(format(L["Club channel %s no found, please use the full name of the channel."], name))
				else
					local currentText = DefaultChatFrame.editBox:GetText()
					local command = format("/%s ", clubChannelId)
					ChatFrame_OpenChat(command .. currentText, DefaultChatFrame)
				end
			end

			self:UpdateButton("CLUB", chatFunc, anchor, offsetX, offsetY, db.color, self.db.tex, name, nil, db.abbr)

			numberOfButtons = numberOfButtons + 1
			offsetX, offsetY = CalculateNextOffset(anchor, offsetX, offsetY, buttonWidth, buttonHeight, spacing)
		end
	else
		self:DisableButton("CLUB")
	end

	if self.db.channels.emote.enable and E.db.WT.social.emote.enable then
		local db = self.db.channels.emote

		local chatFunc = function(btn, mouseButton)
			if mouseButton == "LeftButton" then
				if _G.MER_CustomEmoteFrame then
					if _G.MER_CustomEmoteFrame:IsShown() then
						_G.MER_CustomEmoteFrame:Hide()
					else
						_G.MER_CustomEmoteFrame:Show()
					end
				else
					F.Print(L["Please enable Emote module in MerathilisUI Chat category."])
				end
			end
		end

		local abbr = db.icon
				and ("|TInterface\\AddOns\\ElvUI_MerathilisUI\\Media\\Emotes\\mario:" .. self.db.font.size .. "|t")
			or db.abbr
		self:UpdateButton(
			"MEREmote",
			chatFunc,
			anchor,
			offsetX,
			offsetY,
			db.color,
			self.db.tex,
			"MER " .. L["Emote"],
			{ L["Left Click: Toggle"] },
			abbr
		)
		numberOfButtons = numberOfButtons + 1
		offsetX, offsetY =
			CalculateNextOffset(anchor, offsetX, offsetY, self.db.buttonWidth, self.db.buttonHeight, self.db.spacing)
	else
		self:DisableButton("MEREmote")
	end

	if self.db.channels.roll.enable then
		local db = self.db.channels.roll

		local chatFunc = function(_, mouseButton)
			if mouseButton == "LeftButton" then
				RandomRoll(1, 100)
			end
		end

		local abbr = (db.icon and "|TInterface\\Buttons\\UI-GroupLoot-Dice-Up:" .. self.db.font.size .. "|t") or db.abbr

		self:UpdateButton("ROLL", chatFunc, anchor, offsetX, offsetY, db.color, self.db.tex, nil, nil, abbr)

		numberOfButtons = numberOfButtons + 1
		offsetX, offsetY =
			CalculateNextOffset(anchor, offsetX, offsetY, self.db.buttonWidth, self.db.buttonHeight, self.db.spacing)
	else
		self:DisableButton("ROLL")
	end

	-- Update the size of the bar
	local width, height =
		CalculateBarSize(orientation, numberOfButtons, spacing, buttonWidth, buttonHeight, hasBackdrop, backdropSpacing)

	if self.db.mouseOver then
		self.bar:SetAlpha(0)
		if not self.db.backdrop then
			height = height + MOUSE_OVER_HEIGHT_PADDING
		end
	else
		self.bar:SetAlpha(1)
	end

	self.bar:Size(width, height)

	if self.db.backdrop then
		self.bar.backdrop:Show()
		if E.private.mui.skins.shadow.enable and self.bar.MERshadow then
			self.bar.MERshadow:Show()
		end
	else
		self.bar.backdrop:Hide()
		if E.private.mui.skins.shadow.enable and self.bar.MERshadow then
			self.bar.MERshadow:Hide()
		end
	end
end

module.UpdateBar = F.ThrottleFunction(0.1, module.UpdateBar)

function module:CreateBar()
	if self.bar then
		return
	end

	local bar = CreateFrame("Frame", "MER_ChatBar", E.UIParent, "SecureHandlerStateTemplate")

	bar:SetResizable(false)
	bar:SetClampedToScreen(true)
	bar:SetFrameStrata("LOW")
	bar:SetFrameLevel(5)
	bar:CreateBackdrop("Transparent")
	bar:ClearAllPoints()
	bar:Point("BOTTOMLEFT", _G.LeftChatPanel, "TOPLEFT", 6, 3)
	S:CreateBackdropShadow(bar)

	self.bar = bar

	self:HookScript(self.bar, "OnEnter", "OnEnterBar")
	self:HookScript(self.bar, "OnLeave", "OnLeaveBar")
end

function module:Initialize()
	self.db = E.db.mui.chat.chatBar
	if not self.db.enable then
		return
	end

	module:CreateBar()
	module:UpdateBar()

	E:CreateMover(module.bar, "ChatBarMover", MER.Title .. L["Chat Bar"], nil, nil, nil, "ALL,MERATHILISUI", function()
		return module.db.enable
	end, "mui,modules,chat,chatBar")

	if self.db.autoHide then
		self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateBar")
		self:RegisterEvent("PLAYER_GUILD_UPDATE", "UpdateBar")
	end
end

function module:ProfileUpdate()
	self.db = E.db.mui.chat.chatBar

	if not self.db.enable then
		if self.bar then
			self.bar:Hide()
		end
		return
	end

	if self.db.enable and not self.bar then
		self:Initialize()
	end

	self.bar:Show()

	if self.db.autoHide then
		self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateBar")
		self:RegisterEvent("PLAYER_GUILD_UPDATE", "UpdateBar")
	else
		self:UnregisterEvent("GROUP_ROSTER_UPDATE")
		self:UnregisterEvent("PLAYER_GUILD_UPDATE")
	end
end

MER:RegisterModule(module:GetName())
