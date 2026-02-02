local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

function module:BagSync()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.bSync then
		return
	end
end

module:AddCallbackForAddon("BagSync")
