local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local UF = E:GetModule('UnitFrames')

local RoleIconTextures = {
	SUNUI = {
		TANK = MER.Media.Textures.sunTank,
		HEALER = MER.Media.Textures.sunHealer,
		DAMAGER = MER.Media.Textures.sunDPS
	},
	SVUI = {
		TANK = MER.Media.Textures.svuiTank,
		HEALER = MER.Media.Textures.svuiHealer,
		DAMAGER = MER.Media.Textures.svuiDPS
	},
	LYNUI = {
		TANK = MER.Media.Textures.lynTank,
		HEALER = MER.Media.Textures.lynHealer,
		DAMAGER = MER.Media.Textures.lynDPS
	},
	DEFAULT = {
		TANK = E.Media.Textures.Tank,
		HEALER = E.Media.Textures.Healer,
		DAMAGER = E.Media.Textures.DPS
	},
}

function module:Configure_RoleIcons()
	self.db = E.db.mui.unitframes.roleIcons
	if not self.db or not self.db.enable then
		return
	end

	local pack = self.db.enable and self.db.roleIconStyle or "DEFAULT"
	UF.RoleIconTextures = RoleIconTextures[pack]
end
