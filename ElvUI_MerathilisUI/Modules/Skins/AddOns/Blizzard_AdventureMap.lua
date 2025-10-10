local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_AdventureMap()
	if not module:CheckDB("garrison", "garrison") then
		return
	end

	local AdventureMapQuestChoiceDialog = _G.AdventureMapQuestChoiceDialog
	AdventureMapQuestChoiceDialog.Rewards:SetAlpha(0)
	AdventureMapQuestChoiceDialog.Background:Hide()

	AdventureMapQuestChoiceDialog.CloseButton:SetPoint("TOPRIGHT", -5, -5)
	AdventureMapQuestChoiceDialog.DeclineButton:SetPoint("BOTTOMRIGHT", -5, 5)
	AdventureMapQuestChoiceDialog.AcceptButton:SetPoint("BOTTOMLEFT", 5, 5)

	module:CreateShadow(AdventureMapQuestChoiceDialog)

	hooksecurefunc(AdventureMapQuestChoiceDialog, "RefreshRewards", function()
		for reward in AdventureMapQuestChoiceDialog.rewardPool:EnumerateActive() do
			if not reward.__MERSkin then
				if reward.Icon then
					reward.Icon:CreateBackdrop()
					reward.Icon:SetTexCoord(unpack(E.TexCoords))
				end

				if reward.ItemNameBG then
					reward.ItemNameBG:SetAlpha(0)
					reward.MERItemNameBG = CreateFrame("Frame", nil, reward)
					module:Reposition(reward.MERItemNameBG, reward.ItemNameBG, 2, 0, 0, -3, -1)
					reward.MERItemNameBG:SetFrameLevel(reward:GetFrameLevel())
					reward.MERItemNameBG:SetTemplate("Transparent")
				end
				reward.__MERSkin = true
			end
		end
	end)
end

module:AddCallbackForAddon("Blizzard_AdventureMap")
