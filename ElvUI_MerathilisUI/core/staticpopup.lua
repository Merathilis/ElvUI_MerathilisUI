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

--Incompatibility messages
E.PopupDialogs["MER_INCOMPATIBLE_ADDON"] = {
	text = gsub(L["INCOMPATIBLE_ADDON"], "ElvUI", "ElvUI_MerathilisUI"),
	OnAccept = function(self) DisableAddOn(E.PopupDialogs["MER_INCOMPATIBLE_ADDON"].addon); ReloadUI(); end,
	OnCancel = function(self) E.PopupDialogs["MER_INCOMPATIBLE_ADDON"].optiontable[E.PopupDialogs["MER_INCOMPATIBLE_ADDON"].value] = false; ReloadUI(); end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["LOCATION_PLUS_INCOMPATIBLE"] = {
	text = L["You have got Location Plus and Shadow & Light both enabled at the same time. Select an addon to disable."],
	OnAccept = function() DisableAddOn("ElvUI_LocPlus"); ReloadUI() end,
	OnCancel = function() DisableAddOn("ElvUI_SLE"); ReloadUI() end,
	button1 = 'Location Plus',
	button2 = 'Shadow & Light',
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}
