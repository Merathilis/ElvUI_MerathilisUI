local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if not module:CheckDB("merchant", "merchant") then
		return
	end

	local MerchantFrame = _G.MerchantFrame
	MerchantFrame:Styling()
end

S:AddCallback("MerchantFrame", LoadSkin)
