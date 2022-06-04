local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.islandQueue ~= true or E.private.mui.skins.blizzard.IslandQueue ~= true then return end

	local IslandsQueueFrame = _G.IslandsQueueFrame
	IslandsQueueFrame:Styling()
	MER:CreateBackdropShadow(IslandsQueueFrame)

	IslandsQueueFrame.HelpButton:Hide()

	IslandsQueueFrame.DifficultySelectorFrame:StripTextures()
	local bg = MERS:CreateBDFrame(IslandsQueueFrame.DifficultySelectorFrame, .65)
	bg:SetPoint("TOPLEFT", 50, -20)
	bg:SetPoint("BOTTOMRIGHT", -50, 5)
end

S:AddCallbackForAddon("Blizzard_IslandsQueueUI", LoadSkin)
