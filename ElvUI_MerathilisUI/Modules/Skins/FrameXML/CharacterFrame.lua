local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_UIPanels_Game()
	if not module:CheckDB("character", "character") then
		return
	end

	local CharacterFrame = _G.CharacterFrame

	module:CreateShadow(CharacterFrame)
	module:CreateShadow(_G.EquipmentFlyoutFrameButtons)

	for i = 1, 4 do
		module:ReskinTab(_G["CharacterFrameTab" .. i])
	end

	-- Token
	module:CreateShadow(_G.TokenFramePopup)
	module:CreateShadow(_G.CurrencyTransferLog)
	module:CreateShadow(_G.CurrencyTransferMenu)

	-- Reputation
	module:CreateShadow(_G.ReputationDetailFrame)
	module:CreateShadow(_G.ReputationFrame.ReputationDetailFrame)
	_G.ReputationFrame.ReputationDetailFrame:ClearAllPoints()
	_G.ReputationFrame.ReputationDetailFrame:Point("TOPLEFT", _G.ReputationFrame, "TOPRIGHT", 3, 0)
end

module:AddCallbackForAddon("Blizzard_UIPanels_Game")
