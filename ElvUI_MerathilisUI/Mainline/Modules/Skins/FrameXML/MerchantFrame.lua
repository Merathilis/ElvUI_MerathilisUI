local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:MerchantFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.merchant ~= true or E.private.mui.skins.blizzard.merchant ~= true then return end

	local MerchantFrame = _G.MerchantFrame
	MerchantFrame:Styling()
end

module:AddCallback("MerchantFrame")
