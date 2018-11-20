local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local CreateFrame = CreateFrame
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, ContributionRewardMixin, ContributionMixin

local function styleWarboard()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Warboard ~= true or E.private.muiSkins.blizzard.warboard ~= true then return end

	local WarboardQuestChoiceFrame = _G["WarboardQuestChoiceFrame"]
	WarboardQuestChoiceFrame:Styling()

	for i = 1, 4 do
		local option = WarboardQuestChoiceFrame["Option"..i]
		local optionBackdrop = MERS:CreateBDFrame(option)
		optionBackdrop:SetPoint("TOPLEFT", -2, 8)

		option.Header.Ribbon:Hide()
		option.Background:Hide()
		option.Header.Text:SetTextColor(1, 1, 1)
		option.Header.Text.SetTextColor = MER.dummy
		option.OptionText:SetTextColor(1, 1, 1)
		option.OptionText.SetTextColor = MER.dummy
		option.ArtworkBorder:SetAlpha(0)

		option.ArtBackdrop = CreateFrame("Frame", nil, option)
		option.ArtBackdrop:SetFrameLevel(option:GetFrameLevel())
		option.ArtBackdrop:SetPoint("TOPLEFT", option.Artwork, -2, 2)
		option.ArtBackdrop:SetPoint("BOTTOMRIGHT", option.Artwork, 2, -2)
		MERS:CreateBD(option.ArtBackdrop)
	end
end

S:AddCallbackForAddon("Blizzard_WarboardUI", "mUIWarboard", styleWarboard)
