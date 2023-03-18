local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("barber", "barber") then
		return
	end

	local BarberShopFrame = _G.BarberShopFrame
	BarberShopFrame:Styling()
	module:CreateShadow(BarberShopFrame)
end

S:AddCallbackForAddon("Blizzard_BarbershopUI", LoadSkin)
