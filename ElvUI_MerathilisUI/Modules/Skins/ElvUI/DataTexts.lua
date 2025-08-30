local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:ElvUI_MinimapPanels()
	if not E.private.mui.skins.shadow.enable then
		return
	end
end

module:AddCallback("ElvUI_MinimapPanels")
