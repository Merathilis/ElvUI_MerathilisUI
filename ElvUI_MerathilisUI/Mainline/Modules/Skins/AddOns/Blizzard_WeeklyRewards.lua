local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
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

	header:SetTemplate('Transparent')

	frame:Styling()
	module:CreateShadow(frame)
end

S:AddCallbackForAddon('Blizzard_WeeklyRewards', LoadSkin)
