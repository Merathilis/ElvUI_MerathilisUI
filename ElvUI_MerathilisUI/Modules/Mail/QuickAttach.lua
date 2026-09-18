local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Mail") ---@class MER_Mail
local MS = MER:GetModule("MER_Skins")

local _G = _G
local ipairs = ipairs
local format = format

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetSendMailItem = GetSendMailItem
local StaticPopup_Show = StaticPopup_Show
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_Container_PickupContainerItem = C_Container.PickupContainerItem
local C_Item_GetItemInfoInstant = C_Item.GetItemInfoInstant

local ATTACHMENTS_MAX_SEND = ATTACHMENTS_MAX_SEND or 12
local NUM_BAG_SLOTS = NUM_BAG_SLOTS or 4
local REAGENT_BAG = Enum.BagIndex and Enum.BagIndex.ReagentBag
local C_Timer_After = C_Timer.After

local ICON_SIZE = 26
local ICON_GAP = 4

-- Blizzard's item class ID for trade goods, and the sub-class IDs it uses to
-- tell profession material types apart (Cloth, Leather, Herb, ...). "nil" is
-- used below as our own sentinel for "any trade goods, regardless of type".
local TRADEGOODS_CLASS_ID = 7
local CATEGORIES = {
	{ subclassID = 5, icon = "Interface\\Icons\\INV_Fabric_Silk_02", name = L["Cloth"] },
	{ subclassID = 6, icon = "Interface\\Icons\\INV_Misc_LeatherScrap_04", name = L["Leather"] },
	{ subclassID = 7, icon = "Interface\\Icons\\INV_Ore_Copper_01", name = L["Metal & Stone"] },
	{ subclassID = 8, icon = "Interface\\Icons\\INV_Misc_Food_15", name = L["Cooking"] },
	{ subclassID = 9, icon = "Interface\\Icons\\INV_Misc_Herb_02", name = L["Herb"] },
	{ subclassID = 12, icon = "Interface\\Icons\\INV_Enchant_Disenchant", name = L["Enchanting"] },
	{ subclassID = 16, icon = "Interface\\Icons\\INV_Inscription_Tradeskill01", name = L["Inscription"] },
	{ subclassID = 4, icon = "Interface\\Icons\\INV_Misc_Gem_01", name = L["Jewelcrafting"] },
	{ subclassID = 10, icon = "Interface\\Icons\\INV_Elemental_Primal_Fire", name = L["Elemental"] },
	{ subclassID = 18, icon = "Interface\\Icons\\INV_Misc_Bag_10_Blue", name = L["Optional Reagents"] },
	{ subclassID = 1, icon = "Interface\\Icons\\INV_Gizmo_02", name = L["Parts"] },
	{ subclassID = 11, icon = "Interface\\Icons\\INV_Misc_QuestionMark", name = L["Other"] },
	{ subclassID = nil, icon = "Interface\\Icons\\INV_Misc_Bag_08", name = L["All Trade Goods"] },
}

local quickAttachRecipientTarget

StaticPopupDialogs["MER_QUICK_ATTACH_RECIPIENT"] = {
	text = L["Set a default recipient for %s (leave empty to clear):"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	maxLetters = 48,
	OnShow = function(self)
		local key = quickAttachRecipientTarget
		self.EditBox:SetText((key and E.global.mui.mail.quickAttachRecipients[key]) or "")
		self.EditBox:HighlightText()
	end,
	OnAccept = function(self)
		if quickAttachRecipientTarget then
			E.global.mui.mail.quickAttachRecipients[quickAttachRecipientTarget] = self.EditBox:GetText()
		end
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}

local function FirstFreeAttachmentSlot()
	for i = 1, ATTACHMENTS_MAX_SEND do
		if not GetSendMailItem(i) then
			return i
		end
	end
end

function module:AttachTradeGoodsCategory(subclassID, categoryKey)
	local recipient = E.global.mui.mail.quickAttachRecipients[categoryKey]
	if recipient and recipient ~= "" then
		SendMailNameEditBox:SetText(recipient)
	end

	local bags = {}
	for bag = 0, NUM_BAG_SLOTS do
		bags[#bags + 1] = bag
	end
	if REAGENT_BAG then
		bags[#bags + 1] = REAGENT_BAG
	end

	for _, bag in ipairs(bags) do
		local slots = C_Container_GetContainerNumSlots(bag)
		for slot = 1, slots do
			local freeSlot = FirstFreeAttachmentSlot()
			if not freeSlot then
				return
			end

			local info = C_Container_GetContainerItemInfo(bag, slot)
			if info and info.itemID and not info.isLocked and not info.isBound then
				local _, _, _, _, _, classID, itemSubclassID = C_Item_GetItemInfoInstant(info.itemID)
				if classID == TRADEGOODS_CLASS_ID and (subclassID == nil or itemSubclassID == subclassID) then
					C_Container_PickupContainerItem(bag, slot)
					_G["SendMailAttachment" .. freeSlot]:Click()
				end
			end
		end
	end
end

-- WindTools' "Contacts" feature (favorites/alts/recent-recipients panel)
-- docks its own frame, named "WTContacts", to the right of the Send Mail
-- frame when enabled. Anchor past it when it's present and shown, so the
-- two bars never overlap; fall back to SendMailFrame's own edge otherwise.
function module:UpdateQuickAttachAnchor()
	if not self.quickAttachBar then
		return
	end

	if _G.WTContacts and _G.WTContacts:IsShown() then
		self.quickAttachBar:ClearAllPoints()
		self.quickAttachBar:SetPoint("TOPLEFT", _G.WTContacts, "TOPRIGHT", 6, -4)
	else
		-- SendMailFrame's own edge sits far past the visible border in this
		-- client, so anchor to a real, always-visible element near the top
		-- right (the "Postage" cost display) instead of the raw frame edge.
		self.quickAttachBar:ClearAllPoints()
		self.quickAttachBar:SetPoint("TOPLEFT", _G.SendMailCostMoneyFrame, "TOPRIGHT", 10, 6)
	end
end

-- WTContacts may not exist yet the first time the Send Mail frame shows (it
-- builds itself lazily too), so this is retried on every show until it's
-- found; once hooked, toggling it live re-anchors our bar immediately.
function module:HookWTContactsVisibility()
	if self.wtContactsHooked or not _G.WTContacts then
		return
	end

	_G.WTContacts:HookScript("OnShow", function()
		module:UpdateQuickAttachAnchor()
	end)
	_G.WTContacts:HookScript("OnHide", function()
		module:UpdateQuickAttachAnchor()
	end)
	self.wtContactsHooked = true
end

function module:CreateQuickAttachUI()
	if self.quickAttachBar then
		return
	end

	-- A vertical strip of profession-material category buttons to the right
	-- of the Send Mail frame - clicking one attaches every matching item type
	-- from your bags.
	local bar = CreateFrame("Frame", nil, SendMailFrame)
	bar:SetSize(ICON_SIZE, (ICON_SIZE + ICON_GAP) * #CATEGORIES - ICON_GAP)
	self.quickAttachBar = bar
	module:UpdateQuickAttachAnchor()

	SendMailFrame:HookScript("OnShow", function()
		C_Timer_After(0, function()
			module:HookWTContactsVisibility()
			module:UpdateQuickAttachAnchor()
		end)
	end)

	for index, category in ipairs(CATEGORIES) do
		local key = category.subclassID or "all"
		local btn = MS.CreateButton(bar, ICON_SIZE, ICON_SIZE, true, category.icon)
		if index == 1 then
			btn:SetPoint("TOP", bar, "TOP", 0, 0)
		else
			btn:SetPoint("TOP", bar, "TOP", 0, -(ICON_SIZE + ICON_GAP) * (index - 1))
		end

		btn:SetScript("OnClick", function()
			module:AttachTradeGoodsCategory(category.subclassID, key)
		end)
		btn:SetScript("OnMouseUp", function(self, mouseButton)
			if mouseButton == "RightButton" then
				quickAttachRecipientTarget = key
				StaticPopup_Show("MER_QUICK_ATTACH_RECIPIENT", category.name)
			end
		end)
		btn:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetText(category.name, 1, 1, 1)
			local recipient = E.global.mui.mail.quickAttachRecipients[key]
			if recipient and recipient ~= "" then
				GameTooltip:AddLine(format(L["Default recipient: %s"], recipient), nil, nil, nil, true)
			end
			GameTooltip:AddLine(L["Left-click to attach all - right-click to set a default recipient."], 1, 1, 1)
			GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
	end
end

function module:ShowQuickAttachUI()
	if self.quickAttachBar then
		self.quickAttachBar:Show()
	end
end

function module:HideQuickAttachUI()
	if self.quickAttachBar then
		self.quickAttachBar:Hide()
	end
end
