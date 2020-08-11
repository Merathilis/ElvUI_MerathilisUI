local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

local _G = _G
local pairs = pairs


local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.weeklyRewards) then return end

	-- /run UIParent_OnEvent({}, "WEEKLY_REWARDS_SHOW")
	local frame = _G.WeeklyRewardsFrame
	local header = frame.HeaderFrame

	frame:StripTextures()
	header:StripTextures()

	if frame.backdrop then
		frame.backdrop:Styling()
	end
end

S:AddCallbackForAddon('Blizzard_WeeklyRewards', 'muiWeeklyRewards', LoadSkin)
