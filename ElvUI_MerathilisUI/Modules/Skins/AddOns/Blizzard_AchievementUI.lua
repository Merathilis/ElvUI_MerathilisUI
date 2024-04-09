local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc

local function SetupButtonHighlight(button)
	button:SetHighlightTexture(E.media.normTex)

	local hl = button:GetHighlightTexture()
	hl:SetVertexColor(F.r, F.g, F.b, 0.25)
	hl:SetInside(button)
end

function module:Blizzard_AchievementUI()
	if not module:CheckDB("achievement", "achievement") then
		return
	end

	local AchievementFrame = _G.AchievementFrame
	module:CreateShadow(AchievementFrame)

	for i = 1, 3 do
		local tab = _G["AchievementFrameTab" .. i]
		module:ReskinTab(tab)
	end

	for i = 1, 7 do
		local bu = _G["AchievementFrameAchievementsContainerButton" .. i]
		if bu then
			module:CreateGradient(bu)
		end
	end

	hooksecurefunc(_G.AchievementFrameCategories.ScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			local bu = child.Button
			if bu and not bu.IsSkinned then
				bu.Background:Hide()
				bu:CreateBackdrop("Transparent")
				bu.backdrop:SetPoint("TOPLEFT", 0, -1)
				bu.backdrop:SetPoint("BOTTOMRIGHT")
				module:CreateGradient(bu.backdrop)
				SetupButtonHighlight(bu)

				bu.IsSkinned = true
			end
		end
	end)

	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
		for i = 1, _G.ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
			local button = _G["AchievementFrameSummaryAchievement" .. i]
			if button and not button.IsSkinned then
				button:CreateBackdrop("Transparent")
				button.backdrop:SetAllPoints()
				module:CreateGradient(button.backdrop)

				button.IsSkinned = true
			end
		end
	end)

	hooksecurefunc(_G.AchievementFrameCategories.ScrollBox, "Update", function(frame)
		for _, child in next, { frame.ScrollTarget:GetChildren() } do
			local button = child.Button
			if button and not button.IsSkinned then
				button:CreateBackdrop("Transparent")
				button.backdrop:SetAllPoints()
				module:CreateGradient(button.backdrop)

				button.IsSkinned = true
			end
		end
	end)

	hooksecurefunc(_G.AchievementFrameAchievements.ScrollBox, "Update", function(frame)
		for _, child in next, { frame.ScrollTarget:GetChildren() } do
			if child and not child.IsSkinned then
				child:CreateBackdrop("Transparent")
				child.backdrop:SetAllPoints()
				module:CreateGradient(child.backdrop)

				child.IsSkinned = true
			end
		end
	end)
end

module:AddCallbackForAddon("Blizzard_AchievementUI")
