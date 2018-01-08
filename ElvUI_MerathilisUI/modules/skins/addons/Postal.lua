local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local CreateFrame = CreateFrame
-- WoW API / Variables
-- GLOBALS:

local function stylePostal()
	if E.private.muiSkins.addonSkins.po ~= true then return end

	InboxPrevPageButton:SetPoint('CENTER', InboxFrame, 'BOTTOMLEFT', 45, 112)
	InboxNextPageButton:SetPoint('CENTER', InboxFrame, 'BOTTOMLEFT', 295, 112)
	OpenAllMail:Kill()

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local b = _G['MailItem'..i..'ExpireTime']
		if b then
			b:SetPoint('TOPRIGHT', 'MailItem'..i, 'TOPRIGHT', -5, -10)
			if b.returnicon then
				b.returnicon:SetPoint('TOPRIGHT', b, 'TOPRIGHT', 20, 0)
			end
		end
		if _G['PostalInboxCB'..i] then
			S:HandleCheckBox(_G['PostalInboxCB'..i])
		end
	end

	if _G["PostalSelectOpenButton"] then
		S:HandleButton(_G["PostalSelectOpenButton"])
		PostalSelectOpenButton:SetPoint('RIGHT', _G["InboxFrame"], 'TOP', -41, -48)
	end

	if _G["Postal_OpenAllMenuButton"] then
		S:HandleNextPrevButton(_G["Postal_OpenAllMenuButton"], true)
		_G["Postal_OpenAllMenuButton"]:SetPoint('LEFT', _G["PostalOpenAllButton"], 'RIGHT', 5, 0)
	end

	if _G["PostalOpenAllButton"] then
		S:HandleButton(_G["PostalOpenAllButton"])
		_G["PostalOpenAllButton"]:SetPoint('CENTER', _G["InboxFrame"], 'TOP', -34, -400)
	end

	if _G["PostalSelectReturnButton"] then
		S:HandleButton(_G["PostalSelectReturnButton"])
		_G["PostalSelectReturnButton"]:SetPoint('LEFT', _G["InboxFrame"], 'TOP', -5, -48)
	end

	if _G["Postal_ModuleMenuButton"] then
		S:HandleNextPrevButton(_G["Postal_ModuleMenuButton"], true)
		_G["Postal_ModuleMenuButton"]:SetPoint('TOPRIGHT', _G["MailFrame"], -53, -6)
	end

	if _G["Postal_BlackBookButton"] then
		S:HandleNextPrevButton(_G["Postal_BlackBookButton"])
		_G["Postal_BlackBookButton"]:SetPoint('LEFT', _G["SendMailNameEditBox"], 'RIGHT', 5, 2)
	end
end

S:AddCallbackForAddon("Postal", "mUIPostal", stylePostal)