local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local A = F.Animation
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack
local select = select

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local GetInboxText = GetInboxText
local GetInboxInvoiceInfo = GetInboxInvoiceInfo

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if not module:CheckDB("mail", "mail") then
		return
	end

	local MailFrame = _G.MailFrame
	MailFrame:Styling()
	module:CreateShadow(MailFrame)

	for i = 1, 2 do
		module:ReskinTab(_G["MailFrameTab"..i])
	end

	_G.MailFrameTab2:ClearAllPoints()
	_G.MailFrameTab2:SetPoint("TOPLEFT", _G.MailFrameTab1, "TOPRIGHT", -5, 0)

	-- InboxFrame
	for i = 1, _G.INBOXITEMS_TO_DISPLAY do
		local bg = _G["MailItem" .. i]
		bg:StripTextures()

		if bg.backdrop then
			bg.backdrop:Hide()
		end
		bg:CreateBackdrop('Transparent')


		local b = _G["MailItem" .. i .. "Button"]
		b:StripTextures()
		b:CreateBackdrop("Transparent", true)
		b:StyleButton()
	end

	-- SendMailFrame
	local SendMailFrame = _G.SendMailFrame
	local SendMailScrollFrame = _G.SendMailScrollFrame
	SendMailScrollFrame:SetTemplate("Transparent")

	select(4, SendMailScrollFrame:GetRegions()):Hide()
	_G.SendMailBodyEditBox:SetPoint("TOPLEFT", 2, -2)
	_G.SendMailBodyEditBox:SetWidth(278)

	-- OpenMailFrame
	local OpenMailFrame = _G.OpenMailFrame
	OpenMailFrame:Styling()
	_G.OpenMailScrollFrame:SetTemplate("Transparent")
	module:CreateShadow(OpenMailFrame)

	OpenMailFrame:SetPoint("TOPLEFT", _G.InboxFrame, "TOPRIGHT", 5, 0)
	_G.OpenMailFrameIcon:Hide()
	_G.OpenMailHorizontalBarLeft:Hide()

	local OpenMailScrollFrame = _G.OpenMailScrollFrame
	OpenMailScrollFrame:CreateBackdrop("Transparent")
	OpenMailScrollFrame:SetPoint("TOPLEFT", 17, -83)
	OpenMailScrollFrame:SetWidth(304)

	OpenMailScrollFrame.ScrollBar:ClearAllPoints()
	OpenMailScrollFrame.ScrollBar:SetPoint("TOPRIGHT", OpenMailScrollFrame, -1, -18)
	OpenMailScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", OpenMailScrollFrame, -1, 18)
	select(2, OpenMailScrollFrame:GetRegions()):Hide()
	_G.OpenStationeryBackgroundLeft:Hide()
	_G.OpenStationeryBackgroundRight:Hide()

	_G.InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	_G.InvoiceTextFontSmall:SetTextColor(1, 1, 1)
	_G.OpenMailArithmeticLine:SetColorTexture(0.8, 0.8, 0.8)
	_G.OpenMailArithmeticLine:SetSize(256, 1)
	_G.OpenMailInvoiceAmountReceived:SetPoint("TOPRIGHT", _G.OpenMailArithmeticLine, "BOTTOMRIGHT", -14, -5)

	hooksecurefunc("OpenMail_Update", function()
		if not _G.InboxFrame.openMailID then
			return
		end

		local _, _, _, isInvoice = GetInboxText(_G.InboxFrame.openMailID)
		if isInvoice then
			local invoiceType, _, playerName = GetInboxInvoiceInfo(_G.InboxFrame.openMailID)
			if playerName then
				if invoiceType == "buyer" then
					_G.OpenMailArithmeticLine:SetPoint("TOP", "OpenMailInvoicePurchaser", "BOTTOMLEFT", 125, -5)
				elseif invoiceType == "seller" then
					_G.OpenMailArithmeticLine:SetPoint("TOP", "OpenMailInvoiceHouseCut", "BOTTOMRIGHT", -114, -22)
				elseif invoiceType == "seller_temp_invoice" then
					_G.OpenMailArithmeticLine:SetPoint("TOP", "OpenMailInvoicePurchaser", "BOTTOMLEFT", 125, -5)
				end
			end
		end
	end)
end

S:AddCallback("MailFrame", LoadSkin)
