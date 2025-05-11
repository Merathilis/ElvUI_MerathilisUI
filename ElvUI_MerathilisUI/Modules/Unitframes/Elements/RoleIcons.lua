local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")

local RoleIconTextures = {
	SUNUI = {
		TANK = I.Media.RoleIcons.SunUITank,
		HEALER = I.Media.RoleIcons.SunUIHealer,
		DAMAGER = I.Media.RoleIcons.SunUIDPS,
	},
	SVUI = {
		TANK = I.Media.RoleIcons.SVUITank,
		HEALER = I.Media.RoleIcons.SVUIHealer,
		DAMAGER = I.Media.RoleIcons.SVUIDPS,
	},
	LYNUI = {
		TANK = I.Media.RoleIcons.LynUITank,
		HEALER = I.Media.RoleIcons.LynUIHealer,
		DAMAGER = I.Media.RoleIcons.LynUIDPS,
	},
	DEFAULT = {
		TANK = E.Media.Textures.Tank,
		HEALER = E.Media.Textures.Healer,
		DAMAGER = E.Media.Textures.DPS,
	},
	CUSTOM = {
		TANK = I.Media.RoleIcons.CustomTank,
		HEALER = I.Media.RoleIcons.CustomHealer,
		DAMAGER = I.Media.RoleIcons.CustomDPS,
	},
	GLOW = {
		TANK = I.Media.RoleIcons.GlowTank,
		HEALER = I.Media.RoleIcons.GlowHealer,
		DAMAGER = I.Media.RoleIcons.GlowDPS,
	},
	GRAVED = {
		TANK = I.Media.RoleIcons.GravedTank,
		HEALER = I.Media.RoleIcons.GravedHealer,
		DAMAGER = I.Media.RoleIcons.GravedDPS,
	},
	MAIN = {
		TANK = I.Media.RoleIcons.MainTank,
		HEALER = I.Media.RoleIcons.MainHealer,
		DAMAGER = I.Media.RoleIcons.MainDPS,
	},
	WHITE = {
		TANK = I.Media.RoleIcons.WhiteTank,
		HEALER = I.Media.RoleIcons.WhiteHealer,
		DAMAGER = I.Media.RoleIcons.WhiteDPS,
	},
	MATERIAL = {
		TANK = I.Media.RoleIcons.MaterialTank,
		HEALER = I.Media.RoleIcons.MaterialHealer,
		DAMAGER = I.Media.RoleIcons.MaterialDPS,
	},
	ElvUIOld = {
		TANK = I.Media.RoleIcons.ElvUITank,
		HEALER = I.Media.RoleIcons.ElvUIHealer,
		DAMAGER = I.Media.RoleIcons.ElvUIDPS,
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
