local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_WeeklyRewards()
	if not module:CheckDB("weeklyRewards", "weeklyRewards") then
		return
	end

	-- /run UIParent_OnEvent({}, "WEEKLY_REWARDS_SHOW")
	local frame = _G.WeeklyRewardsFrame
	local header = frame.HeaderFrame

	frame:StripTextures()
	if frame and not frame.backdrop then
		frame:CreateBackdrop("Transparent")
	end

	header:StripTextures()
	header:SetPoint("TOP", 1, -42)

	if _G.WeeklyRewardExpirationWarningDialog then
		module:CreateShadow(_G.WeeklyRewardExpirationWarningDialog.NineSlice)
	end
end

module:AddCallbackForAddon("Blizzard_WeeklyRewards")
