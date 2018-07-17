local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions

-- WoW API / Variables
-- GLOBALS:

local function stylePostal()
	if E.private.muiSkins.addonSkins.bs ~= true or not IsAddOnLoaded("Postal") then return end

	if PostalOpenAllButton then
		PostalOpenAllButton:StyleButton(true)
		S:HandleButton(PostalOpenAllButton)
		OpenAllMail:Kill()
	end

	if Postal_OpenAllMenuButton then
		S:HandleNextPrevButton(Postal_OpenAllMenuButton, true)
		Postal_OpenAllMenuButton:SetPoint("LEFT", PostalOpenAllButton, "RIGHT", 2, 0)
	end

	if PostalSelectOpenButton then
		S:HandleButton(PostalSelectOpenButton, true)
		PostalSelectOpenButton:SetPoint("RIGHT", InboxFrame, "TOP", -41, -48)
	end

	if PostalSelectReturnButton then
		S:HandleButton(PostalSelectReturnButton, true)
		PostalSelectReturnButton:SetPoint("LEFT", InboxFrame, "TOP", -5, -48)
	end

	if Postal_ModuleMenuButton then
		S:HandleNextPrevButton(Postal_ModuleMenuButton, true)
		Postal_ModuleMenuButton:SetPoint('TOPRIGHT', MailFrame, -53, -6)
	end

	if Postal_BlackBookButton then
		S:HandleNextPrevButton(Postal_BlackBookButton, true)
		Postal_BlackBookButton:SetPoint("LEFT", SendMailNameEditBox, "RIGHT", 5, 2)
	end
end

S:AddCallbackForAddon("Postal", "mUIPostal", stylePostal)