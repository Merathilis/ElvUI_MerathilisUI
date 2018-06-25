local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins");

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc

local function styleBFAMissions()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.BFAMissions ~= true or E.private.muiSkins.blizzard.BFAMissions ~= true then return end

	local MissionFrame = _G["BFAMissionFrame"]

	for i, v in ipairs(_G["BFAMissionFrame"].MissionTab.MissionList.listScroll.buttons) do
		local Button = _G["BFAMissionFrameMissionsListScrollFrameButton" .. i]
		if Button and not Button.skinned then
			Button:StripTextures()
			MERS:CreateBD(Button, .25)
			MERS:Reskin(Button, true)
			Button.LocBG:SetAlpha(0)

			Button.isSkinned = true
		end
	end
end

S:AddCallbackForAddon('Blizzard_GarrisonUI', "mUIBFAMissions", styleBFAMissions)
