local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
local select = select
local hooksecurefunc = hooksecurefunc
--WoW API / Variables

local function styleArtifact()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.artifact ~= true or E.private.muiSkins.blizzard.artifact ~= true then return end

	_G.ArtifactFrame:Styling()

	_G.ArtifactFrame.Background:Hide()
	_G.ArtifactFrame.PerksTab.HeaderBackground:Hide()
	_G.ArtifactFrame.PerksTab.BackgroundBack:Hide()
	_G.ArtifactFrame.PerksTab.TitleContainer.Background:SetAlpha(0)
	_G.ArtifactFrame.PerksTab.Model.BackgroundFront:Hide()
	_G.ArtifactFrame.PerksTab.Model:SetAlpha(.2)
	_G.ArtifactFrame.PerksTab.AltModel:SetAlpha(.2)
	_G.ArtifactFrame.BorderFrame:Hide()
	_G.ArtifactFrame.ForgeBadgeFrame.ItemIcon:Hide()
	_G.ArtifactFrame.ForgeBadgeFrame.ForgeLevelBackground:ClearAllPoints()
	_G.ArtifactFrame.ForgeBadgeFrame.ForgeLevelBackground:SetPoint("TOPLEFT", _G["ArtifactFrame"])
	_G.ArtifactFrame.AppearancesTab.Background:Hide()

	_G.ArtifactFrame.AppearancesTab:HookScript("OnShow", function(self)
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

S:AddCallbackForAddon("Blizzard_ArtifactUI", "mUIArtifact", styleArtifact)
