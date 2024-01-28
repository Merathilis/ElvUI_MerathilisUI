local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

function module:Blizzard_GMChatUI()
	if not module:CheckDB("gmChat", "GMChat") then
		return
	end

	module:CreateBackdropShadow(_G.GMChatFrame)
	module:CreateBackdropShadow(_G.GMChatTab)
end

module:AddCallbackForAddon("Blizzard_GMChatUI")
