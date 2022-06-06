local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

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

	local MiniMapMailFrame = _G.MiniMapMailFrame

	-- Change the Minimap Mail icon
	_G.MiniMapMailIcon:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\Textures\\Mail")
	_G.MiniMapMailIcon:SetSize(16, 16)
	MiniMapMailFrame:Raise()

	MiniMapMailFrame:SetScript("OnShow", function()
		if not MiniMapMailFrame.highlight then
			MiniMapMailFrame.highlight = CreateFrame("Frame", nil, MiniMapMailFrame)
			MiniMapMailFrame.highlight:SetAllPoints(MiniMapMailFrame)
			MiniMapMailFrame.highlight:SetFrameLevel(MiniMapMailFrame:GetFrameLevel() + 1)

			MiniMapMailFrame.highlight.tex = MiniMapMailFrame.highlight:CreateTexture()
			MiniMapMailFrame.highlight.tex:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\Textures\\Mail")
			MiniMapMailFrame.highlight.tex:SetPoint("TOPLEFT", _G.MiniMapMailIcon, "TOPLEFT", -2, 2)
			MiniMapMailFrame.highlight.tex:SetPoint("BOTTOMRIGHT", _G.MiniMapMailIcon, "BOTTOMRIGHT", 2, -2)
			MiniMapMailFrame.highlight.tex:SetVertexColor(r, g, b)

			MER:CreatePulse(MiniMapMailFrame, 1, 1)
		end
	end)

	local MailFrame = _G.MailFrame
	MailFrame.backdrop:Styling()
	MER:CreateBackdropShadow(MailFrame)

	-- InboxFrame
	for i = 1, _G.INBOXITEMS_TO_DISPLAY do
		local bg = _G["MailItem"..i]
		bg:StripTextures()

		local b = _G["MailItem"..i.."Button"]
		b:StripTextures()
		b:CreateBackdrop("Transparent", true)
		b:StyleButton()
	end

	-- SendMailFrame
	local SendMailFrame = _G.SendMailFrame

	for i = 4, 7 do
		select(i, SendMailFrame:GetRegions()):Hide()
	end

	-- OpenMailFrame
	local OpenMailFrame = _G.OpenMailFrame
	OpenMailFrame:Styling()
	MER:CreateShadow(OpenMailFrame)

	OpenMailFrame:SetPoint("TOPLEFT", _G.InboxFrame, "TOPRIGHT", 5, 0)
	_G.OpenMailFrameIcon:Hide()
	_G.OpenMailTitleText:ClearAllPoints()
	_G.OpenMailTitleText:SetPoint("TOP", 0, -4)
	_G.OpenMailHorizontalBarLeft:Hide()

	local OpenMailScrollFrame = _G.OpenMailScrollFrame
	OpenMailScrollFrame:CreateBackdrop("Transparent")
	OpenMailScrollFrame:SetPoint("TOPLEFT", 17, -83)
	OpenMailScrollFrame:SetWidth(304)

	OpenMailScrollFrame.ScrollBar:ClearAllPoints()
	OpenMailScrollFrame.ScrollBar:SetPoint("TOPRIGHT", OpenMailScrollFrame, -1, -18)
	OpenMailScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", OpenMailScrollFrame, -1, 18)
	_G.OpenScrollBarBackgroundTop:Hide()
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
