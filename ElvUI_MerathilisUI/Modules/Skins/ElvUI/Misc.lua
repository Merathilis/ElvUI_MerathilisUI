local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

-- Credit for the Class logos: ADDOriN @DevianArt
-- http://addorin.deviantart.com/gallery/43689290/World-of-Warcraft-Class-Logos

function module:ElvUI_Misc()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local ElvUI_MinimapClusterBackdrop = _G.ElvUI_MinimapClusterBackdrop
	if ElvUI_MinimapClusterBackdrop then
		ElvUI_MinimapClusterBackdrop:SetTemplate("Transparent")
		module:CreateBackdropShadow(ElvUI_MinimapClusterBackdrop)
	end

	if _G.PluginInstallFrame then
		module:CreateShadow(_G.PluginInstallFrame)
	end

	if _G.PluginInstallTitleFrame then
		module:CreateShadow(_G.PluginInstallTitleFrame)

		if not _G.PluginInstallTitleFrame.ClassIcon then
			_G.PluginInstallTitleFrame.ClassIcon = _G.PluginInstallTitleFrame:CreateTexture(nil, "OVERLAY")
			_G.PluginInstallTitleFrame.ClassIcon:SetTexture(
				I.General.MediaPath .. "Textures\\ClassBanner\\CLASS-" .. E.myclass
			)
			_G.PluginInstallTitleFrame.ClassIcon:SetAlpha(0.75)
			_G.PluginInstallTitleFrame.ClassIcon:Size(128)
			_G.PluginInstallTitleFrame.ClassIcon:SetPoint("BOTTOM", _G.PluginInstallTitleFrame, "BOTTOM", 0, 25)
		end
	end
end

module:AddCallback("ElvUI_Misc")
