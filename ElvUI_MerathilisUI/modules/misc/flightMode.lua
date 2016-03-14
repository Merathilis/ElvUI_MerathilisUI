local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
if not IsAddOnLoaded("ElvUI_BenikUI") then return; end
local BFM = E:GetModule('BUIFlightMode');
local MFM = E:NewModule('MUIFlightMode');

function MFM:Initialize()
	if E.db.mui.general.FlightMode then
		-- Hide BenikUI Logo
		BFM.FlightMode.bottom.logo:Hide()
		-- Hide BenikUI Version
		BFM.FlightMode.bottom.benikui:Hide()
		
		-- MerathilisUI Logo
		BFM.FlightMode.bottom.logo = BFM.FlightMode:CreateTexture(nil, 'OVERLAY')
		BFM.FlightMode.bottom.logo:Size(256, 128)
		BFM.FlightMode.bottom.logo:Point("CENTER", BFM.FlightMode.bottom, "CENTER", 0, 35)
		BFM.FlightMode.bottom.logo:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\merathilis_logo.tga')
		
		-- MerathilisUI Version
		BFM.FlightMode.bottom.merathilisui = BFM.FlightMode.bottom:CreateFontString(nil, 'OVERLAY')
		BFM.FlightMode.bottom.merathilisui:FontTemplate(nil, 10)
		BFM.FlightMode.bottom.merathilisui:SetFormattedText("v%s", MER.Version)
		BFM.FlightMode.bottom.merathilisui:SetPoint("TOP", BFM.FlightMode.bottom.logo, "BOTTOM", 0, 30)
		BFM.FlightMode.bottom.merathilisui:SetTextColor(1, 1, 1)
	end
end

E:RegisterModule(MFM:GetName());
