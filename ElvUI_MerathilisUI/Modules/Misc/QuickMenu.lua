local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")
local S = MER:GetModule("MER_Skins")

local _G = _G
local unpack = unpack

local ChatEdit_ActivateChat = ChatEdit_ActivateChat
local ChatEdit_ChooseBoxForSend = ChatEdit_ChooseBoxForSend
local ChatFrame_SendTell = ChatFrame_SendTell
local GuildInvite = C_GuildInfo.Invite
local AddFriend = C_FriendList.AddFriend
local UnitIsPlayer = UnitIsPlayer
local hooksecurefunc = hooksecurefunc

function module:MenuButton_AddFriend()
	AddFriend(module.MenuButtonName)
end

function module:MenuButton_CopyName()
	local editBox = ChatEdit_ChooseBoxForSend()
	local hasText = (editBox:GetText() ~= "")
	ChatEdit_ActivateChat(editBox)
	editBox:Insert(module.MenuButtonName)
	if not hasText then
		editBox:HighlightText()
	end
end

function module:MenuButton_GuildInvite()
	GuildInvite(module.MenuButtonName)
end

function module:MenuButton_Whisper()
	ChatFrame_SendTell(module.MenuButtonName)
end

function module:QuickMenu()
	if not E.db.mui.misc.quickMenu then
		return
	end

	local menuList = {
		{
			text = _G.ADD_FRIEND,
			func = module.MenuButton_AddFriend,
			color = { 0, 0.6, 1 },
		},
		{
			text = gsub(_G.CHAT_GUILD_INVITE_SEND, HEADER_COLON, ""),
			func = module.MenuButton_GuildInvite,
			color = { 0, 0.8, 0 },
		},
		{
			text = _G.COPY_NAME,
			func = module.MenuButton_CopyName,
			color = { 1, 0, 0 },
		},
		{
			text = _G.WHISPER,
			func = module.MenuButton_Whisper,
			color = { 1, 0.5, 1 },
		},
	}

	local frame = CreateFrame("Frame", "MER_MenuButtonFrame", _G.DropDownList1)
	frame:SetSize(10, 10)
	frame:SetPoint("TOPLEFT")
	frame:Hide()

	for i = 1, 4 do
		local button = CreateFrame("Button", nil, frame)
		button:SetSize(25, 10)
		button:SetPoint("TOPLEFT", frame, (i - 1) * 28 + 2, -2)
		S:PixelIcon(button, nil, true)
		button.Icon:SetColorTexture(unpack(menuList[i].color))
		button:SetScript("OnClick", menuList[i].func)
		F.AddTooltip(button, "ANCHOR_TOP", menuList[i].text)
	end

	hooksecurefunc("ToggleDropDownMenu", function(level, _, dropdownMenu)
		if level and level > 1 then
			return
		end

		local name = dropdownMenu.name
		local unit = dropdownMenu.unit
		local isPlayer = unit and UnitIsPlayer(unit)
		local isFriendMenu = dropdownMenu == _G.FriendsDropDown -- menus on FriendsFrame
		if not name or (not isPlayer and not dropdownMenu.chatType and not isFriendMenu) then
			frame:Hide()
			return
		end

		local gameAccountInfo = dropdownMenu.accountInfo and dropdownMenu.accountInfo.gameAccountInfo
		if gameAccountInfo and gameAccountInfo.characterName and gameAccountInfo.realmName then
			module.MenuButtonName = gameAccountInfo.characterName .. "-" .. gameAccountInfo.realmName
			frame:Show()
		else
			local server = dropdownMenu.server
			if not server or server == "" then
				server = E.myrealm
			end
			module.MenuButtonName = name .. "-" .. server
			frame:Show()
		end
	end)
end

module:AddCallback("QuickMenu")
