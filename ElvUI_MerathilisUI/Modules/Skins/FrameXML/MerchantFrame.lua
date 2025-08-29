local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G
local pairs, unpack = pairs, unpack

local hooksecurefunc = hooksecurefunc

function module:HandleMerchantItem(index)
	for currencyIndex = 1, 3 do
		local itemLine = _G["MerchantItem" .. index .. "AltCurrencyFrameItem" .. currencyIndex]
		for _, region in pairs({ itemLine:GetRegions() }) do
			if region:GetObjectType() == "Texture" then
				region:SetTexCoord(unpack(E.TexCoords))
			end
		end
	end
end

function module:MerchantFrame()
	if not self:CheckDB("merchant", "merchant") then
		return
	end

	local MerchantFrame = _G.MerchantFrame
	self:CreateShadow(MerchantFrame)

	for i = 1, 2 do
		self:ReskinTab(_G["MerchantFrameTab" .. i])
	end

	for i = 1, 12 do
		self:HandleMerchantItem(i)
	end

	for _, region in pairs({ _G.MerchantMoneyFrame.GoldButton:GetRegions() }) do
		if region:GetObjectType() == "Texture" then
			F.MoveFrameWithOffset(region, 0, 4)
		end
	end

	hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
		for i = 1, 3 do
			local token = _G["MerchantToken" .. i]
			if token and not token.__MERSkin then
				F.SetFontOutline(token.Count)
				F.MoveFrameWithOffset(token.Count, -2, 0)
				token.Icon:SetTexCoord(unpack(E.TexCoords))
				token.__MERSkin = true
			end
		end
	end)
end

module:AddCallback("MerchantFrame")
