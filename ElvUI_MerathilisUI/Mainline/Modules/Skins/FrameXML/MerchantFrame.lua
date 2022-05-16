local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.merchant ~= true or E.private.mui.skins.blizzard.merchant ~= true then return end

	local MerchantFrame = _G.MerchantFrame
	MerchantFrame:Styling()
end

S:AddCallback("mUIMerchantFrame", LoadSkin)
