local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

function module:RaidUtility()
	if not E.private.mui.skins.enable or not E.private.general.raidUtility then
		return
	end

	local frames = {
		_G.RaidUtilityPanel,
		_G.RaidUtility_ShowButton,
		_G.RaidUtility_CloseButton,
		_G.RaidUtilityRoleIcons,
		_G.RaidUtilityTargetIcons,
	}

	for _, frame in pairs(frames) do
		module:CreateShadow(frame)
	end
end

module:AddCallback("RaidUtility")
