local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local select = select

local GetAchievementInfo = GetAchievementInfo
local GetAchievementNumCriteria = GetAchievementNumCriteria
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not module:CheckDB("achievement", "achievement") then
		return
	end

	local AchievementFrame = _G.AchievementFrame
	AchievementFrame:Styling()
	module:CreateShadow(AchievementFrame)

	for i = 1, 3 do
		local tab = _G["AchievementFrameTab"..i]
		module:ReskinTab(tab)
	end

	for i = 1, 7 do
		local bu = _G["AchievementFrameAchievementsContainerButton"..i]
		if bu then
			module:CreateGradient(bu)
		end
	end

	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
		for i = 1, _G.ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
			local bu = _G["AchievementFrameSummaryAchievement"..i]
			if not bu.reskinned then
				if bu.backdrop then
					module:CreateGradient(bu.backdrop)
				end
				bu.reskinned = true
			end
		end
	end)

	hooksecurefunc(_G.AchievementFrameCategories.ScrollBox, 'Update', function(frame)
		for _, child in next, { frame.ScrollTarget:GetChildren() } do
			local button = child.Button
			if button and not button.IsSkinned then
				if button.backdrop then
					module:CreateGradient(button.backdrop)
				end
				button.IsSkinned = true
			end
		end
	end)

	hooksecurefunc(_G.AchievementFrameAchievements.ScrollBox, 'Update', function(frame)
		for _, child in next, { frame.ScrollTarget:GetChildren() } do
			if not child.IsSkinned then
				if child.backdrop then
					module:CreateGradient(child.backdrop)
				end
				child.IsSkinned = true
			end
		end
	end)

end

S:AddCallbackForAddon("Blizzard_AchievementUI", LoadSkin)
