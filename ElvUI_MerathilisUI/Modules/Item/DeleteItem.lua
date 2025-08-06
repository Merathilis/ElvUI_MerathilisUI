local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_DeleteItem")
local S = E:GetModule("Skins")

local _G = _G

local strmatch = strmatch
local strsplit = strsplit
local pairs = pairs

local CreateFrame = CreateFrame
local StaticPopupDialogs = _G.StaticPopupDialogs

local STATICPOPUP_NUMDIALOGS = STATICPOPUP_NUMDIALOGS
local DELETE_ITEM_CONFIRM_STRING = DELETE_ITEM_CONFIRM_STRING

local dialogs = {
	["DELETE_ITEM"] = true,
	["DELETE_GOOD_ITEM"] = true,
	["DELETE_QUEST_ITEM"] = true,
	["DELETE_GOOD_QUEST_ITEM"] = true,
}

function module:AddKeySupport(dialog)
	local targetFrame = dialog

	if self.db.fillIn == "AUTO" and dialog.EditBox then
		targetFrame = dialog.EditBox
	end

	if dialog.which ~= "DELETE_ITEM" then
		local msg = dialog.Text:GetText()
		local msgTable = { strsplit("\n\n", msg) }

		msg = ""

		for k, v in pairs(msgTable) do
			if (v ~= "") and (not strmatch(v, DELETE_ITEM_CONFIRM_STRING)) then
				msg = msg .. v .. "\n\n"
			end
		end

		msg = msg .. L["Press the |cffffd200Delete|r key as confirmation."]
		dialog.Text:SetText(msg)
	end

	targetFrame:SetScript("OnKeyDown", function(self, key)
		if key == "DELETE" then
			dialog.button1:Enable()
		end
	end)

	targetFrame:HookScript("OnHide", function(self)
		self:SetScript("OnKeyDown", nil)
	end)
end

function module:ShowFillInButton(dialog)
	local editBoxFrame = dialog.EditBox
	local yesButton = dialog.button1
	if not editBoxFrame or not yesButton then
		return
	end

	if not self.fillInButton then
		local button = CreateFrame("Button", "MER_DeleteButton", E.UIParent, "UIPanelButtonTemplate")
		button:SetFrameStrata("TOOLTIP")
		S:HandleButton(button)
		self.fillInButton = button
	end

	editBoxFrame:Hide()
	self.fillInButton:SetPoint("TOPLEFT", editBoxFrame, "TOPLEFT", -2, -4)
	self.fillInButton:SetPoint("BOTTOMRIGHT", editBoxFrame, "BOTTOMRIGHT", 2, 4)

	self.fillInButton:SetText("|cffe74c3c" .. L["Click to confirm"] .. "|r")
	self.fillInButton:SetScript("OnClick", function(self)
		yesButton:Enable()
		self:SetText("|cff2ecc71" .. L["Confirmed"] .. "|r")
	end)
	self.fillInButton:Show()
end

function module.HideFillInButton()
	if module.fillInButton then
		module.fillInButton:Hide()
		module.fillInButton:SetScript("OnClick", nil)
	end
end

function module:DELETE_ITEM_CONFIRM()
	for i = 1, STATICPOPUP_NUMDIALOGS do
		local dialog = _G["StaticPopup" .. i]
		local type = dialog.which
		if not dialogs[type] then
			return
		end

		if self.db.delKey then
			self:AddKeySupport(dialog)
		end

		if StaticPopupDialogs[type].hasEditBox == 1 then
			if self.db.fillIn == "CLICK" then
				self:ShowFillInButton(dialog)
				dialog:HookScript("OnHide", module.HideFillInButton)
			elseif self.db.fillIn == "AUTO" then
				dialog.EditBox:SetText(DELETE_ITEM_CONFIRM_STRING)
			end
		end
	end
end

function module:Initialize()
	if not E.db.mui.item.delete.enable then
		return
	end

	self.db = E.db.mui.item.delete

	self:RegisterEvent("DELETE_ITEM_CONFIRM")
end

function module:ProfileUpdate()
	if not E.db.mui.item.delete.enable then
		self:UnregisterEvent("DELETE_ITEM_CONFIRM")
	else
		self:Initialize()
	end
end

MER:RegisterModule(module:GetName())
