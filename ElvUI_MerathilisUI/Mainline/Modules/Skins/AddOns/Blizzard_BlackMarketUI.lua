local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local pairs, select, unpack = pairs, select, unpack

local CreateFrame = CreateFrame
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local hooksecurefunc = hooksecurefunc

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if not module:CheckDB("bmah", "blackmarket") then
		return
	end

	local BlackMarketFrame = _G.BlackMarketFrame

	BlackMarketFrame.Inset:DisableDrawLayer("BORDER")
	select(9, BlackMarketFrame.Inset:GetRegions()):Hide()
	BlackMarketFrame.MoneyFrameBorder:Hide()
	BlackMarketFrame.HotDeal.Left:Hide()
	BlackMarketFrame.HotDeal.Right:Hide()
	select(4, BlackMarketFrame.HotDeal:GetRegions()):Hide()

	BlackMarketFrame:Styling()
	module:CreateBackdropShadow(BlackMarketFrame)

	module:CreateBG(BlackMarketFrame.HotDeal.Item)

	local headers = {"ColumnName", "ColumnLevel", "ColumnType", "ColumnDuration", "ColumnHighBidder", "ColumnCurrentBid"}
	for _, headerName in pairs(headers) do
		local header = BlackMarketFrame[headerName]
		header.Left:Hide()
		header.Middle:Hide()
		header.Right:Hide()

		local bg = CreateFrame("Frame", nil, header)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 0)
		bg:SetFrameLevel(header:GetFrameLevel()-1)
		bg:CreateBackdrop('Transparent')
	end

	BlackMarketFrame.HotDeal:CreateBackdrop('Transparent')

	hooksecurefunc("BlackMarketScrollFrame_Update", function()
		local buttons = _G.BlackMarketScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]

			bu.Item.IconTexture:SetTexCoord(unpack(E.TexCoords))
			if not bu.reskinned then
				bu.Left:Hide()
				bu.Right:Hide()
				select(3, bu:GetRegions()):Hide()

				bu.Item:SetNormalTexture("")
				bu.Item:SetPushedTexture("")
				bu.Item:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				bu.Item.IconBorder:SetAlpha(0)

				local bg = CreateFrame("Frame", nil, bu)
				bg:SetPoint("TOPLEFT")
				bg:SetPoint("BOTTOMRIGHT", 0, 5)
				bg:SetFrameLevel(bu:GetFrameLevel()-1)
				bg:CreateBackdrop('Transparent')

				local tex = bu:CreateTexture(nil, "BACKGROUND")
				tex:SetPoint("TOPLEFT")
				tex:SetPoint("BOTTOMRIGHT", 0, 5)
				tex:SetColorTexture(0, 0, 0, .25)

				bu:SetHighlightTexture(E["media"].normTex)
				local hl = bu:GetHighlightTexture()
				hl:SetVertexColor(r, g, b, .2)
				hl.SetAlpha = MER.dummy
				hl:ClearAllPoints()
				hl:SetPoint("TOPLEFT", 0, -1)
				hl:SetPoint("BOTTOMRIGHT", -1, 6)

				bu.Selection:ClearAllPoints()
				bu.Selection:SetPoint("TOPLEFT", 0, -1)
				bu.Selection:SetPoint("BOTTOMRIGHT", -1, 6)
				bu.Selection:SetTexture(E["media"].normTex)
				bu.Selection:SetVertexColor(r, g, b, .1)

				bu.reskinned = true
			end

			if bu:IsShown() and bu.itemLink then
				local _, _, quality = GetItemInfo(bu.itemLink)
				bu.Name:SetTextColor(GetItemQualityColor(quality))
			end
		end
	end)

	hooksecurefunc("BlackMarketFrame_UpdateHotItem", function(self)
		local hotDeal = self.HotDeal
		if hotDeal:IsShown() and hotDeal.itemLink then
			local _, _, quality = GetItemInfo(hotDeal.itemLink)
			hotDeal.Name:SetTextColor(GetItemQualityColor(quality))
		end
		hotDeal.Item.IconBorder:Hide()
	end)
end

S:AddCallbackForAddon("Blizzard_BlackMarketUI", LoadSkin)
