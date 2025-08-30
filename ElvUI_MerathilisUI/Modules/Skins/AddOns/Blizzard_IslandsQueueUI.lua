local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_IslandsQueueUI()
	if not module:CheckDB("islandQueue", "IslandQueue") then
		return
	end

	local IslandsQueueFrame = _G.IslandsQueueFrame
	module:CreateBackdropShadow(IslandsQueueFrame)

	IslandsQueueFrame.HelpButton:Hide()

	IslandsQueueFrame.DifficultySelectorFrame:StripTextures()
	local bg = module:CreateBDFrame(IslandsQueueFrame.DifficultySelectorFrame, 0.65)
	bg:SetPoint("TOPLEFT", 50, -20)
	bg:SetPoint("BOTTOMRIGHT", -50, 5)
end

module:AddCallbackForAddon("Blizzard_IslandsQueueUI")
