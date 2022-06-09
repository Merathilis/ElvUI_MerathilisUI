local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("islandQueue", "IslandQueue") then
		return
	end

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
