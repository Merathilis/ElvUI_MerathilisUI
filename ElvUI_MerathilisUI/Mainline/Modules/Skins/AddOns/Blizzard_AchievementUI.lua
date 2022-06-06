local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
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

	if not _G.AchievementFrame.backdrop then
		_G.AchievementFrame:CreateBackdrop('Transparent')
		_G.AchievementFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(_G.AchievementFrame)

	-- Hide the ElvUI default backdrop
	if _G.AchievementFrameCategoriesContainer.backdrop then
		_G.AchievementFrameCategoriesContainer.backdrop:Hide()
	end

	for i = 1, 7 do
		local bu = _G["AchievementFrameAchievementsContainerButton"..i]
		if bu.backdrop then
			module:CreateGradient(bu.backdrop)
		end
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

	for i = 1, 12 do
		local label = _G["AchievementFrameSummaryCategoriesCategory"..i.."Label"]

		label:SetTextColor(1, 1, 1)
	end

	_G.AchievementFrameSummaryCategoriesStatusBarTitle:SetTextColor(1, 1, 1)

	_G.AchievementFrame.searchBox:ClearAllPoints()
	_G.AchievementFrame.searchBox:SetPoint("BOTTOMRIGHT", _G.AchievementFrameAchievementsContainer, "TOPRIGHT", -2, -2)
	_G.AchievementFrame.searchBox:SetSize(100, 20)
end

S:AddCallbackForAddon("Blizzard_AchievementUI", LoadSkin)
