local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

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

	for i = 1, 10 do
		self:HandleMerchantItem(i)
	end
end

module:AddCallback("MerchantFrame")
