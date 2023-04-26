local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule("Skins")

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

local function LoadSkin()
	if not module:CheckDB("merchant", "merchant") then
		return
	end

	local MerchantFrame = _G.MerchantFrame
	MerchantFrame:Styling()

	for i = 1, 2 do
		module:ReskinTab(_G["MerchantFrameTab"..i])
	end

	for i = 1, 10 do
		HandleMerchantItem(i)
	end
end

S:AddCallback("MerchantFrame", LoadSkin)
