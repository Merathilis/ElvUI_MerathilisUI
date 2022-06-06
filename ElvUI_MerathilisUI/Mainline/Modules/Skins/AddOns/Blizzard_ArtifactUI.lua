local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local select = select
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not module:CheckDB("artifact", "artifact") then
		return
	end

	local ArtifactFrame = _G.ArtifactFrame
	ArtifactFrame:Styling()
	MER:CreateBackdropShadow(_G.ArtifactFrame)

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
	ArtifactFrame.ForgeBadgeFrame.ForgeLevelBackground:SetPoint("TOPLEFT", _G["ArtifactFrame"])
	ArtifactFrame.AppearancesTab.Background:Hide()

	ArtifactFrame.AppearancesTab:HookScript("OnShow", function(self)
		for i = 1, self:GetNumChildren() do
			local child = select(i, self:GetChildren())
			if child and child.appearanceID and not child.backdrop then
				child:CreateBackdrop("Transparent")
				child.backdrop:Styling()
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
	end)
end

S:AddCallbackForAddon("Blizzard_ArtifactUI", LoadSkin)
