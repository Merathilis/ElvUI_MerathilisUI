local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_GuildRecruitmentUI()
	if not module:CheckDB("guild", "guild") then
		return
	end

	local rolesFrame = _G.CommunitiesGuildRecruitmentFrameRecruitment.RolesFrame
	F.ReskinRole(rolesFrame.TankButton, "TANK")
	F.ReskinRole(rolesFrame.HealerButton, "HEALER")
	F.ReskinRole(rolesFrame.DamagerButton, "DPS")
end

module:AddCallbackForAddon("Blizzard_GuildRecruitmentUI")
