local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("guild", "guild") then
		return
	end

	local rolesFrame = _G.CommunitiesGuildRecruitmentFrameRecruitment.RolesFrame
	F.ReskinRole(rolesFrame.TankButton, "TANK")
	F.ReskinRole(rolesFrame.HealerButton, "HEALER")
	F.ReskinRole(rolesFrame.DamagerButton, "DPS")
end

S:AddCallbackForAddon("Blizzard_GuildRecruitmentUI", LoadSkin)
