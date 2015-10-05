local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

E.PopupDialogs['BENIKUI'] = {
	text = L["To get the whole MerathilisUI Functionality and Look it's recommended that you download |cff00c0faElvUI_BenikUI|r!"],
	button1 = YES,
	OnAccept = E.noop,
	showAlert = 1,
}

E.PopupDialogs["OUTDATED"] = {
	text = L["Download MerathilisUI"],
	button1 = OKAY,
	timeout = 0,
	whileDead = true,
	hasEditBox = true,
	editBoxWidth = 325,
	OnShow = function(self, ...) 
		self.editBox:SetFocus()
		self.editBox:SetText("http://git.tukui.org/Merathilis/UI-Settings")
		self.editBox:HighlightText()
	end,
	EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
}

E.PopupDialogs["WATCHFRAME_URL"] = {
	text = L['WATCH_WOWHEAD_LINK'],
	button1 = OKAY,
	timeout = 0,
	whileDead = true,
	hasEditBox = true,
	editBoxWidth = 350,
	OnShow = function(self, ...) self.editBox:SetFocus() end,
	EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	preferredIndex = 5,
}
