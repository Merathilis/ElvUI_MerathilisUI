local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

local DisableAddOn = DisableAddOn
local ReloadUI = ReloadUI

-- MerathilisUI Credits
StaticPopupDialogs["MERATHILISUI_CREDITS"] = {
	text = MER.Title,
	button1 = OKAY,
	hasEditBox = 1,
	OnShow = function(self, data)
		self.editBox:SetAutoFocus(false)
		self.editBox.width = self.editBox:GetWidth()
		self.editBox:Width(280)
		self.editBox:AddHistoryLine("text")
		self.editBox.temptxt = data
		self.editBox:SetText(data)
		self.editBox:HighlightText()
		self.editBox:SetJustifyH("CENTER")
	end,
	OnHide = function(self)
		self.editBox:Width(self.editBox.width or 50)
		self.editBox.width = nil
		self.temptxt = nil
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide();
	end,
	EditBoxOnTextChanged = function(self)
		if(self:GetText() ~= self.temptxt) then
			self:SetText(self.temptxt)
		end
		self:HighlightText()
		self:ClearFocus()
	end,
	OnAccept = E.noop,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}

-- ElvUI Versions check
E.PopupDialogs["VERSION_MISMATCH"] = {
	text = MER:MismatchText(),
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
}

-- BenikUI Tip
E.PopupDialogs['BENIKUI'] = {
	text = L["To get the whole MerathilisUI functionality and look it's recommended that you download |cff00c0faElvUI_BenikUI|r!"],
	button1 = CLOSE,
	OnAccept = E.noop,
	showAlert = 1
}

E.PopupDialogs['MAP_PIN_NOTE'] = {
	text = 'Add a Note',
	button2 = CLOSE,
	timeout = 0,
	hasEditBox = 1,
	maxLetters = 1024,
	editBoxWidth = 350,
	whileDead = true,
	hideOnEscape = true,
	OnShow = function(self)
		(self.icon or _G[self:GetName()..'AlertIcon']):Hide()
		local editBox = self.editBox or _G[self:GetName()..'EditBox']
		local pin = focus
		if pin.note then editBox:SetText(pin.note) else editBox:SetText('') end
		editBox:SetFocus()
		local button2 = self.button2 or _G[self:GetName()..'Button2']
		button2:ClearAllPoints()
		button2:SetPoint('TOP', editBox, 'BOTTOM', 0, -6)
		button2:SetWidth(150)
		self:SetFrameStrata('FULLSCREEN')
		WorldMapFrame:SetFrameStrata('DIALOG')
	end,
	OnHide = function(self)
		local editBox = self.editBox or _G[self:GetName()..'EditBox']
		local t = editBox:GetText()
		local pin = focus
		pin.note = t
		focus = nil
		self:SetFrameStrata('DIALOG')
		WorldMapFrame:SetFrameStrata('FULLSCREEN')
	end,
}