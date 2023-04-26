local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Mail')
local S = MER:GetModule('MER_Skins')
local ES = E:GetModule('Skins')

-- Credits: WindTools :)
local _G = _G
local floor = floor
local format = format
local pairs = pairs
local select = select
local tinsert = tinsert
local unpack = unpack

local BNGetNumFriends = BNGetNumFriends
local CreateFrame = CreateFrame
local DeleteInboxItem = DeleteInboxItem
local EasyMenu = EasyMenu
local GameTooltip = _G.GameTooltip
local GetClassColor = GetClassColor
local GetInboxItem = GetInboxItem
local GetInboxNumItems = GetInboxNumItems
local GetItemQualityColor = GetItemQualityColor
local GetItemInfo = GetItemInfo
local InboxItemCanDelete = InboxItemCanDelete
local IsInGuild = IsInGuild
local hooksecurefunc = hooksecurefunc

local C_BattleNet_GetFriendAccountInfo = C_BattleNet and C_BattleNet.GetFriendAccountInfo
local C_BattleNet_GetFriendGameAccountInfo = C_BattleNet and C_BattleNet.GetFriendGameAccountInfo
local C_BattleNet_GetFriendNumGameAccounts = C_BattleNet and C_BattleNet.GetFriendNumGameAccounts
local C_FriendList_GetFriendInfoByIndex = C_FriendList.GetFriendInfoByIndex
local C_FriendList_GetNumOnlineFriends = C_FriendList.GetNumOnlineFriends
local GetInboxHeaderInfo = GetInboxHeaderInfo
local C_Mail_IsCommandPending = C_Mail.IsCommandPending
local C_Mail_HasInboxMoney = C_Mail.HasInboxMoney
local GetMoney = GetMoney
local GetSendMailPrice = GetSendMailPrice
local TakeInboxMoney = TakeInboxMoney
local TakeInboxItem = TakeInboxItem

local GetNumGuildMembers = GetNumGuildMembers
local GetGuildRosterInfo = GetGuildRosterInfo

local LOCALIZED_CLASS_NAMES_FEMALE = LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE

local currentPageIndex
local data

local mailIndex, timeToWait, totalCash, inboxItems = 0, 0.15, 0, {}
local isGoldCollecting
local RecipientList = ""

local function GetNonLocalizedClass(className)
	for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_MALE) do
		if className == localizedName then
			return class
		end
	end

	-- For deDE and frFR
	if E.locale == "deDE" or E.locale == "frFR" then
		for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
			if className == localizedName then
				return class
			end
		end
	end
end

local function SetButtonTexture(button, texture, r, g, b)
	local normalTex = button:CreateTexture(nil, "ARTWORK")
	normalTex:Point("CENTER")
	normalTex:Size(button:GetSize())
	normalTex:SetTexture(texture)
	normalTex:SetVertexColor(1, 1, 1, 1)
	button.normalTex = normalTex

	local hoverTex = button:CreateTexture(nil, "ARTWORK")
	hoverTex:Point("CENTER")
	hoverTex:Size(button:GetSize())
	hoverTex:SetTexture(texture)
	if not r or not g or not b then
		r, g, b = unpack(E.media.rgbvaluecolor)
	end
	hoverTex:SetVertexColor(r, g, b, 1)
	hoverTex:SetAlpha(0)
	button.hoverTex = hoverTex

	button:SetScript("OnEnter", function()
		E:UIFrameFadeIn(button.hoverTex, (1 - button.hoverTex:GetAlpha()) * 0.382, button.hoverTex:GetAlpha(), 1)
	end)

	button:SetScript("OnLeave", function()
		E:UIFrameFadeOut(button.hoverTex, button.hoverTex:GetAlpha() * 0.382, button.hoverTex:GetAlpha(), 0)
	end)
end

local function SetButtonTooltip(button, text)
	button:HookScript("OnEnter", function()
		GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
		GameTooltip:ClearLines()
		GameTooltip:SetText(text)
	end)

	button:HookScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

function module:ShowContextText(button)
	if not button.name then
		return
	end

	local menu = {
		{
			text = button.name,
			isTitle = true,
			notCheckable = true
		}
	}

	if not button.class then
		tinsert(
			menu,
			{
				text = L["Remove From Favorites"],
				func = function()
					if button.realm then
						E.global.mui.mail.contacts.favorites[button.name .. "-" .. button.realm] = nil
						self:ChangeCategory("FAVORITE")
					end
				end,
				notCheckable = true
			}
		)
	else
		if button.dType and button.dType == "alt" then
			tinsert(
				menu,
				{
					text = L["Remove This Alt"],
					func = function()
						E.global.mui.mail.contacts.alts[button.realm][button.faction][button.name] = nil
						self:BuildAltsData()
						self:UpdatePage(currentPageIndex)
					end,
					notCheckable = true
				}
			)
		end

		tinsert(
			menu,
			{
				text = L["Add To Favorites"],
				func = function()
					if button.realm then
						E.global.mui.mail.contacts.favorites[button.name .. "-" .. button.realm] = true
					end
				end,
				notCheckable = true
			}
		)
	end

	EasyMenu(menu, self.contextMenuFrame, "cursor", 0, 0, "MENU")
end

function module:ConstructFrame()
	if self.frame then
		return
	end

	local frame = CreateFrame("Frame", "MER_Mail", _G.SendMailFrame, 'BackdropTemplate')
	frame:Point("TOPLEFT", _G.MailFrame, "TOPRIGHT", 2, -1)
	frame:Point("BOTTOMRIGHT", _G.MailFrame, "BOTTOMRIGHT", 152, 1)
	frame:CreateBackdrop("Transparent")
	frame.backdrop:Styling()
	S:CreateBackdropShadow(frame)
	frame:EnableMouse(true)

	self.frame = frame

	self.contextMenuFrame = CreateFrame("Frame", "MER_ContactsContextMenu", E.UIParent, "UIDropDownMenuTemplate")
end

function module:ConstructButtons()
	-- Toggle frame
	local toggleButton = CreateFrame("Button", "MER_MailToggleButton", _G.SendMailFrame, "SecureActionButtonTemplate")
	toggleButton:Size(24)
	SetButtonTexture(toggleButton, MER.Media.Icons.list)
	SetButtonTooltip(toggleButton, L["Toggle Contacts"])
	toggleButton:Point("BOTTOMRIGHT", _G.MailFrame, "BOTTOMRIGHT", -24, 38)
	toggleButton:RegisterForClicks("AnyUp")

	toggleButton:SetScript("OnClick", function()
		if self.frame:IsShown() then
			self.db.forceHide = true
			self.frame:Hide()
		else
			self.db.forceHide = nil
			self.frame:Show()
		end
	end)

	-- Alternate Character
	local altsButton = CreateFrame("Button", "MER_MailAltsButton", self.frame, "SecureActionButtonTemplate")
	altsButton:Size(25)
	SetButtonTexture(altsButton, MER.Media.Icons.barCharacter, 0.945, 0.769, 0.059)
	SetButtonTooltip(altsButton, L["Alternate Character"])
	altsButton:Point("TOPLEFT", self.frame, "TOPLEFT", 10, -10)
	altsButton:RegisterForClicks("AnyUp")

	altsButton:SetScript("OnClick", function()
		self:ChangeCategory("ALTS")
	end)

	-- Online Friends
	local friendsButton = CreateFrame("Button", "MER_MailFriendsButton", self.frame, "SecureActionButtonTemplate")
	friendsButton:Size(25)
	SetButtonTexture(friendsButton, MER.Media.Icons.barFriends, 0.345, 0.667, 0.867)
	SetButtonTooltip(friendsButton, L["Online Friends"])
	friendsButton:Point("LEFT", altsButton, "RIGHT", 10, 0)
	friendsButton:RegisterForClicks("AnyUp")

	friendsButton:SetScript("OnClick", function()
		self:ChangeCategory("FRIENDS")
	end)

	-- Guild Members
	local guildButton = CreateFrame("Button", "MER_MailGuildButton", self.frame, "SecureActionButtonTemplate")
	guildButton:Size(25)
	SetButtonTexture(guildButton, MER.Media.Icons.barGuild, 0.180, 0.800, 0.443)
	SetButtonTooltip(guildButton, _G.GUILD)
	guildButton:Point("LEFT", friendsButton, "RIGHT", 10, 0)
	guildButton:RegisterForClicks("AnyUp")

	guildButton:SetScript("OnClick", function()
		self:ChangeCategory("GUILD")
	end)

	-- Favorites
	local favoriteButton = CreateFrame("Button", "MER_MailFavoriteButton", self.frame, "SecureActionButtonTemplate")
	favoriteButton:Size(25)
	SetButtonTexture(favoriteButton, MER.Media.Icons.favorite, 0.769, 0.118, 0.227)
	SetButtonTooltip(favoriteButton, L["Favorites"])
	favoriteButton:Point("LEFT", guildButton, "RIGHT", 10, 0)
	favoriteButton:RegisterForClicks("AnyUp")

	favoriteButton:SetScript("OnClick", function()
		self:ChangeCategory("FAVORITE")
	end)

	self.toggleButton = toggleButton
	self.altsButton = altsButton
	self.friendsButton = friendsButton
	self.guildButton = guildButton
	self.favoriteButton = favoriteButton
end

function module:ConstructNameButtons()
	self.frame.nameButtons = {}

	for i = 1, 14 do
		local button = CreateFrame("Button", "MER_MailNameButton" .. i, self.frame, "UIPanelButtonTemplate")
		button:Size(140, 20)

		if i == 1 then
			button:Point("TOP", self.frame, "TOP", 0, -45)
		else
			button:Point("TOP", self.frame.nameButtons[i - 1], "BOTTOM", 0, -4)
		end

		button:SetText("")
		button:RegisterForClicks("LeftButtonDown", "RightButtonDown")
		ES:HandleButton(button)

		button:SetScript("OnClick", function(self, mouseButton)
			if mouseButton == "LeftButton" then
				if _G.SendMailNameEditBox then
					local playerName = self.name
					if playerName then
						if self.realm and self.realm ~= E.myrealm then
							playerName = playerName .. "-" .. self.realm
						end
						_G.SendMailNameEditBox:SetText(playerName)
					end
				end
			elseif mouseButton == "RightButton" then
				module:ShowContextText(self)
			end
		end)

		button:SetScript("OnEnter", function(self)
			module:SetButtonTooltip(self)
		end)

		button:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)

		button:Hide()
		self.frame.nameButtons[i] = button
	end
end

function module:ConstructPageController()
	local pagePrevButton = CreateFrame("Button", "MER_MailPagePrevButton", self.frame, "SecureActionButtonTemplate")
	pagePrevButton:Size(14)
	SetButtonTexture(pagePrevButton, E.Media.Textures.ArrowUp)
	pagePrevButton.normalTex:SetRotation(ES.ArrowRotation.left)
	pagePrevButton.hoverTex:SetRotation(ES.ArrowRotation.left)
	pagePrevButton:Point("BOTTOMLEFT", self.frame, "BOTTOMLEFT", 8, 8)
	pagePrevButton:RegisterForClicks("AnyUp")

	pagePrevButton:SetScript("OnClick", function(_, mouseButton)
		if mouseButton == "LeftButton" then
			currentPageIndex = currentPageIndex - 1
			self:UpdatePage(currentPageIndex)
		end
	end)

	local pageNextButton = CreateFrame("Button", "MER_MailPageNextButton", self.frame, "SecureActionButtonTemplate")
	pageNextButton:Size(14)
	SetButtonTexture(pageNextButton, E.Media.Textures.ArrowUp)
	pageNextButton.normalTex:SetRotation(ES.ArrowRotation.right)
	pageNextButton.hoverTex:SetRotation(ES.ArrowRotation.right)
	pageNextButton:Point("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", -8, 8)
	pageNextButton:RegisterForClicks("AnyUp")

	pageNextButton:SetScript("OnClick", function(_, mouseButton)
		if mouseButton == "LeftButton" then
			currentPageIndex = currentPageIndex + 1
			self:UpdatePage(currentPageIndex)
		end
	end)

	local slider = CreateFrame("Slider", "MER_MailSlider", self.frame, "BackdropTemplate")
	slider:Size(80, 20)
	slider:Point("BOTTOM", self.frame, "BOTTOM", 0, 8)
	slider:SetOrientation("HORIZONTAL")
	slider:SetValueStep(1)
	slider:SetValue(1)
	slider:SetMinMaxValues(1, 10)

	slider:SetScript("OnValueChanged", function(_, newValue)
		if newValue then
			currentPageIndex = newValue
			self:UpdatePage(currentPageIndex)
		end
	end)

	ES:HandleSliderFrame(slider)

	local pageIndicater = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	pageIndicater:Point("BOTTOM", slider, "TOP", 0, 6)
	slider.pageIndicater = pageIndicater

	-- Mouse wheel control
	self.frame:EnableMouseWheel(true)
	self.frame:SetScript("OnMouseWheel", function(_, delta)
		if not currentPageIndex then
			return
		end

		if delta > 0 then
			if pagePrevButton:IsShown() then
				currentPageIndex = currentPageIndex - 1
				self:UpdatePage(currentPageIndex)
			end
		else
			if pageNextButton:IsShown() then
				currentPageIndex = currentPageIndex + 1
				self:UpdatePage(currentPageIndex)
			end
		end
	end)

	self.pagePrevButton = pagePrevButton
	self.pageNextButton = pageNextButton
	self.slider = slider
end

function module:SetButtonTooltip(button)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(button, "ANCHOR_BOTTOMRIGHT", 8, 20)
	GameTooltip:SetText(button.name or "")
	GameTooltip:AddDoubleLine(L["Name"], button.name or "", 1, 1, 1, GetClassColor(button.class))
	GameTooltip:AddDoubleLine(L["Realm"], button.realm or "", 1, 1, 1, unpack(E.media.rgbvaluecolor))

	if button.BNName then
		GameTooltip:AddDoubleLine(L["Battle.net Tag"], button.BNName, 1, 1, 1, 1, 1, 1)
	end

	if button.faction then
		local text, r, g, b
		if button.faction == "Horde" then
			text = _G.FACTION_HORDE
			r = 0.906
			g = 0.298
			b = 0.235
		else
			text = _G.FACTION_ALLIANCE
			r = 0.204
			g = 0.596
			b = 0.859
		end

		GameTooltip:AddDoubleLine(_G.FACTION, text or "", 1, 1, 1, r, g, b)
	end

	GameTooltip:Show()
end

function module:UpdatePage(pageIndex)
	local numData = data and #data or 0

	-- Name buttons
	if numData ~= 0 then
		for i = 1, 14 do
			local temp = data[(pageIndex - 1) * 14 + i]
			local button = self.frame.nameButtons[i]
			if temp then
				button.dType = temp.dType
				if temp.memberIndex then -- Only get guild member info if needed
					local fullname, _, _, _, _, _, _, _, _, _, className = GetGuildRosterInfo(temp.memberIndex)
					local name, realm = F.SplitString("-", fullname)
					realm = realm or E.myrealm
					button.name = name
					button.realm = realm
					button.class = className
					button.BNName = nil
					button.faction = E.myfaction
				else
					button.name = temp.name
					button.realm = temp.realm
					button.class = temp.class
					button.faction = temp.faction
					button.BNName = temp.BNName
				end
				button:SetText(button.class and F.CreateClassColorString(button.name, button.class) or button.name)
				button:Show()
			else
				button.dType = nil
				button:Hide()
			end
		end
	else
		for i = 1, 14 do
			self.frame.nameButtons[i]:Hide()
		end
	end

	-- Previous page button
	if pageIndex == 1 then
		self.pagePrevButton:Hide()
	else
		self.pagePrevButton:Show()
	end

	-- Next page button
	if pageIndex * 14 - numData >= 0 then
		self.pageNextButton:Hide()
	else
		self.pageNextButton:Show()
	end

	-- Slider
	self.slider:SetValue(pageIndex)
	self.slider:SetMinMaxValues(1, floor(numData / 14) + 1)
	self.slider.pageIndicater:SetText(format("%d / %d", pageIndex, floor(numData / 14) + 1))

	if numData <= 14 then
		self.slider:Hide()
	else
		self.slider:Show()
	end
end

function module:UpdateAltsTable()
	if not self.altsTable then
		self.altsTable = E.global.mui.mail.contacts.alts
	end

	if not self.altsTable[E.myrealm] then
		self.altsTable[E.myrealm] = {}
	end

	if not self.altsTable[E.myrealm][E.myfaction] then
		self.altsTable[E.myrealm][E.myfaction] = {}
	end

	if not self.altsTable[E.myrealm][E.myfaction][E.myname] then
		self.altsTable[E.myrealm][E.myfaction][E.myname] = E.myclass
	end
end

function module:BuildAltsData()
	data = {}

	for realm, factions in pairs(self.altsTable) do
		for faction, characters in pairs(factions) do
			for name, class in pairs(characters) do
				if not (name == E.myname and realm == E.myrealm) then
					tinsert(data, { name = name, realm = realm, class = class, faction = faction, dType = "alt" })
				end
			end
		end
	end
end

function module:BuildFriendsData()
	data = {}

	local tempKey = {}
	local numWoWFriend = C_FriendList_GetNumOnlineFriends()
	for i = 1, numWoWFriend do
		local info = C_FriendList_GetFriendInfoByIndex(i)
		if info.connected then
			local name, realm = F.SplitString("-", info.name)
			realm = realm or E.myrealm
			tinsert(data, { name = name, realm = realm, class = GetNonLocalizedClass(info.className), dType = "friend" })
			tempKey[name .. "-" .. realm] = true
		end
	end

	local numBNOnlineFriend = select(2, BNGetNumFriends())

	for i = 1, numBNOnlineFriend do
		local accountInfo = C_BattleNet_GetFriendAccountInfo(i)
		if accountInfo and accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.isOnline then
			local numGameAccounts = C_BattleNet_GetFriendNumGameAccounts(i)
			if numGameAccounts and numGameAccounts > 0 then
				for j = 1, numGameAccounts do
					local gameAccountInfo = C_BattleNet_GetFriendGameAccountInfo(i, j)
					if
						gameAccountInfo.clientProgram and gameAccountInfo.clientProgram == "WoW" and
							gameAccountInfo.wowProjectID == 1 and
							gameAccountInfo.factionName and
							gameAccountInfo.factionName == E.myfaction and
							not tempKey[gameAccountInfo.characterName .. "-" .. gameAccountInfo.realmName]
					 then
						tinsert(data,
							{ name = gameAccountInfo.characterName, realm = gameAccountInfo.realmName,
								class = GetNonLocalizedClass(gameAccountInfo.className), BNName = accountInfo.accountName, dType = "bnfriend" })
					end
				end
			elseif
				accountInfo.gameAccountInfo.clientProgram == "WoW" and accountInfo.gameAccountInfo.wowProjectID == 1 and
					accountInfo.gameAccountInfo.factionName and
					accountInfo.gameAccountInfo.factionName == E.myfaction and
					not tempKey[accountInfo.gameAccountInfo.characterName .. "-" .. accountInfo.gameAccountInfo.realmName]
			 then
				tinsert(data,
					{ name = accountInfo.gameAccountInfo.characterName, realm = accountInfo.gameAccountInfo.realmName,
						class = GetNonLocalizedClass(accountInfo.gameAccountInfo.className), BNName = accountInfo.accountName,
						dType = "bnfriend" })
			end
		end
	end
end

function module:BuildGuildData()
	data = {}

	if not IsInGuild() then
		return
	end

	local totalMembers = GetNumGuildMembers()
	for i = 1, totalMembers do
		tinsert(
			data,
			{
				memberIndex = i,
				dType = "guild"
			}
		)
	end
end

function module:BuildFavoriteData()
	data = {}

	for fullName in pairs(E.global.mui.mail.contacts.favorites) do
		local name, realm = F.SplitString("-", fullName)
		realm = realm or E.myrealm
		tinsert(data, { name = name, realm = realm, dType = "favorite" })
	end
end

function module:ChangeCategory(type)
	type = type or self.db.defaultPage

	if type == "ALTS" then
		self:BuildAltsData()
	elseif type == "FRIENDS" then
		self:BuildFriendsData()
	elseif type == "GUILD" then
		self:BuildGuildData()
	elseif type == "FAVORITE" then
		self:BuildFavoriteData()
	else
		self:ChangeCategory(self.db.defaultPage)
		return
	end

	currentPageIndex = 1
	self:UpdatePage(1)
end

function module:SendMailFrame_OnShow()
	if self.db.forceHide then
		self.frame:Hide()
	else
		self.frame:Show()
	end
end

function module:MailBox_DelectClick()
	local selectedID = self.id + (_G.InboxFrame.pageNum - 1) * 7
	if InboxItemCanDelete(selectedID) then
		DeleteInboxItem(selectedID)
	else
		_G.UIErrorsFrame:AddMessage(MER.RedColor .. _G.ERR_MAIL_DELETE_ITEM_ERROR)
	end
end

function module:MailItem_AddDelete(i)
	local bu = CreateFrame('Button', nil, self)
	bu:SetPoint('BOTTOMRIGHT', self:GetParent(), 'BOTTOMRIGHT', -10, 5)
	bu:SetSize(16, 16)
	--F.PixelIcon(bu, 136813, true)
	local icon = bu:CreateTexture(nil, 'ARTWORK')
	icon:SetInside()

	icon:SetTexture('Interface\\RAIDFRAME\\ReadyCheck-NotReady')

	bu.id = i
	bu:SetScript('OnClick', module.MailBox_DelectClick)
	F.AddTooltip(bu, 'ANCHOR_RIGHT', _G.DELETE, 'BLUE')
end

function module:InboxItem_OnEnter()
	if not self.index then
		return
	end
	wipe(inboxItems)

	local itemAttached = select(8, GetInboxHeaderInfo(self.index))
	if itemAttached then
		for attachID = 1, 12 do
			local _, itemID, _, itemCount = GetInboxItem(self.index, attachID)
			if itemCount and itemCount > 0 then
				inboxItems[itemID] = (inboxItems[itemID] or 0) + itemCount
			end
		end

		if itemAttached > 1 then
			_G.GameTooltip:AddLine(L["Attach List"])
			for itemID, count in pairs(inboxItems) do
				local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture = GetItemInfo(itemID)
				if itemName then
					local r, g, b = GetItemQualityColor(itemQuality)
					_G.GameTooltip:AddDoubleLine(
						' |T' .. itemTexture .. ':12:12:0:0:50:50:4:46:4:46|t ' .. itemName,
						count,
						r,
						g,
						b
					)
				end
			end
			_G.GameTooltip:Show()
		end
	end
end

function module:MailBox_CollectGold()
	if mailIndex > 0 then
		if not C_Mail_IsCommandPending() then
			if C_Mail_HasInboxMoney(mailIndex) then
				TakeInboxMoney(mailIndex)
			end
			mailIndex = mailIndex - 1
		end
		E:Delay(timeToWait, module.MailBox_CollectGold)
	else
		isGoldCollecting = false
		module:UpdateOpeningText()
	end
end

function module:MailBox_CollectAllGold()
	if isGoldCollecting then
		return
	end
	if totalCash == 0 then
		return
	end

	isGoldCollecting = true
	mailIndex = GetInboxNumItems()

	module:UpdateOpeningText(true)
	module:MailBox_CollectGold()
end

function module:TotalCash_OnEnter()
	local numItems = GetInboxNumItems()
	if numItems == 0 then
		return
	end

	for i = 1, numItems do
		totalCash = totalCash + select(5, GetInboxHeaderInfo(i))
	end

	if totalCash > 0 then
		_G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		_G.GameTooltip:AddLine(E:FormatMoney(totalCash))
		_G.GameTooltip:Show()
	end
end

function module:TotalCash_OnLeave()
	F:HideTooltip()
	totalCash = 0
end

function module:UpdateOpeningText(opening)
	if opening then
		module.GoldButton:SetText(_G.OPEN_ALL_MAIL_BUTTON_OPENING)
	else
		module.GoldButton:SetText(_G.GUILDCONTROL_OPTION16)
	end
end

function module:MailBox_CreateButton(parent, width, height, text, anchor)
	local button = CreateFrame('Button', nil, parent, 'UIPanelButtonTemplate')
	button:SetSize(width, height)
	button:SetPoint(unpack(anchor))
	button:SetText(text)
	ES:HandleButton(button)

	return button
end

function module:CollectGoldButton()
	_G.OpenAllMail:ClearAllPoints()
	_G.OpenAllMail:SetPoint('BOTTOMRIGHT', _G.MailFrame, 'BOTTOM', -2, 16)
	_G.OpenAllMail:SetSize(80, 20)

	local button = module:MailBox_CreateButton(_G.InboxFrame, 80, 20, '', {'BOTTOMLEFT', _G.MailFrame, 'BOTTOM', 2, 16})
	button:SetScript('OnClick', module.MailBox_CollectAllGold)
	button:HookScript('OnEnter', module.TotalCash_OnEnter)
	button:HookScript('OnLeave', module.TotalCash_OnLeave)

	module.GoldButton = button
	module:UpdateOpeningText()
end

function module:MailBox_CollectAttachment()
	for i = 1, _G.ATTACHMENTS_MAX_RECEIVE do
		local attachmentButton = _G.OpenMailFrame.OpenMailAttachments[i]
		if attachmentButton:IsShown() then
			TakeInboxItem(_G.InboxFrame.openMailID, i)
			E:Delay(timeToWait, module.MailBox_CollectAttachment)
			return
		end
	end
end

function module:MailBox_CollectCurrent()
	if _G.OpenMailFrame.cod then
		_G.UIErrorsFrame:AddMessage(MER.RedColor .. L["You can't auto collect CoD mail"])
		return
	end

	local currentID = _G.InboxFrame.openMailID
	if C_Mail_HasInboxMoney(currentID) then
		TakeInboxMoney(currentID)
	end
	module:MailBox_CollectAttachment()
end

function module:CollectCurrentButton()
	local button = module:MailBox_CreateButton(_G.OpenMailFrame, 70, 20, L["Take All"], { 'RIGHT', 'OpenMailReplyButton', 'LEFT', -6, 0 })
	button:SetScript('OnClick', module.MailBox_CollectCurrent)

	_G.OpenMailCancelButton:SetSize(70, 20)
	_G.OpenMailCancelButton:ClearAllPoints()
	_G.OpenMailCancelButton:SetPoint('BOTTOMRIGHT', _G.OpenMailFrame, 'BOTTOMRIGHT', -8, 8)
	_G.OpenMailDeleteButton:SetSize(70, 20)
	_G.OpenMailDeleteButton:ClearAllPoints()
	_G.OpenMailDeleteButton:SetPoint('RIGHT', _G.OpenMailCancelButton, 'LEFT', -6, 0)
	_G.OpenMailReplyButton:SetSize(70, 20)
	_G.OpenMailReplyButton:ClearAllPoints()
	_G.OpenMailReplyButton:SetPoint('RIGHT', _G.OpenMailDeleteButton, 'LEFT', -6, 0)
end

function module:ArrangeDefaultElements()
	_G.InboxTooMuchMail:ClearAllPoints()
	_G.InboxTooMuchMail:SetPoint('BOTTOM', _G.MailFrame, 'TOP', 0, 5)

	_G.SendMailNameEditBox:SetWidth(155)
	_G.SendMailNameEditBoxMiddle:SetWidth(146)
	_G.SendMailCostMoneyFrame:SetAlpha(0)

	_G.SendMailMailButton:HookScript('OnEnter', function(self)
		_G.GameTooltip:SetOwner(self, 'ANCHOR_TOP')
		_G.GameTooltip:ClearLines()
		local sendPrice = GetSendMailPrice()
		local colorStr = '|cffffffff'
		if sendPrice > GetMoney() then
			colorStr = '|cffff0000'
		end
		_G.GameTooltip:AddLine(_G.SEND_MAIL_COST..colorStr..E:FormatMoney(sendPrice))
		_G.GameTooltip:Show()
	end)
	_G.SendMailMailButton:HookScript('OnLeave', F.HideTooltip)
end

function module:LastMailSaver()
	local mailSaver = CreateFrame('CheckButton', nil, _G.SendMailFrame, 'OptionsBaseCheckButtonTemplate')
	mailSaver:SetHitRectInsets(0, 0, 0, 0)
	mailSaver:SetPoint('LEFT', _G.SendMailNameEditBox, 'RIGHT', 0, 0)
	mailSaver:SetSize(24, 24)
	ES:HandleCheckBox(mailSaver)

	mailSaver:SetChecked(E.db.mui.mail.saveRecipient)
	mailSaver:SetScript('OnClick', function(self)
		E.db.mui.mail.saveRecipient = self:GetChecked()
	end)
	F.AddTooltip(mailSaver, 'ANCHOR_TOP', L["Save mail recipient"])

	local resetPending
	hooksecurefunc('SendMailFrame_SendMail', function()
		if E.db.mui.mail.saveRecipient then
			RecipientList = _G.SendMailNameEditBox:GetText()
			resetPending = true
		else
			resetPending = nil
		end
	end)

	hooksecurefunc(_G.SendMailNameEditBox, 'SetText', function(self, text)
		if resetPending and text == '' then
			resetPending = nil
			self:SetText(RecipientList)
		end
	end)

	_G.SendMailFrame:HookScript('OnShow', function()
		if E.db.mui.mail.saveRecipient then
			_G.SendMailNameEditBox:SetText(RecipientList)
		end
	end)
end

function module:Initialize()
	self:UpdateAltsTable()
	self.db = E.db.mui.mail

	if not self.db.enable or self.Initialized or IsAddOnLoaded('Postal') then
		return
	end

	self:ConstructFrame()
	self:ConstructButtons()
	self:ConstructNameButtons()
	self:ConstructPageController()

	-- Delete buttons
	for i = 1, 7 do
		local itemButton = _G['MailItem' .. i .. 'Button']
		module.MailItem_AddDelete(itemButton, i)
	end

	hooksecurefunc('InboxFrameItem_OnEnter', module.InboxItem_OnEnter)

	self:ArrangeDefaultElements()
	self:CollectGoldButton()
	self:CollectCurrentButton()
	self:LastMailSaver()

	self:SecureHookScript(_G.SendMailFrame, "OnShow", "SendMailFrame_OnShow")

	self:ChangeCategory()
	self.Initialized = true
end

function module:ProfileUpdate()
	self.db = E.db.mui.mail

	if self.db.enable then
		self:Initialize()
		self.frame:Show()
		self.toggleButton:Show()
	else
		if self.Initialized then
			self.frame:Hide()
			self.toggleButton:Hide()
		end
	end
end

MER:RegisterModule(module:GetName())

-- Temp fix for GM mails
function OpenAllMail:AdvanceToNextItem()
	local foundAttachment = false
	while ( not foundAttachment ) do
		local _, _, _, _, _, CODAmount, _, _, _, _, _, _, isGM = GetInboxHeaderInfo(self.mailIndex)
		local itemID = select(2, GetInboxItem(self.mailIndex, self.attachmentIndex))
		local hasBlacklistedItem = self:IsItemBlacklisted(itemID)
		local hasCOD = CODAmount and CODAmount > 0
		local hasMoneyOrItem = C_Mail.HasInboxMoney(self.mailIndex) or HasInboxItem(self.mailIndex, self.attachmentIndex)
		if ( not hasBlacklistedItem and not isGM and not hasCOD and hasMoneyOrItem ) then
			foundAttachment = true
		else
			self.attachmentIndex = self.attachmentIndex - 1
			if ( self.attachmentIndex == 0 ) then
				break
			end
		end
	end

	if ( not foundAttachment ) then
		self.mailIndex = self.mailIndex + 1
		self.attachmentIndex = ATTACHMENTS_MAX
		if ( self.mailIndex > GetInboxNumItems() ) then
			return false
		end

		return self:AdvanceToNextItem()
	end

	return true
end
