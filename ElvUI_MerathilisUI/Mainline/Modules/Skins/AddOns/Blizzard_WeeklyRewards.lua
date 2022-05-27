local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_WeeklyRewards()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.weeklyRewards) then return end

	-- /run UIParent_OnEvent({}, "WEEKLY_REWARDS_SHOW")
	local frame = _G.WeeklyRewardsFrame
	local header = frame.HeaderFrame

	frame:StripTextures()
	header:StripTextures()

	if not frame.backdrop then
		frame:CreateBackdrop('Transparent')
	end

	if not header.backdrop then
		header:CreateBackdrop('Transparent')
	end

	frame.backdrop:Styling()
	MER:CreateBackdropShadow(frame)
end

module:AddCallbackForAddon('Blizzard_WeeklyRewards')
