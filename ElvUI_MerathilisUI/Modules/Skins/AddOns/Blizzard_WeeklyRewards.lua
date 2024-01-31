local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_WeeklyRewards()
	if not module:CheckDB("weeklyRewards", "weeklyRewards") then
		return
	end

	-- /run UIParent_OnEvent({}, "WEEKLY_REWARDS_SHOW")
	local frame = _G.WeeklyRewardsFrame
	local header = frame.HeaderFrame

	frame:StripTextures()
	frame.NineSlice:Kill()
	frame.BackgroundTile:SetAlpha(0)
	module:CreateShadow(frame)

	header:StripTextures()
	header.Left:SetAlpha(0)
	header.Right:SetAlpha(0)
	header.Middle:SetAlpha(0)
	header:SetTemplate('Transparent')
end

module:AddCallbackForAddon('Blizzard_WeeklyRewards')
