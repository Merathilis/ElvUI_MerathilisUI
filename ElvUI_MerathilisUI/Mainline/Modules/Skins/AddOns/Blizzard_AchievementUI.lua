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
