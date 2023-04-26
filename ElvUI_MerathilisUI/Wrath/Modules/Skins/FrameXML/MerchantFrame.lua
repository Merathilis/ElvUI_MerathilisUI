local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local select = select

local function LoadSkin()
	if not module:CheckDB("merchant", "merchant") then
		return
	end

	local MerchantFrame = _G.MerchantFrame
	MerchantFrame:Styling()
	module:CreateShadow(MerchantFrame)
end

S:AddCallback("MerchantFrame", LoadSkin)
