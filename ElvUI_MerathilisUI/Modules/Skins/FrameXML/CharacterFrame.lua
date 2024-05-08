local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:CharacterFrame()
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

	-- Reputation
	module:CreateShadow(_G.ReputationDetailFrame)
end

module:AddCallback("CharacterFrame")
