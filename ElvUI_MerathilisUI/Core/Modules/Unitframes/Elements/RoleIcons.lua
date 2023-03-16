local MER, F, E, L, V, P, G = unpack((select(2, ...)))
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
	CUSTOM = {
		TANK = MER.Media.Textures.customTank,
		HEALER = MER.Media.Textures.customHeal,
		DAMAGER = MER.Media.Textures.customDPS
	},
	GLOW = {
		TANK = MER.Media.Textures.glowTank,
		HEALER = MER.Media.Textures.glowHeal,
		DAMAGER = MER.Media.Textures.glowDPS
	},
	GLOW1 = {
		TANK = MER.Media.Textures.glow1Tank,
		HEALER = MER.Media.Textures.glow1Heal,
		DAMAGER = MER.Media.Textures.glow1DPS
	},
	GRAVED = {
		TANK = MER.Media.Textures.gravedTank,
		HEALER = MER.Media.Textures.gravedHeal,
		DAMAGER = MER.Media.Textures.gravedDPS
	},
	MAIN = {
		TANK = MER.Media.Textures.mainTank,
		HEALER = MER.Media.Textures.mainHeal,
		DAMAGER = MER.Media.Textures.mainDPS
	},
	WHITE = {
		TANK = MER.Media.Textures.whiteTank,
		HEALER = MER.Media.Textures.whiteHeal,
		DAMAGER = MER.Media.Textures.whiteDPS
	},
	MATERIAL = {
		TANK = MER.Media.Textures.materialTank,
		HEALER = MER.Media.Textures.materialHeal,
		DAMAGER = MER.Media.Textures.materialDPS
	}
}

function module:Configure_RoleIcons()
	self.db = E.db.mui.unitframes.roleIcons
	if not self.db or not self.db.enable then
		return
	end

	local pack = self.db.enable and self.db.roleIconStyle or "DEFAULT"
	UF.RoleIconTextures = RoleIconTextures[pack]
end
