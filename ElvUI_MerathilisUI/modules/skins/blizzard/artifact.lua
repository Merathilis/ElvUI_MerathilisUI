local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

local function styleArtifact()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.artifact ~= true or E.private.muiSkins.blizzard.artifact ~= true then return end

	if not ArtifactFrame.stripes then
		MERS:CreateStripes(ArtifactFrame)
	end

	ArtifactFrame.Background:Hide()
	ArtifactFrame.PerksTab.HeaderBackground:Hide()
	ArtifactFrame.PerksTab.BackgroundBack:Hide()
	ArtifactFrame.PerksTab.TitleContainer.Background:SetAlpha(0)
	ArtifactFrame.PerksTab.Model.BackgroundFront:Hide()
	ArtifactFrame.PerksTab.Model:SetAlpha(.2)
	ArtifactFrame.PerksTab.AltModel:SetAlpha(.2)
	ArtifactFrame.BorderFrame:Hide()
    ArtifactFrame.ForgeBadgeFrame.ItemIcon:Hide()
    ArtifactFrame.ForgeBadgeFrame.ForgeLevelBackground:ClearAllPoints()
	ArtifactFrame.ForgeBadgeFrame.ForgeLevelBackground:SetPoint("TOPLEFT", ArtifactFrame)
	ArtifactFrame.AppearancesTab.Background:Hide()

	-- Works almost -.-
	ArtifactFrame.AppearancesTab:HookScript("OnShow", function()
		for i = 1, 24 do
			local bu = select(i, ArtifactFrame.AppearancesTab:GetChildren())
			if bu then
				bu.Background:Hide()
				if bu:GetWidth() > 400 then
					MERS:CreateGradient(bu)
					MERS:CreateBD(bu, 0)
					bu.Name:SetTextColor(1, 1, 1)
				else
					bu.Border:SetAlpha(0)
					bu.HighlightTexture:Hide()
					bu.Selected:SetAlpha(1)
					bu.Selected.SetAlpha = MER.dummy
				end
			end
		end
	end)

	hooksecurefunc(ArtifactFrame.AppearancesTab, "Refresh", function()
		for i = 1, 24 do
			local bu = select(i, ArtifactFrame.AppearancesTab:GetChildren())
			if bu and bu.bg then
				if bu.Selected:IsShown() then
					bu.bg:SetBackdropBorderColor(1, 1, 0)
				else
					bu.bg:SetBackdropBorderColor(0, 0, 0)
				end
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_ArtifactUI", "mUIArtifact", styleArtifact)