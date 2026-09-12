local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Mail") ---@class MER_Mail
local MS = MER:GetModule("MER_Skins")

local _G = _G
local wipe = wipe
local pairs = pairs
local tsort = table.sort

local CreateFrame = CreateFrame
local AutoLootMailItem = AutoLootMailItem
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
local C_Timer_After = C_Timer.After

local ATTACHMENTS_MAX_RECEIVE = ATTACHMENTS_MAX_RECEIVE

local selectedID
local selectedIDmoney

local selectedIndices = {}
local queueState = {
	active = false,
	queue = nil,
	pos = 0,
	waiting = false,
	actionFn = nil,
}

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

StaticPopupDialogs["MER_DELETE_MAIL_SELECTED"] = {
	text = L["Delete %d selected mails?"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function()
		module:DeleteSelectedConfirmed()
	end,
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

	module:RefreshSelectionCheckboxes()

	if queueState.active and queueState.waiting then
		queueState.waiting = false
		C_Timer_After(0.2, function()
			module:AdvanceMailQueue()
		end)
	end
end

--[[----------------------------------
--	Throttled mail queue (Open Selected / Delete Selected)
--]]
----------------------------------

function module:ProcessMailQueue(queue, actionFn)
	if queueState.active or not queue or #queue == 0 then
		return
	end

	queueState.active = true
	queueState.queue = queue
	queueState.pos = 0
	queueState.actionFn = actionFn

	module:AdvanceMailQueue()
end

function module:AdvanceMailQueue()
	if not queueState.active then
		return
	end

	queueState.pos = queueState.pos + 1
	local index = queueState.queue[queueState.pos]
	if not index then
		module:FinishMailQueue()
		return
	end

	local pos = queueState.pos
	queueState.waiting = true
	queueState.actionFn(index)

	C_Timer_After(2, function()
		if queueState.active and queueState.waiting and queueState.pos == pos then
			queueState.waiting = false
			module:AdvanceMailQueue()
		end
	end)
end

function module:FinishMailQueue()
	queueState.active = false
	queueState.queue = nil
	queueState.pos = 0
	queueState.waiting = false
	queueState.actionFn = nil
end

function module:OnMailClosed()
	if queueState.active then
		module:FinishMailQueue()
	end
end

--[[----------------------------------
--	Selection (Open Selected / Delete Selected)
--]]
----------------------------------

function module:GetSelectedIndices(descending)
	local list = {}
	for index in pairs(selectedIndices) do
		list[#list + 1] = index
	end
	tsort(list, descending and function(a, b) return a > b end or nil)
	return list
end

function module:OpenSelectedMail()
	if queueState.active then
		return
	end

	local queue = module:GetSelectedIndices(false)
	if #queue == 0 then
		F.Print(L["No mail selected."])
		return
	end

	wipe(selectedIndices)
	module:ProcessMailQueue(queue, AutoLootMailItem)
end

function module:DeleteSelected()
	local count = 0
	for _ in pairs(selectedIndices) do
		count = count + 1
	end

	if count == 0 then
		F.Print(L["No mail selected."])
		return
	end

	StaticPopup_Show("MER_DELETE_MAIL_SELECTED", count)
end

function module:DeleteSelectedConfirmed()
	if queueState.active then
		return
	end

	local queue = module:GetSelectedIndices(true)
	wipe(selectedIndices)

	module:ProcessMailQueue(queue, function(index)
		if InboxItemCanDelete(index) then
			DeleteInboxItem(index)
		else
			ReturnInboxItem(index)
		end
	end)
end

function module:RefreshSelectionCheckboxes()
	local db = E.db.mui.mail.selection
	if not (db and db.enable) then
		return
	end

	for i = 1, 7 do
		local row = _G["MailItem" .. i]
		local cb = row and row.merSelectBox
		if cb then
			local index = i + (InboxFrame.pageNum - 1) * 7
			if index > GetInboxNumItems() then
				cb:Hide()
			else
				cb:Show()
				cb:SetChecked(selectedIndices[index] or false)
			end
		end
	end
end

function module:CreateSelectionCheckboxes()
	if self.selectAllCheckbox then
		return
	end

	for i = 1, 7 do
		local row = _G["MailItem" .. i]
		if row and not row.merSelectBox then
			local cb = F.CreateCheckBox(row)
			cb:SetSize(14, 14)
			cb:SetPoint("TOPLEFT", row, "TOPLEFT", -2, 2)
			cb:SetFrameLevel(row:GetFrameLevel() + 5)
			cb.rowIndex = i
			cb:SetScript("OnClick", function(self)
				local index = self.rowIndex + (InboxFrame.pageNum - 1) * 7
				if self:GetChecked() then
					selectedIndices[index] = true
				else
					selectedIndices[index] = nil
				end
			end)
			row.merSelectBox = cb
		end
	end

	-- Select-all sits just above the first row, aligned with the per-row
	-- checkboxes - anchored to MailItem1 itself, not a guessed pixel offset.
	local selectAll = F.CreateCheckBox(InboxFrame)
	selectAll:SetSize(22, 22)
	selectAll:SetPoint("BOTTOMLEFT", _G.MailItem1, "TOPLEFT", -2, 2)
	selectAll:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		for i = 1, 7 do
			local index = i + (InboxFrame.pageNum - 1) * 7
			if index <= GetInboxNumItems() then
				selectedIndices[index] = checked or nil
				local row = _G["MailItem" .. i]
				if row and row.merSelectBox then
					row.merSelectBox:SetChecked(checked)
				end
			end
		end
	end)
	selectAll:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["Select all mail on this page"])
		GameTooltip:Show()
	end)
	selectAll:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	self.selectAllCheckbox = selectAll

	-- Open/Delete Selected flank Blizzard's own "Open All" button with an equal
	-- gap on each side, anchored to that real button instead of a guessed offset.
	local openSelected = MS.CreateButton(InboxFrame, 42, 20)
	openSelected:SetText(L["Open"])
	openSelected:SetPoint("RIGHT", _G.OpenAllMail, "LEFT", -5, 0)
	openSelected:SetScript("OnClick", function()
		module:OpenSelectedMail()
	end)
	openSelected:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["Open Selected"])
		GameTooltip:Show()
	end)
	openSelected:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	self.openSelectedButton = openSelected

	local deleteSelected = MS.CreateButton(InboxFrame, 42, 20)
	deleteSelected:SetText(L["Delete"])
	deleteSelected:SetPoint("LEFT", _G.OpenAllMail, "RIGHT", 5, 0)
	deleteSelected:SetScript("OnClick", function()
		module:DeleteSelected()
	end)
	deleteSelected:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["Delete Selected"])
		GameTooltip:Show()
	end)
	deleteSelected:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	self.deleteSelectedButton = deleteSelected
end

function module:UpdateSelectionCheckboxes()
	local db = E.db.mui.mail.selection
	local show = db and db.enable

	for i = 1, 7 do
		local row = _G["MailItem" .. i]
		if row and row.merSelectBox then
			if show then
				row.merSelectBox:Show()
			else
				row.merSelectBox:Hide()
			end
		end
	end

	if self.selectAllCheckbox then
		if show then
			self.selectAllCheckbox:Show()
		else
			self.selectAllCheckbox:Hide()
		end
	end
	if self.openSelectedButton then
		if show then
			self.openSelectedButton:Show()
		else
			self.openSelectedButton:Hide()
		end
	end
	if self.deleteSelectedButton then
		if show then
			self.deleteSelectedButton:Show()
		else
			self.deleteSelectedButton:Hide()
		end
	end

	if not show then
		wipe(selectedIndices)
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
	self:RegisterEvent("MAIL_CLOSED", "OnMailClosed")
	self:RegisterEvent("MAIL_FAILED", "OnMailFailed")
	self:SecureHook("SendMailFrame_Reset", "OnSendMailReset")

	module:CreateSelectionCheckboxes()
	module:UpdateSelectionCheckboxes()

	module:CreateSendTemplatesUI()
	module:ShowSendTemplatesUI()
end

function module:OnDisable()
	if self:IsHooked("InboxFrame_Update") then
		self:Unhook("InboxFrame_Update")
	end

	if self:IsEventRegistered("MAIL_CLOSED") then
		self:UnregisterEvent("MAIL_CLOSED")
	end
	if self:IsEventRegistered("MAIL_FAILED") then
		self:UnregisterEvent("MAIL_FAILED")
	end
	if self:IsHooked("SendMailFrame_Reset") then
		self:Unhook("SendMailFrame_Reset")
	end

	if queueState.active then
		module:FinishMailQueue()
	end
	wipe(selectedIndices)

	for i = 1, 7 do
		local expire = _G["MailItem" .. i .. "ExpireTime"]
		if expire and expire.returnicon then
			expire.returnicon:Hide()
		end

		local row = _G["MailItem" .. i]
		if row and row.merSelectBox then
			row.merSelectBox:Hide()
		end
	end

	if self.selectAllCheckbox then
		self.selectAllCheckbox:Hide()
	end
	if self.openSelectedButton then
		self.openSelectedButton:Hide()
	end
	if self.deleteSelectedButton then
		self.deleteSelectedButton:Hide()
	end

	module:HideSendTemplatesUI()
end

function module:Initialize()
	local db = E.db.mui.mail
	if db and db.enable then
		if type(db.selection) ~= "table" then
			db.selection = CopyTable(P.mail.selection)
		end
		if type(E.global.mui.mail.templates) ~= "table" then
			E.global.mui.mail.templates = {}
		end

		if not E.global.mui.mail.exampleTemplateSeeded then
			E.global.mui.mail.exampleTemplateSeeded = true
			E.global.mui.mail.templates[L["Example: Send to Alts"]] = {
				recipients = { "AltName-RealmName" },
				subject = L["Gold from Main"],
				body = L["This is an example template - edit the recipients/subject/body or delete it in Options > Mail > Send Templates."],
			}
		end

		self:Enable()
	else
		self:Disable()
	end
end

MER:RegisterModule(module:GetName())
