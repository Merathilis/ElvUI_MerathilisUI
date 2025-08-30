local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local MM = E:GetModule("Minimap")

local _G = _G

function module:ElvUI_MiniMap()
	if not E.private.mui.skins.enable then
		return
	end

	self:CreateBackdropShadow(_G.Minimap)
	self:CreateShadow(_G.MinimapRightClickMenu)
end

module:AddCallback("ElvUI_MiniMap")
