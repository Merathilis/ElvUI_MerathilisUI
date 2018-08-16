local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleIslandsPartyPose()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.IslandsPartyPose ~= true or E.private.muiSkins.blizzard.IslandsPartyPose ~= true then return end

	local IslandsPartyPoseFrame = _G["IslandsPartyPoseFrame"]
	IslandsPartyPoseFrame:Styling()

	IslandsPartyPoseFrame.ModelScene:StripTextures()
	MERS:CreateBDFrame(IslandsPartyPoseFrame.ModelScene, .25)

	IslandsPartyPoseFrame.RewardAnimations.RewardFrame.NameFrame:SetAlpha(0)
	MERS:CreateBDFrame(IslandsPartyPoseFrame.RewardAnimations.RewardFrame.NameFrame, .25)
end

S:AddCallbackForAddon("Blizzard_IslandsPartyPoseUI", "mUIIslandsPartyPose", styleIslandsPartyPose)