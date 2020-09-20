local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local UF = E:GetModule('UnitFrames')

--Cache global variables
--Lua Variables
--WoW API / Variables
-- GLOBALS:

function module:Configure_RoleIcons()
	if E.db.mui.unitframes.roleIcons ~= true then return end

	UF.RoleIconTextures = {
		TANK = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Tank.tga]],
		HEALER = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Healer.tga]],
		DAMAGER = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Dps.tga]]
	}
end
