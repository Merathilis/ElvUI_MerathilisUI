local MER, E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule('UnitFrames')
local COMP = MER:GetModule("mUICompatibility")

--Cache global variables
--Lua Variables
--WoW API / Variables
-- GLOBALS:

UF.RoleIconTextures = {
	TANK = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Tank.tga]],
	HEALER = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Healer.tga]],
	DAMAGER = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Dps.tga]]
}
