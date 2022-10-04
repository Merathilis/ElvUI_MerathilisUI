local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = MER:GetModule('MER_Skins')

function S:ElvUI_MinimapPanels()
	if not (E.private.mui.skins.shadow.enable) then
		return
	end

	self:CreateShadow(_G.MinimapPanel)
	MinimapPanel:Styling()
end

S:AddCallback("ElvUI_MinimapPanels")
