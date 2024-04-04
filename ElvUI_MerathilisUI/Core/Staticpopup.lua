local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)

local C_AddOns_DisableAddOn = C_AddOns.DisableAddOn

-- MerathilisUI Credits
E.PopupDialogs["MERATHILISUI_CREDITS"] = {
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
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnTextChanged = function(self)
		if self:GetText() ~= self.temptxt then
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
E.PopupDialogs["VERSION_OUTDATED"] = {
	text = format(L["MSG_MER_ELV_OUTDATED"], MER.ElvUIVersion, MER.RequiredVersion),
	-- button1 = CLOSE,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = false,
}

E.PopupDialogs["VERSION_MISMATCH"] = {
	text = L["MSG_MER_ELV_MISMATCH"],
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = false,
}

-- Compatibility
E.PopupDialogs["WINDTOOLS_MER_INCOMPATIBLE"] = {
	text = L["You got |cff00c0faElvUI_Windtools|r and |cffff7d0aMerathilisUI|r both enabled at the same time. Please select an addon to disable."],
	OnAccept = function()
		C_AddOns_DisableAddOn("ElvUI_WindTools")
		ReloadUI()
	end,
	OnCancel = function()
		C_AddOns_DisableAddOn("ElvUI_MerathilisUI")
		ReloadUI()
	end,
	button1 = "|cff00c0faElvUI_Windtools|r",
	button2 = MER.Title,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["LIVVEN_MER_INCOMPATIBLE"] = {
	text = L["You got |cff9482c9ElvUI_LivvenUI|r and |cffff7d0aMerathilisUI|r both enabled at the same time. Please select an addon to disable."],
	OnAccept = function()
		C_AddOns_DisableAddOn("ElvUI_LivvenUI")
		ReloadUI()
	end,
	OnCancel = function()
		C_AddOns_DisableAddOn("ElvUI_MerathilisUI")
		ReloadUI()
	end,
	button1 = "|cff9482c9ElvUI_LivvenUI|r",
	button2 = MER.Title,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs.MERATHILISUI_RESET_MODULE = {
	text = L["Are you sure you want to reset %s module?"],
	button1 = _G.ACCEPT,
	button2 = _G.CANCEL,
	OnAccept = function(_, func)
		func()
		ReloadUI()
	end,
	whileDead = 1,
	hideOnEscape = true,
}

E.PopupDialogs.MERATHILISUI_RESET_ALL_MODULES = {
	text = format(L["Reset all %s modules."], MER.Title),
	button1 = _G.ACCEPT,
	button2 = _G.CANCEL,
	OnAccept = function()
		E.db.mui = P
		E.private.mui = V
		ReloadUI()
	end,
	whileDead = 1,
	hideOnEscape = true,
}

E.PopupDialogs.MERATHILISUI_INVALIDPOWER = {
	text = L["Invalid Model, you need to add a Model ID/Path"],
	button1 = _G.OKAY,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
}
