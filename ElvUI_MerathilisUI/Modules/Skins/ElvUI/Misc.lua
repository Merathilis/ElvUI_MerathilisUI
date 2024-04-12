local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G

function module:ElvUI_Misc()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local ElvUI_MinimapClusterBackdrop = _G.ElvUI_MinimapClusterBackdrop
	if ElvUI_MinimapClusterBackdrop then
		ElvUI_MinimapClusterBackdrop:SetTemplate("Transparent")
		module:CreateBackdropShadow(ElvUI_MinimapClusterBackdrop)
	end

	if PluginInstallFrame then
		module:CreateShadow(PluginInstallFrame)
	end

	if PluginInstallTitleFrame then
		module:CreateShadow(PluginInstallTitleFrame)
	end
end

module:AddCallback("ElvUI_Misc")
