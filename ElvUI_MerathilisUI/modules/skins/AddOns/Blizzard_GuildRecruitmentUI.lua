local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleGuildRecruitment()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guild ~= true then return end

	local rolesFrame = _G.CommunitiesGuildRecruitmentFrameRecruitment.RolesFrame
	MER:ReskinRole(rolesFrame.TankButton, "TANK")
	MER:ReskinRole(rolesFrame.HealerButton, "HEALER")
	MER:ReskinRole(rolesFrame.DamagerButton, "DPS")
end

S:AddCallbackForAddon("Blizzard_GuildRecruitmentUI", "mUIGuildRecruitment", styleGuildRecruitment)
