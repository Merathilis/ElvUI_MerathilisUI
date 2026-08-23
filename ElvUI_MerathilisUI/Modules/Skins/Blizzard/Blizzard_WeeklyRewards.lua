local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_WeeklyRewards()
	local frame = _G.WeeklyRewardsFrame

	print("WeeklyRewardsFrame loaded")
end

module:AddCallbackForAddon("Blizzard_WeeklyRewards")
