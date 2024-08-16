local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

function module:ElvUI_mMediaTag()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.mmt then
		return
	end

	local teleportMenu = _G["mMediaTag_Teleports_Menu"]
	if teleportMenu then
		module:CreateShadow(teleportMenu)
	end
end

module:AddCallbackForAddon("ElvUI_mMediaTag")
