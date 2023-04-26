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
	AchievementFrame.backdrop:Styling()
	module:CreateBackdropShadow(AchievementFrame)

	-- Hide the ElvUI default backdrop
	if _G.AchievementFrameCategoriesContainer.backdrop then
		_G.AchievementFrameCategoriesContainer.backdrop:Hide()
	end

	for i = 1, 2 do
		module:ReskinTab(_G["AchievementFrameTab"..i])
	end

	hooksecurefunc("AchievementButton_DisplayAchievement", function(button, category, achievement)
		local _, _, _, completed = GetAchievementInfo(category, achievement)
		if completed then
			if button.accountWide then
				button.label:SetTextColor(0, .6, 1)
			else
				button.label:SetTextColor(.9, .9, .9)
			end
		else
			if button.accountWide then
				button.label:SetTextColor(0, .3, .5)
			else
				button.label:SetTextColor(.65, .65, .65)
			end
		end
	end)

	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(objectivesFrame, id)
		for i = 1, GetAchievementNumCriteria(id) do
			local name = _G["AchievementFrameCriteria"..i.."Name"]
			if name and select(2, name:GetTextColor()) == 0 then
				name:SetTextColor(1, 1, 1)
			end

			local bu = _G["AchievementFrameMeta"..i]
			if bu and select(2, bu.label:GetTextColor()) == 0 then
				bu.label:SetTextColor(1, 1, 1)
			end
		end
	end)

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
end

S:AddCallbackForAddon("Blizzard_AchievementUI", LoadSkin)
