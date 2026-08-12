local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Mail") ---@class MER_Mail

local _G = _G

local CreateFrame = CreateFrame
local DeleteInboxItem = DeleteInboxItem
local GetInboxHeaderInfo = GetInboxHeaderInfo
local GetInboxItem = GetInboxItem
local GetInboxNumItems = GetInboxNumItems
local InboxItemCanDelete = InboxItemCanDelete
local ReturnInboxItem = ReturnInboxItem
local StaticPopup_Show = StaticPopup_Show
local StaticPopup_Hide = StaticPopup_Hide
local MoneyFrame_Update = MoneyFrame_Update
local GameTooltip = GameTooltip

local ATTACHMENTS_MAX_RECEIVE = ATTACHMENTS_MAX_RECEIVE

local selectedID
local selectedIDmoney

StaticPopupDialogs["MER_DELETE_MAIL"] = {
	text = DELETE_MAIL_CONFIRMATION,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function()
		DeleteInboxItem(selectedID)
		selectedID = nil
	end,
	showAlert = 1,
	timeout = 0,
	hideOnEscape = 1,
}

StaticPopupDialogs["MER_DELETE_MONEY"] = {
	text = DELETE_MONEY_CONFIRMATION,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function()
		DeleteInboxItem(selectedID)
		selectedID = nil
	end,
	OnShow = function(self)
		MoneyFrame_Update(self.moneyFrame, selectedIDmoney)
	end,
	hasMoneyFrame = 1,
	showAlert = 1,
	timeout = 0,
	hideOnEscape = 1,
}

function module:OnClick()
	selectedID = self.id + (InboxFrame.pageNum - 1) * 7

	local _, _, _, _, money = GetInboxHeaderInfo(selectedID)
	selectedIDmoney = money

	local firstAttachName
	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		firstAttachName = GetInboxItem(selectedID, i)
		if firstAttachName then
			break
		end
	end

	if InboxItemCanDelete(selectedID) then
		if firstAttachName then
			StaticPopup_Show("MER_DELETE_MAIL", firstAttachName)
			return
		elseif money and money > 0 then
			StaticPopup_Show("MER_DELETE_MONEY")
			return
		else
			DeleteInboxItem(selectedID)
		end
	else
		ReturnInboxItem(selectedID)
		StaticPopup_Hide("COD_CONFIRMATION")
	end

	selectedID = nil
end

function module:UpdateMailIcons()
	for i = 1, 7 do
		local index = i + (InboxFrame.pageNum - 1) * 7
		local expire = _G["MailItem" .. i .. "ExpireTime"]
		local b = expire and expire.returnicon

		if not b then
			return
		end

		if index > GetInboxNumItems() then
			b:Hide()
		else
			local canDelete = InboxItemCanDelete(index)
			b.texture:SetTexture(
				canDelete and "Interface\\RaidFrame\\ReadyCheck-NotReady"
					or "Interface\\ChatFrame\\ChatFrameExpandArrow"
			)
			b.tooltip = canDelete and DELETE or MAIL_RETURN
			b:Show()
		end
	end
end

function module:OnEnable()
	for i = 1, 7 do
		local expire = _G["MailItem" .. i .. "ExpireTime"]
		if expire and not expire.returnicon then
			local b = CreateFrame("Button", nil, expire)
			b:SetPoint("TOPRIGHT", expire, "BOTTOMRIGHT", -5, -1)
			b:SetSize(16, 16)

			b.texture = b:CreateTexture(nil, "BACKGROUND")
			b.texture:SetAllPoints()
			b.texture:SetTexCoord(1, 0, 0, 1)

			b.id = i
			b:SetScript("OnClick", module.OnClick)

			b:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(self.tooltip or "")
				GameTooltip:Show()
			end)

			b:SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)

			expire.returnicon = b
		end

		if expire and expire.returnicon then
			expire.returnicon:Show()
		end
	end

	self:SecureHook("InboxFrame_Update", "UpdateMailIcons")
end

function module:OnDisable()
	if self:IsHooked("InboxFrame_Update") then
		self:Unhook("InboxFrame_Update")
	end

	for i = 1, 7 do
		local expire = _G["MailItem" .. i .. "ExpireTime"]
		if expire and expire.returnicon then
			expire.returnicon:Hide()
		end
	end
end

function module:Initialize()
	local db = E.db.mui.mail
	if db and db.enable then
		self:Enable()
	else
		self:Disable()
	end
end

MER:RegisterModule(module:GetName())
