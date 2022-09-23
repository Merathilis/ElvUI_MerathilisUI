local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')

local function GradientColorClass(class)
	if class ~= nil then
		return F.ClassGradient[class].r1 - 0.2, F.ClassGradient[class].g1 - 0.2,
			F.ClassGradient[class].b1 - 0.2, 0.9, F.ClassGradient[class].r2 + 0.2,
			F.ClassGradient[class].g2 + 0.2, F.ClassGradient[class].b2 + 0.2, 0.9
	end
end

local function GradientBars()
	local class
	hooksecurefunc(_detalhes, "InstanceRefreshRows", function(instancia)
		if instancia.barras and instancia.barras[1] then
			for _, row in next, instancia.barras do
				if row and row.textura then
					hooksecurefunc(row.textura, "SetVertexColor", function(_, r, g, b)
						-- row.textura:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\StatusBars\\Line4pixel")
						if row.minha_tabela and row.minha_tabela.name then
							class = row.minha_tabela:class()
							if class ~= 'UNKNOW' then
								row.textura:SetGradientAlpha("Horizontal", GradientColorClass(class))
							else
								row.textura:SetGradientAlpha("Horizontal", r - 0.5, g - 0.5, b - 0.5, 0.9, r + 0.2, g + 0.2, b + 0.2, 0.9)
							end
						end
					end)
				end
			end
		end
	end)
end

local function LoadSkin()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.dt then
		return
	end

	GradientBars()
end

module:AddCallbackForAddon('Details', LoadSkin)
