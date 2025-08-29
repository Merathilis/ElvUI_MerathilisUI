local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local pairs = pairs

local C_AzeriteEssence_CanOpenUI = C_AzeriteEssence.CanOpenUI

local function updateEssenceButton(button)
	if not button.backdrop then
		button:CreateBackdrop("Transparent")
		button.backdrop:SetPoint("TOPLEFT", 1, 0)
		button.backdrop:SetPoint("BOTTOMRIGHT", 0, 2)

		if button.Icon then
			S:HandleIcon(button.Icon)
			button.PendingGlow:SetTexture("")

			local hl = button:GetHighlightTexture()
			hl:SetColorTexture(F.r, F.g, F.b, 0.25)
			hl:SetInside(button.backdrop)
			button.Background:SetAlpha(0)
		end
		if button.ExpandedIcon then
			button:DisableDrawLayer("BACKGROUND")
			button:DisableDrawLayer("BORDER")
		end
	end

	if button:IsShown() then
		if button.PendingGlow and button.PendingGlow:IsShown() then
			button.backdrop:SetBackdropBorderColor(1, 0.8, 0)
		else
			button.backdrop:SetBackdropBorderColor(0, 0, 0)
		end
	end
end

function module:Blizzard_AzeriteEssenceUI()
	if not module:CheckDB("azeriteEssence", "AzeriteEssence") then
		return
	end

	if not C_AzeriteEssence_CanOpenUI() then
		return
	end

	local AzeriteEssenceUI = _G.AzeriteEssenceUI
	module:CreateBackdropShadow(AzeriteEssenceUI)

	for _, milestoneFrame in pairs(AzeriteEssenceUI.Milestones) do
		if milestoneFrame.LockedState then
			milestoneFrame.LockedState.UnlockLevelText:SetTextColor(0.6, 0.8, 1)
			milestoneFrame.LockedState.UnlockLevelText.SetTextColor = E.dummy
		end
	end

	hooksecurefunc(AzeriteEssenceUI.EssenceList.ScrollBox, "Update", function(self)
		self:ForEachFrame(updateEssenceButton)
	end)
end

module:AddCallbackForAddon("Blizzard_AzeriteEssenceUI")
