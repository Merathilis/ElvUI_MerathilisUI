local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

local function styleArtifact()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.artifact ~= true or E.private.muiSkins.blizzard.artifact ~= true then return end

	MERS:CreateGradient(ArtifactFrame)
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

	ArtifactFrame.AppearancesTab:HookScript("OnShow", function(self)
		if self.skinned then return end
		for i = 1, self:GetNumChildren() do
			local child = select(i, self:GetChildren())
			if child and child.appearanceID and not child.backdrop then
				child:CreateBackdrop("Transparent")
				MERS:CreateGradient(child.backdrop)
				child.SwatchTexture:SetTexCoord(.20, .80, .20, .80)
				child.SwatchTexture:SetInside(child)
				child.Border:SetAlpha(0)
				child.Background:SetAlpha(0)
				child.HighlightTexture:SetAlpha(0)
				child.HighlightTexture.SetAlpha = E.noop
				if child.Selected:IsShown() then
					child.backdrop:SetBackdropBorderColor(1, 1, 1)
				end
				child.Selected:SetAlpha(0)
				child.Selected.SetAlpha = E.noop
				hooksecurefunc(child.Selected, "SetShown", function(self, isActive)
					if isActive then
						child.backdrop:SetBackdropBorderColor(1, 1, 1)
					else
						child.backdrop:SetBackdropBorderColor(0, 0, 0)
					end
				end)
			elseif child and child.DescriptionTooltipArea and not child.backdrop then
				child:StripTextures()
				child.Name:SetTextColor(1, 1, 1)
				child:CreateBackdrop("Transparent")
				child.backdrop:SetBackdropColor(0, 0, 0, 1/2)
				local point, anchor, secondaryPoint, x, y = child:GetPoint()
				child:SetPoint(point, anchor, secondaryPoint, x, y+2)
				hooksecurefunc(child, "SetPoint", function(self, point, anchor, secondaryPoint, x, y)
					if y == -80 or y == 0 then -- Blizz sets these two, maybe not best way for this but eh.
						self:SetPoint(point, anchor, secondaryPoint, x, y+2)
						if not E.PixelMode then
							child.backdrop:Point('TOPLEFT', child, 'TOPLEFT', -E.Border+2, E.Border-3)
							child.backdrop:Point('BOTTOMRIGHT', child, 'BOTTOMRIGHT', E.Border-2, E.Border+3)
						end
					end
				end)
			end
		end
		self.skinned = true
	end)
end

S:AddCallbackForAddon("Blizzard_ArtifactUI", "mUIArtifact", styleArtifact)