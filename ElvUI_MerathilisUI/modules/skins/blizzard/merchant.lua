local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

local function styleMerchant()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.merchant ~= true or E.private.muiSkins.blizzard.merchant ~= true then return end

	MERS:CreateGradient(MerchantFrame)
	if not MerchantFrame.stripes then
		MERS:CreateStripes(MerchantFrame)
	end
end

S:AddCallback("mUIMerchant", styleMerchant)