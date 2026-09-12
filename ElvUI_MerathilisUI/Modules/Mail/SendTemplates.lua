local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Mail") ---@class MER_Mail
local MS = MER:GetModule("MER_Skins")

local _G = _G
local pairs = pairs
local ipairs = ipairs
local next = next
local format = format
local strtrim = strtrim
local strsplit = strsplit
local tinsert = tinsert

local CreateFrame = CreateFrame
local GetSendMailMoney = GetSendMailMoney
local SetSendMailMoney = SetSendMailMoney
local GetSendMailItem = GetSendMailItem
local SendMailFrame_SendMail = SendMailFrame_SendMail
local UIDropDownMenu_Initialize = UIDropDownMenu_Initialize
local UIDropDownMenu_AddButton = UIDropDownMenu_AddButton
local UIDropDownMenu_CreateInfo = UIDropDownMenu_CreateInfo
local ToggleDropDownMenu = ToggleDropDownMenu
local GameTooltip = GameTooltip
local C_Timer_After = C_Timer.After

local ATTACHMENTS_MAX_SEND = ATTACHMENTS_MAX_SEND or 12

local sendState

function module.ParseRecipients(text)
	local recipients = {}
	if not text or text == "" then
		return recipients
	end

	for _, piece in ipairs({ strsplit("\n,", text) }) do
		local name = strtrim(piece)
		if name ~= "" then
			tinsert(recipients, name)
		end
	end

	return recipients
end

function module:CreateSendTemplatesUI()
	if self.sendTemplatesButton then
		return
	end

	-- A small icon button at the bottom-left edge, before the gold display -
	-- the gap next to Send/Cancel was too tight and overlapped the copper amount.
	-- The template list only opens as a click-to-show context menu, so it
	-- takes zero permanent space until used.
	local btn = MS.CreateButton(SendMailFrame, 20, 20, true, "Interface\\Icons\\INV_Letter_15")
	btn:SetPoint("RIGHT", _G.SendMailMoneyFrame, "LEFT", -6, 0)
	btn:SetScript("OnClick", function(self)
		ToggleDropDownMenu(1, nil, module.templateMenu, self, 0, 0)
	end)
	btn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["Send Templates"])
		GameTooltip:Show()
	end)
	btn:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	self.sendTemplatesButton = btn

	local continueButton =
		MS.CreateButton(SendMailFrame, 20, 20, true, "Interface\\RaidFrame\\ReadyCheck-Ready")
	continueButton:SetPoint("RIGHT", _G.SendMailMoneyFrame, "LEFT", -6, 0)
	continueButton:Hide()
	continueButton:SetScript("OnClick", function()
		continueButton:Hide()
		btn:Show()
		module:SendNext()
	end)
	continueButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["Continue"])
		GameTooltip:Show()
	end)
	continueButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	self.sendContinueButton = continueButton

	local menu = CreateFrame("Frame", "MER_SendMailTemplateMenu", SendMailFrame, "UIDropDownMenuTemplate")
	menu:Hide()
	UIDropDownMenu_Initialize(menu, function()
		local hasTemplates = next(E.global.mui.mail.templates) ~= nil
		if not hasTemplates then
			local info = UIDropDownMenu_CreateInfo()
			info.text = L["No templates saved."]
			info.isTitle = true
			info.notCheckable = true
			UIDropDownMenu_AddButton(info)
			return
		end

		for name in pairs(E.global.mui.mail.templates) do
			local info = UIDropDownMenu_CreateInfo()
			info.text = name
			info.notCheckable = true
			info.func = function()
				module:SendToAll(name)
			end
			UIDropDownMenu_AddButton(info)
		end
	end, "MENU")
	self.templateMenu = menu
end

function module:ShowSendTemplatesUI()
	if self.sendTemplatesButton then
		self.sendTemplatesButton:Show()
	end
	if self.sendContinueButton then
		self.sendContinueButton:Hide()
	end
end

function module:HideSendTemplatesUI()
	if self.sendTemplatesButton then
		self.sendTemplatesButton:Hide()
	end
	if self.sendContinueButton then
		self.sendContinueButton:Hide()
	end

	sendState = nil
end

function module:SendToAll(templateName)
	if sendState then
		return
	end

	local tpl = E.global.mui.mail.templates[templateName]
	if not tpl or not tpl.recipients or #tpl.recipients == 0 then
		F.Print(L["This template has no recipients."])
		return
	end

	local money = GetSendMailMoney()
	local hasItem = false
	for i = 1, ATTACHMENTS_MAX_SEND do
		if GetSendMailItem(i) then
			hasItem = true
			break
		end
	end

	sendState = {
		recipients = tpl.recipients,
		subject = tpl.subject,
		body = tpl.body,
		money = money,
		hasItem = hasItem,
		index = 0,
	}

	module:SendNext()
end

function module:SendNext()
	if not sendState then
		return
	end

	sendState.index = sendState.index + 1
	local recipient = sendState.recipients[sendState.index]
	if not recipient then
		module:FinishSendAll()
		return
	end

	SendMailNameEditBox:SetText(recipient)
	SendMailSubjectEditBox:SetText(sendState.subject or "")
	SendMailBodyEditBox:SetText(sendState.body or "")

	F.Print(format(L["Sending %d/%d to %s..."], sendState.index, #sendState.recipients, recipient))

	SendMailFrame_SendMail()
end

function module:OnSendMailReset()
	if not sendState then
		return
	end

	if sendState.money and sendState.money > 0 then
		SetSendMailMoney(sendState.money)
	end

	if sendState.hasItem and sendState.index < #sendState.recipients then
		module:PromptItemReattach()
		return
	end

	if sendState.index >= #sendState.recipients then
		module:FinishSendAll()
		return
	end

	C_Timer_After(0.3, function()
		if sendState then
			module:SendNext()
		end
	end)
end

function module:PromptItemReattach()
	F.Print(L["Item cleared - re-drag it into the attachment slot, then click Continue."])
	if self.sendTemplatesButton then
		self.sendTemplatesButton:Hide()
	end
	if self.sendContinueButton then
		self.sendContinueButton:Show()
	end
end

function module:FinishSendAll()
	F.Print(L["Mass send complete."])
	if self.sendContinueButton then
		self.sendContinueButton:Hide()
	end
	if self.sendTemplatesButton then
		self.sendTemplatesButton:Show()
	end

	sendState = nil
end

function module:OnMailFailed()
	if not sendState then
		return
	end

	local recipient = sendState.recipients[sendState.index]
	F.Print(format(L["Send failed for %s."], recipient or "?"))
	if self.sendContinueButton then
		self.sendContinueButton:Hide()
	end
	if self.sendTemplatesButton then
		self.sendTemplatesButton:Show()
	end

	sendState = nil
end
