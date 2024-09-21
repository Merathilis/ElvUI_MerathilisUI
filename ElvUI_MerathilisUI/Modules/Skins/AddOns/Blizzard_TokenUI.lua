local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_TokenUI()
	if not self:CheckDB("character") then
		return
	end

	module:CreateShadow(_G.CurrencyTransferLog)
	module:CreateShadow(_G.CurrencyTransferMenu)
end

module:AddCallbackForAddon("Blizzard_TokenUI")
