local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_BattlefieldMap()
	if not self:CheckDB("bgmap", "battlefieldMap") then
		return
	end

	self:CreateBackdropShadow(_G.BattlefieldMapFrame)
	self:CreateBackdropShadow(_G.BattlefieldMapTab)
end

module:AddCallbackForAddon("Blizzard_BattlefieldMap")
