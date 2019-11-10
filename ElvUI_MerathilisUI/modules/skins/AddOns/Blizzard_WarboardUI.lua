local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Warboard ~= true or E.private.muiSkins.blizzard.warboard ~= true then return end

	local WarboardQuestChoiceFrame = _G.WarboardQuestChoiceFrame
	WarboardQuestChoiceFrame:Styling()

	for i = 1, 4 do
		local option = WarboardQuestChoiceFrame["Option"..i]
		if not option.backdrop then
			option:CreateBackdrop("Transparent")
			option.backdrop:SetPoint("TOPLEFT", -2, 15)
			MERS:CreateGradient(option.backdrop)
		end

		option.Header.Ribbon:Hide()
		option.Background:Hide()
		option.Header.Text:SetTextColor(1, 1, 1)
		option.Header.Text.SetTextColor = MER.dummy
		option.OptionText:SetTextColor(1, 1, 1)
		option.OptionText.SetTextColor = MER.dummy
		option.ArtworkBorder:SetAlpha(0)
	end
end

S:AddCallbackForAddon("Blizzard_WarboardUI", "mUIWarboard", LoadSkin)
