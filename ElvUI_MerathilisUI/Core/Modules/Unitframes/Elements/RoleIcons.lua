local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local UF = E:GetModule('UnitFrames')

function module:Configure_RoleIcons()
	if E.db.mui.unitframes.roleIcons ~= true then return end

	UF.RoleIconTextures = {
		TANK = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\Tank.tga]],
		HEALER = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\Healer.tga]],
		DAMAGER = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\Dps.tga]]
	}
end
