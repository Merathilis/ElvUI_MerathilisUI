local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("weeklyRewards", "weeklyRewards") then
		return
	end

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
	module:CreateBackdropShadow(frame)
end

S:AddCallbackForAddon('Blizzard_WeeklyRewards', LoadSkin)
