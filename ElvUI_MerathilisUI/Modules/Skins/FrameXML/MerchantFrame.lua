local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

local function HandleMerchantItem(index)
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
	if not module:CheckDB("merchant", "merchant") then
		return
	end

	local MerchantFrame = _G.MerchantFrame
	module:CreateShadow(MerchantFrame)

	for i = 1, 2 do
		module:ReskinTab(_G["MerchantFrameTab" .. i])
	end

	for i = 1, 10 do
		HandleMerchantItem(i)
	end
end

module:AddCallback("MerchantFrame")
