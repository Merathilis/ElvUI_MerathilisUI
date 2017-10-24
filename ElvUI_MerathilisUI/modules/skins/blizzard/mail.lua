local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local unpack = unpack
local select = select
--WoW API / Variables
local GetInboxText = GetInboxText
local GetInboxInvoiceInfo = GetInboxInvoiceInfo

--GLOBALS: hooksecurefunc, INBOXITEMS_TO_DISPLAY, ATTACHMENTS_MAX_SEND

local function styleMail()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.mail ~= true or E.private.muiSkins.blizzard.mail ~= true then return end

	-- Change the Minimap Mail icon
	_G["MiniMapMailIcon"]:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\Mail")
	_G["MiniMapMailIcon"]:SetSize(16, 16)

	local MailFrame = _G["MailFrame"]
	select(18, MailFrame:GetRegions()):Hide()

	MERS:CreateStripes(MailFrame)

	-- InboxFrame
	for i = 1, INBOXITEMS_TO_DISPLAY do
		local bg = _G["MailItem"..i]
		bg:StripTextures()

		if bg.backdrop then
			bg.backdrop:Hide()
		end
		MERS:CreateBD(bg, .25)

		local b = _G["MailItem"..i.."Button"]
		b:StripTextures()
		b:SetTemplate("Transparent", true)
		b:StyleButton()
	end

	-- SendMailFrame
	local SendMailFrame = _G["SendMailFrame"]
	local SendMailScrollFrame = _G["SendMailScrollFrame"]
	SendMailScrollFrame:SetTemplate("Transparent")

	for i = 4, 7 do
		select(i, SendMailFrame:GetRegions()):Hide()
	end

	select(4, SendMailScrollFrame:GetRegions()):Hide()
	_G["SendMailBodyEditBox"]:SetPoint("TOPLEFT", 2, -2)
	_G["SendMailBodyEditBox"]:SetWidth(278)

	for i = 1, ATTACHMENTS_MAX_SEND do
		local b = _G["SendMailAttachment"..i]
		if not b.skinned then
			b:StripTextures()
			b:SetTemplate("Transparent", true)
			MERS:CreateGradient(b)
			b:StyleButton()
			b.skinned = true
			hooksecurefunc(b.IconBorder, "SetVertexColor", function(self, r, g, b)
				self:GetParent():SetBackdropBorderColor(r, g, b)
				self:SetTexture("")
			end)
			hooksecurefunc(b.IconBorder, "Hide", function(self)
				self:GetParent():SetBackdropBorderColor(unpack(E.media.bordercolor))
			end)
		end
		local t = b:GetNormalTexture()
		if t then
			t:SetTexCoord(unpack(E.TexCoords))
			t:SetInside()
		end
	end

	-- OpenMailFrame
	local OpenMailFrame = _G["OpenMailFrame"]

	MERS:CreateStripes(OpenMailFrame)

	OpenMailFrame:SetPoint("TOPLEFT", _G["InboxFrame"], "TOPRIGHT", 5, 0)
	_G["OpenMailFrameIcon"]:Hide()
	_G["OpenMailTitleText"]:ClearAllPoints()
	_G["OpenMailTitleText"]:SetPoint("TOP", 0, -4)
	_G["OpenMailHorizontalBarLeft"]:Hide()
	select(25, OpenMailFrame:GetRegions()):Hide()

	local OpenMailScrollFrame = _G["OpenMailScrollFrame"]
	OpenMailScrollFrame:SetTemplate("Transparent")
	OpenMailScrollFrame:SetPoint("TOPLEFT", 17, -83)
	OpenMailScrollFrame:SetWidth(304)

	OpenMailScrollFrame.ScrollBar:ClearAllPoints()
	OpenMailScrollFrame.ScrollBar:SetPoint("TOPRIGHT", OpenMailScrollFrame, -1, -18)
	OpenMailScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", OpenMailScrollFrame, -1, 18)
	_G["OpenScrollBarBackgroundTop"]:Hide()
	select(2, OpenMailScrollFrame:GetRegions()):Hide()
	_G["OpenStationeryBackgroundLeft"]:Hide()
	_G["OpenStationeryBackgroundRight"]:Hide()

	_G["InvoiceTextFontNormal"]:SetTextColor(1, 1, 1)
	_G["InvoiceTextFontSmall"]:SetTextColor(1, 1, 1)
	_G["OpenMailArithmeticLine"]:SetColorTexture(0.8, 0.8, 0.8)
	_G["OpenMailArithmeticLine"]:SetSize(256, 1)
	_G["OpenMailInvoiceAmountReceived"]:SetPoint("TOPRIGHT", _G["OpenMailArithmeticLine"], "BOTTOMRIGHT", -14, -5)

	hooksecurefunc("OpenMail_Update", function()
		if ( not _G["InboxFrame"].openMailID ) then
			return
		end

		local _, _, _, isInvoice = GetInboxText(_G["InboxFrame"].openMailID)
		if isInvoice then
			local invoiceType, _, playerName = GetInboxInvoiceInfo(_G["InboxFrame"].openMailID)
			if playerName then
				if invoiceType == "buyer" then
					_G["OpenMailArithmeticLine"]:SetPoint("TOP", "OpenMailInvoicePurchaser", "BOTTOMLEFT", 125, -5)
				elseif invoiceType == "seller" then
					_G["OpenMailArithmeticLine"]:SetPoint("TOP", "OpenMailInvoiceHouseCut", "BOTTOMRIGHT", -114, -22)
				elseif invoiceType == "seller_temp_invoice" then
					_G["OpenMailArithmeticLine"]:SetPoint("TOP", "OpenMailInvoicePurchaser", "BOTTOMLEFT", 125, -5)
				end
			end
		end
	end)
end

S:AddCallback("mUIMail", styleMail)