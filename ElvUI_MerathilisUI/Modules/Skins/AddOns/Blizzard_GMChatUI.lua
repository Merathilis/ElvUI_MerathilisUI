local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_GMChatUI()
	if not module:CheckDB("gmChat", "GMChat") then
		return
	end

	module:CreateBackdropShadow(_G.GMChatFrame)
	module:CreateBackdropShadow(_G.GMChatTab)
end

module:AddCallbackForAddon("Blizzard_GMChatUI")
