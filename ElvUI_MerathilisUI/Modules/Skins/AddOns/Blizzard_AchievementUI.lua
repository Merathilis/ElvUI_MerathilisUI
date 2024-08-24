local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_AchievementUI()
	if not module:CheckDB("achievement", "achievement") then
		return
	end

	local AchievementFrame = _G.AchievementFrame
	module:CreateShadow(AchievementFrame)
	module:CreateBackdropShadow(_G.AchievementFrameComparisonHeader)

	for i = 1, 3 do
		local tab = _G["AchievementFrameTab" .. i]
		module:ReskinTab(tab)
	end

	module:CreateBackdropShadow(_G.AchievementFrame.SearchPreviewContainer)
	module:CreateBackdropShadow(_G.AchievementFrame.SearchResults)
end

module:AddCallbackForAddon("Blizzard_AchievementUI")
