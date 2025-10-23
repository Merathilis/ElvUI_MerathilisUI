local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_AdventureMap()
	if not module:CheckDB("garrison", "garrison") then
		return
	end

	local AdventureMapQuestChoiceDialog = _G.AdventureMapQuestChoiceDialog
	local childFrame = AdventureMapQuestChoiceDialog.Details.Child

	self:CreateBackdropShadow(AdventureMapQuestChoiceDialog)

	F.SetFont(childFrame.TitleHeader)
	F.SetFont(childFrame.DescriptionText)
	F.SetFont(childFrame.ObjectivesHeader)
	F.SetFont(childFrame.ObjectivesText)
	F.SetFont(AdventureMapQuestChoiceDialog.RewardsHeader)

	hooksecurefunc(AdventureMapQuestChoiceDialog, "RefreshRewards", function()
		for reward in AdventureMapQuestChoiceDialog.rewardPool:EnumerateActive() do
			if not reward.__MERSkin then
				reward.MERItemNameBG = CreateFrame("Frame", nil, reward)
				reward.MERItemNameBG:SetFrameLevel(reward:GetFrameLevel())
				reward.MERItemNameBG:SetTemplate("Transparent")
				module:Reposition(reward.MERItemNameBG, reward.ItemNameBG, 2, 0, -1, -3, -1)
				reward.__MERSkin = true
			end
		end
	end)
end

module:AddCallbackForAddon("Blizzard_AdventureMap")
