local MER, E, L, V, P, G = unpack(select(2, ...))

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

-- Compatibility
E.PopupDialogs["WINDTOOLS_MER_INCOMPATIBLE"] = {
	text = L["You got |cff00c0faElvUI_Windtools|r and |cffff7d0aMerathilisUI|r both enabled at the same time. Please select an addon to disable."],
	OnAccept = function() DisableAddOn("ElvUI_WindTools"); ReloadUI() end,
	OnCancel = function() DisableAddOn("ElvUI_MerathilisUI"); ReloadUI() end,
	button1 = "|cff00c0faElvUI_Windtools|r",
	button2 = MER.Title,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["LIVVEN_MER_INCOMPATIBLE"] = {
	text = L["You got |cff9482c9ElvUI_LivvenUI|r and |cffff7d0aMerathilisUI|r both enabled at the same time. Please select an addon to disable."],
	OnAccept = function() DisableAddOn("ElvUI_LivvenUI"); ReloadUI() end,
	OnCancel = function() DisableAddOn("ElvUI_MerathilisUI"); ReloadUI() end,
	button1 = "|cff9482c9ElvUI_LivvenUI|r",
	button2 = MER.Title,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

-- Profile Creation
function MER:NewProfile(new)
	if (new) then
		E.PopupDialogs["MERATHILISUI_CREATE_PROFILE_NEW"] = {
			text = MER:cOption(L["Name for the new profile"]),
			button1 = OKAY,
			button2 = CANCEL,
			hasEditBox = 1,
			whileDead = 1,
			hideOnEscape = 1,
			timeout = 0,
			OnShow = function(self, data)
				self.editBox:SetAutoFocus(false)
				self.editBox.width = self.editBox:GetWidth()
				self.editBox:Width(280)
				self.editBox:AddHistoryLine("text")
				self.editBox.temptxt = data
				self.editBox:SetText("MerathilisUI")
				self.editBox:HighlightText()
				self.editBox:SetJustifyH("CENTER")
			end,
			OnHide = function(self)
				self.editBox:Width(self.editBox.width or 50)
				self.editBox.width = nil
				self.temptxt = nil
			end,
			OnAccept = function(self, data, data2)
				local text = self.editBox:GetText()
				ElvUI[1].data:SetProfile(text)
				PluginInstallStepComplete.message = MER.Title.."Profile Created"
				PluginInstallStepComplete:Show()
			end
			}
		E:StaticPopup_Show("MERATHILISUI_CREATE_PROFILE_NEW")
	else
		E.PopupDialogs["MERATHILISUI_PROFILE_OVERRIDE"] = {
			text = MER:cOption(L["Are you sure you want to override the current profile?"]),
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				PluginInstallStepComplete.message = MER.Title..L["Profile Set"]
				PluginInstallStepComplete:Show()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}
		E:StaticPopup_Show("MERATHILISUI_PROFILE_OVERRIDE")
	end
end
