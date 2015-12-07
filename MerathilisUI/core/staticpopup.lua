local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
local YES, OKAY, CLOSE = YES, OKAY, CLOSE

-- ElvUI Version check
E.PopupDialogs["VERSION_MISMATCH"] = {
	text = MER:MismatchText(),
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
}

-- Benik UI Tip
E.PopupDialogs['BENIKUI'] = {
	text = L["To get the whole MerathilisUI functionality and look it's recommended that you download |cff00c0faElvUI_BenikUI|r!"],
	button1 = YES,
	OnAccept = E.noop,
	showAlert = 1
}

-- Wowhead Links
E.PopupDialogs["WATCHFRAME_URL"] = {
	text = L['WATCH_WOWHEAD_LINK'],
	button1 = OKAY,
	timeout = 0,
	whileDead = true,
	hasEditBox = true,
	editBoxWidth = 325,
	OnShow = function(self, ...) self.editBox:SetFocus() end,
	EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	preferredIndex = 5
}
