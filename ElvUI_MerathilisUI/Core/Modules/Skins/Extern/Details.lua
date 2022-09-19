local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')

local function LoadSkin()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.dt then
		return
	end

	hooksecurefunc(_G.Details, "InstanceRefreshRows", function(instancia)
		if instancia.barras then
			for _, row in ipairs(instancia.barras) do
				if row and row.textura then
					hooksecurefunc(row.textura, "SetVertexColor", function(_, r, g, b)
						row.textura:SetTexture("Interface\\Addons\\ElvUI_MerathilisUI\\Core\\Media\\StatusBars\\Line7pixel")
						row.textura:SetGradientAlpha("Horizontal", r-0.5, g-0.5, b-0.5, 0.9, r+0.2, g+0.2, b+0.2, 0.9)
					end)
				end
			end
		end
	end)
end

module:AddCallbackForAddon('Details', LoadSkin)
