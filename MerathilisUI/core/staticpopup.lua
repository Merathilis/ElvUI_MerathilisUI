local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

E.PopupDialogs['BENIKUI'] = {
	text = L["To get the whole MerathilisUI functionality it's recommended that you download |cff00c0faElvUI_BenikUI|r!"],
	button1 = YES,
	OnAccept = E.noop,
	showAlert = 1,
}
