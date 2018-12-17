local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS:

local function stylePostal()
	if E.private.muiSkins.addonSkins.bs ~= true or not IsAddOnLoaded("Postal") then return end

	if _G.PostalOpenAllButton then
		_G.PostalOpenAllButton:StyleButton(true)
		S:HandleButton(_G.PostalOpenAllButton)
		_G.OpenAllMail:Kill()
	end

	if _G.Postal_OpenAllMenuButton then
		S:HandleNextPrevButton(_G.Postal_OpenAllMenuButton, true)
		_G.Postal_OpenAllMenuButton:SetPoint("LEFT", _G.PostalOpenAllButton, "RIGHT", 2, 0)
	end

	if _G.PostalSelectOpenButton then
		S:HandleButton(_G.PostalSelectOpenButton, true)
		_G.PostalSelectOpenButton:SetPoint("RIGHT", _G.InboxFrame, "TOP", -41, -48)
	end

	if _G.PostalSelectReturnButton then
		S:HandleButton(_G.PostalSelectReturnButton, true)
		_G.PostalSelectReturnButton:SetPoint("LEFT", _G.InboxFrame, "TOP", -5, -48)
	end

	if _G.Postal_ModuleMenuButton then
		S:HandleNextPrevButton(_G.Postal_ModuleMenuButton, true)
		_G.Postal_ModuleMenuButton:SetPoint('TOPRIGHT', _G.MailFrame, -53, -6)
	end

	if _G.Postal_BlackBookButton then
		S:HandleNextPrevButton(_G.Postal_BlackBookButton, true)
		_G.Postal_BlackBookButton:SetPoint("LEFT", _G.SendMailNameEditBox, "RIGHT", 5, 2)
	end
end

S:AddCallbackForAddon("Postal", "mUIPostal", stylePostal)
