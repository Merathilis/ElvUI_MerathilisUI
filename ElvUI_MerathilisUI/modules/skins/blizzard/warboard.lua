local MER, E, L, V, P, G = unpack(select(2, ...))
-- local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, ContributionRewardMixin, ContributionMixin

local function styleWarboard()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Warboard ~= true or E.private.muiSkins.blizzard.warboard ~= true then return end

	local WarboardQuestChoiceFrame = _G["WarboardQuestChoiceFrame"]
	WarboardQuestChoiceFrame:Styling()
end

S:AddCallbackForAddon("Blizzard_WarboardUI", "mUIWarboard", styleWarboard)