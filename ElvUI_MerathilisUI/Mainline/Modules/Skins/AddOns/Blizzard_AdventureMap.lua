local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_AdventureMap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.skins.blizzard.garrison ~= true or E.private.mui.skins.blizzard.garrison ~= true then return end

	local AdventureMapQuestChoiceDialog = _G["AdventureMapQuestChoiceDialog"]
	AdventureMapQuestChoiceDialog.Rewards:SetAlpha(0)
	AdventureMapQuestChoiceDialog.Background:Hide()

	AdventureMapQuestChoiceDialog.CloseButton:SetPoint("TOPRIGHT", -5, -5)
	AdventureMapQuestChoiceDialog.DeclineButton:SetPoint("BOTTOMRIGHT", -5, 5)
	AdventureMapQuestChoiceDialog.AcceptButton:SetPoint("BOTTOMLEFT", 5, 5)
end

module:AddCallbackForAddon("Blizzard_AdventureMap")
