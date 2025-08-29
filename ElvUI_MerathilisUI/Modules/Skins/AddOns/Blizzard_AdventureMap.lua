local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_AdventureMap()
	if not module:CheckDB("garrison", "garrison") then
		return
	end

	local AdventureMapQuestChoiceDialog = _G["AdventureMapQuestChoiceDialog"]
	AdventureMapQuestChoiceDialog.Rewards:SetAlpha(0)
	AdventureMapQuestChoiceDialog.Background:Hide()

	AdventureMapQuestChoiceDialog.CloseButton:SetPoint("TOPRIGHT", -5, -5)
	AdventureMapQuestChoiceDialog.DeclineButton:SetPoint("BOTTOMRIGHT", -5, 5)
	AdventureMapQuestChoiceDialog.AcceptButton:SetPoint("BOTTOMLEFT", 5, 5)

	module:CreateShadow(AdventureMapQuestChoiceDialog)
end

module:AddCallbackForAddon("Blizzard_AdventureMap")
